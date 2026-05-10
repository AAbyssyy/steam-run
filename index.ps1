# ===================== 配置区 =====================
$AllowKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$GameAppID = 1551360   # 极限竞速：地平线5
# =================================================

# 检测管理员权限
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "请以管理员身份运行终端！Win+X 选择终端(管理员)" -ForegroundColor Red
    Read-Host "按回车退出"
    exit
}

Clear-Host
Write-Host "===== 地平线5 专属卡密激活工具 =====" -ForegroundColor Cyan
$InputKey = Read-Host "请输入专属激活卡密"

# 卡密校验
if ($InputKey -ne $AllowKey) {
    Write-Host "`n❌ 卡密错误，激活失败！" -ForegroundColor Red
    Read-Host "按回车退出"
    exit
}

Write-Host "`n✅ 卡密验证通过，正在自动定位Steam路径..." -ForegroundColor Green
Start-Sleep 1

# ==============================================
# 修复：自动获取Steam路径（兼容所有安装位置）
# ==============================================
$steamPath = $null

# 先读注册表
$regPaths = @(
    "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam",
    "HKLM:\SOFTWARE\Valve\Steam",
    "HKCU:\SOFTWARE\Valve\Steam"
)

foreach ($reg in $regPaths) {
    if (Test-Path $reg) {
        $steamPath = (Get-ItemProperty $reg).InstallPath
        if ($steamPath) { break }
    }
}

# 注册表找不到，用常见路径
if (-not $steamPath) {
    $commonPaths = @(
        "C:\Program Files (x86)\Steam",
        "D:\Steam",
        "E:\Steam",
        "F:\Steam"
    )
    foreach ($p in $commonPaths) {
        if (Test-Path "$p\steam.exe") {
            $steamPath = $p
            break
        }
    }
}

# 还是找不到
if (-not $steamPath -or -not (Test-Path "$steamPath\steam.exe")) {
    Write-Host "`n❌ 无法找到Steam，请确认已安装Steam！" -ForegroundColor Red
    Read-Host "按回车退出"
    exit
}

Write-Host "✅ 已找到Steam：$steamPath" -ForegroundColor Green
Start-Sleep 1

# 生成入库文件
$manifestPath = Join-Path $steamPath "steamapps\appmanifest_$GameAppID.acf"

$manifestContent = @"
"AppState"
{
    "appid"        "$GameAppID"
    "Universe"      "1"
    "StateFlags"    "4"
    "InstallDir"    "Forza Horizon 5"
    "SizeOnDisk"    "0"
}
"@

try {
    $manifestContent | Out-File $manifestPath -Encoding ASCII -Force
    Write-Host "`n🎉 地平线5 入库成功！" -ForegroundColor Green
    Write-Host "💡 请**完全退出Steam再重新打开**，游戏库就会出现！" -ForegroundColor Yellow
}
catch {
    Write-Host "`n❌ 写入失败：$_" -ForegroundColor Red
}

Read-Host "`n按回车结束"
