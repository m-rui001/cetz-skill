#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 静电拖曳示意（Mechanics of Space Debris Removal, Fig.12；DOI 10.3390/aerospace12040277）：
// 右侧航天器带正电荷晕、喇叭锥与两片太阳翼，左侧碎片带负电荷晕，
// 中间蓝色电子束锥与黄色双向箭头，红色弧形拖尾及倾斜引线标签。
#canvas({
  import draw: *;

  // 画布边界
  rect((-8.0, -4.8), (7.6, 5.0), fill: none, stroke: none)

  // 地标坐标
  let S = (2.55, 1.10)    // 航天器中心
  let D = (-4.0, -1.70)   // 碎片中心
  let apex = (0.20, 1.05) // 电子束顶点（喇叭口）

  // 折线椭圆助手
  let oval(center, rx, ry, fill: none, stroke: none) = {
    let pts = range(0, 36).map(i => {
      let a = i * 10deg
      (center.at(0) + rx * calc.cos(a), center.at(1) + ry * calc.sin(a))
    })
    line(..pts, close: true, fill: fill, stroke: stroke)
  }
  // 折线弧助手（起止角度）
  let arc-line(center, rx, ry, a0, a1, stroke: none, n: 18) = {
    let pts = range(0, n + 1).map(i => {
      let a = a0 + (a1 - a0) * i / n
      (center.at(0) + rx * calc.cos(a), center.at(1) + ry * calc.sin(a))
    })
    line(..pts, stroke: stroke)
  }
  // 绕碎片中心旋转的坐标助手
  let ang = -16deg
  let rotp(p) = {
    let dx = p.at(0) - D.at(0)
    let dy = p.at(1) - D.at(1)
    (D.at(0) + dx * calc.cos(ang) - dy * calc.sin(ang),
     D.at(1) + dx * calc.sin(ang) + dy * calc.cos(ang))
  }
  // 旋转矩形助手（两角点）
  let rrect(a, b, fill: none, stroke: none) = {
    let pts = ((a.at(0), a.at(1)), (b.at(0), a.at(1)),
               (b.at(0), b.at(1)), (a.at(0), b.at(1))).map(rotp)
    line(..pts, close: true, fill: fill, stroke: stroke)
  }
  // 旋转线段助手
  let rline(a, b, stroke: none) = line(rotp(a), rotp(b), stroke: stroke)

  // ── 红色弧形拖尾（上下各一条，粗圆头直线，端点埋入晕圈/太阳翼后） ──
  line((-1.70, 4.40), (3.30, 3.30),
    stroke: (paint: rgb(240, 118, 118), thickness: 15pt, cap: "round"))
  line((3.10, 0.30), (2.30, -3.40),
    stroke: (paint: rgb(240, 118, 118), thickness: 15pt, cap: "round"))

  // ── 航天器正电荷晕 ──
  circle(S, radius: 2.45, fill: rgb(226, 234, 214), stroke: none)

  // ── 淡紫散射锥（底） ──
  line(apex, (-3.90, 0.10), (-3.90, -3.10), close: true,
    fill: rgb(150, 143, 196, 110), stroke: none)

  // ── 蓝色电子束锥 ──
  line(apex, (-3.60, 0.12), (-3.60, -2.52), close: true,
    fill: rgb(70, 106, 176, 215), stroke: none)

  // ── 航天器喇叭锥体 ──
  line((0.10, 2.30), (1.55, 1.62), (1.55, 0.58), (0.10, -0.12), close: true,
    fill: rgb(210, 217, 205), stroke: (paint: rgb(120, 130, 120), thickness: 0.9pt))
  oval((0.12, 1.09), 0.22, 1.21,
    fill: rgb(232, 236, 226), stroke: (paint: rgb(120, 130, 120), thickness: 0.9pt))
  // 喇叭内侧弧线
  arc-line((0.30, 1.09), 0.55, 0.55, 100deg, 260deg,
    stroke: (paint: rgb(150, 160, 148), thickness: 0.7pt))

  // ── 航天器舱体与尾罩 ──
  rect((1.50, 0.62), (2.95, 1.58), radius: 0.45,
    fill: rgb(186, 193, 180), stroke: (paint: rgb(110, 120, 110), thickness: 0.9pt))
  oval((2.98, 1.10), 0.28, 0.48, fill: rgb(62, 68, 62), stroke: none)

  // ── 上下太阳翼（两短边插值出内部栅格） ──
  let panel(a, b, c, d, fill) = {
    line(a, b, c, d, close: true,
      fill: fill, stroke: (paint: rgb(96, 112, 148), thickness: 0.9pt))
    for t in (1.0 / 3.0, 2.0 / 3.0) {
      let p(u, v) = (u.at(0) + (v.at(0) - u.at(0)) * t,
                     u.at(1) + (v.at(1) - u.at(1)) * t)
      line(p(a, b), p(d, c), stroke: (paint: rgb(140, 155, 190), thickness: 0.7pt))
    }
    let m(u, v) = ((u.at(0) + v.at(0)) / 2, (u.at(1) + v.at(1)) / 2)
    line(m(a, d), m(b, c), stroke: (paint: rgb(140, 155, 190), thickness: 0.7pt))
  }
  panel((3.14, 1.77), (4.06, 3.77), (4.78, 3.43), (3.86, 1.43), rgb(58, 74, 122))
  panel((3.31, 0.69), (5.04, -0.97), (5.62, -0.36), (3.89, 1.31), rgb(52, 66, 116))

  // ── 正电荷符号 ──
  for p in ((0.70, 2.60), (1.60, 3.10), (2.70, 2.90),
            (4.90, 1.70), (4.40, -0.50), (3.50, -1.00),
            (1.50, -0.85), (5.10, 0.55)) {
    content(p, text(size: 13pt, weight: "bold")[+])
  }

  // ── 碎片负电荷晕 ──
  circle(D, radius: 1.75, fill: rgb(247, 224, 205), stroke: none)

  // ── 碎片主体（旋转的卫星本体与橙色电池板） ──
  rrect((-4.78, -2.42), (-3.22, -1.02),
    fill: rgb(152, 154, 160), stroke: (paint: rgb(70, 72, 80), thickness: 1pt))
  rrect((-4.65, -2.28), (-4.00, -1.16),
    fill: rgb(206, 122, 40), stroke: (paint: rgb(80, 60, 40), thickness: 0.7pt))
  rrect((-3.90, -2.28), (-3.40, -1.16),
    fill: rgb(186, 106, 36), stroke: (paint: rgb(80, 60, 40), thickness: 0.7pt))
  rline((-4.32, -2.28), (-4.32, -1.16), stroke: (paint: rgb(80, 60, 40), thickness: 0.6pt))
  rline((-4.65, -1.72), (-3.40, -1.72), stroke: (paint: rgb(80, 60, 40), thickness: 0.6pt))
  // 顶部天线盘
  oval((-4.15, -0.95), 0.28, 0.22,
    fill: rgb(90, 92, 98), stroke: (paint: rgb(60, 62, 70), thickness: 0.7pt))

  // ── 负电荷符号 ──
  for p in ((-5.35, -0.85), (-4.40, -0.35), (-3.00, -0.55),
            (-2.50, -1.55), (-3.10, -2.65), (-4.50, -2.95),
            (-5.30, -2.25), (-5.55, -1.65)) {
    content(p, text(size: 13pt, weight: "bold")[−])
  }

  // ── 黄色双向箭头（沿束轴） ──
  line((-3.50, -1.15), (0.05, 0.95),
    stroke: (paint: rgb(248, 196, 26), thickness: 2.8pt),
    mark: (start: "stealth", end: "stealth"),
    fill: rgb(248, 196, 26))

  // ── 标签与引线 ──
  content((5.15, 2.60), [Space craft], anchor: "west")
  line((5.05, 2.42), (3.05, 1.45), mark: (end: "stealth"), stroke: 0.8pt)

  content((-5.30, -3.45), [Debris], anchor: "center")
  line((-4.90, -3.15), (-4.30, -2.55), mark: (end: "stealth"), stroke: 0.8pt)

  content((-2.90, 2.00), [Electrostatic force results\ from craft charges.],
    angle: 26deg)
  line((-2.30, 1.30), (-1.55, -0.10), mark: (end: "stealth"), stroke: 0.8pt)

  content((-0.45, -1.95), [Electron beam\ emission onto debris.], angle: 34deg)
  line((-0.75, -1.55), (-1.15, -0.30), mark: (end: "stealth"), stroke: 0.8pt)

  content((4.35, -3.55), [Low-thrust used to\ tow debris], anchor: "center")
  line((3.70, -2.95), (3.05, -1.90), mark: (end: "stealth"), stroke: 0.8pt)
})
