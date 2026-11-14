#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 13pt)
#import "@preview/cetz:0.4.2": canvas, draw

// SAVGS 可调悬架侧视示意：浅灰 L 形底盘（右侧长弧轮拱）+ 圆角车轮块 + 地面剖面线，
// 上/下横臂、斜置弹簧减振器、G-F 摆杆与 T_G 力矩、θ_SL / θ_SL(min) / θ_LW 角及 y′z′ 坐标系。
// 来源：Actuators 2025, 14, 485, Figure 18 (Arana). DOI: 10.3390/act14100485

#canvas({
  import draw: *
  // 原图像素→厘米（y 轴向下，故翻转）
  let K = 0.030
  let P(x, y) = (x * K, (404 - y) * K)
  let ch-fill = rgb(235, 235, 235)
  let wh-fill = rgb(243, 243, 243)
  let bar-c = rgb(107, 107, 107)
  let coil-c = rgb(31, 31, 31)

  // 三次贝塞尔采样成折线点列
  let cub(p0, p1, p2, p3, n) = range(n + 1).map(i => {
    let (t, m) = (i / n, 1 - i / n)
    (0, 1).map(j => m * m * m * p0.at(j) + 3 * m * m * t * p1.at(j)
      + 3 * m * t * t * p2.at(j) + t * t * t * p3.at(j))
  })
  // 屏幕角度圆弧（x 右、y 下）→ 折线
  let sarc(c, r, a1, a2, mark: none) = line(
    ..range(17).map(i => {
      let a = a1 + (a2 - a1) * i / 16
      P(c.at(0) + r * calc.cos(a * 1deg), c.at(1) + r * calc.sin(a * 1deg))
    }), mark: mark, stroke: 0.55pt)
  // 倾斜椭圆线圈（弹簧）
  let coil(c, rx, ry, ang) = line(..range(20).map(i => {
    let (a, ca, sa) = (i / 19 * 360deg, calc.cos(ang * 1deg), calc.sin(ang * 1deg))
    let (x, y) = (rx * calc.cos(a), ry * calc.sin(a))
    P(c.at(0) + x * ca - y * sa, c.at(1) + x * sa + y * ca)
  }), close: true, stroke: (paint: coil-c, thickness: 0.095))
  // 实心四分之一圆（坐标系/轮心符号）
  let wedge(c, r, a1, a2) = {
    let pts = range(9).map(i => {
      let a = a1 + (a2 - a1) * i / 8
      P(c.at(0) + r * calc.cos(a * 1deg), c.at(1) + r * calc.sin(a * 1deg))
    })
    line(..pts, P(..c), close: true, fill: rgb(20, 20, 20), stroke: none)
  }
  // 波浪引线
  let leader(a, b, k: 0.18) = {
    let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1))
    bezier(P(..a), P(a.at(0) + dx * 0.40 - dy * k, a.at(1) + dy * 0.40 + dx * k),
      P(a.at(0) + dx * 0.72 + dy * k * 0.7, a.at(1) + dy * 0.72 - dx * k * 0.7),
      P(..b), stroke: (paint: rgb(64, 64, 64), thickness: 0.45pt))
  }
  // 横臂：白色胶囊杆 + 两端关节
  let wishbone(a, b, h) = {
    let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1))
    let (nx, ny) = (-dy, dx).map(v => v / calc.sqrt(dx * dx + dy * dy) * h)
    line(P(a.at(0) + nx, a.at(1) + ny), P(b.at(0) + nx, b.at(1) + ny),
      P(b.at(0) - nx, b.at(1) - ny), P(a.at(0) - nx, a.at(1) - ny),
      close: true, fill: white, stroke: 0.6pt)
    for p in (a, b) { circle(P(..p), radius: 0.115, fill: white, stroke: 0.6pt) }
  }

  // 地标：G/F 摆杆铰点、E 减振器下铰点、上下横臂端点
  let (G, F, E) = ((161, 105), (181, 105), (211, 264))
  let (SA, SB, WA, WB) = ((150, 156), (227, 156), (129, 264), (231, 283))

  // 底盘：L 形外轮廓，右边界为轮拱长弧
  let arch = ()
  for p in cub((240, 58), (206, 88), (178, 128), (170, 170), 10) { arch.push(P(..p)) }
  for p in cub((170, 170), (163, 230), (148, 320), (123, 351), 8).slice(1) { arch.push(P(..p)) }
  let corner = ()
  for p in cub((224, 37), (236, 37), (240, 44), (240, 58), 6).slice(1) { corner.push(P(..p)) }
  line(P(48, 352), P(48, 37), P(224, 37), ..corner, ..arch, P(100, 352), P(70, 352),
    close: true, fill: ch-fill, stroke: 0.7pt)

  // 车轮块（圆角矩形）与地面剖面线
  rect(P(222, 78), P(332, 353), radius: 0.36, fill: wh-fill, stroke: 0.7pt)
  line(P(44, 355), P(356, 355), stroke: 0.8pt)
  for i in range(26) { line(P(50 + i * 11, 355), P(42 + i * 11, 363), stroke: 0.5pt) }

  // θ_SL：水平/斜向虚线射线 + 竖向量角箭头
  line(P(F.at(0), 105), P(250, 105), stroke: (paint: rgb(77, 77, 77), thickness: 0.45pt, dash: "dotted"))
  line(P(F.at(0), 105), P(241, 120), stroke: (paint: rgb(77, 77, 77), thickness: 0.45pt, dash: "dotted"))
  line(P(236, 106), P(236, 121), mark: (end: "stealth", fill: black), stroke: 0.5pt)
  // θ_LW：同样的射线与量角箭头
  line(P(E.at(0), 263), P(322, 263), stroke: (paint: rgb(77, 77, 77), thickness: 0.45pt, dash: "dotted"))
  line(P(E.at(0), 263), P(322, 288), stroke: (paint: rgb(77, 77, 77), thickness: 0.45pt, dash: "dotted"))
  line(P(283, 264), P(283, 281), mark: (end: "stealth", fill: black), stroke: 0.5pt)
  // θ_SL 大弧（水平→竖直）、θ_SL(min) 极限虚线与上方包络弧
  sarc((146, 115), 62, -8, -90, mark: (end: "stealth", fill: black))
  line(P(146, 53), P(168, 99), stroke: (paint: rgb(89, 89, 89), thickness: 0.5pt, dash: "dashed"))
  bezier(P(238, 56), P(222, 55), P(202, 60), P(186, 95), stroke: (paint: rgb(90, 90, 90), thickness: 0.45pt))

  // 减振器主筒 + 沿轴排布的弹簧线圈
  line(P(..G), P(208, 251), stroke: (paint: bar-c, thickness: 0.55))
  for i in range(10) {
    let t = 0.355 + i * 0.054
    coil((G.at(0) + (E.at(0) - G.at(0)) * t, G.at(1) + (E.at(1) - G.at(1)) * t), 27, 3.4, 9)
  }
  // 筒底叉形支架与 E 铰点
  line(P(196, 247), P(222, 252), P(214, 270), P(197, 259),
    close: true, fill: rgb(212, 212, 212), stroke: 0.6pt)
  circle(P(..E), radius: 0.105, fill: white, stroke: 0.6pt)

  // 上横臂、下横臂（后画以压住筒身）
  wishbone(SA, SB, 5.6)
  wishbone(WA, WB, 5.0)
  // G-F 摆杆与两端铰点
  line(P(G.at(0) - 2, G.at(1)), P(F.at(0) + 2, F.at(1)), stroke: (paint: rgb(46, 46, 46), thickness: 0.26))
  for p in (G, F) { circle(P(..p), radius: 0.085, fill: white, stroke: 0.5pt) }
  // T_G 力矩弧箭头
  sarc((159, 107), 14, 165, 330, mark: (end: "stealth", fill: black))

  // 坐标系：四分之一填充圆 + y′/z′ 轴
  circle(P(57, 120), radius: 0.18, stroke: 0.6pt)
  wedge((57, 120), 6, 180, 270)
  wedge((57, 120), 6, 0, 90)
  line(P(63, 120), P(82, 120), mark: (end: "stealth", fill: black), stroke: 0.6pt)
  line(P(57, 126), P(57, 143), mark: (end: "stealth", fill: black), stroke: 0.6pt)
  content(P(88, 119), anchor: "west", $y'$)
  content(P(64, 147), anchor: "west", $z'$)

  // 轮心 H 符号与接地点 I 引线
  circle(P(272, 216), radius: 0.30, stroke: 0.5pt)
  wedge((272, 216), 10, 180, 270)
  wedge((272, 216), 10, 0, 90)
  leader((283, 212), (297, 206))
  // 其余引线：SL、SD、上下横臂、I
  leader((152, 118), (160, 106), k: 0.2)
  leader((240, 187), (211, 183), k: 0.3)
  leader((127, 177), (150, 160))
  leader((121, 292), (130, 266))
  leader((285, 337), (277, 353), k: 0.35)

  // 文字标注（逐字照录）
  for (p, t) in (
    ((104, 46), [Chassis]), ((300, 100), [Wheel]), ((140, 133), [SL]), ((250, 187), [SD]),
    ((188, 257), [E]), ((137, 110), [G]), ((183, 85), [F]), ((146, 82), $T_G$),
    ((176, 24), $theta_"SL"^("min")$), ((286, 332), [I]),
    ((110, 199), align(center)[Upper #linebreak() wishbone]),
    ((93, 321), align(center)[Lower #linebreak() wishbone]),
  ) { content(P(..p), t) }
  for (p, t) in (((249, 121), $theta_"SL"$), ((288, 273), $theta_"LW"$), ((300, 206), [H])) {
    content(P(..p), t, anchor: "west")
  }
})
