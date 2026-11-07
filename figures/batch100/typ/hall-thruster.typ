// 编译效果：霍尔推力器原理示意图。左侧圆角灰箱 Propellant Storage 经粗黑线与阀 V 接放电室左壁；
// 壁内灰色短矩形为阳极/气体分配器，上下白虚线+黑箭头标注 Injected Gas，左下斜指箭头标注 Anode & Gas Distributor；
// 浅灰放电室粗黑边框、右壁留出口；顶/底壁灰菱形蓝描边为磁极，顶部斜指标注 Magnetic Field Source；
// 室内白色星芒为电离区，上方 Radial B⃗ 粗箭头下指、下方括号标 Ionization；右上灰椭圆蓝描边 Cathode，
// 其 e⁻ 直箭头指向出口外标 Neutralize Exhaust，弯弧 e⁻ 箭头标 Forming Hall Current；
// 星芒右侧 Axial E⃗ 短虚线箭头，三条水平黑虚线束流指向出口，最右竖直括号标 Accelerated Beam Exhaust。
// 来源：Propulsion Technologies for CubeSats: Review, Aerospace 2024, 11(7), 502, Figure 23. DOI 10.3390/aerospace11070502
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 11pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 语义坐标常量：放电室壁、星芒中心、右壁出口、束流起点
#let (cx0, cx1, cy0, cy1) = (0, 10, 0, 5.5)
#let (sx, sy) = (4.6, 2.75)
#let (exit-y0, exit-y1) = (0.9, 4.5)
#let beam-x0 = 7.5
#let pole-x = 4.4
#let blue = rgb("#33608C")
#let head = (end: "stealth", fill: black, length: 0.3, width: 0.26)
#let dash-long = (7pt, 3.5pt)

// 共享 helper：圆角灰箱（存储箱）
#let rounded-box(at, w, h, label) = {
  let (x, y) = at
  draw.rect((x - w / 2, y - h / 2), (x + w / 2, y + h / 2),
    radius: 0.35, fill: luma(217), stroke: 1.5pt + black)
  draw.content(at, label)
}
// 共享 helper：阀门小圆 V
#let valve-circle(at) = {
  draw.circle(at, radius: 0.45, fill: white, stroke: 1.5pt + black)
  draw.content(at, [V])
}
// 共享 helper：磁极菱形（灰底蓝描边）
#let magnet-pole(at) = {
  let (x, y) = at
  draw.line((x - 0.9, y), (x, y + 0.35), (x + 0.9, y), (x, y - 0.35),
    close: true, fill: luma(150), stroke: 1.2pt + blue)
}
// 共享 helper：电离区星芒（for 循环交替内外半径尖角，白底灰描边）
#let starburst(at, r) = {
  let (x, y) = at
  let pts = ()
  for i in range(24) {
    let a = i * 15deg
    let rr = if calc.rem(i, 2) == 1 { r * 0.45 } else { r }
    pts.push((x + rr * calc.cos(a), y + rr * calc.sin(a)))
  }
  draw.line(..pts, close: true, fill: white, stroke: 1.2pt + gray)
}
// 共享 helper：水平黑虚线右箭头束流
#let dashed-beam(y) = draw.line((beam-x0, y), (cx1, y),
  stroke: (thickness: 2.5pt, dash: dash-long), mark: head)
// 共享 helper：文字+斜指箭头
#let point-label(text, from, to, anchor: "south") = {
  draw.content(from, text, anchor: anchor)
  draw.line(from, to, stroke: 1.2pt + black, mark: head)
}
// 共享 helper：右侧竖直括号+两行标签
#let bracket-right(x, y0, y1, label) = {
  let ym = (y0 + y1) / 2
  draw.line((x - 0.2, y1), (x, y1), (x, y0), (x - 0.2, y0), stroke: 1pt + black)
  draw.line((x, ym), (x + 0.2, ym), stroke: 1pt + black)
  draw.content((x + 0.45, ym), label, anchor: "west")
}

#canvas({
  import draw: *
  // 放电室：浅灰底 + 粗黑壁，右壁上下两短段留出口
  rect((cx0, cy0), (cx1, cy1), fill: luma(217), stroke: none)
  line((cx0, cy0), (cx0, cy1), stroke: 3.5pt)
  line((cx0, cy1), (cx1, cy1), stroke: 3.5pt)
  line((cx0, cy0), (cx1, cy0), stroke: 3.5pt)
  line((cx1, exit-y1), (cx1, cy1), stroke: 3.5pt)
  line((cx1, cy0), (cx1, exit-y0), stroke: 3.5pt)
  // 推进剂供给：存储箱 -> 阀 V -> 左壁
  rounded-box((-3.9, 2.75), 3.2, 2.5, [Propellant\ Storage])
  line((-2.3, 2.75), (-1.7, 2.75), stroke: 3pt)
  valve-circle((-1.25, 2.75))
  line((-0.8, 2.75), (cx0, 2.75), stroke: 3pt)
  // 阳极/气体分配器灰矩形 + 跨壁白虚线框
  rect((0, 2.3), (1.8, 2.9), fill: luma(150), stroke: none)
  rect((-0.2, 1.95), (0.6, 3.25), stroke: (paint: white, thickness: 2pt, dash: (5pt, 3pt)))
  // 上下 Injected Gas：白虚线 + 黑实心右箭头（循环 ±dy）
  for (dy, ly) in ((0.55, 0.5), (-0.6, -0.5)) {
    let y = 2.6 + dy
    line((-0.15, y), (0.45, y), stroke: (paint: white, thickness: 2pt, dash: (5pt, 3pt)))
    line((0.45, y), (1.0, y), stroke: 2.5pt, mark: head)
    content((2.3, y + ly), [Injected Gas])
  }
  point-label([Anode &\ Gas Distributor], (-2.0, 1.0), (0.2, 2.45), anchor: "north")
  // 顶/底磁极菱形 + 顶部斜指标签
  magnet-pole((pole-x, cy1))
  magnet-pole((pole-x, cy0))
  point-label([Magnetic Field Source], (6.3, 6.3), (4.75, 5.85))
  // 电离区星芒 + Radial B 粗下箭头 + 下方括号 Ionization
  starburst((sx, sy), 1.2)
  content((sx, 4.4), [Radial $arrow(B)$])
  line((sx, 4.1), (sx, sy), stroke: 3pt, mark: head)
  line((sx - 0.8, 1.45), (sx - 0.8, 1.2), (sx + 0.8, 1.2), (sx + 0.8, 1.45), stroke: 1pt)
  line((sx, 1.2), (sx, 1.05), stroke: 1pt)
  content((sx, 0.75), [Ionization])
  // Cathode 椭圆骑顶壁 + e⁻ 直箭头中和排气 + 右侧两行标签
  circle((8.45, cy1), radius: (1.2, 0.35), fill: luma(150), stroke: 1.2pt + blue)
  content((8.45, cy1), [Cathode])
  line((9.5, 5.2), (10.15, 3.9), stroke: 1.5pt, mark: head)
  content((10.5, 4.5), $e^-$)
  content((11.2, 4.4), [Neutralize\ Exhaust], anchor: "west")
  // Forming Hall Current 两行 + e⁻ 弯弧左箭头
  content((7.0, 4.6), [Forming\ Hall Current])
  bezier((8.45, 4.85), (6.0, 3.6), (8.4, 3.9), (7.2, 3.6),
    stroke: 1.2pt, mark: head)
  content((5.7, 3.6), $e^-$)
  // Axial E + 短虚线右箭头
  content((6.5, 2.95), [Axial $arrow(E)$])
  line((5.2, 2.5), (6.0, 2.5), stroke: (thickness: 2pt, dash: "dotted"), mark: head)
  // 三条束流虚线右箭头（for 循环 over y 列表）
  for y in (2.1, 2.75, 3.4) { dashed-beam(y) }
  // 最右竖直括号 + Accelerated Beam Exhaust
  bracket-right(10.6, 1.7, 3.7, [Accelerated\ Beam Exhaust])
})