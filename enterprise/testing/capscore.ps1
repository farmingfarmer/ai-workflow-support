<#
  capscore.ps1 <n> : after the agent review is on the clipboard (Ctrl+A/Ctrl+C on the page),
  slice the CURRENT (last) review -> review_aNN.txt, then keyword topic-recall vs gtdiff_aNN.txt.
  Grabs the LAST PRE-REVIEW block so it is robust to any accumulated page/DOM content. Prints REVIEWS=
  (count of reviews seen in the capture) as a contamination signal. Appends one line to scores_all.txt.
#>
param([int]$n)
$nn = '{0:d2}' -f $n
$wd = "C:\Users\NE1002766\dev\contract_agent\pr_work"
$a = Get-Clipboard -Raw
if (-not $a) { Write-Output "NOCLIP a$nn"; exit }
$revCount = ([regex]::Matches($a, 'Reasoned for')).Count
$s = $a.LastIndexOf('PRE-REVIEW')
$e = if ($s -ge 0) { $a.IndexOf('generated content may', $s) } else { -1 }
# use the footer as endpoint only if it's far enough to bracket a real review; else take to end
if ($s -ge 0 -and $e -gt ($s + 3000)) { $r = $a.Substring($s, $e - $s) }
elseif ($s -ge 0) { $r = $a.Substring($s) } else { $r = $a }
$r | Out-File "$wd\review_a$nn.txt" -Encoding UTF8
$gtPath = "$wd\gtdiff_a$nn.txt"
if (-not (Test-Path $gtPath)) { Write-Output "NOGT a$nn REVLEN=$($r.Length)"; exit }
$gt = Get-Content $gtPath -Raw
$topics = [ordered]@{
  payment='payment|fee\b|fees|rate|invoic|pricing|price|discount|\bNTE\b|not-to-exceed|royalt'
  term='end date|expir|effective date|renew|auto-renew|extend the|term of|duration'
  termination='terminat|cancel'; indemnity='indemnif|indemnit|hold harmless'
  liability='liabilit|limitation of'; privacy_phi='PHI|HIPAA|privacy|de-identif|protected health'
  data_use='secondary use|AI training|use of data|data use|training on|reuse'
  ip_license='intellectual property|ownership|licens'; warranty='warrant'
  security='security|safeguard|encrypt|breach|incident'; confidential='confidential|non-disclosure'
  insurance='insurance|coverage|E&O|cyber'
  scope='scope|deliverable|resource|staffing|milestone|statement of work|personnel'
  sla='service level|uptime|availability|maintenance| SLA'
  compliance='complian|Stark|Open Payments|FCPA|regulat'
  precedence='precedence|order of|controll|conflict|defer|governing agreement'
}
$gtset=@(); $cov=@()
foreach ($k in $topics.Keys) { if ($gt -match $topics[$k]) { $gtset += $k; if ($r -match $topics[$k]) { $cov += $k } } }
$miss = @($gtset | Where-Object { $cov -notcontains $_ })
$line = "a$nn RECALL=$($cov.Count)/$($gtset.Count) REVLEN=$($r.Length) REVIEWS=$revCount"
Add-Content "$wd\scores_all.txt" $line
Write-Output $line
Write-Output ("MISS: " + ($miss -join ','))
