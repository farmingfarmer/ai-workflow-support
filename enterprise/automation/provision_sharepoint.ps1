<#
  provision_sharepoint.ps1
  Creates the "Contract Review" document library, its folder tree, and columns -- matching
  folder_manifest.json. One command instead of clicking through the SharePoint UI.

  Prereqs (run in-tenant on the ThinkPad):
    Install-Module PnP.PowerShell -Scope CurrentUser        # once
  Run:
    ./provision_sharepoint.ps1 -SiteUrl "https://<tenant>.sharepoint.com/sites/<yoursite>"
  It will open an interactive sign-in. Idempotent -- safe to re-run.
#>
param(
  [Parameter(Mandatory=$true)][string]$SiteUrl,
  [string]$Library = "Contract Review"
)

Connect-PnPOnline -Url $SiteUrl -Interactive

# 1. Library
if (-not (Get-PnPList -Identity $Library -ErrorAction SilentlyContinue)) {
  New-PnPList -Title $Library -Template DocumentLibrary -OnQuickLaunch | Out-Null
  Write-Host "Created library '$Library'."
} else {
  Write-Host "Library '$Library' already exists."
}

# 2. Folders (parents before children)
$folders = @(
  "Inbox",
  "Reviews",
  "Reference",
  "Reference/Originals",
  "Reference/Redlines",
  "Scorecards",
  "Config"
)
foreach ($f in $folders) {
  Resolve-PnPFolder -SiteRelativePath "$Library/$f" | Out-Null
  Write-Host "  folder: $f"
}

# 3. Columns (idempotent; ignore 'already exists')
function Add-Col($params) { try { Add-PnPField -List $Library @params -ErrorAction Stop | Out-Null } catch { Write-Host "  (column exists) $($params.DisplayName)" } }
Add-Col @{ DisplayName="Vendor";     InternalName="Vendor";     Type="Text" }
Add-Col @{ DisplayName="DocType";    InternalName="DocType";    Type="Choice"; Choices=@("MSA","SOW","DSA","BAA","NDA","License","Amendment") }
Add-Col @{ DisplayName="CRStatus";   InternalName="CRStatus";   Type="Choice"; Choices=@("Received","Reviewed","Escalated") }
Add-Col @{ DisplayName="ReviewLink"; InternalName="ReviewLink"; Type="URL" }

Write-Host ""
Write-Host "Done. Library '$Library' provisioned with folders and columns."
Write-Host "Next: upload the classification JSONs to Config/, drop a test contract in Inbox/, and build Flow 1 per sharepoint_automation_standup.md."
