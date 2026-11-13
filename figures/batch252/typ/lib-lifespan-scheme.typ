#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：白底矢量线稿，洋红主链 1→6 沿右上斜向排布，紫/蓝/青三条回用环与黄色收集环汇入，节点圆内为图元小图标。
// 来源：Batteries 2024, 10, 38, Figure 3, Scheme of the LIB lifespan, from production to disposal. https://doi.org/10.3390/batteries10010038
#canvas({
  import draw: *
  let mag = rgb("#e3007d")
  let pur = rgb("#7b2fc4")
  let blu = rgb("#2f5bb7")
  let tea = rgb("#00bfae")
  let yel = rgb("#f5a300")
  let ink = rgb("#1c1c1c")
  // 共享助手：以圆心为原点的相对定位
  let at(p, dx, dy) = (p.at(0) + dx, p.at(1) + dy)
  // 地标：编号 -> 圆心与半径
  let N = (
    "1": ((1.12, 6.93), 0.46), "2": ((2.45, 6.02), 0.44),
    "3": ((3.80, 5.19), 0.45), "4": ((5.07, 4.42), 0.40),
    "5": ((6.40, 3.59), 0.42), "6": ((7.77, 2.82), 0.40),
    "0": ((5.58, 1.22), 0.42),
  )

  // 图标：采矿（镐与矿堆）
  let icoMine(p, s) = {
    line(at(p, -0.36 * s, -0.40 * s), at(p, 0.08 * s, 0.12 * s), stroke: (paint: ink, thickness: 1.8pt))
    arc(at(p, 0.08 * s, 0.04 * s), start: 158deg, stop: 22deg, radius: 0.44 * s, stroke: (paint: ink, thickness: 2.4pt))
    circle(at(p, -0.50 * s, -0.42 * s), radius: 0.14 * s, fill: ink, stroke: none)
    circle(at(p, -0.22 * s, -0.54 * s), radius: 0.11 * s, fill: ink, stroke: none)
    circle(at(p, 0.04 * s, -0.46 * s), radius: 0.09 * s, fill: ink, stroke: none)
  }
  // 图标：部件制造（颗粒与极片）
  let icoComp(p, s) = {
    rect(at(p, -0.52 * s, 0.00 * s), at(p, -0.18 * s, 0.40 * s), stroke: (paint: ink, thickness: 1.1pt), fill: rgb("#cfe3f7"))
    rect(at(p, 0.12 * s, -0.44 * s), at(p, 0.46 * s, -0.04 * s), stroke: (paint: ink, thickness: 1.1pt), fill: rgb("#ffdcb0"))
    circle(at(p, -0.08 * s, 0.44 * s), radius: 0.15 * s, stroke: (paint: ink, thickness: 1.1pt), fill: rgb("#f6c9dd"))
    circle(at(p, -0.32 * s, -0.40 * s), radius: 0.13 * s, stroke: (paint: ink, thickness: 1.1pt), fill: rgb("#c9a8e0"))
  }
  // 图标：电芯（圆柱壳与正极帽）
  let icoCell(p, s) = {
    rect(at(p, -0.20 * s, -0.50 * s), at(p, 0.20 * s, 0.26 * s), stroke: (paint: ink, thickness: 1.4pt), fill: rgb("#bfe6d8"))
    line(at(p, -0.08 * s, 0.26 * s), at(p, -0.08 * s, 0.42 * s), stroke: (paint: ink, thickness: 1.2pt))
    line(at(p, 0.08 * s, 0.26 * s), at(p, 0.08 * s, 0.42 * s), stroke: (paint: ink, thickness: 1.2pt))
    line(at(p, -0.08 * s, 0.42 * s), at(p, 0.08 * s, 0.42 * s), stroke: (paint: ink, thickness: 1.2pt))
    line(at(p, -0.20 * s, 0.06 * s), at(p, 0.20 * s, 0.06 * s), stroke: (paint: ink, thickness: 0.9pt))
  }
  // 图标：终端使用（笔电与汽车）
  let icoUse(p, s) = {
    rect(at(p, -0.54 * s, 0.06 * s), at(p, -0.02 * s, 0.42 * s), stroke: (paint: ink, thickness: 1.3pt), fill: white)
    line(at(p, -0.64 * s, 0.00 * s), at(p, 0.08 * s, 0.00 * s), stroke: (paint: ink, thickness: 1.6pt))
    line(at(p, 0.14 * s, -0.20 * s), at(p, 0.22 * s, -0.34 * s), at(p, 0.58 * s, -0.34 * s), at(p, 0.64 * s, -0.20 * s), close: true, stroke: (paint: ink, thickness: 1.2pt), fill: white)
    circle(at(p, 0.26 * s, -0.40 * s), radius: 0.07 * s, fill: ink, stroke: none)
    circle(at(p, 0.54 * s, -0.40 * s), radius: 0.07 * s, fill: ink, stroke: none)
  }
  // 图标：废电池（三支短电芯）
  let icoWaste(p, s) = {
    rect(at(p, -0.46 * s, -0.36 * s), at(p, -0.16 * s, 0.26 * s), stroke: (paint: ink, thickness: 1.2pt), fill: rgb("#f7c9c9"))
    rect(at(p, -0.12 * s, -0.42 * s), at(p, 0.18 * s, 0.20 * s), stroke: (paint: ink, thickness: 1.2pt), fill: rgb("#f7c9c9"))
    rect(at(p, 0.22 * s, -0.30 * s), at(p, 0.50 * s, 0.32 * s), stroke: (paint: ink, thickness: 1.2pt), fill: rgb("#f7c9c9"))
  }
  // 图标：填埋（垃圾箱与散料）
  let icoFill(p, s) = {
    line(at(p, -0.44 * s, 0.12 * s), at(p, 0.42 * s, 0.12 * s), stroke: (paint: ink, thickness: 1.8pt))
    line(at(p, -0.30 * s, 0.12 * s), at(p, -0.36 * s, -0.44 * s), at(p, 0.34 * s, -0.44 * s), at(p, 0.28 * s, 0.12 * s), stroke: (paint: ink, thickness: 1.3pt))
    circle(at(p, -0.10 * s, 0.28 * s), radius: 0.09 * s, fill: ink, stroke: none)
    circle(at(p, 0.12 * s, 0.34 * s), radius: 0.07 * s, fill: ink, stroke: none)
  }
  // 图标：收集与预处理（扳手与螺丝刀）
  let icoFix(p, s) = {
    circle(at(p, -0.20 * s, 0.26 * s), radius: 0.14 * s, stroke: (paint: ink, thickness: 1.7pt), fill: white)
    line(at(p, -0.12 * s, 0.16 * s), at(p, 0.18 * s, -0.38 * s), stroke: (paint: ink, thickness: 1.7pt))
    line(at(p, 0.22 * s, 0.42 * s), at(p, 0.08 * s, 0.24 * s), stroke: (paint: ink, thickness: 3.4pt))
    line(at(p, 0.08 * s, 0.24 * s), at(p, -0.24 * s, -0.40 * s), stroke: (paint: ink, thickness: 1.4pt))
  }

  // 四条回流环：紫（再生）、蓝（修复）、青（梯次利用）、黄（收集），先画以便被色块遮盖
  bezier((5.28, 1.08), (0.52, 2.20), (3.20, 0.72), (0.52, 1.30), stroke: (paint: pur, thickness: 2.8pt))
  bezier((0.52, 2.20), (0.74, 6.62), (0.50, 3.70), (0.44, 5.10), stroke: (paint: pur, thickness: 2.8pt), mark: (end: "stealth", scale: 0.45))
  bezier((5.34, 1.40), (2.04, 2.80), (3.80, 1.06), (2.10, 1.86), stroke: (paint: blu, thickness: 2.8pt))
  bezier((2.04, 2.80), (2.10, 5.70), (2.00, 4.00), (1.94, 5.00), stroke: (paint: blu, thickness: 2.8pt), mark: (end: "stealth", scale: 0.45))
  bezier((5.22, 1.28), (3.48, 2.58), (3.95, 1.12), (3.28, 2.02), stroke: (paint: tea, thickness: 2.8pt))
  bezier((3.48, 2.58), (6.06, 3.34), (3.64, 3.30), (4.58, 3.52), stroke: (paint: tea, thickness: 2.8pt), mark: (end: "stealth", scale: 0.45))
  bezier((5.96, 1.06), (6.72, 3.30), (7.06, 1.12), (7.22, 2.80), stroke: (paint: yel, thickness: 2.8pt), mark: (end: "stealth", scale: 0.45))

  // 洋红主链：1→2→3→4→5→6
  for (a, b) in (("1", "2"), ("2", "3"), ("3", "4"), ("4", "5"), ("5", "6")) {
    let (pa, ra) = N.at(a)
    let (pb, rb) = N.at(b)
    let d = (pb.at(0) - pa.at(0), pb.at(1) - pa.at(1))
    let L = calc.sqrt(d.at(0) * d.at(0) + d.at(1) * d.at(1))
    let u = (d.at(0) / L, d.at(1) / L)
    line((pa.at(0) + u.at(0) * (ra + 0.02), pa.at(1) + u.at(1) * (ra + 0.02)),
      (pb.at(0) - u.at(0) * (rb + 0.10), pb.at(1) - u.at(1) * (rb + 0.10)),
      stroke: (paint: mag, thickness: 3.2pt), mark: (end: "stealth"))
  }

  // 三条回用椭圆标签，白底遮盖穿过的曲线
  for (c, col, t) in (
    ((1.12, 4.59), pur, [Recycling]),
    ((2.43, 3.70), blu, [Repairing \ Healing]),
    ((3.83, 2.94), tea, [Reuse \ Second life]),
  ) {
    circle(c, radius: (0.80, 0.42), stroke: (paint: col, thickness: 2.4pt), fill: white)
    content(c, text(size: 7.5pt, weight: "bold", t))
  }

  // 七个主链节点：彩色圆环＋内部图标
  for (k, c, icon) in (("1", mag, icoMine), ("2", mag, icoComp), ("3", mag, icoCell), ("4", mag, icoUse), ("5", mag, icoWaste), ("6", mag, icoFill), ("0", yel, icoFix)) {
    let (p, r) = N.at(k)
    circle(p, radius: r, stroke: (paint: c, thickness: 2.2pt), fill: white)
    icon(p, r)
  }

  // 步骤编号与逐字标签
  for (k, npos, tpos, t) in (
    ("1", (1.66, 7.26), (1.90, 7.18), "Mining for Critical Raw Materials"),
    ("2", (2.94, 6.38), (3.18, 6.31), "LIB  components fabrication"),
    ("3", (4.30, 5.55), (4.54, 5.48), "LIB  manufacturing"),
    ("4", (5.54, 4.86), (5.78, 4.79), "End use"),
    ("5", (6.88, 4.03), (7.12, 3.96), "Waste LIBs"),
    ("6", (8.26, 3.24), (8.50, 3.17), "Landfill  disposal"),
    ("0", (6.26, 1.36), (6.62, 1.28), "Waste LIB  collection and"),
  ) {
    content(npos, text(size: 15pt, weight: "bold", k), anchor: "south-west")
    content(tpos, text(size: 8pt, t), anchor: "west")
  }
  // 0 号节点标签的第二行
  content((6.62, 0.92), text(size: 8pt, "pretreatments"), anchor: "west")
})
