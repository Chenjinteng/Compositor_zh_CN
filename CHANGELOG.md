# Compositor 上游更新日志

`Chenjinteng/Compositor_zh_CN` 的 `zh_cn` 分支,基于 [`robbietilton/Compositor`](https://github.com/robbietilton/Compositor) 上游 main 跟踪。每个上游 release 的"用户能看见的变化" + "对 fork 汉化的影响"汇总,链接到上游具体 commit。

fork tag 跟上游版本的对应表:

| 上游 release | 上游 publish commit | fork tag | xcstrings keys |
|---|---|---|---|
| 1.4.6 | `e64f749` | `1.4.6_zh` → `9ddee11` | 1140 |
| 1.4.7 | `675d8a4` (publish `af30c45`) | `1.4.7_zh` → `5dc435b` | 1146 |
| 1.4.8 | `24ef288` (publish `22c7b8d`) | `1.4.8_zh` → `59fa9cd` | 1175 |
| 1.4.9 | `0ab3ff5` (publish `b4bfdea`) | `1.4.9_zh` → `5e5383f` | 1184 |

---

## Compositor 1.4.9(2026-10-08)— 上游

publish commit: [`b4bfdea`](https://github.com/robbietilton/Compositor/commit/b4bfdea)

### 用户能直接看到的变化

- **WebP 导入**([#244](https://github.com/robbietilton/Compositor/pull/244)):File › Open / 拖入接受 `.webp`。导入清单里加 `WebP`
- **更新提示弹窗换样式**([`759bcbe`](https://github.com/robbietilton/Compositor/commit/759bcbe)):新版本提示从大段 release notes 改成要点列表(用 Sparkle `<changes>` 一行一项)
- **Tab 行为**([`d0ec2f3`](https://github.com/robbietilton/Compositor/commit/d0ec2f3)):空起始 Tab 跨 session 保留;Untitled 编号保持低位
- **图层效果 / 实时文字**撑过 Canvas Size / Image Size 和调整操作([#181](https://github.com/robbietilton/Compositor/pull/181),[`94e90bd`](https://github.com/robbietilton/Compositor/commit/94e90bd))
- **Camera Raw 大重构**:
  - LUT 表 3.2 MB → 1.25 MB([`7b5a592`](https://github.com/robbietilton/Compositor/commit/7b5a592))
  - 预览 5–20× 加速([`a8630e4`](https://github.com/robbietilton/Compositor/commit/a8630e4))
  - Color Grading 走 Photoshop 真 Blending([`9dac4f1`](https://github.com/robbietilton/Compositor/commit/9dac4f1))
  - Color Mixer / Calibration / Curves / Vignettes / Grading 全对齐 Photoshop([`bdfb9c2`](https://github.com/robbietilton/Compositor/commit/bdfb9c2))
  - 自适应 Contrast / Highlights / Shadows / Dehaze / Texture / Clarity / Sharpening 跟 Photoshop 接近([`75147a2`](https://github.com/robbietilton/Compositor/commit/75147a2))
  - Light / Color sliders 与 Photoshop Camera Raw Filter 一致([`57ab3bb`](https://github.com/robbietilton/Compositor/commit/57ab3bb))
- **中键缩放**([`e03923f`](https://github.com/robbietilton/Compositor/commit/e03923f)):⌘ + 中键拖动 = 缩放(Blender 风格)
- 新增文件:`CameraRawTables.swift`(+ `CameraRawTables.bin` 1.25 MB 资源)、`UpdateDriver.swift`;测试新增 `LayerEffectsSurviveTests.swift`、`MiddleButtonTests.swift`、`ProjectWorkspaceTests.swift`、`ImageImportTests.swift`

### 对 fork 汉化的影响

- **UpdateDriver** 是 1.4.9 全新 UI(替代 Sparkle 自带弹窗):`UpdateDriver.swift` 的 title / 4 个 button / 2 个 informative 模板 / suppression button title——Batch C-19 + C-19-cont. 已全部 L() wrap + xcstrings 加 8 条 zh-Hans
- **ProjectTabs** 完全重写:新的 tab bar 控件 + `Drop to open in a new canvas` / `Close %@` / `Add to %@` / `Open in a new project tab` / `New canvas (⌘N) · Drop images here for new tabs`——Batch C-19 已 L() wrap + xcstrings 加 5 条 zh-Hans
- **ColorPaletteControls** mask 模式 popover(`Mask background` / `Mask foreground` / `Black · Hide` / `White · Reveal`)+ swatch help / a11y label(`Background color` / `Foreground color`):Batch C-20 修了 String 变量传参走 verbatim 的 fallback 路径
- xcstrings 1175 → 1184 keys(+ 9 条,主要在 UpdateDriver / ProjectTabs / ColorPaletteControls)

---

## Compositor 1.4.8(2026-10-08)— 上游

publish commit: [`22c7b8d`](https://github.com/robbietilton/Compositor/commit/22c7b8d)

### 用户能直接看到的变化

- **Navigator 缩略导航**([#199](https://github.com/robbietilton/Compositor/pull/199),[`3e09948`](https://github.com/robbietilton/Compositor/commit/3e09948)):画布角落 300% 缩放以上时显示全文档小图,框出当前视野,点击或拖动定位
- **Scanlines 拆出来独立 filter**([`06c3a22`](https://github.com/robbietilton/Compositor/commit/06c3a22)):之前是 Dither 的子选项,现在 Filter › Scanlines 独立。13 个控件(Displace / Smoothness / Threshold / Color Split 等)+ 9 个 help
- **File › Export As…**([#208](https://github.com/robbietilton/Compositor/pull/208),[`450af5f`](https://github.com/robbietilton/Compositor/commit/450af5f)):统一 PNG / JPEG / 一页 PDF,带实时预览、JPEG 画质与文件大小,⇧⌥⌘W
- **图层面板 reveal**([#235](https://github.com/robbietilton/Compositor/pull/235),[`d2b8aaf`](https://github.com/robbietilton/Compositor/commit/d2b8aaf)):画布选中某图层时,图层面板里那一项高亮
- **Layers panel 不再闪灰**([`06313a9`](https://github.com/robbietilton/Compositor/commit/06313a9)):点击 / 描画时不再整体闪一下
- **Camera Raw Shadows/Highlights** 保持原色调顺序([`0b4c56c`](https://github.com/robbietilton/Compositor/commit/0b4c56c))
- **Don't Save** 按钮颜色与 Cancel 一致,Save 是唯一高亮色([`4e035bf`](https://github.com/robbietilton/Compositor/commit/4e035bf))——取代 1.4.7 显式 `hasDestructiveAction = true` 的设计
- **translations are on hold** — 上游 README 加了一段不接受翻译 PR 的说明([`cea9083`](https://github.com/robbietilton/Compositor/commit/cea9083))
- 新增文件:`NavigatorMinimap.swift`、`Document/EditorSession+Navigator.swift`、`Rendering/NavigatorGeometry.swift`、`Document/Scanlines.swift`、`UI/ExportAsSheet.swift`(替换 `JPEGExportSheet.swift`)、`Tests/CommandPaletteTests.swift`、`Tests/LastFilterTests.swift`、`Scripts/ExportOptions.plist`

### 对 fork 汉化的影响

- **ExportAsSheet** 是新文件(`UI/ExportAsSheet.swift`):Batch C-17 把所有字面量(标题 / Format / Size / Quality / Page / Background / Transparency kept · sRGB / Updating… / PDF readout `String(format: String(localized: "%@ × %@ in at %d DPI"))` 等)L() wrap + xcstrings 加 16 条
- **ScanlinesControls** 在 `FilterSheet.swift` 的独立 section:13 个控件 + 9 个 help——Batch C-17 全部 L() wrap + xcstrings 加 14 条
- **Navigator** 菜单项 + accessibility label:Batch C-17 改了 `CompositorApp.swift` + `NavigatorMinimap.swift`
- 上游 `Dither.swift` 把 `DitherStyle.localizedName` 等删了(取回原 SwiftUI `Text($0.rawValue)` 模式)——Batch C-16 在 FilterSheet 改用 `Text(L($0.rawValue))` 串回 catalog
- xcstrings 1146 → 1175 keys(+ 29 条,Export As / Scanlines / Navigator / 几个 string localized reformat)

---

## Compositor 1.4.7(2026-10-08)— 上游

publish commit: [`af30c45`](https://github.com/robbietilton/Compositor/commit/af30c45)

### 用户能直接看到的变化

- **`⇧⌘F` 上次滤镜**([#192](https://github.com/robbietilton/Compositor/pull/192),[`6b81d4a`](https://github.com/robbietilton/Compositor/commit/6b81d4a)):Filter › Last Filter,以相同参数再跑一次(Photoshop 同款)
- **`⌘F` 搜索命令**([`720c121`](https://github.com/robbietilton/Compositor/commit/720c121)):View › Search Commands…,全局命令面板搜索菜单/工具名后 Return 执行(替代 1.4.6 "Command Palette")
- **F 切换全屏**:View › Toggle Fullscreen(F 进入/退出全屏,**Esc 也能退出**——1.4.6 "Canvas Only" 的 Esc 不退出已修复)
- **图层面板按钮颜色**改用 primary 色提升可读性([`7fb40a9`](https://github.com/robbietilton/Compositor/commit/7fb40a9));disabled 状态 dim 程度跟菜单一致([`790195f`](https://github.com/robbietilton/Compositor/commit/790195f))
- **图层重命名**:`LayerCell` 改名时文本框大小不变,改用图层背景色块表达"正在编辑"([`8f7d344`](https://github.com/robbietilton/Compositor/commit/8f7d344))
- **未保存对话框**:Don't Save 标为 destructive 红色按钮(1.4.8 又改回统一色)
- **Hand 工具 / 空格平移**:拖一整段期间一直显示"握拳"手,松手才换"摊开"([`c0a1cd0`](https://github.com/robbietilton/Compositor/commit/c0a1cd0))
- **工具栏自动滚动**:宽度超过窗口时横向滚动替代挤压([`68396ff`](https://github.com/robbietilton/Compositor/commit/68396ff))
- 新增文件:`UI/CommandPaletteView.swift`、`Tests/CommandPaletteTests.swift`、`Tests/LastFilterTests.swift`

### 对 fork 汉化的影响

- `CompositorApp.swift` View 菜单 `Search Commands…` / `Toggle Fullscreen`,Filter 菜单 `Last Filter` / `Last Filter: %@`——Batch C-15 L() wrap
- `KeyboardShortcuts.swift` `Text(definition.title)` 改 `Text(L(definition.title))`,`Text(group)` 改 `Text(L(group))`,搜索过滤 `L($0.title).localizedCaseInsensitiveContains(search)`——Batch C-15
- `CommandPaletteView.swift` `skipped: Set<String>` 在 static init 时 `Bundle.main.localizedString` 一次,匹配中文 fork 下 NSMenuItem.title 实际渲染("搜索命令…/窗口/帮助/服务")——Batch C-15
- xcstrings 1140 → 1146 keys(+ 6 条:Search Commands…/Search Commands/Toggle Fullscreen/Toggle Fullscreen: .../Last Filter/Last Filter: %@)

---

## Compositor 1.4.6(2026-10-04)— 上游

publish commit: [`e64f749`](https://github.com/robbietilton/Compositor/commit/e64f749)

### 用户能直接看到的变化

- **Command Palette**([#192 之前](https://github.com/robbietilton/Compositor/commit/cb139a1)):F 打开,搜索菜单/工具,Return 执行。1.4.6 阶段是 ⌥⌘P 启动,1.4.7 改为 F 触发
- **Canvas Only 模式**([`ad4bddf`](https://github.com/robbietilton/Compositor/commit/ad4bddf)):F 进入全黑全屏仅画布(1.4.7 改名 "Toggle Fullscreen")
- **Camera Raw Color Noise Reduction** 改写([`42a559b`](https://github.com/robbietilton/Compositor/commit/42a559b),[`61ea182`](https://github.com/robbietilton/Compositor/commit/61ea182)):颜色噪点减同时保持亮度
- **RAW 导入**([`196342c`](https://github.com/robbietilton/Compositor/commit/196342c),[`6345432`](https://github.com/robbietilton/Compositor/commit/6345432)):round in C 0.6s(debug 15s),8-bit round 防止 banding
- **Image › Rotate Canvas 90°** 双向([`754f188`](https://github.com/robbietilton/Compositor/commit/754f188))
- **Layer Effects**:Add layer effect 按钮,Inner Glow / Inner Shadow 改写重着色(仿 Photoshop),Color Overlay 完整重写
- **New Canvas 改进**:始终从透明开始(像素,72 DPI),支持 inches / cm / mm + 72 / 300 DPI,设置改成 pill 风格
- **Snap 整合**([`bba92dc`](https://github.com/robbietilton/Compositor/commit/bba92dc)):View › Snap 一个总开关,palette 显示哪些选项开了
- **Edit 菜单**去掉 macOS 自带的 text extras([`710dd66`](https://github.com/robbietilton/Compositor/commit/710dd66))

### 对 fork 汉化的影响

- 1.4.6 之前 zh_cn 已有 14 个 Phase 2 汉化 batch 在 `9ddee11` 之前(详见 `git log zh_cn` 的 C-9 到 C-14)
- 1.4.6 同步时 `Batch C-9: bring zh_cn fork to 1.4.7_zh` 实际是基于 1.4.6 (fa41b9b),后被 `2a3e71f Rename zh_cn build to 1.4.6_zh (was 1.4.7_zh)` 改回 1.4.6_zh
- xcstrings 1094 → 1140 keys(1.4.5 之前到 1.4.6 期间持续汉化)

---

## fork 跟踪笔记

- 上游 main 当前 `b4bfdea Publish update feed for Compositor 1.4.9`(2026-10-08 之后)
- 上游没有正式的 `v1.4.7` / `v1.4.8` / `v1.4.9` git tag——只在 main 分支以 commit 形式发布;`Publish update feed for ...` commit 更新 appcast.xml 让 Sparkle 知道有新版
- 上游 README 自 1.4.8 起加了 "translations are on hold" 段:`Compositor is English only for now, and translation pull requests aren't being accepted`——所以 fork **不会** PR 任何翻译回上游
- fork 同步 1.4.x 时,pbxproj 6 处 `MARKETING_VERSION` + `PRODUCT_BUNDLE_IDENTIFIER` 保留 fork 标识(`cn.jintengchen.compositor` 替代上游 `com.wonderassembly.compositor`,Personal Team 不能再用上游 bundle ID)
- 详细同步流程和踩坑:见 `docs/zh-Hans-localization.md` 末尾
- 本 fork 的 commits / tags / DMG 状态:看 `git log zh_cn` + `git tag --list 1.*_zh`
