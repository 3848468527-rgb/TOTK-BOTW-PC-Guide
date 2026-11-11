<#
  launch-botw.ps1 — 一键启动旷野之息(Cemu), 并设为高优先级 (by DeliKitch)
  用法:
    powershell -ExecutionPolicy Bypass -File .\scripts\launch-botw.ps1 -CemuDir "D:\Cemu-BOTW\Cemu"
    可选 -GameRpx "....\roms\The Legend of Zelda Breath of the Wild\code\U-King.rpx"
#>
param(
    [string]$CemuDir = 'D:\Cemu-BOTW\Cemu',
    [string]$GameRpx = ''
)
$ErrorActionPreference = 'Continue'
$exe = Join-Path $CemuDir 'Cemu.exe'
if (-not (Test-Path $exe)) { Write-Host "找不到 Cemu.exe: $exe" -ForegroundColor Red; exit 1 }
if (-not $GameRpx) {
    $GameRpx = Join-Path $CemuDir 'roms\The Legend of Zelda Breath of the Wild\code\U-King.rpx'
}

# 关掉残留进程, 避免双开
$old = Get-Process -Name 'Cemu' -ErrorAction SilentlyContinue
if ($old) { $old | Stop-Process -Force -ErrorAction SilentlyContinue; Start-Sleep -Seconds 3 }

if (Test-Path $GameRpx) { Start-Process -FilePath $exe -ArgumentList @('-g', "`"$GameRpx`"") -WorkingDirectory $CemuDir }
else { Start-Process -FilePath $exe -WorkingDirectory $CemuDir }

# 等游戏起来后设为高优先级, 减少卡顿
for ($i = 0; $i -lt 30; $i++) {
    Start-Sleep -Milliseconds 800
    $p = Get-Process -Name 'Cemu' -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($p) { try { $p.PriorityClass = 'High' } catch {}; break }
}
Write-Host "已启动 Cemu (高优先级)。" -ForegroundColor Green