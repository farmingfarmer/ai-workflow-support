<#
  aggregate_pr.ps1 - roll up scores_all.txt into the corpus scorecard.
  De-dupes by doc id (last line per aNN wins), sums covered/total topics, writes scorecard_all.md + .json.
  Output is numbers only (no contract text) - the exportable artifact.
#>
param(
  [string]$WorkDir = "C:\Users\NE1002766\dev\contract_agent\pr_work",
  [double]$Target = 0.80
)
$scoresPath = Join-Path $WorkDir 'scores_all.txt'
if (-not (Test-Path $scoresPath)) { Write-Output "NO scores_all.txt"; exit }
$byDoc = [ordered]@{}
foreach ($ln in Get-Content $scoresPath) {
  if ($ln -match '^(a\d\d)\s+RECALL=(\d+)/(\d+)') {
    $byDoc[$matches[1]] = [pscustomobject]@{ doc=$matches[1]; m=[int]$matches[2]; n=[int]$matches[3]; line=$ln }
  }
}
$rows = @($byDoc.Values | Sort-Object doc)
$sumM = ($rows | Measure-Object m -Sum).Sum
$sumN = ($rows | Measure-Object n -Sum).Sum
$recall = if ($sumN -gt 0) { [math]::Round($sumM / $sumN, 3) } else { 0 }
$metDocs = @($rows | Where-Object { $_.n -gt 0 -and ($_.m / $_.n) -ge $Target }).Count
$perfect = @($rows | Where-Object { $_.n -gt 0 -and $_.m -eq $_.n }).Count
$pct = [math]::Round($recall * 100, 1)

$bar = '|' + '---|' * 3
$lines = New-Object System.Collections.Generic.List[string]
$lines.Add('# Contract Review Agent - corpus precision/recall scorecard')
$lines.Add('')
$lines.Add('Automated topic-recall over the reference corpus (keyword proxy; confirm change-lists with Contracting before publishing).')
$lines.Add('')
$lines.Add('- Documents scored: ' + $rows.Count)
$lines.Add('- Aggregate topic recall: ' + $pct + '% (' + $sumM + '/' + $sumN + ' ground-truth topics)')
$lines.Add('- Documents at or above the ' + [int]($Target*100) + '% bar: ' + $metDocs + ' / ' + $rows.Count)
$lines.Add('- Documents with full topic coverage: ' + $perfect)
$lines.Add('')
$lines.Add('| Doc | Recall | Missed topics |')
$lines.Add($bar)
foreach ($r in $rows) {
  $miss = ''
  if ($r.line -match 'MISS=([^ ]*)') { $miss = ($matches[1] -replace '\|', ', ') }
  $lines.Add('| ' + $r.doc + ' | ' + $r.m + '/' + $r.n + ' | ' + $miss + ' |')
}
($lines -join "`r`n") | Out-File (Join-Path $WorkDir 'scorecard_all.md') -Encoding UTF8

$obj = [pscustomobject]@{
  scored = $rows.Count; aggregate_recall = $recall; covered = $sumM; total = $sumN
  docs_at_target = $metDocs; docs_full_coverage = $perfect; target = $Target
  per_doc = @($rows | ForEach-Object { @{ doc=$_.doc; covered=$_.m; total=$_.n } })
}
$obj | ConvertTo-Json -Depth 5 | Out-File (Join-Path $WorkDir 'scorecard_all.json') -Encoding UTF8
Write-Output ('SCORECARD scored=' + $rows.Count + ' recall=' + $pct + '% covered=' + $sumM + '/' + $sumN + ' atTarget=' + $metDocs + ' full=' + $perfect)
