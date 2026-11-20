<#
  extract_all_gt.ps1  (IN-TENANT) — full-corpus ground-truth extraction for the P/R proof.
  Processes EVERY scoreable redlined reference doc (tracked_changes >= MinChg) in one Word COM pass,
  in a stable sorted-by-filename order, producing a canonical a-series dataset:
     orig_aNN.txt   = reject-all-changes original (what the vendor sent / what the agent reviews)
     final_aNN.txt  = accept-all-changes final    (what our humans negotiated to)
     gtdiff_aNN.txt = changed paragraphs (orig vs final) = the ground-truth answer key
     manifest_all.csv = idx,file,changes,origKB,identical
  Idempotent: skips a doc if its gtdiff already exists unless -Force. On-device only; prints compact counts.
#>
param(
  [string]$Csv     = "C:\Users\NE1002766\dev\contract_agent\groundtruth_sizing.csv",
  [string]$RefDir  = "C:\Users\NE1002766\dev\contract_agent\reference",
  [string]$WorkDir = "C:\Users\NE1002766\dev\contract_agent\pr_work",
  [int]$MinChg     = 5,
  [switch]$Force
)
if (-not (Test-Path $WorkDir)) { New-Item -ItemType Directory -Path $WorkDir | Out-Null }
$allFiles = Get-ChildItem $RefDir -Recurse -File -Filter *.docx
$rows = Import-Csv $Csv | Where-Object { [int]$_.tracked_changes -ge $MinChg } | Sort-Object { $_.file }
$idx = 0
foreach ($r in $rows) { $idx++; $r | Add-Member -NotePropertyName idx -NotePropertyValue $idx -Force }

function Paras($t){ @($t -split "[`r`n]+" | ForEach-Object { ($_ -replace '\s+',' ').Trim() } | Where-Object { $_.Length -gt 8 }) }

$word = New-Object -ComObject Word.Application; $word.Visible=$false; $word.DisplayAlerts=0
$summary=@(); $manifest=@()
foreach ($r in $rows) {
  $nn = '{0:d2}' -f $r.idx
  $gtPath = Join-Path $WorkDir ("gtdiff_a{0}.txt" -f $nn)
  $ff = $allFiles | Where-Object { $_.Name -eq $r.file } | Select-Object -First 1
  if (-not $ff) { $summary += ("a$nn=MISSING"); continue }
  if ((Test-Path $gtPath) -and -not $Force) { $summary += ("a$nn=skip"); $manifest += [pscustomobject]@{idx=$nn;file=$r.file;changes=$r.tracked_changes;origKB='';identical=''}; continue }
  $orig=''; $final=''
  try {
    $d1=$word.Documents.Open($ff.FullName,$false,$true); try{$d1.Revisions.RejectAll()}catch{while($d1.Revisions.Count){$d1.Revisions.Item(1).Reject()}}; $orig=$d1.Content.Text; $d1.Close($false)
    $d2=$word.Documents.Open($ff.FullName,$false,$true); try{$d2.Revisions.AcceptAll()}catch{while($d2.Revisions.Count){$d2.Revisions.Item(1).Accept()}}; $final=$d2.Content.Text; $d2.Close($false)
  } catch { $summary += ("a$nn=ERR"); continue }
  $orig  | Out-File (Join-Path $WorkDir ("orig_a{0}.txt"  -f $nn)) -Encoding UTF8
  $final | Out-File (Join-Path $WorkDir ("final_a{0}.txt" -f $nn)) -Encoding UTF8
  $op=Paras $orig; $fp=Paras $final
  $chg = @($fp | Where-Object { $op -notcontains $_ })
  $identical = ($orig -eq $final)
  $chg | Select-Object -First 40 | Out-File $gtPath -Encoding UTF8
  $kb=[math]::Round((Get-Item (Join-Path $WorkDir ("orig_a{0}.txt" -f $nn))).Length/1KB)
  $summary += ("a$nn=chg"+$chg.Count+"/"+$kb+"KB")
  $manifest += [pscustomobject]@{idx=$nn;file=$r.file;changes=$r.tracked_changes;origKB=$kb;identical=$identical}
}
$word.Quit() | Out-Null
$manifest | Export-Csv (Join-Path $WorkDir 'manifest_all.csv') -NoTypeInformation -Encoding UTF8
"EXTRACT_ALL_DONE count=" + $rows.Count + " :: " + ($summary -join ' ')
