chcp 65001 | Out-Null
$RightKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$AppID = 1551360

# 管理员检测
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")
if (-not $isAdmin) { Write-Host "请用管理员身份运行" -ForegroundColor Red; pause; exit }

Clear-Host
Write-Host "===== 地平线5 终极入库工具 =====" -ForegroundColor Cyan
$InKey = Read-Host "请输入卡密"

if ($InKey -ne $RightKey) { Write-Host "卡密错误！" -ForegroundColor Red; pause; exit }
Write-Host "`n卡密正确，正在写入授权..." -ForegroundColor Green

# 找Steam路径
$steamPaths = @("C:\Program Files (x86)\Steam","D:\Steam","E:\Steam","F:\Steam","C:\Steam")
$steamRoot = $null
foreach ($p in $steamPaths) { if (Test-Path "$p\steam.exe") { $steamRoot = $p; break } }
if (-not $steamRoot) { Write-Host "未找到Steam！" -ForegroundColor Red; pause; exit }

# 【核心修复】完整合法的acf文件（之前缺关键字段！）
$acfPath = Join-Path $steamRoot "steamapps\appmanifest_$AppID.acf"
$acfTxt = @"
"AppState"
{
    "appid"        "1551360"
    "Universe"     "1"
    "name"         "Forza Horizon 5"
    "StateFlags"   "4"
    "installdir"   "Forza Horizon 5"
    "LastUpdated"  "0"
    "UpdateResult" "0"
    "SizeOnDisk"   "0"
    "buildid"      "0"
    "IsInstalled"  "1"
    "LicenseType"  "1"
}
"@
$acfTxt | Out-File $acfPath -Encoding ASCII -Force

Write-Host "`n✅ 授权写入成功！" -ForegroundColor Green
Write-Host "`n⚠️  必须严格按以下步骤操作：" -ForegroundColor Yellow
Write-Host "1. 完全关闭Steam（右下角托盘也要退出）"
Write-Host "2. 重新打开Steam → 库 → 找到地平线5 → 直接安装"
Write-Host "3. 无购买按钮，直接下载！"
pause
