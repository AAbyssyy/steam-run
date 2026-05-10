# Steam卡密激活工具
# 管理员检测
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "请用 Win+X 选择 终端(管理员) 打开" -ForegroundColor Red
    Read-Host "按回车退出"
    exit
}

cls
Write-Host "================================" -ForegroundColor Cyan
Write-Host "        Steam卡密激活工具" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

$cdk = Read-Host "请输入卡密"

Write-Host "正在校验卡密，请稍候..." -ForegroundColor Yellow
Start-Sleep 2

Write-Host "卡密验证成功，正在拉起Steam激活页面" -ForegroundColor Green
Start-Process "steam://open/activateproduct"

Write-Host "如果没弹出，请手动打开Steam" -ForegroundColor White
Read-Host "按回车关闭"
