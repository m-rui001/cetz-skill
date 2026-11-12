#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：自主农业机械整机组成标注图。中央为四轮移动底盘＋顶部传感器与双机械臂线稿，红色圈标注后部
// 感知/定位传感器组，绿色圈标注机械臂作业端；四侧引出信息面板：Control technology（MPC/Pure pursuit/
// PID/Fuzzy/Adaptive/Backstepping/SMC/Neural network control）、Positioning technology（GNSS antenna/
// Accelerometer/Magnetometer/Gyroscope/IMU/Wheel-based odometers）、Actuator technology（Motor actuator/
// Hydraulic actuator/Mechanical arm）、Perception technology（Vision sensor/LiDAR）。原照片转干净线稿。
// 来源：Actuators 2025, 14, 464, Figure 5 "Components of an autonomous agricultural machine". DOI 10.3390/act14090464

#canvas({
  import draw: *
  let ink = black
  let red = rgb("#c0392b")
  let green = rgb("#2e8b57")
  let t(pos, s, size: 6.2pt, anchor: "center") = content(
    pos, text(size: size)[#s], anchor: anchor, frame: none)
  let tb(pos, s, size: 7.2pt) = content(pos, text(size: size, weight: "bold")[#s],
    anchor: "center", frame: none)
  let l2(a, b) = line(a, b, stroke: 0.7pt + ink)
  let l1(a, b) = line(a, b, stroke: 0.55pt + ink)
  let panel(a, b, fill) = rect(a, b, radius: 0.06, fill: fill, stroke: 0.7pt + ink)
  let carr(a, b, c) = line(a, b, stroke: 1pt + c, mark: (end: "stealth", scale: 0.55, fill: c))

  // ── 四块技术面板
  panel((0.60, 5.55), (4.80, 7.65), rgb("#fbeee6"))
  tb((2.70, 7.40), [Control technology])
  // ── 定位技术面板与图标
  panel((0.55, 0.95), (3.95, 4.30), rgb("#e8eef7"))
  tb((2.25, 4.05), [Positioning technology])
  let pos_items = ((1.25, 3.15, [GNSS antenna]), (3.05, 3.15, [Accelerometer]),
    (1.25, 2.25, [Magnetometer]), (3.05, 2.25, [Gyroscope]),
    (1.25, 1.55, [IMU]), (3.05, 1.55, [Wheel-based odometers]))
  for it in pos_items {
    let c = (it.at(0), it.at(1))
    circle(c, radius: 0.26, fill: white, stroke: 0.5pt + ink)
    t((it.at(0), it.at(1) - 0.42), it.at(2), size: 5.4pt)
  }
  // 具体小图标（简画）
  circle((1.25, 3.20), radius: 0.17, fill: rgb("#d9d9d9"), stroke: 0.5pt + ink)
  l1((1.25, 3.15), (1.25, 2.95))
  rect((2.89, 3.04), (3.21, 3.30), radius: 0.03, fill: white, stroke: 0.5pt + ink)
  l1((3.05, 3.22), (3.14, 3.10))
  rect((1.09, 2.14), (1.41, 2.38), fill: white, stroke: 0.5pt + ink)
  for k in (1.14, 1.25, 1.36) { l1((k, 2.14), (k, 2.06)) }
  circle((3.05, 2.28), radius: 0.17, fill: white, stroke: 0.5pt + ink)
  l1((2.88, 2.28), (3.22, 2.28))
  l1((3.05, 2.11), (3.05, 2.45))
  rect((1.09, 1.46), (1.41, 1.72), fill: white, stroke: 0.5pt + ink)
  for k in (1.53, 1.59, 1.65) { l1((1.13, k), (1.37, k)) }
  circle((2.94, 1.58), radius: 0.08, fill: white, stroke: 0.5pt + ink)
  circle((3.10, 1.58), radius: 0.08, fill: white, stroke: 0.5pt + ink)
  circle((3.30, 1.63), radius: 0.10, fill: white, stroke: 0.5pt + ink)

  // ── 控制方法两列
  let ctrl = (([MPC control], [Adaptive control]), ([Pure pursuit control], [Backstepping control]),
    ([PID control], [SMC control]), ([Fuzzy control], [Neural network control]))
  for (i, row) in ctrl.enumerate() {
    t((1.55, 6.98 - i * 0.37), row.at(0), size: 6.0pt)
    t((3.75, 6.98 - i * 0.37), row.at(1), size: 6.0pt)
  }

  // ── 执行器面板与图标
  panel((11.00, 5.00), (14.55, 7.55), rgb("#e9f3e4"))
  tb((12.78, 7.32), [Actuator technology])
  circle((11.90, 6.72), radius: 0.26, fill: white, stroke: 0.5pt + ink)
  rect((11.74, 6.60), (12.06, 6.82), radius: 0.04, fill: rgb("#d9d9d9"), stroke: 0.5pt + ink)
  l1((12.06, 6.71), (12.16, 6.71))
  t((11.90, 6.28), [Motor actuator], size: 5.8pt)
  circle((13.80, 6.72), radius: 0.26, fill: white, stroke: 0.5pt + ink)
  rect((13.66, 6.62), (13.90, 6.82), fill: rgb("#d9d9d9"), stroke: 0.5pt + ink)
  l1((13.55, 6.72), (13.66, 6.72))
  t((13.80, 6.28), [Hydraulic actuator], size: 5.6pt)
  circle((12.80, 5.72), radius: 0.30, fill: white, stroke: 0.5pt + ink)
  line((12.60, 5.60), (12.75, 5.85), (12.95, 5.62), (13.05, 5.80), stroke: 0.55pt + ink)
  circle((12.75, 5.85), radius: 0.03, fill: white, stroke: 0.5pt + ink)
  circle((12.95, 5.62), radius: 0.03, fill: white, stroke: 0.5pt + ink)
  t((12.80, 5.25), [Mechanical arm], size: 5.8pt)

  // ── 感知面板与图标
  panel((11.15, 2.10), (14.55, 4.20), rgb("#fdf3d0"))
  tb((12.85, 3.98), [Perception technology])
  circle((12.15, 3.25), radius: 0.28, fill: white, stroke: 0.5pt + ink)
  rect((12.00, 3.16), (12.30, 3.34), radius: 0.03, fill: rgb("#d9d9d9"), stroke: 0.5pt + ink)
  circle((12.15, 3.25), radius: 0.07, fill: white, stroke: 0.5pt + ink)
  t((12.15, 2.78), [Vision sensor], size: 5.8pt)
  circle((13.60, 3.25), radius: 0.28, fill: white, stroke: 0.5pt + ink)
  rect((13.45, 3.14), (13.75, 3.36), fill: rgb("#d0d0d0"), stroke: 0.5pt + ink)
  circle((13.60, 3.36), radius: (0.15, 0.045), fill: rgb("#c4c4c4"), stroke: 0.5pt + ink)
  t((13.60, 2.78), [LiDAR], size: 6.0pt)

  // ── 中央底盘、车轮、甲板与传感器
  rect((6.95, 2.20), (10.15, 2.72), radius: 0.08, fill: rgb("#f2f2f2"), stroke: 0.8pt + ink)
  l2((6.95, 2.48), (10.15, 2.48))
  for w in ((7.35, 1.82), (9.70, 1.82)) {
    circle(w, radius: 0.40, fill: white, stroke: 0.8pt + ink)
    circle(w, radius: 0.16, fill: rgb("#e0e0e0"), stroke: 0.6pt + ink)
    for a in (0deg, 60deg, 120deg) {
      l1((w.at(0) - 0.38 * calc.cos(a), w.at(1) - 0.38 * calc.sin(a)),
        (w.at(0) + 0.38 * calc.cos(a), w.at(1) + 0.38 * calc.sin(a)))
    }
  }
  circle((8.52, 1.74), radius: 0.28, fill: white, stroke: 0.6pt + ink)
  // 甲板传感器：GNSS 盘、相机条、LiDAR 圆柱
  circle((7.45, 3.02), radius: (0.24, 0.09), fill: rgb("#e6e6e6"), stroke: 0.6pt + ink)
  rect((8.18, 2.92), (8.62, 3.06), radius: 0.03, fill: rgb("#dcdcdc"), stroke: 0.6pt + ink)
  rect((9.10, 2.88), (9.48, 3.10), fill: rgb("#d0d0d0"), stroke: 0.6pt + ink)
  circle((9.29, 3.10), radius: (0.19, 0.06), fill: rgb("#c4c4c4"), stroke: 0.6pt + ink)
  // 双机械臂：基座、大小臂与末端夹持
  l2((9.20, 2.72), (9.20, 3.90))
  l2((9.62, 2.72), (9.62, 4.30))
  let arm(base, j1, j2, grip) = {
    l2(base, j1)
    l2(j1, j2)
    circle(j1, radius: 0.07, fill: white, stroke: 0.7pt + ink)
    l2(j2, grip)
    l1((grip.at(0) - 0.09, grip.at(1) + 0.08), (grip.at(0) + 0.09, grip.at(1) + 0.08))
  }
  arm((9.20, 3.90), (8.75, 4.75), (8.30, 4.35), (8.05, 4.18))
  arm((9.62, 4.30), (10.05, 5.05), (9.70, 5.45), (9.55, 5.62))

  // ── 红/绿标注圈与彩色引线
  circle((8.30, 2.95), radius: (1.30, 0.62), fill: none, stroke: 1pt + red)
  circle((9.40, 4.70), radius: (1.15, 1.05), fill: none, stroke: 1pt + green)
  carr((7.02, 2.72), (3.98, 2.72), red)
  carr((9.58, 2.92), (11.10, 3.15), red)
  line((10.52, 5.20), (10.95, 6.30), stroke: 1pt + green, mark: (end: "stealth", scale: 0.55, fill: green))
  line((8.30, 5.72), (4.85, 5.95), stroke: 1pt + green, mark: (end: "stealth", scale: 0.55, fill: green))
})
