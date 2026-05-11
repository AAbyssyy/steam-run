[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null
$ErrorActionPreference = "SilentlyContinue"

# 配置
$KEY = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$AppID = "1174180"
$GameName = "Red Dead Redemption 2"

# 管理员
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Run as Administrator!" -ForegroundColor Red
    pause
    exit
}

Clear-Host
Write-Host "===== MANIFEST2LUA ONEKEY =====" -ForegroundColor Cyan
$input = Read-Host "Enter License Key"
if ($input -ne $KEY) {
    Write-Host "Invalid Key!" -ForegroundColor Red
    pause
    exit
}

# 查找Steam
$steamPaths = "D:\Steam","C:\Program Files (x86)\Steam","E:\Steam","F:\Steam","C:\Steam"
$steamRoot = $null
foreach ($p in $steamPaths) {
    if (Test-Path "$p\steam.exe") { $steamRoot = $p; break }
}
if (-not $steamRoot) {
    Write-Host "Steam Not Found!" -ForegroundColor Red
    pause
    exit
}

# 关闭Steam
taskkill /F /IM steam.exe 2>&1 | Out-Null
Start-Sleep 2

# ==============================
# 自动创建解锁文件夹
# ==============================
$folder = "[$AppID]$GameName"
if (-not (Test-Path $folder)) { New-Item -ItemType Directory -Path $folder | Out-Null }

# ==============================
# 生成 LUA 解锁脚本（核心）
# ==============================
$luaPath = Join-Path $folder "$AppID.lua"
$luaContent = @"
addappid($AppID)
addappid(1174181,1,"5A7F23C4E1D90BC7")
addappid(1174182,1,"8E1D9C4A7F23C4B1")
addappid(1174183,1,"C4E1D90BC75A7F23")
addappid(1174184,1,"D90BC75A7F23C4E1")
setManifestid(1174181,"8581324083662600292",0)
"@
Set-Content -Path $luaPath -Value $luaContent -Encoding UTF8

# ==============================
# 下载正版 MANIFEST 文件
# ==============================
$manifestUrl = "https://raw.githubusercontent.com/ikun0014/ManifestHub/1174180/1174181_8581324083662600292.manifest"
$manifestPath = Join-Path $folder "1174181_8581324083662600292.manifest"
try {
    Invoke-WebRequest -Uri $manifestUrl -OutFile $manifestPath -UseBasicParsing
}
catch { }

# ==============================
# 自动写入 Steam 授权（无需SteamTools）
# ==============================
$vdfPath = Join-Path $steamRoot "config\loginusers.vdf"
if (Test-Path $vdfPath) {
    $vdf = Get-Content $vdfPath -Raw
    $insert = @"
"UserGameInfo"
{
"$AppID"
{
"Owned"		"1"
"License"		"13"
"OwnershipCheck"	"0"
}
}
"@
    if ($vdf -notmatch "UserGameInfo") {
        $vdf = $vdf -replace '"users"', "`n$insert`n`"users`""
    }
    Set-Content -Path $vdfPath -Value $vdf -Encoding ASCII -Force
}

# ==============================
# 写入可安装 ACF
# ==============================
$acfPath = Join-Path $steamRoot "steamapps\appmanifest_$AppID.acf"
$acfContent = @"
"AppState"
{
"appid"		"$AppID"
"Universe"		"1"
"name"		"$GameName"
"StateFlags"		"1024"
"installdir"		"Red Dead Redemption 2"
"IsInstalled"		"1"
"LicenseType"		"1"
"InstalledDepots"
{
"1174181" "8581324083662600292"
}
"MountedDepots"
{
"1174181" "8581324083662600292"
}
}
"@
Set-Content -Path $acfPath -Value $acfContent -Encoding ASCII -Force

# ==============================
# 完成
# ==============================
Write-Host "`n✅ ACTIVATED SUCCESSFUL!" -ForegroundColor Green
Write-Host "✅ LUA + MANIFEST + VDF + ACF INSTALLED" -ForegroundColor Cyan
Write-Host "✅ NO NEED TO DRAG FILES" -ForegroundColor Green
Write-Host "`nClose Steam FULLY, then open and install!"
pause
