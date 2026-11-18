<#
  gt_extract_topics.ps1   (runs IN-TENANT on the ThinkPad)
  For each sample redline (from sample_manifest.csv), reads the HUMAN tracked changes via Word COM and tags the
  TOPICS those changes touched (indemnity, liability, data-use, etc.). The set of touched topics per doc is the
  ground truth = what the human reviewers materially changed. Topic-level scoring avoids fragile clause-number
  alignment across varied contracts. No content leaves the machine; only topic COUNTS are printed.

  Output: <WorkDir>\gt_<idx>.json  ({ idx, topics:[...], revisions_scanned })
  Usage:  powershell -ExecutionPolicy Bypass -File gt_extract_topics.ps1
#>
param(
  [string]$RefDir  = "C:\Users\NE1002766\dev\contract_agent\reference",
  [string]$WorkDir = "C:\Users\NE1002766\dev\contract_agent\pr_work"
)
$manifest = Import-Csv (Join-Path $WorkDir 'sample_manifest.csv')
$allFiles = Get-ChildItem $RefDir -Recurse -File | Where-Object { $_.Extension -eq '.docx' }

# topic -> keyword regex (lowercase)
$TOPICS = [ordered]@{
  indemnity      = 'indemnif|hold harmless'
  liability      = 'liabilit|limitation of liability|liability cap'
  payment        = 'payment|invoic|\bfee\b|\bfees\b|net \d'
  term_renewal   = 'renewal|auto-renew|automatically renew|\bterm\b'
  termination    = 'terminat'
  data_use       = 'data|secondary use|model|training|de-identif'
  security       = 'security|safeguard|encrypt|breach|incident'
  privacy_phi    = 'phi|hipaa|\bbaa\b|protected health'
  insurance      = 'insurance|coverage|certificate of'
  ip_rights      = 'intellectual property|ownership|license grant|\bip\b'
  warranty       = 'warrant|represent'
  confidentiality= 'confidential|non-disclosure|nondisclosure'
  compliance     = 'stark|anti-kickback|kickback|open payments|credential|conflict of interest'
  pci            = 'pci'
  sla            = 'service level|\bsla\b|uptime|availability'
  scope          = 'scope|deliverable|acceptance criteria|milestone'
  publicity      = 'publicity|use of name|press release'
  governing_law  = 'governing law|jurisdiction|dispute'
}

$word = New-Object -ComObject Word.Application
$word.Visible = $false; $word.DisplayAlerts = 0
$summary = @()
foreach ($row in $manifest) {
  $ff = $allFiles | Where-Object { $_.Name -eq $row.file } | Select-Object -First 1
  if (-not $ff) { continue }
  $found = [ordered]@{}; $scanned = 0
  try {
    $doc = $word.Documents.Open($ff.FullName, $false, $true)
    foreach ($rev in $doc.Revisions) {
      $scanned++
      $t = ''; $ctx = ''
      try { $t = $rev.Range.Text } catch {}
      try { $ctx = $rev.Range.Paragraphs.Item(1).Range.Text } catch {}
      $hay = ("$t $ctx").ToLower()
      foreach ($k in $TOPICS.Keys) { if ($hay -match $TOPICS[$k]) { $found[$k] = $true } }
    }
    $doc.Close($false)
  } catch { }
  $topics = @($found.Keys)
  $obj = [pscustomobject]@{ idx = [int]$row.idx; topics = $topics; revisions_scanned = $scanned }
  $obj | ConvertTo-Json -Compress | Out-File (Join-Path $WorkDir ("gt_{0}.json" -f $row.idx)) -Encoding UTF8
  $summary += "idx$($row.idx):$($topics.Count)topics/$scanned revs"
}
$word.Quit() | Out-Null
"GT_DONE " + ($summary -join ' | ')
