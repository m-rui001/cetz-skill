#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：超级电容三种储能机理并列剖面图。(a) EDLC：深色集流体夹青色隔膜，左侧蓝色正离子、右侧黄色负离子
// 形成双电层，底部标 Electrical Double Layer；(b) Pseudocapacitor：集流体间散布 SO4^2- 与 Na+，电极界面
// 画钩形电子转移箭头，底部标 Capacitive Faradaic；(c) Hybrid：左半法拉第反应（K+、OH- 与钩形箭头），
// 右半双电层，底部标 Non- Capacitive Faradaic / EDLC。顶部统一电池符号与 +/−。标签逐字保留。
// 来源：Batteries 2025, 11, 232, Figure 3 "Supercapacitors' charge storage mechanisms" DOI 10.3390/batteries11060232

#canvas({
  import draw: *
  let ink = black
  let dark = rgb("#1d1d3f")
  let purple = rgb("#6a3fa0")
  let green = rgb("#8a7a1f")
  let red = rgb("#a03030")
  let teal = rgb("#8fd6cf")
  let pink = rgb("#e8a0a0")
  let blue = rgb("#3d7fc4")
  let yellow = rgb("#e8c23c")
  // 集流体：深色板＋内侧彩色薄条＋竖排标签
  let collector(x, edge, label) = {
    rect((x, 1.45), (x + 0.45, 5.20), fill: dark, stroke: 0.8pt + ink)
    rect((x + 0.33, 1.45), (x + 0.45, 5.20), fill: edge, stroke: none)
    content((x + 0.17, 3.3), text(size: 6.6pt, fill: rgb("#f0e68c"), label),
      angle: 90deg, frame: none)
  }
  // 圆形离子：带正负号
  let ion(p, c, s) = {
    circle(p, radius: 0.145, fill: c, stroke: 0.6pt + ink)
    content(p, text(size: 6pt, s), frame: none)
  }
  // 顶部电池符号与引线
  let circuit(xl, xr, cx) = {
    line((xl, 5.20), (xl, 5.95), (cx - 0.17, 5.95), stroke: 1.6pt + ink)
    line((cx + 0.22, 5.95), (xr, 5.95), (xr, 5.20), stroke: 1.6pt + ink)
    line((cx - 0.15, 5.72), (cx - 0.15, 6.18), stroke: 2pt + ink)
    line((cx + 0.20, 5.82), (cx + 0.20, 6.08), stroke: 2pt + ink)
    content((cx - 0.42, 6.28), text(size: 8pt, weight: "bold", [+]))
    content((cx + 0.46, 6.28), text(size: 8pt, weight: "bold", [−]))
  }
  let title(cx, s) = content((cx, 6.48), text(size: 9.5pt, weight: "bold", s))
  let tag(x, s) = content((x, 6.48), text(size: 9pt, weight: "bold", s))
  let notes(cx, y, s, size: 8.2pt) = content((cx, y), text(size: size, weight: "bold", s))

  // (a) EDLC：双电层
  tag(0.70, [(a)])
  title(3.00, [EDLC])
  circuit(1.12, 4.55, 2.95)
  collector(0.90, purple, [Current Collector])
  collector(4.30, purple, [Current Collector])
  rect((2.60, 1.90), (3.20, 5.00), fill: teal.transparentize(55%), stroke: 0.8pt + rgb("#3a8f85"))
  content((2.90, 3.35), text(size: 7.5pt, [Separator]), angle: 90deg, frame: none)
  for i in range(6) {
    let y = 4.85 - i * 0.55
    ion((1.62, y), blue, [+])
    ion((4.10, y), yellow, [−])
  }
  notes(2.95, 1.05, [Electrical Double Layer])

  // (b) Pseudocapacitor：表面法拉第反应
  tag(6.85, [(b)])
  title(9.30, [Pseudocapacitor])
  circuit(7.22, 11.63, 9.30)
  collector(7.00, green, [Current Collector])
  collector(11.40, green, [Current Collector])
  rect((9.05, 1.90), (9.75, 5.00), fill: rgb("#c8d8e8").transparentize(55%), stroke: 0.8pt + rgb("#5a7a9a"))
  content((9.40, 3.35), text(size: 7.5pt, [Separator]), angle: 90deg, frame: none)
  for p in ((8.05, 4.55), (8.15, 3.55), (8.55, 2.45), (10.55, 4.35), (10.55, 3.35), (10.55, 2.35)) {
    content(p, text(size: 7.5pt, [$"SO"_4^(2-)$]), frame: none)
  }
  for p in ((8.25, 4.10), (8.75, 3.05), (8.45, 2.05), (10.15, 3.95), (10.35, 2.85), (10.85, 2.00)) {
    content(p, text(size: 7.5pt, [$"Na"^+$]), frame: none)
  }
  line((7.85, 2.35), (7.70, 2.85), (7.85, 3.30), stroke: 1.6pt + blue,
    mark: (end: "stealth", scale: 0.5, fill: blue))
  line((11.22, 3.22), (11.35, 2.78), (11.22, 2.35), stroke: 1.6pt + blue,
    mark: (end: "stealth", scale: 0.5, fill: blue))
  notes(9.35, 1.05, [Capacitive Faradaic])

  // (c) Hybrid：左法拉第、右双电层
  tag(13.10, [(c)])
  title(15.45, [Hybrid])
  circuit(13.42, 17.12, 15.40)
  collector(13.20, red, [Current Collector])
  collector(16.90, purple, [Current Collector])
  rect((14.85, 1.90), (15.55, 5.00), fill: pink.transparentize(50%), stroke: 0.8pt + rgb("#a06060"))
  content((15.20, 3.35), text(size: 7.5pt, [Separator]), angle: 90deg, frame: none)
  for p in ((13.90, 4.55), (14.20, 3.55), (14.35, 2.55), (15.95, 4.35), (16.30, 3.35), (16.00, 2.35)) {
    content(p, text(size: 7.5pt, [$"K"^+$]), frame: none)
  }
  for p in ((14.55, 4.35), (14.60, 3.10), (14.50, 2.20), (16.20, 4.85), (16.40, 2.60)) {
    content(p, text(size: 7.5pt, [$"OH"^-$]), frame: none)
  }
  line((13.80, 2.15), (13.70, 2.70), (13.80, 3.20), stroke: 1.6pt + rgb("#2f9e44"),
    mark: (end: "stealth", scale: 0.5, fill: rgb("#2f9e44")))
  line((16.55, 5.05), (16.65, 4.55), (16.55, 4.05), stroke: 1.6pt + rgb("#2f9e44"),
    mark: (end: "stealth", scale: 0.5, fill: rgb("#2f9e44")))
  notes(14.35, 1.10, [Non- Capacitive\ Faradaic], size: 7.8pt)
  notes(17.10, 1.15, [EDLC], size: 8.2pt)
})
