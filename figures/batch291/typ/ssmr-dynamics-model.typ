#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 四轮滑移转向机器人(SSMR)俯视动力学模型：米色车体+前置灰色载荷箱、四个花纹轮胎、八条轮胎力
// F_(ijx′)/F_(ijy′)、x′/y′/z′ 机体系与 v、ψ、尺寸 a b c e h d₂ L r、右下全局坐标系 G 插图。
// 来源：Robotics 2025, 14, 74, Figure 3；DOI: 10.3390/robotics14060074
#canvas({
  import draw: *
  // 配色与常数
  let beige = rgb(251, 240, 222)
  let grey = rgb(213, 213, 213)
  let tire = rgb(122, 122, 122)
  let brn = rgb(150, 44, 20)
  let blu = rgb(0, 0, 225)
  let blk = rgb(25, 25, 25)
  let k = 0.70711
  // 机体系 (x′,y′) → 画布：绕几何中心 L 逆时针旋转 45°
  let P(x, y) = (k * (x - y), k * (x + y))
  let Pv(v) = P(v.at(0), v.at(1))
  // 数学斜体标签
  let T(pos, m, col: blk, size: 10pt) = content(pos, text(fill: col, size: size, m))

  // 车体底板、前置载荷箱与四个车轮（机体系内绘制，整组旋转）
  group({
    rotate(45deg)
    rect((-2.0, -1.45), (2.3, 1.45), radius: 0.35, fill: beige, stroke: none)
    rect((2.6, -1.9), (4.9, 1.95), radius: 0.12, fill: grey, stroke: (paint: rgb(186, 186, 186), thickness: 0.6pt))
    for (wx, wy) in ((2.45, 1.55), (2.45, -1.55), (-1.05, 1.55), (-1.05, -1.55)) {
      rect((wx - 0.52, wy - 0.31), (wx + 0.52, wy + 0.31), radius: 0.07, fill: tire, stroke: (paint: rgb(78, 78, 78), thickness: 0.5pt))
      for i in range(-3, 4) {
        line((wx + 0.145 * i, wy - 0.25), (wx + 0.145 * i, wy + 0.25), stroke: (paint: rgb(92, 92, 92), thickness: 0.45pt))
      }
      circle((wx, wy), radius: 0.155, fill: white, stroke: (paint: brn, thickness: 1.4pt))
      circle((wx, wy), radius: 0.05, fill: brn, stroke: none)
    }
  })

  // 蓝色虚线尺寸基准
  let dl(a, b) = line(Pv(a), Pv(b), stroke: (paint: blu, thickness: 0.55pt, dash: "dashed"))
  dl((-2.35, 0.75), (2.45, 0.75))
  dl((-2.35, -0.85), (2.45, -0.85))
  dl((-2.8, 1.55), (2.7, 1.55))
  dl((-2.8, -1.55), (2.7, -1.55))
  dl((2.45, -2.3), (2.45, 2.3))
  dl((-1.05, -2.3), (-1.05, 2.3))
  dl((-2.55, -2.3), (-2.55, 2.3))
  // 尺寸箭头
  let dim(a, b) = line(Pv(a), Pv(b), stroke: (paint: blu, thickness: 0.6pt), mark: (start: "stealth", end: "stealth", fill: blu, scale: 0.38))
  dim((-0.45, 0.78), (-0.45, 1.53))
  dim((0.05, 0.75), (2.42, 0.75))
  dim((-1.62, 1.12), (-1.08, 1.12))
  dim((2.06, -0.03), (2.06, -0.75))
  dim((0.6, -0.03), (0.6, -1.53))
  dim((-2.55, 0.05), (-2.55, 1.85))
  dim((-2.55, -1.85), (-2.55, -0.05))
  // 轮胎半径 r
  dim((2.45, -1.92), (2.45, -2.36))

  // 机体系坐标轴：x′ 沿中心线、y′ 横向、z′ 竖直
  let ax = (paint: blk, thickness: 1.1pt)
  line(P(-2.2, 0), P(5.0, 0), stroke: ax, mark: (end: "stealth", fill: blk, scale: 0.7))
  line(P(0, 0), P(0, 3.45), stroke: ax, mark: (end: "stealth", fill: blk, scale: 0.7))
  line((0, 0), (0, 4.6), stroke: ax, mark: (end: "stealth", fill: blk, scale: 0.7))
  // 绕 z′ 的横摆角速度 ω
  bezier((-0.55, 4.0), (0.55, 4.0), (-0.56, 4.44), (0.56, 4.44), stroke: (paint: blk, thickness: 0.7pt), mark: (end: "stealth", fill: blk, scale: 0.45))

  // 航向角 ψ：自 X 轴量至 x′ 轴
  let O = P(2.45, 0)
  line(O, (O.at(0) + 1.45, O.at(1)), stroke: (paint: blk, thickness: 0.6pt, dash: "dashed"))
  bezier(O, (O.at(0) + 0.75, O.at(1)), (O.at(0), O.at(1) + 0.75), (O.at(0), O.at(1) + 0.75), stroke: (paint: blk, thickness: 0.6pt))

  // 车体关键点：C、B、H=(x,y) 与几何中心 L
  for p in ((-1.7, 0), (-1.0, 0), (0.8, 0), (2.45, 0)) {
    circle(Pv(p), radius: 0.075, fill: blk, stroke: none)
  }
  circle(P(0, 0), radius: 0.09, fill: white, stroke: (paint: blk, thickness: 1.1pt))

  // 八条轮胎力：纵向沿 +x′，横向沿 +y′
  let forces = (
    ((2.95, 1.78), (3.8, 2.02), (4.28, 2.22), (2.55, 1.9), (2.76, 2.32), (3.1, 2.22), $F_(f l x')$, $F_(f l y')$),
    ((2.95, -1.72), (3.75, -1.52), (4.38, -1.42), (3.12, -2.72), (2.72, -2.12), (3.78, -2.74), $F_(f r x')$, $F_(f r y')$),
    ((-0.5, 1.75), (0.3, 1.95), (0.66, 2.2), (-1.12, 1.95), (-1.28, 2.72), (-1.52, 3.0), $F_(r l x')$, $F_(r l y')$),
    ((-0.5, -1.72), (0.3, -1.52), (0.9, -1.9), (-0.92, -2.3), (-1.02, -1.98), (-0.72, -2.88), $F_(r r x')$, $F_(r r y')$),
  )
  for f in forces {
    line(Pv(f.at(0)), Pv(f.at(1)), stroke: (paint: brn, thickness: 1.5pt), mark: (end: "stealth", fill: brn, scale: 0.6))
    line(Pv(f.at(3)), Pv(f.at(4)), stroke: (paint: brn, thickness: 1.5pt), mark: (end: "stealth", fill: brn, scale: 0.6))
    T(Pv(f.at(2)), f.at(6), col: brn)
    T(Pv(f.at(5)), f.at(7), col: brn)
  }

  // 右下角全局坐标系 G 插图
  line((3.95, -3.62), (5.45, -3.62), (5.45, -2.1), (3.95, -2.1), (3.95, -3.62), stroke: (paint: brn, thickness: 1pt, dash: "dashed"))
  line((4.32, -3.28), (4.32, -2.52), stroke: (paint: blk, thickness: 0.9pt), mark: (end: "stealth", fill: blk, scale: 0.45))
  line((4.32, -3.28), (5.05, -3.28), stroke: (paint: blk, thickness: 0.9pt), mark: (end: "stealth", fill: blk, scale: 0.45))
  circle((4.32, -3.28), radius: 0.075, fill: white, stroke: (paint: blk, thickness: 0.8pt))
  circle((4.32, -3.28), radius: 0.025, fill: blk, stroke: none)
  T((5.28, -2.3), $G$, col: brn, size: 9pt)
  T((4.32, -2.34), $Z$, size: 9pt)
  T((5.16, -3.45), $X$, size: 9pt)
  T((4.12, -3.5), $Y$, size: 9pt)

  // 尺寸与角度文字
  T(Pv((-0.16, 1.2)), $a$, col: blu, size: 10pt)
  T(Pv((1.25, 0.98)), $b$, col: blu, size: 10pt)
  T(Pv((-1.36, 0.86)), $c$, col: blu, size: 10pt)
  T(Pv((0.4, -0.86)), $e$, col: blu, size: 10pt)
  T(Pv((1.9, -0.38)), $h$, col: blu, size: 10pt)
  T(Pv((-2.78, 0.95)), $d_2$, col: blu, size: 10pt)
  T(Pv((-2.78, -0.95)), $d_2$, col: blu, size: 10pt)
  T(Pv((2.64, -2.14)), $r$, col: blu, size: 10pt)
  T(Pv((-0.32, 0.46)), $L$, size: 11pt)
  T(Pv((0.95, 0.44)), $H$, size: 11pt)
  T(Pv((1.02, -0.5)), $(x, y)$, size: 11pt)
  T(Pv((-1.34, 0.4)), $B$, size: 11pt)
  T(Pv((-1.55, -0.36)), $C$, size: 11pt)
  T((2.22, 2.62), $psi$, size: 12pt)
  T((-1.02, 3.98), $omega$, size: 12pt)
  T(Pv((4.15, 0.46)), $v$, size: 12pt)
  T(Pv((5.35, 0.12)), $x'$, size: 12pt)
  T(Pv((0, 3.68)), $y'$, size: 12pt)
  T((0, 4.9), $z'$, size: 12pt)
})
