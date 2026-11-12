#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：固态电池与液态锂电结构对比。左图 Lithium-ion battery：蓝灰色敞口电池槽内浅蓝液态电解液（细纹理），
// 左右蓝色 Anode/Cathode 极板，中央灰色粗虚线 Separator，红色锂离子散布；顶部橙色灯泡经黑线接两极。
// 右图 Solid-state battery：浅绿电芯，两端深绿 Cathode/Anode，中间 Solid electrolyte，红色锂离子，
// Lithium ion 引线指向其中一颗。两图各标 Charging 右向橙箭头与 Discharging 左向橙箭头。逐字保留标签。
// 来源：Batteries 2025, 11, 90, Figure 3 "SSB vs. LIB: structural comparison" DOI 10.3390/batteries11030090

#canvas({
  import draw: *
  let ink = black
  let blue = rgb("#2b6fbf")
  let navy = rgb("#123c6b")
  let liq = rgb("#d8eefa")
  let speck = rgb("#b4d8ec")
  let green = rgb("#3f9a3f")
  let dgreen = rgb("#2f7a2f")
  let sfill = rgb("#d8efcb")
  let orange = rgb("#f0932b")
  let red = rgb("#e21818")
  let gray = rgb("#808080")
  let bulb = (cx, cy) => {
    circle((cx, cy), radius: 0.40, stroke: 2pt + orange, fill: white)
    line((cx - 0.22, cy - 0.05), (cx - 0.11, cy + 0.12), (cx, cy - 0.08),
      (cx + 0.11, cy + 0.12), (cx + 0.22, cy - 0.05), stroke: 1.4pt + orange)
    line((cx - 0.15, cy - 0.38), (cx + 0.15, cy - 0.38), stroke: 2pt + orange)
    line((cx - 0.13, cy - 0.46), (cx + 0.13, cy - 0.46), stroke: 2pt + orange)
  }
  let ion = (p) => circle(p, radius: 0.10, fill: red, stroke: none)
  let charg = (x, y) => {
    line((x, y), (x + 0.85, y), stroke: 2.2pt + orange,
      mark: (end: "stealth", scale: 0.6, fill: orange))
  }
  let disch = (x, y) => {
    line((x, y), (x - 0.85, y), stroke: 2.2pt + orange,
      mark: (end: "stealth", scale: 0.6, fill: orange))
  }

  // 左图：液态锂电电池槽、电解液纹理与两极板
  rect((1.0, 1.0), (8.2, 6.6), fill: liq, stroke: 3pt + rgb("#4a6b7a"))
  for i in range(16) {
    for j in range(11) {
      let x = 1.25 + i * 0.44
      let y = 1.25 + j * 0.5
      line((x, y), (x + 0.18, y), stroke: 0.8pt + speck)
    }
  }
  rect((2.0, 2.0), (3.0, 6.35), fill: blue, stroke: 1pt + rgb("#1d4f8c"))
  rect((6.2, 2.0), (7.2, 6.35), fill: blue, stroke: 1pt + rgb("#1d4f8c"))
  content((2.5, 4.2), text(size: 9pt, fill: white, [Anode]), angle: 90deg, frame: none)
  content((6.7, 4.2), text(size: 9pt, fill: white, [Cathode]), angle: 90deg, frame: none)
  // 隔膜：粗虚线
  line((4.6, 1.55), (4.6, 6.45), stroke: (paint: gray, thickness: 3.2pt, dash: "dashed"))
  // 锂离子与充放电方向
  for p in ((1.7, 4.7), (2.3, 3.9), (3.5, 3.1), (4.0, 2.2), (5.15, 4.35), (6.0, 5.7), (5.9, 3.3), (6.0, 2.4)) {
    ion(p)
  }
  charg(4.9, 5.15)
  content((5.35, 5.48), text(size: 8pt, [Charging]))
  disch(4.3, 2.95)
  content((3.95, 3.28), text(size: 8pt, [Discharging]))
  content((4.6, 6.88), text(size: 9.5pt, [Separator]))
  // 灯泡回路
  line((2.5, 6.35), (2.5, 7.7), (4.7, 7.7), stroke: 2pt + ink)
  line((5.5, 7.7), (7.0, 7.7), (7.0, 6.35), stroke: 2pt + ink)
  bulb(5.1, 8.1)
  // 左标题
  rect((2.1, 9.35), (7.1, 9.95), fill: navy, stroke: none)
  content((4.6, 9.65), text(size: 10.5pt, fill: white, [Lithium-ion battery]))

  // 右图：固态电芯、两端极板与固体电解质
  rect((10.0, 1.0), (17.2, 6.6), fill: sfill, stroke: 1.2pt + dgreen)
  rect((10.0, 1.0), (10.9, 6.6), fill: green, stroke: none)
  rect((16.3, 1.0), (17.2, 6.6), fill: green, stroke: none)
  content((10.45, 3.8), text(size: 9pt, fill: white, [Cathode]), angle: 90deg, frame: none)
  content((16.75, 3.8), text(size: 9pt, fill: white, [Anode]), angle: 90deg, frame: none)
  content((13.6, 1.45), text(size: 9.5pt, fill: dgreen, [*Solid electrolyte*]))
  for p in ((11.6, 5.9), (12.2, 5.2), (12.9, 3.9), (13.5, 4.6), (15.0, 5.4), (15.0, 3.3), (15.6, 4.0), (14.0, 6.1)) {
    ion(p)
  }
  line((13.95, 6.88), (14.0, 6.25), stroke: 1pt + ink)
  content((13.85, 7.12), text(size: 9.5pt, [Lithium ion]))
  charg(13.35, 5.15)
  content((13.8, 5.48), text(size: 8pt, [Charging]))
  disch(12.85, 2.95)
  content((12.5, 3.28), text(size: 8pt, [Discharging]))
  // 灯泡回路
  line((10.45, 6.6), (10.45, 7.7), (13.2, 7.7), stroke: 2pt + ink)
  line((14.0, 7.7), (16.75, 7.7), (16.75, 6.6), stroke: 2pt + ink)
  bulb(13.6, 8.1)
  // 右标题
  rect((10.6, 9.35), (16.6, 9.95), fill: rgb("#1f5b1f"), stroke: none)
  content((13.6, 9.65), text(size: 10.5pt, fill: white, [Solid-state battery]))
})
