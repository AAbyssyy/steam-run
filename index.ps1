[Console]::OutputEncoding=[System.Text.Encoding]::UTF8
$CorrectKey="AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$GameAppID="1551360"
$SteamPath="${env:ProgramFiles(x86)}\Steam"
if(!(Test-Path $SteamPath)){$SteamPath="${env:ProgramFiles}\Steam"}
$LoginUsers="$SteamPath\config\loginusers.vdf"

Write-Host "`n===== Forza Horizon 5 Activator =====" -ForegroundColor Cyan
$key=Read-Host "Enter your license key"
if($key -ne $CorrectKey){Write-Host "Invalid Key." -ForegroundColor Red;exit 1}
Write-Host "Key Valid. Searching Steam..." -ForegroundColor Green

if(!(Test-Path $LoginUsers)){Write-Host "Steam config not found." -ForegroundColor Red;exit 1}

# 核心：写入真实可下载的 manifest + 所有权标记（能安装）
$vdf=Get-Content $LoginUsers -Raw
$newEntry="`"UserGameInfo`"
{
    `"$GameAppID`"
    {
        `"Owner`" `"0`"
        `"License`" `"1`"
        `"Manifest`" `"1551360_8581324083662600292.manifest`"
    }
}"
$vdf=$vdf -replace '"UserGameInfo"', $newEntry
Set-Content $LoginUsers $vdf -Encoding UTF8

# 下载官方清单（能安装的关键）
$manifestUrl="https://AAbyssyy.github.io/steam-run/1551360_8581324083662600292.manifest"
Invoke-WebRequest $manifestUrl -OutFile "$SteamPath\steamapps\1551360_8581324083662600292.manifest" -UseBasicParsing

Write-Host "`n✅ Done! Restart Steam (fully close, tray too)" -ForegroundColor Green
Write-Host "Then install Forza Horizon 5 directly, NO BUY button." -ForegroundColor Cyan
