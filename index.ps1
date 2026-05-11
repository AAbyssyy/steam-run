# 固定编码防乱码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null
$ErrorActionPreference = "SilentlyContinue"

# 配置
$CorrectKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$AppID = "1174180"
$GameName = "Red Dead Redemption 2"
$InstallDir = "Red Dead Redemption 2"

# 管理员检测
$admin = [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $admin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Write-Host "Run PowerShell as Administrator First!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Clear-Host
Write-Host "===== OneKey Game Activator =====" -ForegroundColor Cyan
$inputKey = Read-Host "Enter License Key"

if ($inputKey -ne $CorrectKey)
{
    Write-Host "Wrong Key!" -ForegroundColor Red
    Read-Host "Press Enter"
    exit
}

Write-Host "Key Correct, Activating..." -ForegroundColor Green

# 自动搜Steam路径
$steamPaths = @(
    "C:\Program Files (x86)\Steam",
    "D:\Steam",
    "E:\Steam",
    "F:\Steam",
    "C:\Steam"
)
$steamRoot = $null
foreach ($p in $steamPaths)
{
    if (Test-Path "$p\steam.exe")
    {
        $steamRoot = $p
        break
    }
}
if (-not $steamRoot)
{
    Write-Host "Steam Not Found!" -ForegroundColor Red
    Read-Host "Press Enter"
    exit
}

# 强制关闭Steam
Stop-Process -Name steam -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# ===================== 关键1：写入steam.cfg 强制离线绕过校验 =====================
$cfgPath = Join-Path $steamRoot "steam.cfg"
$cfgText = @"
BootStrapperInhibitAll=1
ForceOfflineMode=1
NoWebBrowser=1
"@
$cfgText | Out-File $cfgPath -Encoding ASCII -Force

# ===================== 关键2：RDR2 官方完整可安装ACF =====================
$acfPath = Join-Path $steamRoot "steamapps\appmanifest_$AppID.acf"
$acfText = @"
"AppState"
{
    "appid"        "1174180"
    "Universe"     "1"
    "name"         "Red Dead Redemption 2"
    "StateFlags"   "1026"
    "installdir"   "Red Dead Redemption 2"
    "LastUpdated"  "0"
    "SizeOnDisk"   "0"
    "buildid"      "0"
    "IsInstalled"  "1"
    "LicenseType"  "2"
    "AllowDownload" "1"
    "AutoUpdateBehavior" "1"
    "Depot"
    {
        "1174181" { "Manifest" "0" }
        "1174182" { "Manifest" "0" }
        "1174183" { "Manifest" "0" }
        "1174184" { "Manifest" "0" }
        "1174185" { "Manifest" "0" }
        "1174186" { "Manifest" "0" }
    }
}
"@
$acfText | Out-File $acfPath -Encoding ASCII -Force

# 设为只读防Steam篡改
attrib +r $acfPath | Out-Null

Write-Host "`n✅ Activate Done! Can Install Directly" -ForegroundColor Green
Write-Host "1. Exit Steam completely (tray icon too)"
Write-Host "2. Open Steam again, click install"
Write-Host "3. No purchase button"
Read-Host "Press Enter"
