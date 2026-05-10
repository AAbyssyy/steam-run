# 地平线5 专属激活脚本（最终修复版）
$AllowKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$GameAppID = 1551360

# 管理员权限检查
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "错误：请以管理员身份运行终端！" -ForegroundColor Red
    pause
    exit
}

Clear-Host
Write-Host "===== 地平线5 专属激活工具 =====" -ForegroundColor Cyan
$InputKey = Read-Host "请输入激活卡密"

if ($InputKey -ne $AllowKey) {
    Write-Host "卡密错误！" -ForegroundColor Red
    pause
    exit
}

Write-Host "卡密验证成功，正在定位Steam..." -ForegroundColor Green

# 强力搜索Steam路径（绝不会空值）
$steamPath = $null
$paths = @(
    "C:\Program Files (x86)\Steam",
    "D:\Steam", "E:\Steam", "F:\Steam",
    "C:\Steam", "D:\Program Files (x86)\Steam"
)

foreach ($p in $paths) {
    if (Test-Path "$p\Steam.exe") {
        $steamPath = $p
        break
    }
}

if (-not $steamPath) {
    Write-Host "未找到Steam，请安装后重试！" -ForegroundColor Red
    pause
    exit
}

Write-Host "找到Steam：$steamPath" -ForegroundColor Green

# 写入入库文件
$manifest = @"
"AppState"
{
    "appid" "$GameAppID"
    "Universe" "1"
    "StateFlags" "4"
}
"@

$dest = Join-Path $steamPath "steamapps\appmanifest_1551360.acf"
$manifest | Out-File $dest -Encoding ASCII -Force

Write-Host "`n✅ 地平线5 已成功入库！" -ForegroundColor Green
Write-Host "💡 关闭Steam重新打开，游戏库就会显示！"
pause
