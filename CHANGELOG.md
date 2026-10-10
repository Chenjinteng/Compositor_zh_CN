# zh_cn fork 变更日志

`Chenjinteng/Compositor_zh_CN.git` 的 `zh_cn` 分支的版本变更记录。**这不是上游 Compositor 的 changelog**——只是 fork 维护人(Jinteng)给自己看的"每个 fork 版本做了什么、为什么这么改"的速查表。

每个 fork 版本对应一个 tag(`1.4.x_zh` 形式,无 `v` 前缀以区分上游 `v1.4.x`)。tag 指向该 fork 版本收尾时的 HEAD commit。

## 1.4.9_zh(当前)

**tag**: `1.4.9_zh` → `5741215`(release 收尾 tag 已 force-push 到此处)
**上游 base**: `b4bfdea Publish update feed for Compositor 1.4.9`(`upstream/main`)
**zh_cn HEAD**: `5741215`
**xcstrings**: 1184 keys
**DMG**: `dist/Compositor-1.4.9_zh-arm64.dmg` 7.84 MB / `dist/Compositor-1.4.9_zh-x86_64.dmg` 8.16 MB
**bundle ID**: `cn.jintengchen.compositor`
**MARKETING_VERSION**: `1.4.9_zh`

### commits

| commit | 说明 |
|---|---|
| `429154a` | Merge upstream 1.4.9 (b4bfdea) into zh_cn — 3 处冲突:pbxproj / README.md (加 WebP) / scripts/publish.sh |
| `6e1cb24` | Batch C-19: localize 1.4.9 new UI strings — Update alert + Project Tabs help |
| `28df52b` | Batch C-19 (cont.): localize UpdateDriver button + informative text |
| `5741215` | Batch C-20: localize ColorPaletteControls popover and swatch labels (修 mask 模式 popover + swatch help/a11y) |

### 主要汉化

- **UpdateDriver**(Sparkle 1.4.9 新提示样式):"A new version of %@ is available!" 标题、2 个 informative 模板、4 个 button(安装/稍后/跳过/自动下载)
- **ProjectTabs**:`Drop to open in a new canvas` / `Drop into new canvas` a11y / `Open in a new project tab` / `New canvas (⌘N) · Drop images here for new tabs` / `Close %@` / `Add to %@`
- **ColorPaletteControls**:`Mask background` / `Mask foreground` / `Black · Hide` / `White · Reveal` / `Background color` / `Foreground color`

### 1.4.8 merge 时回退但 SwiftUI 字面量自动 lookup 命中的字面量

zh_cn 1.4.7 之前用 `L()` 包了 60+ 处字面量,1.4.8 上游把这些改回 plain string literal(信任 SwiftUI `LocalizedStringKey` 自动 catalog lookup)。**经验证,这些字面量当前在 fork 里实际显示为中文**——xcstrings 里有翻译,SwiftUI 字面量自动命中。`ColorPaletteControls` 的 L42/L59 是例外,因为传 `ternary` 表达式退化为 `String` 类型,SwiftUI 不走 `LocalizedStringKey` 路径。

剩余 8 个未翻译字面量(全部边角):
- `Develop` / `Text color`(2 个简单单字)
- 4 个 help 长句
- 2 个 CanvasSizeSheet 里的 dynamic 信息(需要 `String(format: String(localized:))` 重构)

## 1.4.8_zh

**tag**: `1.4.8_zh` → `59fa9cd`
**上游 base**: `22c7b8d Publish update feed for Compositor 1.4.8`
**xcstrings**: 1175 keys
**DMG**: `dist/Compositor-1.4.8_zh-arm64.dmg` / `dist/Compositor-1.4.8_zh-x86_64.dmg`

### commits

| commit | 说明 |
|---|---|
| `35fb68c` | Merge upstream 1.4.8 (22c7b8d) into zh_cn — 8 处冲突:pbxproj / README / CompositorApplicationDelegate / ProjectController / ColorPalette / Dither / FilterSheet / LayersPanel |
| `0e6de02` | Batch C-15: localize 1.4.7 new commands (Search Commands / Toggle Fullscreen / Last Filter) |
| `5dc435b` | Batch C-15 (cont.): extend Chinese localization log |

### 主要汉化

- **ExportAsSheet** (全新):sheet 标题 / Format / Size / Quality / Page / Background / 缩放控件 / Transparency kept · sRGB / Updating… / PDF readout 用 `String(format: String(localized: "%@ × %@ in at %d DPI"))`
- **FilterSheet scanlinesControls** (1.4.7 时 Dither 内置的 Scanlines 拆出来独立 filter):13 个控件 + 9 个 help
- **CompositorApp** (1.4.8 加的菜单项):`Export As…` / `Navigator (300% and above)`
- **NavigatorMinimap**:`accessibilityLabel("Navigator")`

## 1.4.7_zh

**tag**: `1.4.7_zh` → `5dc435b`
**上游 base**: `af30c45 Publish update feed for Compositor 1.4.7`
**xcstrings**: 1146 keys

### commits

| commit | 说明 |
|---|---|
| `6095890` | Merge upstream 1.4.7 (af30c45) into zh_cn — 8 处冲突(后来被 1.4.8 merge 时改动) |

### 主要汉化

- **CompositorApp**:View 菜单 `Search Commands…` / `Toggle Fullscreen`,Filter 菜单 `Last Filter` / `Last Filter: %@`
- **KeyboardShortcuts**:`Text(definition.title)` 改走 L()
- **CommandPaletteView**:`skipped: Set<String>` 在 static init 时 `Bundle.localizedString` 一次,匹配中文 fork 下 NSMenuItem.title 实际渲染("搜索命令…/窗口/帮助/服务")

## 1.4.6_zh

**tag**: `1.4.6_zh` → `9ddee11`
**上游 base**: `fa41b9b Publish update feed for Compositor 1.4.6`
**xcstrings**: 1140 keys

### commits

`9ddee11` 之前的 14 个 batch 是 Phase 2 汉化(批量 enum picker + 工具栏 / Layers panel / Camera Raw 全套 / Levels / Curves / Hue-Saturation / Gradient Map / Color Picker / Filter sheets / Crop / Grid Settings / Type / Color Picker / Image Trim / Canvas Size / JPEG Export / Layer Mask / Transform Inspector / Keyboard Shortcuts panels / Camera Raw 全部面板 / 图层右键菜单 + 裁剪比例下拉)。详见 `git log zh_cn` 的 9ddee11 之前。

## 上游同步基础设施

| 设施 | 用途 |
|---|---|
| `origin` | `git@github.com:Chenjinteng/Compositor_zh_CN.git` — fork 仓库 |
| `upstream` | `git@github.com:robbietilton/Compositor.git` — 上游(新增,`tagOpt=--no-tags`,只 fetch 分支) |
| `main` 分支 | 永远 = `upstream/main`(本次 reset 后维持),不在 main 上做 fork 工作 |
| `zh_cn` 分支 | 所有 fork 工作(merge / 汉化 batch / 文档)都在这里 |
| 远端 tag 政策 | 显式 `git push origin <tag>` 单 tag push,绝不 `git push --tags` —— 否则上游 `v1.x` 会被一并推上来 |
| 当前 4 个 fork tag | `1.4.6_zh` / `1.4.7_zh` / `1.4.8_zh` / `1.4.9_zh`,全部 clean,无 `v1.x` 污染 |

## 同步上游的标准流程

```bash
# 0) 切到 main,fast-forward 到 upstream
git checkout main
git fetch upstream           # 只拿分支,不拿 tag(tagOpt=--no-tags)
git merge --ff-only upstream/main

# 1) 切到 zh_cn,跑 merge upstream/main,解冲突
git checkout zh_cn
git merge --no-ff upstream/main -m "Batch C-NN: merge upstream 1.4.x"
# 解 8-12 处冲突(pbxproj / README / EffectsSheet / ColorPalette / Dither /
#   FilterSheet / LayersPanel / ProjectController 等)
xcodebuild -project Compositor.xcodeproj -scheme Compositor \
           -destination 'platform=macOS' build   # 确认编译过

git commit --no-edit       # 收尾 merge commit

# 2) 汉化 batch
# 看 upstream diff,挑出 1.4.x 新增的 .swift 文件 + 改动中新增的 UI 字面量
# 加 xcstrings key + zh-Hans 翻译,源代码 L() 包装
# (重要:SwiftUI 字面量自动 LocalizedStringKey lookup;只有 String 变量传参要 L() wrap)
git commit -m "Batch C-NN: localize 1.4.x new UI strings"

# 3) 文档
# 更新 docs/zh-Hans-localization.md(每个 batch 写一段)+ CHANGELOG.md(本文件)
git commit -m "Batch C-NN: extend Chinese localization log"

# 4) 打 fork tag,推
git tag -a 1.4.x_zh HEAD -m "..."
git push origin zh_cn
git push origin 1.4.x_zh     # 显式 tag push

# 5) 出 DMG
zsh scripts/release.sh     # 跑分 arm64 + x86_64 两个 DMG
```

## 关键经验(防止重复踩坑)

- **SwiftUI 字面量 vs String 变量**:
  - `Text("xxx")` / `Button("xxx")` — 字面量,推断 `LocalizedStringKey`,自动 catalog lookup
  - `Text(stringVariable)` / `Text(ternary ? "a" : "b")` — String 变量/表达式,verbatim,**不** catalog lookup
  - 解决:用 `Text(L("xxx"))` / `Text(ternary ? L("a") : L("b"))` 强制走 Bundle lookup
  - **判断标准**:`grep -E 'Text\("[A-Z][^"]+"\)|\.title = "[A-Z][^"]+"|help\("[A-Z][^"]+"'` 找到的是字面量,大概率已自动翻译;`Text(ternary...)` / `let x = ternary; .help(x)` 这种**没有**自动翻译
- **xcstrings key 命名**:英文 rawValue 直接当 key,zh-Hans 翻译进 `localizations.zh-Hans.stringUnit.value`
- **bundle ID**:Personal Team 不能再用上游 `com.wonderassembly.compositor`,fork 用 `cn.jintengchen.compositor[.tests|.uitests]`
- **签名 cert**:真 Team ID 在 cert Subject **OU** 字段(`FJYQT2JA5U`),cert 名字括号里 `FDQLLU43U7` 是 Team Member ID 不是 Team ID
- **MARKETING_VERSION**:改 pbxproj 6 处 × 3 targets,`xcodebuild archive` 时 `xcodebuild` 自动注入 `CFBundleShortVersionString`
- **发布**:Personal Team 7 天 cert 过期,不能 notarize,自己 Mac 双击右键打开绕过 Gatekeeper
- **冲突模式**:1.4.7 / 1.4.8 / 1.4.9 上游每次 merge 都会回退 zh_cn 的 L() 包装设计,接受 upstream 一侧后,在新 C-NN 批中用 L() + `String(format: String(localized:))` 重新串起来
- **git push --tags 永远别用**:会把上游 `v1.x` 一并推过来;fork 这边手动 `git push origin <tag>`

## 已知未汉化(8 个边角字面量,不影响日常使用)

- `Develop` / `Text color`(2 个简单单字)
- 4 个 help 长句
- 2 个 CanvasSizeSheet 里的 dynamic 信息(`Current: $W × $H pixels` / `New: $W × $H pixels · $BYTES uncompressed` / `Final dimensions must be 1–$MAX pixels per side.`)

要补的话:1 个 commit 即可。
