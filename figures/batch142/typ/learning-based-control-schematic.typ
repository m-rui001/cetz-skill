#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 学习控制策略框图（Actuators 2024, 13(2), 52, Fig.21；DOI 10.3390/act13020052）：
// 虚线框内“学习逆模型→轨迹优化→连续体机器人”开环；采样数据回流到控制策略，再驱动连续体机器人。
#canvas({
  import draw: *

  // 复用标签：目标位姿上标 des
  let xdes = $x^"des"$

  // 通用方框：矩形 + 居中多行文字
  let box(x1, y1, x2, y2, lines) = {
    rect((x1, y1), (x2, y2), stroke: (paint: black, thickness: 0.6pt))
    let cx = (x1 + x2) / 2
    let cy = (y1 + y2) / 2
    let n = lines.len()
    for (i, l) in lines.enumerate() {
      content((cx, cy + (n - 1) * 0.21 - i * 0.42), l, anchor: "center")
    }
  }
  // 线段箭头（可折线）
  let ar(..pts) = line(..pts, stroke: (paint: black, thickness: 0.6pt), mark: (end: "stealth"))

  // 训练数据采集外框（虚线）
  rect((0.4, 1.3), (13.9, 4.62), stroke: (paint: black, thickness: 0.6pt, dash: "dashed"))

  // 上行三个模块
  box(2.5, 2.95, 5.7, 4.0, ("Learned inverse", "model"))
  box(6.4, 2.95, 9.6, 4.0, ("Trajectory", "optimization"))
  box(10.4, 2.95, 13.6, 4.0, ("Continuum", "robot"))

  // 目标输入与模块间信号流
  ar((1.0, 3.475), (2.5, 3.475))
  content((0.45, 3.95), [Target #xdes], anchor: "west")
  ar((5.7, 3.475), (6.4, 3.475))
  ar((9.6, 3.475), (10.4, 3.475))
  content((10.0, 4.45), [#text(size: 7.5pt)[Actuation]], anchor: "center")
  content((10.0, 4.13), [#text(size: 7.5pt)[state]], anchor: "center")

  // 采样数据回流路径：机器人底部→左折→下探入控制策略
  ar((12.0, 2.95), (12.0, 1.95), (8.0, 1.95), (8.0, 1.05))
  content((0.5, 1.52), [Training data acquisition], anchor: "west")
  content((8.3, 1.62), [Samples: $x_i$, $x_(i-1)$, #xdes, $tau_i$], anchor: "west")

  // 控制策略模块及其驱动的连续体机器人
  box(6.9, 1.05, 9.1, -0.45, ("Control", "strategy"))
  box(10.4, 0.8, 13.6, -0.2, ("Continuum", "robot"))
  ar((9.1, 0.3), (10.4, 0.3))

  // 控制策略的两路输入信号
  ar((5.9, 0.62), (6.9, 0.62))
  content((5.85, 0.9), [#xdes], anchor: "west")
  ar((5.3, 0.02), (6.9, 0.02))
  content((5.25, 0.3), [$x_i$, $x_(i-1)$], anchor: "west")
})
