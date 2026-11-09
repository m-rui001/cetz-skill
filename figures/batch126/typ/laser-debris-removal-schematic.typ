#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 激光清除轨道碎片机构示意图，干净线稿平涂版
// 来源：Mechanics of Space Debris Removal, Aerospace 2025, 12, 277, Fig.13. DOI 10.3390/aerospace12040277.
#canvas({
  import draw: *

  // 线性插值助手
  let L(p, q, t) = (p.at(0) + (q.at(0) - p.at(0)) * t, p.at(1) + (q.at(1) - p.at(1)) * t)

  // 太阳能板助手：起点、方向角、长度、宽度、分段
  let solar(pos, ang, len, wid, segs: 4) = {
    let a = ang * 1deg
    let dx = calc.cos(a)
    let dy = calc.sin(a)
    let nx = -dy
    let ny = dx
    let c(t, s) = (pos.at(0) + dx * t + nx * s, pos.at(1) + dy * t + ny * s)
    let w = wid / 2
    line(c(0, -w), c(0, w), c(len, w), c(len, -w), close: true,
      fill: rgb(36, 42, 96), stroke: rgb(105, 112, 150) + 0.5pt)
    for k in range(1, segs) {
      let t = len * k / segs
      line(c(t, -w), c(t, w), stroke: rgb(105, 112, 150) + 0.4pt)
    }
  }

  // 卫星两片太阳能板（上片向右上，下片向左下）
  solar((-3.72, 0.85), 78, 3.4, 0.52)
  solar((-3.88, -0.92), 250, 3.4, 0.52)

  // 卫星主体与端面
  rect((-4.7, -1.0), (-2.5, 0.9), radius: 0.15,
    fill: rgb(205, 205, 212), stroke: rgb(115, 115, 122) + 0.7pt)
  circle((-4.72, -0.05), radius: (0.18, 0.92),
    fill: rgb(193, 193, 201), stroke: rgb(115, 115, 122) + 0.6pt)
  line((-4.5, -0.55), (-2.7, -0.55), stroke: rgb(150, 150, 158) + 0.6pt)
  line((-4.4, -0.78), (-2.8, -0.78), stroke: rgb(150, 150, 158) + 0.6pt)
  line((-3.3, -0.9), (-3.3, 0.8), stroke: rgb(150, 150, 158) + 0.6pt)

  // 尾部四个球形推进器
  for y in (-0.72, -0.32, 0.08, 0.48) {
    circle((-4.95, y), radius: 0.17, fill: rgb(55, 55, 62), stroke: rgb(30, 30, 35) + 0.5pt)
  }

  // 右端喇叭状采集传感器
  line((-2.5, 0.5), (-1.55, 0.9), (-1.55, -1.0), (-2.5, -0.78), close: true,
    fill: rgb(196, 196, 203), stroke: rgb(115, 115, 122) + 0.6pt)
  circle((-1.55, -0.05), radius: (0.1, 0.95),
    fill: rgb(175, 175, 183), stroke: rgb(115, 115, 122) + 0.6pt)

  // 顶部激光器与镜头
  rect((-4.15, 0.88), (-3.5, 1.18), radius: 0.05,
    fill: rgb(190, 190, 198), stroke: rgb(115, 115, 122) + 0.6pt)
  circle((-3.5, 1.03), radius: 0.1, fill: rgb(70, 70, 80), stroke: rgb(40, 40, 45) + 0.5pt)

  // 紫色激光束与末端红色光斑
  line((-3.4, 1.03), (3.2, -0.35), stroke: rgb(150, 55, 160) + 1.3pt)
  line((3.2, -0.35), (2.72, -0.26), stroke: rgb(235, 60, 30) + 2pt)

  // 右侧碎片：外壳、太阳能阵列、网格
  let A = (3.1, -2.0)
  let B = (5.6, -2.25)
  let C = (5.85, 0.95)
  let D = (3.4, 1.15)
  line(A, B, C, D, close: true, fill: rgb(212, 212, 217), stroke: rgb(120, 120, 125) + 0.6pt)
  let A2 = (3.3, -1.78)
  let B2 = (5.45, -2.0)
  let C2 = (5.66, 0.88)
  let D2 = (3.6, 1.0)
  line(A2, B2, C2, D2, close: true, fill: rgb(40, 36, 105), stroke: rgb(120, 110, 160) + 0.4pt)
  for k in (1, 2, 3, 4, 5) {
    line(L(A2, B2, k / 6), L(D2, C2, k / 6), stroke: rgb(120, 110, 170) + 0.4pt)
    line(L(A2, D2, k / 6), L(B2, C2, k / 6), stroke: rgb(120, 110, 170) + 0.4pt)
  }

  // 碎片顶部平台、天线与侧向支杆
  line((4.0, 1.02), (5.0, 0.82), (5.05, 1.38), (4.05, 1.58), close: true,
    fill: rgb(190, 190, 198), stroke: rgb(115, 115, 122) + 0.5pt)
  line((4.55, 1.5), (4.55, 2.55), stroke: rgb(110, 110, 118) + 1.2pt)
  circle((4.55, 2.6), radius: 0.07, fill: rgb(232, 232, 236), stroke: rgb(110, 110, 118) + 0.5pt)
  line((4.12, 1.55), (4.1, 2.2), stroke: rgb(110, 110, 118) + 0.8pt)
  line((4.98, 1.35), (5.0, 2.0), stroke: rgb(110, 110, 118) + 0.8pt)
  line((3.55, 1.1), (3.5, 1.85), stroke: rgb(110, 110, 118) + 0.8pt)
  line((5.32, 0.85), (5.38, 1.6), stroke: rgb(110, 110, 118) + 0.8pt)

  // 标签：Laser
  content((-5.3, 2.55), [Laser])
  line((-5.85, 2.35), (-4.85, 2.35), stroke: 0.7pt)
  line((-4.85, 2.3), (-3.9, 1.22), stroke: 0.5pt)

  // 标签：Ultraviolet pulses laser beam
  content((1.05, 3.95), [Ultraviolet pulses laser beam])
  line((-1.95, 3.75), (4.05, 3.75), stroke: 0.7pt)
  line((-1.55, 3.7), (-0.95, 0.72), stroke: 0.5pt)

  // 标签：Substance flow
  content((0.85, -0.55), [Substance flow])
  line((-0.45, -0.75), (2.15, -0.75), stroke: 0.7pt)
  line((2.1, -0.7), (3.05, -0.33), stroke: 0.5pt)

  // 标签：Acquisition sensor
  content((0.55, -3.35), [Acquisition sensor])
  line((-1.35, -3.55), (2.45, -3.55), stroke: 0.7pt)
  line((-1.3, -3.5), (-1.65, -0.95), stroke: 0.5pt)
})
