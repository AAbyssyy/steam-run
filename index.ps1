[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null
$ErrorActionPreference = "SilentlyContinue"

# 配置
$KEY = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$APPID = "1174180"
$GAME = "Red Dead Redemption 2"

# 管理员
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
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
$steamPaths = @("D:\Steam", "C:\Program Files (x86)\Steam", "E:\Steam", "F:\Steam")
$steam = $null
foreach ($p in $steamPaths) {
    if (Test-Path "$p\steam.exe") {
        $steam = $p
        break
    }
}
if (-not $steam) {
    Write-Host "Steam Not Found!" -ForegroundColor Red
    pause
    exit
}

# 关闭Steam
taskkill /F /IM steam.exe > $null 2>&1
Start-Sleep 2

# ==============================================
# 🔥 核心：tibbar213 正版可安装结构
# ==============================================
$acf = Join-Path $steam "steamapps\appmanifest_$APPID.acf"
$manifest = @"
"AppState"
{
    "appid"                "$APPID"
    "Universe"             "1"
    "name"                 "$GAME"
    "StateFlags"           "1024"
    "installdir"           "Red Dead Redemption 2"
    "UpdateResult"         "0"
    "SizeOnDisk"           "0"
    "buildid"              "0"
    "LastOwner"            "0"
    "InstalledDepots"
    {
        "1174181"          "0"
        "1174182"          "0"
        "1174183"          "0"
        "1174184"          "0"
    }
    "UserConfig"
    {
        "Language"         "english"
    }
    "MountedDepots"
    {
        "1174181"          "0"
    }
}
"@

# 写入
Set-Content -Path $acf -Value $manifest -Encoding ASCII -Force

# 关键：修改登录授权（tibbar213 核心）
$vdf = Join-Path $steam "config\loginusers.vdf"
if (Test-Path $vdf) {
    $content = Get-Content $vdf -Raw
    $content = $content -replace '"users"', "`"UserGameInfo\`n{\n`"$APPID\`"\n{\n`"Owned`"	`"1`"\n}\n}\n`"users`""
    Set-Content -Path $vdf -Value $content -Encoding ASCII -Force
}

Write-Host "`n✅ ACTIVATED - INSTALL NOW!" -ForegroundColor Green
Write-Host "Close Steam FULLY from tray, then open and install!"
pause
