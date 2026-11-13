// LayoutGAN — 生成器与线框判别器总览
// 源图：LayoutGAN: Generating Graphic Layouts with Wireframe Discriminators
//       (Li et al., ICLR 2019, arXiv:1901.06767) Figure 1
// 上半部分：Generator（随机布局 → 编码 → 关系模块 → 解码 → 细化布局）
// 下半部分：Wireframe Rendering Discriminator（布局 → 可微线框渲染 → CNN → 真伪）
//
// 本图按"语义一致"重绘：模块关系、箭头方向、标签全部保留；
// 线宽、圆角、间距为可读性做了统一，不逐像素复刻原图。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Arial", "Segoe UI"), size: 5pt)

#canvas({
  import draw: * 

  // ---------------- 调色板与基础工具 ----------------
  let INK = rgb("#111111")
  let MUT = rgb("#777777")
  let PINK = rgb("#f2b7b7")        // 类别概率 p 的条
  let GREEN = rgb("#b9d8b4")       // 几何参数 θ 的条
  let PANEL = rgb("#f2f2f2")       // 编码器 / 解码器 / CNN 面板
  let MODULE = rgb("#d9e7f6")      // 关系模块的蓝色底
  let MODULE_ST = rgb("#4f83c4")
  let RENDER = rgb("#f8cba6")      // 可微线框渲染的橙色底
  let ARROW_FILL = rgb("#dcdcdc")
  let ARROW_ST = rgb("#9a9a9a")
  let BLUE_TXT = rgb("#1f5fa8")    // 细化后的特征 f'

  // 统一笔触：0.65pt 线、圆头
  let ink(t) = (paint: INK, thickness: t, cap: "round")

  // 圆角面板
  let panel(x0, y0, x1, y1, fill: PANEL, stroke: MUT, r: 0.3, t: 0.6pt) = rect(
    (x0, y0), (x1, y1), radius: r,
    fill: fill, stroke: (paint: stroke, thickness: t),
  )

  // 居中 / 左对齐文字
  let lbl(x, y, body, size: 5pt, anchor: "center", color: INK) = content(
    (x, y), anchor: anchor, text(size: size, fill: color, body),
  )

  // 两行说明文字（如 Class / Probabilities）
  let two-line(x, y, a, b, size: 4.5pt) = {
    lbl(x, y + 0.115, a, size: size)
    lbl(x, y - 0.115, b, size: size)
  }

  // 实线箭头
  let arrow(a, b, t: 0.7pt) = line(
    a, b, stroke: (paint: INK, thickness: t, cap: "round"),
    mark: (end: ">"),
  )

  // 虚线箭头（关系模块里所有元素特征汇聚到 self-attention）
  let dashed-arrow(a, b) = line(
    a, b, stroke: (paint: INK, thickness: 0.65pt, dash: "dashed"),
    mark: (end: "stealth", fill: INK),
  )

  // 粗块状箭头：方案图里模块之间的大灰箭头
  let block-arrow(x, y, w: 0.78, h: 0.46) = {
    let hh = h / 2
    let hl = 0.24                 // 箭头尖长度
    line(
      (x, y - hh / 2), (x + w - hl, y - hh / 2), (x + w - hl, y - hh),
      (x + w, y), (x + w - hl, y + hh), (x + w - hl, y + hh / 2),
      (x, y + hh / 2), close: true,
      fill: ARROW_FILL, stroke: (paint: ARROW_ST, thickness: 0.55pt),
    )
  }

  // 花括号：直接用字形缩放，避免折线看起来像尖括号
  let brace-left(x, y0, y1) = content(
    (x, (y0 + y1) / 2), anchor: "center",
    text(size: (y1 - y0) * 21pt, font: "Arial")[{],
  )
  let brace-right(x, y0, y1) = content(
    (x, (y0 + y1) / 2), anchor: "center",
    text(size: (y1 - y0) * 21pt, font: "Arial")[}],
  )

  // 一个图形元素的两段参数条：左粉 = 类别概率 p，右绿 = 几何参数 θ
  let param-bar(x, y, p, t, w: 1.52, h: 0.17) = {
    rect((x, y), (x + w / 2, y + h), fill: PINK, stroke: (paint: MUT, thickness: 0.4pt))
    rect((x + w / 2, y), (x + w, y + h), fill: GREEN, stroke: (paint: MUT, thickness: 0.4pt))
    lbl(x + w * 0.25, y + h + 0.15, p, size: 4.7pt)
    lbl(x + w * 0.75, y + h + 0.15, t, size: 4.7pt)
  }

  // 卷积特征图的 3D 薄板：正面网格 + 顶面 / 右侧面透视
  let slab(x, y, w, h, d: 0.3, cols: 3, rows: 4) = {
    // 右侧面
    line(
      (x + w, y), (x + w + d, y + d), (x + w + d, y + h + d), (x + w, y + h),
      close: true, fill: rgb("#ececec"), stroke: ink(0.6pt),
    )
    // 顶面
    line(
      (x, y + h), (x + d, y + h + d), (x + w + d, y + h + d), (x + w, y + h),
      close: true, fill: rgb("#fafafa"), stroke: ink(0.6pt),
    )
    // 正面
    rect((x, y), (x + w, y + h), fill: white, stroke: ink(0.6pt))
    // 正面竖 / 横网格
    for i in range(1, cols) {
      line((x + w * i / cols, y), (x + w * i / cols, y + h), stroke: ink(0.45pt))
    }
    for j in range(1, rows) {
      line((x, y + h * j / rows), (x + w, y + h * j / rows), stroke: ink(0.45pt))
    }
    // 顶面沿深度的网格线，右侧面的水平网格线
    for i in range(1, cols) {
      line((x + w * i / cols, y + h), (x + d + w * i / cols, y + h + d), stroke: ink(0.45pt))
    }
    for j in range(1, rows) {
      line((x + w, y + h * j / rows), (x + w + d, y + h * j / rows + d), stroke: ink(0.45pt))
    }
  }

  // ================= 上半部分：Generator =================
  // 左侧竖排说明：这一行是生成器
  lbl(0.85, 6.75, "Generator", size: 7pt)

  // ---- ① 随机输入 Random Input ----
  // 标题 + 两个分布示意图：均匀分布（方波）与高斯分布（钟形曲线）
  lbl(4.35, 9.08, "Random Input", size: 6.8pt)
  // 均匀分布：方波
  line(
    (2.78, 8.38), (3.06, 8.38), (3.06, 8.70), (3.46, 8.70),
    (3.46, 8.38), (3.74, 8.38), stroke: ink(0.7pt),
  )
  // 高斯分布：钟形曲线（第二个随机输入，原图是平滑单峰）
  let bell = ()
  for i in range(0, 21) {
    let t = i / 20
    let gx = 4.98 + 0.84 * t
    let gy = 8.37 + 0.33 * calc.exp(-calc.pow((t - 0.5) / 0.19, 2))
    bell.push((gx, gy))
  }
  line(..bell, stroke: ink(0.7pt))
  // 两个分布各自对应的参数含义
  two-line(3.26, 8.04, "Class", "Probabilities", size: 4.35pt)
  two-line(5.40, 8.04, "Geometric", "Parameters", size: 4.35pt)

  // 随机采样的 N 个图形元素：每行左侧 p_i，右侧 θ_i
  brace-left(2.52, 5.86, 7.13)
  param-bar(2.72, 7.00, [$p_1$], [$theta_1$])
  param-bar(2.72, 6.52, [$p_2$], [$theta_2$])
  lbl(3.95, 6.21, "⋮", size: 6.5pt)
  param-bar(2.72, 5.92, [$p_N$], [$theta_N$])
  // 整批元素写成一个集合
  lbl(4.02, 5.62, [${(p_1, theta_1), ..., (p_N, theta_N)}$], size: 4.6pt)

  // ---- ② 编码器 Encoder ----
  // 每个元素的 (p, θ) 先各自过两层全连接 fc，得到特征 f(p_i, x_i)
  lbl(8.42, 8.96, "Encoder", size: 6.8pt)
  panel(7.26, 5.38, 9.58, 8.55)
  rect((7.70, 5.78), (7.92, 8.12), fill: rgb("#e7e7e7"), stroke: ink(0.55pt))
  rect((8.86, 5.78), (9.08, 8.12), fill: rgb("#e7e7e7"), stroke: ink(0.55pt))
  lbl(7.81, 8.25, "fc", size: 4.7pt)
  lbl(8.97, 8.25, "fc", size: 4.7pt)
  arrow((8.02, 6.92), (8.78, 6.92))

  block-arrow(9.66, 6.92)

  // ---- ③ 堆叠关系模块 Stacked Relation Module ----
  // 把所有元素特征放进一个集合，用 self-attention 让每个元素看到其它元素
  lbl(15.3, 8.62, "Stacked Relation Module", size: 6.8pt)
  panel(10.48, 5.12, 20.02, 8.36, fill: MODULE, stroke: MODULE_ST, r: 0.45)

  // 顶部：整个特征序列 f(p_1,x_1) … f(p_n,x_n)
  lbl(12.05, 7.99, [$f(p_1, x_1)$], size: 4.9pt)
  lbl(13.32, 7.99, [$f(p_2, x_2)$], size: 4.9pt)
  lbl(14.42, 7.99, "⋯", size: 5.5pt)
  lbl(15.52, 7.99, [$f(p_i, x_i)$], size: 4.9pt)
  lbl(16.62, 7.99, "⋯", size: 5.5pt)
  lbl(17.86, 7.99, [$f(p_n, x_n)$], size: 4.9pt)
  // 虚线箭头：每个位置的元素特征都参与注意力
  dashed-arrow((11.98, 7.86), (13.55, 6.42))
  dashed-arrow((13.28, 7.86), (13.95, 6.42))
  dashed-arrow((14.42, 7.86), (14.35, 6.42))
  dashed-arrow((15.48, 7.86), (14.72, 6.42))
  dashed-arrow((16.58, 7.86), (14.98, 6.42))
  dashed-arrow((17.80, 7.86), (15.10, 6.42))

  // 左侧：逐元素特征列表（位置编码 x_i 与类别 p_i 拼在一起）
  lbl(11.48, 7.38, [$f(p_1, x_1)$], size: 4.7pt)
  lbl(11.48, 7.00, [$f(p_2, x_2)$], size: 4.7pt)
  lbl(11.48, 6.70, "⋮", size: 6pt)
  lbl(11.48, 6.42, [$f(p_i, x_i)$], size: 4.7pt)
  lbl(11.48, 6.12, "⋮", size: 6pt)
  lbl(11.48, 5.84, [$f(p_n, x_n)$], size: 4.7pt)

  // 注意力聚合符号 ⊕ 与 self-attention 盒子
  circle((12.33, 5.90), radius: 0.17, stroke: ink(0.75pt))
  line((12.19, 5.90), (12.47, 5.90), stroke: ink(0.8pt))
  line((12.33, 5.76), (12.33, 6.04), stroke: ink(0.8pt))
  arrow((12.52, 5.90), (12.98, 5.90))
  panel(13.02, 5.68, 15.24, 6.36, fill: rgb("#dfdfdf"), stroke: rgb("#999999"), r: 0.1)
  lbl(14.13, 6.02, "Self-attention", size: 4.7pt)

  // 右侧：关系模块输出的细化特征 f'(p_i, x_i)，用蓝色区分
  lbl(19.28, 7.38, [$f'(p_1, x_1)$], size: 4.7pt, color: BLUE_TXT)
  lbl(19.28, 7.00, [$f'(p_2, x_2)$], size: 4.7pt, color: BLUE_TXT)
  lbl(19.28, 6.70, "⋮", size: 6pt, color: BLUE_TXT)
  lbl(19.28, 6.42, [$f'(p_i, x_i)$], size: 4.7pt, color: BLUE_TXT)
  lbl(19.28, 6.12, "⋮", size: 6pt, color: BLUE_TXT)
  lbl(19.28, 5.84, [$f'(p_n, x_n)$], size: 4.7pt, color: BLUE_TXT)
  // self-attention 输出 → 细化特征列
  arrow((15.28, 6.02), (18.78, 6.02))

  block-arrow(20.10, 6.92)

  // ---- ④ 解码器 Decoder ----
  // 细化特征再过两层 fc，解回每个元素的类别概率与几何参数
  lbl(22.06, 8.96, "Decoder", size: 6.8pt)
  panel(20.88, 5.38, 23.18, 8.55)
  rect((21.32, 5.78), (21.54, 8.12), fill: rgb("#e7e7e7"), stroke: ink(0.55pt))
  rect((22.46, 5.78), (22.68, 8.12), fill: rgb("#e7e7e7"), stroke: ink(0.55pt))
  lbl(21.43, 8.25, "fc", size: 4.7pt)
  lbl(22.57, 8.25, "fc", size: 4.7pt)
  arrow((21.64, 6.92), (22.38, 6.92))

  block-arrow(23.26, 7.55, w: 0.56, h: 0.34)
  block-arrow(23.26, 6.10, w: 0.56, h: 0.34)

  // 两路 fc：上面粉色管类别 p'，下面绿色管几何 θ'
  rect((23.92, 6.95), (24.08, 8.22), fill: PINK, stroke: ink(0.55pt))
  lbl(24.00, 8.36, "fc", size: 4.7pt)
  rect((23.92, 5.52), (24.08, 6.62), fill: GREEN, stroke: ink(0.55pt))
  lbl(24.00, 6.76, "fc", size: 4.7pt)

  // ---- ⑤ 细化后的布局输出 ----
  block-arrow(24.16, 7.55, w: 0.46, h: 0.3)
  block-arrow(24.16, 6.10, w: 0.46, h: 0.3)
  two-line(25.28, 8.22, "Class", "Probabilities", size: 4.2pt)
  two-line(26.35, 8.22, "Geometric", "Parameters", size: 4.2pt)
  param-bar(24.72, 7.62, [$p'_1$], [$theta'_1$], w: 1.62)
  param-bar(24.72, 7.16, [$p'_2$], [$theta'_2$], w: 1.62)
  lbl(25.70, 6.86, "⋮", size: 6.5pt)
  param-bar(24.72, 6.42, [$p'_N$], [$theta'_N$], w: 1.62)
  brace-right(27.30, 6.36, 7.86)
  lbl(26.05, 6.06, [${(p'_1, theta'_1), ..., (p'_N, theta'_N)}$], size: 4.5pt)

  // ---- 生成器与判别器之间的分隔线 ----
  line(
    (0.0, 4.62), (28.55, 4.62),
    stroke: (paint: rgb("#777777"), thickness: 0.8pt, dash: (2.2pt, 1.2pt, 0.35pt, 1.2pt)),
  )

  // ================= 下半部分：Wireframe Rendering Discriminator =================
  // 左侧说明：这一行是线框渲染判别器
  two-line(1.05, 2.62, "Wireframe Rendering", "Discriminator", size: 7pt)

  // ---- ① 判别器输入：生成器输出的布局参数 ----
  two-line(3.55, 4.14, "Class", "Probabilities", size: 4.2pt)
  two-line(5.15, 4.14, "Geometric", "Parameters", size: 4.2pt)
  brace-left(2.55, 1.70, 3.66)
  param-bar(2.75, 3.38, [$p'_1$], [$theta'_1$])
  param-bar(2.75, 2.92, [$p'_2$], [$theta'_2$])
  lbl(4.00, 2.63, "⋮", size: 6pt)
  param-bar(2.75, 2.20, [$p'_N$], [$theta'_N$])
  lbl(4.05, 1.62, [${(p'_1, theta'_1), ..., (p'_N, theta'_N)}$], size: 4.45pt)

  block-arrow(6.42, 2.75)

  // ---- ② 可微线框渲染：把图形域的参数画成可视域图像 ----
  panel(7.20, 1.62, 10.55, 3.78, fill: RENDER, stroke: rgb("#d99a63"), r: 0.42)
  lbl(8.88, 3.02, "Differentiable", size: 5.7pt)
  lbl(8.88, 2.70, "Wireframe Rendering", size: 5.7pt)
  lbl(8.88, 2.02, "(Graphic -> Visual Domain)", size: 5.1pt)

  block-arrow(10.62, 2.75)

  // ---- ③ 线框布局图：每个设计元素带一个彩色包围框 ----
  lbl(13.02, 4.14, "Wireframe Layout", size: 6.8pt)
  rect((11.30, 0.82), (14.72, 3.78), fill: rgb("#1f4a45"), stroke: ink(0.6pt))
  // 地面色带
  rect((11.30, 0.82), (14.72, 1.42), fill: rgb("#2c5d3a"), stroke: none)

  // 太阳：圆盘 + 八条短射线，外加粉色包围框
  circle((12.10, 3.22), radius: 0.21, fill: rgb("#b08a1e"), stroke: none)
  for a in range(0, 8) {
    let th = a * calc.pi / 4
    let c = (12.10 + 0.29 * calc.cos(th), 3.22 + 0.29 * calc.sin(th))
    let e = (12.10 + 0.37 * calc.cos(th), 3.22 + 0.37 * calc.sin(th))
    line(c, e, stroke: (paint: rgb("#b08a1e"), thickness: 0.8pt))
  }
  rect((11.80, 2.91), (12.40, 3.53), fill: none, stroke: (paint: rgb("#e39aa8"), thickness: 1.1pt))

  // 树：树干 + 树冠 + 果实，外加绿色包围框
  rect((13.18, 1.42), (13.30, 1.86), fill: rgb("#5a2d1a"), stroke: none)
  circle((13.24, 2.35), radius: 0.40, fill: rgb("#1c5c2a"), stroke: none)
  for p in ((13.10, 2.48), (13.34, 2.55), (13.24, 2.22), (13.44, 2.34)) {
    circle(p, radius: 0.025, fill: rgb("#8c1d1d"), stroke: none)
  }
  rect((12.82, 1.40), (13.68, 2.78), fill: none, stroke: (paint: rgb("#57d36a"), thickness: 1.1pt))

  // 左侧小孩：头 + 身体 + 四肢，外加黄色包围框
  circle((11.92, 2.16), radius: 0.095, fill: rgb("#e5c46a"), stroke: none)
  line((11.92, 2.06), (11.92, 1.76), stroke: (paint: rgb("#d46a86"), thickness: 1.2pt))
  line((11.92, 1.98), (11.78, 2.10), stroke: (paint: rgb("#d46a86"), thickness: 0.9pt))
  line((11.92, 1.98), (12.06, 2.10), stroke: (paint: rgb("#d46a86"), thickness: 0.9pt))
  line((11.92, 1.76), (11.82, 1.48), stroke: (paint: rgb("#d46a86"), thickness: 0.9pt))
  line((11.92, 1.76), (12.02, 1.48), stroke: (paint: rgb("#d46a86"), thickness: 0.9pt))
  rect((11.72, 1.44), (12.14, 2.30), fill: none, stroke: (paint: rgb("#e8e06a"), thickness: 1.1pt))

  // 右侧小孩：头 + 身体 + 四肢，外加蓝 / 品红双层包围框
  circle((13.98, 2.02), radius: 0.095, fill: rgb("#d9b27a"), stroke: none)
  line((13.98, 1.92), (13.98, 1.62), stroke: (paint: rgb("#3b6fb5"), thickness: 1.2pt))
  line((13.98, 1.86), (13.84, 1.98), stroke: (paint: rgb("#3b6fb5"), thickness: 0.9pt))
  line((13.98, 1.86), (14.12, 1.98), stroke: (paint: rgb("#3b6fb5"), thickness: 0.9pt))
  line((13.98, 1.62), (13.88, 1.36), stroke: (paint: rgb("#3b6fb5"), thickness: 0.9pt))
  line((13.98, 1.62), (14.08, 1.36), stroke: (paint: rgb("#3b6fb5"), thickness: 0.9pt))
  rect((13.72, 1.30), (14.26, 2.22), fill: none, stroke: (paint: rgb("#5a6de0"), thickness: 1.1pt))
  rect((13.78, 1.38), (14.20, 2.14), fill: none, stroke: (paint: rgb("#c25ad6"), thickness: 0.9pt))

  block-arrow(14.82, 2.75)

  // ---- ④ CNN：三层特征图逐层缩小，学习线框布局的空间模式 ----
  lbl(18.25, 4.14, "CNN", size: 6.8pt)
  panel(15.48, 1.10, 21.18, 3.80, r: 0.45)
  slab(16.05, 1.45, 0.92, 1.90, d: 0.32, cols: 3, rows: 4)
  slab(17.95, 1.60, 0.74, 1.52, d: 0.28, cols: 2, rows: 3)
  slab(19.55, 1.75, 0.58, 1.18, d: 0.24, cols: 2, rows: 2)
  arrow((17.32, 2.42), (17.86, 2.42), t: 0.8pt)
  arrow((19.06, 2.42), (19.46, 2.42), t: 0.8pt)

  block-arrow(21.26, 2.45, w: 0.62, h: 0.4)

  // ---- ⑤ fc + Real / Fake 二分类输出 ----
  rect((21.98, 1.92), (22.14, 3.10), fill: rgb("#d0d0d0"), stroke: ink(0.55pt))
  lbl(22.06, 3.24, "fc", size: 4.7pt)
  arrow((22.20, 2.50), (22.72, 2.50))
  lbl(22.82, 2.58, "Real / Fake", size: 6.4pt, anchor: "west")
  lbl(22.82, 2.22, "Prediction", size: 6.4pt, anchor: "west")
})
