#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 来源：Actuators 2024, 13(2), 52, Fig.17 —— Cosserat 杆段自由体受力图（DOI 10.3390/act13020052）
// 编译外观：浅灰切面楔形 + 粗黑骨干弧，左侧分布力箭头列，
// 两端内力 n 与弯矩 m 弧箭头，标注 n(s)/m(s)/n(c)/m(c)/f(σ)/l(σ)/σ/c/s
#canvas({
  import draw: *

  // 骨干三次贝塞尔控制点（自下端 c 到上端 s，向左凸）
  let P = ((2.15, 0.55), (1.35, 1.95), (2.10, 3.75), (4.25, 4.30))

  // 贝塞尔取点
  let bez(t) = {
    let u = 1 - t
    let w = (u*u*u, 3*u*u*t, 3*u*t*t, t*t*t)
    let x = w.at(0)*P.at(0).at(0) + w.at(1)*P.at(1).at(0) + w.at(2)*P.at(2).at(0) + w.at(3)*P.at(3).at(0)
    let y = w.at(0)*P.at(0).at(1) + w.at(1)*P.at(1).at(1) + w.at(2)*P.at(2).at(1) + w.at(3)*P.at(3).at(1)
    (x, y)
  }

  // 贝塞尔切向
  let tng(t) = {
    let u = 1 - t
    let c = (-3*u*u, 3*u*u - 6*u*t, 6*u*t - 3*t*t, 3*t*t)
    let x = c.at(0)*P.at(0).at(0) + c.at(1)*P.at(1).at(0) + c.at(2)*P.at(2).at(0) + c.at(3)*P.at(3).at(0)
    let y = c.at(0)*P.at(0).at(1) + c.at(1)*P.at(1).at(1) + c.at(2)*P.at(2).at(1) + c.at(3)*P.at(3).at(1)
    (x, y)
  }

  // 单位外法线（指向左外侧）
  let nrm(t) = {
    let d = tng(t)
    let l = calc.sqrt(d.at(0)*d.at(0) + d.at(1)*d.at(1))
    (-d.at(1)/l, d.at(0)/l)
  }

  // 沿法线偏移取点
  let off(t, k) = {
    let p = bez(t)
    let n = nrm(t)
    (p.at(0) + k*n.at(0), p.at(1) + k*n.at(1))
  }

  // 圆弧采样（用于弯矩弧箭头）
  let arcpts(c, r, a0, a1, n) = range(n + 1).map(i => {
    let a = (a0 + (a1 - a0)*i/n) * 1deg
    (c.at(0) + r*calc.cos(a), c.at(1) + r*calc.sin(a))
  })

  // 骨干采样点
  let B = range(25).map(i => bez(i/24))

  // 浅灰切面楔形：自骨干底端沿骨干至上端，再向右下闭合
  draw.line(..B, (4.80, 4.45), (4.62, -0.35), close: true,
    fill: rgb(90%, 90%, 90%), stroke: none)

  // 楔形右侧虚线边界（自骨干顶端向下）
  draw.line((4.30, 4.15), (4.50, 2.20), (4.56, 0.05),
    stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))

  // 分布力的外参考弧（细线）
  draw.line(..range(25).map(i => off(i/24*0.94, 0.95)),
    stroke: (paint: black, thickness: 0.5pt))

  // 分布力 f(σ) 箭头列：由外弧指向骨干
  for t in (0.06, 0.19, 0.32, 0.45, 0.58, 0.70, 0.82) {
    draw.line(off(t, 0.95), off(t, 0.11),
      stroke: (paint: black, thickness: 0.7pt),
      mark: (end: "stealth", fill: black, scale: 0.75))
  }

  // 粗黑骨干
  draw.line(..B, stroke: (paint: black, thickness: 2.2pt))

  // s 端内力 n(s)：沿切向指向右上
  draw.line((4.25, 4.30), (5.17, 4.54),
    stroke: (paint: black, thickness: 0.9pt),
    mark: (end: "stealth", fill: black))

  // s 端弯矩 m(s)：顶端小弧箭头，尖端朝右下
  draw.line(..arcpts((4.02, 4.02), 0.42, 170, 5, 12),
    stroke: (paint: black, thickness: 0.8pt),
    mark: (end: "stealth", fill: black, scale: 0.75))

  // c 端内力 n(c)：向下
  draw.line((2.15, 0.55), (1.95, -0.55),
    stroke: (paint: black, thickness: 0.9pt),
    mark: (end: "stealth", fill: black))

  // c 端弯矩 m(c)：底端小弧箭头，尖端朝右上
  draw.line(..arcpts((2.05, 0.62), 0.40, 200, 340, 12),
    stroke: (paint: black, thickness: 0.8pt),
    mark: (end: "stealth", fill: black, scale: 0.75))

  // 逐字符号标注
  content((5.30, 4.90), $bold(n)(s)$)
  content((5.02, 3.55), $bold(m)(s)$)
  content((1.90, -1.00), $bold(n)(c)$)
  content((2.78, 0.86), $bold(m)(c)$)
  content((1.50, 3.85), $l(σ)$)
  content((0.28, 1.85), $f(σ)$)
  content((3.55, 4.42), $s$)
  content((1.42, 0.30), $c$)
  content((2.42, 1.72), $σ$)
})
