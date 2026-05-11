# 强制编码防乱码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null
$ErrorActionPreference = "SilentlyContinue"

# 配置
$FixKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$AppID = "1174180"
$GameName = "Red Dead Redemption 2"
$InstallFolder = "Red Dead Redemption 2"

# 检测管理员
$curPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if(-not $curPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    Write-Host "ERROR: Run PowerShell as Administrator!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Clear-Host
Write-Host "===== RDR2 OneKey Activator =====" -ForegroundColor Cyan
$InputKey = Read-Host "Enter your license key"

if($InputKey -ne $FixKey)
{
    Write-Host "Invalid License Key!" -ForegroundColor Red
    Read-Host "Press Enter"
    exit
}

Write-Host "Key Verified. Processing..." -ForegroundColor Green

# 自动遍历找Steam路径
$steamPaths = @("C:\Program Files (x86)\Steam","D:\Steam","E:\Steam","F:\Steam","C:\Steam")
$steamRoot = $null
foreach($path in $steamPaths)
{
    if(Test-Path "$path\Steam.exe")
    {
        $steamRoot = $path
        break
    }
}

if(-not $steamRoot)
{
    Write-Host "Steam Not Found On System!" -ForegroundColor Red
    Read-Host "Press Enter"
    exit
}
Write-Host "Steam Found: $steamRoot"

# 强制关闭Steam
Stop-Process -Name Steam -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

# 写入完整可安装ACF（复刻Onekey有效结构）
$acfFullPath = Join-Path $steamRoot "steamapps\appmanifest_$AppID.acf"
$acfContent = @"
"AppState"
{
    "appid"        "$AppID"
    "Universe"     "1"
    "name"         "$GameName"
    "StateFlags"   "6"
    "installdir"   "$InstallFolder"
    "IsInstalled"  "1"
    "LicenseType"  "1"
    "AllowDownload" "1"
    "Depot"
    {
        "1174181"
        {
            "Manifest" "0"
        }
        "1174182"
        {
            "Manifest" "0"
        }
        "1174183"
        {
            "Manifest" "0"
        }
        "1174184"
        {
            "Manifest" "0"
        }
    }
}
"@

$acfContent | Out-File $acfFullPath -Encoding ASCII -Force

Write-Host "`n✅ Activate Success!" -ForegroundColor Green
Write-Host "1. Fully exit Steam from tray"
Write-Host "2. Reopen Steam, install game directly"
Write-Host "3. No purchase button"
Read-Host "Press Enter"
