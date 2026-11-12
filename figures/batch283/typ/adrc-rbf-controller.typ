#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：ADRC-RBF 控制器闭环结构框图。左端求和点（y_in 与 y_out 反馈）→ ADRC 参数更新（上）与
// ADRC 控制器（下）→ u → PLANT → y_out；上方 RBF 参数更新→RBF 神经网络（W C H 三路），网络输出
// y_rbf 与 y_out 在右侧求和得 e_rbf，并反馈回网络与参数更新；∂y_rbf/∂x_n 由网络送回参数更新。
// 来源：Aerospace 2025, 12, 684, Figure 4 "Structure of the ADRC-RBF controller"。DOI 10.3390/aerospace12080684

#canvas({
  import draw: *
  let ink = black
  let navy = rgb("#2f3d5c")
  let green = rgb("#8fc98f")
  let yellow = rgb("#ffe08a")
  let blue = rgb("#a8cbe8")
  // 实心盒
  let box(c, w, h, s, size: 7pt, fill: white) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      fill: fill, stroke: 0.55pt + ink)
    content(c, text(size: size)[#s], anchor: "center", frame: none)
  }
  // 标注文字
  let t(pos, s, size: 7pt, anchor: "center") = content(
    pos, text(size: size)[#s], anchor: anchor, frame: none)
  // 单向箭头与折线箭头
  let arr(a, b) = line(a, b, stroke: 0.55pt + ink, mark: (end: "stealth", scale: 0.6))
  let poly(..pts) = line(..pts, stroke: 0.55pt + ink, mark: (end: "stealth", scale: 0.6))

  // 输入求和点：y_in 加、y_out 反馈减
  let J = (1.25, 3.55)
  circle(J, radius: 0.09, fill: white, stroke: 0.55pt + ink)
  t((1.38, 3.72), [+], size: 8pt)
  t((1.02, 3.72), [−], size: 8pt)
  poly((0.20, 1.55), (0.78, 1.55), (0.78, 3.40), (1.16, 3.40))
  t((0.42, 1.75), [y_in], size: 7.5pt)
  // y_out 反馈沿底部绕回左端
  poly((10.10, 3.55), (10.55, 3.55), (10.55, 0.55), (0.55, 0.55), (0.55, 3.55), (1.16, 3.55))
  t((9.80, 3.35), [y_out], size: 7.5pt)

  // ADRC 控制器与参数更新
  box((2.25, 3.55), 0.60, 0.30, [ADRC \ Controller], size: 6.8pt, fill: green)
  box((2.25, 5.35), 0.74, 0.32, [ADRC \ Parameters \ Update], size: 5.6pt, fill: green)
  line((1.34, 3.55), (1.45, 3.55), (1.45, 5.07), (1.51, 5.07),
    stroke: 0.55pt + ink, mark: (end: "stealth", scale: 0.6))
  arr((1.34, 3.55), (1.63, 3.55))
  // 参数更新向控制器下发 K_P K_D 与 β 两组参数
  arr((2.00, 5.03), (2.00, 3.87))
  t((1.58, 4.32), [K_P K_D], size: 6.4pt)
  arr((2.52, 5.03), (2.52, 3.87))
  t((2.92, 4.32), [β_1 β_2 β_3], size: 6.2pt)

  // 被控对象与输出
  box((5.05, 3.55), 0.75, 0.30, [PLANT], size: 8pt, fill: blue)
  arr((2.87, 3.55), (4.28, 3.55))
  t((3.45, 3.72), [u], size: 7.5pt)
  arr((5.82, 3.55), (10.10, 3.55))

  // RBF 参数更新与神经网络
  box((6.55, 5.70), 1.00, 0.24, [RBF Parameters \ Update], size: 6.4pt, fill: yellow)
  box((6.55, 4.15), 0.95, 0.38, [RBF Neural \ Network], size: 7pt, fill: yellow)
  // W C H 三路连接
  for (i, s) in ("W", "C", "H").enumerate() {
    let x = 6.15 + 0.40 * i
    arr((x, 5.46), (x, 4.53))
    t((x + 0.05, 4.98), [#s], size: 6pt)
  }
  // 网络参数梯度送回参数更新
  poly((5.60, 4.53), (5.60, 5.46), (5.53, 5.46))
  t((4.95, 5.30), [∂y_rbf / ∂x_n], size: 5.6pt)
  // 网络输出 y_rbf 与 y_out 在右侧合成 e_rbf
  let E = (8.05, 4.15)
  circle(E, radius: 0.09, fill: white, stroke: 0.55pt + ink)
  t((7.90, 4.35), [−], size: 8pt)
  t((8.22, 4.35), [+], size: 8pt)
  arr((7.52, 4.15), (7.95, 4.15))
  t((7.32, 3.60), [y_rbf], size: 5.4pt)
  line((8.05, 3.55), (8.05, 4.06), stroke: 0.55pt + ink)
  // e_rbf 反馈：下行回网络、上行回参数更新
  poly((8.05, 4.24), (8.05, 4.78), (7.05, 4.78), (7.05, 4.53))
  t((7.74, 4.94), [e_rbf], size: 5.8pt, anchor: "west")
  poly((8.14, 4.15), (8.35, 4.15), (8.35, 5.70), (7.57, 5.70))
})
