#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：履带机器人（TMR）平面运动学俯视图。全局系 O_G-X_G-Y_G 与机体方向成 θ；机体局部系 O_L-X_L-Y_L
// 随车体转 36°；机体速度 v 与 X_L 成 φ，分解为 v_XL/v_YL；左右履带速度 v_left/v_right 沿 X_L；
// 瞬心 O_c 在 v 的法线上，R/R′ 分别连右履带前端与后端，a 为两半径夹角，ε 为 R′ 与履带轴夹角。
// 来源：Actuators 2025, 14, 51, Figure 1 "Top View of TMR Kinematic Model". DOI 10.3390/act14020051

#canvas({
  import draw: *
  let ink = black
  let blue = rgb("#2f5fb3")
  let redc = rgb("#c62828")
  let gray = rgb("#8a8a8a")
  let tdir = 36deg
  let ph = 22deg
  let u = (calc.cos(tdir), calc.sin(tdir))
  let n = (-calc.sin(tdir), calc.cos(tdir))
  let add(p, q, s: 1) = (p.at(0) + q.at(0) * s, p.at(1) + q.at(1) * s)
  let at(c, r, ang) = (c.at(0) + r * calc.cos(ang), c.at(1) + r * calc.sin(ang))
  let mid(p, q) = ((p.at(0) + q.at(0)) / 2, (p.at(1) + q.at(1)) / 2)
  let O = (0.62, 0.62)
  let OL = (4.55, 4.05)
  let bg = 0.70
  let cl = add(OL, n, s: bg)
  let cr = add(OL, n, s: -bg)
  let hl = 1.50
  let hw = 0.18

  // 圆弧折线助手（c 为圆心；CeTZ 原生 arc 的 pos 是起点，容易错位）
  let sarc(c, r, a1, a2, st: 0.6pt + ink, mark: none) = line(
    ..range(17).map(i => {
      let a = a1 + (a2 - a1) * i / 16
      (c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a))
    }), stroke: st, mark: mark)

  // 全局坐标轴与 θ 参考射线（先画，车身覆盖中段）
  let axg(p, q) = line(p, q, stroke: 2.2pt + ink, mark: (end: "stealth", fill: ink, scale: 1.25))
  let thray = calc.atan2(OL.at(0) - O.at(0), OL.at(1) - O.at(1))
  line(O, add(O, (calc.cos(thray), calc.sin(thray)), s: 6.2),
    stroke: (paint: gray, thickness: 0.45pt, dash: "dash-dotted"))
  sarc(O, 0.85, 0deg, thray, st: 0.7pt + ink)
  content(at(O, 1.02, thray / 2), [$theta$], size: 9pt)

  // 机体参考框（点划线）与竖直转向轴
  let fw = bg + hw + 0.42
  let fl = hl + 0.30
  line(add(add(OL, u, s: fl), n, s: fw), add(add(OL, u, s: fl), n, s: -fw),
    add(add(OL, u, s: -fl), n, s: -fw), add(add(OL, u, s: -fl), n, s: fw),
    close: true, stroke: (paint: gray, thickness: 0.45pt, dash: "dash-dotted"))
  line(add(OL, (0, 1), s: 0.45), add(OL, (0, 1), s: 2.35),
    stroke: (paint: gray, thickness: 0.45pt, dash: "dash-dotted"))

  // 车体底板、内框、四履带
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
  line(add(add(OL, u, s: -1.28), n, s: -0.52), add(add(OL, u, s: 1.28), n, s: -0.52),
    add(add(OL, u, s: 1.28), n, s: 0.52), add(add(OL, u, s: -1.28), n, s: 0.52),
    close: true, fill: rgb("#f2f2f2"), stroke: 1.0pt + gray)
  track(cl)
  track(cr)
  circle(OL, radius: 0.055, fill: ink, stroke: none)

  // 全局坐标轴与标签
  axg(O, add(O, (0, 1), s: 7.1))
  axg(O, add(O, (1, 0), s: 7.6))
  content(add(O, (0, 1), s: 7.27), [$Y_G$], anchor: "south")
  content(add(O, (1, 0), s: 7.77), [$X_G$], anchor: "west")
  content(add(O, (0, -0.30)), [$O_G$])

  // 机体局部坐标轴
  line(OL, add(OL, u, s: 2.55), stroke: (paint: ink, thickness: 0.7pt, dash: "dash-dotted"))
  line(OL, add(OL, n, s: 1.45), stroke: (paint: ink, thickness: 0.7pt, dash: "dash-dotted"))
  content(add(OL, u, s: 2.65), [$X_L$], anchor: "west")
  content(add(OL, n, s: 1.30), [$Y_L$], anchor: "south")
  content(add(OL, u, s: -0.28), [$O_L$], anchor: "north", size: 9.5pt)

  // 左右履带速度 v_left / v_right（沿 X_L）
  let va(p, q, col: blue, w: 1.5pt) = line(p, q, stroke: w + col, mark: (end: "stealth", fill: col, scale: 0.75))
  va(add(cl, u, s: -1.00), add(cl, u, s: 1.68))
  va(add(cr, u, s: -0.80), add(cr, u, s: 1.55))
  content(add(add(cl, u, s: 1.90), n, s: 0.45), [$v_"left"$], size: 8.5pt)
  content(add(add(cr, u, s: 0.85), n, s: -0.38), [$v_"right"$], size: 8.5pt, anchor: "north")

  // 合成速度 v（红）与 v_XL / v_YL 分解（蓝）
  let vdir = (calc.cos(tdir + ph), calc.sin(tdir + ph))
  let vl = 2.45
  let vx = add(OL, u, s: vl * calc.cos(ph))
  let vy = add(OL, n, s: vl * calc.sin(ph))
  let vt = add(OL, vdir, s: vl)
  va(OL, vx)
  va(OL, vy)
  line(vx, vt, stroke: (paint: blue, thickness: 0.55pt, dash: "dashed"))
  line(vy, vt, stroke: (paint: blue, thickness: 0.55pt, dash: "dashed"))
  line(OL, vt, stroke: 2.2pt + redc, mark: (end: "stealth", fill: redc, scale: 0.85))
  content(add(vt, (0.02, 0.24)), [$bold(v)$], size: 9.5pt, anchor: "south")
  content(add(vx, (0.06, -0.30)), [$v_"XL"$], size: 8.5pt, anchor: "north")
  content(add(add(OL, n, s: 0.45), u, s: -0.35), [$v_"YL"$], size: 8.5pt)
  // φ：X_L 与 v 之间的小弧
  arc(at(OL, 1.00, tdir), start: tdir, stop: tdir + ph, radius: 1.00,
    stroke: 0.6pt + ink, mark: (end: "stealth", fill: ink, scale: 0.5))
  content(at(OL, 1.20, tdir + ph / 2), [$phi$], size: 9.5pt, angle: tdir + ph / 2)

  // 转向角速度 ω：绕竖直点划轴的蓝弧
  sarc(add(OL, (0, 1), s: 1.78), 0.34, 100deg, 255deg,
    st: 1.0pt + blue, mark: (end: "stealth", fill: blue, scale: 0.6))
  content(add(add(OL, (0, 1), s: 1.78), (-0.98, 0)), [$omega$], size: 9.5pt, anchor: "east")

  // 瞬心 O_c、R/R′、a、ε
  let d = (calc.sin(tdir + ph), -calc.cos(tdir + ph))
  let Oc = add(OL, d, s: 3.85)
  let front = add(cr, u, s: hl)
  let rear = add(cr, u, s: -hl)
  line(Oc, front, stroke: 0.9pt + ink)
  line(Oc, rear, stroke: (paint: gray, thickness: 0.7pt, dash: "dashed"))
  line(rear, add(rear, u, s: -0.95), stroke: (paint: gray, thickness: 0.55pt, dash: "dashed"))
  let midR = mid(Oc, front)
  let midQ = mid(Oc, rear)
  content(add(midR, (0.42, 0.16)), [$R$], size: 9pt)
  content((5.30, 2.60), [$R'$], size: 9pt)
  let a1 = calc.atan2(front.at(0) - Oc.at(0), front.at(1) - Oc.at(1))
  let a2 = calc.atan2(rear.at(0) - Oc.at(0), rear.at(1) - Oc.at(1))
  sarc(Oc, 0.92, a1, a2, st: 0.6pt + blue, mark: none)
  content(at(Oc, 1.12, (a1 + a2) / 2), [$a$], size: 9pt)
  let ae = calc.atan2(Oc.at(0) - rear.at(0), Oc.at(1) - rear.at(1))
  let au = calc.atan2(u.at(0), u.at(1))
  let e1 = calc.min(ae, au)
  let e2 = calc.max(ae, au)
  sarc(rear, 0.58, e1, e2, st: 0.55pt + ink, mark: none)
  content(at(rear, 0.78, (e1 + e2) / 2), [$epsilon$], size: 8.5pt)
  content(add(Oc, (0.12, -0.34)), [$O_c$], anchor: "north", size: 9.5pt)

  // 履带全长 L 与中心距 b 的尺寸线
  let bar = (start: "bar", end: "bar", scale: 0.32)
  let dimline(p, q, off, lab, laboff) = {
    let m1 = add(p, off)
    let m2 = add(q, off)
    line(p, m1, stroke: 0.45pt + gray)
    line(q, m2, stroke: 0.45pt + gray)
    line(m1, m2, stroke: 0.6pt + ink, mark: bar)
    content(add(mid(m1, m2), laboff), lab, size: 8.5pt)
  }
  dimline(add(cl, u, s: -hl), add(cl, u, s: hl), (n.at(0) * 1.02, n.at(1) * 1.02),
    [$L$], (n.at(0) * 0.28 - 1.55, n.at(1) * 0.28 - 0.36))
  dimline(add(cl, u, s: -hl), add(cr, u, s: -hl), (u.at(0) * -0.48, u.at(1) * -0.48),
    [$b$], (u.at(0) * -0.28, u.at(1) * -0.28))
})