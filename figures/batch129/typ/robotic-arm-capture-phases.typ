#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 机械臂捕获空间碎片四阶段示意（干净线稿平涂版）
// 来源：Aerospace 2025, 12, 277, Figure 22. DOI 10.3390/aerospace12040277.
#canvas({
  import draw: *
  let navy = rgb("#1f3864")
  let blue = rgb("#b9cbe3")
  let red = rgb("#c00000")
  let lw = 0.9pt

  // 向量助手
  let add(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
  let mul(a, k) = (a.at(0) * k, a.at(1) * k)
  let xf(o, a, p) = {
    let ca = calc.cos(a * 1deg)
    let sa = calc.sin(a * 1deg)
    (o.at(0) + p.at(0) * ca - p.at(1) * sa, o.at(1) + p.at(0) * sa + p.at(1) * ca)
  }
  // 二次贝塞尔采样（柔性捕获绳）
  let qbez(a, ctl, b, n: 18) = {
    let out = ()
    for i in range(n + 1) {
      let t = i / n
      let u = 1 - t
      out.push((
        u * u * a.at(0) + 2 * u * t * ctl.at(0) + t * t * b.at(0),
        u * u * a.at(1) + 2 * u * t * ctl.at(1) + t * t * b.at(1),
      ))
    }
    out
  }

  // 基础图元
  let quad(pts, fill: white) = line(..pts, close: true, fill: fill, stroke: navy + lw)

  // 三维盒体：c 中心，u 半宽向量，v 半高向量，w 深度向量
  let box3d(c, u, v, w, fill: blue) = {
    let f1 = add(c, add(mul(u, -1), mul(v, -1)))
    let f2 = add(c, add(u, mul(v, -1)))
    let f3 = add(c, add(u, v))
    let f4 = add(c, add(mul(u, -1), v))
    quad((f4, f3, add(f3, w), add(f4, w)))
    quad((f2, add(f2, w), add(f3, w), f3))
    quad((f1, f2, f3, f4), fill: fill)
  }

  // 薄板（太阳翼）
  let slab(p, d, t) = quad((p, add(p, d), add(add(p, d), t), add(p, t)))

  // 追踪星：太阳翼 + 蓝色主体
  let chaser(c) = {
    slab(add(c, (-0.92, 0.20)), (-1.95, 0.32), (0.10, 0.40))
    slab(add(c, (0.92, -0.14)), (1.95, -0.32), (0.10, 0.40))
    box3d(c, (0.90, 0.10), (0, 0.70), (0.44, 0.38), fill: blue)
  }

  // 目标碎片：可旋转白色盒体 + 两片薄翼
  let target(c, a) = {
    let P(p) = xf(c, a, p)
    let w = (0.28, 0.22)
    let b1 = P((-0.50, -0.36))
    let b2 = P((0.50, -0.36))
    let b3 = P((0.50, 0.36))
    let b4 = P((-0.50, 0.36))
    quad((b4, b3, add(b3, w), add(b4, w)))
    quad((b2, add(b2, w), add(b3, w), b3))
    quad((b1, b2, b3, b4))
    quad((P((-0.46, 0.12)), P((-2.05, 0.62)), P((-1.98, 0.96)), P((-0.40, 0.46))))
    quad((P((0.46, -0.10)), P((2.05, -0.58)), P((1.98, -0.92)), P((0.40, -0.44))))
  }

  // 机械臂：粗连杆 + 关节白圈 + 末端执行器
  let arm(pts) = {
    for i in range(pts.len() - 1) {
      line(pts.at(i), pts.at(i + 1), stroke: navy + 1.8pt)
    }
    for p in pts.slice(0, pts.len() - 1) {
      circle(p, radius: 0.075, fill: white, stroke: navy + lw)
    }
    circle(pts.last(), radius: 0.10, fill: white, stroke: navy + 1.1pt)
  }

  // 四阶段场景表
  let scenes = (
    (
      o: (0, 0),
      ap: ((0.05, 0.62), (0.05, 1.02), (0.68, 1.70), (1.25, 2.12)),
      tp: (3.6, 2.3), ang: 45, mode: "cone",
      label: "I-Observing and Planning",
    ),
    (
      o: (8.6, 0),
      ap: ((0.05, 0.62), (0.05, 1.02), (0.68, 1.72), (1.22, 2.16)),
      tp: (3.9, 2.35), ang: 20, mode: "tether",
      label: "II-Final Approaching",
    ),
    (
      o: (0, -6.6),
      ap: ((0.05, 0.62), (0.05, 1.05), (0.85, 1.88), (1.80, 1.62)),
      tp: (2.55, 1.95), ang: 0, mode: "contact",
      label: "III-Impact and Capture",
    ),
    (
      o: (8.6, -6.6),
      ap: ((0.05, 0.62), (0.05, 1.05), (0.78, 1.92), (1.55, 1.60)),
      tp: (2.30, 1.95), ang: -25, mode: "contact",
      label: "IV-Post-capturing stabilization",
    ),
  )

  for s in scenes {
    let c = add(s.o, (3.0, 1.8))
    let tip = add(c, s.ap.at(3))
    let tpos = add(c, s.tp)
    chaser(c)
    target(tpos, s.ang)
    arm(s.ap.map(p => add(c, p)))
    // 观测锥：两条红线指向目标
    if s.mode == "cone" {
      line(tip, add(tpos, (-1.05, 0.78)), stroke: red + lw)
      line(tip, add(tpos, (-0.85, 0.08)), stroke: red + lw)
    }
    // 柔性捕获绳
    if s.mode == "tether" {
      let pts = qbez(add(tip, (0.04, 0.08)), add(tip, (1.25, 1.85)), add(tpos, (-0.95, 0.0)))
      line(..pts, stroke: red + 1.3pt)
      circle(add(tpos, (-0.95, 0.0)), radius: 0.06, fill: red, stroke: none)
    }
    // 接触/抓附：末端与目标间短连杆
    if s.mode == "contact" {
      line(tip, add(tpos, (-0.55, -0.15)), stroke: navy + 1.8pt)
    }
    content(
      add(s.o, (4.3, -0.60)),
      text(
        size: 12pt,
        weight: "bold",
        font: ("Times New Roman", "DejaVu Serif"),
        s.label,
      ),
    )
  }
})
