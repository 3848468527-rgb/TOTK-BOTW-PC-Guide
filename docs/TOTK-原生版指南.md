# 王国之泪 PC 原生版（TotK-Recomp）完整指南

> 作者：**DeliKitch** ｜ 本仓库不含游戏文件，请自备正版 dump。

## 一、这是什么

TotK-Recomp 是社区用「静态重编译」技术把 Switch 版《王国之泪》的机器码翻译成 Windows x64 程序，再用 Vulkan 渲染。
和模拟器（Yuzu/Ryujinx/Eden 等）相比：
- **帧率更高**：没有 JIT 翻译开销，2K 下 120fps 很轻松；
- **更稳定**：不会出现模拟器特有的卡顿和图形错误；
- **画质好**：支持 DLSS/DLAA、原生分辨率、宽屏。

## 二、准备条件

| 项目 | 要求 |
|---|---|
| 游戏版本 | 《王国之泪》**1.4.3**（需要 base `.xci` + 更新 `.nsp` 两份 dump）|
| 系统 | Windows 10/11 x64 |
| CPU | 支持 AVX2（建议 6 核 12 线程以上）|
| 内存 | 16GB 起，建议 24GB+（原生版吃内存）|
| 显卡 | Vulkan 1.3 的 NVIDIA/AMD 独显（RTX 20 系以上体验最佳）|
| 硬盘 | 约 25GB（romfs 17GB + 程序/缓存）|

## 三、安装步骤（简述）

1. 获取社区 TotK-Recomp 的安装器/压缩包（作者会随版本发布，注意核对来源与校验值）。
2. 安装器会要求选择 **base 游戏 dump（.xci）** 与 **更新档（.nsp）**，以及一个空目录作为游戏目录。
3. 等待构建：解包 → 翻译代码 → 编译 → 预构建着色器/管线（首次约 10~30 分钟，视 CPU 而定）。
4. 完成后运行游戏目录里的 `totk.exe`。

> 更新游戏版本时，覆盖 `romfs`/`exefs` 后重新运行一次构建即可；配置文件 `totk.ini` 会保留。

## 四、配置文件说明（config/totk-2k120.ini）

| 键 | 说明 |
|---|---|
| `fps_limit` | 帧率上限：`60`/`120`/`144`/`165`/`display`（跟显示器）；高帧率需 `realtime = 1` |
| `realtime` / `cloth_realtime` / `highfps_fix` | 高帧率必需，否则动画/物理变速 |
| `dlss` | `quality`（质量，最锐利）/`balanced`/`performance`/`dlaa`（抗锯齿最好）|
| `dlaa` | 1 = 用 DLAA 替代 DLSS（画面最清晰但更吃性能）|
| `gpl` | 图形管线库，默认开，减少着色器卡顿 |
| `pipe_skip` | `fullscreen`（默认）跳过全屏通道，别随意改 |
| `shadow_scale` / `shadow_res` / `pcss` | 阴影质量，卡就调小 |
| `fov` / `aspect` | 视野/宽高比（宽屏可 `stretch`）|
| `vk_present` | `mailbox` 垂直同步；`immediate` 低延迟无同步 |
| `perf_overlay` | F10 切换帧率浮层：`off`/`fps`/`full` |

**游戏内按 F1** 打开设置菜单，可实时改分辨率、DLSS、阴影、帧率上限，改动会写回 `totk.ini`。

## 五、性能优化清单

1. 关掉后台占 CPU 的程序（浏览器、录屏、压缩软件）。
2. NVIDIA 控制面板：**着色器缓存大小 = 无限制**；电源管理模式 = 最高性能。
3. 首次进入新区域会短暂卡顿（编译管线），属正常；第二次进入就流畅了。
4. 2K 屏建议：`window_size = 2560x1440`、`output_res = 2560x1440`、`dlss = quality`；想更高帧改 `dlss = balanced`。
5. 用外部插帧（小黄鸭）：游戏锁 60，插到 120/180，见 docs/小黄鸭插帧.md。
6. 帧率不稳时：`fps_limit = 60`、`shadow_scale = 1`、`pcss = 0`，逐个降。

## 六、常见问题

- **闪退**：确认游戏是 1.4.3、dump 完整；更新显卡驱动；不要开 `free_cores = 1`。
- **贴图错误/黑块**：更新版本或换 `astc = gpu`/`cpu` 试试。
- **启动慢**：首次加载预构建缓存较慢，之后正常。
- **手柄不识别**：`[input] pad_layout = nintendo` 对应 Switch Pro 布局；Xbox 手柄可改 `xbox`。