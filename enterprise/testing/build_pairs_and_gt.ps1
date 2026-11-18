<#
  build_pairs_and_gt.ps1   (runs IN-TENANT on the ThinkPad)
  For each sampled redline: produce the ORIGINAL (reject changes) and FINAL (accept changes) full texts via Word,
  then derive the ground-truth TOPICS by paragraph-diffing original vs final and topic-scanning the CHANGED
  paragraphs (keeps clause context the per-revision method lost). No content leaves the machine; prints counts only.

  Output in WorkDir: orig_<idx>.txt, final_<idx>.txt, gt_<idx>.json ({idx, topics, changed_paras})
  Usage: powershell -ExecutionPolicy Bypass -File build_pairs_and_gt.ps1
#>
param(
  [string]$RefDir  = "C:\Users\NE1002766\dev\contract_agent\reference",
  [string]$WorkDir = "C:\Users\NE1002766\dev\contract_agent\pr_work"
)
$manifest = Import-Csv (Join-Path $WorkDir 'sample_manifest.csv')
$allFiles = Get-ChildItem $RefDir -Recurse -File | Where-Object { $_.Extension -eq '.docx' }

$TOPICS = [ordered]@{
  indemnity='indemnif|hold harmless'; liability='liabilit|limitation of liability|liability cap'
  payment='payment|invoic|\bfee\b|\bfees\b|net \d'; term_renewal='renewal|auto-renew|automatically renew|\bterm\b'
  termination='terminat'; data_use='\bdata\b|secondary use|model|training|de-identif'
  security='security|safeguard|encrypt|breach|incident'; privacy_phi='phi|hipaa|\bbaa\b|protected health'
  insurance='insurance|coverage|certificate of'; ip_rights='intellectual property|ownership|license grant'
  warranty='warrant|represent'; confidentiality='confidential|non-disclosure|nondisclosure'
  compliance='stark|anti-kickback|kickback|open payments|credential|conflict of interest'
  pci='pci'; sla='service level|\bsla\b|uptime|availability'; scope='scope|deliverable|acceptance criteria|milestone'
  publicity='publicity|use of name|press release'; governing_law='governing law|jurisdiction|dispute'
}
function Paras($text) { @($text -split "[`r`n]+" | ForEach-Object { $_.Trim() } | Where-Object { $_.Length -gt 3 }) }
function ScanTopics($text) { $h=$text.ToLower(); $t=@(); foreach($k in $TOPICS.Keys){ if($h -match $TOPICS[$k]){$t+=$k} }; ,$t }

$word = New-Object -ComObject Word.Application
$word.Visible=$false; $word.DisplayAlerts=0
$summary=@()
foreach ($row in $manifest) {
  $ff = $allFiles | Where-Object { $_.Name -eq $row.file } | Select-Object -First 1
  if (-not $ff) { continue }
  $orig=''; $final=''
  try {
    $d1=$word.Documents.Open($ff.FullName,$false,$true)
    try { $d1.Revisions.RejectAll() } catch { while($d1.Revisions.Count){$d1.Revisions.Item(1).Reject()} }
    $orig=$d1.Content.Text; $d1.Close($false)
    $d2=$word.Documents.Open($ff.FullName,$false,$true)
    try { $d2.Revisions.AcceptAll() } catch { while($d2.Revisions.Count){$d2.Revisions.Item(1).Accept()} }
    $final=$d2.Content.Text; $d2.Close($false)
  } catch { }
  $orig  | Out-File (Join-Path $WorkDir ("orig_{0}.txt"  -f $row.idx)) -Encoding UTF8
  $final | Out-File (Join-Path $WorkDir ("final_{0}.txt" -f $row.idx)) -Encoding UTF8
  $op=Paras $orig; $fp=Paras $final
  $changed = @($op | Where-Object { $fp -notcontains $_ }) + @($fp | Where-Object { $op -notcontains $_ })
  $topics = ScanTopics ($changed -join " `n ")
  ([pscustomobject]@{ idx=[int]$row.idx; topics=$topics; changed_paras=$changed.Count }) |
    ConvertTo-Json -Compress | Out-File (Join-Path $WorkDir ("gt_{0}.json" -f $row.idx)) -Encoding UTF8
  $summary += "idx$($row.idx):$($topics.Count)t/$($changed.Count)chg"
}
$word.Quit() | Out-Null
"PAIRS_GT_DONE " + ($summary -join ' | ')
