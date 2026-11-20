<#
  score_file.ps1 <n> — score an already-saved review_aNN.txt against gtdiff_aNN.txt (e.g. a review captured
  manually from the live agent, like a13). Appends to scores_all.txt so it joins the aggregate. Prints 3 lines.
#>
param([int]$n, [string]$WorkDir = "C:\Users\NE1002766\dev\contract_agent\pr_work")
. (Join-Path $PSScriptRoot 'pr_topics.ps1')
$nn = '{0:d2}' -f $n
$revP = Join-Path $WorkDir "review_a$nn.txt"
$gtP  = Join-Path $WorkDir "gtdiff_a$nn.txt"
if (-not (Test-Path $revP)) { Write-Output "NOREVIEW a$nn"; exit }
if (-not (Test-Path $gtP))  { Write-Output "NOGT a$nn"; exit }
$sc = Get-TopicRecall -Gt (Get-Content $gtP -Raw) -Review (Get-Content $revP -Raw)
$line = "a$nn RECALL=$($sc.Recall) MISS=$($sc.Missed -join '|') REVLEN=$((Get-Content $revP -Raw).Length)"
Add-Content (Join-Path $WorkDir 'scores_all.txt') $line
Write-Output $line
Write-Output ("GT: " + ($sc.GTtopics -join ','))
Write-Output ("COV: " + ($sc.Covered -join ','))
