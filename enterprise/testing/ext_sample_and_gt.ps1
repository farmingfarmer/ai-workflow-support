<#
  ext_sample_and_gt.ps1   (IN-TENANT) — extended sample for the P/R proof.
  Picks diverse NEW contract types from the reference set (MSA, SaaS, inbound license, AI-governance),
  excluding the docs already tested (Eon SOW, Tempus DSAs, TriNetX/nference BAAs). For each it uses Word COM to
  produce the ORIGINAL (reject changes) and FINAL (accept changes), and the ground-truth changed paragraphs
  (orig-vs-final diff). On-device; prints only counts + filenames.
  Output in WorkDir: orig_e<n>.txt, final_e<n>.txt, gtdiff_e<n>.txt, manifest_ext.csv
#>
param(
  [string]$Csv     = "C:\Users\NE1002766\dev\contract_agent\groundtruth_sizing.csv",
  [string]$RefDir  = "C:\Users\NE1002766\dev\contract_agent\reference",
  [string]$WorkDir = "C:\Users\NE1002766\dev\contract_agent\pr_work"
)
$allFiles = Get-ChildItem $RefDir -Recurse -File | Where-Object { $_.Extension -eq '.docx' }
$rows = Import-Csv $Csv | Where-Object { [int]$_.tracked_changes -ge 5 -and [int]$_.tracked_changes -le 500 }

# one representative per category, by filename; skip already-tested vendors
$exclude = 'eon|tempus|trinetx|nference'
$cats = [ordered]@{
  MSA          = 'master services|\bMSA\b'
  SaaS         = 'saas|software as a service|software agreement'
  InboundLicense = 'inbound|license|licence|avandra'
  Governance   = 'governance|mlops|ai gover'
  Services     = 'soarian|atwater|services agreement'
}
# selection: match CSV rows to files, filter by category pattern, exclude done vendors
$cand = foreach ($r in $rows) {
  $ff = $allFiles | Where-Object { $_.Name -eq $r.file } | Select-Object -First 1
  if ($ff -and ($ff.Name -notmatch $exclude)) {
    $catName = $null
    foreach ($c in $cats.Keys) { if ($ff.Name -match $cats[$c]) { $catName = $c; break } }
    if ($catName) { [pscustomobject]@{ file=$r.file; full=$ff.FullName; cat=$catName; changes=[int]$r.tracked_changes } }
  }
}
$sel = foreach ($grp in ($cand | Group-Object cat)) {
  $grp.Group | Sort-Object { [math]::Abs($_.changes - 80) } | Select-Object -First 1
}
$sel = $sel | Select-Object -First 5
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
  $orig  | Out-File (Join-Path $WorkDir ("orig_e{0}.txt"  -f $s.idx)) -Encoding UTF8
  $final | Out-File (Join-Path $WorkDir ("final_e{0}.txt" -f $s.idx)) -Encoding UTF8
  $op=Paras $orig; $fp=Paras $final
  $chg = @($fp | Where-Object { $op -notcontains $_ })
  $chg | Select-Object -First 30 | Out-File (Join-Path $WorkDir ("gtdiff_e{0}.txt" -f $s.idx)) -Encoding UTF8
  $summary += ('e'+$s.idx+'['+$s.cat+']chg='+$chg.Count)
}
$word.Quit() | Out-Null
$sel | Select-Object idx, cat, file, changes | Export-Csv (Join-Path $WorkDir 'manifest_ext.csv') -NoTypeInformation -Encoding UTF8
"EXT_DONE " + ($summary -join ' ')
