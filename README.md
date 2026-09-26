# cetz-skill

Typst / [CeTZ](https://github.com/konradheter/typst-cetz) 的科学插图重绘合集：把数学、物理教材里的线描插图（向量场、张量示意图、光路、电路、流形与立体几何的骨架图）逐一写成可编辑的 CeTZ 代码，并与原图做像素级比对。

A collection of textbook line-art figures redrawn as editable CeTZ (Typst) source. Each `.typ` file was drawn from scratch against a scan of the original figure, compiled, and checked with an overlay tool until the geometry matched within about one pixel. 目录结构、工具和踩坑记录见下文；`experience/EXPERIENCE.md` 是全过程的流水账。

## 关于原图

本仓库**不包含任何教材扫描图**。比对用的原始页面来自本地持有的电子书（Guillemin–Pollack《The Foundations of Differential Geometry》、Fleisch 的向量与张量系列、Itskov《Tensor Algebra and Tensor Analysis for Engineers》、James《Fourier Transforms》等），它们受版权保护，不随代码分发。

这里存放的是代码本身。需要提醒的是：部分 `.typ` 渲染出来的图形在构图上参照了上述书籍的插图，几何线条的表达属于本仓库，原书的独创性设计仍归原出版社所有，请自行判断使用场景。`LICENSE` 里的 MIT 覆盖的是代码和文档。

## 目录

```
figures/batchNN/typ/*.typ   195 个插图源码，按批次组织（每个文件自包含，可直接编译）
figures/batchNN/*.py        该批次的提取与测量脚本（连通域、直线拟合、灰格枚举等）
previews/                   由 figures/ 编译出的预览图
tools/                      跨批次通用的工具
experience/EXPERIENCE.md    逐批次的经验总结（主文档）
experience/results/         每个批次的 RESULTS.md 记录
community.md                多个 agent 协作时的工位板，含时间线日志
references/api-cheatsheet.md  CeTZ 0.4.2 常用接口速查
assets/                     通用的 ML / 化学 / 统计示意图模板
SKILL.md                    CeTZ 绘图的写作流程约定
```

批次的命名前缀对应素材来源：`fig` 通用插图、`pdf` 来自 PDF 章节、`dt` Guillemin–Pollack、`it` Itskov、`ft` James 傅里叶变换、`gt` Fleisch、`dg` 微分几何。

## 编译

需要 Typst 0.15.1 与 CeTZ 0.4.2（首次联网拉取后会被缓存，之后可离线编译）。

```bash
cd figures/batch73
typst compile --root . --font-path C:/Windows/Fonts typ/it43.typ it43.png
```

每个 `.typ` 的开头都是同一套画布设置：

```typ
#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw
#canvas({
  import draw: *          // 少了这一行，line 会绑到 Typst 内置的 line 元素，报错信息很难懂
  ...
})
```

`render_previews.py` 会把 `figures/*/typ` 下所有文件批量编译到 `previews/`，失败的文件会打印文件名和第一行报错。

195 个文件里有 192 个能直接编译，三个例外保留原样没有改动，因为它们本来就是半成品或实验草稿：

- `figures/batch61/typ/dt62-spiral.typ` — 坐标串写到一半就断了（原图扫描缺失，这张当时就放弃了）
- `figures/batch45/typ/pdf025-triplex-receiver.typ` — `if i<6 {` 里的 `<6` 被 Typst 当成 label，语法未修正
- `figures/batch72/typ/_t.typ` — 试探 `ellipse` 参数写法的草稿

## 比对方法

判断"画得像不像"靠的不是肉眼印象，而是一个量化门槛：把原图和渲染图按墨迹包围盒对齐缩放后，计算渲染墨迹到原图墨迹的最近邻平均距离，要求小于 1.0 px。`tools/ov2.py` 做这件事，同时输出一张三色叠加图——青色是只有原图有的墨迹，品红是只有渲染有的，黑色是重合部分。

```bash
python tools/ov2.py figures/batch73 it43
```

这个门槛只是必要条件。平均值小于 1 px 但形状错了完全可能发生：文字标签把墨迹包围盒撑大，整张图的几何会被拉伸；抗锯齿的光晕会让重叠核心看起来是 2 px 宽而平均值依然达标。所以每张图最后还要看叠加图本身，线条倾角、箭头朝向、连接关系不对就不算通过。

`experience/EXPERIENCE.md` 里记录了这些坑的完整来由，以及几类被判定为"不适合 CeTZ 重绘"的图（数据曲线、照片级渲染、立体材质剖面）和跳过的量化理由。

## 约定

- 坐标系换算：画布裸数字单位是 cm；常见标定是 `S = 148.0`，`px(x, y) => (x / S, (Y0 - y) / S)`，其中 `Y0` 为原图高度，把图像坐标（y 向下）翻成画布坐标（y 向上）。
- 手绘线条优先用 `line(stroke: (...), ...)`，stroke 必须是命名参数。
- 直线虚线要逐段画，不要指望 `dash` 参数在斜线上对齐。

## License

MIT，见 `LICENSE`。
