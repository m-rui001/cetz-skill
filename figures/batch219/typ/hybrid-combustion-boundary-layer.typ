#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 混合火箭燃烧边界层示意：顶部黑色 Oxidizer Flow 粗箭头，黑曲线为湍流边界层外缘；下部橙色
// Polymer Fuel 块与蓝色燃料表面，红色 Diffusion Flame 斜带横贯；左侧紫/蓝/红/橙四条密度-温度
// 剖面与绿色 Velocity 剖面，中部蓝 Convection、粉 Radiation、灰/黄扩散框，右侧 Oxidizer Rich /
// Fuel Rich 双箭头，左缘 Turbulent Boundary Layer 竖排标注。
// 来源：Aerospace 2024, 11(9), 739, Fig. 2；DOI 10.3390/aerospace11090739
#canvas({
  import draw: *
  // 配色：紫(产物) 蓝(氧化剂) 亮蓝(对流) 绿(速度) 红 橙 粉 黑
  let (purple, blue, wblue, green) = (rgb("#7030a0"), rgb("#2e75b6"), rgb("#1e7fe0"), rgb("#12a05c"))
  let (red, org, pink, ink) = (rgb("#c00000"), rgb("#ef7d2f"), rgb("#ff3f87"), rgb("#111111"))  // 红 橙 粉 黑
  // 助手：Catmull-Rom 平滑，把控制点转成密集折线（所有曲线共用）
  let sm(pts, n: 12) = {
    let g(i) = pts.at(calc.clamp(i, 0, pts.len() - 1))
    let out = ()
    for i in range(pts.len() - 1) {
      let (a, b, c, d) = (g(i - 1), g(i), g(i + 1), g(i + 2))
      for k in range(n) {
        let t = k / n
        out.push((0, 1).map(j => 0.5 * (2 * b.at(j) + (c.at(j) - a.at(j)) * t
          + (2 * a.at(j) - 5 * b.at(j) + 4 * c.at(j) - d.at(j)) * t * t
          + (3 * b.at(j) - a.at(j) - 3 * c.at(j) + d.at(j)) * t * t * t)))
      }
    }
    out.push(pts.last())
    out
  }
  // 助手：竖向波浪箭头
  let wavy(x, y0, y1, amp, col, w: 3.8pt, n: 3) = {
    let d = if y1 > y0 { 1 } else { -1 }
    let pts = range(0, 49).map(k => {
      let s = k / 48
      (x + amp * calc.sin(s * 2 * calc.pi * n), y0 + (y1 - y0 - 0.34 * d) * s)
    })
    pts.push((x, y1))
    line(..pts, stroke: (paint: col, thickness: w))
    line((x - 0.21, y1 - d * 0.42), (x + 0.21, y1 - d * 0.42), (x, y1), close: true, fill: col, stroke: none)
  }
  // 助手：色块＋居中文字
  let tag(x0, y0, x1, y1, fill, txt, col, size: 8pt, weight: "bold") = {
    rect((x0, y0), (x1, y1), fill: fill, stroke: none)
    content(((x0 + x1) / 2, (y0 + y1) / 2), text(size: size, fill: col, weight: weight, txt))
  }
  // 燃料块与表面高度
  let yS = 2.70
  rect((1.80, 0.20), (14.38, yS), fill: org, stroke: none)
  // 聚合物分子链：锯齿主链＋球棍原子
  let ch = range(0, 13).map(i => (5.10 + i * 0.325, 1.06 + (if calc.odd(i) { 0.14 } else { -0.14 })))
  for i in range(12) { line(ch.at(i), ch.at(i + 1), stroke: (paint: rgb("#4a4a4a"), thickness: 0.9pt)) }
  for p in ch {
    for s in (-1, 1) {
      let h = (p.at(0) + s * 0.09, p.at(1) + s * 0.23)
      line(p, h, stroke: (paint: rgb("#6a6a6a"), thickness: 0.5pt))
      circle(h, radius: 0.045, fill: white, stroke: (paint: rgb("#9a9a9a"), thickness: 0.35pt))
    }
    circle(p, radius: 0.082, fill: rgb("#8d8d8d"), stroke: (paint: white, thickness: 0.5pt))
  }
  // 链两端 C/H 标注
  for (p, t) in (((4.98, 1.34), "H"), ((4.74, 0.98), "C"), ((4.98, 0.58), "H"),
    ((9.22, 1.34), "H"), ((9.46, 0.98), "C"), ((9.22, 0.58), "H")) {
    content(p, text(size: 8pt, fill: rgb("#3a3a3a"), t))
  }
  // 燃料块标题、热传导色块与向下红箭头
  content((7.18, 1.95), text(size: 13pt, fill: white, weight: "bold")[Polymer Fuel])
  tag(9.70, 0.98, 12.15, 2.42, rgb("#f2a6a6"), [Heat \ Conduction], rgb("#7b0000"), size: 9pt)
  line((10.72, 0.94), (11.10, 0.94), (11.10, 0.72), (11.34, 0.72), (10.91, 0.26),
    (10.48, 0.72), (10.72, 0.72), close: true, fill: red, stroke: none)
  // 边界层外缘黑曲线（左端小钩）
  line(..sm(((1.40, 7.40), (1.55, 7.85), (1.91, 8.16), (2.55, 8.62), (3.44, 9.08), (4.34, 9.44),
    (5.61, 9.95), (6.89, 10.40), (8.16, 10.81), (9.44, 11.12), (10.71, 11.35), (11.99, 11.50),
    (13.26, 11.63), (14.08, 11.68))), stroke: (paint: ink, thickness: 1.5pt))
  // 扩散火焰红带：中心线两侧等距偏移成闭合色带，左端加圆头
  let band(pts, h) = {
    let c = sm(pts, n: 14)
    // 逐点法向偏移（s = ±1 取上下缘）
    let off(p, a, b, s) = {
      let (dx, dy) = (b.at(0) - a.at(0), b.at(1) - a.at(1))
      let l = calc.sqrt(dx * dx + dy * dy)
      (p.at(0) - s * dy / l * h, p.at(1) + s * dx / l * h)
    }
    let nb(i) = (c.at(calc.max(i - 1, 0)), c.at(calc.min(i + 1, c.len() - 1)))
    let up = range(c.len()).map(i => off(c.at(i), ..nb(i), 1))
    let lo = range(c.len()).map(i => off(c.at(i), ..nb(i), -1))
    // 起点圆头
    let p0 = c.at(0)
    let (tx, ty) = (c.at(1).at(0) - p0.at(0), c.at(1).at(1) - p0.at(1))
    let m = calc.sqrt(tx * tx + ty * ty)
    let cap = range(0, 7).map(k => {
      let (cs, sn) = (calc.cos(calc.pi * k / 6), calc.sin(calc.pi * k / 6))
      (p0.at(0) - ty / m * h * cs - tx / m * h * sn, p0.at(1) + tx / m * h * cs - ty / m * h * sn)
    })
    up + lo.rev() + cap.rev()
  }
  line(..band(((4.10, 5.42), (4.52, 5.86), (5.10, 6.38), (5.74, 6.89), (6.38, 7.19), (7.14, 7.42),
    (7.91, 7.57), (8.93, 7.80), (9.95, 7.98), (10.97, 8.08), (11.99, 8.11), (13.01, 8.11),
    (14.38, 8.11)), 0.36), close: true, fill: rgb("#ee1111"), stroke: none)
  content((10.25, 8.02), text(size: 9pt, fill: white, weight: "bold")[Diffusion Flame])
  // 剖面基准轴：黑点划线（密度/温度）与绿虚线（速度）
  line((2.98, 10.40), (2.98, 0.20), stroke: (paint: ink, thickness: 0.8pt, dash: "dash-dotted"))
  line((6.45, 10.60), (6.45, yS), stroke: (paint: green, thickness: 0.9pt, dash: "dashed"))
  // 四条剖面：紫（产物）、蓝（氧化剂）、红（温度）、橙（燃料）
  let prof(pts, col, d: "dashed", w: 1.4pt) = { line(..sm(pts), stroke: (paint: col, thickness: w, dash: d)) }
  prof(((3.57, 10.71), (3.60, 10.15), (3.65, 9.38), (3.72, 8.67), (3.88, 8.11), (4.21, 7.65),
    (4.64, 7.29), (4.97, 6.96), (5.10, 6.63), (5.02, 6.27), (4.74, 5.92), (4.34, 5.51),
    (3.93, 5.00), (3.57, 4.41), (3.32, 3.77), (3.14, 3.14), (3.06, 2.75)), purple, d: none, w: 1.7pt)
  prof(((5.15, 10.61), (5.07, 10.10), (4.95, 9.38), (4.77, 8.62), (4.57, 7.85), (4.39, 7.09),
    (4.23, 6.32), (4.11, 5.56), (4.01, 4.79), (3.93, 4.03), (3.85, 3.26), (3.83, 2.75)), blue)
  prof(((2.42, 9.26), (2.47, 8.87), (2.65, 8.49), (2.96, 8.11), (3.39, 7.78), (3.95, 7.50),
    (4.59, 7.22), (5.15, 6.91), (5.56, 6.58), (5.71, 6.27), (5.66, 5.94), (5.43, 5.56),
    (5.10, 5.18), (4.72, 4.74), (4.34, 4.23), (3.98, 3.65), (3.67, 3.06), (3.52, 2.75)), red)
  prof(((3.06, 7.55), (3.11, 6.83), (3.21, 6.07), (3.36, 5.31), (3.72, 4.54), (4.11, 3.83),
    (4.49, 3.37), (4.85, 3.06), (5.30, 2.91), (5.86, 2.78), (6.32, 2.68)), org)
  // 绿色速度剖面＋自基准轴指向剖面的速度箭头
  let vel = ((6.30, 2.70), (6.35, 3.26), (6.50, 4.03), (6.71, 4.79), (6.96, 5.56), (7.27, 6.32),
    (7.57, 7.09), (7.85, 7.85), (8.08, 8.62), (8.29, 9.38), (8.47, 10.15), (8.58, 10.68), (8.64, 10.86))
  line(..sm(vel), stroke: (paint: green, thickness: 1.7pt))
  for (y, x1) in ((10.53, 8.56), (9.95, 8.42), (9.33, 8.28), (8.11, 7.93), (6.45, 7.32), (5.18, 6.81)) {
    line((6.45, y), (x1, y), stroke: (paint: green, thickness: 0.9pt), mark: (end: "stealth"))
  }
  content((7.62, 4.45), text(size: 9pt, fill: green, weight: "bold")[Velocity])
  // 对流/辐射/扩散波浪先画：随后色块盖住中段，标签才完整可读
  wavy(9.82, 8.36, 10.80, 0.16, wblue, n: 3.0); wavy(9.82, 7.30, 2.92, 0.16, wblue, n: 3.0)
  wavy(13.13, 8.34, 10.80, 0.19, pink, n: 2.5); wavy(13.13, 7.32, 2.92, 0.19, pink, n: 2.5)
  wavy(11.55, 10.88, 8.55, 0.06, ink, w: 1.1pt, n: 2.2)
  // 对流/辐射/扩散色块（火焰上下各一组）
  tag(8.85, 9.00, 10.91, 9.64, rgb("#b3d5f4"), [Convection], rgb("#17375e"), size: 9pt)
  tag(8.72, 5.43, 10.91, 6.12, rgb("#b3d5f4"), [Convection], rgb("#17375e"), size: 9pt)
  tag(12.04, 9.00, 14.03, 9.64, rgb("#f2a0a6"), [Radiation], rgb("#9c0006"), size: 9pt)
  tag(12.04, 5.43, 14.03, 6.12, rgb("#f2a0a6"), [Radiation], rgb("#9c0006"), size: 9pt)
  tag(10.07, 10.10, 12.88, 10.94, rgb("#d5d3d3"), [Convection and \ diffusion of oxidizer],
    rgb("#404040"), size: 6pt, weight: "regular")
  // 黄色燃料对流扩散：先画波浪再盖色块
  wavy(11.22, 5.50, 7.58, 0.11, rgb("#f2b705"), w: 3pt, n: 2.4)
  tag(10.46, 6.89, 12.50, 7.65, rgb("#fdf0c4"), [Convection and \ diffusion of fuel],
    rgb("#8a6a00"), size: 6pt, weight: "regular")
  // 顶部 Oxidizer Flow 粗黑箭头
  line((7.00, 11.94), (10.55, 11.94), stroke: (paint: ink, thickness: 15pt),
    mark: (end: "triangle", scale: 2.0, fill: ink))
  content((8.70, 11.94), text(size: 10pt, fill: white, weight: "bold")[Oxidizer Flow])
  // 右侧富氧/富燃区：上下两段箭头，中间留文字
  let rich(x, ytop, ybot, ytxt, txt) = {
    line((x, ytxt + 0.26), (x, ytop), stroke: (paint: ink, thickness: 0.9pt), mark: (end: "stealth"))
    line((x, ytxt - 0.26), (x, ybot), stroke: (paint: ink, thickness: 0.9pt), mark: (end: "stealth"))
    content((x, ytxt), text(size: 7pt, fill: rgb("#3a3a3a"), txt))
  }
  rich(14.18, 11.32, 8.60, 10.16, [Oxidizer \ Rich])
  rich(14.18, 8.10, 2.98, 5.05, [Fuel \ Rich])
  // 左缘边界层括线＋竖排标注
  line((1.36, 7.80), (1.18, 7.80), (1.18, 5.32), (1.33, 5.18), (1.18, 5.04), (1.18, 3.05),
    (1.36, 3.05), stroke: (paint: ink, thickness: 0.9pt))
  content((0.34, 5.20), angle: 90deg, text(size: 8.5pt, [Turbulent Boundary Layer]))
  // 四条剖面名称标注
  content((2.85, 11.52), text(size: 9pt, fill: purple, weight: "bold")[Product Material \ Density])
  content((5.42, 11.30), text(size: 9pt, fill: blue, weight: "bold")[Oxidizer \ Density])
  content((1.82, 9.78), text(size: 9pt, fill: red, weight: "bold")[Temperature])
  content((5.48, 3.72), text(size: 9pt, fill: org, weight: "bold")[Fuel \ Density])
})