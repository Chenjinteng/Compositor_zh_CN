# Compositor

> 这是 [robbietilton/Compositor](https://github.com/robbietilton/Compositor) 的中文本地化分支。
> 英文版本见 [README_en_US.md](README_en_US.md)。

> ⚠️ **声明**:本 fork 为个人自用分支,汉化借助 AI 工具辅助完成,本人并非专业本地化或开发者。译文如有不准确或不够地道之处,欢迎提交 issue 反馈指正;不接受挑刺式批评。
>
> **立场**:
> - 本分支**仅供个人使用**,不会进行任何形式的传播、推广或商业化分发
> - **不会**向上游 [robbietilton/Compositor](https://github.com/robbietilton/Compositor) 提交翻译 PR 或合并请求(尊重上游 README 关于 "translations are on hold" 的声明)
> - 与原作者及其所属 [Wonder Assembly LLC](https://www.wonderassembly.com) **没有任何合作关系或授权**,所有商标、产品名归原作者所有
>
> **致谢**:感谢 [Robbie Tilton](https://github.com/robbietilton) 创作并开源了 Compositor。这个 fork 是站在他的肩膀上,翻译只是为了让他的出色工作也能用中文顺手一点。如果你是寻找官方版本,请访问 [robbietilton.com/compositor](https://robbietilton.com/compositor) 或 [上游 GitHub](https://github.com/robbietilton/Compositor)。

Adobe Photoshop 太贵,GIMP 等工具又不够顺手,我没法靠它们保持心流。这正是我打造 Compositor 的原因。

目标是打造一款完全免费且开源的全功能图像编辑器。我过去常用 Photoshop 做合成与后期,所以 Compositor 的设计以这套工作流为核心 —— 提供创作像素级完美成图所需的全部工具。

因为是开源,你可以下载 Xcode 项目,任意增删修改功能,让它贴合自己的工作流。

## 安装

### 下载
前往 [robbietilton.com/compositor](https://robbietilton.com/compositor) 获取 Compositor,或直接从 [GitHub Releases](https://github.com/robbietilton/Compositor/releases/latest) 下载最新版本。

### Homebrew

```sh
brew install --cask robbietilton-compositor
```

## 功能

### 图层
- 图层与文件夹,带不透明度设置,以及 Photoshop 的全套混合模式(顺序保持一致)—— 文件夹的不透明度会作用于其内的所有图层
- 图层蒙版:可在画布任意位置(超出图层自身像素范围)进行绘制、填充、反相、模糊和羽化;可链接或断开,以单独变换蒙版
- 剪贴蒙版与文件夹蒙版
- 调整图层:色相/饱和度、色阶、曲线、曝光、渐变映射、颗粒、黑白、色彩平衡、反相、高斯模糊、动感模糊和杂色
- 图层效果:描边、投影、颜色叠加、内阴影、外发光和内发光,GPU 渲染,可随时编辑
- 向下合并、合并图层和合并组(⌘E)
- 复制、内联重命名、重新排序、嵌套拖放;Option + 拖动复制;图层面板右键菜单
- 复制粘贴整个图层或文件夹(无选区时 ⌘C/⌘V),可在项目内或跨项目粘贴,亦可跨项目拖动

### 变换
- 非破坏性的移动、缩放、旋转和翻转 —— 不论缩到多小,图像始终保留全分辨率
- 自由扭曲(⌘ + 拖动控制柄),Shift 锁定到单轴
- 多图层或整组文件夹一起变换
- 对齐到画布、图层边缘和中心点,带参考线
- 位置、尺寸、缩放和角度的精确数值,可用方向键步进
- 翻转图层与翻转画布,水平和垂直方向

### 选区
- 矩形与椭圆选框、徒手与多边形套索,以及魔法工具 —— 魔棒按颜色选,Object 沿着点击对象描边(Tab 切换)
- 主体识别,以及对任意选区的扩展、收缩和羽化
- 选区的加减、轮廓移动、内部像素的移动与复制
- 将图层像素或蒙版载入为选区
- 内容识别填充,也可用于扩展图像边缘之外

### 绘画与修饰
- 画笔带尺寸、硬度、不透明度和平滑,可在绘画/异与/擦除模式间切换(B 和 E),Shift 绘制直线
- 污点修复画笔(内容识别)
- 仿制图章,可对齐或不对齐,可从一个图层或所有图层取样
- 模糊工具,作用于像素或蒙版
- 渐变工具与形状工具(矩形、圆角矩形、椭圆和直线),保持可编辑而非栅格化
- 文字工具(T):在可拖动、可调整大小的段落框内联多行编辑;字体、字号、颜色、对齐和间距均在工具栏;文字可变换并用作剪贴蒙版
- 拾色器与完整取色器

### 调整与滤镜
- Camera Raw 滤镜:光线、颜色、曲面级、混色器、调色、细节、光学和几何,面板置于画布旁
- 色阶(带自动)、曲线、色相/饱和度、曝光、渐变映射、颗粒、黑白、色彩平衡和反相
- 高斯模糊与动感模糊,可延伸超出图层边缘
- 添加杂色、暗角、光晕/发光、抖动、扫描线、色调对比度、镜头校正和移除背景
- 实时预览,当选区存在时仅作用于选区
- 上次滤镜(⌃⌘F)以相同参数再次执行上一次的滤镜

### 画布与文件
- 多项目标签页
- 搜索命令(⌘F):按名称搜索所有菜单命令和工具,类似 Raycast 或 Obsidian,Return 直接执行
- 切换全屏(F):整个屏幕只剩画布浮于黑底之上,所有面板收起;再按 F 或按 Esc 恢复
- 标尺(⌘R)、从标尺拖出参考线、可调间距与细分数的布局网格,以及参考线/网格/图层/文档边界的对齐
- 裁剪带吸附,提供 3:4、9:16 等比例,Option 开启对称裁剪;有选区时从选区开始裁剪
- 画布大小、图像大小和裁剪
- 300% 缩放以上时,在画布角落有一个 Navigator 缩略导航:全文档迷你视图,框出当前视野;点击或拖动直接定位(View › Navigator)
- 缩小查看时的高质量降采样,放大查看时的像素网格
- 支持导入 JPEG、PNG、HEIC、WebP、TIFF、SVG、相机 RAW(需先走 develop 一步)、Photoshop PSD 和 PSB(8 位 RGB,不支持 CMYK)。Photoshop 文件夹、蒙版、混合模式、填充矩形/椭圆,以及简单的水平文字保持可编辑;其他矢量和竖排文字转为像素。应用前会显示转换报告
- 大文档:内存预算随 Mac 调整,过大的 Photoshop 文件将图层裁切到画布以保证可打开
- 导出 PNG(⇧⌘E)、导出 JPEG(⇧⌥⌘S),以及导出为(⇧⌥⌘W)PDF / PNG / JPEG,可选按打印尺寸缩放,带实时预览、JPEG 画质与文件大小;复制合并
- 保存项目的同时可继续工作
- 整体采用 Photoshop 风格快捷键,在 编辑 > 键盘快捷键 中可重映射
- 拖动数字标签即可滑改数值,Photoshop 同款
- 自动更新,签名并公证

### 与 AI 智能体协作
- AI 智能体与脚本可直接构建与编辑项目:`.comp` 是一个由 PNG 图层和清单文件组成的文件夹,项目打开时写入即生效。详见[编写 Compositor 项目](docs/writing-comp-files.md)

## 系统要求

- Apple silicon Mac,macOS 26.0 或更高版本
- Xcode 26 或更高版本(从源码构建时)

## 构建

打开 `Compositor.xcodeproj`,运行 **Compositor** scheme。


打开 `Compositor.xcodeproj`,运行 **Compositor** scheme。

## 发布

`scripts/release.sh` 构建 Release 版本,使用 Developer ID 签名、公证并加签,最终打包为 `dist/Compositor-<version>.dmg`。

依赖以下外部资源(均须保存在仓库外):

- 登录钥匙串中的 **Developer ID Application** 证书
- 通过 `xcrun notarytool store-credentials "compositor-notary" …` 保存的公证凭据
- [`create-dmg`](https://github.com/create-dmg/create-dmg)(`brew install create-dmg`)

## 多机发布与个人使用

本 fork 为个人自用,日常在两台 Mac 间切换使用,所以 `scripts/release.sh` 改为
**按架构分别构建 DMG**(arm64 + x86_64 各一个),而不是打包成一个 universal DMG。

### 两台机器

| 设备 | 系统 | 架构 | 对应 DMG |
|---|---|---|---|
| Mac mini(开发机,本仓库所在) | macOS 27.0.1 | arm64 | `dist/Compositor-<version>-arm64.dmg` |
| MacBook Pro 13-inch, 2018 | macOS 15.7.7(Sequoia)¹ | x86_64 | `dist/Compositor-<version>-x86_64.dmg` |

¹ 2018 MBP 13 通过 OpenCore Legacy Patcher 升级到 Sequoia;它也是 Intel 阵营
最后一代能跑到 macOS 26 (Tahoe) 的机器,但这台没升到 Tahoe。

### 部署目标的覆盖

工程文件 `project.pbxproj` 仍然写 `arm64 only` + `macOS 26.0` 的默认值。脚本层
在 `xcodebuild archive` 时显式把 `MACOSX_DEPLOYMENT_TARGET` 覆盖到 `15.0`,
让 x86_64 DMG 能在 MBP 2018(15.7.7)上跑;`scripts/publish.sh` 的
`xcodebuild -showBuildSettings` 也同步加这个 override,保证 appcast 里的
`minimumSystemVersion` 跟实际产物对齐。

### 跑 release.sh

```sh
./scripts/release.sh
```

跑完 `dist/` 下出两个 DMG,各自单一架构、各自 Personal Team 签名。`spctl` 报
`rejected` 是因为没 notarize,预期内 informational noise。

## 许可证

MIT —— 见 [LICENSE](LICENSE)。