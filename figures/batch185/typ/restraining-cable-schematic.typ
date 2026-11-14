#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 平涂线稿重绘：拉线驱动连续体机器人弯曲/绳长示意 (a)、平台受力 (b)、实验装置 (c)、拉线布置 CAD (d)
// 来源：Actuators 2024, 13(2), 52, Fig.13（DOI 10.3390/act13020052）
#canvas({
  import draw: *

  let red = rgb("#e8231a")
  let blu = rgb("#1a6fd4")
  let gry = rgb("#8d9096")
  let lgry = rgb("#e8eaed")
  let mgry = rgb("#b9bcc2")
  let brn = rgb("#9a7b3a")

  // 地面：实线 + 斜线阴影
  let ground(x0, x1, y) = {
    line((x0, y), (x1, y), stroke: 1.5pt)
    for i in range(0, 14) {
      let x = x0 + (i + 0.4) * (x1 - x0) / 14
      line((x, y), (x - 0.2, y - 0.32), stroke: 0.6pt)
    }
  }

  // 透视椭圆折线（(d) 盘面）
  let oval(cx, cy, rx, ry, stroke: black, fill: none, n: 44) = {
    let pts = ()
    for i in range(n + 1) {
      let a = 2 * calc.pi * i / n
      pts.push((cx + rx * calc.cos(a), cy + ry * calc.sin(a)))
    }
    line(..pts, stroke: stroke, fill: fill)
  }

  // (a) 直杆与弯曲杆
  ground(0.6, 3.6, 6.6)
  ground(4.3, 7.1, 6.6)

  // 左：直立杆，上下两段等长 d
  line((2.0, 6.6), (2.0, 10.85), stroke: 3.2pt)
  for y in (10.85, 8.75) {
    line((0.9, y), (3.1, y), stroke: (paint: black, thickness: 2.4pt, cap: "round"))
  }
  line((1.55, 6.6), (1.55, 8.75), stroke: (paint: red, thickness: 1pt))
  line((1.55, 8.75), (1.55, 10.85), stroke: (paint: red, thickness: 1pt))
  content((2.35, 7.7), [d])
  content((2.35, 9.8), [d])

  // 右：三次贝塞尔曲杆，返回采样点与切向
  let bez(t) = {
    let u = 1 - t
    let (a, b, c, d) = ((4.65, 6.6), (4.6, 8.2), (5.1, 9.7), (6.0, 11.1))
    let px = u*u*u*a.at(0) + 3*u*u*t*b.at(0) + 3*u*t*t*c.at(0) + t*t*t*d.at(0)
    let py = u*u*u*a.at(1) + 3*u*u*t*b.at(1) + 3*u*t*t*c.at(1) + t*t*t*d.at(1)
    let dx = 3*u*u*(b.at(0)-a.at(0)) + 6*u*t*(c.at(0)-b.at(0)) + 3*t*t*(d.at(0)-c.at(0))
    let dy = 3*u*u*(b.at(1)-a.at(1)) + 6*u*t*(c.at(1)-b.at(1)) + 3*t*t*(d.at(1)-c.at(1))
    (p: (px, py), d: (dx, dy))
  }
  // 法向偏移点：s > 0 取凸侧（左），s < 0 取凹侧（右）
  let off(t, s) = {
    let b = bez(t)
    let l = calc.sqrt(b.d.at(0) * b.d.at(0) + b.d.at(1) * b.d.at(1))
    (b.p.at(0) - b.d.at(1) / l * s, b.p.at(1) + b.d.at(0) / l * s)
  }
  let steps = 26
  let cpts = ()
  for i in range(steps + 1) { cpts.push(bez(i / steps).p) }
  line(..cpts, stroke: 3.2pt)

  // 沿法向放置的横梁
  let bar(p, d, half: 1.1) = {
    let l = calc.sqrt(d.at(0)*d.at(0) + d.at(1)*d.at(1))
    let nx = -d.at(1) / l
    let ny = d.at(0) / l
    line((p.at(0) - nx*half, p.at(1) - ny*half), (p.at(0) + nx*half, p.at(1) + ny*half),
      stroke: (paint: black, thickness: 2.4pt, cap: "round"))
  }
  let pm = bez(0.45)
  bar(pm.p, pm.d)
  let pt = bez(1.0)
  bar(pt.p, pt.d)

  // 凸侧绳长虚线（贴杆偏移），段长 d + α / d − α 标注于左侧空白
  let dsh = ()
  for i in range(0, 21) { dsh.push(off(i / 20, 0.2)) }
  line(..dsh, stroke: (paint: red, thickness: 0.95pt, dash: "dashed"))
  content((4.55, 10.25), $d + alpha$)
  content((4.0, 7.55), $d - alpha$)
  content((3.55, 6.05), text(font: "Times New Roman", size: 12pt)[(a)])

  // (b) 平台受力
  rect((9.55, 6.7), (18.05, 11.6), fill: rgb("#f4f5f8"), stroke: none)
  // 两块竖直平台板（圆角 + 侧缘薄盘）
  let plate(x) = {
    rect((x, 7.15), (x + 0.85, 11.15), fill: lgry, stroke: (paint: gry, thickness: 0.8pt), radius: 0.1)
    for dx in (0.13, 0.72) {
      line((x + dx, 7.4), (x + dx, 10.9), stroke: (paint: mgry, thickness: 2pt))
    }
  }
  plate(10.2)
  plate(13.4)
  // 中间刚性连杆与两端轮毂
  line((10.9, 8.95), (13.6, 8.95), stroke: (paint: rgb("#9a9ea5"), thickness: 6pt))
  for x in (10.78, 13.52) {
    rect((x - 0.22, 8.68), (x + 0.22, 9.22), fill: rgb("#cdd0d5"), stroke: (paint: gry, thickness: 0.7pt), radius: 0.05)
  }
  // 斜拉索与四向力箭头
  let A = (10.95, 10.55)
  let B = (13.65, 8.55)
  line(A, B, stroke: (paint: brn, thickness: 1.6pt))
  line(A, (12.35, 10.55), stroke: (paint: red, thickness: 1.8pt), mark: (end: "stealth"))
  line(A, (10.95, 9.2), stroke: (paint: red, thickness: 1.8pt), mark: (end: "stealth"))
  line(B, (13.65, 9.5), stroke: (paint: red, thickness: 1.8pt), mark: (end: "stealth"))
  line(B, (12.35, 8.55), stroke: (paint: red, thickness: 1.8pt), mark: (end: "stealth"))
  content((11.62, 10.95), text(fill: red, weight: "bold", size: 11pt)[$F_2'$])
  content((11.05, 9.75), text(fill: red, weight: "bold", size: 11pt)[$F_1'$])
  content((13.98, 9.1), text(fill: red, weight: "bold", size: 11pt)[$F_1$])
  content((12.95, 8.12), text(fill: red, weight: "bold", size: 11pt)[$F_2$])
  content((10.62, 6.92), text(fill: blu, weight: "bold", size: 10pt)[Platform 1])
  content((14.05, 11.45), text(fill: blu, weight: "bold", size: 10pt)[Platform 2])
  content((12.4, 6.35), text(font: "Times New Roman", size: 12pt)[(b)])

  // (c) 实验装置线稿
  // 辐条轮盘
  let disc(cx, cy, r, spokes: 6) = {
    circle((cx, cy), radius: r, stroke: (paint: black, thickness: 1.4pt), fill: white)
    for k in range(spokes) {
      let a = 2 * calc.pi * k / spokes + 0.25
      line((cx + 0.18*r*calc.cos(a), cy + 0.18*r*calc.sin(a)),
           (cx + 0.95*r*calc.cos(a), cy + 0.95*r*calc.sin(a)), stroke: 1.1pt)
    }
    circle((cx, cy), radius: 0.95 * r, stroke: (paint: black, thickness: 1.4pt), fill: none)
    circle((cx, cy), radius: 0.16 * r, fill: rgb("#4a4f55"), stroke: none)
  }
  line((0.3, 0.6), (7.3, 0.6), stroke: 1.2pt)
  rect((0.2, 1.1), (1.55, 4.5), fill: rgb("#f1f2f4"), stroke: (paint: mgry, thickness: 0.7pt), radius: 0.08)
  rect((6.15, 1.0), (7.05, 4.6), fill: rgb("#dfe2e6"), stroke: (paint: gry, thickness: 0.7pt))
  rect((2.05, 2.62), (5.35, 3.02), fill: rgb("#2f3338"), stroke: (paint: rgb("#1b1f22"), thickness: 0.6pt))
  disc(2.05, 2.82, 0.8)
  disc(5.35, 2.82, 1.0, spokes: 8)
  line((5.35, 2.82), (6.15, 2.82), stroke: (paint: rgb("#8f949a"), thickness: 6pt))
  for k in range(3) {
    let t = k / 2
    line((1.85 + 0.45*t, 3.55), (4.95 + 1.05*t, 3.6 - 0.3*t), stroke: (paint: rgb("#b0b4b9"), thickness: 0.45pt))
  }
  content((3.7, 0.22), text(font: "Times New Roman", size: 12pt)[(c)])

  // (d) 拉线布置
  // 左：三层透视盘 + 交叉拉线
  let ys = (4.45, 3.15, 1.85)
  for y in ys {
    oval(10.9, y, 1.05, 0.3, stroke: (paint: gry, thickness: 0.8pt), fill: rgb("#eef0f2"))
    oval(10.9, y, 0.88, 0.24, stroke: (paint: mgry, thickness: 0.5pt))
    for k in range(8) {
      let a = 2 * calc.pi * k / 8
      circle((10.9 + 0.72 * calc.cos(a), y + 0.2 * calc.sin(a)), radius: 0.035, fill: gry, stroke: none)
    }
  }
  for i in range(2) {
    for o in (-0.78, -0.4, 0.4, 0.78) {
      line((10.9 + o, ys.at(i)), (10.9 - o, ys.at(i + 1)), stroke: (paint: brn, thickness: 0.7pt))
    }
  }
  // 右：底座 + 弯管 + 大圆盘 + 四根拉线
  oval(14.5, 1.3, 1.0, 0.26, stroke: (paint: gry, thickness: 0.8pt), fill: rgb("#e9ebee"))
  oval(14.5, 1.3, 0.42, 0.11, stroke: (paint: mgry, thickness: 0.6pt), fill: rgb("#d6d9dd"))
  let dc = (15.4, 3.8)
  circle(dc, radius: 0.88, stroke: (paint: gry, thickness: 0.9pt), fill: rgb("#eceef0"))
  for k in range(12) {
    let a = 2 * calc.pi * k / 12
    circle((dc.at(0) + 0.64 * calc.cos(a), dc.at(1) + 0.64 * calc.sin(a)), radius: 0.05,
      fill: rgb("#c2c6cb"), stroke: (paint: mgry, thickness: 0.4pt))
  }
  circle(dc, radius: 0.3, stroke: (paint: mgry, thickness: 0.6pt), fill: white)
  // 四根张紧拉线：底座 → 盘下缘穿孔（表驱动）
  let cables = ((-0.62, 200), (-0.22, 225), (0.2, 250), (0.6, 275))
  for (o, ang) in cables {
    let a = ang * calc.pi / 180
    line((14.5 + o, 1.45), (dc.at(0) + 0.64 * calc.cos(a), dc.at(1) + 0.64 * calc.sin(a)),
      stroke: (paint: brn, thickness: 0.7pt))
  }
  // 弯管：折线采样，穿过盘心
  let tube = ((14.5, 1.35), (14.32, 1.9), (14.35, 2.5), (14.62, 3.1), (15.05, 3.6), dc)
  line(..tube, stroke: (paint: rgb("#4a4f55"), thickness: 5.5pt, cap: "round"))
  circle(dc, radius: 0.13, fill: rgb("#2f3338"), stroke: none)
  content((13.6, 0.22), text(font: "Times New Roman", size: 12pt)[(d)])
})
