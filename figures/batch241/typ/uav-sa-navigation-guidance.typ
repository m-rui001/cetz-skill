#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：UAV 态势感知与制导控制架构框图。左虚线框 Navigation：五类传感器→导航/精感模块→
// Current state 与 Vehicular State 两个蓝虚线子框→车辆状态估计器→态势感知，下方环境感知链；
// 右虚线框 Guidance & Control：控制分配/控制器/轨迹生成/事件触发四模块（上下信号箭头）＋
// 四项应对策略子框，顶部无人机图标、底部 Mission Plan 与左侧 Motion 线接入。
// 来源：Robotics 2024, 13, 117, Figure 3 "Components of SA within UAV operations"。DOI 10.3390/robotics13080117

#canvas({
  import draw: *
  let ink = black
  let red = rgb("#c0392b")
  let blue = rgb("#2f6fb0")
  let faint = rgb("#54728c")
  // 圆角盒：中心 c、半宽 w、半高 h、文字、字号、填充/文字/描边色
  let box(c, w, h, s, size: 8pt, fill: white, fg: ink, stroke: ink) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      radius: 0.09, fill: fill, stroke: 0.55pt + stroke)
    content(c, text(size: size, fill: fg)[#s], anchor: "center", frame: none)
  }
  // 虚线分组框
  let frame(a, b, col: faint) = rect(a, b,
    fill: none, stroke: (paint: col, thickness: 0.6pt, dash: "dashed"))
  // 标注文字
  let t(pos, s, size: 8pt, fill: ink, anchor: "center", angle: 0deg) = content(
    pos, angle: angle, text(size: size, fill: fill)[#s], anchor: anchor, frame: none)
  // 单向/双向箭头
  let arr(a, b) = line(a, b, stroke: 0.6pt + ink, mark: (end: "stealth", scale: 0.65))
  let darr(a, b) = line(a, b, stroke: 0.6pt + ink,
    mark: (start: "stealth", end: "stealth", scale: 0.6))

  // 两大分组虚线框与红色斜体标题
  frame((0.45, 0.65), (8.35, 7.55))
  frame((9.40, 0.65), (13.40, 6.45))
  t((4.40, 7.80), [Navigation], size: 10pt, fill: red)
  t((13.78, 3.55), [Guidance & Control], size: 10pt, fill: red, angle: 90deg)

  // 环境扰动输入与机体运动反馈两路外部连线
  t((1.35, 8.05), [Environmental \ Disturbances], size: 7.5pt)
  arr((2.62, 7.95), (2.62, 7.37))
  t((9.00, 7.05), [Motion], size: 8pt)
  arr((10.95, 6.90), (2.99, 6.90))

  // 五类机载传感器依次接入导航/精感模块
  let sensors = ("LiDAR", "GPS", "IMU", "RF-Module", "Camera")
  for (i, s) in sensors.enumerate() {
    let y = 6.90 - 0.40 * i
    box((1.36, y), 0.66, 0.16, s, size: 6.6pt)
    arr((2.02, y), (2.25, y))
  }
  // 导航/精感模块（竖排文字）
  box((2.62, 6.20), 0.36, 1.15, [], fill: white)
  t((2.62, 6.20), [Navigation Sensors \ Precision Sensors], size: 6.8pt, angle: 90deg)
  // 检测区域黑块回报至模块
  box((4.60, 5.90), 1.06, 0.78, [], fill: rgb("#111111"), stroke: rgb("#111111"))
  t((4.60, 5.90), [Front#sub[center] \ Front#sub[right] \ Front#sub[left] \ bottom#sub[center] \ back#sub[center]],
    size: 5.6pt, fill: white)
  arr((3.83, 5.90), (2.99, 5.90))

  // Current state 六项（蓝虚线子框，标题置于框内左上）
  frame((1.00, 2.20), (3.98, 4.90), col: blue)
  t((1.58, 4.66), [Current state], size: 6.8pt, fill: blue)
  let cur = ("Satellite Data", "Offline Map Data", "Probabilistic Map",
             "Onboard Sensory Data", "Dynamic/Static Obstacle", "Wind Magnitude and Direction")
  for (i, s) in cur.enumerate() {
    box((2.48, 4.30 - 0.36 * i), 1.42, 0.15, s, size: if s.len() > 24 { 5.2pt } else { 5.9pt })
  }
  // Vehicular State 五项（蓝虚线子框）
  frame((4.60, 2.40), (6.62, 4.90), col: blue)
  t((5.28, 4.66), [Vehicular State], size: 6.6pt, fill: blue)
  let veh = ("Kinematics", "Dynamics", "Internal Situation", "SMC Control", "LOS Guidance")
  for (i, s) in veh.enumerate() {
    box((5.52, 4.30 - 0.36 * i), 0.95, 0.14, s, size: 6.1pt)
  }
  // 模块底部下行并分两路注入两个状态子框
  line((2.62, 5.05), (2.62, 5.02), (6.10, 5.02), stroke: 0.6pt + ink)
  arr((2.48, 5.02), (2.48, 4.90))
  arr((6.10, 5.02), (6.10, 4.90))
  // 机体运动信号另分一路注入 Vehicular State
  arr((6.45, 6.90), (6.45, 4.90))

  // 环境感知链：Current state → 环境感知 → 环境状态估计器 → 态势感知
  box((2.30, 1.55), 1.26, 0.26, [Environment Perception], size: 6.2pt)
  box((5.45, 1.55), 1.46, 0.26, [Environmental State Estimator], size: 5.6pt)
  arr((2.48, 2.20), (2.40, 1.81))
  arr((3.60, 1.55), (3.96, 1.55))
  line((6.94, 1.55), (7.90, 1.55), (7.90, 2.50), stroke: 0.6pt + ink,
    mark: (end: "stealth", scale: 0.65))

  // 车辆状态估计器与态势感知（竖排文字）
  box((7.05, 3.55), 0.30, 1.05, [], fill: white)
  t((7.05, 3.55), [Vehicle State \ Estimator], size: 6.8pt, angle: 90deg)
  box((7.90, 3.55), 0.30, 1.05, [], fill: white)
  t((7.90, 3.55), [Situation \ Awareness], size: 6.8pt, angle: 90deg)
  arr((6.62, 3.85), (6.75, 3.85))
  arr((7.35, 3.85), (7.60, 3.85))

  // 态势感知输出经总线分配到制导控制三个入口
  line((8.20, 3.55), (9.55, 3.55), (9.55, 3.05), stroke: 0.6pt + ink)
  line((9.55, 3.05), (9.55, 4.80), stroke: 0.6pt + ink)
  for y in (4.80, 4.00, 3.05) {
    arr((9.55, y), (10.05, y))
  }
  // 制导控制四模块与上下信号箭头
  box((11.55, 5.60), 1.50, 0.25, [Control Allocation], size: 8pt)
  box((11.55, 4.80), 1.50, 0.25, [Controller], size: 8pt)
  box((11.55, 4.00), 1.50, 0.25, [Trajectory Generator], size: 8pt)
  box((11.52, 3.05), 1.55, 0.25, [Event-Trigger Mechanism], size: 7.2pt)
  arr((11.55, 5.05), (11.55, 5.35))
  arr((11.55, 4.25), (11.55, 4.55))
  darr((11.55, 3.30), (11.55, 3.75))
  // 四项应对策略子框
  frame((10.00, 0.95), (13.10, 2.62), col: blue)
  let resp = ("Coping with Adverse Wind", "Using accordant Wind flow", "Handling Internal Error")
  for (i, s) in resp.enumerate() {
    box((11.55, 2.38 - 0.32 * i), 1.52, 0.13, s, size: 6pt)
  }
  box((11.55, 1.28), 1.52, 0.30, [Collision Avoidance \ (Static-Moving Obstacles)], size: 6.4pt)

  // 无人机图标（简化线稿）：机身、双臂、四旋翼
  let drone = (11.60, 6.98)
  rect((drone.at(0) - 0.22, drone.at(1) - 0.09), (drone.at(0) + 0.22, drone.at(1) + 0.09),
    radius: 0.05, fill: rgb("#3a3a3a"), stroke: rgb("#3a3a3a"))
  for sd in (-1, 1) {
    line((drone.at(0) + 0.12 * sd, drone.at(1)), (drone.at(0) + 0.48 * sd, drone.at(1) + 0.12),
      stroke: 0.6pt + ink)
    circle((drone.at(0) + 0.48 * sd, drone.at(1) + 0.12), radius: 0.045,
      fill: white, stroke: 0.5pt + ink)
    circle((drone.at(0) + 0.60 * sd, drone.at(1) + 0.12), radius: 0.045,
      fill: white, stroke: 0.5pt + ink)
  }
  darr((11.55, 6.80), (11.55, 5.88))
  // 任务规划入口
  t((12.30, 0.40), [Mission Plan], size: 7.5pt)
  line((12.90, 0.40), (13.22, 0.40), (13.22, 3.05), (13.00, 3.05),
    stroke: 0.6pt + ink, mark: (end: "stealth", scale: 0.65))
})
