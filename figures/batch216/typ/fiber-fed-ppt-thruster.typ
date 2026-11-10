#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 纤维供给式脉冲等离子体推力器（FPPT）剖面示意图，平涂线稿重绘
// 来源：Aerospace 2024, 11(7), 502, Figure 28；DOI 10.3390/aerospace11070502
#canvas({
  import draw: *

  // ---- 配色 ----
  let cBlue = rgb("#0093d0")
  let cBlack = rgb("#1c1c1c")
  let cRed = rgb("#dd2318")
  let cPurp = rgb("#7b3fa0")
  let cGreen = rgb("#2f9e44")
  let cGray = rgb("#93a1b0")
  let cHatch = rgb("#8a929c")

  // ---- 助手：矩形内 45° 影线填充 ----
  let hatch(x0, x1, y0, y1, step: 0.24) = {
    let h = y1 - y0
    let n = calc.ceil((x1 - x0 + h) / step)
    for i in range(n + 1) {
      let s = x0 - h + i * step
      let t0 = calc.max(0, x0 - s)
      let t1 = calc.min(h, x1 - s)
      if t1 > t0 + 0.01 {
        line((s + t0, y0 + t0), (s + t1, y0 + t1), stroke: 0.5pt + cHatch)
      }
    }
  }

  // ===== 左侧：纤维存储与步进驱动送料 =====
  content((2.1, 5.3), align(right)[Feed#linebreak()from#linebreak()Fiber#linebreak()Spool], anchor: "east")
  rect((2.45, 3.5), (4.85, 7.0), stroke: 1pt + cBlack)
  // 两只送料卷筒
  for cy in (6.0, 4.7) {
    circle((3.65, cy), radius: 0.42, stroke: 0.9pt + cBlack, fill: cGray)
    arc((3.65, cy), start: 110deg, stop: 250deg, radius: 0.2, stroke: 1.3pt + rgb("#2d6ba8"))
  }
  content((3.65, 3.3), align(center)[Stepper#linebreak()Driven Feed], anchor: "north")

  // ===== 蓝色 PTFE 纤维束与锥形尖端 =====
  rect((4.3, 4.85), (10.4, 5.45), fill: cBlue, stroke: none)
  content((6.9, 5.15), text(fill: white, weight: "bold")[PTFE Fiber])
  line((8.3, 5.15), (9.7, 5.15), stroke: 1.5pt + white, mark: (end: "stealth", fill: white))
  line((10.4, 5.45), (11.35, 5.15), (10.4, 4.85), close: true, fill: cBlue, stroke: none)

  // ===== 电磁铁与导引管 =====
  rect((7.45, 5.62), (8.25, 6.05), fill: cPurp, stroke: 0.7pt + cBlack)
  content((6.45, 7.15), [Electromagnet])
  line((7.05, 7.0), (7.72, 6.15), stroke: 0.8pt + cBlack, mark: (end: "stealth"))
  content((6.9, 4.5), [Guide Tube])

  // ===== 上阴极 =====
  rect((9.8, 7.15), (11.9, 7.6), fill: cBlack, stroke: none)
  content((10.85, 7.375), text(fill: white, weight: "bold", size: 9pt)[Cathode])

  // ===== 绝缘体（影线区） =====
  rect((10.0, 6.0), (11.2, 7.05), fill: rgb("#f2f2f2"), stroke: 0.7pt + cBlack)
  hatch(10.0, 11.2, 6.0, 7.05)
  content((8.45, 8.65), [Insulator])
  line((9.25, 8.5), (10.55, 7.12), stroke: 0.8pt + cBlack, mark: (end: "stealth"))

  // ===== 阳极（红条）与下阴极 =====
  rect((9.6, 5.55), (11.6, 5.9), fill: cRed, stroke: none)
  content((9.12, 5.72), text(weight: "bold", size: 9pt)[V+])
  rect((10.0, 4.45), (10.7, 4.78), fill: cPurp, stroke: 0.7pt + cBlack)
  rect((9.8, 3.9), (11.9, 4.35), fill: cBlack, stroke: none)
  content((10.85, 4.125), text(fill: white, weight: "bold", size: 9pt)[Cathode])

  // ===== 上下点火器 PPU =====
  rect((12.4, 7.9), (14.15, 8.55), stroke: 1.6pt + cGreen, fill: white)
  content((13.275, 8.225), text(weight: "bold", size: 9pt)[Igniter PPU])
  line((12.8, 7.9), (12.8, 7.4), (11.9, 7.4), stroke: 1pt + cBlack)

  rect((12.4, 2.95), (14.15, 3.6), stroke: 1.6pt + cGreen, fill: white)
  content((13.275, 3.275), text(weight: "bold", size: 9pt)[Igniter PPU])
  line((12.8, 3.6), (12.8, 4.1), (11.9, 4.1), stroke: 1pt + cBlack)

  // ===== PPU 与储能电容 =====
  rect((10.55, 1.75), (11.95, 3.25), stroke: 1pt + cBlack, fill: white)
  line((10.85, 2.9), (11.65, 2.9), stroke: 1.3pt + cBlack)
  line((10.85, 2.6), (11.65, 2.6), stroke: 1.3pt + cBlack)
  content((11.25, 2.08), text(weight: "bold", size: 9pt)[PPU])
  line((11.25, 3.25), (11.25, 3.9), stroke: 1pt + cBlack)
  content((9.5, 2.25), align(right)[Storage#linebreak()Capacitor], anchor: "east")
  line((9.85, 2.35), (10.5, 2.68), stroke: 0.8pt + cBlack, mark: (end: "stealth"))

  // ===== 右侧标注：推进剂锥尖 / 阳极 / 点火器 =====
  content((14.55, 6.3), [Propellant w/#linebreak()Conical Tip], anchor: "west")
  line((14.45, 6.15), (11.45, 5.22), stroke: 0.8pt + cBlack, mark: (end: "stealth"))

  content((14.55, 5.35), [Anode], anchor: "west")
  line((14.45, 5.42), (11.65, 5.62), stroke: 0.8pt + cBlack, mark: (end: "stealth"))

  content((14.55, 4.3), [Igniter], anchor: "west")
  line((14.45, 4.3), (10.75, 4.62), stroke: 0.8pt + cBlack, mark: (end: "stealth"))
})
