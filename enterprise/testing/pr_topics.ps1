<#
  pr_topics.ps1  — shared topic taxonomy + scorer. Dot-source it:  . .\pr_topics.ps1
  Get-TopicRecall -Gt <groundtruth text> -Review <agent review text> returns:
    @{ GTtopics=@(...); Covered=@(...); Missed=@(...); Recall="m/n"; N=<int>; M=<int> }
  A topic counts as a GROUND-TRUTH topic if its keyword appears in the human redline diff, and COVERED if it
  also appears in the agent review. Keyword proxy — coarser than human judgement, but consistent and auditable.
#>
$script:PrTopics = [ordered]@{
  payment      = 'payment|fee\b|fees|rate|invoic|pricing|price|discount|\bNTE\b|not-to-exceed|royalt'
  term         = 'end date|expir|effective date|renew|auto-renew|extend the|term of|duration'
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

function Get-TopicRecall {
  param([string]$Gt, [string]$Review)
  $gtset = @(); $cov = @()
  foreach ($k in $script:PrTopics.Keys) {
    if ($Gt -match $script:PrTopics[$k]) {
      $gtset += $k
      if ($Review -match $script:PrTopics[$k]) { $cov += $k }
    }
  }
  $miss = @($gtset | Where-Object { $cov -notcontains $_ })
  [pscustomobject]@{
    GTtopics = $gtset; Covered = $cov; Missed = $miss
    N = $gtset.Count; M = $cov.Count
    Recall = ("{0}/{1}" -f $cov.Count, $gtset.Count)
  }
}
