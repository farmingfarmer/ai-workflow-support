<#
  extract_redline_groundtruth.ps1
  Runs IN-TENANT on the ThinkPad. For every redline .docx in the reference directory, it reads the tracked
  changes (OOXML w:ins / w:del / comments) WITHOUT sending any content off the machine, and writes a per-document
  ground-truth sizing CSV locally. Only aggregate NUMBERS are meant to be read back from this session.

  Tracked changes = what the human reviewers decided to fix = the gold-standard "expected findings" (recall
  denominator). This does not run the agent; it sizes the ground truth for the whole corpus.

  Usage:
    powershell -ExecutionPolicy Bypass -File extract_redline_groundtruth.ps1 `
      -RefDir "C:\Users\NE1002766\dev\contract_agent\reference" `
      -OutCsv "C:\Users\NE1002766\dev\contract_agent\groundtruth_sizing.csv"
#>
param(
  [string]$RefDir = "C:\Users\NE1002766\dev\contract_agent\reference",
  [string]$OutCsv = "C:\Users\NE1002766\dev\contract_agent\groundtruth_sizing.csv"
)
Add-Type -AssemblyName System.IO.Compression.FileSystem

function Get-Changes($path) {
  $ins = 0; $del = 0; $com = 0
  try {
    $zip = [System.IO.Compression.ZipFile]::OpenRead($path)
    try {
      $entry = $zip.Entries | Where-Object { $_.FullName -eq 'word/document.xml' }
      if ($entry) {
        $sr = New-Object System.IO.StreamReader($entry.Open())
        $xml = $sr.ReadToEnd(); $sr.Close()
        $ins = ([regex]::Matches($xml, '<w:ins ')).Count
        $del = ([regex]::Matches($xml, '<w:del ')).Count
      }
      $centry = $zip.Entries | Where-Object { $_.FullName -eq 'word/comments.xml' }
      if ($centry) {
        $sr2 = New-Object System.IO.StreamReader($centry.Open())
        $cxml = $sr2.ReadToEnd(); $sr2.Close()
        $com = ([regex]::Matches($cxml, '<w:comment ')).Count
      }
    } finally { $zip.Dispose() }
  } catch { }
  [pscustomobject]@{ ins = $ins; del = $del; com = $com }
}

# Process ALL .docx; the actual tracked-change count (not the filename) decides which are redlines.
$files = Get-ChildItem $RefDir -Recurse -File | Where-Object { $_.Extension -eq '.docx' }

$rows = @(); $i = 0
foreach ($f in $files) {
  $i++
  $c = Get-Changes $f.FullName
  $total = $c.ins + $c.del
  $rows += [pscustomobject]@{
    idx = $i; file = $f.Name; ins = $c.ins; del = $c.del; comments = $c.com;
    tracked_changes = $total; has_changes = [int]($total -gt 0)
  }
}
$rows | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8

# aggregate (numbers only; safe to read back)
$withChg = $rows | Where-Object { $_.has_changes -eq 1 }
$tc = ($rows | Measure-Object tracked_changes -Sum).Sum
$sorted = ($withChg | Sort-Object tracked_changes | Select-Object -ExpandProperty tracked_changes)
$median = if ($sorted.Count) { $sorted[[math]::Floor($sorted.Count/2)] } else { 0 }
"DOCX=$($rows.Count) WITH_TRACKED_CHANGES=$($withChg.Count) TOTAL_CHANGES=$tc MEDIAN_PER_DOC=$median MAX=$(($rows | Measure-Object tracked_changes -Maximum).Maximum) CSV=$OutCsv"
