# 配置
$GameAppID = 1551360
$AllowKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"

# 管理员检测
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "请以管理员身份运行！" -ForegroundColor Red
    Read-Host "回车退出"
    exit
}

Clear-Host
Write-Host "===== 地平线5 卡密激活 =====" -ForegroundColor Cyan
$InputKey = Read-Host "请输入卡密"

if ($InputKey -ne $AllowKey) {
    Write-Host "`n❌ 卡密错误" -ForegroundColor Red
    Read-Host "回车退出"
    exit
}

Write-Host "`n✅ 卡密正确，尝试写入库文件..." -ForegroundColor Green

# 自动找Steam路径
$steamReg = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam" -ErrorAction SilentlyContinue
if (-not $steamReg) {
    Write-Host "❌ 未找到Steam" -ForegroundColor Red
    Read-Host
    exit
}
$steamPath = $steamReg.InstallLocation
$libFolder = Join-Path $steamPath "steamapps"
$manifestPath = Join-Path $libFolder "appmanifest_$GameAppID.acf"

# 写入最小manifest
$manifestContent = @"
"AppState"
{
    "appid"        "$GameAppID"
    "Universe"      "1"
    "StateFlags"    "4"
    "InstallLocation"  "Forza Horizon 5"
    "CurrentLanguage"   "english"
    "SizeOnDisk"        "0"
    "BytesDownloaded"   "0"
    "BytesToDownload"   "0"
}
"@

try {
    $manifestContent | Out-File $manifestPath -Encoding ASCII
    Write-Host "✅ 入库文件写入成功！" -ForegroundColor Green
    Write-Host "💡 重启Steam → 库中即可看到地平线5（可下载）" -ForegroundColor Yellow
} catch {
    Write-Host "❌ 写入失败：$_" -ForegroundColor Red
}

Read-Host "回车结束"
