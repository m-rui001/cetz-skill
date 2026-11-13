#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：四倾转旋翼无人机 ADRC-RBF 姿态控制总图。左侧三路完全相同的 ADRC-RBF 通道（滚转/俯仰/偏航），
// 每路含 ADRC 参数更新、ADRC 控制器、RBF 参数更新、RBF 神经网络四块及 β/K、W C H、∂φ/∂U 信号；
// 中间竖长条 Control Allocation 汇总三路控制量 U_lat/U_lon/U_ped 与顶部 U_T，输出三组舵面偏角；
// 右侧 Flight Dynamics Model of Quad Tiltrotor UAV 输出 φ_out/θ_out/ψ_out。
// 来源：Aerospace 2025, 12, 684, Figure 8 "ADRC-RBF attitude control system"。DOI 10.3390/aerospace12080684

#canvas({
  import draw: *
  let ink = black
  let navy = rgb("#2f3d5c")
  let green = rgb("#8fc98f")
  let yellow = rgb("#ffe08a")
  let blue = rgb("#a8cbe8")
  // 实心盒：中心 c、半宽 w、半高 h、文字、字号、填充
  let box(c, w, h, s, size: 7pt, fill: white) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      fill: fill, stroke: 0.55pt + ink)
    content(c, text(size: size)[#s], anchor: "center", frame: none)
  }
  // 标注文字
  let t(pos, s, size: 6.5pt, anchor: "center") = content(
    pos, text(size: size)[#s], anchor: anchor, frame: none)
  // 单向箭头
  let arr(a, b) = line(a, b, stroke: 0.55pt + ink, mark: (end: "stealth", scale: 0.6))

  // 单路 ADRC-RBF 通道：ymid 为纵向中心，xin/U 为输入输出名
  let channel(ymid, xin, xout, uout, deriv) = {
    rect((0.60, ymid - 1.25), (6.35, ymid + 1.25), fill: white, stroke: 0.6pt + navy)
    // 四个内部模块
    box((1.85, ymid + 0.40), 0.78, 0.42, [ADRC \ Parameters \ Update], size: 5.7pt, fill: green)
    box((1.85, ymid - 0.62), 0.66, 0.26, [ADRC \ Controller], size: 6.6pt, fill: green)
    box((4.35, ymid + 1.00), 1.30, 0.20, [RBF Parameters Update], size: 6.5pt, fill: yellow)
    box((4.35, ymid + 0.18), 0.98, 0.34, [RBF Neural \ Network], size: 6.6pt, fill: yellow)
    // 外部输入 e_c 与 x_in
    arr((0.60, ymid + 0.40), (1.19, ymid + 0.40))
    t((0.78, ymid + 0.60), $e_c$, size: 6.5pt)
    arr((0.60, ymid - 0.62), (1.19, ymid - 0.62))
    t((0.76, ymid - 0.88), xin, size: 6.5pt)
    // 参数更新→RBF 参数更新（∂φ/∂U）
    arr((2.63, ymid + 0.30), (3.05, ymid + 0.94))
    t((1.90, ymid + 1.04), deriv, size: 5.2pt)
    // RBF 参数更新→RBF 网络（W C H 三路）
    for (i, s) in ("W", "C", "H").enumerate() {
      let x = 3.95 + 0.40 * i
      arr((x, ymid + 0.80), (x, ymid + 0.54))
      t((x + 0.18, ymid + 0.63), [#s], size: 5.8pt)
    }
    // ADRC 参数更新→控制器（K_P K_D 与 β1 β2 β3）
    arr((1.62, ymid - 0.02), (1.62, ymid - 0.36))
    t((1.08, ymid - 0.19), $K_P K_D$, size: 5.8pt)
    arr((2.16, ymid - 0.02), (2.16, ymid - 0.36))
    t((2.82, ymid - 0.19), $β_1 β_2 β_3$, size: 5.4pt)
    // 网络与参数更新的反馈（e_rbf、φ_out 由右侧进入）
    arr((6.90, ymid + 1.00), (5.65, ymid + 1.00))
    t((7.55, ymid + 1.14), $e_"rbf"$, size: 6.4pt)
    arr((6.90, ymid + 0.18), (5.33, ymid + 0.18))
    t((7.55, ymid + 0.40), xout, size: 5.8pt)
    // 控制器输出 U 至控制分配
    arr((2.55, ymid - 0.62), (9.13, ymid - 0.62))
    t((7.55, ymid - 0.46), uout, size: 6.4pt)
  }

  // 三路通道：滚转、俯仰、偏航
  channel(6.90, $phi_"in"$, $phi_"out"$, $U_"lat"$, $frac(∂ phi_"in,rbf", ∂ U_"lat")$)
  channel(4.30, $theta_"in"$, $theta_"out"$, $U_"lon"$, $frac(∂ theta_"in,rbf", ∂ U_"lon")$)
  channel(1.70, $psi_"in"$, $psi_"out"$, $U_"ped"$, $frac(∂ psi_"in,rbf", ∂ U_"ped")$)

  // 顶部总距信号
  arr((6.35, 8.38), (10.00, 8.38))
  line((10.00, 8.38), (10.00, 6.64), stroke: 0.55pt + ink, mark: (end: "stealth", scale: 0.6))
  t((8.10, 8.52), $U_T$, size: 7pt)

  // 控制分配器
  box((10.00, 3.70), 0.85, 2.90, [Control \ Allocation], size: 8pt, fill: blue)
  arr((10.85, 5.62), (12.32, 5.62))
  arr((10.85, 3.72), (12.32, 3.72))
  arr((10.85, 1.72), (12.32, 1.72))
  t((10.92, 5.80), $δ_"Tlon" δ_"Tlat" δ_r$, size: 4.6pt, anchor: "west")
  t((10.92, 3.90), $δ_B δ_B δ_A δ_"DA"$, size: 4.6pt, anchor: "west")
  t((10.92, 1.90), $δ_"Alon" δ_"Ele" δ_"rud"$, size: 4.5pt, anchor: "west")

  // 飞行动力学模型与三轴输出
  box((13.30, 3.70), 0.95, 2.60, [Flight \ Dynamics \ Model of \ Quad \ Tiltrotor \ UAV], size: 8pt, fill: blue)
  arr((14.25, 5.40), (14.90, 5.40))
  arr((14.25, 3.60), (14.90, 3.60))
  arr((14.25, 1.70), (14.90, 1.70))
  t((14.98, 5.40), $phi_"out"$, size: 7pt, anchor: "west")
  t((14.98, 3.60), $theta_"out"$, size: 7pt, anchor: "west")
  t((14.98, 1.70), $psi_"out"$, size: 7pt, anchor: "west")
})
