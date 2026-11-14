#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 两轮自平衡机器人俯视几何示意：x/y 坐标轴、斜置机体与两只车轮、八条虚线投影到 x_l/x_m/x_b/x_r 与 y_l/y_b/y_m/y_r、
// 中心质心四分之一填充圆、虚线旋转参考框及其右前角上的 ψ 偏航角弧、机体内 φ 摆角弧；黑白线稿。
// 来源：Robotics 2025, 14, 801, Figure 3(a). DOI: 10.3390/robotics14080101

#canvas({
  import draw: *

  // —— 几何参数 ——
  let C = (4.35, 5.15) // 机体中心
  let a = 2.00 // 机体边长
  let rB = a / calc.sqrt(2) // 机体半对角线
  let hd = 3.00 // 参考框半对角线
  let angB = 45deg // 机体姿态角 φ
  let angF = 50deg // 参考框偏航角 ψ

  // 极坐标取点助手
  let at(c, r, ang) = (c.at(0) + r * calc.cos(ang), c.at(1) + r * calc.sin(ang))
  // 矩形四角助手（中心、半长、半宽、长轴方向）
  let box4(c, hl, hw, ang) = {
    let u = (calc.cos(ang), calc.sin(ang))
    let v = (-calc.sin(ang), calc.cos(ang))
    (
      (c.at(0) + hl * u.at(0) + hw * v.at(0), c.at(1) + hl * u.at(1) + hw * v.at(1)),
      (c.at(0) + hl * u.at(0) - hw * v.at(0), c.at(1) + hl * u.at(1) - hw * v.at(1)),
      (c.at(0) - hl * u.at(0) - hw * v.at(0), c.at(1) - hl * u.at(1) - hw * v.at(1)),
      (c.at(0) - hl * u.at(0) + hw * v.at(0), c.at(1) - hl * u.at(1) + hw * v.at(1)),
    )
  }

  // —— 线型 ——
  let AX = (paint: black, thickness: 0.8pt)
  let LD = (paint: black, thickness: 0.45pt, dash: "dashed")
  let CL = (paint: black, thickness: 0.4pt, dash: "dash-dotted")
  let BD = (paint: black, thickness: 1.3pt)
  let WH = (paint: black, thickness: 1.0pt)

  // —— 地标点 ——
  let T1 = at(C, rB, 90deg) // 机体顶角
  let T2 = at(C, rB, 0deg) // 机体右角
  let T3 = at(C, rB, 270deg) // 机体底角
  let T4 = at(C, rB, 180deg) // 机体左角
  let M = ((T3.at(0) + T4.at(0)) / 2, (T3.at(1) + T4.at(1)) / 2) // 后轴中点
  let WL = at(M, 1.40, 135deg) // 左轮心
  let WR = at(M, 1.40, -45deg) // 右轮心
  let wL = box4(WL, 0.675, 0.300, -45deg)
  let wR = box4(WR, 0.675, 0.300, -45deg)
  let K1 = at(C, hd, angF) // 参考框右前角（落在原点射线上）
  let K2 = at(C, hd, angF + 90deg)
  let K3 = at(C, hd, angF + 180deg)
  let K4 = at(C, hd, angF + 270deg)

  // 八条投影虚线＋轴标签（表驱动：p 为被投影的地标点）
  let proj = (
    (p: wL.at(2), ax: "y", lab: $y_l$),
    (p: T2, ax: "y", lab: $y_b$),
    (p: M, ax: "y", lab: $y_m$),
    (p: wR.at(0), ax: "y", lab: $y_r$),
    (p: wL.at(1), ax: "x", lab: $x_l$),
    (p: M, ax: "x", lab: $x_m$),
    (p: (C.at(0), C.at(1) - 0.30), ax: "x", lab: $x_b$),
    (p: wR.at(0), ax: "x", lab: $x_r$),
  )
  for q in proj {
    if q.ax == "y" {
      line((0, q.p.at(1)), q.p, stroke: LD)
      content((-0.16, q.p.at(1)), q.lab, anchor: "east")
    } else {
      line((q.p.at(0), 0), q.p, stroke: LD)
      content((q.p.at(0), -0.18), q.lab, anchor: "north")
    }
  }

  // 虚线旋转参考框（机器人本体系）
  line(K1, K2, K3, K4, close: true, stroke: LD)
  // 机体纵轴延长线（过原点、中心、参考框前角）
  line((0, 0), K1, stroke: CL)
  // 过中心的横向中心线
  line(at(C, 1.15, 135deg), at(C, 1.15, -45deg), stroke: CL)
  // 两轮轴线中心线
  line(at(M, 1.75, 135deg), at(M, 1.75, -45deg), stroke: CL)

  // 坐标轴与箭头
  line((0, 0), (9.0, 0), stroke: AX, mark: (end: "stealth"))
  line((0, 0), (0, 8.6), stroke: AX, mark: (end: "stealth"))

  // 机体方框与左右车轮
  line(T1, T2, T3, T4, close: true, stroke: BD)
  line(..wL, close: true, stroke: WH)
  line(..wR, close: true, stroke: WH)

  // 质心标记：对角两象限填实（arc 锚点在起点，故按起点定位）
  arc(at(C, 0.30, 90deg), start: 90deg, stop: 180deg, radius: 0.30, mode: "PIE", fill: black, stroke: none)
  arc(at(C, 0.30, 270deg), start: 270deg, stop: 360deg, radius: 0.30, mode: "PIE", fill: black, stroke: none)
  circle(C, radius: 0.30, stroke: (paint: black, thickness: 0.7pt), fill: none)

  // ψ 偏航角：参考框右前角的内角弧
  arc(at(K1, 0.75, angF + 180deg), start: angF + 180deg, stop: angF + 270deg, radius: 0.75, stroke: (paint: black, thickness: 0.5pt), mark: (start: "stealth", end: "stealth", scale: 0.5))
  // φ 摆角：机体姿态与水平线之间的弧
  arc(at(C, 0.75, 3deg), start: 3deg, stop: angB, radius: 0.75, stroke: (paint: black, thickness: 0.5pt), mark: (end: "stealth", scale: 0.5))

  // 轴名与角度标注
  content((-0.16, 8.02), $y$, anchor: "east")
  content((8.66, -0.18), $x$, anchor: "north")
  content(at(K1, 1.15, angF - 82deg), $psi$, angle: angF - 90deg)
  content(at(C, 1.70, 22deg), $phi$, angle: -55deg)
})
