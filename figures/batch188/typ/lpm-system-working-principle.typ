#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 液体推进模块工作原理示意：左侧贮箱—阀门—集气腔主流程，右上为加热芯片区放大图
// 来源：Aerospace 2024, 11(7), 502, Fig.7（DOI 10.3390/aerospace11070502）
#canvas({
  import draw: *
  let ink = rgb("#2e4256")        // 主轮廓深蓝灰
  let purple = rgb("#4a3a68")     // 加热条 / 放大图壁面深紫
  let bluefill = rgb("#4a7eb8")   // 推进剂填充蓝
  let bluedot = rgb("#2f6db5")    // 气体分子点
  let red = rgb("#e02424")        // 放大圈与箭头红
  let orange = rgb("#f2a71b")     // 放大图顶端粒子橙
  let dashc = rgb("#4a86c8")      // 飞行轨迹虚线蓝
  let gasdot(p, r: 0.05) = circle(p, radius: r, fill: bluedot, stroke: none)

  // —— 左图：Plenum 腔体、顶部加热芯片条与腔内气体 ——
  rect((1.0, 6.9), (4.6, 8.6), fill: white, stroke: ink)
  rect((1.0, 8.15), (4.6, 8.6), fill: purple, stroke: none)
  for i in range(5) {
    let cx = 1.45 + i * 0.63
    rect((cx - 0.21, 8.26), (cx + 0.21, 8.5), fill: white, stroke: none)
  }
  circle((3.34, 8.38), radius: 0.28, fill: none, stroke: (paint: red, thickness: 1.3pt))
  for p in ((1.3, 7.25), (1.75, 7.6), (2.2, 7.15), (2.6, 7.75), (3.1, 7.3), (3.5, 7.65), (3.95, 7.2), (4.35, 7.55), (1.5, 7.95), (2.95, 7.9), (4.1, 7.85), (2.4, 7.45)) { gasdot(p) }
  content((4.8, 8.32), [Heater Chip], anchor: "west")
  content((4.8, 7.5), [Plenum], anchor: "west")

  // —— 阀门前后管路与蝶形阀符号（两个对顶三角） ——
  line((2.62, 6.9), (2.62, 6.3), stroke: ink)
  line((2.98, 6.9), (2.98, 6.3), stroke: ink)
  line((2.62, 5.5), (2.62, 4.9), stroke: ink)
  line((2.98, 5.5), (2.98, 4.9), stroke: ink)
  line((2.45, 6.3), (3.15, 6.3), (2.8, 5.9), close: true, fill: white, stroke: ink)
  line((2.45, 5.5), (3.15, 5.5), (2.8, 5.9), close: true, fill: white, stroke: ink)
  content((3.4, 5.88), [Valve], anchor: "west")

  // —— 贮箱：上部 Gas 与下部推进剂 ——
  rect((0.85, 2.0), (5.35, 4.9), fill: white, stroke: none)
  rect((0.85, 2.0), (5.35, 3.65), fill: bluefill, stroke: none)
  rect((0.85, 2.0), (5.35, 4.9), fill: none, stroke: ink)
  line((0.85, 3.65), (5.35, 3.65), stroke: ink)
  for p in ((1.15, 4.05), (1.55, 4.45), (1.95, 4.15), (2.35, 4.6), (2.75, 4.2), (2.2, 4.75), (3.2, 4.55), (4.25, 4.1), (4.65, 4.5), (5.05, 4.2), (4.5, 4.75), (3.55, 4.0)) { gasdot(p) }
  content((3.8, 4.3), [Gas], anchor: "center")
  content((5.55, 4.3), [Tank], anchor: "west")
  content((3.1, 3.12), [Propellant], anchor: "center")
  content((3.1, 2.58), [Solid/Liquid], anchor: "center")

  // —— 从加热芯片红圈引出 zoom in 指示箭头 ——
  line((3.58, 8.55), (6.25, 8.95), stroke: red, mark: (end: "stealth"))
  content((6.45, 8.95), [zoom in], anchor: "west")
  line((7.85, 8.98), (11.25, 7.62), stroke: red, mark: (end: "stealth"))

  // —— 右图：放大视图的壁面、空间与腔内粒子 ——
  rect((9.5, 3.3), (10.85, 6.25), fill: purple, stroke: none)
  rect((12.25, 3.3), (13.6, 6.25), fill: purple, stroke: none)
  circle((11.5, 4.4), radius: 3.1, fill: none, stroke: (paint: red, thickness: 1.3pt))
  content((12.4, 6.7), [Space], anchor: "west")
  circle((11.55, 6.6), radius: 0.16, fill: orange, stroke: none)
  line((11.55, 6.6), (12.2, 4.35), stroke: (paint: dashc, thickness: 1pt, dash: "dashed"))
  line((12.2, 4.35), (10.8, 2.95), stroke: (paint: dashc, thickness: 1pt, dash: "dashed"), mark: (end: "stealth"))
  circle((10.7, 2.7), radius: 0.15, fill: bluedot, stroke: none)
  circle((11.95, 2.25), radius: 0.15, fill: bluedot, stroke: none)
  circle((12.9, 2.7), radius: 0.15, fill: bluedot, stroke: none)
  content((11.5, 1.7), [Plenum], anchor: "center")
})
