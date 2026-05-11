chcp 65001 | Out-Null
$RightKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"

# 管理员检测
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
if (-not $isAdmin) {
    Write-Host "Please run as Administrator" -ForegroundColor Red
    pause
    exit
}

Clear-Host
Write-Host "===== Game Activator =====" -ForegroundColor Cyan
$InKey = Read-Host "Please enter your key"

if ($InKey -ne $RightKey) {
    Write-Host "Wrong key!" -ForegroundColor Red
    pause
    exit
}

# 加载你的线上游戏库
try {
    $lib = Invoke-RestMethod "https://AAbyssyy.github.io/steam-run/games.json"
    $AppID = $lib.active.appid
    $GameName = $lib.active.name
    $InstallDir = $lib.active.folder
}
catch {
    Write-Host "Library load failed" -ForegroundColor Red
    pause
    exit
}

Write-Host "`n✅ Key Correct | Game: $GameName" -ForegroundColor Green

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

# 写入授权文件
$acfPath = Join-Path $steamRoot "steamapps\appmanifest_$AppID.acf"
$acfTxt = @"
"AppState"
{
    "appid"        "$AppID"
    "Universe"     "1"
    "name"         "$GameName"
    "StateFlags"   "4"
    "installdir"   "$InstallDir"
    "IsInstalled"  "1"
    "LicenseType"  "1"
}
"@
$acfTxt | Out-File $acfPath -Encoding ASCII -Force

Write-Host "`n✅ Activated Success!" -ForegroundColor Green
Write-Host "Close Steam fully and reopen to install"
pause
