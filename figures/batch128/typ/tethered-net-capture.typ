// 深空绳网捕获机构线稿：黄色网面 + 三只配重球 + 波浪系绳 + 发射平板 + 网中目标卫星 + 右下地球
// 依 Mechanics of Space Debris Removal: A Review, Aerospace 2025, 12, 277, Figure 21 重绘. DOI 10.3390/aerospace12040277.
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  // 深空背景（覆盖整个画幅）
  rect((0, 0), (20, 13), fill: rgb(4%, 5%, 10%), stroke: none)

  // 星场点阵
  let stars = ((0.8, 12.4), (2.1, 9.7), (0.5, 7.4), (1.5, 5.2), (3.2, 11.5), (4.6, 12.7),
    (5.6, 10.3), (3.9, 8.3), (6.5, 12.3), (7.6, 11.3), (2.6, 2.9), (5.0, 6.6), (6.9, 8.8),
    (8.1, 12.6), (10.3, 12.3), (12.6, 12.4), (15.4, 12.5), (17.3, 11.9), (18.7, 10.3),
    (16.4, 9.1), (12.1, 10.8), (10.7, 9.4), (16.9, 8.0), (7.5, 4.3), (4.0, 1.6),
    (9.9, 2.1), (11.2, 3.5), (3.3, 4.6), (18.2, 7.2), (0.9, 3.4))
  for s in stars { circle(s, radius: 0.045, fill: rgb(88%, 90%, 96%), stroke: none) }
  for s in ((15.1, 10.9), (13.2, 11.9), (9.3, 8.6), (17.8, 6.9)) { circle(s, radius: 0.055, fill: white, stroke: none) }
  for s in ((16.8, 12.1), (10.9, 5.9), (2.0, 10.6)) { circle(s, radius: 0.05, fill: rgb(92%, 78%, 62%), stroke: none) }

  // 地球：取圆在画幅内的弧段并沿画幅边缘闭合
  let ec = (18.4, -1.2)
  let er = 6.6
  let arc = ()
  for i in range(0, 25) {
    let a = (76 + (169.44 - 76) * i / 24) * calc.pi / 180
    arc.push((ec.at(0) + er * calc.cos(a), ec.at(1) + er * calc.sin(a)))
  }
  // 大气辉光、海面
  line(..arc, stroke: (paint: rgb(85%, 94%, 100%, 40%), thickness: 6pt))
  line(..arc, (20, 0), close: true, fill: rgb(52%, 72%, 89%), stroke: none)
  // 陆地色块
  for p in (((13.9, 0.9), (15.1, 0.5), (16.0, 1.2), (16.6, 2.2), (15.6, 2.6), (14.2, 2.0)),
    ((17.3, 3.1), (18.2, 2.8), (19.0, 3.4), (19.6, 4.3), (18.6, 4.6), (17.5, 4.1)),
    ((12.5, 0.15), (13.2, 0.05), (13.9, 0.35), (13.4, 0.75), (12.7, 0.6))) {
    line(..p, close: true, fill: rgb(46%, 57%, 36%), stroke: none)
  }
  // 云带
  for p in (((14.1, 1.6), (15.3, 1.9), (16.5, 1.5)), ((17.6, 3.6), (18.5, 3.2), (19.5, 3.7)),
    ((12.9, 0.5), (13.9, 0.9), (15.0, 0.6))) {
    bezier(..p, stroke: (paint: rgb(100%, 100%, 100%, 70%), thickness: 1.1pt))
  }

  // 网发射平板（白色楔形板，带圆形徽标）
  line((0.35, 1.05), (2.30, 0.55), (3.10, 2.30), (1.15, 2.80), close: true,
    fill: rgb(96%, 96%, 94%), stroke: (paint: rgb(25%, 25%, 28%), thickness: 1.0pt))
  line((0.35, 1.05), (0.62, 1.55), (1.42, 3.30), (1.15, 2.80), close: true,
    fill: rgb(78%, 78%, 76%), stroke: (paint: rgb(25%, 25%, 28%), thickness: 0.6pt))
  circle((1.72, 1.68), radius: 0.50, fill: white, stroke: (paint: rgb(20%, 20%, 22%), thickness: 0.8pt))
  circle((1.72, 1.68), radius: 0.36, stroke: (paint: rgb(20%, 20%, 22%), thickness: 0.4pt))
  for dy in (-0.14, 0, 0.14) {
    line((1.44, 1.68 + dy), (2.00, 1.68 + dy), stroke: (paint: rgb(20%, 20%, 22%), thickness: 0.4pt))
  }

  // 网几何地标：四角双线性插值
  let netcol = rgb(85%, 88%, 20%)
  let A = (9.20, 10.40)
  let B = (14.60, 8.00)
  let C = (13.80, 3.40)
  let D = (8.60, 5.50)
  let npt(u, v) = (
    (1 - u) * (1 - v) * A.at(0) + u * (1 - v) * B.at(0) + u * v * C.at(0) + (1 - u) * v * D.at(0),
    (1 - u) * (1 - v) * A.at(1) + u * (1 - v) * B.at(1) + u * v * C.at(1) + (1 - u) * v * D.at(1),
  )

  // 松弛波浪系绳：自发射板顶角连到网角 D
  let rope(p0, p1, sag, amp) = {
    let pts = ()
    for i in range(0, 25) {
      let t = i / 24
      let x = p0.at(0) + (p1.at(0) - p0.at(0)) * t
      let y = p0.at(1) + (p1.at(1) - p0.at(1)) * t - sag * 4 * t * (1 - t) + amp * calc.sin(t * 34)
      pts.push((x, y))
    }
    pts
  }
  line(..rope((2.85, 2.15), D, 1.05, 0.10), stroke: (paint: netcol, thickness: 1.3pt))

  // 被网包裹的目标卫星（局部坐标旋转置入）
  let sc = (11.80, 7.30)
  let sa = 25 * calc.pi / 180
  let sp(u, v) = (
    sc.at(0) + u * calc.cos(sa) - v * calc.sin(sa),
    sc.at(1) + u * calc.sin(sa) + v * calc.cos(sa),
  )
  // 两侧太阳翼与分格线
  for k in (-1, 1) {
    line(sp(k * 0.85, -0.52), sp(k * 2.55, -0.52), sp(k * 2.55, 0.52), sp(k * 0.85, 0.52), close: true,
      fill: rgb(38%, 62%, 88%), stroke: (paint: rgb(18%, 22%, 30%), thickness: 0.8pt))
    for j in (1, 2, 3, 4) {
      let u = k * (0.85 + 0.34 * j)
      line(sp(u, -0.52), sp(u, 0.52), stroke: (paint: rgb(88%, 94%, 100%, 70%), thickness: 0.4pt))
    }
  }
  // 星体、仪器与支架
  line(sp(-0.85, -0.60), sp(0.85, -0.60), sp(0.85, 0.60), sp(-0.85, 0.60), close: true,
    fill: rgb(94%, 93%, 88%), stroke: (paint: rgb(12%, 12%, 15%), thickness: 1.0pt))
  line(sp(-0.68, -0.40), sp(0.10, -0.40), sp(0.10, 0.02), sp(-0.68, 0.02), close: true,
    fill: rgb(72%, 72%, 70%), stroke: (paint: rgb(12%, 12%, 15%), thickness: 0.5pt))
  line(sp(-0.42, 0.14), sp(0.72, 0.14), sp(0.72, 0.48), sp(-0.42, 0.48), close: true,
    fill: rgb(14%, 14%, 16%), stroke: none)
  for dx in (-0.20, 0.10, 0.40) {
    line(sp(dx, 0.16), sp(dx, 0.46), stroke: (paint: rgb(70%, 70%, 72%), thickness: 0.35pt))
  }
  line(sp(0.35, -0.60), sp(0.62, -1.10), stroke: (paint: rgb(12%, 12%, 15%), thickness: 0.8pt))
  circle(sp(0.62, -1.14), radius: 0.08, fill: rgb(90%, 90%, 90%), stroke: (paint: rgb(12%, 12%, 15%), thickness: 0.4pt))

  // 网面网格（纵线＋横线）覆盖卫星，表现包裹
  for i in range(0, 9) {
    line(npt(i / 8, 0), npt(i / 8, 1), stroke: (paint: netcol, thickness: 1.0pt))
  }
  for j in range(0, 8) {
    line(npt(0, j / 7), npt(1, j / 7), stroke: (paint: netcol, thickness: 1.0pt))
  }
  line(A, B, C, D, close: true, stroke: (paint: netcol, thickness: 1.6pt))
  // 网角收拢褶皱
  for k in range(0, 4) {
    let dv = 0.10 + 0.14 * k
    bezier(npt(0.02, dv), npt(0.20, dv + 0.10), npt(0.10, dv + 0.28), npt(0.02, dv + 0.22),
      stroke: (paint: netcol, thickness: 0.9pt))
  }

  // 三只网角配重球（第四角为系绳收拢端）
  for (c, m) in (((9.20, 10.40), (9.05, 10.80)), ((14.60, 8.00), (15.05, 8.32)), ((13.80, 3.40), (14.28, 3.20))) {
    line(c, m, stroke: (paint: netcol, thickness: 1.3pt))
    circle(m, radius: 0.21, fill: rgb(52%, 52%, 55%), stroke: (paint: rgb(18%, 18%, 20%), thickness: 0.8pt))
    circle((m.at(0) - 0.06, m.at(1) + 0.07), radius: 0.07, fill: rgb(85%, 85%, 88%), stroke: none)
  }
})
