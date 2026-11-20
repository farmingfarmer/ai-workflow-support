<#
  run_pr_harness.ps1 — batch precision/recall over the full reference corpus, in-tenant, no GUI.
  For each orig_aNN.txt: call the tenant chat model with the Contract Review Agent's instruction block as the
  system prompt (optionally + the Keck playbook text), save the review to review_aNN.txt, score it against
  gtdiff_aNN.txt, and append one line to scores_all.txt. Then run aggregate_pr.ps1 for the scorecard.

  DATA BOUNDARY: contract text goes only to the tenant's own model endpoint (BAA/DPA-covered). Reviews stay on
  the device. The only exportable artifact is scores_all.txt / the scorecard (numbers, no contract text).

  FAITHFULNESS: this runs the agent's exact instruction block + playbook against each contract. It is a
  reproducible proxy of the production declarative agent (same instructions, same playbook, same model class).
  Cross-check: compare one harness review to the live-agent review of the same doc (e.g. a13) once.

  EXAMPLE (Azure OpenAI):
    .\run_pr_harness.ps1 -Endpoint "https://<res>.openai.azure.com/openai/deployments/<dep>/chat/completions?api-version=2024-02-15-preview" `
       -ApiKey $env:AOAI_KEY -InstrFile .\contract_agent_paste_block.txt -PlaybookFile .\playbook.txt -From 1 -To 56
#>
param(
  [Parameter(Mandatory=$true)][string]$Endpoint,
  [Parameter(Mandatory=$true)][string]$ApiKey,
  [Parameter(Mandatory=$true)][string]$InstrFile,          # agent instruction block (e.g. contract_agent_paste_block.txt)
  [string]$PlaybookFile = "",                               # optional: Keck Contract Negotiation Playbook text
  [string]$WorkDir = "C:\Users\NE1002766\dev\contract_agent\pr_work",
  [int]$From = 1,
  [int]$To   = 56,
  [int]$MaxTokens = 4000,
  [double]$Temperature = 0.1,
  [string]$AuthHeader = "api-key",                          # "api-key" (Azure) or "Authorization" (Bearer/OpenAI)
  [string]$Model = "",                                      # required only for OpenAI-style endpoints
  [int]$SleepMs = 1500
)
. (Join-Path $PSScriptRoot 'pr_topics.ps1')
$instr = Get-Content $InstrFile -Raw
$system = $instr
if ($PlaybookFile -and (Test-Path $PlaybookFile)) {
  $system = $instr + "`n`n===== KECK CONTRACT NEGOTIATION PLAYBOOK (reference) =====`n" + (Get-Content $PlaybookFile -Raw)
}
$scoresPath = Join-Path $WorkDir 'scores_all.txt'
if ($AuthHeader -eq 'Authorization') { $headers = @{ Authorization = "Bearer $ApiKey"; 'Content-Type'='application/json' } }
else { $headers = @{ 'api-key' = $ApiKey; 'Content-Type'='application/json' } }

foreach ($i in $From..$To) {
  $nn = '{0:d2}' -f $i
  $origP = Join-Path $WorkDir "orig_a$nn.txt"
  $gtP   = Join-Path $WorkDir "gtdiff_a$nn.txt"
  if (-not (Test-Path $origP)) { Write-Output "a$nn SKIP (no original)"; continue }
  if (-not (Test-Path $gtP))   { Write-Output "a$nn SKIP (no ground truth)"; continue }
  $contract = Get-Content $origP -Raw
  $user = "Please review this contract.`n`n" + $contract
  $body = @{
    messages = @(
      @{ role='system'; content=$system },
      @{ role='user';   content=$user }
    )
    temperature = $Temperature
    max_tokens  = $MaxTokens
  }
  if ($Model) { $body['model'] = $Model }
  $json = $body | ConvertTo-Json -Depth 6
  $review = $null
  for ($try=1; $try -le 4; $try++) {
    try {
      $resp = Invoke-RestMethod -Uri $Endpoint -Method Post -Headers $headers -Body $json -TimeoutSec 180
      $review = $resp.choices[0].message.content
      break
    } catch {
      $wait = [math]::Min(30, 3 * $try)
      Write-Output ("a$nn retry $try ($($_.Exception.Message.Substring(0,[math]::Min(40,$_.Exception.Message.Length))))")
      Start-Sleep -Seconds $wait
    }
  }
  if (-not $review) { Write-Output "a$nn FAIL (no response)"; continue }
  $review | Out-File (Join-Path $WorkDir "review_a$nn.txt") -Encoding UTF8
  $gt = Get-Content $gtP -Raw
  $sc = Get-TopicRecall -Gt $gt -Review $review
  $line = "a$nn RECALL=$($sc.Recall) MISS=$($sc.Missed -join '|') REVLEN=$($review.Length)"
  Add-Content $scoresPath $line
  Write-Output $line
  Start-Sleep -Milliseconds $SleepMs
}
Write-Output "HARNESS_DONE range=$From-$To -> $scoresPath"
