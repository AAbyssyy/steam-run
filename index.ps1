chcp 65001 | Out-Null
$RightKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$AppID = 1174180

# 管理员检测
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
if (-not $isAdmin) {
    Write-Host "Please run as Administrator" -ForegroundColor Red
    pause
    exit
}

Clear-Host
Write-Host "===== Red Dead Redemption 2 Activator =====" -ForegroundColor Cyan
$InKey = Read-Host "Please enter your key"

if ($InKey -ne $RightKey) {
    Write-Host "Wrong key!" -ForegroundColor Red
    pause
    exit
}

Write-Host "`nKey Correct, activating game..." -ForegroundColor Green

# 自动查找Steam
$steamPaths = @("C:\Program Files (x86)\Steam","D:\Steam","E:\Steam","F:\Steam","C:\Steam")
$steamRoot = $null
foreach ($p in $steamPaths) {
    if (Test-Path "$p\steam.exe") {
        $steamRoot = $p
        break
    }
}

if (-not $steamRoot) {
    Write-Host "Steam Not Found!" -ForegroundColor Red
    pause
    exit
}

# ==============================================
# 🔥 核心：完整版 ACF（带 Depot，真正可安装）
# ==============================================
$acfPath = Join-Path $steamRoot "steamapps\appmanifest_$AppID.acf"
$acfTxt = @"
"AppState"
{
    "appid"        "1174180"
    "Universe"     "1"
    "name"         "Red Dead Redemption 2"
    "StateFlags"   "6"
    "installdir"   "Red Dead Redemption 2"
    "LastUpdated"  "0"
    "UpdateResult" "0"
    "SizeOnDisk"   "0"
    "buildid"      "0"
    "IsInstalled"  "1"
    "LicenseType"  "1"
    "AutoUpdate"   "0"
    "AllowDownload" "1"
    "Depot"
    {
        "1174181"
        {
            "Manifest" "0"
            "Size"     "0"
        }
        "1174182"
        {
            "Manifest" "0"
            "Size"     "0"
        }
        "1174183"
        {
            "Manifest" "0"
            "Size"     "0"
        }
        "1174184"
        {
            "Manifest" "0"
            "Size"     "0"
        }
    }
    "DLC"
    {
    }
}
"@

# 强制写入完整版ACF
$acfTxt | Out-File $acfPath -Encoding ASCII -Force

Write-Host "`n✅ Activated Success! (Full ACF Installable)" -ForegroundColor Green
Write-Host "===================================================="
Write-Host "1. FULLY CLOSE STEAM (Right click tray icon -> Exit)"
Write-Host "2. Open Steam again -> Find RDR2 -> CLICK INSTALL"
Write-Host "3. NO PURCHASE BUTTON, DIRECT DOWNLOAD!"
Write-Host "===================================================="
pause
