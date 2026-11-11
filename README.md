# 王国之泪 / 旷野之息 PC 配置与优化教程

> **作者 / Author: DeliKitch**
> 本仓库整理《塞尔达传说：王国之泪》《塞尔达传说：旷野之息》在 PC 上运行的**优化配置、安装教程与排错经验**（2K / 高帧率 / DLSS / 小黄鸭插帧）。

## ⚠️ 重要：本仓库不含任何游戏文件
- 游戏本体（romfs、程序、更新档、Cemu roms 等）**均不包含**，请使用你自己合法拥有的游戏 dump。
- 本仓库只包含**配置文件、脚本和文字教程**（MIT License，Copyright © 2026 **DeliKitch**）。
- *The Legend of Zelda: Tears of the Kingdom / Breath of the Wild* 为任天堂株式会社的版权作品与商标。

---

## 一、王国之泪（TotK-Recomp 原生移植版）

适用：社区静态重编译的 PC 原生版（本机实测版本 `TotK-Recomp 0.3.1+ab1dee5`，游戏 **1.4.3**，需要 base `.xci` + 更新 `.nsp` dump）。
它把 Switch 版游戏代码静态翻译成 Windows 程序，再通过 Vulkan 运行，**不是模拟器**，因此帧率和画质都远好于模拟器。

| 项目 | 本机实测配置 |
|---|---|
| 显示器 | 2560x1440（2K）|
| 帧率上限 | 120（`fps_limit = 120`，`realtime = 1`）|
| 超分 | DLSS 质量 / DLAA（`nvngx_dlss.dll` 放在 `totk.exe` 同目录）|
| 阴影 | 轻量阴影（`shadow_scale` 小、`pcss = 0`）|
| 实测 | 2K 下 GPU 约 50% 占用，帧率轻松跑满，温度稳定 |

**快速使用**
1. 按 [docs/TOTK-原生版指南.md](docs/TOTK-原生版指南.md) 用你自己的 dump 构建/安装原生版；
2. 应用配置模板（自动备份原配置）：
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\apply-totk-config.ps1 -GameDir "D:\TOTK-Recomp" -Preset 2k120
   ```
3. 游戏内按 **F1** 可随时改画质/帧率，菜单里改的会写回 `totk.ini`。

配置模板：
- [config/totk-2k120.ini](config/totk-2k120.ini)：2K + 120 帧（推荐 180Hz 显示器）
- [config/totk-2k60.ini](config/totk-2k60.ini)：2K + 60 帧（更省电/更稳）

---

## 二、旷野之息（Cemu 2.0 整合包）

适用：Wii U 版 + Cemu 模拟器（开源，cemu-project）。本机实测整合包为 **Cemu 2.0-86**，含社区图形包（Graphic Packs）。

| 项目 | 本机实测配置 |
|---|---|
| 模拟器 | Cemu 2.0-86 / Cemu 2.6（本机调优版）|
| 图形包 | Resolution（内部 1920x1080）+ FPS++ 165 + Clarity/阴影优化 |
| 实测 | 2K 输出 + 165 帧（改 `rules.txt` 默认值，比设置菜单更可靠），一键启动脚本自动设高优先级 |
| 注意 | 高帧率必须配合 FPS++ 图形包，否则物理会变速；改完规则需重启 Cemu 生效 |

**快速使用**：见 [docs/BOTW-Cemu指南.md](docs/BOTW-Cemu指南.md)。
要点：Cemu 里 **选项 → 图形包** 勾选 Resolution / FPS++ / Clarity；**选项 → 通用设置** 里 MLC 路径指向 `mlc`、Game Path 指向 `roms`；Graphic API 选 Vulkan、`async compile` 开、`accurateShaderMul` 关。

---

## 三、画质与帧率优化通用清单

1. **显卡驱动**保持最新；NVIDIA 控制面板 → 管理 3D 设置 → **着色器缓存大小 = 无限制**。
2. **电源模式** = 高性能 / 卓越性能；关闭后台录屏、浏览器多标签等吃 CPU 的程序。
3. **DLSS**：优先「质量」或「DLAA」（画面最锐利）；想更高帧再降「平衡/性能」。
4. **小黄鸭（Lossless Scaling）插帧**：游戏锁 60/120 作为稳定基准，插帧 2x/3x 到显示器刷新率。详见 [docs/小黄鸭插帧.md](docs/小黄鸭插帧.md)。
5. **帧生成冲突**：王国之泪原生版若已在菜单开启帧生成（dlssg），使用小黄鸭前请关闭，二者叠加会严重掉帧。
6. **首次卡顿**：原生版首次进新区域会编译着色器/管线，短暂停顿属正常，之后流畅。

---

## 四、文件说明

```
config/    totk-2k120.ini / totk-2k60.ini      王国之泪原生版配置模板
scripts/   apply-totk-config.ps1               一键应用配置（自动备份）
           tune-botw-graphics.ps1              调优 BOTW 图形包默认值（rules.txt）
           launch-botw.ps1                     一键启动 Cemu 旷野之息（高优先级）
           check-setup.ps1                     硬件与目录检查
docs/      TOTK-原生版指南.md                  构建/安装/调优完整教程
           BOTW-Cemu指南.md                    Cemu 配置完整教程
           小黄鸭插帧.md                       插帧设置教程
```

## 五、致谢与版权 / Credits & Legal

- **王国之泪原生移植**：社区开源静态重编译项目 TotK-Recomp（作者与贡献者保留全部权利），本项目仅提供配置与文档。
- **Cemu**：开源 Wii U 模拟器，[cemu-project](https://github.com/cemu-project/Cemu)（MPL-2.0），本仓库不含其二进制。
- **BOTW 图形包**：社区 [cemu_graphic_packs](https://github.com/cemu-project/cemu_graphic_packs) 项目的配置建议。
- *The Legend of Zelda: Tears of the Kingdom*、*Breath of the Wild*、*Nintendo Switch/Wii U* 为任天堂株式会社的商标与版权作品。
  请勿使用本仓库传播游戏文件；请支持正版。
- 本仓库的配置、脚本与文档：**MIT License，Copyright (c) 2026 DeliKitch**。