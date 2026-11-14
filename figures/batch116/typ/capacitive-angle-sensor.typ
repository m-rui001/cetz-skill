#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 电容式旋转角度传感器双面板图（redraw，语义重绘）
// 编译效果：(a) 透视椭圆黄色定子盘——灰外缘环、同心椭圆环＋24 根径向辐条扇区网格、
//   三个带孔安装耳（上右/左/下右），中央灰圆柱轮毂托白蓝半球罩；其下黄色转子盘带
//   灰缘环与六瓣正弦波浪电极带、中心灰轴圆柱下伸；八组引线标签上下环绕，底居中 (a)。
//   (b) 线性拟合图——双轴 0–350 刻度、灰点划网格、红粗对角线＋两端露绿的拟合线、
//   右中三条目图例、左上五行系数文本，底居中 (b)。
// 来源：Passive and Active Exoskeleton Solutions: Sensors, Actuators, Applications, and Recent Trends. Sensors 2024, 24, 7095, Figure 2. DOI 10.3390/s24217095.
#canvas(length: 1cm, {
  import draw: *
  // —— 配色与共用助手：透视椭圆点/椭圆/双行标签/引线/圆柱 ——
  let yel = rgb("#f6d365")
  let gry = rgb("#a9a9a9")
  let rim = rgb("#c9c9c9")
  let ink = rgb("#555555")
  let gs = (paint: gry, thickness: 0.5pt)
  let ep(c, rx, ry, f, a) = (c.at(0) + rx * f * calc.cos(a), c.at(1) + ry * f * calc.sin(a))
  let ell(c, rx, ry, f: 1, fill: none, stroke: gs) = circle(c, radius: (rx * f, ry * f), fill: fill, stroke: stroke)
  let ml(a, b) = [#a \ #b]
  let leader(p, body, ts, anchor: "south") = {
    for t in ts { line(p, t, stroke: (paint: ink, thickness: 0.6pt)) }
    content(p, body, anchor: anchor)
  }
  let cyl(cx, y0, y1, rx, ry) = {
    circle((cx, y0), radius: (rx, ry), fill: gry, stroke: gs)
    rect((cx - rx, y0), (cx + rx, y1), fill: gry, stroke: none)
    line((cx - rx, y0), (cx - rx, y1), stroke: gs)
    line((cx + rx, y0), (cx + rx, y1), stroke: gs)
    circle((cx, y1), radius: (rx, ry), fill: gry.lighten(30%), stroke: gs)
  }

  // —— (a) 转子：下伸轴＋灰缘环＋中心黄盘＋正弦波浪电极带 ——
  group({
    translate((5.2, 12.6))
    let C = (0, 0)
    let R = (0, -1.55)
    cyl(0, -3.5, -1.55, 0.55, 0.24)
    ell(R, 3.0, 1.4, fill: rim, stroke: (paint: ink, thickness: 0.8pt))
    ell(R, 2.85, 1.32, fill: white)
    ell(R, 2.85, 1.32, f: 0.45, fill: yel)
    // 内外缘同相位 → 等宽正弦环带（六瓣）
    let wv(f0) = range(73).map(i => { let a = i * 5deg; ep(R, 2.85, 1.32, f0 + 0.1 * calc.sin(6 * a), a) })
    line(..wv(0.86), ..wv(0.62).rev(), close: true, fill: yel, stroke: none)
    line(..wv(0.86), close: true, stroke: gs)
    line(..wv(0.62), close: true, stroke: gs)
    // —— (a) 定子：三安装耳＋黄盘灰缘＋辐条/同心环扇区网格 ——
    for a in (75deg, 185deg, 345deg) {
      let p = ep(C, 3.2, 1.5, 1.12, a)
      circle(p, radius: (0.3, 0.15), fill: rim, stroke: (paint: ink, thickness: 0.7pt))
      circle(p, radius: (0.12, 0.06), fill: white, stroke: gs)
    }
    ell(C, 3.3, 1.55, fill: rim, stroke: (paint: ink, thickness: 0.8pt))
    ell(C, 3.15, 1.47, fill: yel)
    for i in range(24) { let a = i * 15deg; line(ep(C, 3.15, 1.47, 0.45, a), ep(C, 3.15, 1.47, 1, a), stroke: gs) }
    for f in (0.45, 0.72) { ell(C, 3.15, 1.47, f: f) }
    // —— (a) 轮毂法兰＋灰圆柱＋白蓝半球罩 ——
    ell((0, 0.05), 0.78, 0.36, fill: rim)
    cyl(0, 0.05, 0.72, 0.62, 0.28)
    hobby((-0.62, 0.72), (-0.52, 1.22), (0, 1.48), (0.52, 1.22), (0.62, 0.72), (0, 0.5),
      close: true, fill: rgb("#f5f8fd"), stroke: gs)
    bezier((-0.55, 0.8), (0.55, 0.8), (-0.2, 0.52), (0.2, 0.52), stroke: (paint: rgb("#b9c6e8"), thickness: 2.5pt))
    // —— (a) 八组引线标签（上四下四）与面板字母 ——
    leader((-3.7, 2.5), [Stator], (ep(C, 3.3, 1.55, 1, 160deg),))
    leader((-1.7, 2.9), ml("Excitation", "electrodes"), (ep(C, 3.15, 1.47, 0.5, 150deg), ep(C, 3.15, 1.47, 0.5, 115deg)))
    leader((0.9, 2.9), ml("Collection", "electrodes"), (ep(C, 3.15, 1.47, 0.8, 65deg), ep(C, 3.15, 1.47, 0.8, 35deg)))
    leader((3.1, 2.9), ml("Guard", "electrodes"), (ep(C, 3.3, 1.55, 1, 25deg), ep(C, 3.3, 1.55, 1, 0deg)))
    leader((-3.7, -3.5), [Rotor], (ep(R, 3.0, 1.4, 1, 200deg),), anchor: "north")
    leader((-1.6, -3.9), ml("Coupling", "electrodes"),
      (ep(R, 2.85, 1.32, 0.75, 235deg), ep(R, 2.85, 1.32, 0.75, 265deg)), anchor: "north")
    leader((1.0, -3.9), ml("Sensitive", "electrodes"),
      (ep(R, 2.85, 1.32, 0.75, 300deg), ep(R, 2.85, 1.32, 0.75, 330deg)), anchor: "north")
    leader((3.3, -3.7), ml("Guard", "electrodes"),
      (ep(R, 3.0, 1.4, 1, 340deg), ep(C, 3.3, 1.55, 1, 340deg)), anchor: "north")
    content((0, -4.95), [(a)])
  })

  // —— (b) 拟合图：度→cm 比例助手＋边框/点划网格/双轴刻度 loop ——
  group({
    translate((1.7, 1.6))
    let W = 8.2
    let H = 5.4
    let sx(d) = d / 375 * W
    let sy(d) = d / 375 * H
    rect((0, 0), (W, H), stroke: (paint: gry, thickness: 0.7pt))
    for i in range(1, 8) {
      let v = i * 50
      line((sx(v), 0), (sx(v), H), stroke: (paint: gry, thickness: 0.5pt, dash: "dash-dotted"))
      line((0, sy(v)), (W, sy(v)), stroke: (paint: gry, thickness: 0.5pt, dash: "dash-dotted"))
    }
    for i in range(8) {
      let v = i * 50
      line((sx(v), 0), (sx(v), -0.12), stroke: (paint: ink, thickness: 0.6pt))
      content((sx(v), -0.22), text(9pt)[#v], anchor: "north")
      line((0, sy(v)), (-0.12, sy(v)), stroke: (paint: ink, thickness: 0.6pt))
      content((-0.22, sy(v)), text(9pt)[#v], anchor: "east")
    }
    content((W / 2, -0.8), [Position (degree)])
    content((-1.1, H / 2), [Output (degree)], angle: 90deg)
    // —— (b) 对角线：绿拟合线全长→蓝测量带 x 标记→红粗线覆盖中段 ——
    line((sx(-14), sy(-14)), (sx(389), sy(389)), stroke: (paint: rgb("#2ecc40"), thickness: 1.6pt))
    line((sx(0), sy(0)), (sx(360), sy(360)),
      stroke: (paint: rgb("#3b6db4"), thickness: 3.2pt), mark: (start: "x", end: "x"))
    line((sx(2), sy(2)), (sx(358), sy(358)), stroke: (paint: rgb("#e60000"), thickness: 2pt))
    // —— (b) 右中图例三条目：蓝 x / 绿星 / 红虚线 x ——
    let entries = (
      (rgb("#3b6db4"), none, "x", [Measured data]),
      (rgb("#2ecc40"), none, "*", [Fitting line of measured data]),
      (rgb("#e60000"), "dashed", "x", [Theoretical data of turntable]),
    )
    for (i, e) in entries.enumerate() {
      let (c, da, mk, lb) = e
      let y = 2.3 - i * 0.4
      line((3.8, y), (4.4, y), stroke: (paint: c, thickness: 1pt, dash: da), mark: (end: mk))
      content((4.55, y), text(8pt, lb), anchor: "west")
    }
    // —— (b) 左上五行拟合系数文本（逐字）与面板字母 ——
    content((0.3, H - 0.25), text(8pt)[Linear model Poly1: \
      f(x) = p1*x + p2 \
      Coefficients (with 95% confidence bounds): \
      #h(0.8em) p1 = 0.9996 (0.9996, 0.9996) \
      #h(0.8em) p2 = 0.0033 (-0.0146, 0.0121)], anchor: "north-west")
    content((W / 2, -1.3), [(b)])
  })
})
