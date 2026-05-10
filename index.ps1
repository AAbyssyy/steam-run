[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$AllowKey = "AB6HA-ZGBTZ-W6GM5-AC544-AC544"
$GameAppID = "1551360"

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator!" -ForegroundColor Red
    pause
    exit
}

Clear-Host
Write-Host "===== Forza Horizon 5 Activator =====" -ForegroundColor Cyan
$inputKey = Read-Host "Enter your license key"

if ($inputKey -ne $AllowKey) {
    Write-Host "Invalid Key!" -ForegroundColor Red
    pause
    exit
}

Write-Host "Key Valid. Searching Steam..." -ForegroundColor Green

$steamPath = $null
$paths = @(
    "D:\Steam",
    "C:\Program Files (x86)\Steam",
    "E:\Steam",
    "F:\Steam",
    "C:\Steam"
)

foreach ($p in $paths) {
    if (Test-Path "$p\Steam.exe") {
        $steamPath = $p
        break
    }
}

if (-not $steamPath) {
    Write-Host "Steam Not Found!" -ForegroundColor Red
    pause
    exit
}

Write-Host "Steam Found: $steamPath"

$steamapps = Join-Path $steamPath "steamapps"

$manifestPath = Join-Path $steamapps "appmanifest_$GameAppID.acf"
$manifestContent = @"
"AppState"
{
"appid" "$GameAppID"
"Universe" "1"
"StateFlags" "6"
"InstallLocation" "Forza Horizon 5"
"IsInstalled" "1"
}
"@
$manifestContent | Out-File $manifestPath -Encoding ASCII -Force

$packagePath = Join-Path $steamapps "packageinfo_$GameAppID.acf"
$packageContent = @"
"PackageState"
{
"appid" "$GameAppID"
"StateFlags" "6"
"IsOwned" "1"
"IsLicensed" "1"
}
"@
$packageContent | Out-File $packagePath -Encoding ASCII -Force

Write-Host "Success! Game activated." -ForegroundColor Green
Write-Host "Restart Steam fully, then install."
pause
