#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 连续体机器人双关节 + 弯曲臂 干净线稿（重绘自 Actuators 2024, 13(2), 52, Fig.15；DOI 10.3390/act13020052）
#canvas({
  import draw: *

  // 折线逼近椭圆（白色平涂）
  let oval(cx, cy, rx, ry) = {
    let n = 56
    let pts = range(0, n).map(i => {
      let t = i / n * 2 * calc.pi
      (cx + rx * calc.cos(t), cy + ry * calc.sin(t))
    })
    line(..pts, close: true, fill: white, stroke: 0.9pt)
  }

  // 水平圆柱：上下母线 + 两端椭圆
  let hcyl(cx, cy, len, r) = {
    let x1 = cx - len / 2
    let x2 = cx + len / 2
    line((x1, cy - r), (x2, cy - r), stroke: 0.9pt)
    line((x1, cy + r), (x2, cy + r), stroke: 0.9pt)
    oval(x1, cy, r * 0.36, r)
    oval(x2, cy, r * 0.36, r)
  }

  // 竖直圆柱：左右母线 + 上下椭圆
  let vcyl(cx, cy, len, r) = {
    let y1 = cy - len / 2
    let y2 = cy + len / 2
    line((cx - r, y1), (cx - r, y2), stroke: 0.9pt)
    line((cx + r, y1), (cx + r, y2), stroke: 0.9pt)
    oval(cx, y1, r, r * 0.36)
    oval(cx, y2, r, r * 0.36)
  }

  // 关键地标
  let O = (4.45, 3.10)      // 坐标系原点（臂根）
  let J = (10.45, 9.90)     // 第二关节中心

  // ---- 弯曲臂：贝塞尔骨架生成等宽分段带 ----
  let P0 = O
  let P1 = (6.95, 3.50)
  let P2 = (10.05, 5.45)
  let P3 = (10.28, 9.30)
  let bez(t) = {
    let u = 1 - t
    let a = u * u * u
    let b = 3 * u * u * t
    let c = 3 * u * t * t
    let d = t * t * t
    (
      a * P0.at(0) + b * P1.at(0) + c * P2.at(0) + d * P3.at(0),
      a * P0.at(1) + b * P1.at(1) + c * P2.at(1) + d * P3.at(1),
    )
  }
  let N = 96
  let pts = range(0, N + 1).map(i => bez(i / N))
  let w = 0.28
  let lft = ()
  let rgt = ()
  for i in range(0, N + 1) {
    let p = pts.at(i)
    let a = pts.at(calc.max(i - 1, 0))
    let b = pts.at(calc.min(i + 1, N))
    let dx = b.at(0) - a.at(0)
    let dy = b.at(1) - a.at(1)
    let m = calc.sqrt(dx * dx + dy * dy)
    lft.push((p.at(0) - dy / m * w, p.at(1) + dx / m * w))
    rgt.push((p.at(0) + dy / m * w, p.at(1) - dx / m * w))
  }
  line(..lft, ..rgt.rev(), close: true, fill: rgb(160, 160, 160), stroke: 1pt)
  // 臂体横向螺纹（椎节分段感）
  for i in range(0, N + 1) {
    if calc.rem(i, 4) == 2 {
      line(lft.at(i), rgt.at(i), stroke: (paint: rgb(80, 80, 80), thickness: 0.45pt))
    }
  }

  // ---- 两条牵引细线：原点 → 第二关节 ----
  line(O, J, stroke: 0.6pt)
  line((4.55, 3.35), (10.75, 9.55), stroke: 0.6pt)

  // ---- d3 三维薄块：位于牵引线上 ----
  let C = (7.00, 6.00)
  let u = (0.60, 0.79)
  let n = (-0.79, 0.60)
  let q(k, s) = (C.at(0) + k * u.at(0) + s * n.at(0), C.at(1) + k * u.at(1) + s * n.at(1))
  let e = (0.30, 0.22) // 厚度方向
  let fn = (q(0.62, 0.24), q(-0.62, 0.24), q(-0.62, -0.24), q(0.62, -0.24))
  let bk = fn.map(p => (p.at(0) + e.at(0), p.at(1) + e.at(1)))
  line(..bk, close: true, stroke: 0.7pt)
  for i in range(0, 4) {
    line(fn.at(i), bk.at(i), stroke: 0.7pt)
  }
  line(..fn, close: true, fill: white, stroke: 0.9pt)
  content(q(0, 0), $d_3$)

  // ---- 第一关节：θ1 横筒前，θ2 竖筒被部分遮挡 ----
  vcyl(4.25, 4.10, 2.6, 0.52)
  hcyl(3.20, 3.10, 3.30, 0.62)

  // ---- 第二关节：θ5 横筒 + θ4 竖筒穿过 ----
  vcyl(10.75, 9.90, 2.70, 0.52)
  hcyl(10.45, 9.90, 3.05, 0.60)

  // ---- 坐标系三轴 ----
  line((4.25, 5.40), (4.25, 7.10), mark: (end: "stealth"), stroke: 0.8pt)
  content((4.25, 7.35), $z$)
  line(O, (8.05, 2.45), mark: (end: "stealth"), stroke: 0.8pt)
  content((8.30, 2.37), $x$)
  line(O, (7.40, 4.15), mark: (end: "stealth"), stroke: 0.8pt)
  content((7.62, 4.20), $y$)

  // ---- 角度标签 ----
  content((1.95, 3.08), $theta_1$)
  content((4.25, 4.75), $theta_2$)
  content((9.58, 9.90), $theta_5$)
  content((10.75, 10.75), $theta_4$)
})
