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

Write-Host "`n✅ 卡密验证通过，正在入库 地平线5 ..." -ForegroundColor Green
Start-Sleep 2

# 自动拉起Steam入库地平线5
Start-Process "steam://install/$GameAppID"

Write-Host "`n🎉 地平线5 激活入库成功！" -ForegroundColor Green
Write-Host "💡 打开Steam库即可看到游戏，直接安装游玩" -ForegroundColor Yellow
Read-Host "按回车结束"
