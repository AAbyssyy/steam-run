[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$AllowKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$GameAppID = 1551360

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
    "C:\Program Files (x86)\Steam",
    "D:\Steam", "E:\Steam", "F:\Steam", "C:\Steam"
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

# 关键：写 appmanifest + 写 packageinfo（授权）
$steamapps = Join-Path $steamPath "steamapps"
$manifestPath = Join-Path $steamapps "appmanifest_$GameAppID.acf"

$manifest = @"
"AppState"
{
    "appid" "$GameAppID"
    "Universe" "1"
    "StateFlags" "4"
    "InstallLocation" "Forza Horizon 5"
    "SizeOnDisk" "0"
    "BuildID" "0"
    "LastUpdated" "0"
    "LastPlayed" "0"
    "IsInstalled" "1"
    "IsUpdating" "0"
    "IsDownloading" "0"
    "State" "4"
}
"@

$manifest | Out-File $manifestPath -Encoding ASCII -Force

# 写入本地授权记录（关键，解决“购买”按钮）
$packagePath = Join-Path $steamapps "packageinfo_$GameAppID.acf"
$package = @"
"PackageState"
{
    "appid" "$GameAppID"
    "packageid" "0"
    "Universe" "1"
    "StateFlags" "4"
    "IsOwned" "1"
}
"@

$package | Out-File $packagePath -Encoding ASCII -Force

Write-Host "`n✅ Success! Game added with license." -ForegroundColor Green
Write-Host "Restart Steam to install Forza Horizon 5."
pause
