#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：履带机器人（TMR）SMC 控制框图。上排 Te SMC 与 ω SMC 交换期望角速度，TMR 运动学模型
// 把位姿 X,Y,φ 分别送入 ω SMC 与 UDO，UDO 输出滑移系数估计 ŝ 进 ω SMC；Te SMC 下发期望电磁转矩
// 驱动履带动力学模型，后者回馈左右轮角速度；q_d 为期望位姿输入。底部注记说明 * 上标含义。
// 来源：Actuators 2025, 14, 51, Figure 3 "Block Diagram of TMRs Control System". DOI 10.3390/act14020051

#canvas({
  import draw: *
  let ink = black
  let lw = 1.4pt
  let box(c, w, h, body, size: 13pt) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      radius: 0.12, stroke: lw + ink)
    content(c, text(size: size, weight: "bold")[#body], frame: none)
  }
  let arr(a, b) = line(a, b, stroke: lw + ink, mark: (end: "stealth", fill: ink, scale: 1.1))
  let elb(..pts) = line(..pts, stroke: lw + ink, mark: (end: "stealth", fill: ink, scale: 1.1))
  let lab(pos, body, size: 9pt, anchor: "center") = content(pos, text(size: size)[#body], anchor: anchor, frame: none)

  // 五个功能块
  box((3.20, 6.35), 1.45, 0.80, [T#sub[e] SMC], size: 15pt)
  box((8.45, 6.55), 1.55, 0.80, [ω SMC], size: 15pt)
  box((14.35, 4.60), 1.45, 1.70, [TMR \ Kinematics \ Model], size: 14pt)
  box((8.45, 3.65), 1.45, 0.72, [UDO], size: 15pt)
  box((3.20, 2.85), 1.45, 1.10, [Track \ Dynamics \ Model], size: 14pt)

  // ω SMC → Te SMC（期望角速度）
  arr((6.90, 6.55), (4.65, 6.55))
  lab((5.78, 7.02), [$omega_"left"^(*), omega_"right"^(*)$], size: 8pt)
  // TMR 运动学 → ω SMC（位姿）
  arr((12.90, 6.30), (10.02, 6.30))
  lab((11.45, 6.58), [$X, Y, phi$], size: 9.5pt)
  // TMR 运动学 → UDO（位姿）
  arr((12.90, 4.05), (9.92, 4.05))
  lab((11.40, 4.32), [$X, Y, phi$], size: 9.5pt)
  // UDO → ω SMC（滑移系数估计）
  arr((8.45, 4.37), (8.45, 5.75))
  lab((8.72, 5.10), [$hat(s)_"left", hat(s)_"right"$], size: 8.5pt, anchor: "west")
  // Te SMC → 履带动力学（期望转矩）
  arr((3.20, 5.55), (3.20, 3.95))
  lab((3.45, 4.75), [$T_(e, "left")^(*), T_(e, "right")^(*)$], size: 8.5pt, anchor: "west")
  // 履带动力学 → TMR 运动学（左右轮角速度）
  elb((4.65, 2.10), (14.35, 2.10), (14.35, 2.90))
  lab((7.30, 2.35), [$omega_"left", omega_"right"$], size: 9pt)
  // 期望位姿 q_d 输入
  arr((15.65, 1.45), (15.65, 2.90))
  lab((15.85, 2.15), [$q_d$], size: 10pt, anchor: "west")

  // 底部注记（逐字保留）
  content((4.55, 1.05),
    text(size: 9pt)[Remark: The variables with the "\*" superscript represent the \ expected values.], anchor: "west", frame: none)
})
