[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$AllowKey = "AB6HA-ZGBTZ-W6GM5-AC544-5409V"
$GameAppID = 1551360

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Run as Administrator!" -ForegroundColor Red
    pause
    exit
}

Clear-Host
Write-Host "===== Forza Horizon 5 Activator =====" -ForegroundColor Cyan
$inputKey = Read-Host "Enter your license key"

if ($inputKey -ne $AllowKey) {
    Write-Host "Invalid Key!" -ForegroundColor Red
    pause
    exit
}

Write-Host "Key Valid. Searching Steam..." -ForegroundColor Green

$steamPath = $null
$paths = @(
    "C:\Program Files (x86)\Steam",
    "D:\Steam", "E:\Steam", "F:\Steam", "C:\Steam"
)

foreach ($p in $paths) {
    if (Test-Path "$p\Steam.exe") {
        $steamPath = $p
        break
    }
}

if (-not $steamPath) {
    Write-Host "Steam Not Found!" -ForegroundColor Red
    pause
    exit
}

Write-Host "Steam Found: $steamPath"

$manifest = @"
"AppState"
{
    "appid" "$GameAppID"
    "Universe" "1"
    "StateFlags" "4"
}
"@

$dest = Join-Path $steamPath "steamapps\appmanifest_$GameAppID.acf"
$manifest | Out-File $dest -Encoding ASCII -Force

Write-Host "`n✅ Success! Game added to your library." -ForegroundColor Green
Write-Host "Restart Steam to see Forza Horizon 5 in your Library."
pause
