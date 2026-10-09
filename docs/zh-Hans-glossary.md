# Compositor zh-Hans 翻译字典

zh-Hans 本地化版本基于 Adobe Photoshop 简体中文版术语,对齐通用译法。所有 key 都在 `Compositor/Localizable.xcstrings` 的 `zh-Hans` 段,运行时通过 `Bundle.main.localizedString(forKey:value:table:)` 解析。

新术语先查本表再加 `.xcstrings`。同义词 / 新译法在此登记后再更新 .xcstrings。

## 通用

| 英文 | 中文 |
| --- | --- |
| OK | 好 |
| Cancel | 取消 |
| Default | 默认 |
| Reset | 重置 |
| Done | 完成 |
| Help | 帮助 |
| Open | 打开 |
| Save | 保存 |
| Save As / Save As… | 另存为 / 另存为… |
| Open Project / Open Project… | 打开项目 / 打开项目… |
| Close Project | 关闭项目 |
| Close %@ | 关闭 %@ |
| Import / Import image | 导入 / 导入图像 |
| Export / Export… | 导出 / 导出… |
| Export PNG / Export PNG… | 导出 PNG / 导出 PNG… |
| Export JPEG / Export JPEG… | 导出 JPEG / 导出 JPEG… |
| Apply | 应用 |
| Apply Crop | 应用裁剪 |
| Add / Remove | 添加 / 移除 |
| Don’t Save | 不保存 |
| Untitled | 未命名 |
| Continue | 继续 |
| All | 全部 |
| Back | 返回 |
| Close | 关闭 |
| New | 新建 |
| Hide / Show | 隐藏 / 显示 |
| Edit | 编辑 |

## 工具栏

| 英文 | 中文 |
| --- | --- |
| Move / Transform | 移动 / 变换 |
| Marquee | 选框 |
| Lasso | 套索 |
| Wand (tool) | 魔棒 |
| Brush (tool) | 画笔 |
| Eraser | 橡皮擦 |
| Spot Healing | 污点修复 |
| Clone Stamp | 仿制图章 |
| Smear / Blur (tool) | 涂抹 |
| Gradient (tool) | 渐变 |
| Shape (tool) | 形状 |
| Type (tool) | 文字 |
| Eyedropper | 吸管 |
| Hand (tool) | 抓手 / 手形 |
| Zoom (tool) | 缩放 |
| Crop (tool) | 裁剪 |
| Type → Type tool / Text tool | 文字 → 文字工具 |

## 文件 / 编辑菜单

| 英文 | 中文 |
| --- | --- |
| New Canvas / New Canvas… | 新建画布 / 新建画布… |
| Open Recent | 最近打开 |
| Save Project | 保存项目 |
| Revert | 恢复到磁盘版本 |
| Page Setup | 页面设置 |
| Print | 打印 |
| Undo / Redo | 撤销 / 重做 |
| Undo %@ / Redo %@ | 撤销 %@ / 重做 %@ |
| Cut / Copy / Paste | 剪切 / 复制 / 粘贴 |
| Copy Merged | 复制合并 |
| Deselect | 取消选择 |
| Select All | 全选 |
| Rulers | 显示/标尺 |
| Show / Hide Rulers | 显示/隐藏 标尺 |

## 图层面板

| 英文 | 中文 |
| --- | --- |
| Layers | 图层 |
| Layers (menu) | 图层 |
| Layer %lld | 图层 %lld |
| Layer %@ | 图层 %@ |
| Layer Mask | 图层蒙版 |
| Background (layer) | 背景 |
| Background canvas | 背景画布 |
| Background Color | 背景颜色 |
| Folder / Folder %lld | 文件夹 / 文件夹 %lld |
| New folder | 新建文件夹 |
| Group Selected Layers | 将选中图层分组 |
| Ungroup Layers | 取消图层分组 |
| Merge Down / Merge Layers / Merge Group | 向下合并 / 合并图层 / 合并组 |
| Merge Visible | 合并可见图层 |
| New Blank Layer | 新建空白图层 |
| Duplicate Layer / Duplicate Layers | 复制图层 / 复制图层 |
| Rename… / Rename Layer… | 重命名… / 重命名图层… |
| Delete Layer / Delete Selected Layers / Delete Layers | 删除图层 / 删除所选图层 / 删除图层 |
| Delete Mask | 删除蒙版 |
| Add Mask | 添加蒙版 |
| Enable Mask / Disable Mask | 启用蒙版 / 停用蒙版 |
| Link Mask / Unlink Mask | 链接蒙版 / 取消链接蒙版 |
| Invert Mask | 反相蒙版 |
| Add layer mask | 添加图层蒙版 |
| Reveal All (White) | 显示全部(白) |
| Hide All (Black) | 隐藏全部(黑) |
| Create Clipping Mask / Release Clipping Mask | 创建剪贴蒙版 / 释放剪贴蒙版 |
| Show Layer / Hide Layer | 显示图层 / 隐藏图层 |
| Move Layer / Move Layers / Move Layer Up / Move Layer Down | 移动图层 / 移动图层 / 上移图层 / 下移图层 |
| Move Out of Folder | 移出文件夹 |
| Alignment | 对齐方式 |
| Convert / Rasterize | 转换 / 栅格化 |
| Flatten Image | 拼合图像 |

## 图层效果 (sparkles 图标菜单)

| 英文 | 中文 |
| --- | --- |
| Drop Shadow / Drop Shadow… | 投影 / 投影… |
| Inner Shadow / Inner Shadow… | 内阴影 / 内阴影… |
| Outer Glow / Outer Glow… | 外发光 / 外发光… |
| Inner Glow / Inner Glow… | 内发光 / 内发光… |
| Color Overlay / Color Overlay… | 颜色叠加 / 颜色叠加… |
| Stroke / Stroke… | 描边 / 描边… |
| Copy %@ / Add %@ | 粘贴 / Paste / 添加 %@ |
| Edit %@ | 编辑 %@ |
| Delete %@ | 删除 %@ |
| Hide %@ / Show %@ | 隐藏 %@ / 显示 %@ |
| Cancel %@ | 取消 %@ |

### 描边 / 阴影 / 发光 / 叠加 参数

| 英文 | 中文 |
| --- | --- |
| Stroke | 描边 |
| Position / Outside / Inside | 位置 / 外部 / 内部 |
| Size / Opacity / Choke / Spread | 大小 / 不透明度 / 收缩 / 扩散宽度 |
| Color | 颜色 |
| Blend mode | 混合模式 |
| Angle / Distance / Blur | 角度 / 距离 / 模糊 |

## 调整图层菜单(下半圆图标菜单)

| 英文 | 中文 |
| --- | --- |
| Curves / Levels / Levels… / Curves… | 曲线 / 色阶 / 色阶… / 曲线… |
| Exposure | 曝光 |
| Hue/Saturation | 色相/饱和度 |
| Color Balance | 色彩平衡 |
| Black & White | 黑白 |
| Gradient Map | 渐变映射 |
| Grain | 颗粒 |

## 滤镜菜单

| 英文 | 中文 |
| --- | --- |
| Gaussian Blur | 高斯模糊 |
| Motion Blur | 动感模糊 |
| Add Noise | 添加杂色 |
| Vignette | 暗角 |
| Bloom / Glow / Bloom & Glow | 光晕 / 柔光 / 模糊发光 / 光晕/发光 |
| Tonal Contrast | 色调对比 |
| Lens Correction | 镜头校正 |
| Camera Raw Filter | Camera Raw 滤镜 |
| Remove Background | 移除背景 |
| Content-Aware Fill | 内容识别填充 |
| Dither | 抖动 |

### 滤镜参数通用

| 英文 | 中文 |
| --- | --- |
| Amount | 数量 |
| Radius | 半径 |
| Size | 大小 |
| Angle | 角度 |
| Distance | 距离 |
| Scale | 缩放 |
| Offset | 距离 |
| Density | 浓度 |
| Contrast | 对比度 |
| Opacity | 不透明度 |
| Range | 范围 |
| Spread | 扩散宽度 |
| Roughness | 粗糙度 |
| Tolerance | 容差 |
| Edge | 边缘 |
| Shift Edge | 边缘偏移 |
| Refine | 细化 |
| Midpoint | 中点 |
| Roundness | 圆度 |
| Feather | 羽化 |
| Glow | 光晕 |
| Highlights | 高光 |
| Blend / Blending | 混合 |
| Pixel Size / Text Size / Cell Size / Line Spacing | 像素大小 / 文字大小 / 单元格大小 / 行距 |
| Style | 样式 |
| Reverse | 反向 |
| Colors | 颜色 |
| Dark / Light | 深色 / 浅色 |
| Light on Dark | 亮在暗底 |
| Pixel Shape | 像素形状 |
| Characters | 字符 |
| Diffusion | 漫射 |
| Wobble | 抖动 |
| Dots | 点 |
| Vignetting | 暗角 |
| Strength | 强度 |
| Exposure (filter) | 曝光 |
| Gamma | Gamma |
| Apply outside this range instead | 反之,只作用于该范围之外 |

### Dither 算法

| 英文 | 中文 |
| --- | --- |
| Atkinson (Classic Mac) | Atkinson(经典 Mac) |
| Floyd–Steinberg | Floyd–Steinberg |
| Bayer 2 × 2 / Bayer 4 × 4 / Bayer 8 × 8 | Bayer 2 × 2 / Bayer 4 × 4 / Bayer 8 × 8 |
| Halftone Dots / Halftone Lines / Halftone Diamonds | 半调点阵 / 半调线条 / 半调菱形 |
| Mac Patterns | Mac 图案 |
| ASCII | ASCII |
| Scanlines (CRT) | 扫描线(CRT) |
| Square / Dot | 方块 / 圆点 |
| Black & White | 黑白 |
| Two Colors | 两色 |
| Original | 原始 |

### 颜色平衡 / 黑白 / 渐变映射 / 颗粒

| 英文 | 中文 |
| --- | --- |
| Shadows / Midtones / Highlights | 阴影 / 中间调 / 高光 |
| Reds / Yellows / Greens / Cyans / Blues / Magentas | 红色 / 黄色 / 绿色 / 青色 / 蓝色 / 洋红 |
| Cyan / Red / Magenta / Green / Yellow / Blue (sliders) | 青色/红色 / 洋红/绿色 / 黄色/蓝色 |
| Tint | 色调 |
| Hue | 色相 |
| Saturation | 饱和度 |
| Tint Hue / Tint Saturation | 色调色相 / 色调饱和度 |
| Preserve Luminosity | 保持明亮度 |
| Colors (gradient endpoints) | 颜色节点(渐变端点) |
| Shadows / Highlights (gradient map) | 阴影 / 高光(渐变映射) |
| Reverse (gradient map) | 反向 |

## Camera Raw 滤镜(Camera Raw)

| 英文 | 中文 |
| --- | --- |
| Light / Color / Effects / Curve / Color Mixer / Color Grading / Detail / Optics / Geometry / Calibration | 浅色 / 颜色 / 效果 / 曲线 / 色彩混合 / 颜色分级 / 细节 / 光学 / 几何 / 校准 |
| Histogram | 直方图 |
| Vectorscope | 矢量示波器 |
| R %lld G %lld B %lld | R %lld G %lld B %lld |
| Shadow Clipping Indicator / Highlight Clipping Indicator | 阴影裁切指示器 / 高光裁切指示器 |
| White Balance | 白平衡 |
| Exposure / Contrast / Highlights / Shadows / Whites / Blacks | 曝光 / 对比度 / 高光 / 阴影 / 白色 / 黑色 |
| Temperature / Tint / Vibrance / Saturation | 色温 / 色调 / 自然饱和度 / 饱和度 |
| Texture / Clarity / Dehaze | 纹理 / 清晰度 / 去雾 |
| Glow / Vignette / Grain | 光晕 / 暗角 / 颗粒 |
| Style (Glow/Vignette) | 样式 |
| Range / Spread / Warmth | 范围 / 扩散宽度 / 暖度 |
| Midpoint / Roundness / Feather / Highlights | 中点 / 圆度 / 羽化 / 高光 |
| Curve page: Parametric / Point | 参数曲线 / 点 |
| Mixer page: HSL / Color / Point Color | HSL / 颜色 / 点颜色 |
| Mixer tab: Hue / Saturation / Luminance | 色相 / 饱和度 / 亮度 |
| Mixer shift/range: Hue Shift / Saturation Shift / Luminance Shift / Hue Range / Saturation Range / Luminance Range | 色相偏移 / 饱和度偏移 / 亮度偏移 / 色相范围 / 饱和度范围 / 亮度范围 |
| Grading pages: Three-Way / Shadows / Midtones / Highlights / Global | 三向 / 阴影 / 中间调 / 高光 / 全局 |
| Grading: Blending / Balance | 颜色分级:混合 / 平衡 |
| Process Version 1–6 | 处理版本 1–6 |
| Sharpening / Noise Reduction | 锐化 / 降噪 |
| Amount / Radius / Detail / Masking | 数量 / 半径 / 细节 / 蒙版处理 |
| Luminance Detail / Luminance Contrast | 亮度细节 / 亮度对比 |
| Color Detail / Color Smoothness | 颜色细节 / 颜色平滑度 |
| Manual (Optics) | 手动 |
| Remove Chromatic Aberration | 去除色差 |
| Enable Lens Profile Corrections | 启用镜头配置文件校正 |
| Distortion / Vignetting | 畸变 / 暗角 |
| Defringe | 去紫边 |
| Purple Amount / Purple Hue / Green Amount / Green Hue | 紫色数量 / 紫色色相 / 绿色数量 / 绿色色相 |
| Upright: Off / Guided | 校正:关闭 / 引导 |
| Projection: Perspective / Rectilinear | 投影:透视 / 矩形 |
| Vertical / Horizontal / Rotate / Aspect | 垂直 / 水平 / 旋转 / 纵横比 |
| Offset X / Offset Y | X 偏移 / Y 偏移 |
| Scale | 缩放 |
| Constrain Crop | 限制裁剪 |
| Draw Guides / Clear Guides | 绘制参考线 / 清除参考线 |
| Lock Guides | 锁定参考线 |
| Tint (Calibration) | 色调 |
| Red Primary / Green Primary / Blue Primary | 红色原色 / 绿色原色 / 蓝色原色 |
| Camera Raw section eye icons (Show/Hide X) | 通过 L("Hide %@") / L("Show %@") 拼接 |

## 混合模式 (Layer Blend Mode)

| 英文 | 中文 |
| --- | --- |
| Normal | 正常 |
| Darken | 变暗 |
| Multiply | 正片叠底 |
| Color Burn | 颜色加深 |
| Linear Burn | 线性加深 |
| Lighten | 变亮 |
| Screen | 滤色 |
| Color Dodge | 颜色减淡 |
| Linear Dodge (Add) | 线性减淡(添加) |
| Overlay | 叠加 |
| Soft Light | 柔光 |
| Hard Light | 强光 |
| Vivid Light | 亮光 |
| Linear Light | 线性光 |
| Pin Light | 点光 |
| Hard Mix | 实色混合 |
| Difference | 差值 |
| Exclusion | 排除 |
| Subtract | 减去 |
| Divide | 划分 |
| Hue | 色相 |
| Saturation | 饱和度 |
| Color | 颜色 |
| Luminosity | 亮度 |

## 选区工具 (Marquee / Lasso / Wand)

| 英文 | 中文 |
| --- | --- |
| New (SelectionMode) | 新建 |
| Add (SelectionMode) | 添加 |
| Subtract (SelectionMode) | 减去 |
| Rectangle / Ellipse (Marquee) | 矩形 / 椭圆 |
| Freehand / Polygonal (Lasso) | 徒手 / 多边形 |
| Wand / Object (Wand modes) | 魔棒 / 对象 |
| Point Sample (Wand) | 点采样 |
| This Layer / All Layers (Wand sample scope) | 当前图层 / 所有图层 |
| Contiguous | 连续 |
| Anti-alias | 抗锯齿 |
| Tolerance | 容差 |
| Edge (Object Selection) | 边缘 |
| Fuzziness | 容差 |
| Select %@ | 选择 %@ |
| Sample Size: Point Sample / 3 by 3 Average / 5 by 5 Average | 采样大小:点采样 / 3×3 平均 / 5×5 平均 |
| Show Rulers / Show Controls | 显示标尺 / 显示控件 |
| Auto Select | 自动选择 |
| Sample Ring | 取样环 |

## 形状 / 渐变 / 文字工具

| 英文 | 中文 |
| --- | --- |
| Rectangle / Ellipse / Line (Shape kinds) | 矩形 / 椭圆 / 直线 |
| Linear / Radial (Gradient shape) | 线性 / 径向 |
| Foreground to Transparent | 前景到透明 |
| Fill mode | 填充模式 |
| Gradient style | 渐变样式 |
| Add stop / Remove stop | 添加节点 / 删除节点 |
| Stop color / Stop opacity / Stop position | 节点颜色 / 节点不透明度 / 节点位置 |
| Color stops | 颜色节点 |
| Anchor | 锚点 |
| Shear | 倾斜 |
| Flip H / Flip V | 水平翻转 / 垂直翻转 |
| Tracking / Leading | 字距 / 行距 |
| Bold / Italic | 加粗 / 斜体 |
| Underline | 下划线 |
| Color (text) | 颜色 |
| Edit Text | 编辑文字 |

## 颜色选择器

| 英文 | 中文 |
| --- | --- |
| Color Picker | 颜色选择器 |
| Foreground Color | 前景颜色 |
| Background Color | 背景颜色 |
| Text Color | 文字颜色 |
| Vignette Color | 暗角颜色 |
| Gradient Map Highlights | 渐变映射高光 |
| Gradient Map Shadows | 渐变映射阴影 |
| Dither Light Color / Dither Dark Color | 抖动亮色 / 抖动暗色 |
| Click the canvas to sample | 点击画布以取色 |
| New color | 新颜色 |
| Saturation and brightness | 饱和度与亮度 |
| Hex / Hex color | 十六进制 / 十六进制颜色 |
| degrees | 度 |
| R / G / B (channel rows) | 红 / 绿 / 蓝 |

## 画布 / 标尺 / 单位 / 网格

| 英文 | 中文 |
| --- | --- |
| Width / Height | 宽度 / 高度 |
| Pixels / Centimeters / Millimeters / Inches / Percent | 像素 / 厘米 / 毫米 / 英寸 / 百分比 |
| Units | 单位 |
| Resolution | 分辨率 |
| DPI | DPI |
| 1080p / 1440p / 4K / YouTube Thumb / iPhone 18 Pro | 1080p / 1440p / 4K / YouTube 缩略图 / iPhone 18 Pro |
| Show Grid / Show Guides / Show Rulers | 显示网格 / 显示参考线 / 显示标尺 |
| Grid Color | 网格颜色 |
| Gridline every | 网格线间距 |
| Subdivisions | 细分 |
| Dashed Lines / Lines / Dots | 虚线 / 实线 / 点线 |
| Light Gray / Light Red / Medium Blue / Yellow / Magenta / Cyan / Black | 浅灰 / 浅红 / 中蓝 / 黄色 / 洋红 / 青色 / 黑色 |
| Custom (grid preset) | 自定义 |
| Vertical / Horizontal | 垂直 / 水平 |
| Top / Center / Bottom | 顶部 / 居中 / 底部 |
| Left / Right / Center | 左对齐 / 居中对齐 / 右对齐 |
| Top Left / Top Right / Middle Left / Middle Right / Bottom Left / Bottom Right | 左上 / 右上 / 左中 / 右中 / 左下 / 右下 |
| Snapping | 对齐 |
| Snap To | 对齐到 |
| Snap | 对齐 |

## 调整(色阶 / 曲线 / 色相饱和度 / 色彩范围)

| 英文 | 中文 |
| --- | --- |
| Channel | 通道 |
| RGB / Red / Green / Blue | RGB / 红 / 绿 / 蓝 |
| Master / Reds / Yellows / Greens / Cyans / Blues / Magentas | 全图 / 红色 / 黄色 / 绿色 / 青色 / 蓝色 / 洋红 |
| Lightness (Hue/Sat) | 亮度 |
| Colorize | 着色 |
| Input / Output | 输入 / 输出 |
| Input black / Input white / Output black / Output white | 输入黑场 / 输入白场 / 输出黑场 / 输出白场 |
| Loading histogram… | 直方图加载中… |
| Histogram (button) / histogram (label) | 直方图(按钮) / 直方图(标签) |
| RGB histogram | RGB 直方图 |
| histogram | 直方图 |
| Original (a11y prefix) | 原始 |
| Underlying pixels · alpha-weighted histogram | 底层像素 · 基于 alpha 加权的直方图 |
| Original pixels · alpha-weighted histogram | 原始像素 · 基于 alpha 加权的直方图 |
| Original pixels · selection and alpha-weighted histogram | 原始像素 · 选区与 alpha 加权的直方图 |
| Click to add a point. Drag to adjust. | 点击添加一个控制点;拖动以调整。 |
| Input %lld · Output %lld | 输入 %lld · 输出 %lld |
| Remove point | 删除控制点 |
| Reset curve | 重置曲线 |
| Click the original layer to set | 点击原始图层设置 |
| Click the eyedropper again to stop. | 再次点击吸管以停止。 |
| Click the image to center this range on that color | 点击图像把当前色域中心定位到该颜色 |
| Click the image to widen this range to include that color | 点击图像扩大当前色域以包含该颜色 |
| Click the image to narrow this range to exclude that color | 点击图像收窄当前色域以排除该颜色 |
| Color Range / Color Range… | 色彩范围 / 色彩范围… |
| Selection | 选区 |
| Fuzziness | 容差 |
| Invert | 反相 |
| Limited to the selection | 仅作用于选区 |
| Targeted adjustment | 定向调整 |
| Colorize (Hue/Sat) | 着色 |
| Apply outside this range instead | 反之,只作用于该范围之外 |
| Hue %lld°  %lld | 色相 %lld°  %lld |
| Shift-click adds a color, Option-click takes one away. | 按住 Shift 点击加入颜色;按住 Option 点击移除颜色。 |
| Click the image to pick the color to select. | 点击图像选择要纳入选区的颜色。 |
| Click the image to select that color | 点击图像选中该颜色 |
| Click the image to add that color to the selection | 点击图像把该颜色加入选区 |
| Click the image to take that color out of the selection | 点击图像把该颜色从选区中移除 |
| Choose the (prefix) | 选择 |

## 视图 / 缩放 / 标尺快捷键

| 英文 | 中文 |
| --- | --- |
| Actual Pixels | 实际像素 |
| Fit Canvas | 适应画布 |
| Zoom In / Zoom Out | 放大 / 缩小 |
| Space to pan | 空格平移 |
| Drag to pan | 拖动平移 |
| Pinch to zoom | 捏合缩放 |
| Shift 45° / Shift add / Tab for Wand / Delete clears / Escape cancel | Shift 锁定 45° / Shift 添加 / Tab 切换为魔棒 / Delete 清除选区 / Escape 取消 |
| ⌥⌫/⌘⌫ fill / ⌘D deselect | ⌥⌫/⌘⌫ 填充 / ⌘D 取消选择 |

## 选区修改 / 变换菜单

| 英文 | 中文 |
| --- | --- |
| Expand / Expand… | 扩展 / 扩展… |
| Contract / Contract… | 收缩 / 收缩… |
| Feather / Feather… | 羽化 / 羽化… |
| Deselect / Reselect / Inverse | 取消选择 / 重新选择 / 反选 |
| Transform | 变换 |
| Rotate | 旋转 |
| Crop | 裁剪 |
| Trim / Trim… | 裁剪 / 裁剪… |
| Based On | 依据 |
| Transparent Pixels | 透明像素 |
| Top Left Pixel Color / Bottom Right Pixel Color | 左上角像素颜色 / 右下角像素颜色 |
| Free / Original / 1:1 / 4:3 / 3:4 / 16:9 / 9:16 | 自由 / 原始 / 1:1 / 4:3 / 3:4 / 16:9 / 9:16 |
| Trim Away | 裁去 |

## 状态栏 / 提示

| 英文 | 中文 |
| --- | --- |
| Showing | 显示 |
| Zoom | 缩放 |
| Drag to crop / Drag to draw / Drag to move / Drag to erase / Drag to paint / Drag to clone / Drag to smudge / Drag to soften / Drag to select | 拖动裁剪 / 拖动绘制 / 拖动移动 / 拖动擦除 / 拖动绘制 / 拖动仿制 / 拖动涂抹 / 拖动柔化 / 拖动以框选 |
| Nudge %@ 1 px | 向 %@ 微移 1 像素 |
| Click corners | 依次单击各角点 |
| Tab for Wand | Tab 切换为魔棒 |
| Hold to pan / Hold to repeat / Hold to draw | 按住平移 / 按住重复 / 按住绘制 |

## 性能 / 渲染 / 状态

| 英文 | 中文 |
| --- | --- |
| Working… / Applying… / Importing… / Updating… | 正在处理… / 正在应用… / 正在导入… / 正在更新… |
| Warnings | 警告 |
| Converted | 已转换 |
| Dropped | 已丢弃 |
| Keep Mine | 保留我的版本 |
| Clipped to %@ | 剪贴自 %@ |
| Layer effect | 图层效果 |
| Layer effects | 图层效果 |
| Edit %@. | 编辑 %@。 |

## 画布 / 新建

| 英文 | 中文 |
| --- | --- |
| Create canvas | 创建画布 |
| Create a canvas or import an image. | 新建画布或导入图像 |
| Import an image or add a blank layer. | 导入图像或新建空白图层 |
| Transparent canvas / White canvas / Black canvas | 透明画布 / 白色画布 / 黑色画布 |
| Background | 背景 |
| New Blank Layer | 新建空白图层 |
| New adjustment layer | 新建均匀调整图层 |

## 文件 / 项目名

| 英文 | 中文 |
| --- | --- |
| Untitled | 未命名 |
| No layers yet | 还没有图层 |
| Close Project | 关闭项目 |
| Open Project | 打开项目 |
| Project tabs | 项目标签 |

## 键盘快捷键 / 命令面板

| 英文 | 中文 |
| --- | --- |
| Keyboard Shortcuts | 键盘快捷键 |
| Press keys… | 请按组合键… |
| Search… | 搜索… |
| Menus | 菜单 |
| Clear Menu | 清除菜单 |

## 窗口 / 工具栏

| 英文 | 中文 |
| --- | --- |
| Window | 窗口 |
| Tools / Toolbar | 工具 |
| Pan | 平移 |

## 应用程序 / 元数据

| 英文 | 中文 |
| --- | --- |
| Compositor | Compositor |
| Select %@: %@ | 选择%@:%@ |
| Add to %@ | 添加到 %@ |
| Develop %@ | Develop %@ |
| Tool › %@ | 工具 › %@ |
| Hide Others | 隐藏其他 |
| Services | 服务 |

## 翻译字典维护

新增术语请同步到本文件,避免下一轮扫字段时漏掉或者重复命名。`.xcstrings` 的 key 与本表 key 完全对齐,顺序可不同,但拼写/大小写必须完全一致(`Localizable.xcstrings` 对大小写敏感)。

rawValue 始终用英文(`.comp` 序列化、NSMenuItem.representedObject、raw enum key 都需要稳定),中文只出现在 `localizations.zh-Hans.stringUnit.value`。