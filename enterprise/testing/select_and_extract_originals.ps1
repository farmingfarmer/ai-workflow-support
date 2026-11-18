<#
  select_and_extract_originals.ps1   (runs IN-TENANT on the ThinkPad)
  From the ground-truth sizing CSV, selects a representative sample of redline docs (spanning inferred TYPE and a
  moderate change-count band), then uses Word COM to REJECT all tracked changes and save each ORIGINAL (pre-redline)
  as text -- ready to upload to the Contract Review agent. All content stays on the machine; only counts are printed.

  Output:
    <WorkDir>\orig_<idx>.txt           the reverted originals (upload these to the agent)
    <WorkDir>\sample_manifest.csv      idx, file, type, tracked_changes (for Alex to see which is which)
  Usage:
    powershell -ExecutionPolicy Bypass -File select_and_extract_originals.ps1
#>
param(
  [string]$Csv     = "C:\Users\NE1002766\dev\contract_agent\groundtruth_sizing.csv",
  [string]$RefDir  = "C:\Users\NE1002766\dev\contract_agent\reference",
  [string]$WorkDir = "C:\Users\NE1002766\dev\contract_agent\pr_work",
  [int]$PerType    = 2,
  [int]$MaxTotal   = 7,
  [int]$MinChanges = 3,
  [int]$MaxChanges = 300
)
if (-not (Test-Path $WorkDir)) { New-Item -ItemType Directory -Path $WorkDir | Out-Null }

function Infer-Type($name) {
  switch -regex ($name) {
    'BAA|business associate' { 'BAA'; break }
    'DSA|data security|data sharing|data use' { 'DSA'; break }
    'SOW|statement of work|order form' { 'SOW' ; break }
    'NDA|CDA|confidential|non-disclosure' { 'NDA'; break }
    'MSA|master' { 'MSA'; break }
    'amend|addend' { 'Amendment'; break }
    'license|licence' { 'License'; break }
    default { 'Other' }
  }
}

# map CSV rows back to real files, infer type, keep the moderate band
$rows = Import-Csv $Csv | Where-Object { [int]$_.tracked_changes -ge $MinChanges -and [int]$_.tracked_changes -le $MaxChanges }
$allFiles = Get-ChildItem $RefDir -Recurse -File | Where-Object { $_.Extension -eq '.docx' }
$cand = foreach ($r in $rows) {
  $ff = $allFiles | Where-Object { $_.Name -eq $r.file } | Select-Object -First 1
  if ($ff) { [pscustomobject]@{ file=$r.file; full=$ff.FullName; type=(Infer-Type $r.file); changes=[int]$r.tracked_changes } }
}

# spanning selection: up to PerType per type, closest-to-median change count first, cap MaxTotal
$sel = @()
foreach ($grp in ($cand | Group-Object type)) {
  $med = ($grp.Group | Sort-Object changes | Select-Object -ExpandProperty changes)[[math]::Floor($grp.Count/2)]
  $sel += ($grp.Group | Sort-Object { [math]::Abs($_.changes - $med) } | Select-Object -First $PerType)
}
$sel = $sel | Sort-Object type | Select-Object -First $MaxTotal
$idx = 0; foreach ($s in $sel) { $idx++; $s | Add-Member -NotePropertyName idx -NotePropertyValue $idx -Force }

# Word COM: reject all revisions, save original as text
$word = New-Object -ComObject Word.Application
$word.Visible = $false; $word.DisplayAlerts = 0
$ok = 0
foreach ($s in $sel) {
  try {
    $doc = $word.Documents.Open($s.full, $false, $true)   # confirmConversions=false, readOnly=true
    try { $doc.Revisions.RejectAll() } catch { while ($doc.Revisions.Count -gt 0) { $doc.Revisions.Item(1).Reject() } }
    $out = Join-Path $WorkDir ("orig_{0}.txt" -f $s.idx)
    $doc.SaveAs([ref]$out, [ref]2)   # 2 = wdFormatText
    $doc.Close($false)
    $ok++
  } catch { }
}
$word.Quit() | Out-Null

$sel | Select-Object idx, file, type, changes | Export-Csv (Join-Path $WorkDir 'sample_manifest.csv') -NoTypeInformation -Encoding UTF8
"SELECTED=$($sel.Count) EXTRACTED=$ok TYPES=$((($sel | Group-Object type | ForEach-Object { $_.Name+':'+$_.Count }) -join ',')) WORKDIR=$WorkDir"
