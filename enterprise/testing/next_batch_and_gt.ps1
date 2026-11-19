<#
  next_batch_and_gt.ps1   (IN-TENANT) — next batch for the P/R proof (f-series).
  Picks up to 5 NEW reference redlines, excluding every vendor already tested (Eon, Tempus, TriNetX, nference-if-done,
  Meditology, Atwater, Hakkoda), preferring new vendors/types (Avandra inbound license, nference, BD, Deloitte,
  Soarian, Across). For each: Word COM reject->orig, accept->final, and orig-vs-final changed paragraphs (GT).
  On-device; prints only counts + filenames. Output: orig_f<n>.txt, final_f<n>.txt, gtdiff_f<n>.txt, manifest_f.csv
#>
param(
  [string]$Csv     = "C:\Users\NE1002766\dev\contract_agent\groundtruth_sizing.csv",
  [string]$RefDir  = "C:\Users\NE1002766\dev\contract_agent\reference",
  [string]$WorkDir = "C:\Users\NE1002766\dev\contract_agent\pr_work",
  [int]$MaxTotal   = 5
)
$allFiles = Get-ChildItem $RefDir -Recurse -File | Where-Object { $_.Extension -eq '.docx' }
$rows = Import-Csv $Csv | Where-Object { [int]$_.tracked_changes -ge 5 -and [int]$_.tracked_changes -le 500 }
$doneVendors = 'eon|tempus|trinetx|meditology|atwater|hakkoda'
# prefer these new vendors/types, one each, for diversity
$prefer = @('avandra','nference','\bbd\b','deloitte','soarian','across','inbound','mlops')

$cand = foreach ($r in $rows) {
  $ff = $allFiles | Where-Object { $_.Name -eq $r.file } | Select-Object -First 1
  if ($ff -and ($ff.Name -notmatch $doneVendors)) {
    $rank = 99; for ($i=0; $i -lt $prefer.Count; $i++) { if ($ff.Name -match $prefer[$i]) { $rank = $i; break } }
    [pscustomobject]@{ file=$r.file; full=$ff.FullName; changes=[int]$r.tracked_changes; rank=$rank }
  }
}
# one per preferred vendor pattern first (dedup by rank), then fill
$sel = @()
$usedRank = @{}
foreach ($c in ($cand | Sort-Object rank, { [math]::Abs($_.changes - 80) })) {
  if ($sel.Count -ge $MaxTotal) { break }
  if ($c.rank -lt 99 -and $usedRank.ContainsKey($c.rank)) { continue }
  $sel += $c; if ($c.rank -lt 99) { $usedRank[$c.rank] = $true }
}
$idx=0; foreach($s in $sel){ $idx++; $s | Add-Member -NotePropertyName idx -NotePropertyValue $idx -Force }

function Paras($t){ @($t -split "[`r`n]+" | ForEach-Object { ($_ -replace '\s+',' ').Trim() } | Where-Object { $_.Length -gt 8 }) }
$word = New-Object -ComObject Word.Application; $word.Visible=$false; $word.DisplayAlerts=0
$summary=@()
foreach ($s in $sel) {
  $orig=''; $final=''
  try {
    $d1=$word.Documents.Open($s.full,$false,$true); try{$d1.Revisions.RejectAll()}catch{while($d1.Revisions.Count){$d1.Revisions.Item(1).Reject()}}; $orig=$d1.Content.Text; $d1.Close($false)
    $d2=$word.Documents.Open($s.full,$false,$true); try{$d2.Revisions.AcceptAll()}catch{while($d2.Revisions.Count){$d2.Revisions.Item(1).Accept()}}; $final=$d2.Content.Text; $d2.Close($false)
  } catch {}
  $orig  | Out-File (Join-Path $WorkDir ("orig_f{0}.txt"  -f $s.idx)) -Encoding UTF8
  $final | Out-File (Join-Path $WorkDir ("final_f{0}.txt" -f $s.idx)) -Encoding UTF8
  $op=Paras $orig; $fp=Paras $final
  $chg = @($fp | Where-Object { $op -notcontains $_ })
  $chg | Select-Object -First 30 | Out-File (Join-Path $WorkDir ("gtdiff_f{0}.txt" -f $s.idx)) -Encoding UTF8
  $kb=[math]::Round((Get-Item (Join-Path $WorkDir ("orig_f{0}.txt" -f $s.idx))).Length/1KB)
  $summary += ('f'+$s.idx+'=chg'+$chg.Count+'/'+$kb+'KB')
}
$word.Quit() | Out-Null
$sel | Select-Object idx, file, changes | Export-Csv (Join-Path $WorkDir 'manifest_f.csv') -NoTypeInformation -Encoding UTF8
"NEXTBATCH_DONE " + ($summary -join ' ')
