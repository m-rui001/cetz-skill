#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 编译图为紧凑空间光学相机调焦机构的左侧结构线稿与右侧传动链示意图；来源：Aerospace 2026, 13, 624, Figure 1. DOI 10.3390/aerospace13070624
#canvas({
  import draw: *

  let ink = rgb("#30343b")
  let blue = rgb("#3e8bbf")
  let pale = rgb("#dcecf5")
  let metal = rgb("#c8cdd1")
  let dark = rgb("#68727a")
  let yellow = rgb("#f4e34b")
  let orange = rgb("#c97832")
  let white = rgb("#ffffff")
  let dash = (paint: blue, thickness: 0.8pt, dash: "dashed")
  let edge = (paint: ink, thickness: 0.8pt)

  let lab = (p, s, sz: 7pt) => {
    content(p, text(size: sz, [#s]), anchor: "center", frame: none)
  }
  let arrow = (a, b, c: ink) => {
    line(a, b, stroke: (paint: c, thickness: 0.8pt),
      mark: (end: "stealth", scale: 0.5, fill: c))
  }

  // 左侧标题与底部基座
  lab((7.2, 15.4), "Compact focusing mechanism", sz: 8pt)
  rect((1.0, 2.2), (6.0, 8.1), fill: metal, stroke: edge)
  for y in (2.7, 3.1, 3.5, 3.9, 4.3, 4.7, 5.1, 5.5, 5.9, 6.3, 6.7, 7.1, 7.5) {
    line((1.15, y), (1.65, y), stroke: (paint: dark, thickness: 0.5pt))
  }
  rect((1.8, 3.0), (5.3, 7.2), fill: rgb("#aeb5ba"), stroke: edge)
  rect((2.35, 4.8), (4.75, 5.55), fill: rgb("#8e989e"), stroke: edge)
  circle((5.1, 5.0), radius: 0.18, fill: dark, stroke: none)

  // 左侧编码器与齿轮组
  circle((4.0, 8.4), radius: (1.05, 0.72), fill: rgb("#a99be2"), stroke: edge)
  circle((5.0, 7.55), radius: 0.76, fill: orange, stroke: edge)
  circle((5.0, 7.55), radius: 0.22, fill: white, stroke: edge)
  for p in ((4.55, 7.55), (5.45, 7.55), (5.0, 7.1), (5.0, 8.0)) {
    circle(p, radius: 0.08, fill: white, stroke: edge)
  }
  rect((5.35, 8.2), (7.2, 9.0), fill: rgb("#9ba4aa"), stroke: edge)
  circle((7.35, 8.6), radius: 0.58, fill: rgb("#82928a"), stroke: edge)
  circle((7.35, 8.6), radius: 0.16, fill: white, stroke: edge)
  line((5.6, 8.6), (8.3, 8.6), stroke: edge)

  // 左侧蜗杆和步进电机
  line((7.2, 10.3), (10.4, 10.3), stroke: (paint: ink, thickness: 1.8pt))
  for x in (7.4, 7.85, 8.3, 8.75, 9.2, 9.65, 10.1) {
    line((x, 9.95), (x + 0.35, 10.65), stroke: edge)
  }
  circle((8.55, 10.3), radius: 0.55, fill: yellow, stroke: edge)
  rect((10.5, 9.35), (12.2, 11.25), fill: rgb("#b99575"), stroke: edge)
  rect((10.5, 9.75), (11.0, 10.85), fill: rgb("#e6d5bd"), stroke: edge)
  line((10.0, 10.3), (10.5, 10.3), stroke: edge)

  // 左侧聚焦基座、圆柱凸轮与镜筒
  circle((8.0, 5.35), radius: (2.75, 2.25), fill: pale, stroke: (paint: blue, thickness: 1.2pt))
  circle((8.0, 5.35), radius: (2.15, 1.75), fill: white, stroke: (paint: blue, thickness: 1pt))
  rect((6.2, 3.35), (9.05, 7.35), fill: yellow, stroke: edge)
  circle((9.1, 5.35), radius: (2.0, 1.7), fill: rgb("#d7d9d8"), stroke: edge)
  circle((9.1, 5.35), radius: (1.5, 1.25), fill: white, stroke: edge)
  circle((9.1, 5.35), radius: (0.8, 0.68), fill: rgb("#e9eef0"), stroke: edge)
  circle((9.1, 5.35), radius: 0.18, fill: dark, stroke: none)
  line((6.45, 3.55), (6.45, 7.15), stroke: (paint: orange, thickness: 1.2pt))

  // 左侧标签
  line((3.55, 8.8), (2.3, 10.3), stroke: edge)
  lab((1.7, 10.55), "Encoder")
  line((7.9, 10.75), (6.8, 12.1), stroke: edge)
  lab((6.2, 12.35), "Worm gear pair")
  line((11.3, 10.1), (12.9, 11.2), stroke: edge)
  lab((13.35, 11.45), "Stepper motor")
  line((7.4, 8.15), (9.3, 9.0), stroke: edge)
  lab((10.0, 9.15), "Gear pair")
  line((8.0, 7.6), (10.3, 8.0), stroke: edge)
  lab((11.3, 8.2), "Focusing base")
  line((4.0, 3.0), (2.5, 1.7), stroke: edge)
  lab((1.65, 1.35), "CCD focal plane assembly")
  line((6.35, 3.8), (5.2, 2.1), stroke: edge)
  lab((4.8, 1.75), "Cylindrical cam")

  // 右侧控制器与控制信号
  rect((16.2, 12.6), (18.4, 13.7), fill: white, stroke: edge)
  lab((17.3, 13.15), "Controller", sz: 7pt)
  line((18.4, 13.15), (23.2, 13.15), stroke: dash,
    mark: (end: "stealth", scale: 0.45, fill: blue))
  lab((20.65, 13.55), "Control signal", sz: 7pt)

  // 右侧步进电机与蜗杆
  rect((27.0, 11.7), (29.0, 13.2), fill: rgb("#e5e7e8"), stroke: edge)
  lab((28.0, 13.65), "Stepper motor", sz: 7pt)
  line((24.0, 12.45), (27.0, 12.45), stroke: edge)
  for x in (24.1, 24.45, 24.8, 25.15, 25.5, 25.85) {
    line((x, 12.15), (x + 0.28, 12.75), stroke: edge)
  }
  lab((25.1, 13.55), "Worm", sz: 7pt)

  // 右侧蜗轮与凸轮齿轮
  circle((25.2, 10.25), radius: 1.15, fill: white, stroke: edge)
  circle((25.2, 10.25), radius: 0.82, fill: rgb("#f2f2f0"), stroke: edge)
  circle((25.2, 10.25), radius: 0.12, fill: dark, stroke: none)
  for p in ((24.2, 10.25), (26.2, 10.25), (25.2, 9.25), (25.2, 11.25)) {
    line((25.2, 10.25), p, stroke: (paint: dark, thickness: 0.6pt))
  }
  lab((23.0, 10.95), "Worm wheel", sz: 7pt)
  circle((25.2, 7.55), radius: 1.25, fill: white, stroke: edge)
  circle((25.2, 7.55), radius: 0.9, fill: rgb("#f2f2f0"), stroke: edge)
  line((25.2, 8.8), (25.2, 6.3), stroke: edge)
  lab((23.2, 8.65), "Cam gear", sz: 7pt)

  // 右侧编码器与传动齿轮
  rect((20.2, 6.9), (21.1, 7.6), fill: white, stroke: edge)
  lab((20.65, 8.2), "Encoder", sz: 7pt)
  line((21.1, 7.25), (22.3, 7.25), stroke: edge)
  rect((22.3, 6.6), (23.45, 7.9), fill: white, stroke: edge)
  lab((22.9, 8.35), "Transmission gear", sz: 7pt)
  line((23.45, 7.25), (24.0, 7.25), stroke: edge)

  // 右侧圆柱凸轮与从动件
  circle((25.2, 7.55), radius: 0.48, fill: rgb("#d5d8d8"), stroke: edge)
  rect((24.75, 7.25), (25.65, 7.85), fill: rgb("#e8eaea"), stroke: edge)
  lab((27.8, 7.35), "Cylindrical cam", sz: 7pt)
  line((25.65, 7.55), (27.0, 7.55), stroke: edge)
  line((25.2, 6.3), (25.2, 5.25), stroke: edge)
  circle((25.2, 5.12), radius: 0.16, fill: dark, stroke: none)
  lab((27.1, 5.45), "Cam follower", sz: 7pt)

  // 右侧焦平面组件与轴向位移
  rect((24.35, 4.25), (26.05, 4.85), fill: white, stroke: edge)
  rect((24.35, 4.85), (26.05, 5.05), fill: rgb("#c8ced0"), stroke: edge)
  lab((27.2, 4.55), "CCD focal plane", sz: 7pt)
  lab((27.2, 4.05), "assembly", sz: 7pt)
  line((25.2, 4.25), (25.2, 3.2), stroke: edge)
  line((24.55, 3.2), (25.85, 3.2), stroke: edge)
  line((24.7, 3.2), (24.85, 2.8), stroke: edge)
  line((24.85, 2.8), (25.05, 3.2), stroke: edge)
  line((25.35, 3.2), (25.55, 2.8), stroke: edge)
  line((25.55, 2.8), (25.75, 3.2), stroke: edge)
  arrow((26.55, 5.0), (26.55, 2.75), c: blue)
  lab((28.0, 3.55), "Axial displacement", sz: 7pt)
  lab((28.0, 3.05), "(along optical axis)", sz: 7pt)

  // 右侧位置反馈虚线链
  line((20.2, 7.25), (18.0, 7.25), stroke: dash)
  line((18.0, 7.25), (18.0, 12.6), stroke: dash,
    mark: (end: "stealth", scale: 0.45, fill: blue))
  lab((16.9, 8.35), "Position", sz: 7pt)
  lab((16.9, 7.85), "feedback", sz: 7pt)
})
