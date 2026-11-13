#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 干净线稿平涂重绘：上部为电动绳系 EDT 系统，下部为碎片清除系统示意，来源 Aerospace 2025, 12, 277 (debris) Figure 19 参考图。
#canvas({
  import draw: *;

  // 配色与共享助手
  let sky = rgb("#eef9fe")
  let grey = rgb("#d9d9d9")
  let orange = rgb("#f28c00")
  let red = rgb("#e82020")
  let green = rgb("#1a8f4c")
  let yellow = rgb("#fff2a8")
  let tetherx(y) = 5.8 + (16.8 - y) * 0.047
  let electron(p) = {
    circle(p, radius: 0.13, fill: yellow, stroke: (paint: rgb("#e0a000"), thickness: 0.4pt))
    content(p, text(size: 6.2pt)[e−])
  }
  // 两行标签助手（逐行独立绘制，避免 linebreak 参数误用）
  let label2(x, y, l1, l2, ..args) = {
    content((x, y + 0.2), l1, ..args)
    content((x, y - 0.2), l2, ..args)
  }

  // 上部 EDT 系统背景与地球弧线
  rect((0, 6.6), (11, 20.5), fill: sky, stroke: none)
  bezier((0, 6.7), (3.5, 7.1), (7.5, 7.1), (11, 6.7),
    stroke: (paint: rgb("#9cc9dd"), thickness: 1pt))

  // geomagnetic field 三条绿色虚线箭头
  for (a, b) in (
    ((10.2, 13.4), (1.6, 10.2)),
    ((10.3, 12.0), (1.9, 9.0)),
    ((10.4, 10.6), (2.2, 7.8)),
  ) {
    line(a, b, stroke: (paint: green, thickness: 1pt, dash: "dashed"),
      mark: (end: "stealth", fill: green))
  }
  label2(0.3, 8.4, text(fill: green)[geo-magnetic], text(fill: green)[field],
    anchor: "west")

  // flight direction 点线箭头
  line((9.5, 14.1), (1.0, 12.4),
    stroke: (paint: black, thickness: 0.9pt, dash: "dotted"),
    mark: (end: "stealth", fill: black))
  label2(0.5, 14.2, [flight], [direction], anchor: "west")

  // 裸绳系与端质量
  bezier((5.8, 16.8), (5.85, 14), (6.15, 10), (6.2, 8.2),
    stroke: (paint: black, thickness: 1.2pt))
  rect((6.0, 7.9), (6.42, 8.22), fill: grey, stroke: black)

  // 电流沿绳系向上
  line((6.10, 8.8), (5.86, 15.7),
    stroke: (paint: orange, thickness: 1.6pt), mark: (end: "stealth"))
  content((4.4, 10.7), text(fill: orange)[current], anchor: "east")

  // Lorentz force 红色水平箭头
  for (y, l) in (
    (14.2, 0.9), (12.8, 1.0), (11.4, 1.0), (10.0, 1.0), (8.6, 1.0),
  ) {
    line((tetherx(y) - 0.05, y), (tetherx(y) + l, y),
      stroke: (paint: red, thickness: 1.1pt), mark: (end: "stealth"))
  }
  content((7.45, 9.65), text(fill: red)[Lorentz force], anchor: "west")

  // 火箭上面级
  line((5.72, 18.7), (5.9, 18.9), (6.08, 18.7), (6.1, 18.2), (6.1, 17.25),
    (5.55, 17.25), (5.55, 18.2), close: true,
    fill: rgb("#e6e6e6"), stroke: black)
  rect((5.55, 17.3), (6.1, 17.55), fill: orange, stroke: none)
  line((5.55, 17.25), (6.1, 17.25), (6.28, 16.75), (5.37, 16.75), close: true,
    fill: rgb("#c9c9c9"), stroke: black)
  label2(6.45, 18.0, [rocket], [upper stage], anchor: "west")

  // 绳系与发射器标注
  line((4.9, 16.2), (5.8, 15.7), stroke: (paint: black, thickness: 0.6pt))
  content((4.85, 16.25), [bare tether], anchor: "east")
  rect((6.22, 7.72), (6.64, 7.98), fill: orange, stroke: black)
  line((6.64, 7.85), (7.35, 7.85),
    stroke: (paint: orange, thickness: 1.2pt), mark: (end: "stealth"))
  content((6.55, 7.3), text(fill: orange)[emitter])
  line((4.8, 7.05), (5.2, 7.2), (4.9, 7.35), (6.0, 7.85),
    stroke: (paint: black, thickness: 0.6pt))
  content((4.78, 7.05), [end-mass], anchor: "east")

  // 电子 e− 散布
  for p in ((6.9, 15.8), (5.5, 15.2), (7.2, 14.8),
            (7.8, 8.5), (8.2, 8.0), (7.6, 7.5)) {
    electron(p)
  }

  // 下部：Debris removal system 标题与黄色服务箱
  content((3.1, 5.75), text(weight: "bold", size: 11pt)[Debris removal system])
  line((0.9, 3.1), (0.9, 4.3), (2.4, 4.3), (2.4, 3.1), close: true,
    fill: rgb("#fff21a"), stroke: black)
  line((0.9, 4.3), (1.3, 4.7), (2.8, 4.7), (2.4, 4.3), close: true,
    fill: rgb("#fff78a"), stroke: black)
  line((2.4, 3.1), (2.4, 4.3), (2.8, 4.7), (2.8, 3.5), close: true,
    fill: rgb("#f5d900"), stroke: black)
  for dy in (0.16, 0.38, 0.60) {
    rect((1.24, 3.14 + dy), (1.84, 3.32 + dy),
      fill: white, stroke: (paint: rgb("#14a5a0"), thickness: 0.8pt))
  }

  // 机械臂与蓝色模块
  line((0.9, 3.72), (0.55, 3.88), (0.28, 3.55), (0.08, 3.78),
    stroke: (paint: rgb("#777"), thickness: 2.2pt))
  line((0.9, 3.72), (0.55, 3.88), (0.28, 3.55), (0.08, 3.78),
    stroke: (paint: black, thickness: 0.7pt))
  line((0.08, 3.78), (0.0, 3.92), stroke: black)
  line((0.08, 3.78), (0.0, 3.64), stroke: black)
  rect((2.85, 3.28), (5.15, 4.18), fill: rgb("#16005e"), stroke: black)
  line((2.4, 3.75), (2.85, 3.75), stroke: (paint: rgb("#777"), thickness: 2pt))

  // 下部 Debris 卫星、太阳翼、红色方向箭头
  rect((1.3, 2.0), (1.8, 2.48), fill: grey, stroke: black)
  rect((0.55, 2.08), (1.3, 2.36), fill: rgb("#dce6f0"), stroke: black)
  rect((1.8, 2.08), (2.55, 2.36), fill: rgb("#dce6f0"), stroke: black)
  line((0.92, 2.08), (0.92, 2.36), stroke: (paint: rgb("#8aa0b5"), thickness: 0.5pt))
  line((2.18, 2.08), (2.18, 2.36), stroke: (paint: rgb("#8aa0b5"), thickness: 0.5pt))
  content((2.9, 2.02), text(weight: "bold")[Debris], anchor: "west")
  line((0.25, 3.1), (0.25, 0.7),
    stroke: (paint: red, thickness: 3pt), mark: (end: "stealth"))

  // Tether 与末端小方盒
  line((1.55, 2.0), (1.55, 0.62), stroke: (paint: rgb("#555"), thickness: 1pt))
  content((0.85, 1.3), [Tether], anchor: "west")
  rect((1.3, 0.22), (1.8, 0.62), fill: white, stroke: (paint: green, thickness: 1pt))
  line((1.38, 0.44), (1.55, 0.56), (1.72, 0.44),
    stroke: (paint: green, thickness: 0.8pt))
  rect((1.43, 0.28), (1.67, 0.44), fill: none, stroke: (paint: green, thickness: 0.8pt))
})
