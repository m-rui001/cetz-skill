#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 编译效果：两幅并排的激光推进剖面示意图。红色粗激光箭头、浅蓝靶板＋灰色/透明基底、
// 红色星芒等离子体与蓝色鼓包、右侧冲击波弧线与飞溅液滴、绿色推力箭头、黑色方框引线标注。
// 来源：Aerospace 2025, 12, 604, Figure 1（DOI 10.3390/aerospace12070604）

#let s = 0.0125            // 参考图像素 → 厘米
#let H = 506
#let P(x, y) = (x * s, (H - y) * s)   // 像素坐标（y 向下）→ 画布坐标（y 向上）
#let ink = rgb("#1a3a63")
#let board = rgb("#98b9e3")
#let plasm = rgb("#1771c4")
#let red = rgb("#ff0000")
#let green = rgb("#00a240")
#let serif = ("Times New Roman", "Libertinus Serif")

#canvas({
  import draw: *
  // 粗箭头：a→b，w 杆宽 / hw 头宽 / hl 头长（厘米）
  let fat(a, b, w, hw, hl, fill) = {
    let (x1, y1) = a
    let (x2, y2) = b
    let dx = x2 - x1
    let dy = y2 - y1
    let L = calc.sqrt(dx * dx + dy * dy)
    let (ux, uy) = (dx / L, dy / L)
    let (nx, ny) = (-uy, ux)
    let (xb, yb) = (x2 - hl * ux, y2 - hl * uy)
    line((x1 + nx * w / 2, y1 + ny * w / 2), (xb + nx * w / 2, yb + ny * w / 2),
      (xb + nx * hw / 2, yb + ny * hw / 2), (x2, y2),
      (xb - nx * hw / 2, yb - ny * hw / 2), (xb - nx * w / 2, yb - ny * w / 2),
      (x1 - nx * w / 2, y1 - ny * w / 2),
      close: true, fill: fill, stroke: none)
  }
  // 靶板：一块竖直矩形板
  let slab(x0, x1, y0, y1, fill) = rect(P(x0, y0), P(x1, y1), fill: fill, stroke: 0.8pt + ink)
  // 等离子体：蓝色鼓包（靶面外的胶囊形）＋红色星芒＋五条喷射短线
  let jet(sc, x0, x1) = {
    let (_, cy) = P(..sc)
    rect((x0 * s, cy - 0.235), (x1 * s, cy + 0.235), radius: 0.235,
      fill: plasm, stroke: 0.8pt + ink)
    let n = 11
    let pts = ()
    for i in range(2 * n) {
      let a = (i * 180 / n) * 1deg + 6deg
      let r = if calc.even(i) { 0.40 } else { 0.175 }
      pts.push((P(..sc).at(0) + r * calc.cos(a), P(..sc).at(1) + r * calc.sin(a)))
    }
    line(..pts, close: true, fill: red, stroke: 0.35pt + black)
    for (ang, len) in ((35deg, 0.62), (12deg, 0.78), (-8deg, 0.80), (-27deg, 0.58), (-46deg, 0.60)) {
      let (c, sn) = (calc.cos(ang), calc.sin(ang))
      let (cx, cy) = P(..sc)
      line((cx + 0.54 * c, cy + 0.54 * sn), (cx + (0.54 + len) * c, cy + (0.54 + len) * sn),
        stroke: 0.5pt)
    }
  }
  // 冲击波弧线（右侧开口朝左的圆弧）
  let wave(cx, cy, r) = arc(P(cx, cy), start: -70deg, stop: 70deg, radius: r, stroke: 0.7pt)
  // 飞溅液滴（横向椭圆）
  let drops(pts) = for p in pts {
    group({
      translate(P(..p))
      scale(x: 1.42, y: 1)
      circle((0, 0), radius: 0.08, stroke: 0.55pt)
    })
  }
  // 方框标注：引线先画、方框后画以盖住引线起点
  let tag(c, body, to) = {
    line(P(..c), P(..to), mark: (end: (symbol: "stealth", scale: 1.25, fill: black)), stroke: 0.55pt)
    content(P(..c), text(font: serif, size: 11pt, body), frame: "rect",
      padding: 1.5pt, fill: white, stroke: 0.55pt)
  }

  // ── 左图：激光穿过透明基底，约束烧蚀 ──
  fat(P(28, 208), P(226, 208), 0.38, 0.76, 0.80, red)      // 入射激光
  wave(500, 205, 1.24)                                     // 冲击波
  slab(233, 268, 77, 333, white)                           // 透明基底
  slab(268, 303, 77, 333, board)                           // 靶材
  jet((281, 206), 271, 321)                              // 等离子体与喷射
  drops(((414, 143), (509, 156), (459, 176), (463, 225), (502, 248), (414, 254)))
  content(P(120, 208), text(font: serif, size: 12.5pt, [Laser]))
  fat(P(378, 447), P(178, 447), 0.30, 0.75, 0.68, green)   // 推力
  content(P(278, 447), text(font: serif, size: 12.5pt, [Thrust]))
  tag((362, 51), [Target], (312, 182))
  tag((360, 361), [Plasma], (297, 231))
  tag((127, 351), [Transparent #linebreak() substrate], (247, 324))

  // ── 右图：激光直接辐照自由面，基底在背面 ──
  fat(P(1222, 208), P(976, 208), 0.36, 0.76, 0.72, red)    // 反向入射激光
  wave(1082, 205, 1.20)
  slab(833, 866, 86, 330, rgb("#c0c0c0"))                  // 基底
  slab(866, 896, 86, 330, board)                           // 靶材
  jet((875, 207), 864, 914)
  drops(((1005, 152), (1040, 177), (1088, 150), (1005, 255), (1047, 257), (1080, 227)))
  content(P(1120, 208), text(font: serif, size: 12.5pt, [Laser]))
  fat(P(967, 438), P(777, 438), 0.30, 0.75, 0.68, green)
  content(P(872, 438), text(font: serif, size: 12.5pt, [Thrust]))
  tag((952, 60), [Target], (905, 182))
  tag((950, 356), [Plasma], (884, 231))
  tag((727, 347), [Substrate], (846, 324))
})
