#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 四旋翼扰动观测/自适应控制总体框图：位置环与姿态环双闭环，
// 顶部扰动估计模块回馈 d̂_v、d̂_η；浅蓝圆角功能块 + 深蓝箭头总线。
// 来源：Actuators 2024, 13, 217, Figure 3, DOI 10.3390/act13060217
#canvas({
  import draw: *

  // 配色：浅蓝填充、深蓝边框、连线蓝
  let fc = rgb(189, 215, 238)
  let ec = rgb(47, 117, 181)
  let lc = rgb(70, 114, 196)
  let st = (paint: lc, thickness: .75pt)

  // 圆角功能块：两角点 + 居中标题（dy 微调文字纵向位置）
  let blk(x0, y0, x1, y1, body, dy: 0) = {
    rect((x0, y0), (x1, y1), radius: .12, fill: fc,
      stroke: (paint: ec, thickness: 1.1pt))
    content(((x0 + x1) / 2, (y0 + y1) / 2 + dy), body, anchor: "center")
  }
  // 直角折线箭头（末点带实心三角）
  let ar(..pts) = line(..pts, stroke: st, mark: (end: "stealth", scale: 1.0))
  // 标注文字
  let lab(pos, body, anc: "center") = content(pos, text(size: 9pt, body), anchor: anc)

  // 五个功能块
  blk(5.66, 4.93, 7.90, 6.20, text(size: 8.6pt, weight: "bold", [Disturbance \ estimation]))
  blk(2.64, 3.02, 4.33, 4.30, text(size: 8.6pt, weight: "bold", [position \ controller]))
  blk(2.64, 1.08, 4.33, 2.36, text(size: 8.6pt, weight: "bold", [attitude \ resolution]))
  blk(5.94, 1.09, 7.63, 3.07, text(size: 8.6pt, weight: "bold", [attitude \ controller]), dy: -.22)
  blk(9.25, 1.08, 11.15, 4.53, text(size: 8.6pt, weight: "bold", [Quadrotor]))

  // 位置环：给定输入、u1、位置反馈
  ar((.15, 3.47), (2.64, 3.47))
  ar((4.33, 3.91), (9.25, 3.91))
  ar((9.25, 3.43), (4.33, 3.43))

  // 扰动估计回馈：d̂_v 左上绕行，d̂_η 竖直下送
  ar((5.66, 5.56), (1.77, 5.56), (1.77, 3.87), (2.64, 3.87))
  ar((6.78, 4.93), (6.78, 3.07))
  // 顶部量测反馈总线：x,y,z 与 φ,θ,ψ
  ar((10.20, 4.53), (10.20, 5.56), (7.90, 5.56))

  // 姿态环：姿态解算支路
  ar((3.16, 3.02), (3.16, 2.36))
  ar((3.80, 3.02), (3.80, 2.36))
  ar((4.33, 1.94), (5.94, 1.94))
  ar((4.33, 1.56), (5.94, 1.56))

  // 姿态控制器至四旋翼的四个控制量
  ar((7.63, 2.31), (9.25, 2.31))
  ar((7.63, 1.92), (9.25, 1.92))
  ar((7.63, 1.51), (9.25, 1.51))
  ar((9.25, 2.71), (7.63, 2.71))

  // 外部输入：偏航给定、外界扰动
  ar((6.73, .28), (6.73, 1.09))
  ar((10.20, .23), (10.20, 1.08))

  // 逐字标注
  lab((.15, 3.64), [$x_d$、$y_d$、$z_d$], anc: "west")
  lab((2.65, 5.92), [$hat(d)_v$])
  lab((6.94, 4.33), [$hat(d)_eta$], anc: "west")
  lab((4.79, 4.20), [$u_1$])
  lab((8.90, 5.84), [$x$ 、 $y$ 、 $z$])
  lab((8.95, 5.20), [$phi$ 、 $theta$ 、 $psi$])
  lab((7.78, 3.60), [$x$ 、 $y$ 、 $z$])
  lab((7.78, 3.02), [$phi$、$theta$、$psi$], anc: "west")
  lab((8.14, 2.52), [$u_2$])
  lab((8.14, 2.13), [$u_3$])
  lab((8.14, 1.72), [$u_4$])
  lab((2.84, 2.68), [$u_x$])
  lab((3.50, 2.68), [$u_y$])
  lab((4.79, 2.16), [$phi_d$])
  lab((4.79, 1.78), [$theta_d$])
  lab((6.60, .60), [$psi_d$], anc: "east")
  lab((10.06, .60), [$d_v$ 、 $d_eta$], anc: "east")
})
