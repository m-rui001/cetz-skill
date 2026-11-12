#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：基于观测的自适应鲁棒力控双层框架图。High Level 红虚线框内为自适应鲁棒力控律（式 16）、
// 扩展状态观测器（式 10）、参数自适应（式 7）与动态虚拟交互模型（式 3），底部为 F_d 求和点、
// F/T 传感器与环境力回路；Low Level 蓝虚线框内为逆运动学→运动控制器→机器人动力学→正运动学，
// 含 θ_c 求和点与 θ_m 反馈。信号 x̂_2、u、θ、θ̂、X_c、τ、θ_m、X_m、F_d、F_e 逐字标注。
// 来源：Actuators 2025, 14, 116, Figure 1 "Overall framework of the observation-based adaptive robust interaction control"。DOI 10.3390/act14010016

#canvas({
  import draw: *
  let ink = black
  let red = rgb("#d0342c")
  let blue = rgb("#1f6fb0")
  let green = rgb("#b7d7a8")
  let yellow = rgb("#f6d98a")
  let navyblue = rgb("#bcd4ea")
  let peach = rgb("#f4c7a1")
  let pink = rgb("#e8a0b4")
  // 盒：中心、半宽、半高、文字、字号、填充、描边
  let box(c, w, h, s, size: 6.4pt, fill: white, stroke: ink) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      radius: 0.04, fill: fill, stroke: 0.7pt + stroke)
    content(c, text(size: size)[#s], anchor: "center", frame: none)
  }
  let t(pos, s, size: 6.6pt, anchor: "center", fill: ink) = content(
    pos, text(size: size, fill: fill)[#s], anchor: anchor, frame: none)
  let arr(a, b) = line(a, b, stroke: 0.7pt + ink, mark: (end: "stealth", scale: 0.6))
  let line2(a, b) = line(a, b, stroke: 0.7pt + ink)
  let poly(..pts) = line(..pts, stroke: 0.7pt + ink, mark: (end: "stealth", scale: 0.6))

  // 两大层级虚线框
  rect((0.35, 0.75), (8.35, 7.95), fill: none, stroke: (paint: red, thickness: 1pt, dash: "dashed"))
  rect((8.75, 3.55), (13.05, 7.95), fill: none, stroke: (paint: blue, thickness: 1pt, dash: "dashed"))
  t((4.35, 8.12), [High Level], size: 8pt, fill: red)
  t((10.90, 8.12), [Low Level], size: 8pt, fill: blue)

  // High Level：三个核心模块与交互模型
  box((1.45, 4.45), 0.80, 1.45, [Adaptive \ Robust \ Force \ Control Law \ Eqn. (16)], size: 6.6pt, fill: yellow)
  box((4.55, 6.15), 0.92, 0.42, [Extended State \ Observer Eqn. (10)], size: 6.2pt, fill: green)
  box((4.55, 3.75), 0.92, 0.42, [Parameter \ Adaptation Eqn. (7)], size: 6.2pt, fill: green)
  box((5.30, 1.78), 2.15, 0.30, [Dynamic Virtual Interaction Model Eqn. (3)], size: 5.4pt, fill: navyblue)
  // 观测器与力控律、参数自适应之间的信号
  poly((2.27, 5.60), (2.95, 5.60), (2.95, 6.05), (3.61, 6.05))
  t((3.14, 5.86), [u], size: 6.4pt)
  arr((3.61, 6.38), (2.29, 6.38))
  t((2.95, 6.54), [$hat(x)_2$], size: 6.6pt)
  arr((4.55, 4.19), (4.55, 5.92))
  t((4.82, 5.05), [$hat(theta)$], size: 6.6pt)
  poly((2.95, 5.60), (2.95, 3.75), (3.61, 3.75))
  t((3.14, 4.02), [u], size: 6.4pt)
  arr((2.29, 4.30), (3.61, 4.30))
  t((2.95, 4.46), [θ], size: 6.6pt)

  // 底部力回路：F_d / F_e 求和 → 力控律；环境 → F/T → 求和点
  let J = (1.30, 1.15)
  circle(J, radius: 0.075, fill: white, stroke: 0.7pt + ink)
  t((1.06, 1.36), [−], size: 8pt)
  t((1.54, 0.98), [+], size: 8pt)
  t((0.38, 1.15), [$F_d$], size: 6.8pt, anchor: "west")
  arr((0.72, 1.15), (1.22, 1.15))
  box((3.95, 1.15), 0.58, 0.26, [F/T Sensor], size: 6.2pt, fill: peach)
  box((6.95, 1.15), 0.68, 0.28, [Environment], size: 6.4pt, fill: navyblue)
  arr((6.61, 1.15), (4.55, 1.15))
  arr((3.37, 1.15), (1.40, 1.15))
  t((2.42, 1.33), [$F_e$], size: 6.8pt)
  poly((1.30, 1.23), (1.30, 2.98))
  // 交互模型向环境施力，并向低层输出 X_c
  arr((7.20, 1.62), (7.20, 1.31))
  poly((7.00, 1.78), (7.00, 7.55), (9.85, 7.55), (9.85, 7.25))
  t((9.30, 7.70), [$X_c$], size: 7pt, anchor: "west")

  // Low Level：逆运动学 → 运动控制器 → 机器人动力学 → 正运动学
  rect((8.95, 3.72), (12.85, 7.60), radius: 0.20, fill: rgb("#eef5ea"), stroke: 0.7pt + rgb("#8fbf88"))
  box((10.90, 6.95), 1.00, 0.26, [Inverse Kinematics], size: 6.4pt, fill: pink)
  box((10.90, 5.85), 1.00, 0.26, [Motion Controller], size: 6.4pt, fill: pink)
  box((10.90, 4.85), 1.00, 0.26, [Robot Dynamics], size: 6.4pt, fill: pink)
  box((10.90, 4.05), 1.00, 0.26, [Forward Kinematics], size: 6.4pt, fill: pink)
  // θ_c 求和点与 θ_m 反馈
  circle((10.90, 6.42), radius: 0.07, fill: white, stroke: 0.7pt + ink)
  t((10.72, 6.58), [+], size: 8pt)
  t((10.55, 6.42), [−], size: 8pt)
  arr((10.90, 6.69), (10.90, 6.51))
  t((11.16, 6.42), [$theta_c$], size: 6.4pt, anchor: "west")
  arr((10.90, 6.33), (10.90, 6.13))
  t((11.06, 5.38), [τ], size: 6.6pt, anchor: "west")
  arr((10.90, 5.59), (10.90, 5.13))
  t((11.06, 4.44), [$theta_m$], size: 6.2pt, anchor: "west")
  arr((10.90, 4.59), (10.90, 4.33))
  poly((10.90, 4.45), (9.65, 4.45), (9.65, 6.42), (10.82, 6.42))
  // X_m 送回交互模型
  poly((10.90, 3.79), (10.90, 2.06), (7.37, 2.06), (7.37, 1.94))
  t((10.52, 2.20), [$X_m$], size: 6.8pt, anchor: "west")
})
