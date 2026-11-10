#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 干净线稿平涂：电阻喷射器剖视图，含 16mm 直径标注、加热线圈、馈管与接头
// 来源：Aerospace 2024, 11(7), 502, Fig.6；DOI 10.3390/aerospace11070502
#canvas({
  import draw: *

  // 配色与线型
  let ink = rgb("#244850")
  let shell = rgb("#b7d9d7")
  let shell2 = rgb("#88b6b4")
  let cutbg = rgb("#3f6669")
  let gold = rgb("#d9b23f")
  let copper = rgb("#a86c2d")
  let pale = rgb("#e6f3f0")
  let steel = rgb("#a8bfc0")
  let white = rgb("#ffffff")
  let ln = (paint: ink, thickness: 0.7pt)
  let thick = (paint: ink, thickness: 1.0pt)

  // 斜置轴线坐标：P(轴向s, 径向r)
  let ox = 2.4
  let oy = 1.9
  let P(s, r) = (ox + s, oy + 0.28 * s + r)

  // 椭圆助手：折线近似（CeTZ 无 ellipse 原语）
  let ellipse(center, rx, ry, fill: none, stroke: none, n: 32) = {
    let (cx, cy) = center
    let pts = range(0, n).map(i => {
      let a = i / n * 2 * calc.pi
      (cx + rx * calc.cos(a), cy + ry * calc.sin(a))
    })
    draw.line(..pts, close: true, fill: fill, stroke: stroke)
  }

  // 安装支耳：上方法兰与下方吊耳（先画，机身覆盖接缝）
  let fin = (P(5.80, 0.72), P(5.90, 1.30), P(6.16, 1.30), P(6.30, 0.72))
  draw.line(..fin, close: true, fill: shell2, stroke: ln)
  let lug = (P(5.86, -0.70), P(5.98, -1.22), P(6.50, -1.22), P(6.40, -0.70))
  draw.line(..lug, close: true, fill: shell2, stroke: ln)
  draw.circle(P(6.24, -1.00), radius: 0.13, fill: white, stroke: ln)

  // 主筒体外壳
  let body = (
    P(0, 0.50), P(0.36, 0.74), P(6.12, 0.74),
    P(6.38, 0.50), P(6.38, -0.50), P(6.12, -0.74),
    P(0.36, -0.74), P(0, -0.50)
  )
  draw.line(..body, close: true, fill: shell, stroke: ln)

  // 尾端面与环形加强环
  ellipse(P(6.34, 0), 0.18, 0.62, fill: shell2, stroke: ln)
  ellipse(P(0.46, 0), 0.09, 0.62, stroke: ln)
  ellipse(P(6.04, 0), 0.09, 0.66, stroke: ln)

  // 左侧收敛-扩张喷管（喇叭口朝左）
  let nozzle = (
    P(0.34, 0.46), P(-0.42, 0.26), P(-1.30, 0.48),
    P(-1.78, 0.66), P(-1.78, -0.66), P(-1.30, -0.48),
    P(-0.42, -0.26), P(0.34, -0.46)
  )
  draw.line(..nozzle, close: true, fill: shell, stroke: ln)
  draw.line(P(-1.70, 0.52), P(-0.55, 0.20), stroke: (paint: pale, thickness: 1.0pt))
  ellipse(P(-1.74, 0), 0.09, 0.52, fill: rgb("#2b565b"), stroke: ln)
  ellipse(P(-1.74, 0), 0.04, 0.26, fill: rgb("#15383b"))

  // 剖切窗口背景
  let cut_pts = range(0, 40).map(i => {
    let a = i / 40 * 2 * calc.pi
    P(3.55 + 2.00 * calc.cos(a), -0.04 + 0.52 * calc.sin(a))
  })
  draw.line(..cut_pts, close: true, fill: cutbg)

  // 内部加热器：中心筒、端面小孔、螺旋线圈
  draw.line(
    P(1.50, -0.15), P(5.22, -0.15), P(5.22, 0.16), P(1.50, 0.16),
    close: true, fill: copper, stroke: ln
  )
  ellipse(P(1.50, 0.00), 0.09, 0.17, fill: gold, stroke: ln)
  draw.circle(P(1.64, -0.09), radius: 0.05, fill: rgb("#3a2a19"))
  draw.circle(P(1.80, -0.02), radius: 0.05, fill: rgb("#3a2a19"))
  draw.circle(P(1.64, 0.09), radius: 0.05, fill: rgb("#3a2a19"))

  // 八圈加热丝（表驱动）
  for k in range(0, 8) {
    let s = 2.02 + k * 0.40
    ellipse(P(s, 0.01), 0.12, 0.33, stroke: (paint: copper, thickness: 0.7pt))
    ellipse(P(s, 0.01), 0.09, 0.29, stroke: (paint: gold, thickness: 1.6pt))
  }
  draw.line(P(1.42, 0.02), P(5.42, 0.02), stroke: (paint: ink, thickness: 0.4pt))

  // 剖切窗口边框
  draw.line(..cut_pts, close: true, stroke: thick)

  // 后部三根平行馈管
  for pr in ((0.46, 0.08), (0.28, 0.02), (0.10, -0.03)) {
    let r = pr.at(0)
    let dr = pr.at(1)
    let p1 = P(5.36, r)
    let p2 = P(7.10, r + dr)
    draw.line(p1, p2, stroke: (paint: ink, thickness: 2.8pt))
    draw.line(p1, p2, stroke: (paint: gold, thickness: 1.3pt))
  }

  // 电缆与右上接头
  let cab = (
    P(6.06, 0.62), (8.00, 4.40), (8.35, 4.72),
    (8.85, 4.66), (9.02, 4.84)
  )
  draw.line(..cab, stroke: (paint: ink, thickness: 2.8pt))
  draw.line(..cab, stroke: (paint: shell2, thickness: 1.1pt))
  draw.rect((8.92, 4.84), (9.20, 5.24), fill: steel, stroke: ln)
  ellipse((9.06, 5.24), 0.14, 0.06, fill: shell2, stroke: ln)
  draw.line((8.92, 4.96), (9.20, 4.96), stroke: (paint: ink, thickness: 0.45pt))
  draw.line((8.92, 5.08), (9.20, 5.08), stroke: (paint: ink, thickness: 0.45pt))

  // 16mm 直径标注与两条指示箭头
  draw.content((0.70, 4.80), text(size: 7.5pt, [16mm diameter]), anchor: "west")
  draw.line((2.05, 4.62), P(3.55, 0.74), mark: (end: "stealth"), stroke: ln)
  draw.line((6.60, 1.62), P(4.80, -0.74), mark: (end: "stealth"), stroke: ln)
})
