#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 白底黑灰线稿：轨迹、逆运动学、SMC、机器人、积分器及多路反馈与监视器。
// 来源：Robotics 2025, 14, 14，Figure 4，Simulink trajectory model of the robot manipulator for SMC. DOI: 10.3390/robotics14020014
#canvas({
  import draw: *
  let ink = rgb("#333333")
  let wire = rgb("#777777")
  let blue = rgb("#3e8bbf")
  let orange = rgb("#df833e")
  let pen = (paint: ink, thickness: 0.8pt)
  let wp = (paint: wire, thickness: 0.7pt)
  let arrow = (end: "stealth", scale: 0.45, fill: wire)
  let label(p, s, size: 9pt, anchor: "center") = {
    content(p, text(size: size, s), anchor: anchor, frame: none)
  }
  let path(points, tip: true) = {
    if tip { line(..points, stroke: wp, mark: arrow) }
    else { line(..points, stroke: wp) }
  }
  let box(a, b) = rect(a, b, fill: white, stroke: pen)
  let dot(p) = circle(p, radius: 0.045, fill: ink, stroke: none)
  let scope(p, title, w: 1.35) = {
    box((p.at(0) - w / 2, p.at(1) - 0.34), (p.at(0) + w / 2, p.at(1) + 0.34))
    rect((p.at(0) - w / 2 + 0.17, p.at(1) - 0.18),
      (p.at(0) + w / 2 - 0.17, p.at(1) + 0.18), radius: 0.06, stroke: wp)
    label((p.at(0), p.at(1) - 0.66), title)
  }
  let sum(p) = {
    circle(p, radius: 0.29, fill: white, stroke: pen)
    label((p.at(0) - 0.13, p.at(1)), "+", size: 8pt)
    label((p.at(0) + 0.13, p.at(1)), "−", size: 8pt)
  }
  let function-mark(p) = {
    line((p.at(0) - 0.10, p.at(1) - 0.08), (p.at(0) + 0.09, p.at(1) + 0.10),
      stroke: (paint: blue, thickness: 2pt))
    line((p.at(0) + 0.09, p.at(1) + 0.10), (p.at(0) + 0.14, p.at(1) - 0.07),
      stroke: (paint: orange, thickness: 2pt))
    label((p.at(0), p.at(1) - 0.28), "fcn", size: 6pt)
  }
  let traj = (3, 6.8)
  let inv = (8, 10.75)
  let ctl = (15.5, 7)
  let plant = (21.5, 7)
  let joint-sum = (11.5, 14)
  let e-sum = (6.5, 3.6)
  let de-sum = (8.5, 1.8)

  // 先铺设积分反馈母线，块体与端口文字随后覆盖。
  path(((23, 8.5), (25, 8.5)))
  path(((26.4, 8.5), (28, 8.5)))
  path(((29.4, 8.5), (30, 8.5), (30, 14), (11.79, 14)))
  path(((30, 11.9), (13.25, 11.9), (13.25, 8.5), (14, 8.5)))
  path(((19.2, 11.9), (19.2, 8.5), (20, 8.5)))
  path(((27.1, 8.5), (27.1, 11.1), (12.65, 11.1), (12.65, 7.75), (14, 7.75)))
  path(((18.65, 11.1), (18.65, 7.75), (20, 7.75)))
  for p in ((30, 11.9), (19.2, 11.9), (27.1, 8.5), (18.65, 11.1)) { dot(p) }

  // 轨迹信号分支及逆运动学输入。
  path(((1.15, 6.8), (2, 6.8)))
  path(((4.2, 7.65), (5.2, 7.65), (5.2, 10.75), (6, 10.75)))
  path(((5.2, 10.75), (5.2, 12.65), (2.9, 12.65), (2.9, 12.05)))
  path(((5.2, 7.65), (5.2, 3.6), (6.21, 3.6)))
  path(((4.2, 6.8), (4.8, 6.8), (4.8, 1.8), (8.21, 1.8)))
  path(((4.2, 5.95), (14, 5.95)))
  path(((10, 10.75), (10.75, 10.75), (10.75, 14), (11.21, 14)))
  path(((11.5, 13.71), (11.5, 12.8), (14.1, 12.8)))
  for p in ((5.2, 7.65), (5.2, 10.75)) { dot(p) }

  // 位置误差、速度误差及控制力矩。
  path(((6.5, 3.89), (6.5, 7), (14, 7)))
  path(((8.5, 2.09), (8.5, 6.45), (14, 6.45)))
  path(((17, 7), (17.8, 7)))
  path(((18.5, 7), (20, 7)))
  path(((17.35, 7), (17.35, 4.25), (14.3, 4.25), (14.3, 3.74)))
  dot((17.35, 7))

  // 机器人末端位置与速度返回误差求和点。
  path(((23, 7.7), (23.65, 7.7), (23.65, 1.8), (8.79, 1.8)))
  path(((23, 7), (24.2, 7), (24.2, 3), (7.45, 3), (7.45, 3.6), (6.79, 3.6)))
  path(((5.2, 3.6), (5.2, 0.65), (29.2, 0.65), (29.2, 6.1), (31.7, 6.1)))
  path(((24.2, 7), (25, 7), (25, 9.7), (30.9, 9.7), (30.9, 7), (31.7, 7)))
  dot((24.2, 7))

  // 三个位置输出监视器和位置跟踪信号汇集。
  for (y, x, sy, title) in ((7, 25.35, 5.65, "out.P3"), (6.3, 25, 4.25, "out.P2"), (5.6, 24.6, 2.85, "out.P1")) {
    path(((23, y), (x, y), (x, sy), (26.2, sy)))
    box((26.2, sy - 0.34), (27.35, sy + 0.34))
    label((26.775, sy), title, size: 7pt)
  }
  path(((32.05, 6.55), (32.7, 6.55), (32.7, 3.8), (29.8, 3.8), (29.8, 2.55), (30.3, 2.55)))
  rect((31.7, 5.7), (32.05, 7.4), fill: black, stroke: none)

  // 扰动源、汇集器及进入机器人模型的扰动线路。
  path(((19.5, 3.4), (20.1, 3.4), (20.1, 3.75), (20.7, 3.75)))
  path(((19.5, 3.4), (20.7, 3.4)))
  path(((19.5, 3.4), (20.1, 3.4), (20.1, 3.05), (20.7, 3.05)))
  path(((20.92, 3.4), (21.4, 3.4), (21.4, 4.35), (19.25, 4.35), (19.25, 5.6), (20, 5.6)))
  rect((20.7, 2.85), (20.92, 3.95), fill: black, stroke: none)
  box((18.5, 3.05), (19.5, 3.8))
  for x in (18.68, 18.88, 19.08, 19.28) {
    rect((x, 3.57), (x + 0.09, 3.69), stroke: wp)
  }
  label((19, 3.3), "0 0", size: 6pt)
  label((19, 2.7), "Disturbanc")

  // 主功能块及逐字端口名称。
  box((2, 5.45), (4.2, 8.15))
  label((2.12, 6.8), "t", anchor: "west")
  for (y, s) in ((7.65, "P"), (6.8, "dP"), (5.95, "ddP")) {
    label((4.08, y), s, anchor: "east")
  }
  function-mark((2.9, 6.75))
  label((3.1, 5.05), "Trajectory")
  circle((0.95, 6.8), radius: 0.19, fill: white, stroke: wp)
  line((0.95, 6.93), (0.95, 6.8), (1.04, 6.76), stroke: wp)
  box((2.35, 11.35), (3.45, 12.05))
  label((2.9, 11.7), $"out.P"_"d"$, size: 7pt)
  box((6, 10.15), (10, 11.35))
  label((6.12, 10.75), "Position", anchor: "west")
  label((9.88, 10.75), $"Join"_"Angles"$, anchor: "east")
  function-mark((8, 10.75))
  label((8, 9.78), "Invers Kinematic")
  box((14, 5.4), (17, 9))
  for (y, s) in ((8.5, "q"), (7.75, "qp"), (7, "e"), (6.45, "de"), (5.95, $"qpp"_d$)) {
    label((14.13, y), s, anchor: "west")
  }
  label((16.85, 7), "U", anchor: "east")
  function-mark(ctl)
  label((15.5, 5.02), "SMC Controller")
  box((17.8, 6.65), (18.5, 7.35))
  line((17.94, 6.86), (18.10, 6.86), (18.10, 7.14), (18.36, 7.14), stroke: wp)
  box((20, 5.1), (23, 9))
  for (y, s) in ((8.5, "q"), (7.75, "qp"), (7, "U"), (5.6, "Disturbance")) {
    label((20.13, y), s, anchor: "west")
  }
  for (y, s) in ((8.5, "qpp"), (7.7, "dP"), (7, "P3"), (6.3, "P2"), (5.6, "P1")) {
    label((22.87, y), s, anchor: "east")
  }
  function-mark(plant)
  label((21.5, 4.72), "Plant (Robot )")

  // 积分器、误差求和节点和示波器。
  for x in (25, 28) {
    box((x, 8), (x + 1.4, 9))
    content((x + 0.7, 8.5), $1 / s$, frame: none)
  }
  for p in (joint-sum, e-sum, de-sum) { sum(p) }
  scope((14.8, 12.8), "Joint Angles Tracking Error", w: 1.4)
  scope((14.3, 3.4), "Torque")
  scope((30.95, 2.55), "Position Tracking", w: 1.3)
  label((17.2, 0.25), [$P_"d"$ = Desired Position])
  label((16.8, 3.2), [P3 = $P_Q$], size: 7pt)
  rect((25.0, 9.6), (30.9, 10.3), fill: white, stroke: none)
  label((27.9, 9.95), [P3 = $P_Q$ = End Effector Position], size: 8pt)
})
