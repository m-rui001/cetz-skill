#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：履带机器人（TMR）平面运动学俯视图。全局坐标系 O_G-X_G-Y_G 下机体转过 θ；机体局部坐标系
// O_L-X_L-Y_L 随车体旋转，左右履带速度 v_left/v_right 合成速度 v（与 X_L 成 φ），并分解为 v_XL/v_YL；
// 转向瞬心 O_c 位于垂直 v 的方向上，R/R' 为瞬心到左右履带的半径，ε 为 O_c 相对 O_L 轴沿 X_L 的偏置，
// a 为 R 与 R' 之间的履带宽度量，L 为履带全长，b 为左右履带中心距，ω 为绕 O_L 的转向角速度。
// 来源：Actuators 2025, 14, 51, Figure 1 "Top View of TMR Kinematic Model". DOI 10.3390/act14020051

#canvas({
  import draw: *
  let ink = black
  let blue = rgb("#2f5fb3")
  let gray = rgb("#8a8a8a")
  let th = 30deg
  let u = (calc.cos(th), calc.sin(th))
  let n = (-calc.sin(th), calc.cos(th))
  let add(p, q, s: 1) = (p.at(0) + q.at(0) * s, p.at(1) + q.at(1) * s)
  let O = (0.55, 0.55)
  let OL = (4.60, 3.85)
  let bg = 0.62
  let cl = add(OL, n, s: bg)
  let cr = add(OL, n, s: -bg)
  let hl = 1.55
  let hw = 0.21

  // 车体与履带
  let track(c) = {
    let a1 = add(add(c, u, s: -hl), n, s: -hw)
    let a2 = add(add(c, u, s: hl), n, s: -hw)
    let a3 = add(add(c, u, s: hl), n, s: hw)
    let a4 = add(add(c, u, s: -hl), n, s: hw)
    line(a1, a2, a3, a4, close: true, fill: rgb("#c9c9c9"), stroke: 0.8pt + gray)
    for i in range(1, 12) {
      let s = -hl + i * (2 * hl / 12)
      line(add(add(c, u, s: s), n, s: -hw), add(add(c, u, s: s), n, s: hw),
        stroke: 0.35pt + rgb("#9b9b9b"))
    }
  }
  track(cl)
  track(cr)
  line(add(add(OL, u, s: -1.30), n, s: -0.44), add(add(OL, u, s: 1.30), n, s: -0.44),
    add(add(OL, u, s: 1.30), n, s: 0.44), add(add(OL, u, s: -1.30), n, s: 0.44),
    close: true, fill: rgb("#f2f2f2"), stroke: 1.0pt + gray)
  rect(add(add(OL, u, s: -1.10), n, s: -0.31), add(add(OL, u, s: 1.10), n, s: 0.31),
    radius: 0.12, fill: none, stroke: 0.5pt + rgb("#bcbcbc"))
  circle(OL, radius: 0.055, fill: ink, stroke: none)

  // 全局坐标轴
  let axg(p, q) = line(p, q, stroke: 2.2pt + ink, mark: (end: "stealth", fill: ink, scale: 1.3))
  axg(O, add(O, (0, 1), s: 7.1))
  axg(O, add(O, (1, 0), s: 7.5))
  content(add(O, (0, 1), s: 7.26), [$Y_G$], anchor: "south")
  content(add(O, (1, 0), s: 7.66), [$X_G$], anchor: "west")
  content(add(O, (0, -0.30)), [$O_G$])

  // 机体局部坐标轴
  let axl(p, q) = line(p, q, stroke: (paint: ink, thickness: 0.75pt, dash: "dash-dotted"))
  axl(OL, add(OL, u, s: 2.62))
  axl(OL, add(OL, n, s: 1.18))
  content(add(OL, u, s: 2.72), [$X_L$], anchor: "west")
  content((4.40, 3.575), [$O_L$], anchor: "north", size: 9.5pt)
  content(add(add(OL, n, s: 1.10), u, s: -0.22), [$Y_L$], anchor: "east")

  // 左右履带速度（沿履带方向）
  let va(p, q) = line(p, q, stroke: 1.4pt + blue, mark: (end: "stealth", fill: blue, scale: 0.9))
  va(add(cl, u, s: -1.05), add(cl, u, s: 1.75))
  va(add(cr, u, s: -0.85), add(cr, u, s: 1.45))
  content(add(add(cl, u, s: 0.62), n, s: 0.46), [$v_"left"$], size: 8.5pt)
  content((5.98, 3.36), [$v_"right"$], size: 8.5pt)

  // 合成速度 v 及其分解
  let ph = 17deg
  let vdir = (calc.cos(th + ph), calc.sin(th + ph))
  let vl = 2.30
  let vx = add(OL, u, s: vl * calc.cos(ph))
  let vy = add(OL, n, s: vl * calc.sin(ph))
  let vt = add(OL, vdir, s: vl)
  va(OL, vt)
  va(OL, vx)
  va(OL, vy)
  line(vx, vt, vy, stroke: (paint: blue, thickness: 0.6pt, dash: "dashed"))
  content(add(vt, (-0.02, 0.20)), [$bold(v)$], size: 9.5pt, anchor: "south")
  content(add(add(OL, u, s: 1.95), n, s: -0.32), [$v_"XL"$], size: 8.5pt)
  content((4.12, 3.80), [$v_"YL"$], size: 8.5pt)
  arc(OL, start: 30deg, stop: 47deg, radius: 0.95, stroke: 0.7pt + ink, mode: "OPEN")
  content(add(OL, (calc.cos(38.5deg), calc.sin(38.5deg)), s: 1.14), [$phi$], size: 9pt)

  // 转向角速度 ω
  arc((3.30, 5.60), start: 10deg, stop: 110deg, radius: 0.36,
    stroke: 1.1pt + blue, mode: "OPEN", mark: (end: "stealth", fill: blue, scale: 0.7))
  content((2.92, 5.38), [$omega$], size: 9.5pt)

  // 瞬心 O_c、半径 R / R' 与偏置 ε
  let d = (calc.sin(th + ph), -calc.cos(th + ph))
  let Oc = add(OL, d, s: 3.55)
  let rear = add(cr, u, s: -hl)
  let per = (0.713, 0.701)
  line(add(OL, u, s: -0.35), add(add(OL, u, s: -0.35), d, s: 1.35),
    stroke: (paint: gray, thickness: 0.55pt, dash: "dashed"))
  let e1 = add(OL, d, s: 1.00)
  let e2 = add(add(OL, u, s: -0.35), d, s: 1.00)
  line(e1, e2, stroke: 0.8pt + ink, mark: (start: "bar", end: "bar", scale: 0.35))
  content(add(add(OL, d, s: 1.18), u, s: -0.175), [$epsilon$], size: 8pt)
  line(OL, Oc, stroke: (paint: gray, thickness: 0.6pt, dash: "dashed"))
  line(Oc, cl, stroke: 0.9pt + ink, mark: (start: "stealth", fill: ink, scale: 0.55))
  line(Oc, rear, stroke: 0.9pt + ink, mark: (start: "stealth", fill: ink, scale: 0.55))
  content(add(add(Oc, (cl.at(0) - Oc.at(0), cl.at(1) - Oc.at(1)), s: 0.35), per, s: 0.24), [$R$], size: 9pt)
  content((5.15, 1.89), [$R'$], size: 9pt)
  content((5.90, 2.25), [$a$], size: 9pt)
  arc(Oc, start: 134deg, stop: 162deg, radius: 0.90, stroke: 0.7pt + blue, mode: "OPEN")
  content((Oc.at(0), Oc.at(1) - 0.14), [$O_c$], anchor: "north", size: 9.5pt)

  // 履带全长 L 与中心距 b 的尺寸标注
  let bar = (start: "bar", end: "bar", scale: 0.35)
  let diml(p, q, off, body, lpos) = {
    let m1 = add(p, off)
    let m2 = add(q, off)
    line(p, m1, stroke: 0.5pt + gray)
    line(q, m2, stroke: 0.5pt + gray)
    line(m1, m2, stroke: 0.6pt + ink, mark: bar)
    content(lpos, body, size: 8.5pt)
  }
  diml(add(cl, u, s: -hl), add(cl, u, s: hl), (n.at(0) * 0.70, n.at(1) * 0.70),
    [$L$], (4.72, 5.66))
  diml(add(cl, u, s: -hl), add(cr, u, s: -hl), (u.at(0) * -0.50, u.at(1) * -0.50),
    [$b$], (2.65, 2.72))

  // 航向角 θ
  line(O, add(O, u, s: 2.2), stroke: (paint: gray, thickness: 0.6pt, dash: "dashed"))
  arc(O, start: 0deg, stop: 30deg, radius: 0.95, stroke: 0.7pt + ink, mode: "OPEN")
  content((1.62, 0.86), [$theta$], size: 9pt)
})
