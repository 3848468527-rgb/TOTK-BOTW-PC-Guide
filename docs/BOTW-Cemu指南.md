# 旷野之息（Cemu 2.0）完整配置指南

> 作者：**DeliKitch** ｜ 本仓库不含游戏文件与 Cemu 程序。

## 一、这是什么

《旷野之息》没有官方 PC 版，PC 上运行的是 **Wii U 版 + Cemu 模拟器**。
Cemu 2.0 已经非常成熟：2K/4K + 120 帧图形包 + Vulkan，画质与流畅度都很好。

本机实测整合包：**Cemu 2.0-86** + 社区图形包（Resolution / FPS++ / Clarity 等）。

## 二、目录结构（整合包）

```
Cemu_2.0-86\
├─ Cemu.exe                 ← 模拟器主程序
├─ settings.xml             ← 全局设置
├─ mlc\                     ← 模拟器数据（存档在这里）
├─ roms\                    ← 游戏本体（Wii U 版）
├─ graphicPacks\            ← 图形包
│  └─ downloadedGraphicPacks\BreathOfTheWild\...
└─ gameProfiles\00050000101c9300.ini   ← 旷野之息专用配置
```

## 三、首次设置

1. 双击 `Cemu.exe`。
2. **选项 → 通用设置**：
   - **MLC 路径** 选择 `mlc` 文件夹；
   - **游戏路径** 添加 `roms` 文件夹。
3. **选项 → 图形 API** 选择 **Vulkan**。
4. **选项 → 图形**：
   - Upscale Filter：Bilinear / Bicubic；
   - 阴影：中等或高；
   - **异步编译（async compile）** 打开，减少卡顿；
   - `accurateShaderMul` 建议 **关**（提高帧率）。
5. **选项 → 输入设置**：选择你的手柄（Xbox/PS/Switch Pro）或键盘。

## 四、图形包（关键！）

在 **选项 → 图形包** 中勾选（BreathOfTheWild）：

| 图形包 | 设置 |
|---|---|
| **Resolution** | 按显示器选：2K 显示器选 2560x1440；或选 2x 超采样（更清晰，更吃显卡）|
| **FPS++** | 选 120（或 60）；120 帧需要配合 FPS++，否则物理变速 |
| **Clarity** | 开（去雾、提高对比度）|
| **Shadow Resolution** | 按性能选 2K/4K |
| **Aspect Ratio** | 16:9 或宽屏 |
| **Anti-Aliasing** | FXAA 或 SMAA（可关）|
| **Cheats** | 按需（无限耐久等）|

> 2K + 120 帧建议：Resolution 2560x1440、FPS++ 120、阴影 2K、其余默认，GPU 占用约 50~70%。

## 五、存档位置

- 存档在 `mlc\` 下（Cemu 内部格式），备份整个 `mlc` 文件夹即可。
- 也可以导出/导入存档：右键游戏 → 存档目录。

## 六、性能优化

1. 图形 API 必须 **Vulkan**；显卡驱动保持最新。
2. Cemu 设置里开 **Async compile**（异步着色器编译），首次进区域卡顿明显减少。
3. 关掉后台程序；NVIDIA 控制面板着色器缓存 = 无限制。
4. 用 120 帧图形包时，建议关闭垂直同步（用显卡 G-Sync/FreeSync），避免帧时间抖动。
5. 想用外部插帧（小黄鸭）：游戏锁 60（FPS++ 60），插到 120/180。

## 七、常见问题

- **启动黑屏/崩溃**：确认 roms 完整、图形 API 设为 Vulkan、更新驱动。
- **帧率低**：检查是否误选了 OpenGL；降低 Resolution/阴影；关掉 MSAA。
- **画质发灰**：开 Clarity 图形包；颜色选项里调对比度。
- **手柄键位不对**：输入设置里重新映射，或换用 Switch Pro 布局。