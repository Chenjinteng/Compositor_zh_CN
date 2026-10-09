# Compositor zh-Hans 本地化批次日志

fork `Chenjinteng/Compositor_zh_CN.git` 的 `zh_cn` 分支在 C-15 merge `af30c45` 后基于上游 `af30c45` (Compositor 1.4.7)。`MARKETING_VERSION = 1.4.7_zh`,tag `1.4.7_zh` 指向 C-15 后的 HEAD。

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

### 当前状态

- fork: `git@github.com:Chenjinteng/Compositor_zh_CN.git`
- branch: `zh_cn` HEAD = `0e6de02`
- tag: `1.4.7_zh` → `0e6de02`
- `MARKETING_VERSION = 1.4.7_zh`
- `.xcstrings` 1146 keys(merge 后 + 1.4.7 新字符串汉化后)
- DMG: `dist/Compositor-1.4.6_zh.dmg` (6.8 MB;1.4.7_zh DMG 尚未打)
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