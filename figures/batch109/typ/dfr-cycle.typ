#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// ── 图：面向回收设计的电池生命周期环 ──
// 编译后画面：中央为蓝色线稿电池（顶部端子排、+/− 标记、圆角框内闪电），
// 其下为绿色粗体标题 "Design for recycling"。五个阶段环绕：
// 1 原料（黄色矿车，顶部）、2 活性材料（瓶罐，左上）、3 电池制造（厂房，左下）、
// 4 寿命终止（粉色回收箱，带回收标志与 BATTERY 字样，底部）、
// 5 回收（黄色循环箭头环内含小电池，右侧）；各配淡绿大数字与黑色粗体标签。
// 小黑箭头 1→2→3→4，大黑弯箭头 4→5 与 5→1 闭环；电池与 2、3、5 间为青色双向箭头。
// 来源：Batteries 2024, 10, 38 (MDPI), Figure 8. DOI 10.3390/batteries10010038.
#let ink = rgb("#1a1a1a")
#let pale = rgb("#dce8d4")
#let teal-c = rgb("#12c4b0")
#let green = rgb("#4e8f3a")
#let yellow = rgb("#f6e465")
#let pink = rgb("#f3c3e9")
#let blue = rgb("#6f9fd2")
#let brown = rgb("#a06a3c")
#let tan = rgb("#c9b29b")
#let brick = rgb("#b4653f")
#let purple = rgb("#c9a2e0")
#let olive = rgb("#8a7a1e")
#let os = (paint: ink, thickness: 1.5pt)

// 通用助手：平移定位、多行标签、淡绿数字、黑色单箭头、青色双箭头
#let at(p, f) = draw.group({ draw.translate(p); f() })
#let lab(p,
  s) = draw.content(p, align(center, stack(dir: ttb, spacing: 2pt, ..s.split("\n").map(t => text(size: 9pt, weight: "bold", t)))))
#let num(p, n) = draw.content(p, text(size: 26pt, weight: "bold", fill: pale, str(n)))
#let arr(a, b) = draw.line(a, b, stroke: (paint: ink, thickness: 2.5pt), mark: (end: ">"))
#let dbl(a, b) = draw.line(a, b, stroke: (paint: teal-c, thickness: 2.5pt), mark: (start: "<", end: ">"))

// 阶段1图标：黄色矿车，满载黄/橄榄色矿石
#let cart = () => {
  draw.line((-1.1, 0.75), (-0.7, 1.15), (-0.25, 0.9), (0.15, 1.3),
    (0.65, 0.95), (1.1, 0.75), close: true, fill: olive, stroke: os)
  draw.line((-0.55, 0.95), (-0.3, 1.2), (-0.05, 0.95), (-0.3, 0.75), close: true, fill: yellow, stroke: os)
  draw.line((0.2, 0.9), (0.45, 1.15), (0.7, 0.9), (0.45, 0.72), close: true, fill: yellow, stroke: os)
  draw.rect((-1.3, 0.5), (1.3, 0.78), fill: yellow, stroke: os)
  draw.line((-1.2, 0.5), (1.2, 0.5), (0.95, -0.55), (-0.95, -0.55), close: true, fill: yellow, stroke: os)
  for x in (-0.65, 0.65) {
    draw.circle((x, -0.8), radius: 0.28, fill: yellow, stroke: os)
    draw.circle((x, -0.8), radius: 0.07, fill: ink)
  }
}
// 阶段2图标：滴瓶、量筒、粉瓶与紫色圆底烧瓶
#let flasks = () => {
  draw.rect((-1.0, -0.3), (-0.55, 0.55), fill: brown, stroke: os)
  draw.rect((-0.9, 0.55), (-0.65, 0.85), fill: ink)
  draw.rect((-0.4, -0.3), (-0.1, 0.9), fill: white, stroke: os)
  draw.rect((-0.4, -0.3), (-0.1, 0.2), fill: yellow)
  draw.rect((0.1, -0.3), (0.7, 0.45), fill: pink, stroke: os)
  draw.rect((0.2, -0.15), (0.6, 0.25), fill: white)
  draw.rect((0.25, 0.45), (0.55, 0.7), fill: white, stroke: os)
  draw.rect((-0.25, -0.3), (-0.05, 0.3), fill: purple, stroke: os)
  draw.circle((-0.15, -0.55), radius: 0.35, fill: purple, stroke: os)
}
// 阶段3图标：烟囱、冷却塔与锯齿厂房
#let factory = () => {
  draw.rect((-1.15, -0.2), (-0.9, 1.1), fill: brown)
  draw.line((-0.7, -0.2), (-0.6, 0.7), (-0.3, 0.7), (-0.2, -0.2), close: true, fill: tan)
  draw.line((-0.15, -0.2), (-0.05, 0.7), (0.25, 0.7), (0.35, -0.2), close: true, fill: tan)
  draw.rect((-1.2, -0.85), (0.5, -0.2), fill: brick)
  draw.line((0.0, -0.2), (0.25, 0.1), (0.25, -0.2), (0.5, 0.1), (0.5, -0.2), close: true, fill: brick)
  draw.rect((0.5, -0.85), (1.15, 0.3), fill: tan)
  for i in range(6) { draw.rect((-1.05 + i * 0.25, -0.65), (-0.95 + i * 0.25, -0.45), fill: rgb("#5a4a42")) }
  for i in range(3) { draw.rect((0.8, 0.05 - i * 0.2), (1.0, 0.15 - i * 0.2), fill: rgb("#5a4a42")) }
  draw.line((-1.3, -0.85), (1.25, -0.85), stroke: os)
}
// 阶段4图标：粉色回收箱，箱口露出废电池，箱身回收标志与 BATTERY 字样
#let bin = () => {
  draw.rect((-0.55, 0.6), (-0.05, 1.0), fill: rgb("#cfe8f7"), stroke: os)
  draw.line((-0.4, 0.8), (-0.2, 0.8), stroke: os)
  draw.line((-0.3, 0.7), (-0.3, 0.9), stroke: os)
  draw.rect((0.05, 0.6), (0.5, 0.95), fill: white, stroke: os)
  draw.rect((-0.45, 1.0), (-0.3, 1.1), fill: white, stroke: os)
  draw.rect((0.15, 0.95), (0.3, 1.05), fill: white, stroke: os)
  draw.line((-0.8, 0.6), (0.8, 0.6), (0.65, -0.85), (-0.65, -0.85), close: true, fill: pink, stroke: os)
  for x in (-0.5, 0.35) { draw.rect((x, -1.0), (x + 0.2, -0.85), fill: pink, stroke: os) }
  for a in (90, 210, 330) {
    draw.arc((0, 0.05), radius: 0.28, start: a * 1deg, stop: (a + 100) * 1deg, stroke: (paint: ink, thickness: 2.5pt))
    draw.arc((0, 0.05), radius: 0.28, start: a * 1deg, stop: (a + 100) * 1deg, stroke: (paint: white, thickness: 1.2pt),
      mark: (end: ">", fill: white, stroke: (paint: ink, thickness: 0.6pt), length: 0.16cm, width: 0.13cm))
  }
  draw.content((0, -0.55), text(size: 8pt, weight: "bold", "BATTERY"))
}
// 阶段5图标：黄色双弧循环箭头环，环心小电池
#let ring = () => {
  for (a, b) in ((170, 40), (350, 220)) {
    draw.arc((0, 0), radius: 1.0, start: a * 1deg, stop: b * 1deg, stroke: (paint: ink, thickness: 5.5pt))
    draw.arc((0, 0), radius: 1.0, start: a * 1deg, stop: b * 1deg, stroke: (paint: yellow, thickness: 3.5pt),
      mark: (end: ">", fill: yellow, stroke: (paint: ink, thickness: 1pt), length: 0.4cm, width: 0.35cm))
  }
  draw.rect((-0.55, -0.3), (0.45, 0.3), fill: white, stroke: os)
  draw.rect((0.45, -0.12), (0.62, 0.12), fill: white, stroke: os)
  for i in range(3) { draw.rect((-0.42 + i * 0.28, -0.15), (-0.22 + i * 0.28, 0.15), fill: yellow) }
}
// 中央图标：蓝色线稿电池，端子、极性、闪电与底座
#let battery = () => {
  let b = (paint: blue, thickness: 2pt)
  draw.rect((-1.6, -1.5), (1.6, 1.3), radius: 0.12, stroke: b)
  draw.rect((-1.8, 1.3), (1.8, 1.7), stroke: b)
  draw.rect((-1.5, 1.7), (1.5, 1.95), stroke: b)
  for x in (-1.25, -0.55, 0.35, 1.0) { draw.rect((x, 1.95), (x + 0.35, 2.25), stroke: b) }
  draw.rect((-1.7, -1.85), (1.7, -1.5), stroke: b)
  for i in range(9) { draw.line((-1.5 + i * 0.375, -1.85), (-1.5 + i * 0.375, -1.65), stroke: b) }
  draw.line((-1.25, 0.95), (-0.85, 0.95), stroke: b)
  draw.line((0.95, 0.95), (1.35, 0.95), stroke: b)
  draw.line((1.15, 0.75), (1.15, 1.15), stroke: b)
  draw.rect((-0.6, -0.75), (0.6, 0.45), radius: 0.15, stroke: b)
  draw.line((0.15, 0.25), (-0.15, -0.1), (0.1, -0.1), (-0.15, -0.55), stroke: b)
}

// 命名地标：五阶段图标中心与中央电池中心
#let p1 = (5.3, 8.8)
#let p2 = (2.1, 6.8)
#let p3 = (2.2, 2.8)
#let p4 = (5.3, 1.2)
#let p5 = (11.7, 6.1)
#let bc = (7.8, 5.9)
// 阶段表：编号/中心/标签/图标/标签纵向偏移（1-4 在图标上方，5 在下方）
#let stages = (
  (n: 1, p: p1, t: "RAW\nMATERIALS", ic: cart, dy: 1.8),
  (n: 2, p: p2, t: "ACTIVE\nMATERIALS", ic: flasks, dy: 1.8),
  (n: 3, p: p3, t: "BATTERY\nMANUFACTURING", ic: factory, dy: 1.8),
  (n: 4, p: p4, t: "END\nOF LIFE", ic: bin, dy: 1.8),
  (n: 5, p: p5, t: "RECYCLING", ic: ring, dy: -1.7),
)

#canvas(length: 1cm, {
  import draw: *
  // 中央电池与绿色标题
  at(bc, battery)
  content((8.7, 3.3), text(size: 14pt, weight: "bold", fill: green, "Design for recycling"))
  // 循环绘制五阶段：图标 + 淡绿数字 + 黑色标签
  for s in stages {
    let (x, y) = s.p
    at(s.p, s.ic)
    lab((x + 0.3, y + s.dy), s.t)
    num((x - 1.45, y + s.dy), s.n)
  }
  // 小黑箭头：1→2、2→3、3→4
  arr((4.0, 8.5), (3.55, 8.3))
  arr((2.1, 5.7), (2.1, 5.0))
  arr((3.5, 1.9), (4.3, 1.5))
  // 大黑弯箭头：4→5 与 5→1，闭合生命周期环
  draw.bezier((6.4, 1.1), (11.7, 3.9), (8.4, 0.7), (10.6, 2.2),
    stroke: (paint: ink, thickness: 3.5pt), mark: (end: ">", fill: ink, length: 0.5cm, width: 0.45cm))
  draw.bezier((11.6, 7.4), (6.8, 9.5), (10.9, 9.0), (8.9, 9.9),
    stroke: (paint: ink, thickness: 3.5pt), mark: (end: ">", fill: ink, length: 0.5cm, width: 0.45cm))
  // 青色双向箭头：中央电池 ↔ 阶段 2、3、5
  dbl((4.0, 6.6), (5.6, 6.9))
  dbl((4.0, 4.2), (5.6, 4.6))
  dbl((9.7, 6.0), (10.5, 6.0))
})
