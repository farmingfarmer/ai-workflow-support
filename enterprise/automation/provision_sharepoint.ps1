<#
  provision_sharepoint.ps1
  Creates the "Contract Review" document library, its folder tree, and columns -- matching
  folder_manifest.json. One command instead of clicking through the SharePoint UI.

  Prereqs (run in-tenant on the ThinkPad):
    # The module. MIND THE POWERSHELL VERSION: this ThinkPad runs Windows PowerShell 5.1 (no PS7),
    # and modern PnP.PowerShell (2.x) requires PS7.2+. So install the last PS5.1-compatible version:
    Install-Module PnP.PowerShell -RequiredVersion 1.12.0 -Scope CurrentUser   # DONE on the ThinkPad Nov 25 2026
    # (If PS7 gets installed later, you can move to the current 2.x PnP instead.)
  Run:
    ./provision_sharepoint.ps1 -SiteUrl "https://<tenant>.sharepoint.com/sites/<yoursite>"
  It will open an interactive sign-in. Idempotent -- safe to re-run.

  AUTH NOTE: Connect-PnPOnline -Interactive uses the multi-tenant "PnP Management Shell" app by default.
  Many tenants DISABLE that app or require admin consent, in which case -Interactive fails. If so, either
  (a) have an admin consent the PnP Management Shell app (Register-PnPManagementShellAccess), (b) pass a
  -ClientId of a registered Entra app, or (c) skip PnP entirely and create the library + folders + columns
  by hand in the SharePoint UI (see folder_manifest.json for the exact structure). Provisioning is a one-time,
  5-minute step either way; the real build is Flow 1.
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
