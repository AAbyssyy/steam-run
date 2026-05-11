[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null
$ErrorActionPreference = "SilentlyContinue"

# ========== RDR2 官方参数（和 Onekey 完全一致） ==========
$FixKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$AppID = "1174180"
$GameName = "Red Dead Redemption 2"
$InstallFolder = "Red Dead Redemption 2"
$StateFlags = "1026"  # 关键：必须是1026，不是6

# 管理员检测
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

# 找Steam路径
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

# 强关Steam
Stop-Process -Name Steam -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# ========== 完整 ACF（含所有 Depot + 隐藏字段） ==========
$acfFullPath = Join-Path $steamRoot "steamapps\appmanifest_$AppID.acf"
$acfContent = @"
"AppState"
{
    "appid"        "$AppID"
    "Universe"     "1"
    "name"         "$GameName"
    "StateFlags"   "$StateFlags"
    "installdir"   "$InstallFolder"
    "IsInstalled"  "1"
    "LicenseType"  "1"
    "AllowDownload" "1"
    "BytesStaged"  "0"
    "InstallLocation" "0"
    "AutoUpdateBehavior" "1"
    "AllowOtherDownloadsWhileRunning" "0"
    "Depot"
    {
        "1174181" { "Manifest" "0" }
        "1174182" { "Manifest" "0" }
        "1174183" { "Manifest" "0" }
        "1174184" { "Manifest" "0" }
        "1174185" { "Manifest" "0" }
        "1174186" { "Manifest" "0" }
        "1174187" { "Manifest" "0" }
        "1174188" { "Manifest" "0" }
        "1174189" { "Manifest" "0" }
        "1174190" { "Manifest" "0" }
        "1174191" { "Manifest" "0" }
        "1174192" { "Manifest" "0" }
        "1174193" { "Manifest" "0" }
        "1174194" { "Manifest" "0" }
        "1174195" { "Manifest" "0" }
    }
}
"@

# 写入ACF
$acfContent | Out-File $acfFullPath -Encoding ASCII -Force

# ✅ 关键：设为只读，防止Steam自动删除
attrib +r $acfFullPath

Write-Host "`n✅ Activate Success! (Full ACF + ReadOnly)" -ForegroundColor Green
Write-Host "1. Fully exit Steam from tray"
Write-Host "2. Reopen Steam → Library → RDR2 → Install"
Write-Host "3. No purchase button, direct download"
Read-Host "Press Enter"
