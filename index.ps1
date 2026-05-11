chcp 65001 | Out-Null
$RightKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$AppID = 1174180
$HidDllUrl = "https://raw.githubusercontent.com/ikunshare/Onekey/main/hid.dll" # 原作者原版

# 管理员检测
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
if (-not $isAdmin) {
    Write-Host "请以管理员身份运行" -ForegroundColor Red
    pause
    exit
}

Clear-Host
Write-Host "===== RDR2 一键入库（可安装）=====" -ForegroundColor Cyan
$InKey = Read-Host "请输入卡密"

if ($InKey -ne $RightKey) {
    Write-Host "卡密错误！" -ForegroundColor Red
    pause
    exit
}

Write-Host "`n卡密正确，正在激活..." -ForegroundColor Green

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
    Write-Host "未找到Steam！" -ForegroundColor Red
    pause
    exit
}

# 关闭Steam
Stop-Process -Name steam -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# 1. 写入完整版ACF（带Depot，可安装）
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
        "1174181" { "Manifest" "0" "Size" "0" }
        "1174182" { "Manifest" "0" "Size" "0" }
        "1174183" { "Manifest" "0" "Size" "0" }
        "1174184" { "Manifest" "0" "Size" "0" }
    }
    "DLC" {}
}
"@
$acfTxt | Out-File $acfPath -Encoding ASCII -Force

# 2. 下载并注入hid.dll（关键！和Onekey同源）
$hidPath = Join-Path $steamRoot "hid.dll"
Invoke-WebRequest -Uri $HidDllUrl -OutFile $hidPath -UseBasicParsing

Write-Host "`n✅ 激活成功（入库+可安装）" -ForegroundColor Green
Write-Host "===================================="
Write-Host "1. 请完全关闭Steam（托盘也要退出）"
Write-Host "2. 重新打开Steam → 找到RDR2 → 直接安装"
Write-Host "3. 无购买按钮，直接下载！"
Write-Host "===================================="

# 启动Steam
Start-Process "$steamRoot\steam.exe"
pause
