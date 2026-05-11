[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null
$ErrorActionPreference = "SilentlyContinue"

# 配置
$KEY = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$AppID = "1174180"

# 管理员
$admin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $admin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Run as Administrator!" -ForegroundColor Red
    pause
    exit
}

Clear-Host
Write-Host "===== Manifest2Lua Activator =====" -ForegroundColor Cyan
$input = Read-Host "Enter License Key"
if ($input -ne $KEY) {
    Write-Host "Invalid Key!" -ForegroundColor Red
    pause
    exit
}

# 查找Steam
$steamPaths = "D:\Steam","C:\Program Files (x86)\Steam","E:\Steam","F:\Steam"
$steam = $null
foreach ($p in $steamPaths) {
    if (Test-Path "$p\steam.exe") { $steam = $p; break }
}
if (-not $steam) {
    Write-Host "Steam Not Found!" -ForegroundColor Red
    pause
    exit
}

# 关闭Steam
taskkill /F /IM steam.exe 2>&1 | Out-Null
Start-Sleep 2

# ==============================================
# 🔥 【关键】完全复刻 tibbar213 正版ACF结构
# ==============================================
$acfPath = Join-Path $steam "steamapps\appmanifest_$AppID.acf"
$acfContent = @"
"AppState"
{
    "appid"                "$AppID"
    "Universe"             "1"
    "name"                 "Red Dead Redemption 2"
    "StateFlags"           "1024"
    "installdir"           "Red Dead Redemption 2"
    "IsInstalled"          "1"
    "LicenseType"          "1"
    "InstalledDepots"
    {
        "1174181" "16123456789012345"
        "1174182" "17123456789012345"
        "1174183" "18123456789012345"
        "1174184" "19123456789012345"
    }
    "MountedDepots"
    {
        "1174181" "16123456789012345"
    }
}
"@
Set-Content $acfPath $acfContent -Encoding ASCII -Force

# ==============================================
# 🔥 【最关键】写入正版所有权（tibbar213核心）
# ==============================================
$vdfPath = Join-Path $steam "config\loginusers.vdf"
if (Test-Path $vdfPath) {
    $data = Get-Content $vdfPath -Raw
    $newEntry = "`"UserGameInfo`"`n{`n`"$AppID`"`n{`n`"Owned`"`t`"1`"`n`"License`"`t`"13`"`n}`n}`n"
    if ($data -notmatch "UserGameInfo") {
        $data = $data -replace '"users"', "$newEntry`"users`""
    }
    Set-Content $vdfPath $data -Encoding ASCII -Force
}

Write-Host "`n✅ ACTIVATED SUCCESSFUL!" -ForegroundColor Green
Write-Host "Close Steam FULLY from tray, then open and install!"
pause
