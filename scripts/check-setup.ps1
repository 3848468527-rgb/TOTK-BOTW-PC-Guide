<#
  check-setup.ps1 — 检查运行王国之泪/旷野之息的硬件与目录 (by DeliKitch)
#>
$ErrorActionPreference = 'SilentlyContinue'
Write-Host "=== 塞尔达 PC 运行环境检查 (DeliKitch) ===" -ForegroundColor Cyan

$gpus = Get-CimInstance Win32_VideoController | Where-Object { $_.Name -notmatch 'Oray|Idd|Basic' }
foreach ($g in $gpus) {
    $vram = if ($g.AdapterRAM -gt 0) { [math]::Round($g.AdapterRAM/1GB,1) } else { '未知' }
    Write-Host ("GPU: {0}  显存: {1} GB  驱动: {2}" -f $g.Name, $vram, $g.DriverVersion)
}
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB,1)
Write-Host ("CPU: {0} ({1}C/{2}T)   内存: {3} GB" -f $cpu.Name.Trim(), $cpu.NumberOfCores, $cpu.NumberOfLogicalProcessors, $ram)
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Name -match '^[C-Z]$' } | ForEach-Object {
    Write-Host ("磁盘 {0}: 剩余 {1} GB" -f $_.Name, [math]::Round($_.Free/1GB,1))
}

Write-Host ""
Write-Host "=== 检测安装 ===" -ForegroundColor Cyan
$totk = @()
foreach ($root in @('D:\','E:\','C:\')) {
    Get-ChildItem $root -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'TOTK|TotK|王国之泪|塞尔达' } | ForEach-Object {
        if (Test-Path (Join-Path $_.FullName 'totk.exe')) {
            $ver = if (Test-Path (Join-Path $_.FullName 'totk-install.json')) { (Get-Content (Join-Path $_.FullName 'totk-install.json') -Raw | ConvertFrom-Json).version } else { '?' }
            $totk += [pscustomobject]@{ Path = $_.FullName; GameVersion = $ver }
        }
    }
}
if ($totk) { $totk | Format-Table -AutoSize | Out-String | Write-Host } else { Write-Host "  未检测到王国之泪原生版 (totk.exe)" }

$cemu = Get-ChildItem 'D:\','E:\' -Recurse -Depth 4 -File -Filter 'Cemu.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($cemu) { Write-Host ("  旷野之息 Cemu: {0}" -f $cemu.FullName) } else { Write-Host "  未检测到 Cemu.exe" }

Write-Host ""
Write-Host "建议:" -ForegroundColor Yellow
Write-Host "  1. NVIDIA 控制面板 -> 管理 3D 设置 -> 着色器缓存大小 = 无限制"
Write-Host "  2. 王国之泪: config/totk-2k120.ini (或 2k60) 用 scripts/apply-totk-config.ps1 应用"
Write-Host "  3. 旷野之息: Cemu 图形 API 选 Vulkan，开 async compile，图形包选 Resolution + FPS++"