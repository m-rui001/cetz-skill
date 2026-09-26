# batch48 结果（Guillemin–Pollack《Differential Topology》线描插图）

素材来自 `E:/EPUB/work/reocr_stage/[Guillemin,Pollack]Differential_Topology(1974)/render/*.epub`，
按 `work/batch43/pick.py` 的线描口径筛图（宽 500–1400、高 330–900、墨迹占比 0.004–0.16）。
序号 39 是数据曲线图，按主人要求不复刻、也不计为放弃。

| 文件 | 图号 | 内容 | 视觉尝试 | overlay 平均偏差 | 长宽比 源/渲染 | 结论 |
|---|---|---|---|---|---|---|
| `typ/dt37-ihull.typ` | dt37 | 流形 X、值域 V、纤维 f⁻¹(y) 与内点凸包示意 | 1 | 0.64 px | 1.000 / 1.006 | 通过 |
| `typ/dt12-intersect.typ` | dt12 | 三组 X/Z 相交序列，横截数 2→0，含两条箭头 | 3 | 0.59 px | 3.098 / 3.080 | 通过 |
| `typ/dt41-X-balls.typ` | dt41 | 区域 X 内两个小球 ∂B_i，f 与 f_i 两条长弧箭头映到 R^n | 2 | 0.63 px | 2.438 / 2.459 | 通过 |

验收口径：`python ../ov.py . <name>` 输出的「渲染墨迹到最近源图墨迹平均距离」< 1.0 px，
且 scale 落在 2.59–2.61、长宽比误差 < 1%；再读 `ov_*.png` 与 `cmp_*.png` 确认结构、
线条、箭头方向、连接关系、版面比例与符号无误。字体不要求与原书一致。

## 本批用到的工具

- `grab.py <zip序号...>`：从 EPUB 里按序号取图存成 `src/dtNN-raw.png`，同时打印墨迹占比与包围盒。
  匹配书名必须用 `'Guillemin'`，用 `'Differential'` 会命中 Sochi 那本微分几何。
- `trace3.py <name> <dil> <eps> "g1|g2|..."`：白区 4 连通标记 → 选中的若干区域并集按 dil 次 3×3 膨胀
  → 裂缝跟随描边 → Douglas–Peucker → 直接吐 Typst 点列。先跑一次不带 group 参数，读每块白区的
  `area/bbox` 来决定哪几个序号属于同一个图形内部。
- `meas.py` / `psk.py`：`meas.py` 打印指定行列的墨迹游程，用来量箭头端点、标签包围盒、笔画粗；
  `psk.py` 在 ov.py 的全局对齐之外再按 x 分带找残余平移，用来区分「整体偏移」和「形状画错」。

## 踩到的坑

- 指标会骗人，但方向和肉眼相反时要以分带数据为准。dt12 从 0.94 px 降到 0.59 px 靠的是三块面板各自
  的刚性 x 偏移（-3/-1/+2）和两行图注的位置，而不是重画曲线；几何本身一直是好的（分面板 0.41–0.67 px），
  拖高平均值的是图注文字（2.28 与 4.17 px）。先按 y 窗口把「几何 / 标签 / 图注」拆开量，再决定改哪里。
- 图注文字的水平位置要按整行墨迹包围盒的中心量，不能按肉眼。dt12 右侧图注我原来放偏了 14.5 px。
- ov.py 的对齐尺度取自整幅墨迹包围盒，所以**动任何一个最外侧标签都会改变全局缩放**。dt41 把 X′′ 类
  标签往右挪 9 px 之后，scale 从 2.5952 变成 2.6179，整体反而更差（0.74 → 1.17）。改边缘元素要单独试。
- Typst 数学里 `bold` 后面带空格会被当成普通单词打印：`$bold (R)^n$` 渲染出字面 “bold (R)^n”，
  宽度从 36 px 涨到 94 px，直接把整幅图的包围盒撑歪（ar 2.44 → 2.64）。写成 `$bold(R)^n$` 才对。
- `import draw: *` 会遮蔽 `math`，取 `math.bold` 之类要写 `std.math`；三角函数用 `calc.cos/calc.sin`。
- 交集符号没有 `cap`/`sect` 可用，直接写 Unicode `∩`；`#` 在数学里写 `hash`。
- 箭头三角按源图像素照抄会偏大。源图箭头长约 35 px、宽约 14 px，按 1 源 px ≈ 0.191 pt 折算是
  `length: 6.6pt, width: 2.7pt`；dt12 用 6pt/2.7pt。
- 描出来的闭合折线用 Catmull–Rom 平滑时，闭合分支不要在末尾再补一个起点（`close: true` 已经闭合），
  否则重复点会让首段曲率抖一下。

## 累计

本批 3/3 通过，无放弃。我这条线（`work/batch1`–`work/batch43` 加 `work/batch48`）目前共有 132 个
`.typ`，逐批通过数记在 `work/EXPERIENCE.md` 的汇总表里。
待办：`work/batch42/src/dg72-raw.png`（三张曲面 + 高斯–博内）仍欠；dt54 已取出原图待做。
