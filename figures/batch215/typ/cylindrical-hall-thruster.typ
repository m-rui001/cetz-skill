#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 圆柱形霍尔推力器剖面示意图，平涂线稿重绘
// 来源：Aerospace 2024, 11(7), 502, Fig.26；DOI 10.3390/aerospace11070502
#canvas({
  import draw: *
  // 圆柱霍尔推力器剖面示意：灰色磁路、蓝色线圈、黄色氮化硼壁、紫色羽流
  // 依据 Aerospace 2024, 11(7), 502, Figure 26 重绘为干净线稿平涂

  let ink = rgb("#333333")
  let darkgray = rgb("#555555")
  let gray = rgb("#969696")
  let blue = rgb("#2e66a6")
  let fieldblue = rgb("#205fbf")
  let yellow = rgb("#f2c94c")
  let gold = rgb("#e7b733")
  let lavender = rgb("#b9a8e8")
  let edge = (paint: darkgray, thickness: 0.8pt)
  let thin = (paint: darkgray, thickness: 0.5pt)
  let ygold = (paint: rgb("#b88b18"), thickness: 0.45pt)

  let lead(a, b) = line(a, b, stroke: (paint: ink, thickness: 0.55pt))

  // 粗黑排气箭头（自定义五边形）
  let block-arrow(x, y, w, h) = {
    let head = w * 0.42
    let hh = h / 2
    let ah = h * 1.15
    line(
      (x, y - hh), (x + w - head, y - hh), (x + w - head, y - ah / 2),
      (x + w, y), (x + w - head, y + ah / 2),
      (x + w - head, y + hh), (x, y + hh),
      close: true, fill: black, stroke: none
    )
  }

  // 推力器出口外的紫色羽流
  line(
    (7.55, 3.80), (8.35, 3.45), (9.45, 3.00), (10.45, 2.55), (11.50, 2.20),
    (11.50, 9.00), (10.45, 8.60), (9.45, 8.10), (8.35, 7.70), (7.55, 7.10),
    close: true, fill: lavender, stroke: none
  )

  // 两个粗黑排气箭头
  block-arrow(9.25, 6.75, 1.55, 0.62)
  block-arrow(9.25, 3.95, 1.55, 0.62)

  // 灰色磁路外壳：左侧与上下薄臂，右侧开口
  rect((3.00, 1.20), (3.48, 9.40), fill: gray, stroke: edge)
  rect((3.00, 8.82), (7.55, 9.40), fill: gray, stroke: edge)
  rect((3.00, 1.20), (7.55, 1.78), fill: gray, stroke: edge)
  rect((7.05, 7.10), (7.55, 8.82), fill: gray, stroke: edge)
  rect((7.05, 1.78), (7.55, 3.80), fill: gray, stroke: edge)

  // 中央放电腔浅色底
  rect((3.48, 3.80), (7.55, 7.10), fill: rgb("#f8f4ff"), stroke: none)

  // 氮化硼壁：上下内衬与左侧衬里
  for y in (4.10, 6.65) {
    rect((4.25, y), (7.55, y + 0.22), fill: yellow, stroke: ygold)
  }
  rect((4.25, 4.32), (4.47, 6.65), fill: yellow, stroke: ygold)

  // 阳极 / 气体分配器
  rect((4.02, 4.45), (4.22, 6.55), fill: gold, stroke: edge)

  // 内侧磁线圈：左侧上下两个蓝色线圈
  for y in (4.05, 5.55) {
    rect((3.55, y), (3.95, y + 0.62), fill: blue, stroke: edge)
  }

  // 外侧磁线圈：底部蓝色线圈
  rect((5.92, 1.88), (6.98, 2.46), fill: blue, stroke: edge)

  // 阴极中和器与短支撑
  rect((6.42, 7.38), (6.90, 7.84), fill: rgb("#2aa6a0"), stroke: edge)
  line((6.66, 7.84), (6.66, 8.82), stroke: thin)

  // 蓝色轴向/径向磁场曲线箭头
  bezier(
    (4.85, 6.20), (6.35, 5.45), (5.80, 6.28), (6.35, 6.05),
    stroke: (paint: fieldblue, thickness: 1.2pt), mark: (end: "stealth")
  )
  bezier(
    (4.85, 4.70), (6.35, 5.35), (5.80, 4.62), (6.35, 4.85),
    stroke: (paint: fieldblue, thickness: 1.2pt), mark: (end: "stealth")
  )

  // 红色轴向电场箭头
  line(
    (4.95, 5.65), (5.85, 5.65),
    stroke: (paint: rgb("#d62728"), thickness: 1.1pt), mark: (end: "stealth")
  )

  // 腔内小字说明
  content((5.10, 5.98), text(size: 4.5pt, [axial electric \ field]), anchor: "west")
  content((5.05, 4.94), text(size: 4.5pt, [axial/radial \ magnetic field]), anchor: "west")

  // 外部部件标签与引线
  let labels = (
    (pos: (2.35, 10.55), anchor: "center", body: [boron nitride \ walls], target: (4.60, 6.77)),
    (pos: (7.15, 10.55), anchor: "center", body: [cathode \ neutralizer], target: (6.66, 7.62)),
    (pos: (1.55, 7.35), anchor: "center", body: [anode / \ gas distributor], target: (4.12, 6.05)),
    (pos: (1.42, 5.20), anchor: "center", body: [inner \ magnetic \ coil], target: (3.75, 5.86)),
    (pos: (1.35, 0.85), anchor: "center", body: [magnetic \ circuit], target: (3.28, 1.55)),
    (pos: (5.55, 0.35), anchor: "center", body: [outer magnetic \ coil], target: (6.45, 2.17)),
    (pos: (11.65, 4.80), anchor: "west", body: [thruster \ exhaust], target: none),
  )

  for l in labels {
    if l.target != none {
      lead(l.pos, l.target)
    }
    content(l.pos, text(size: 8pt, l.body), anchor: l.anchor)
  }
})
