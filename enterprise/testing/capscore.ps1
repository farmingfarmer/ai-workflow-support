<#
  capscore.ps1 <n> : after the agent review is on the clipboard (Ctrl+A/Ctrl+C on the page),
  slice out the review -> review_aNN.txt, then compute a keyword-based topic recall vs gtdiff_aNN.txt.
  Prints 3 short lines (OCR-safe in a half-width pane). Appends one line to scores_all.txt.
  Topic recall is an automated proxy: a topic is a GROUND-TRUTH topic if its keyword appears in the human
  redline diff, and COVERED if it also appears in the agent review. Coarser than human judgment; for an
  auditable first-pass number across the whole corpus. Spot-check against the saved review_aNN.txt.
#>
param([int]$n)
$nn = '{0:d2}' -f $n
$wd = "C:\Users\NE1002766\dev\contract_agent\pr_work"
$a = Get-Clipboard -Raw
if (-not $a) { Write-Output "NOCLIP a$nn"; exit }
$s = $a.IndexOf('PRE-REVIEW'); $e = $a.IndexOf('generated content may')
if ($s -ge 0 -and $e -gt $s) { $r = $a.Substring($s, $e - $s) } else { $r = $a }
$r | Out-File "$wd\review_a$nn.txt" -Encoding UTF8
$gtPath = "$wd\gtdiff_a$nn.txt"
if (-not (Test-Path $gtPath)) { Write-Output "NOGT a$nn REVLEN=$($r.Length)"; exit }
$gt = Get-Content $gtPath -Raw
$topics = [ordered]@{
  payment      = 'payment|fee\b|fees|rate|invoic|pricing|price|discount|\bNTE\b|not-to-exceed'
  term         = 'end date|expir|effective date|renew|auto-renew|extend the|term of'
  termination  = 'terminat|cancel'
  indemnity    = 'indemnif|indemnit|hold harmless'
  liability    = 'liabilit|limitation of'
  privacy_phi  = 'PHI|HIPAA|privacy|de-identif|protected health'
  data_use     = 'secondary use|AI training|use of data|data use|training on|reuse'
  ip_license   = 'intellectual property|ownership|licens'
  warranty     = 'warrant'
  security     = 'security|safeguard|encrypt|breach|incident'
  confidential = 'confidential|non-disclosure'
  insurance    = 'insurance|coverage|E&O|cyber'
  scope        = 'scope|deliverable|resource|staffing|milestone|statement of work|personnel'
  sla          = 'service level|uptime|availability|maintenance| SLA'
  compliance   = 'complian|Stark|Open Payments|FCPA|regulat'
  precedence   = 'precedence|order of|controll|conflict|defer|governing agreement'
}
$gtset = @(); $cov = @()
foreach ($k in $topics.Keys) {
  if ($gt -match $topics[$k]) { $gtset += $k; if ($r -match $topics[$k]) { $cov += $k } }
}
$miss = @($gtset | Where-Object { $cov -notcontains $_ })
$line = "a$nn RECALL=$($cov.Count)/$($gtset.Count) REVLEN=$($r.Length)"
Add-Content "$wd\scores_all.txt" $line
Write-Output $line
Write-Output ("GT: " + ($gtset -join ','))
Write-Output ("MISS: " + ($miss -join ','))
