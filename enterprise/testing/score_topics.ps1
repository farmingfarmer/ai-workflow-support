<#
  score_topics.ps1   (runs IN-TENANT on the ThinkPad)
  Topic-level precision/recall for the sample. For each idx it reads two agent-produced text files from WorkDir:
     review_<idx>.txt   = the agent's review of the ORIGINAL (reject-changes) document   -> AGENT findings
     redline_<idx>.txt  = the agent's REDLINE ANALYSIS of the human redline              -> GROUND TRUTH (what humans changed)
  It tags each with the topic set (same keyword map as gt_extract), then:
     recall    = |GT topics the agent also flagged| / |GT topics|
     precision = |GT topics the agent flagged| / |agent topics|       (extras count against precision; review them)
  Only NUMBERS are printed; the contract text stays on the machine.

  Usage: powershell -ExecutionPolicy Bypass -File score_topics.ps1
#>
param([string]$WorkDir = "C:\Users\NE1002766\dev\contract_agent\pr_work")

$TOPICS = [ordered]@{
  indemnity='indemnif|hold harmless'; liability='liabilit|limitation of liability|liability cap'
  payment='payment|invoic|\bfee\b|\bfees\b|net \d'; term_renewal='renewal|auto-renew|automatically renew|\bterm\b'
  termination='terminat'; data_use='data|secondary use|model|training|de-identif'
  security='security|safeguard|encrypt|breach|incident'; privacy_phi='phi|hipaa|\bbaa\b|protected health'
  insurance='insurance|coverage|certificate of'; ip_rights='intellectual property|ownership|license grant'
  warranty='warrant|represent'; confidentiality='confidential|non-disclosure|nondisclosure'
  compliance='stark|anti-kickback|kickback|open payments|credential|conflict of interest'
  pci='pci'; sla='service level|\bsla\b|uptime|availability'; scope='scope|deliverable|acceptance criteria|milestone'
  publicity='publicity|use of name|press release'; governing_law='governing law|jurisdiction|dispute'
}
function Topics($path) {
  if (-not (Test-Path $path)) { return $null }
  $hay = (Get-Content $path -Raw).ToLower()
  $t = @(); foreach ($k in $TOPICS.Keys) { if ($hay -match $TOPICS[$k]) { $t += $k } }
  ,$t
}

$rows = @(); $aggHit=0; $aggGT=0; $aggAgent=0
Get-ChildItem $WorkDir -Filter 'redline_*.txt' | ForEach-Object {
  $idx = ($_.BaseName -replace 'redline_','')
  $gt = Topics $_.FullName
  $ag = Topics (Join-Path $WorkDir "review_$idx.txt")
  if ($gt -eq $null -or $ag -eq $null) { return }
  $hit = @($gt | Where-Object { $ag -contains $_ })
  $recall    = if ($gt.Count)  { [math]::Round($hit.Count / $gt.Count, 2) }  else { 1 }
  $precision = if ($ag.Count)  { [math]::Round($hit.Count / $ag.Count, 2) }  else { 1 }
  $missed = @($gt | Where-Object { $ag -notcontains $_ })
  $rows += [pscustomobject]@{ idx=$idx; gt=$gt.Count; agent=$ag.Count; caught=$hit.Count; recall=$recall; precision=$precision; missed_topics=($missed -join '/') }
  $aggHit += $hit.Count; $aggGT += $gt.Count; $aggAgent += $ag.Count
}
$rows | Format-Table -AutoSize | Out-String | Write-Output
$R = if ($aggGT) { [math]::Round($aggHit/$aggGT,3) } else { 1 }
$P = if ($aggAgent) { [math]::Round($aggHit/$aggAgent,3) } else { 1 }
"AGGREGATE DOCS=$($rows.Count) RECALL=$R PRECISION=$P  (target >= 0.80 each)"
$rows | Export-Csv (Join-Path $WorkDir 'pr_scorecard.csv') -NoTypeInformation -Encoding UTF8
