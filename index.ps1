# 解决乱码
chcp 65001 | Out-Null

# 固定配置
$RightKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$AppID = 1551360

# 管理员检测
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
if (-not $isAdmin)
{
    Write-Host "Please run as Administrator" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Clear-Host
Write-Host "===== Forza Horizon 5 Activator =====" -ForegroundColor Cyan
$InKey = Read-Host "Please enter your key"

if ($InKey -ne $RightKey)
{
    Write-Host "Wrong key!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "Key Correct, activating game..." -ForegroundColor Green

# 自动找Steam路径
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
    Write-Host "Steam not found!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit
}

# 写入可安装正版级 manifest
$acfPath = Join-Path $steamRoot "steamapps\appmanifest_$AppID.acf"
$acfTxt = @"
"AppState"
{
    "appid"        "1551360"
    "Universe"     "1"
    "StateFlags"   "4"
    "InstallLocation" "Forza Horizon 5"
    "IsInstalled"  "1"
    "LicenseType"  "1"
}
"@
$acfTxt | Out-File $acfPath -Encoding ASCII -Force

Write-Host "Success! Please completely close Steam and reopen." -ForegroundColor Green
Write-Host "Now you can install directly, no purchase button."
Read-Host "Press Enter"
