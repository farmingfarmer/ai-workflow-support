<#
  data_sample.ps1   (runs IN-TENANT on the ThinkPad)
  Targeted sample of DATA-SHARING / DSA redlines (the topic-rich contracts where precision/recall is meaningful),
  then extracts each ORIGINAL (reject changes) for the agent to review. On-device; prints counts only.

  Output in WorkDir: orig_d1..dN.txt  and  manifest_data.csv  (idx, file, changes)
  Usage: powershell -ExecutionPolicy Bypass -File data_sample.ps1
#>
param(
  [string]$Csv     = "C:\Users\NE1002766\dev\contract_agent\groundtruth_sizing.csv",
  [string]$RefDir  = "C:\Users\NE1002766\dev\contract_agent\reference",
  [string]$WorkDir = "C:\Users\NE1002766\dev\contract_agent\pr_work",
  [int]$MaxTotal   = 4
)
$rows = Import-Csv $Csv | Where-Object { [int]$_.tracked_changes -ge 5 }
$allFiles = Get-ChildItem $RefDir -Recurse -File | Where-Object { $_.Extension -eq '.docx' }
# data-sharing / security signal in filename (vendor names the team discussed + DSA/data/security terms)
$pat = 'dsa|data security|data sharing|data use|data transfer|\bdata\b|security addendum|trinetx|nference|tempus|avandra|\bbd\b|business associate|\bbaa\b'
$cand = foreach ($r in $rows) {
  $ff = $allFiles | Where-Object { $_.Name -eq $r.file } | Select-Object -First 1
  if ($ff -and ($ff.Name -match $pat)) {
    [pscustomobject]@{ file=$r.file; full=$ff.FullName; changes=[int]$r.tracked_changes }
  }
}
# prefer a moderate change count (substantive but not the 1000+ monsters)
$sel = $cand | Where-Object { $_.changes -le 400 } | Sort-Object { [math]::Abs($_.changes - 60) } | Select-Object -First $MaxTotal
if ($sel.Count -eq 0) { $sel = $cand | Sort-Object changes | Select-Object -First $MaxTotal }
$idx=0; foreach($s in $sel){ $idx++; $s | Add-Member -NotePropertyName idx -NotePropertyValue $idx -Force }

$word = New-Object -ComObject Word.Application; $word.Visible=$false; $word.DisplayAlerts=0
$ok=0
foreach ($s in $sel) {
  try {
    $doc = $word.Documents.Open($s.full, $false, $true)
    try { $doc.Revisions.RejectAll() } catch { while($doc.Revisions.Count){$doc.Revisions.Item(1).Reject()} }
    ($doc.Content.Text) | Out-File (Join-Path $WorkDir ("orig_d{0}.txt" -f $s.idx)) -Encoding UTF8
    $doc.Close($false); $ok++
  } catch {}
}
$word.Quit() | Out-Null
$sel | Select-Object idx, file, changes | Export-Csv (Join-Path $WorkDir 'manifest_data.csv') -NoTypeInformation -Encoding UTF8
"DATA_SAMPLE SELECTED=$($sel.Count) EXTRACTED=$ok" | Out-File (Join-Path $WorkDir 'data_sample_result.txt') -Encoding ascii
"DATA_SAMPLE SELECTED=$($sel.Count) EXTRACTED=$ok"
