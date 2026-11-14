#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：横向环形任务流程图。中心为蓝色地球，六个卫星图标记分布在环上，浅蓝弧箭头顺时针串联；
// 每个标记旁为编号步骤文字（逐字照录），卫星以简化线稿绘制（本体＋双太阳翼＋可选天线盘/载荷舱）。
// 来源：Aerospace 2025, 12, 375, Figure 13 "Phoenix Mission Flow"。DOI 10.3390/aerospace12050375

#canvas({
  import draw: *
  let navy = rgb("#33456e")
  let steel = rgb("#5d7ba8")
  let gold = rgb("#c79a3c")
  let ink = black
  let arcblue = rgb("#9db8dc")
  let earth = rgb("#b9dcf2")
  let land = rgb("#6fae7c")

  let C = (8.00, 4.20)
  // 极坐标取点
  let P(c, a, r) = (c.at(0) + r * calc.cos(a * 1deg), c.at(1) + r * calc.sin(a * 1deg))
  // 点绕 c 旋转 a 度
  let rot(p, c, a) = {
    let (x, y) = p
    let (ox, oy) = c
    let t = a * 1deg
    (ox + (x - ox) * calc.cos(t) - (y - oy) * calc.sin(t),
     oy + (x - ox) * calc.sin(t) + (y - oy) * calc.cos(t))
  }
  // 旋转矩形：中心 c、半宽 w、半高 h、角 a
  let rrect(c, w, h, a, fill: navy, stroke: 0.5pt) = line(
    ..((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) - h),
       (c.at(0) + w, c.at(1) + h), (c.at(0) - w, c.at(1) + h)).map(p => rot(p, c, a)),
    close: true, fill: fill, stroke: stroke,
  )
  // 卫星：本体＋左右太阳翼＋可选天线盘与载荷舱
  let sat(c, a, dish: false, pod: false, s: 1) = {
    for sd in (-1, 1) {
      let wc = rot((c.at(0) + 0.62 * s * sd, c.at(1)), c, a)
      rrect(wc, 0.24 * s, 0.075 * s, a, fill: steel, stroke: 0.4pt)
      line(rot((c.at(0) + 0.32 * s * sd, c.at(1)), c, a), rot((c.at(0) + 0.38 * s * sd, c.at(1)), c, a), stroke: 0.5pt)
    }
    rrect(c, 0.22 * s, 0.13 * s, a, fill: navy, stroke: 0.6pt)
    if dish {
      let dc = rot((c.at(0) + 0.10 * s, c.at(1) + 0.24 * s), c, a)
      line(rot((c.at(0) + 0.05 * s, c.at(1) + 0.10 * s), c, a), dc, stroke: 0.4pt)
      circle(dc, radius: 0.075 * s, fill: gold, stroke: 0.4pt)
    }
    if pod {
      for sd in (-1, 1) {
        let pc = rot((c.at(0) + 0.10 * s * sd, c.at(1) - 0.20 * s), c, a)
        rrect(pc, 0.075 * s, 0.065 * s, a, fill: gold, stroke: 0.4pt)
      }
    }
  }
  // 编号步骤：圆角框编号＋两行文字
  let step(pos, t, num, anchor: "center") = content(
    pos,
    text(size: 8pt, fill: ink)[#num. #t],
    anchor: anchor, frame: none,
  )

  // 中心地球：海洋圆＋三块简化陆地
  circle(C, radius: 1.18, fill: earth, stroke: 0.9pt + ink)
  line(..((7.05, 4.90), (7.45, 5.10), (7.85, 4.95), (7.60, 4.65), (7.25, 4.65)).map(p => p), close: true, fill: land, stroke: none)
  line(..((8.05, 4.30), (8.45, 4.50), (8.85, 4.25), (8.70, 3.75), (8.30, 3.65), (8.10, 3.95)).map(p => p), close: true, fill: land, stroke: none)
  line(..((7.60, 3.30), (7.95, 3.40), (8.05, 3.10), (7.70, 3.00)).map(p => p), close: true, fill: land, stroke: none)

  // 六个卫星标记（环上角度：1 号在左下，顺时针）
  let steps = ((215, false, true), (160, false, false), (105, false, false),
    (50, true, false), (5, true, false), (-55, true, false))
  for (a, dish, pod) in steps {
    sat(P(C, a, 3.02), a + 90, dish: dish, pod: pod, s: 1.0)
  }
  // 环形箭头：相邻标记之间的外凸弧
  for (a1, a2) in ((222, 153), (153, 98), (98, 43), (43, -2), (-2, -62), (-62, -128)) {
    arc-through(P(C, a1, 3.35), P(C, (a1 + a2) / 2, 3.62), P(C, a2, 3.35),
      stroke: (paint: arcblue, thickness: 2pt), mark: (end: "stealth", scale: 1.4))
  }

  // 步骤文字置于环外侧（沿各自径向），按象限选择锚点使文字向外展开，避免相互遮挡
  let labels = (
    (215, [PODs go into orbit \ with commercial \ satellite.], 1, "north-east"),
    (160, [The service \ satellite goes \ into orbit.], 2, "east"),
    (105, [The service \ satellite captures \ the PODs.], 3, "south-east"),
    (50, [The service \ satellite captures \ a defunct satellite.], 4, "south-west"),
    (5, [The service \ satellite assemble \ a new satellite.], 5, "west"),
    (-55, [The new satellite \ works independently.], 6, "north-west"),
  )
  for (a, t, num, anc) in labels {
    line(P(C, a, 3.74), P(C, a, 3.94), stroke: (paint: steel, thickness: 0.6pt))
    step(P(C, a, 4.02), t, num, anchor: anc)
  }
})
