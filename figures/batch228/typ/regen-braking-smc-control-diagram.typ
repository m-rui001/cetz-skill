// 编译结果：横向控制框图，9 个圆角模块（蓝驱动链/橙转矩估计/洋红状态估计/琥珀滑模控制/
// 紫功率控制），左侧蓝色控制输入与底部绿色反馈回路，中间虚线框内三箭头闭环，右端橙色输出箭标。
// 来源：Actuators 2025, 14, 347 (DOI 10.3390/act14070347), Figure 19 "A Sliding Mode Control system
// for regenerative braking in EVs"，按干净线稿平涂重绘。
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  // 配色：模块填充、线色、强调色
  let blue = rgb("#1a6fb4")
  let green = rgb("#1f8a2e")
  let dgreen = rgb("#17701f")
  let purple = rgb("#9b6bd6")
  let dred = rgb("#9e2233")
  let orange = rgb("#f0a020")
  let lab = rgb("#2b4fc4")

  // 折线箭头：统一线宽，可选末端实心箭头
  let wire(pts, c, w: 1.2pt, head: true, s: 1) = line(
    ..pts,
    stroke: (paint: c, thickness: w),
    mark: if head { (end: "stealth", fill: c, scale: s) } else { none },
  )

  // 圆角模块：表驱动，(x0, y0, x1, y1, 填充, 字色, 标签)
  let blocks = (
    (0.30, 3.15, 2.00, 4.50, rgb("#1aa3dd"), white, [Driver \ Module Unit]),
    (2.35, 3.15, 4.05, 4.50, rgb("#f07a1a"), white, [Torque \ Estimation \ Unit]),
    (4.95, 3.40, 6.60, 4.70, rgb("#e0007a"), white, [State \ Estimator]),
    (7.00, 4.72, 8.65, 6.07, rgb("#e8a91b"), black, [Sliding Mode \ Control Unit]),
    (7.25, 2.10, 8.90, 3.45, rgb("#2aa8e0"), white, [Disturbance \ Observer]),
    (10.30, 3.35, 11.55, 4.50, rgb("#6f00d6"), white, [Power \ Control \ Unit]),
    (4.65, 7.00, 7.15, 7.85, rgb("#f7dede"), black, [Brake Mode \ Prediction Unit]),
    (8.80, 7.00, 10.65, 7.85, rgb("#dfe9d1"), black, [SoC Prediction \ Unit]),
    (3.70, 0.60, 5.35, 1.50, rgb("#e5dfe8"), black, [Feedback \ Control Unit]),
  )

  // 滑模控制虚线范围
  rect((4.65, 1.72), (9.65, 6.20), radius: 0.16, stroke: (paint: green, thickness: 1.1pt, dash: "dashed"))

  // 控制输入：上支到制动模式预测，下支进入滑模框
  wire(((3.20, 5.55), (3.20, 7.42), (4.65, 7.42)), blue)
  wire(((3.20, 5.55), (4.65, 5.55)), blue, head: false)

  // 制动模式预测 → 滑模框（深红）
  wire(((6.00, 7.00), (6.00, 6.20)), dred)

  // SoC 预测 → 制动模式预测（车辆模型），功率控制 → SoC 预测（电池 SoC）
  wire(((8.80, 7.42), (7.15, 7.42)), blue)
  wire(((10.90, 4.50), (10.90, 7.42), (10.65, 7.42)), blue)

  // 驱动链：驾驶模块 → 转矩估计 → 状态估计
  wire(((2.00, 3.83), (2.35, 3.83)), purple, w: 2.2pt)
  wire(((4.05, 3.83), (4.95, 3.83)), dgreen, w: 2.6pt)

  // 状态估计 → 功率控制（穿过虚线框）
  wire(((9.45, 3.95), (10.30, 3.95)), green, w: 2.4pt)

  // 框内闭环：状态估计 → 滑模控制 → 扰动观测 → 状态估计
  arc-through((6.10, 4.70), (6.55, 5.34), (7.00, 5.45), stroke: (paint: rgb("#f4a9c4"), thickness: 4.5pt), mark: (end: "stealth", fill: rgb("#f4a9c4"), scale: 1.8))
  arc-through((8.65, 5.55), (9.18, 4.55), (8.90, 3.50), stroke: (paint: rgb("#dcc98f"), thickness: 4.5pt), mark: (end: "stealth", fill: rgb("#dcc98f"), scale: 1.8))
  arc-through((7.25, 2.55), (6.58, 2.38), (6.38, 3.40), stroke: (paint: rgb("#93c9e9"), thickness: 4.5pt), mark: (end: "stealth", fill: rgb("#93c9e9"), scale: 1.8))

  // 功率控制 → 制动执行箭标
  wire(((11.55, 3.95), (11.62, 3.95)), orange, w: 2pt, head: false)
  line(..((11.62, 4.47), (12.32, 4.47), (12.62, 3.93), (12.32, 3.40), (11.62, 3.40)), close: true, fill: orange, stroke: none)

  // 底部反馈回路：功率控制 → 反馈控制 → 驾驶模块
  wire(((10.90, 3.35), (10.90, 1.05), (5.35, 1.05)), dgreen)
  wire(((3.70, 1.05), (1.10, 1.05), (1.10, 3.15)), dgreen)

  // 模块本体与文字
  for b in blocks {
    let (x0, y0, x1, y1, f, tc, t) = b
    rect((x0, y0), (x1, y1), radius: 0.12, fill: f, stroke: 0.7pt + rgb("#4a4a4a"))
    content(((x0 + x1) / 2, (y0 + y1) / 2), text(fill: tc, size: 7.6pt, t))
  }

  // 信号标签
  content((3.05, 6.50), text(fill: dgreen, weight: "bold", size: 9.2pt, [Control Inputs]), anchor: "east")
  content((6.18, 6.62), text(fill: lab, style: "italic", size: 8pt, [Brake Mode]), anchor: "west")
  content((8.68, 7.12), text(fill: lab, style: "italic", size: 7pt, [Vehicle Model]), anchor: "east")
  content((10.80, 6.48), text(fill: lab, style: "italic", size: 8pt, [Battery SoC]), anchor: "east")
  content((2.12, 2.80), text(fill: lab, style: "italic", size: 8pt, [Brake \ Strength]))
  content((4.42, 2.80), text(fill: lab, style: "italic", size: 8pt, [Demand \ Torque]))
  content((6.85, 1.24), text(fill: lab, style: "italic", size: 8pt, [Brake Force, Speed etc.]), anchor: "west")
  content((5.95, 1.96), text(fill: dgreen, weight: "bold", size: 8.8pt, [Sliding Mode Control]), anchor: "west")
  content((12.05, 3.93), text(fill: black, size: 7.0pt, weight: "bold", [Braking \ Force]))
})
