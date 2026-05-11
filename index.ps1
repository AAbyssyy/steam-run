chcp 65001 | Out-Null
$ErrorActionPreference = 'SilentlyContinue'

# 配置
$key = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$appid = "1174180"
$name = "Red Dead Redemption 2"
$installdir = "Red Dead Redemption 2"

# 管理员
$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) {
    Write-Host "Please run as Administrator" -ForegroundColor Red
    pause
    exit
}

Clear-Host
Write-Host "===== Red Dead Redemption 2 Activator =====" -ForegroundColor Cyan
$input = Read-Host "Enter your license key"

if ($input -ne $key) {
    Write-Host "Invalid Key" -ForegroundColor Red
    pause
    exit
}

Write-Host "Key Valid, Searching Steam..." -ForegroundColor Green

# 找Steam
$paths = @("C:\Program Files (x86)\Steam", "D:\Steam", "E:\Steam", "F:\Steam")
$steam = $null
foreach ($p in $paths) {
    if (Test-Path "$p\steam.exe") {
        $steam = $p
        break
    }
}

if (-not $steam) {
    Write-Host "Steam Not Found" -ForegroundColor Red
    pause
    exit
}

# 关闭Steam
taskkill /F /IM steam.exe >$null 2>&1
Start-Sleep 2

# 写入完整ACF
$acf = Join-Path $steam "steamapps\appmanifest_$appid.acf"
@"
"AppState"
{
"appid" "$appid"
"Universe" "1"
"name" "$name"
"StateFlags" "6"
"installdir" "$installdir"
"IsInstalled" "1"
"LicenseType" "1"
"AllowDownload" "1"
"Depot"
{
"1174181" { "Manifest" "0" }
"1174182" { "Manifest" "0" }
"1174183" { "Manifest" "0" }
"1174184" { "Manifest" "0" }
}
}
"@ | Out-File $acf -Encoding ASCII -Force

Write-Host "Success! Game Activated." -ForegroundColor Green
Write-Host "Close Steam fully, then install directly."
pause
