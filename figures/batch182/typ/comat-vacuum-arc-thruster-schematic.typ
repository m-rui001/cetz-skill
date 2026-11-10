#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 真空电弧推力器（VAT）原理示意图：深紫背景、阴极/阳极、等离子体羽流与逐字标注。
// 依据 Aerospace 2024, 11(7), 502, Figure 29 重绘为干净矢量线稿。DOI 10.3390/aerospace11070502
#set text(size: 8pt, fill: rgb("#efedf6"))
#canvas({
  import draw: *

  // 深紫底板
  rect((-9.0, -4.4), (9.0, 4.4), fill: rgb("#2a0b4d"), stroke: none)

  // 中心虚线轴
  line((-8.4, 0), (8.4, 0),
    stroke: (paint: rgb(190, 186, 205, 75%), thickness: 0.45pt, dash: "dashed"))

  // 左侧阴极块
  rect((-5.7, -2.45), (-2.5, 2.35),
    fill: rgb("#121747"), stroke: rgb("#494878"), thickness: 0.55pt)

  // 阴极上的 10µm 标尺框
  rect((-5.65, -0.65), (-5.05, 0.55),
    fill: rgb("#121747"), stroke: rgb("#dad8e6"), thickness: 0.5pt)
  content((-5.35, -0.05), [10µm], angle: 90deg, anchor: "center")

  // 阴极斑点周围的紫色放射线与半圆场线
  for (dx, dy) in ((-0.42, 1.15), (-0.82, 0.95), (-1.13, 0.55),
                   (-1.20, 0), (-1.13, -0.55), (-0.82, -0.95), (-0.42, -1.15)) {
    line((-2.42, 0), (-2.42 + dx, dy),
      stroke: (paint: rgb(178, 92, 204, 85%), thickness: 0.55pt))
  }
  for r in (0.55, 0.95, 1.35) {
    bezier((-2.42, r), (-2.42, -r), (-3.15, r), (-3.15, -r),
      stroke: (paint: rgb(166, 91, 196, 80%), thickness: 0.65pt))
  }

  // 阴极前方的多层阴极鞘/金属蒸气区
  for (x0, x1, col) in (
    (-2.45, -2.28, rgb(70, 75, 52, 72%)),
    (-2.28, -2.12, rgb(100, 90, 42, 72%)),
    (-2.12, -1.92, rgb(42, 85, 60, 68%)),
  ) {
    rect((x0, -1.9), (x1, 1.9), fill: col, stroke: none)
  }
  for x in (-2.45, -2.28, -2.12, -1.92) {
    line((x, -1.9), (x, 1.9), stroke: (paint: rgb("#5a6b64"), thickness: 0.35pt))
  }

  // 熔化金属斑点
  circle((-2.40, 0), radius: 0.27, fill: rgb(255, 180, 0, 30%), stroke: none)
  circle((-2.40, 0), radius: 0.18, fill: rgb("#ffc21a"), stroke: none)

  // 半透明等离子体羽流锥
  line(
    (-1.95, 0.30), (7.85, 2.05), (7.85, -2.05), (-1.95, -0.30),
    close: true, fill: rgb(137, 153, 160, 24%), stroke: none
  )

  // 中心放电/观察通道
  rect((-2.2, -0.28), (4.75, 0.28),
    fill: rgb(240, 245, 255, 8%), stroke: rgb("#e8e8ef"), thickness: 0.55pt)

  // 电子冷却导致的电场弧线
  for r in (0.70, 1.25, 1.80) {
    bezier(
      (-2.2, r), (-2.2, -r),
      (-2.2 + 1.35 * r, r), (-2.2 + 1.35 * r, -r),
      stroke: (paint: rgb("#3e8dcc"), thickness: 0.75pt)
    )
  }

  // 右侧环形阳极的上下截面块
  rect((5.25, 0.82), (5.80, 2.08),
    fill: rgb("#14194d"), stroke: rgb("#4b4f7e"), thickness: 0.55pt)
  rect((5.25, -2.08), (5.80, -0.82),
    fill: rgb("#14194d"), stroke: rgb("#4b4f7e"), thickness: 0.55pt)

  // 离子（绿色大点）与电子（蓝色小点）分布
  let ions = (
    (-1.65, 0.18), (-1.35, -0.28), (-0.85, 0.45), (-0.55, -0.52),
    (-0.18, 0.10), (0.10, 0.56), (0.34, -0.26), (0.56, 0.32),
    (0.82, -0.58), (1.02, 0.64), (1.26, 0.05), (1.47, -0.32),
    (1.70, 0.55), (1.97, -0.46), (2.22, 0.16), (2.55, -0.10),
    (2.82, 0.70), (3.10, -0.56), (3.34, 0.25), (3.72, -0.20),
    (4.02, 0.89), (4.22, -0.82), (4.52, 0.45), (4.82, -0.36),
    (5.42, 0.52), (5.82, -0.12), (6.22, 0.70), (6.62, -0.50),
    (6.92, 0.26), (7.30, -0.82), (7.62, 0.55),
  )
  let electrons = (
    (-1.42, 0.10), (-0.92, -0.20), (-0.30, 0.40), (0.48, -0.10),
    (1.20, 0.35), (1.82, -0.60), (2.40, 0.50), (3.02, -0.35),
    (3.82, 0.60), (4.42, -0.55), (5.52, 0.60), (6.12, -0.60),
    (6.82, 0.50),
  )
  for (x, y) in ions {
    circle((x, y), radius: 0.11, fill: rgb("#a7df28"), stroke: none)
  }
  for (x, y) in electrons {
    circle((x, y), radius: 0.055, fill: rgb("#1fa7e0"), stroke: none)
  }

  // 顶部标注及引线
  content((-2.9, 4.05), align(center)[Melting metal #linebreak() (Joule effect)],
    anchor: "center")
  line((-2.65, 3.55), (-2.40, 0.38),
    mark: (end: "stealth"), stroke: (paint: rgb("#d8d6e4"), thickness: 0.45pt))

  content((0.55, 4.05), align(center)[Electric field due to #linebreak() electron cooling],
    anchor: "center")
  line((0.30, 3.50), (-0.45, 1.55),
    mark: (end: "stealth"), stroke: (paint: rgb("#d8d6e4"), thickness: 0.45pt))

  content((6.45, 4.05), [Quasi neutral plasma], anchor: "center")
  line((6.45, 3.62), (6.62, 1.62),
    mark: (end: "stealth"), stroke: (paint: rgb("#d8d6e4"), thickness: 0.45pt))

  content((3.65, 2.85), [Electron flux e-], anchor: "center")
  line((3.45, 2.52), (3.20, 0.65),
    mark: (end: "stealth"), stroke: (paint: rgb("#d8d6e4"), thickness: 0.45pt))

  // 羽流内部标注
  content((2.05, -0.78), [Ionized metal], anchor: "center")

  // 底部标注及引线（错位排布，避免文字重叠）
  content((-5.8, -3.45), align(center)[Cathode #linebreak() (metal propellant) #linebreak() 0V],
    anchor: "center")
  line((-5.55, -2.90), (-4.95, -2.42),
    mark: (end: "stealth"), stroke: (paint: rgb("#d8d6e4"), thickness: 0.45pt))

  content((-3.30, -3.45), [Cathode sheath], anchor: "center")
  line((-3.20, -3.12), (-2.30, -1.45),
    mark: (end: "stealth"), stroke: (paint: rgb("#d8d6e4"), thickness: 0.45pt))

  content((-0.85, -2.35), [Metal vapor], anchor: "center")
  line((-1.05, -2.05), (-1.55, -0.80),
    mark: (end: "stealth"), stroke: (paint: rgb("#d8d6e4"), thickness: 0.45pt))

  content((1.85, -3.45), [Plasma Jet expansion], anchor: "center")
  line((1.70, -3.12), (1.25, -1.05),
    mark: (end: "stealth"), stroke: (paint: rgb("#d8d6e4"), thickness: 0.45pt))

  content((5.52, -3.02), [Anode 250V], anchor: "north")
  line((5.52, -2.96), (5.52, -2.15),
    mark: (end: "stealth"), stroke: (paint: rgb("#d8d6e4"), thickness: 0.45pt))

  content((7.25, -3.32), align(center)[Ions #linebreak() (up to 30km.s-1)],
    anchor: "center")
  line((7.02, -2.85), (6.80, -1.15),
    mark: (end: "stealth"), stroke: (paint: rgb("#d8d6e4"), thickness: 0.45pt))
})
