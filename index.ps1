# 配置
$AllowKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$GameAppID = 1551360

# 管理员检测
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if(-not $isAdmin){
    Write-Host "请用管理员身份打开终端再运行！"
    Read-Host "回车退出"
    exit
}

# 控制台强制UTF8解决乱码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

Write-Host "===== 地平线5 专属激活工具 ====="
$cdk = Read-Host "请输入激活卡密"

if($cdk -ne $AllowKey){
    Write-Host "卡密错误，激活失败！"
    Read-Host "回车退出"
    exit
}

Write-Host "卡密正确，正在查找Steam目录..."

# 固定常见Steam路径挨个检测
$steamPaths = @(
    "C:\Program Files (x86)\Steam",
    "D:\Steam",
    "E:\Steam",
    "F:\Steam",
    "C:\Steam"
)

$steamRoot = $null
foreach($p in $steamPaths){
    if(Test-Path "$p\steam.exe"){
        $steamRoot = $p
        break
    }
}

if(-not $steamRoot){
    Write-Host "未检测到已安装的Steam，请先安装Steam！"
    Read-Host "回车退出"
    exit
}

Write-Host "成功找到Steam: $steamRoot"

# 写入入库清单
$acfPath = Join-Path $steamRoot "steamapps\appmanifest_$GameAppID.acf"

$acfText = @"
"AppState"
{
  "appid" "$GameAppID"
  "Universe" "1"
  "StateFlags" "4"
  "InstallDir" "Forza Horizon 5"
}
"@

try{
    $acfText | Out-File $acfPath -Encoding ASCII -Force
    Write-Host "已成功写入地平线5入库文件！"
    Write-Host "请完全关闭Steam，重新打开即可在库中看到游戏"
}
catch{
    Write-Host "写入文件失败，请关闭杀毒软件再试"
}

Read-Host "按回车结束"
