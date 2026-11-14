#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 上肢自适应控制抽象框图：浅灰圆角底板内五个白底彩框——左 Desired Trajectory
// 经求和点入 Adaptive Control，上方 Adaptation Law 与右侧 External Human Forces
// 以橙色 τ_ext(t) 支路驱动，右侧 Human-Robot Interaction 内含人体剪影与绿色轨迹点，
// 底部 P_act(t) 反馈回求和点；红色斜线表示整定参数。来源：Robotics 2024, 13, 181,
// Figure 6 (DOI 10.3390/robotics13120181)

#canvas({
  import draw: *

  // 坐标换算：参考图像素 → cm，y 轴上下翻转
  let k = 0.0127
  let P(x, y) = (x * k, (369 - y) * k)

  // 配色
  let blue = rgb("#2e5496")
  let red = rgb("#c00000")
  let orange = rgb("#ed7d31")
  let green = rgb("#22a552")
  let grey = rgb("#8c8c8c")

  // 圆角框：白底 + 彩色描边 + 居中粗体标题
  let blk(c, x1, y1, x2, y2, body) = {
    rect(P(x1, y1), P(x2, y2), radius: 0.09, stroke: (paint: c, thickness: 1.3pt), fill: white)
    content(P((x1 + x2) / 2, (y1 + y2) / 2), text(size: 7pt, weight: "bold", align(center, body)))
  }
  // 折线信号路径，末端 stealth 箭头
  let sig(pts, col: black, w: 1.1pt, arrow: true, sc: 0.75) = {
    let p = pts.map(q => P(q.at(0), q.at(1)))
    if arrow { line(..p, stroke: (paint: col, thickness: w), mark: (end: "stealth", scale: sc)) }
    else { line(..p, stroke: (paint: col, thickness: w)) }
  }
  // 信号名标签
  let lab(x, y, body, col: black, size: 7pt) = content(P(x, y), text(size: size, fill: col, body))

  // 外框：浅灰圆角大板
  rect(P(12, 12), P(1004, 358), radius: 0.24, stroke: (paint: grey, thickness: 1.2pt), fill: rgb("#f1f1f1"))

  // 主信号链：期望轨迹 → 求和点 → 自适应控制 → 人机交互
  sig(((190, 209), (277, 209)))
  sig(((297, 209), (535, 209)))
  sig(((670, 209), (755, 209)))
  // 误差分支向上折入自适应律左缘
  sig(((340, 209), (340, 136), (368, 136)))
  // 外部人力矩橙色主线，于 x=435 下探入自适应律、x=600 下探入自适应控制
  sig(((775, 60), (435, 60), (435, 100)), col: orange, w: 1.5pt)
  sig(((600, 60), (600, 172)), col: orange, w: 1.5pt)
  // 自适应律输出的整定参数（红色粗线，无箭头）
  sig(((497, 145), (533, 175)), col: red, w: 1.6pt, arrow: false)
  // 自适应控制输出整定参数指向右下文字
  sig(((650, 248), (700, 282)), col: red, w: 1.6pt)
  // 人机交互与外部人力之间的双向作用
  line(P(855, 90), P(855, 125), stroke: (paint: black, thickness: 1.1pt),
    mark: (start: "stealth", end: "stealth", scale: 0.6))
  // 实际位置 P_act 由人机交互右侧绕底反馈回求和点
  sig(((950, 207), (963, 207), (963, 340), (287, 340), (287, 219)))

  // 求和点
  circle(P(287, 209), radius: 0.127, stroke: (paint: black, thickness: 1.1pt), fill: white)

  // 五个功能框
  blk(blue, 33, 165, 190, 255)[Desired \ Trajectory]
  blk(red, 368, 100, 497, 172)[Adaptation \ Law]
  blk(blue, 535, 172, 670, 248)[Adaptive \ Control]
  blk(orange, 775, 30, 940, 90)[External \ Human Forces]

  // 人机交互框：标题在上，下部留出插图区
  rect(P(755, 125), P(950, 295), radius: 0.14, stroke: (paint: blue, thickness: 1.3pt), fill: white)
  content(P(852, 152), text(size: 7pt, weight: "bold")[Human-Robot])
  content(P(852, 175), text(size: 7pt, weight: "bold")[Interaction])

  // 绿色末端轨迹点链（先画连线，再叠空心点）
  let nodes = ((806, 264), (802, 245), (794, 230), (813, 220), (832, 209), (847, 194), (864, 198))
  line(..nodes.map(n => P(n.at(0), n.at(1))), stroke: (paint: green, thickness: 0.9pt))
  for n in nodes {
    circle(P(n.at(0), n.at(1)), radius: 0.092, stroke: (paint: green, thickness: 1.3pt), fill: white)
  }

  // 灰色支撑台
  rect(P(786, 270), P(848, 284), stroke: (paint: grey, thickness: 0.8pt), fill: rgb("#dcdcdc"))

  // 人体剪影：头、躯干、举臂、叉腰臂、双腿
  circle(P(899, 200), radius: 0.145, fill: black, stroke: none)
  line(P(899, 214), P(899, 250), stroke: (paint: black, thickness: 0.24cm, cap: "round"))
  line(P(895, 251), P(886, 289), stroke: (paint: black, thickness: 0.115cm, cap: "round"))
  line(P(903, 251), P(912, 289), stroke: (paint: black, thickness: 0.115cm, cap: "round"))
  line(P(893, 219), P(877, 211), P(867, 199), stroke: (paint: black, thickness: 0.11cm, cap: "round"))
  line(P(906, 221), P(921, 236), P(910, 249), stroke: (paint: black, thickness: 0.11cm, cap: "round"))

  // 台面坐标系 x_b / z_b / y_b
  line(P(798, 271), P(817, 271), stroke: (paint: red, thickness: 0.055cm), mark: (end: "stealth", scale: 0.4))
  line(P(798, 271), P(798, 253), stroke: (paint: rgb("#1f3fb5"), thickness: 0.055cm), mark: (end: "stealth", scale: 0.4))
  line(P(798, 271), P(789, 282), stroke: (paint: green, thickness: 0.055cm), mark: (end: "stealth", scale: 0.4))

  // 信号名与注释文字
  lab(231, 185, $P_(italic("des"))(t)$)
  lab(316, 172, $e(t)$)
  lab(385, 72, $tau_"ext"(t)$)
  lab(657, 107, $tau_"ext"(t)$)
  lab(709, 184, $u(t)$)
  lab(324, 321, $P_(italic("act"))(t)$)
  lab(772, 258, $x_b$, size: 6.5pt)
  lab(824, 251, $z_b$, size: 6.5pt)
  lab(773, 281, $y_b$, size: 6.5pt)
  content(P(692, 310), text(size: 7pt, weight: "bold", fill: red, align(center)[Adapted \ Parameters]))
})
