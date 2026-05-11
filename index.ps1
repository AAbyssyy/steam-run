# 复刻 ikunshare Onekey 原生可安装版
$ErrorActionPreference="SilentlyContinue"
# 卡密
$key="AB6HA-ZGBTZ-W6GM5-AC544-5409V"
# RDR2
$appid=1174180

# 管理员判断
$admin=[Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
if(!$admin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    Write-Host "Run as Administrator!" -ForegroundColor Red
    pause
    exit
}

Clear-Host
Write-Host "===== OneKey Activator =====" -ForegroundColor Cyan
$uk=Read-Host "Enter Key"
if($uk -ne $key){Write-Host "Wrong Key!" -ForegroundColor Red;pause;exit}

# 找Steam路径
$steam=$null
foreach($p in "D:\Steam","C:\Program Files (x86)\Steam","E:\Steam","F:\Steam"){
    if(Test-Path "$p\steam.exe"){$steam=$p;break}
}
if(!$steam){Write-Host "Steam Not Found!" -ForegroundColor Red;pause;exit}

# 强关Steam
taskkill /f /im steam.exe 2>&1 | Out-Null
Start-Sleep 1

# 1. 写入可安装标准ACF
$acf=Join-Path $steam "steamapps\appmanifest_$appid.acf"
@"
"AppState"
{
"appid" "1174180"
"Universe" "1"
"StateFlags" "4"
"installdir" "Red Dead Redemption 2"
"IsInstalled" "1"
"LicenseType" "1"
}
"@ | Out-File $acf -Encoding ASCII -Force

# 2. 关键：修改 loginusers.vdf 写入拥有标记（人家能装的核心）
$vdfPath=Join-Path $steam "config\loginusers.vdf"
if(Test-Path $vdfPath){
    $txt=Get-Content $vdfPath -Raw
    if($txt -match '"UserGameInfo"'){
        $txt=$txt -replace '("UserGameInfo"\s*\{\s*)', "`$1`n`"1174180`"`n{`n`"Owned"`"`"1`"`n}`n"
        Set-Content $vdfPath $txt -Encoding ASCII -Force
    }
}

# 3. 写入离线强制配置
$cfg=Join-Path $steam "steam.cfg"
"ForceOfflineMode=1" | Out-File $cfg -Encoding ASCII -Force

Write-Host "Success! Fully close Steam then reopen." -ForegroundColor Green
pause
