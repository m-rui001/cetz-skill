#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 霍尔推力器剖面示意图（线稿平涂版）：外壳剖切、环形放电通道、线圈绕组、
// 空心阴极、中性气体进料、坐标轴 x,r/y/z、E/B 矢量、θ 旋转与指向角。
// 来源：Aerospace 2024, 11(7), 502, Figure 25（CAD 渲染转干净线稿；DOI 10.3390/aerospace11070502）。
#canvas({
  import draw: *
  // 极坐标助手：环心 + 半径 + 角度 → 二维点
  let pol(c, r, a) = (c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a))
  // 圆弧采样为折线点列
  let arcpts(c, r, a0, a1, n: 22) = range(n + 1).map(i => pol(c, r, a0 + (a1 - a0) * i / n))

  // 命名地标
  let A0 = (4.6, 0.8)      // 剖切面左下角
  let C0 = (8.4, 4.6)      // 剖切面右上角
  let O = (6.5, 2.7)       // 环形腔中心

  // 顶面（等轴测）
  line((4.6, 4.6), (8.4, 4.6), (9.2, 5.1), (5.4, 5.1),
       close: true, fill: rgb("#f6f6f6"), stroke: 0.8pt)
  // 右侧面
  line((8.4, 0.8), (8.4, 4.6), (9.2, 5.1), (9.2, 1.3),
       close: true, fill: rgb("#d4d4d4"), stroke: 0.8pt)
  // 前剖切面
  rect(A0, C0, fill: rgb("#ededed"), stroke: 0.8pt)

  // 环形放电通道：磁极环 → 白色通道 → 内磁芯
  circle(O, radius: 1.05, fill: rgb("#8e8e8e"), stroke: 0.8pt)
  circle(O, radius: 0.78, fill: white, stroke: 0.8pt)
  circle(O, radius: 0.32, fill: rgb("#e3e3e3"), stroke: 0.8pt)

  // 左右两侧深色线圈绕组
  line(..arcpts(O, 1.14, 145deg, 215deg), stroke: 5pt + rgb("#3a3a3a"))
  line(..arcpts(O, 1.14, -35deg, 35deg), stroke: 5pt + rgb("#3a3a3a"))

  // 空心阴极（倾斜短管）
  line((8.47, 5.49), (7.94, 4.46), (7.70, 4.58), (8.23, 5.61),
       close: true, fill: rgb("#c9c9c9"), stroke: 0.8pt)
  line((8.38, 5.52), (7.85, 4.49), stroke: 0.5pt + rgb("#666666"))

  // 中性气体进料管（水平 + 下探至腔顶）
  line((1.8, 5.8), (4.9, 5.8), stroke: 2.2pt + rgb("#8a8a8a"))
  line((4.9, 5.8), (4.9, 4.4), stroke: 2.2pt + rgb("#8a8a8a"))
  line((1.8, 5.8), (4.9, 5.8), stroke: 0.5pt)
  line((4.9, 5.8), (4.9, 4.4), stroke: 0.5pt)

  // 坐标系
  line(O, (6.5, 6.7), stroke: 1pt, mark: (end: "stealth"))
  line(O, (9.8, 4.2), stroke: 1pt, mark: (end: "stealth"))
  line(O, (8.9, 0.85), stroke: 1pt, mark: (end: "stealth"))
  content((6.30, 6.90), [*y*], size: 12pt)
  content((10.05, 4.25), [*x,r*], size: 12pt)
  content((8.95, 0.55), [*z*], size: 12pt)

  // 指向角：y 轴到阴极轴线的红色圆弧
  line(..arcpts(O, 1.55, 54deg, 90deg), stroke: 0.9pt + rgb("#c0392b"),
       mark: (end: "stealth"))
  line((7.30, 5.45), (7.10, 4.95), stroke: 0.5pt)
  content((6.90, 5.72), [Pointing Angle], size: 9pt)

  // 绕 y 轴的旋转角 θ
  line(..arcpts(O, 0.55, 45deg, 130deg), stroke: 0.9pt,
       mark: (end: "stealth"))
  content((5.95, 3.00), [θ], size: 10pt)

  // 离子（红）与电场 E（红箭头）
  circle((6.5, 1.75), radius: 0.11, fill: rgb("#d62728"), stroke: none)
  line((6.5, 1.75), (7.40, 1.05), stroke: 1.1pt + rgb("#d62728"),
       mark: (end: "stealth"))
  content((6.72, 1.28), [E], size: 10pt, fill: rgb("#d62728"))

  // 电子（蓝）与向通道的入射箭头
  circle((8.30, 3.90), radius: 0.10, fill: rgb("#1f5fa8"), stroke: none)
  line((8.15, 3.75), (7.35, 3.20), stroke: 1.1pt + rgb("#1f5fa8"),
       mark: (end: "stealth"))

  // 磁场 B（绿箭头，沿径向）
  line((7.50, 2.40), (8.30, 2.70), stroke: 1.1pt + rgb("#2ca02c"),
       mark: (end: "stealth"))
  content((8.48, 2.72), [B], size: 10pt, fill: rgb("#2ca02c"))

  // 引线标注
  line((2.30, 6.10), (3.20, 5.82), stroke: 0.5pt)
  content((1.55, 6.45), [Neutral \ Gas Feed], size: 9pt)

  line((2.90, 4.30), (5.40, 3.35), stroke: 0.5pt)
  content((2.05, 4.45), [Anode], size: 9pt)

  // 磁极引线指向左侧线圈绕组
  line((2.30, 2.05), (5.55, 2.35), stroke: 0.5pt)
  content((1.55, 2.10), [Magnetic \ Poles], size: 9pt)

  line((9.35, 6.05), (8.55, 5.50), stroke: 0.5pt)
  content((9.30, 6.50), [Hollow Cathode], size: 9pt, anchor: "center")
})
