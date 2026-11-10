#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  // 激光点火固体微推力器剖面示意：左端药柱端面 + 主机体、激光照射器与火箭喷管
  // 来源：Aerospace 2024, 11(7), 502, Figure 14；DOI 10.3390/aerospace11070502

  // 统一配色
  let cOut = rgb(153, 153, 153)
  let cShell = rgb(222, 222, 222)
  let cBody = rgb(194, 194, 194)
  let cDark = rgb(51, 51, 51)
  let cNoz = rgb(245, 240, 222)
  let cBlue = rgb(38, 102, 204)
  let cYel = rgb(247, 209, 51)
  let cInk = rgb(26, 26, 26)
  let st = (paint: cOut, thickness: 0.8pt)
  let stL = (paint: cInk, thickness: 0.6pt)

  // 关键地标
  let yA = 4.0
  let xS = 5.6
  let xE = 14.8
  let yT = 5.2
  let yB = 2.8

  // ── 端面剖视：七根药柱六角排布 ──
  let cx = 2.4
  circle((cx, yA), radius: 1.15, fill: white, stroke: (paint: cOut, thickness: 1pt))
  circle((cx, yA), radius: 1.0, fill: rgb(230, 230, 230), stroke: (paint: cOut, thickness: 0.6pt))
  for (dx, dy) in ((0, 0), (0.53, 0), (0.265, 0.46), (-0.265, 0.46), (-0.53, 0), (-0.265, -0.46), (0.265, -0.46)) {
    circle((cx + dx, yA + dy), radius: 0.29, fill: cDark, stroke: none)
  }

  // ── 左端盖 ──
  rect((xS - 0.32, yB - 0.08), (xS, yT + 0.08), fill: cBody, stroke: st)

  // ── 主机体外壳 ──
  rect((xS, yB), (xE, yT), fill: cShell, stroke: st)

  // ── 燃烧室内腔（浅底） ──
  let xI0 = xS + 0.22
  let xI1 = xE - 0.22
  rect((xI0, yB + 0.16), (xI1, yT - 0.16), fill: cBody, stroke: (paint: cOut, thickness: 0.5pt))

  // ── 药柱：等距竖直分块 ──
  let n = 9
  let pw = (xI1 - xI0) / n
  for i in range(n) {
    let xa = xI0 + i * pw + 0.035
    let xb = xI0 + (i + 1) * pw - 0.035
    rect((xa, yB + 0.22), (xb, yT - 0.22), fill: cDark, stroke: none)
  }

  // ── 顶部凸耳与点火器座 ──
  rect((5.95, yT), (6.6, yT + 0.2), fill: cShell, stroke: st)
  rect((10.7, yT), (11.4, yT + 0.34), fill: cBody, stroke: st)

  // ── 喉部过渡段 ──
  line((xE, 4.35), (16.0, 4.15), (16.0, 3.85), (xE, 3.65), close: true, fill: cShell, stroke: st)

  // ── 火箭喷管：扩张钟形 ──
  line((16.0, 3.85), (16.0, 4.15), (21.0, 5.65), (21.0, 2.35), close: true, fill: cNoz, stroke: st)

  // ── 激光照射器：上下两组蓝-黄单元 ──
  rect((14.95, 4.35), (15.85, 5.05), fill: cBlue, stroke: st)
  rect((15.00, 4.55), (15.50, 4.85), fill: cYel, stroke: none)
  rect((14.95, 2.95), (15.85, 3.65), fill: cBlue, stroke: st)
  rect((15.00, 3.15), (15.50, 3.45), fill: cYel, stroke: none)

  // ── 全装置贯通的点划轴线 ──
  line((1.2, yA), (21.0, yA), stroke: (paint: rgb(107, 107, 107), thickness: 0.5pt, dash: "loosely-dotted"))

  // ── 标注引线 ──
  line((4.9, 6.30), (3.20, 5.05), stroke: stL)     // Propellant -> 端面
  line((10.50, 6.55), (11.05, 5.55), stroke: stL)  // Ignitor -> 点火器座
  line((16.60, 6.85), (15.45, 5.05), stroke: stL)  // Laser irradiator -> 蓝块
  line((11.70, 2.25), (12.30, 2.80), stroke: stL)  // Combustion chamber -> 壳体底
  line((18.90, 1.75), (18.90, 2.98), stroke: stL)  // Rocket nozzle -> 喷管

  // ── 文字标签 ──
  content((4.9, 6.45), [Propellant], anchor: "west")
  content((9.6, 6.70), [Ignitor], anchor: "west")
  content((16.2, 7.00), [Laser irradiator], anchor: "west")
  content((9.9, 2.20), [Combustion chamber])
  content((18.4, 1.55), [Rocket nozzle])
})
