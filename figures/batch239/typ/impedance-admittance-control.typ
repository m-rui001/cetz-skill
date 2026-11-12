#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：上肢康复机器人阻抗/导纳控制结构对照图。(a) 期望轨迹→求和→阻抗控制（含 τ_ext 公式）→
// 人机交互框（人形＋外骨骼虚线连杆）→P_act 反馈；外部人力经 τ_ext 注入。(b) 导纳控制（含 ė 公式）
// 输出经位置/速度环与人机交互框相连，Ẋ_act 回注位置环、P_act 回注左端求和点。
// 来源：Robotics 2024, 13, 181, Figure 4 "General impedance and admittance control structures for upper-limb robotic rehabilitation"。DOI 10.3390/robotics13120181

#canvas({
  import draw: *
  let ink = black
  let navy = rgb("#1f4e79")
  let orange = rgb("#d9822b")
  let green = rgb("#2e9e4f")
  // 盒：中心、半宽、半高、文字、字号、描边
  let box(c, w, h, s, size: 6.8pt, stroke: navy) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      radius: 0.12, fill: white, stroke: 0.9pt + stroke)
    content(c, text(size: size)[#s], anchor: "center", frame: none)
  }
  let t(pos, s, size: 6.8pt, anchor: "center") = content(
    pos, text(size: size)[#s], anchor: anchor, frame: none)
  let arr(a, b) = line(a, b, stroke: 0.7pt + ink, mark: (end: "stealth", scale: 0.7))
  let line2(a, b) = line(a, b, stroke: 0.7pt + ink)
  let poly(..pts) = line(..pts, stroke: 0.7pt + ink, mark: (end: "stealth", scale: 0.7))
  let junction(c) = circle(c, radius: 0.085, fill: white, stroke: 0.7pt + ink)
  // 人形＋外骨骼虚线关节
  let human(cx, cy) = {
    circle((cx, cy + 0.13), radius: 0.055, fill: white, stroke: 0.7pt + ink)
    line2((cx, cy + 0.075), (cx, cy - 0.10))
    line2((cx - 0.11, cy + 0.02), (cx + 0.11, cy + 0.02))
    line2((cx, cy - 0.10), (cx - 0.09, cy - 0.24))
    line2((cx, cy - 0.10), (cx + 0.09, cy - 0.24))
    for p in ((cx - 0.17, cy + 0.05), (cx + 0.17, cy + 0.05), (cx + 0.15, cy - 0.18)) {
      circle(p, radius: 0.035, fill: none, stroke: (paint: green, thickness: 0.6pt, dash: "dashed"))
    }
  }

  // 上下两个浅灰圆角面板
  rect((0.40, 4.60), (16.95, 8.45), radius: 0.25, fill: rgb("#f4f4f4"), stroke: 0.6pt + rgb("#9a9a9a"))
  rect((0.40, 0.55), (16.95, 4.30), radius: 0.25, fill: rgb("#f4f4f4"), stroke: 0.6pt + rgb("#9a9a9a"))

  // ===== (a) 阻抗控制 =====
  let ya = 6.55
  box((1.55, ya), 1.02, 0.34, [Desired \ Trajectory], size: 6.6pt)
  junction((3.55, ya))
  t((3.02, ya + 0.22), [P_des(t)], size: 6.2pt)
  t((3.74, ya + 0.22), [e(t)], size: 6.2pt)
  arr((2.57, ya), (3.47, ya))
  arr((3.63, ya), (3.95, ya))
  box((6.10, ya), 2.15, 0.46, [Impedance Control \ τ_ext(t) = M_d ë(t) + B_d ė(t) + K_d e(t)], size: 6.2pt)
  t((8.60, ya + 0.22), [u(t)], size: 6.6pt)
  arr((8.25, ya), (9.95, ya))
  box((11.45, ya), 1.30, 0.62, [], stroke: navy)
  t((11.45, ya + 0.20), [Human + EE Robot \ Interaction], size: 6.2pt)
  human(11.45, ya - 0.22)
  t((10.62, ya - 0.44), [x_b  z_b \ V_b], size: 5pt)
  box((12.20, ya + 1.18), 1.05, 0.28, [External \ Human Forces], size: 6.2pt, stroke: orange)
  line2((11.15, ya + 1.18), (6.10, ya + 1.18))
  poly((6.10, ya + 1.18), (6.10, ya + 0.46))
  t((6.55, ya + 0.78), [τ_ext(t)], size: 6.6pt)
  line((12.20, ya + 0.90), (12.20, ya + 0.63),
    stroke: 0.7pt + ink, mark: (start: "stealth", end: "stealth", scale: 0.6))
  poly((11.45, ya - 0.62), (11.45, ya - 1.35), (3.55, ya - 1.35), (3.55, ya - 0.09))
  t((6.60, ya - 1.18), [P_act(t)], size: 6.4pt)
  t((3.36, ya - 0.28), [−], size: 9pt)
  t((3.74, ya - 0.28), [+], size: 9pt)
  t((8.60, 4.35), [(a) Impedance control block diagram], size: 7.5pt)

  // ===== (b) 导纳控制 =====
  let yb = 2.40
  box((1.55, yb), 1.02, 0.34, [Desired \ Trajectory], size: 6.6pt)
  junction((3.55, yb))
  t((3.02, yb + 0.22), [P_des(t)], size: 6.2pt)
  t((3.74, yb + 0.22), [e(t)], size: 6.2pt)
  arr((2.57, yb), (3.47, yb))
  arr((3.63, yb), (3.95, yb))
  box((6.20, yb), 2.25, 0.50, [Admittance Control \ ė(t) = B_d⁻¹(τ_ext(t) − M_d ë(t) − K_d e(t))], size: 5.6pt)
  box((11.55, yb), 1.30, 0.62, [], stroke: navy)
  t((11.55, yb + 0.20), [Human-Robot \ Interaction], size: 6.2pt)
  human(11.55, yb - 0.22)
  t((10.72, yb - 0.44), [x_b  z_b \ V_b], size: 5pt)
  box((12.20, yb + 1.14), 1.05, 0.28, [External \ Human Forces], size: 6.2pt, stroke: orange)
  line2((11.15, yb + 1.14), (6.20, yb + 1.14))
  poly((6.20, yb + 1.14), (6.20, yb + 0.50))
  t((6.65, yb + 0.78), [τ_ext(t)], size: 6.6pt)
  line((12.20, yb + 0.86), (12.20, yb + 0.63),
    stroke: 0.7pt + ink, mark: (start: "stealth", end: "stealth", scale: 0.6))
  // 位置/速度环
  junction((6.20, yb - 1.05))
  poly((6.20, yb - 0.50), (6.20, yb - 0.97))
  t((6.78, yb - 0.72), [Ẋ_des(t)], size: 5.8pt)
  box((8.12, yb - 1.05), 1.10, 0.32, [Position/Velocity \ Control], size: 5.6pt)
  arr((6.28, yb - 1.05), (7.02, yb - 1.05))
  poly((9.22, yb - 1.05), (9.65, yb - 1.05), (9.65, yb - 0.28), (10.25, yb - 0.28))
  t((9.62, yb - 0.12), [u(t)], size: 6.4pt)
  // Ẋ_act 与 P_act 反馈
  poly((12.20, yb - 0.62), (12.20, yb - 1.45), (6.20, yb - 1.45), (6.20, yb - 1.14))
  t((8.60, yb - 1.58), [Ẋ_act(t)], size: 5.8pt)
  poly((10.85, yb - 0.62), (10.85, yb - 1.80), (3.55, yb - 1.80), (3.55, yb - 0.09))
  t((6.60, yb - 1.62), [P_act(t)], size: 6.4pt)
  t((3.36, yb - 0.28), [−], size: 9pt)
  t((3.74, yb - 0.28), [+], size: 9pt)
  t((8.60, 0.30), [(b) Admittance control block diagram], size: 7.5pt)
})
