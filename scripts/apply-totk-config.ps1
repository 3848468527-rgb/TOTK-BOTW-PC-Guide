<#
  apply-totk-config.ps1 — 把王国之泪优化配置写入原生版游戏目录 (by DeliKitch)
  用法:
    powershell -ExecutionPolicy Bypass -File .\scripts\apply-totk-config.ps1 -GameDir "D:\TOTK-Recomp" -Preset 2k120
    -Preset: 2k120 (默认) 或 2k60
#>
param(
    [string]$GameDir = 'D:\TOTK-Recomp',
    [ValidateSet('2k120','2k60')]
    [string]$Preset = '2k120'
)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$template = Join-Path (Split-Path -Parent $here) "config\totk-$Preset.ini"
if (-not (Test-Path $template)) { Write-Error "找不到配置模板: $template"; exit 1 }
if (-not (Test-Path (Join-Path $GameDir 'totk.exe'))) {
    Write-Error "在 '$GameDir' 未找到 totk.exe，请用 -GameDir 指定王国之泪原生版目录"; exit 1
}

# 关闭正在运行的游戏
Get-Process totk -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

$target = Join-Path $GameDir 'totk.ini'
if (Test-Path $target) {
    $bak = "$target.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
    Copy-Item $target $bak -Force
    Write-Host "已备份原配置: $bak"
}
Copy-Item $template $target -Force
Write-Host "已写入配置 ($Preset): $target"
Write-Host ""
Write-Host "启动游戏后按 F1 可在菜单里确认/微调 (分辨率 / DLSS / 帧率 / 阴影)。"