<#
  tune-botw-graphics.ps1 — 调优 Cemu 旷野之息图形包默认值 (by DeliKitch)
  原理: Cemu 以图形包 rules.txt 的 [Default] 值为准 (settings.xml 里同名键有时不生效)。
  改完需要完全退出并重启 Cemu 才生效。

  用法:
    powershell -ExecutionPolicy Bypass -File .\scripts\tune-botw-graphics.ps1 -CemuDir "D:\Cemu-BOTW\Cemu" -FpsLimit 165 -Width 1920 -Height 1080
    不带参数则按默认 (165fps / 1920x1080) 处理默认路径。

  注意: 只改你自己安装的图形包文件, 脚本会自动备份为 .bak-tune-<时间>。
#>
param(
    [string]$CemuDir = 'D:\Cemu-BOTW\Cemu',
    [int]$FpsLimit = 165,
    [int]$Width = 1920,
    [int]$Height = 1080
)
$ErrorActionPreference = 'Stop'
$base = Join-Path $CemuDir 'graphicPacks\downloadedGraphicPacks\BreathOfTheWild'
if (-not (Test-Path $base)) { Write-Error "找不到 BOTW 图形包: $base"; exit 1 }

function Update-Rules {
    param([string]$Path, [hashtable]$Edits, [string]$Tag)
    if (-not (Test-Path $Path)) { Write-Host "跳过 $Tag (找不到 $Path)" -ForegroundColor Yellow; return }
    $text = Get-Content $Path -Raw -Encoding UTF8
    $bak = "$Path.bak-tune-$(Get-Date -Format yyyyMMdd-HHmmss)"
    Copy-Item $Path $bak -Force
    foreach ($key in $Edits.Keys) {
        $pattern = '(?m)^' + [regex]::Escape($key) + ' = \S+'
        $repl = "$key = $($Edits[$key])"
        $new = [regex]::Replace($text, $pattern, $repl)
        if ($new -ne $text) { Write-Host "  [$Tag] $key -> $($Edits[$key])" ; $text = $new }
        else { Write-Host "  [$Tag] $key 未找到 (可能默认值已是目标值)" -ForegroundColor Yellow }
    }
    [System.IO.File]::WriteAllText($Path, $text, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "  [$Tag] 已保存, 备份: $bak"
}

Update-Rules -Path (Join-Path $base 'Graphics\rules.txt') -Tag 'Graphics' -Edits @{ '$width' = $Width; '$height' = $Height }
Update-Rules -Path (Join-Path $base 'Mods\FPS++\rules.txt') -Tag 'FPS++' -Edits @{ '$fpsLimitNormal' = $FpsLimit; '$fpsLimitAdvanced' = $FpsLimit }

Write-Host ""
Write-Host "完成。请完全退出 Cemu 后重新启动, 在 选项->图形包 中确认:" -ForegroundColor Green
Write-Host "  Resolution = $Width x $Height / FPS++ = $FpsLimit"
Write-Host "提示: 想恢复默认, 用同名 .bak-tune-* 文件覆盖回去即可。"