<#
  final_and_gt_data.ps1   (IN-TENANT) — for the DATA sample (manifest_data.csv).
  Extracts the FINAL (accept-changes) text for each DSA doc, then computes ground-truth TOPICS as the topics
  present in paragraphs that DIFFER between original (orig_d<n>.txt, already extracted) and final. On-device;
  prints only topic counts. Writes gtd_<n>.json ({idx, topics, changed_paras}) and final_d<n>.txt.
#>
param(
  [string]$RefDir  = "C:\Users\NE1002766\dev\contract_agent\reference",
  [string]$WorkDir = "C:\Users\NE1002766\dev\contract_agent\pr_work"
)
$manifest = Import-Csv (Join-Path $WorkDir 'manifest_data.csv')
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
function Paras($t){ @($t -split "[`r`n]+" | ForEach-Object { ($_ -replace '\s+',' ').Trim() } | Where-Object { $_.Length -gt 8 }) }

$word = New-Object -ComObject Word.Application; $word.Visible=$false; $word.DisplayAlerts=0
$summary=@()
foreach ($row in $manifest) {
  $ff = $allFiles | Where-Object { $_.Name -eq $row.file } | Select-Object -First 1
  if (-not $ff) { $summary+='d'+$row.idx+'-NOFILE'; continue }
  $final=''
  try {
    $d=$word.Documents.Open($ff.FullName,$false,$true)
    try { $d.Revisions.AcceptAll() } catch { while($d.Revisions.Count){$d.Revisions.Item(1).Accept()} }
    $final=$d.Content.Text; $d.Close($false)
  } catch {}
  $final | Out-File (Join-Path $WorkDir ("final_d{0}.txt" -f $row.idx)) -Encoding UTF8
  $origPath = Join-Path $WorkDir ("orig_d{0}.txt" -f $row.idx)
  $orig = if (Test-Path $origPath) { Get-Content $origPath -Raw } else { '' }
  $op=Paras $orig; $fp=Paras $final
  $changed = @($op | Where-Object { $fp -notcontains $_ }) + @($fp | Where-Object { $op -notcontains $_ })
  $hay = ($changed -join " `n ").ToLower()
  $topics=@(); foreach($k in $TOPICS.Keys){ if($hay -match $TOPICS[$k]){$topics+=$k} }
  ([pscustomobject]@{ idx=[int]$row.idx; topics=$topics; changed_paras=$changed.Count }) |
    ConvertTo-Json -Compress | Out-File (Join-Path $WorkDir ("gtd_{0}.json" -f $row.idx)) -Encoding UTF8
  $summary+='d'+$row.idx+'-'+$topics.Count+'t/'+$changed.Count+'p'
}
$word.Quit() | Out-Null
($summary -join '_') | Out-File (Join-Path $WorkDir 'gtd_summary.txt') -Encoding ascii
"GTD_DONE " + ($summary -join ' ')
