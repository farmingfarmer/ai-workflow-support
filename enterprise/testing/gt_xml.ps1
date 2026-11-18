<#
  gt_xml.ps1   (runs IN-TENANT on the ThinkPad)
  Reliable ground truth via direct OOXML parsing (no Word COM). For each sampled redline, it reads
  word/document.xml, finds every PARAGRAPH that contains a tracked change (<w:ins> or <w:del>), extracts that
  paragraph's full text (so the clause context is included), and topic-scans it. The union of touched topics per
  doc = the material ground truth. Only counts are printed; no content leaves the machine.

  Output: <WorkDir>\gt_<idx>.json  ({ idx, topics, changed_paras })
  Usage:  powershell -ExecutionPolicy Bypass -File gt_xml.ps1
#>
param(
  [string]$RefDir  = "C:\Users\NE1002766\dev\contract_agent\reference",
  [string]$WorkDir = "C:\Users\NE1002766\dev\contract_agent\pr_work"
)
Add-Type -AssemblyName System.IO.Compression.FileSystem
$manifest = Import-Csv (Join-Path $WorkDir 'sample_manifest.csv')
$allFiles = Get-ChildItem $RefDir -Recurse -File | Where-Object { $_.Extension -eq '.docx' }

$TOPICS = [ordered]@{
  indemnity='indemnif|hold harmless'; liability='liabilit|limitation of liability|liability cap'
  payment='payment|invoic|\bfee\b|\bfees\b|net \d'; term_renewal='renewal|auto-renew|automatically renew|\bterm\b'
  termination='terminat'; data_use='\bdata\b|secondary use|model|training|de-identif'
  security='security|safeguard|encrypt|breach|incident'; privacy_phi='phi|hipaa|\bbaa\b|protected health'
  insurance='insurance|coverage|certificate of'; ip_rights='intellectual property|ownership|license grant'
  warranty='warrant|represent'; confidentiality='confidential|non-disclosure|nondisclosure'
  compliance='stark|anti-kickback|kickback|open payments|credential|conflict of interest'
  pci='pci'; sla='service level|\bsla\b|uptime|availability'; scope='scope|deliverable|acceptance criteria|milestone'
  publicity='publicity|use of name|press release'; governing_law='governing law|jurisdiction|dispute'
}

function Doc-Xml($path) {
  $zip=[System.IO.Compression.ZipFile]::OpenRead($path)
  try { $e=$zip.Entries|Where-Object{$_.FullName -eq 'word/document.xml'}; if(-not $e){return ''}
        $sr=New-Object System.IO.StreamReader($e.Open()); $x=$sr.ReadToEnd(); $sr.Close(); return $x }
  finally { $zip.Dispose() }
}

$summary=@()
foreach ($row in $manifest) {
  $ff = $allFiles | Where-Object { $_.Name -eq $row.file } | Select-Object -First 1
  if (-not $ff) { continue }
  $xml = Doc-Xml $ff.FullName
  # split into paragraphs; keep those that contain a tracked change
  $paras = [regex]::Split($xml, '</w:p>')
  $changedText = New-Object System.Text.StringBuilder
  $nchg = 0
  foreach ($p in $paras) {
    if ($p -match '<w:ins ' -or $p -match '<w:del ') {
      $nchg++
      # strip ALL tags from the changed paragraph, keep the raw text (robust across run structure)
      $ptext = [regex]::Replace($p, '<[^>]+>', ' ')
      [void]$changedText.Append($ptext); [void]$changedText.Append("`n")
    }
  }
  $hay = $changedText.ToString().ToLower()
  $topics=@(); foreach($k in $TOPICS.Keys){ if($hay -match $TOPICS[$k]){$topics+=$k} }
  ([pscustomobject]@{ idx=[int]$row.idx; topics=$topics; changed_paras=$nchg }) |
    ConvertTo-Json -Compress | Out-File (Join-Path $WorkDir ("gt_{0}.json" -f $row.idx)) -Encoding UTF8
  $summary += 'i'+$row.idx+'-'+$topics.Count+'t/'+$nchg+'p'
}
($summary -join '_') | Out-File (Join-Path $WorkDir 'gt_summary.txt') -Encoding ascii
"GTXML_DONE " + ($summary -join ' ')
