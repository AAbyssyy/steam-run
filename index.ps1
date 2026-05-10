[Console]::OutputEncoding=[System.Text.Encoding]::UTF8
$GameAppID=1551360
$key="AB6HA-ZGBTZ-W6GM5-AC544-5409V"

# 必须管理员
$admin=[Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $admin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    Write-Host "Run as Administrator!" -ForegroundColor Red
    pause;exit
}

Clear-Host
Write-Host "===== Forza Horizon 5 Install Fix =====" -ForegroundColor Cyan
$ukey=Read-Host "Enter license key"
if ($ukey -ne $key){Write-Host "Invalid Key!" -ForegroundColor Red;pause;exit}

# 找Steam
$steamPaths=@("D:\Steam","C:\Program Files (x86)\Steam","E:\Steam","F:\Steam")
$steam=$null
foreach ($p in $steamPaths){if (Test-Path "$p\Steam.exe"){$steam=$p;break}}
if (-not $steam){Write-Host "Steam Not Found!" -ForegroundColor Red;pause;exit}
Write-Host "Steam: $steam"

$steamapps=Join-Path $steam "steamapps"
# 1. 写 appmanifest
$manifest=Join-Path $steamapps "appmanifest_$GameAppID.acf"
@"
"AppState"
{
    "appid" "$GameAppID"
    "Universe" "1"
    "StateFlags" "6"
    "InstallLocation" "Forza Horizon 5"
    "SizeOnDisk" "0"
    "BuildID" "0"
    "LastUpdated" "0"
    "LastPlayed" "0"
    "IsInstalled" "1"
    "IsUpdating" "0"
    "IsDownloading" "0"
    "State" "6"
    "LastOwner" "0"
    "License" "1"
}
"@ | Out-File $manifest -Encoding ASCII -Force

# 2. 写 packageinfo（关键：本地授权）
$pkg=Join-Path $steamapps "packageinfo_$GameAppID.acf"
@"
"PackageState"
{
    "appid" "$GameAppID"
    "packageid" "$GameAppID"
    "Universe" "1"
    "StateFlags" "6"
    "IsOwned" "1"
    "IsLicensed" "1"
    "LicenseExpiry" "0"
}
"@ | Out-File $pkg -Encoding ASCII -Force

# 3. 写 steam.cfg（离线校验绕过）
$cfg=Join-Path $steam "steam.cfg"
"BootStrapperInhibitAll=1`nForceOffline=1" | Out-File $cfg -Encoding ASCII -Force

# 4. 写 loginusers 本地授权标记
$loginusers=Join-Path $steam "config\loginusers.vdf"
if (Test-Path $loginusers){
    $content=Get-Content $loginusers -Raw
    if ($content -notmatch '"$GameAppID"'){
        $content=$content -replace '"UserGameInfo"',"`"UserGameInfo`"`n{`n`"$GameAppID"`"`n{`n`"Owned"`"`"1"`"`n}`n}"
        $content | Out-File $loginusers -Encoding ASCII -Force
    }
}

Write-Host "`n✅ Done! Restart Steam (fully close, tray too)" -ForegroundColor Green
Write-Host "Then install Forza Horizon 5 directly, no BUY button."
pause
