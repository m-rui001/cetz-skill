#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 脉冲等离子体电磁推进（PPT）系统示意图：左侧放电电容引线，中部推进剂供给系统与固体推进剂，
// 顶部点火器／阴极条、底部阳极条，右侧等离子体在 E、B 场中电磁加速排出。
// 重绘自 Aerospace 2024, 11(7), 502, Figure 27（CAD 图转干净线稿平涂；DOI 10.3390/aerospace11070502）。
#canvas({
  import draw: *

  // —— 配色与线型 ——
  let c-feed = rgb(72%, 72%, 72%)
  let c-prop = rgb(82%, 82%, 82%)
  let c-bar = rgb(76%, 76%, 76%)
  let c-ign = rgb(96%, 96%, 96%)
  let ln = (paint: black, thickness: 0.9pt)
  let thick = (paint: black, thickness: 2pt)

  // —— 关键地标 ——
  let fx0 = 2.20       // 腔体左壁
  let fx1 = 11.30      // 腔体右侧上下轨末端
  let fy0 = 0.42       // 下轨
  let fy1 = 3.60       // 上轨
  let yax = 2.00       // 中轴：等离子体/排气方向
  let xbar = 8.45      // 阴极条左缘＝点火器右缘

  // 外围细灰框
  rect((1.60, 0.05), (15.35, 3.95), stroke: (paint: rgb(55%, 55%, 55%), thickness: 0.5pt))

  // 加粗腔体框：右侧开口，上下轨末端带短竖挡边
  line((fx1, 2.95), (fx1, fy1), (fx0, fy1), (fx0, fy0), (fx1, fy0), (fx1, 0.95),
       stroke: thick)

  // 推进剂供给系统（灰箱）
  rect((2.35, 0.95), (4.25, 2.95), fill: c-feed, stroke: ln)
  content((3.30, 1.95), [Propellant \ Feed \ System])

  // 固体推进剂（圆角大块）
  rect((4.45, 0.75), (7.55, 3.05), radius: 0.30, fill: c-prop, stroke: ln)
  content((6.00, 1.90), [Solid \ Propellant])

  // 供给系统 → 固体推进剂 粗箭头
  line((4.27, 1.90), (5.40, 1.90), stroke: (paint: black, thickness: 1.4pt),
       mark: (end: "stealth"))

  // 点火器：右下角斜切的五边形
  line((6.95, 2.50), (6.95, 3.55), (xbar, 3.55), (xbar, 2.80), (8.10, 2.50),
       close: true, fill: c-ign, stroke: ln)
  content((7.70, 3.10), [Igniter])

  // 阴极条 / 阳极条（表驱动，标签居条外侧）
  let bars = (
    (n: "Cathode", x0: xbar, x1: fx1, y0: 3.22, y1: 3.50, lx: 9.85, ly: 3.76),
    (n: "Anode",   x0: 7.60, x1: fx1, y0: 0.50, y1: 0.78, lx: 9.50, ly: 1.04),
  )
  for b in bars {
    rect((b.x0, b.y0), (b.x1, b.y1), fill: c-bar, stroke: ln)
    content((b.lx, b.ly), b.n)
  }

  // 等离子体虚线箭头与标注
  line((xbar + 0.10, yax), (9.45, yax), stroke: (paint: black, thickness: 0.9pt, dash: "dashed"),
       mark: (end: "stealth"))
  content((xbar + 0.10, yax + 0.24), [Plasma], anchor: "west")

  // 电场 E：矢量标注＋向下箭头
  content((9.95, 2.72), $arrow(bold(E))$)
  line((9.95, 2.52), (9.95, 2.18), stroke: (paint: black, thickness: 1.2pt),
       mark: (end: "stealth"))

  // 磁场 B：带圆心点的圆（指向纸外）＋矢量标注
  circle((10.40, yax), radius: 0.16, stroke: ln)
  circle((10.40, yax), radius: 0.032, fill: black, stroke: none)
  content((10.62, yax + 0.26), $arrow(bold(B))$, anchor: "west")

  // 电磁加速排出：两行标注＋中间虚线箭头
  content((11.95, 2.45), [Electromagnetically], anchor: "west")
  content((11.95, 1.72), [Accelerated Exhaust], anchor: "west")
  line((11.95, 2.08), (13.35, 2.08), stroke: (paint: black, thickness: 0.9pt, dash: "dashed"),
       mark: (end: "stealth"))

  // 放电电容：左侧标签＋两条引出线（跨过细框接至腔体左壁）
  content((1.45, 2.00), [Discharge \ Capacitor], anchor: "east")
  line((1.56, 2.14), (fx0, 2.14), stroke: ln)
  line((1.56, 1.86), (fx0, 1.86), stroke: ln)
})
