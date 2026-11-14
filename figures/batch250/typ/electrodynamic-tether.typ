#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 电动力绳系(EDT)原理图：竖直黄色导电带两端配重，左侧为轨道运动与感应电场，
// 右侧为电子/离子收集、JxB 洛伦兹力、等离子体波闭合回路。
// 来源：Aerospace 2024, 11(7), 502, Figure 32 — DOI 10.3390/aerospace11070502

#canvas({
  import draw: *

  // 统一配色
  let ink = rgb("#222222")
  let tape-c = rgb("#e8df6c")
  let mass-c = rgb("#b58a5c")
  let box-c = rgb("#c6c6c6")
  let box-d = rgb("#a6a6a6")
  let blue = rgb("#1f6fb2")
  let green = rgb("#2f8b3c")
  let purple = rgb("#7a3f9d")
  let pink = rgb("#d4576f")
  let red = rgb("#c0392b")
  let orange = rgb("#f2b877")
  let plasma = rgb("#93b7db")

  // 地标：导电带中线、宽度、上下端
  let tx = 5.45
  let tw = 0.62
  let yt = 10.85
  let yb = 3.10
  let xr = tx + tw / 2

  // 箭头助手：起点→终点，着色
  let arr(a, b, c, w: 1.5pt) = line(a, b, stroke: (paint: c, thickness: w), mark: (end: "stealth"))

  // 标签助手：定点放置，可指定锚点
  let lab(pos, body, c, a) = content(pos, text(fill: c, body), anchor: a, stroke: none, fill: none)

  // 电离层等离子体：右侧淡蓝云团（先画，作背景）
  let blob = range(0, 48).map(i => {
    let a = i / 48 * 2 * calc.pi
    let rx = 1.55 + 0.13 * calc.sin(3 * a + 0.7)
    let ry = 5.35 + 0.12 * calc.sin(2 * a + 1.2)
    (10.05 + rx * calc.cos(a), 7.35 + ry * calc.sin(a))
  })
  line(..blob, close: true, fill: plasma.transparentize(58%), stroke: none)

  // 等离子体波：四条红色波浪线（表驱动）
  let wave(x0, y0, y1, amp, ph) = line(
    ..range(0, 37).map(i => {
      let t = i / 36
      (x0 + amp * calc.sin(t * 3.2 * calc.pi + ph) + 0.5 * t, y0 + (y1 - y0) * t)
    }),
    stroke: (paint: red, thickness: 1pt),
  )
  for (i, ph) in (0, 1.1, 2.2, 3.3).enumerate() {
    wave(11.05 + i * 0.30, 10.2, 4.35, 0.16, ph)
  }

  // 地球磁场：粉色斜向箭头，先画，被块箭头遮挡
  for i in range(4) {
    arr((4.02, 5.75 - i * 0.28), (0.70 + i * 0.10, 3.85 - i * 0.30), pink, w: 1.2pt)
  }

  // 导电带本体：黄色长带 + 细横纹
  rect((tx - tw / 2, yb), (tx + tw / 2, yt), fill: tape-c, stroke: (paint: ink, thickness: 0.8pt))
  for i in range(1, 14) {
    let y = yb + i * (yt - yb) / 14
    line((tx - tw / 2 + 0.05, y), (tx + tw / 2 - 0.05, y), stroke: (paint: ink.transparentize(65%), thickness: 0.4pt))
  }

  // 下端配重箱：正面 / 顶面 / 侧面三块
  line((4.28, 2.90), (4.28, 1.95), (6.10, 1.95), (6.10, 2.90), close: true,
    fill: box-c, stroke: (paint: ink, thickness: 0.8pt))
  line((4.28, 2.90), (4.88, 3.30), (6.70, 3.30), (6.10, 2.90), close: true,
    fill: box-c.lighten(30%), stroke: (paint: ink, thickness: 0.8pt))
  line((6.10, 2.90), (6.70, 3.30), (6.70, 2.35), (6.10, 1.95), close: true,
    fill: box-d, stroke: (paint: ink, thickness: 0.8pt))

  // 上端配重块
  rect((tx - tw / 2 - 0.05, yt), (tx + tw / 2 + 0.05, yt + 0.90), fill: mass-c, stroke: (paint: ink, thickness: 0.8pt))

  // 重力梯度力：上下双向蓝箭头
  arr((tx, 11.85), (tx, 13.45), blue, w: 2pt)
  arr((tx, 1.90), (tx, 0.45), blue, w: 2pt)

  // 轨道运动：橙色左向块箭头
  line(
    (4.10, 6.98), (2.10, 6.98), (2.10, 7.36), (1.30, 6.50), (2.10, 5.64), (2.10, 6.02), (4.10, 6.02),
    close: true, fill: orange, stroke: (paint: ink, thickness: 0.8pt),
  )
  content((2.95, 6.50), [Orbital \ Motion], stroke: none, fill: none)

  // 电流方向：绿色上行箭头
  arr((4.85, 5.25), (4.85, 8.75), green, w: 1.8pt)

  // 运动感应电场：紫色上行箭头
  arr((4.32, 5.95), (4.32, 7.40), purple, w: 1.8pt)

  // 电子收集：左向虚线箭头
  for y in (10.62, 10.26, 9.90) {
    line((6.95, y), (xr + 0.03, y),
      stroke: (paint: ink, thickness: 0.9pt, dash: "dashed"), mark: (end: "stealth", fill: ink))
    content((6.72, y + 0.04), $e^(-)$, anchor: "south", stroke: none, fill: none)
  }

  // 离子收集：左向虚线箭头
  for y in (6.05, 5.60, 5.15) {
    line((6.95, y), (xr + 0.03, y),
      stroke: (paint: ink, thickness: 0.9pt, dash: "dashed"), mark: (end: "stealth", fill: ink))
    content((6.72, y + 0.04), $+$, anchor: "south", stroke: none, fill: none)
  }

  // JxB 洛伦兹力：右侧蓝色短箭头
  for y in (8.55, 8.10, 7.65, 7.20, 6.75) {
    arr((xr + 0.03, y), (6.55, y), blue, w: 1.4pt)
  }

  // 文字标注
  lab((4.92, 13.05), [Gravity Gradient \ Force], blue, "east")
  lab((5.70, 0.95), [Gravity Gradient \ Force], blue, "west")
  lab((4.55, 9.10), [Current \ Flow], green, "east")
  lab((4.05, 7.85), [Motion-Induced \ VxB Electric Field], purple, "east")
  lab((7.12, 10.26), [electrons \ collected], ink, "west")
  lab((6.00, 9.15), [JxB Forces \ on Tape], blue, "west")
  lab((7.12, 5.60), [ions \ collected], ink, "west")
  lab((8.45, 6.70), [Plasma Waves \ Close the \ Electrical Circuit], ink, "west")
  lab((7.95, 4.25), [Ionospheric \ Plasma], ink, "west")
  lab((0.30, 2.35), [Earth's \ Magnetic \ Field], red, "west")
})
