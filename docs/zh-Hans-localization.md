# Compositor zh-Hans 本地化批次日志

fork `Chenjinteng/Compositor_zh_CN.git` 的 `zh_cn` 分支在 C-17 merge `22c7b8d` 后基于上游 `22c7b8d` (Compositor 1.4.8)。`MARKETING_VERSION = 1.4.8_zh`,tag `1.4.8_zh` 指向 C-17 后的 HEAD。

每条 batch 是 fork 上一个独立 commit,保持单次审阅粒度。

## 公共基础设施

所有 UI 字面量通过 `Bundle.main.localizedString(forKey:value:table:)` 解析,顶层 helper `func L(_ key: String) -> String` 定义在 `Compositor/ContentView.swift`。enum 通过 `var localizedName: String` 用同样的 Bundle lookup 模式(`rawValue` 留英文做 `.comp` 序列化 / undo 名 / NSMenuItem.representedObject 稳定 key)。

`Compositor/Localizable.xcstrings` 是 String Catalog 格式,`sourceLanguage: en`,`version: 1.1`,每个 key 同时有英文 rawValue 和 `zh-Hans` 翻译。

术语对齐见 [`docs/zh-Hans-glossary.md`](zh-Hans-glossary.md)。

## Batch C-9 — fork 初始化 (`9a5222b`)

首次把 zh_cn fork 拉到 1.4.7_zh 跑通的状态。

- Personal Team 签名 + 全套枚举 `localizedName` 模式
- 状态栏 / NP / 工具栏全面汉化
- `CompositorApplicationDelegate.applicationWillFinishLaunching` 写 `UserDefaults["AppleLanguages"] = ["zh-Hans"]` 强制锁定
- `MARKETING_VERSION = 1.4.7_zh`(后被 batch C-12 改回 `1.4.6_zh`)

## Batch C-10 — 大批量 enum picker + 图层面板 (`381a74c`)

31 files, +622 / −91。`.xcstrings` 922 → 1094 keys。

- 22 个 enum 加 `localizedName`:`CanvasUnit` / `LevelsChannel` / `LayerSampling` / `ColorRange` / `BackgroundQuality` / `DitherStyle` / `DitherPixelShape` / `DitherColors` / `CameraRawWhiteBalance` / `CameraRawGlowStyle` / `CameraRawVignetteStyle` / `CameraRawUprightMode` / `CameraRawProjection` / `CameraRawProcessVersion` / `CameraRawCurvePage` / `CameraRawPointChannel` / `CameraRawMixerPage` / `CameraRawMixerTab` / `CameraRawGradePage` / `GridAppearance.Preset` / `GridAppearance.Style` / `TrimBasedOn` + `CameraRawControls.Section`(私有) + `NewCanvasUnit`(别名)
- 28 处 `Text($0.rawValue)` → `Text($0.localizedName)`
- `Magic → 魔棒`(用户原话"不要叫魔法,要叫魔棒")
- `LassoControls` 工具栏标题用 `currentToolName(session:)` helper 替代 ternary
- LayersPanel trash 按钮 4 路 ternary → `layersDeleteHelp(session:)` helper
- NativeLayerList "Folder" / effect row / 调整 eye a11y 等

## Batch C-11 — Spot Healing / Color Picker / 滤镜弹窗 / 图层默认名 (`7b94779`)

10 files, +746 / −138。`.xcstrings` 1094 → 1128 keys。

- SpotHealingMode rawValues (Content-Aware/Create Texture/Proximity Match) 加中文
- `ColorPickerTarget.title` 整段重写为 Bundle lookup
- FilterSheet 全 17 个 filter case 的 slider label / tooltip / section 头 / OK-Cancel 全包 `L()`
- filterPanel.show 用 `kind.localizedName` 替 `kind.rawValue`
- ColorPickerSheet OK/Cancel/a11y 全 `L()`
- `LayerAdjustment.addAdjustment` 用 `kind.localizedName` 替 `kind.rawValue`
- 新加空白图层 / 文件夹 / Paste 命名走 `Layer %lld` / `Folder %lld` format string
- `PSDReader` fallback 用 format string
- File > New 的 Background 图层名本地化

## Batch C-12 — Levels / Hue-Sat / Color Range / Curves / Gradient Map / Keyboard Shortcuts (`c155bcb`)

10 files, +463 / −68。`.xcstrings` 1128 → 1163 keys。

- `LevelsSample` / `LevelsAuto` / `HueSampleMode` 加 `localizedName`
- LevelsSheet 全部 hardcode 字符串包 `L()`,histogram caption ternary → `histogramCaption()` helper
- HueSaturationSheet slider / Toggle / help 全包 `L()`
- ColorRangeSheet Fuzziness / Invert / 3 段 help 文案 包 `L()`
- CurvesControls Click to add a point / Remove point / Reset curve 包 `L()`
- GradientMapControls Shadows / Highlights / Reverse / "Choose the X color" tooltip 包 `L()`
- ContentView `panel.show(title:)`:
  - "Levels" / "Color Range" / "Hue/Saturation" → `L()`
  - `selection.kind.rawValue` → `.localizedName`(Effects 弹窗标题)
  - `operation.rawValue + " Selection"` → `.localizedName + L("Selection")`
- KeyboardShortcuts 标题 → `L()`

## Batch C-12-bis — 重命名为 `1.4.6_zh` (`2a3e71f`)

`MARKETING_VERSION = 1.4.6_zh`(6 处,Compositor/Tests/UITests × Debug/Release)。旧 tag `1.4.7_zh` 本地 + 远端删除。新 tag `1.4.6_zh` 在 `2a3e71f` 创建并 push。

## Batch C-13 — Layer Blend Mode + Camera Raw 整面板 (`2aa3eea`)

7 files, +488 / −236。`.xcstrings` 1140 keys(经过去重)。

- `LayerBlendMode.localizedName` 加 Bundle lookup
- `BlendModePicker` NSPopUpButton:
  - `NSMenuItem(title:localizedName, action:nil, keyEquivalent:"")` 直接构造
  - `representedObject` 存 `rawValue` 让 selection / highlight 查找稳定跨语言
  - 修 SDK 27 `NSMenu.addItem(withTitle:)` 重载为 `withTitle:action:keyEquivalent:`,必须先构造 NSMenuItem
- Camera Raw 4 个文件全部 hardcode 字符串包 `L()`(worker 批量):
  - `CameraRawControls.swift`:Histogram / Vectorscope 菜单 + Light/Color/Effects 段 16+ slider + 全部 tooltip + eye 图标 Hide/Show 模板
  - `CameraRawColorControls.swift`:Curve (参数/点 + 预设 + 4 个 amount + Selected 点读数) + Mixer (HSL/Color/Point Color + 色轮 + Targeted Adjustment) + 3 个 color slider + 3 个 range slider + Grading 三向/全局 + Blending/Balance + 色轮 tooltip
  - `CameraRawDetailOpticsControls.swift`:Sharpening (数量/半径/细节/蒙版) + Noise Reduction (明度 + Color 及其 6 个 sub-slider) + Optics toggles + Profile 校正 + 手动 Distortion + Defringe Purple/Green + Vignetting/Midpoint + `hueRange()` 加 `isPurple: Bool` 参数(因为 `title.contains("Purple")` 不再命中本地化标题)
  - `CameraRawGeometryCalibrationControls.swift`:Upright (Off/Guided) + Draw Guides + Clear Guides + Projection + 7 个 geometry slider + Constrain Crop + Calibration Process Version 1-6 + Shadows Tint + Red/Green/Blue Primary Hue/Saturation + 全部 tooltip

## Batch C-14 — 图层右键菜单 + 裁剪比例下拉 (`e972751`)

2 files, +21 / −21。`.xcstrings` 1140 keys 不变(本轮全部用的已有条目)。

- NativeLayerList 右键菜单 19 项全包 `L()`:Duplicate Layer / Rename… / Delete Layer / Delete Selected Layers / Delete Mask / Create Clipping Mask / Release Clipping Mask / Group Selected Layers / Ungroup Layers / Move Out of Folder / Add Mask (主项 + Reveal All (White) / Hide All (Black) 子菜单) / Enable Mask / Disable Mask / Link Mask / Unlink Mask / Show Layer / Hide Layer
- `menuItem.title == "Add Mask"` 状态对比改成 `L("Add Mask")`
- CropControls "Crop" / "Ratio" / "Cancel" / "Apply Crop" 全包 `L()`
- 7 个比例选项 `Text(L($0))`,rawValue 保留英文供 `session.cropRatioChoice` 持久化 + `Crop.swift` switch

## Batch C-15 — merge upstream 1.4.7 + 1.4.7 新命令字符串汉化 (`0e6de02`)

合并上游 `af30c45` (Compositor 1.4.7) + 给 1.4.7 新增的命令/UI 字符串上 zh-Hans 翻译。先 merge commit `6095890` 解决冲突,再 C-15 commit 跑汉化。

- `MARKETING_VERSION` 从 `1.4.6_zh` → `1.4.7_zh`(pbxproj 6 处)
- bundle ID 仍是 `cn.jintengchen.compositor[.tests|.uitests]`(保留 fork 身份)

### 合并冲突 8 处解决 (`6095890` Merge upstream 1.4.7 into zh_cn)

- `project.pbxproj`:6 段 `MARKETING_VERSION` + `PRODUCT_BUNDLE_IDENTIFIER` 冲突,保留 fork 标识 + 改成 `1.4.7_zh`
- `IO/CompositorApplicationDelegate.swift`:保留 fork 的 `UserDefaults["AppleLanguages"] = ["zh-Hans"]` 锁定,同时把内部 helper 从 `removeSystemTextItems` 改名为 `removeSystemExtras`(1.4.7 commit 的同步)
- `IO/ProjectController.swift`:保留 fork 的 `String(localized: "Save changes to %@?", ...)` 包装,但补进 1.4.7 commit `283d360` 的 `dontSaveButton.hasDestructiveAction = true`
- `UI/BrushControls.swift` / `UI/GradientControls.swift` / `UI/LassoControls.swift`:采纳 1.4.7 commit `68396ff` 的 `ScrollView(.horizontal)` 包裹让 tool header 窄窗滚动;picker Text 仍走 `.localizedName`(zh_cn 的 C-10 改成),title 仍走 zh_cn 的 `currentToolName(session:)` helper
- `UI/LayersPanel.swift`:采纳 1.4.7 `790195f` / `7fb40a9` 的 `FooterIcon` helper,但保留 `L(...)` 包装 + `layersDeleteHelp(session:)` zh_cn helper
- `README.md`:同步 1.4.7 README:命令面板 → 搜索命令,画布专屏(F)→ 切换全屏(F, Esc 也退出),新增"上次滤镜(⌃⌘F)"一行
- `.gitignore`:加 `default.profraw` 和 `outputs/`(`.comp` 调试产物 + LLVM profile 文件)

merge 后 `xcodebuild -scheme Compositor -destination 'platform=macOS' build` 已验证 `BUILD SUCCEEDED`。

### 1.4.7 新字符串汉化 (`0e6de02` Batch C-15)

`.xcstrings` 1140 → 1146 keys。新增 6 条:

| key | zh-Hans | 说明 |
| --- | --- | --- |
| `Search Commands…` | `搜索命令…` | View 菜单的 Command Palette (⌘F),1.4.7 改名 |
| `Search Commands` | `搜索命令` | KeyboardShortcuts sheet 行标题 |
| `Toggle Fullscreen` | `切换全屏` | View 菜单的 Toggle (F) |
| `Toggle Fullscreen: the canvas alone on black (Esc also leaves)` | `切换全屏:仅画布浮于黑底(Esc 也退出)` | KeyboardShortcuts sheet 描述 |
| `Last Filter` | `上次滤镜` | Filter 菜单项,无 last filter 时 fallback |
| `Last Filter: %@` | `上次滤镜:%@` | Filter 菜单项,有 last filter 时插名字 |

源码改动 3 个文件:

- `IO/CompositorApp.swift`(View 菜单 `Search Commands…` / `Toggle Fullscreen`):从 SwiftUI 字面量 (`Button("xxx")`) 改成 `Button(L("xxx"))`,zh_cn 的 helper 模式统一
- `IO/CompositorApp.swift`(Filter 菜单 `Last Filter`):`session.lastFilter.map { "Last Filter: " + $0.rawValue }` 改成 `String(format: String(localized: "Last Filter: %@"), $0.localizedName)`,rawValue 直接喂 `\u003c0.placeholder\u003e`,`localizedName` 让插值也走 catalog
- `UI/KeyboardShortcuts.swift`:`Text(definition.title)` → `Text(L(definition.title))`,以及 `Text(group)` → `Text(L(group))`,搜索过滤 `$0.title.localizedCaseInsensitiveContains(search)` → `L($0.title).localizedCaseInsensitiveContains(search)`
- `UI/CommandPaletteView.swift`(1.4.7 全新文件,merge 进来的):`skipped: Set<String>` 在 static init 时对每个 key 做一次 `Bundle.main.localizedString(forKey:value:table:)`,让 skip 列表和 SwiftUI 在用户机器上实际渲染的 NSMenuItem.title 匹配(中文 fork 下 `"Search Commands…"` → `"搜索命令…"`)

## Batch C-16 — merge upstream 1.4.8 (`35fb68c`)

合入上游 `22c7b8d` (Compositor 1.4.8) — 22 个 commit、80 个文件、新增 7 个。

- `MARKETING_VERSION` 1.4.7_zh → 1.4.8_zh
- bundle ID 仍是 `cn.jintengchen.compositor[.tests|.uitests]`

### 冲突 8 处解法

- `project.pbxproj`:6 段同 1.4.7,改 `1.4.8_zh`
- `README.md`:跟 1.4.8 加 Dither/Scanlines 一条 + Navigator 缩略导航一段 + Export As(⇧⌥⌘W)一行;同时**保留 fork 自己的"## 构建"段**,删除上游新加的"## Translations on hold"段(fork 本来就是本地化版,不需要那段"can't accept PRs"的免责声明)
- `IO/ProjectController.swift`:**完全接受 upstream 一侧** — 1.4.8 把 `exportJPEG` 整函数替换为 `exportAs(start:)` 走 `ExportAsSheet`,所有 panel title 从 `String(localized:)` 改回普通字符串(后续 C-17 用 `String(format: String(localized:))` + `L()` 重做),`showError` 的 `LocalizedStringResource` 签名也回退到 `String`。Don't Save 不再 `hasDestructiveAction = true`(1.4.8 commit `4e035bf` 改了样式 — 改为按钮颜色统一为 destructive 风格而非显式标 destructive)
- `Document/ColorPalette.swift`:接受 upstream 一侧 — `ColorPickerTarget.title` 改成 `return "Color Picker (xxx)"` 直出,移除了 zh_cn 之前 Batch C-10 加的 Bundle lookup 路径
- `Document/Dither.swift`:接受 upstream 一侧 — 1.4.8 把 `case scanlines = "Scanlines (CRT)"` 从 DitherStyle 拆出,Scanlines 变成独立 filter;同时 upstream 整体移除了 `DitherStyle.localizedName` / `DitherPixelShape.localizedName` / `DitherColors.localizedName`(原文 zh_cn C-10 加的)
- `UI/FilterSheet.swift`:接受 upstream 一侧的 `scanlinesControls` 不变(zh_cn 1.4.7 在 DitherStyle 里塞的 Scanlines 控件被 1.4.8 抽到独立 scanlinesControls 段)。**修编译错**:`Text($0.localizedName)` 因为 DitherStyle 没有 localizedName,改成 `Text(L($0.rawValue))` 让 Picker 仍然走 String Catalog
- `UI/LayersPanel.swift`:接受 upstream 一侧 — 1.4.8 改回 `kind.rawValue` 显示,FooterIcon → `Image+footerHitArea()` 反复翻转,`canEditLayers` → `layersLookEditable`

merge 后 `xcodebuild -scheme Compositor -destination 'platform=macOS' build` 已验证 `BUILD SUCCEEDED`。

### 1.4.8 新增 .swift 文件

- `Document/EditorSession+Navigator.swift`(无字面量)
- `Document/Scanlines.swift`(无 UI 字面量,纯计算)
- `Rendering/NavigatorGeometry.swift`(无字面量)
- `UI/NavigatorMinimap.swift`(accessibilityLabel "Navigator")
- `UI/ExportAsSheet.swift`(全 sheet)
- `scripts/ExportOptions.plist`(无翻译)

## Batch C-17 — 1.4.8 新功能字符串汉化 (`8227a83`)

`.xcstrings` 1146 → 1175 keys。新增 29 条汉化主要用于 3 处新 UI:Export As 弹窗、Scanlines filter 控件、Navigator 菜单。

### Export As sheet (`UI/ExportAsSheet.swift`)

入口:File › Export As…(⇧⌥⌘W)。之前 zh_cn 有单独的 Export JPEG 弹窗,1.4.8 合并为 ExportAsSheet 支持 PNG / JPEG / 一页 PDF。

- Sheet title: `Export As` → `导出为`
- Row labels: `Format` → `格式` / `Size` → `大小` / `Quality` → `质量` / `Page` → `页面` / `Background` → `背景`
- Size × Width/Height help → `像素宽度/高度`,高度/宽度按比例自动调整
- Scale menu help → `按此比例导出:文档本身保持不变`
- Background row → `Color that fills transparent areas` → `用于填充透明区域`;swatch title `Export Background` → `导出背景`
- Status text: `Updating…` → `正在更新…`
- Footer: PNG case → `Transparency kept · sRGB` → `保留透明度 · sRGB`;其他 case → `sRGB`(不动)
- Buttons: `Cancel` → `取消`(已有) / `Export…` → `导出…`
- Zoom: `Fit` → `适应`(已有) / `Show the whole image (⌘0)` → `显示完整图像(⌘0)`
- PDF readout: `"%@ × %@ in at %d DPI"` 改成 `String(format: String(localized: "%@ × %@ in at %d DPI"), ...)` 走 catalog → `"%@ × %@ 英寸,%d DPI"`

注:zoom 的 `Zoom in (\u{2318}+), now %@. At 100%...` / `Zoom out (\u{2318}−), now %@` 用了 SwiftUI 字符串 interpolation + `LocalizedStringKey` 自动 catalog,留给英文(要本地化需要把 percent 用 `Text(...)` 拼接 + 双 `.help`,改动太大)。

### Scanlines filter (`UI/FilterSheet.swift scanlinesControls`)

1.4.8 把 1.4.7 嵌在 DitherStyle 里的 Scanlines 选项拆出来做独立 filter 单独 13 个控件 + tooltip。

| key | zh-Hans |
| --- | --- |
| `Line Spacing` | `行距`(已有) |
| `Thickness` | `线条粗细` |
| `Glow` | `光晕`(已有) |
| `Dots` | `点线`(已有) |
| `Displace` | `形变幅度` |
| `Smoothness` | `平滑度` |
| `Threshold` | `暗部阈值` |
| `Wobble` | `抖动`(已有) |
| `Color Split` | `色散距离` |
| `Density` | `浓度`(已有) |
| `Contrast` | `对比度`(已有) |
| `Black Level` | `底色亮度` |

对应的 9 条 `.help()` tooltip 全部加了:`扫描线之间的间距` / `亮线占间隙的多少;暗部画得更细` / `扫描线周围的光晕,像 CRT 荧光粉的发光` / `比这更暗的部分把线条断成圆点,更亮的位置就连成实线` / `画面亮的地方把线抬起来,负值往下沉,让线条鼓进画面的轮廓` / `形变前亮度的平滑程度,从锐利的山脊到圆润的土丘` / `比这更暗的位置不画线,保持画面成暗屏` / `让线条沿屏幕向下左右抖动,像 CRT 失同步的画面` / `把红蓝通道左右分开,在扫描线上形成彩色边缘` / `扫描线绘制前的整体明暗` / `纯黑处扫描线的亮度,这样黑画面也能看到线`。

FilterKind 新加 `case scanlines = "Scanlines"` 的 xcstrings key:`扫描线`(替代 1.4.7 的 `Scanlines (CRT) → 扫描线(CRT)`,rawValue 改成 `Scanlines`)。

### Navigator (`UI/NavigatorMinimap.swift`, `IO/CompositorApp.swift`)

- View menu: `Toggle("Navigator (300% and above)")` → `Toggle(L("Navigator (300% and above)"))` → `导航(300% 及以上)`
- 缩略图的 `.accessibilityLabel("Navigator")` → `L("Navigator")` → `导航`

### 本批未覆盖的 1.4.8 字面量(留作后续 batch)

1.4.8 上游 `Dither.swift` 中把 `DitherStyle.localizedName` / `DitherPixelShape.localizedName` / `DitherColors.localizedName` 都删了 — 但 `FilterSheet.swift` 里 `ForEach(DitherStyle.groups[group], ...) { Text($0.localizedName) }` 这种写法现在编译不过。1.4.8 merge 时已临时改成 `Text(L($0.rawValue))`,后续 batch C-18+ 可以重新给 3 个 enum 加回 `var localizedName` 让 zh_cn 风格保持一致。

类似回退:1.4.8 上游很多文件去掉了 `L()` 包装 + `localizedName`,`LayersPanel.swift` 的 `Text("Layers")` / `Text(kind.rawValue + "…")` / `Image + footerHitArea()` 都是。需要的后续 batch 一个一个修。

合并上同样影响:`DOC/ColorPalette.swift` 的 `ColorPickerTarget.title` 已经改为 `"Color Picker (xxx)"` 格式;`exportJPEG()` 整体被替换为 `exportAs()`.后续 batch 给这些加 zh-Hans 包装。

### 当前状态

- fork: `git@github.com:Chenjinteng/Compositor_zh_CN.git`
- branch: `zh_cn` HEAD = `8227a83`
- tag: `1.4.8_zh` → `8227a83`
- `MARKETING_VERSION = 1.4.8_zh`
- `.xcstrings` 1175 keys
- DMG: `dist/Compositor-1.4.7_zh.dmg` (6.84 MB;1.4.8_zh DMG 尚未打)
- 签名: Authority `Apple Development: chenjinteng_in_92@hotmail.com (FDQLLU43U7)` TeamIdentifier `FJYQT2JA5U`(Personal Team)

## 已知未本地化

- macOS 系统色板(`NSColorPanel`)由系统提供
- App 主菜单 (`Untitled` 标题栏 / 系统菜单名)走 AppKit,需要 Info.plist 加 `CFBundleName` 本地化版本
- PSD 文件名 / 导入文件名直接来自用户文件
- 主窗口 "Untitled" 在状态栏上方,系统渲染
- Pixel 数值 (如直方图下方 "R 123 G 45 B 200" 的数字部分)不翻译,只翻译格式/单位
- `.comp` 序列化里的 layer name 不自动翻译(新建的图层名走 `Layer %lld`/`Folder %lld` format string,旧的 .comp 文件保留原文)

## 流水线参考

```bash
# 全量 build(本机)
zsh scripts/release.sh
# 等价步骤:rm -rf ~/Library/Caches/CompositorRelease-zh-CN + xcodebuild archive + create-dmg + codesign
# 产物:~/Library/Caches/CompositorRelease-zh-CN/Compositor.xcarchive/Products/Applications/Compositor.app
#     + dist/Compositor-1.4.6_zh.dmg

# 装到 /Applications
rm -rf /Applications/Compositor.app
cp -R ~/Library/Caches/CompositorRelease-zh-CN/Compositor.xcarchive/Products/Applications/Compositor.app /Applications/Compositor.app

# 验证
plutil -convert xml1 -o - /Applications/Compositor.app/Contents/Resources/zh-Hans.lproj/Localizable.strings | grep -c '<key>'
# 应回 1140

plutil -extract CFBundleShortVersionString raw /Applications/Compositor.app/Contents/Info.plist
# 应回 1.4.6_zh

codesign -d --verbose=4 /Applications/Compositor.app | grep -E 'Authority|TeamIdentifier'
# Authority=Apple Development: chenjinteng_in_92@hotmail.com (FDQLLU43U7)
# TeamIdentifier=FJYQT2JA5U
```

签名 cert 7 天过期(Apple Development 是 Personal Team 限时),首次启动会弹 Apple Events / 网络摄像头权限,AppleLanguages 写入需要在 `applicationWillFinishLaunching` 早期。

## 已知踩坑

- `Bundle.main.localizedString(forKey:value:table:)` 是 runtime catalog 查询的唯一路径,`String(localized:defaultValue:)` 只接 `StaticString`
- `Text(String)` / `TextField(_ title: String, ...)` 走 verbatim,必须先 `Bundle.localizedString` 再 `LocalizedStringKey` 包裹,或走 enum `.localizedName` → `Text($0.localizedName)`(verbatim 也行因为内容已是中文)
- `NSMenu.addItem(withTitle:)` 在 SDK 27 解析为 `addItem(withTitle:action:keyEquivalent:)`,必须先 `NSMenuItem(title:action:keyEquivalent:)` 构造再 `menu.addItem(item)`
- Personal Team cert 不能用上游 `com.wonderassembly.compositor` Bundle ID(已注册),fork 用 `cn.jintengchen.compositor[.tests|.uitests]`
- 真 Team ID 在 cert Subject **OU** 字段(`FJYQT2JA5U`),cert 名字括号里 `FDQLLU43U7` 是 Team Member ID,不是 Team ID,`security find-cert -c "Apple Development" -a -Z` 后 `openssl x509 -noout -subject` 读 OU
- Trust settings `kSecTrustSettingsResult = 2 (Deny)` 会让 xcodebuild 报 "Invalid trust settings",Keychain Access GUI 把 cert 信任改 Use System Default
- `MARKETING_VERSION` 改完 pbxproj 后,`CFBundleShortVersionString` 由 xcodebuild 自动注入;手改 Info.plist 不生效