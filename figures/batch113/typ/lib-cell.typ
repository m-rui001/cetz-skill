#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 锂离子电池放电示意（ redraw ）
// 编译效果：顶部中央蓝紫色灯泡（玻璃罩带高光、灯丝锯齿连两根引线、灰色螺纹灯头）；
// 黑色外电路左横段止于灯泡下方缺口、再竖直落到 Cu 板，右横段自缺口另一侧落到 Al 板；
// 左角蓝底白 − 圆、右角红底白 + 圆。深蓝圆角矩形为电池边界。左内 Cu 标签＋浅蓝面/
// 饱和蓝侧面的竖直 3D 板；其右三片透视斜切的石墨蜂窝网格（黑键＋节点小球）竖直叠放，
// 下方两行 Anode / (carbon)。中部竖直粉色隔膜、品红圆角描边，右上标 Separator；底部
// 中央标 Electrolyte。隔膜右侧五层蓝色平行四边形层（三角剖分边），层上下缘红色 O 球、
// 层间绿色 Li 球行，并有蓝色点状竖直迁移路径；右下两行 Cathode / (layered transition
// oxide)。右内 Al 标签＋浅色面/红色侧面 3D 板。底部中右图例：蓝三角＝Co、绿球＝Li、红球＝O。
// 来源：Batteries 2024, 10, 38, Figure 1. DOI 10.3390/batteries10010038.
#canvas(length: 1cm, {
  import draw: *

  // —— 配色与命名地标（cm）——
  let ink = rgb("#1f3864")
  let bulb = rgb("#7b87e0")
  let bulb-e = rgb("#5a63c8")
  let cu-f = rgb("#dbe7f6")
  let cu-s = rgb("#1f77c4")
  let al-f = rgb("#e6ecf7")
  let al-s = rgb("#c0392b")
  let sep-f = rgb("#fbe3ef")
  let sep-e = rgb("#d6339b")
  let lay = rgb("#3742c8")
  let o-c = rgb("#d40000")
  let li-c = rgb("#27ae60")
  let bond = rgb("#222222")
  let y0 = 0.9                          // 极板底
  let y1 = 7.6                          // 极板顶
  let dep = (0.32, 0.22)                // 3D 板深度向量
  let cu-x = 1.75
  let cu-w = 0.9
  let al-x = 13.55
  let al-w = 0.85
  let cu-wx = cu-x + cu-w / 2 + dep.at(0) / 2   // 左导线落点
  let al-wx = al-x + al-w / 2 + dep.at(0) / 2   // 右导线落点
  let top-c = y1 + dep.at(1) / 2
  let wire-y = 10.0
  let bulb-x = 8.0
  let cx0 = 9.1                         // 正极区左界（隔膜右面外）
  let cx1 = 13.0                        // 正极区右界（Al 板左面内）
  let layer-y = (6.78, 5.55, 4.32, 3.09, 1.86)

  // —— 共用助手：高光球、3D 板、斜切蜂窝片、剖分层 ——
  let ball(p, r, c) = {
    circle(p, radius: r, fill: c, stroke: (paint: c.darken(25%), thickness: 0.4pt))
    circle((p.at(0) - r * 0.3, p.at(1) + r * 0.35), radius: r * 0.28, fill: white, stroke: none)
  }
  let slab(x, w, front, side) = {
    let (dx, dy) = dep
    line((x + w, y0), (x + w + dx, y0 + dy), (x + w + dx, y1 + dy), (x + w, y1),
      close: true, fill: side, stroke: (paint: side.darken(25%), thickness: 0.7pt))
    line((x, y1), (x + w, y1), (x + w + dx, y1 + dy), (x + dx, y1 + dy),
      close: true, fill: front.lighten(15%), stroke: (paint: side.darken(10%), thickness: 0.7pt))
    rect((x, y0), (x + w, y1), fill: front, stroke: (paint: side.darken(10%), thickness: 0.7pt))
  }
  let sheet(ox, oy, s: 0.28, nc: 6, nr: 4, kx: 0.5, ky: 0.8) = {
    let hx = calc.sqrt(3) * s
    let P(u, v) = (ox + u + v * kx, oy + v * ky)
    for row in range(nr) {
      for col in range(nc) {
        let cx = col * hx + calc.rem(row, 2) * hx / 2
        let cy = row * 1.5 * s
        let pts = range(7).map(k => {
          let a = 60deg * k + 30deg
          P(cx + s * calc.cos(a), cy + s * calc.sin(a))
        })
        line(..pts, stroke: (paint: bond, thickness: 0.7pt))
        for p in pts.slice(0, 6) { ball(p, 0.045, rgb("#9a9a9a")) }
      }
    }
  }
  let layer(yc, n: 6, th: 0.44, sh: 0.35) = {
    let dx = (cx1 - cx0) / n
    let B = range(n + 1).map(i => (cx0 + i * dx, yc - th / 2))
    let T = range(n + 1).map(i => (cx0 + sh + i * dx, yc + th / 2))
    line(B.at(0), B.at(n), T.at(n), T.at(0), close: true,
      fill: lay, stroke: (paint: lay.darken(25%), thickness: 0.6pt))
    for i in range(n) {
      line(B.at(i), T.at(i), stroke: (paint: lay.lighten(35%), thickness: 0.6pt))
      line(T.at(i), B.at(i + 1), stroke: (paint: lay.lighten(35%), thickness: 0.6pt))
    }
    line(B.at(n), T.at(n), stroke: (paint: lay.lighten(35%), thickness: 0.6pt))
    for p in B { ball(p, 0.17, o-c) }
    for p in T { ball(p, 0.17, o-c) }
  }
  let lab(pos, body, anchor: "center") = content(pos, body, anchor: anchor)

  // —— 电池边界：深蓝圆角矩形 ——
  rect((0, 0), (16, 8.6), radius: 1.1, fill: none, stroke: (paint: ink, thickness: 1.6pt))

  // —— Cu / Al 集流体 3D 板与标签 ——
  slab(cu-x, cu-w, cu-f, cu-s)
  slab(al-x, al-w, al-f, al-s)
  lab((cu-x - 0.35, y1 + 0.45), [Cu])
  lab((al-x + al-w + dep.at(0) + 0.35, y1 + 0.35), [Al])

  // —— 负极：三片斜切蜂窝网格＋两行标签 ——
  for c in (6.9, 4.6, 2.3) { sheet(3.25, c - 0.9) }
  lab((4.1, 0.9), [Anode])
  lab((4.1, 0.45), [(carbon)])

  // —— 隔膜：粉色竖直圆角板＋右上标签；电解液标签 ——
  rect((7.7, 1.0), (8.85, 8.35), radius: 0.28, fill: sep-f, stroke: (paint: sep-e, thickness: 1.2pt))
  lab((9.0, 8.25), [Separator], anchor: "west")
  lab((6.9, 0.5), [Electrolyte])

  // —— 正极：五层剖分层、层间 Li 行与点状迁移路径 ——
  let li-y = range(4).map(i => (layer-y.at(i) + layer-y.at(i + 1)) / 2)
  for x in (cx0 + 2.23, cx0 + 2.89) {
    line((x, li-y.at(0)), (x, li-y.at(3)), stroke: (paint: lay, thickness: 1pt, dash: "dotted"))
  }
  for yc in layer-y { layer(yc) }
  for ym in li-y {
    for i in range(7) { ball((cx0 + 0.25 + i * 0.66, ym), 0.14, li-c) }
  }
  lab((10.5, 0.9), [Cathode], anchor: "west")
  lab((10.5, 0.45), [(layered transition oxide)], anchor: "west")

  // —— 图例：Co 蓝三角、Li 绿球、O 红球 ——
  line((9.35, 1.06), (9.68, 1.06), (9.52, 1.4), close: true, fill: rgb("#1414c8"), stroke: none)
  line((9.52, 1.4), (9.68, 1.06), (9.6, 1.0), close: true, fill: rgb("#0a0a80"), stroke: none)
  lab((9.85, 1.2), [Co], anchor: "west")
  ball((9.5, 0.7), 0.16, li-c)
  lab((9.85, 0.7), [Li], anchor: "west")
  ball((9.5, 0.22), 0.16, o-c)
  lab((9.85, 0.22), [O], anchor: "west")

  // —— 外电路：带缺口的横线＋落到极板的竖线、极性圆 ——
  let ws = (paint: black, thickness: 2pt)
  line((cu-wx, wire-y), (bulb-x - 1.5, wire-y), stroke: ws)
  line((cu-wx, wire-y), (cu-wx, top-c), stroke: ws)
  line((bulb-x + 1.6, wire-y), (al-wx, wire-y), stroke: ws)
  line((al-wx, wire-y), (al-wx, top-c), stroke: ws)
  circle((cu-wx - 0.55, 9.2), radius: 0.42, fill: rgb("#1f77c4"), stroke: none)
  lab((cu-wx - 0.55, 9.2), text(fill: white)[−])
  circle((al-wx + 0.62, 9.2), radius: 0.42, fill: rgb("#e00000"), stroke: none)
  lab((al-wx + 0.62, 9.2), text(fill: white)[+])

  // —— 灯泡：灰色螺纹灯头、蓝紫玻璃罩、高光、灯丝与引线 ——
  line((7.55, 9.8), (8.45, 9.8), (8.32, 8.95), (7.68, 8.95), close: true,
    fill: rgb("#b9b9b9"), stroke: (paint: rgb("#8a8a8a"), thickness: 0.8pt))
  for yy in (9.62, 9.44, 9.26, 9.08) {
    line((7.62, yy), (8.38, yy), stroke: (paint: rgb("#8a8a8a"), thickness: 0.8pt))
  }
  circle((8.0, 8.92), radius: 0.12, fill: rgb("#8a8a8a"), stroke: none)
  rect((7.58, 9.72), (8.42, 9.92), fill: bulb-e, stroke: none)
  hobby((7.62, 9.8), (6.95, 10.9), (7.35, 12.0), (8.0, 12.3), (8.65, 12.0), (9.05, 10.9), (8.38, 9.8),
    close: true, fill: bulb, stroke: (paint: bulb-e, thickness: 1.2pt))
  bezier((7.28, 11.5), (7.6, 11.95), (7.3, 11.8), (7.45, 11.98),
    stroke: (paint: rgb("#cdd3f5"), thickness: 2.5pt, cap: "round"))
  let fp = range(9).map(i => (7.72 + i * 0.07, 10.95 + calc.rem(i, 2) * 0.12))
  line(..fp, stroke: (paint: rgb("#dfe3fa"), thickness: 1pt))
  line((7.72, 10.95), (7.8, 9.85), stroke: (paint: rgb("#dfe3fa"), thickness: 1pt))
  line((8.28, 10.95), (8.2, 9.85), stroke: (paint: rgb("#dfe3fa"), thickness: 1pt))
})
