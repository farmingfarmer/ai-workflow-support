<# stage.ps1 <n> : load orig_aNN.txt onto the clipboard with a review prompt, for pasting into the agent. #>
param([int]$n)
$nn = '{0:d2}' -f $n
$f = "C:\Users\NE1002766\dev\contract_agent\pr_work\orig_a$nn.txt"
if (-not (Test-Path $f)) { Write-Output "NOFILE a$nn"; exit }
$t = Get-Content $f -Raw
Set-Clipboard -Value ("Please review this contract." + [Environment]::NewLine + [Environment]::NewLine + $t)
Write-Output ("STAGED a$nn CHARS=" + ((Get-Clipboard -Raw).Length))
