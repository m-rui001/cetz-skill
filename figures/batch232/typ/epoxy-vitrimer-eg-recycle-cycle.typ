#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 上排：脂肪族连接链与乙二醇的酯交换（蓝链红端基），下排：乙二醇封端的解聚产物；
// 下部：模具与三只烧杯构成闭环——浸溶→基体溶解→分离碳纤维→再聚合，蓝箭头走流程、红波浪箭头表示加热/蒸发。
// 来源：Actuators 2024, 13, 449, Figure 9. DOI 10.3390/act13110449
#canvas({
  import draw: *
  // 配色
  let ink = rgb("#1b1b1b"); let bl = rgb("#2b4a8c"); let rd = rgb("#c0392b")
  let ab = rgb("#1f3d8f"); let gd = rgb("#d9a13b"); let gl = rgb("#f0d9a6")
  let gs = rgb("#5f6670")
  // 共享助手：插值、锯齿链、芳环、半椭圆、烧杯、织物板、波浪箭头
  let lp(p, q, t) = (p.at(0) * (1 - t) + q.at(0) * t, p.at(1) * (1 - t) + q.at(1) * t)
  let zig(x, y, n, dx, dy) = range(n + 1).map(i => (x + i * dx, if calc.even(i) { y } else { y + dy }))
  let hexc(c, r) = {
    line(..range(6).map(i => (c.at(0) + r * calc.cos(90deg + i * 60deg), c.at(1) + r * calc.sin(90deg + i * 60deg))),
      close: true, stroke: (paint: ink, thickness: 0.8pt))
    circle(c, radius: r * 0.52, stroke: (paint: ink, thickness: 0.4pt))
  }
  let arc2(c, rx, ry, up: false) = {
    let k = if up { 1 } else { -1 }
    bezier((c.at(0) - rx, c.at(1)), (c.at(0) + rx, c.at(1)),
      (c.at(0) - rx, c.at(1) + k * ry * 1.33), (c.at(0) + rx, c.at(1) + k * ry * 1.33),
      stroke: (paint: gs, thickness: 0.8pt))
  }
  let beaker(x, yb, h, rx, ry, lvl, lc) = {
    let yt = yb + h
    if lvl > 0 {
      let yl = yb + lvl
      line((x - rx, yb), (x - rx, yl), (x + rx, yl), (x + rx, yb),
        (x + rx * 0.75, yb - ry * 0.55), (x, yb - ry * 0.95), (x - rx * 0.75, yb - ry * 0.55),
        close: true, fill: lc, stroke: none)
      arc2((x, yl), rx, ry * 0.5, up: false)
    }
    line((x - rx, yt), (x - rx, yb), stroke: (paint: gs, thickness: 0.8pt))
    line((x + rx, yt), (x + rx, yb), stroke: (paint: gs, thickness: 0.8pt))
    arc2((x, yb), rx, ry, up: false); arc2((x, yt), rx, ry, up: false); arc2((x, yt), rx, ry, up: true)
  }
  let plate(p1, p2, p3, p4, fc, sc, n: 5) = {
    line(p1, p2, p3, p4, close: true, fill: fc, stroke: (paint: sc, thickness: 0.6pt))
    for i in range(1, n) {
      line(lp(p1, p4, i / n), lp(p2, p3, i / n), stroke: (paint: sc, thickness: 0.25pt))
      line(lp(p1, p2, i / n), lp(p4, p3, i / n), stroke: (paint: sc, thickness: 0.25pt))
    }
  }
  let wavy(p, q, col, amp: 0.13, n: 10) = {
    let d = (q.at(0) - p.at(0), q.at(1) - p.at(1))
    let L = calc.sqrt(d.at(0) * d.at(0) + d.at(1) * d.at(1))
    let s = range(n + 1).map(i => {
      let b = lp(p, q, i / n)
      let w = if calc.even(i) { amp } else { -amp }
      (b.at(0) - d.at(1) / L * w, b.at(1) + d.at(0) / L * w)
    })
    line(..s, stroke: (paint: col, thickness: 1.1pt), mark: (end: "stealth"))
  }
  let arw(p, q, col) = line(p, q, stroke: (paint: col, thickness: 1.1pt), mark: (end: "stealth"))

  // ── 上排左：脂肪链（酯键—二氢吡啶环—双酚 A 二缩水甘油醚）
  let ck = (paint: ink, thickness: 0.8pt)
  let cb = (paint: bl, thickness: 1.3pt)
  let cr = (paint: rd, thickness: 1.3pt)
  line(..zig(0.55, 13.28, 4, 0.30, 0.24), (1.92, 13.54), stroke: cb)
  hexc((2.22, 13.72), 0.40)
  content((2.22, 14.30), text("R", size: 7.5pt)); content((1.62, 13.88), text("R'", size: 7.5pt))
  line(..zig(2.58, 13.44, 4, 0.30, 0.24), stroke: cb)
  // 酯基与缩水甘油醚
  line((3.80, 13.46), (3.92, 13.66), (4.12, 13.42), stroke: ck)
  line((3.88, 13.70), (3.96, 13.98), stroke: ck); line((3.98, 13.66), (4.06, 13.94), stroke: ck)
  content((4.10, 14.06), text("O", size: 7.5pt)); content((4.26, 13.36), text("O", size: 7.5pt))
  line((4.42, 13.42), (4.58, 13.64), (4.74, 13.40), (4.92, 13.62), stroke: ck)
  content((4.72, 13.14), text("HO", size: 7.5pt)); content((5.02, 13.66), text("O", size: 7.5pt))
  line((5.10, 13.74), (5.24, 13.88), stroke: ck)
  // 双酚 A 单元
  hexc((5.62, 13.95), 0.42)
  line((6.04, 13.95), (6.20, 13.95), (6.12, 14.24), stroke: ck)
  line((6.20, 13.95), (6.32, 14.22), stroke: ck); line((6.20, 13.95), (6.32, 13.95), stroke: ck)
  hexc((6.74, 13.95), 0.42)
  line((7.16, 13.95), (7.30, 13.72), stroke: ck); content((7.40, 13.66), text("O", size: 7.5pt))
  line((7.52, 13.60), (7.68, 13.38), (7.82, 13.14), stroke: ck)
  content((7.86, 12.86), text("HO", size: 7.5pt))
  content((4.55, 12.55), text([Fatty Acid Linker], weight: "bold"))

  // 上排右：乙二醇与可逆溶解箭头
  content((9.55, 13.82), text("+", size: 11pt))
  content((9.86, 13.48), text("HO", size: 7.5pt, fill: rd))
  line(..zig(10.28, 13.54, 3, 0.28, 0.26), stroke: cr)
  content((11.52, 13.72), text("OH", size: 7.5pt, fill: rd))
  content((10.85, 12.55), text([Ethylene Glycol], weight: "bold", fill: rd))
  arw((13.55, 14.10), (16.35, 14.10), ink); arw((16.35, 13.68), (13.55, 13.68), ink)
  content((14.95, 14.32), text([Dissolution], weight: "bold", size: 9.5pt))
  content((14.95, 13.40), text([Repolymerization], weight: "bold", size: 9.5pt))

  // ── 下排：乙二醇封端的解聚产物
  translate((0, -0.25))
  content((0.42, 11.50), text("HO", size: 7.5pt, fill: rd))
  line(..zig(0.75, 11.50, 2, 0.30, 0.24), stroke: cr)
  content((1.44, 11.44), text("O", size: 7.5pt))
  line((1.58, 11.52), (1.58, 11.80), stroke: ck)
  line((1.52, 11.84), (1.52, 12.08), stroke: ck); line((1.62, 11.84), (1.62, 12.08), stroke: ck)
  content((1.57, 12.20), text("O", size: 7.5pt))
  line(..zig(1.70, 11.52, 5, 0.30, 0.24), (3.34, 11.74), stroke: cb)
  hexc((3.64, 11.88), 0.38)
  content((3.64, 12.40), text("R", size: 7.5pt)); content((3.16, 12.00), text("R'", size: 7.5pt))
  line(..zig(3.98, 11.58, 5, 0.30, 0.24), stroke: cb)
  line((5.50, 11.62), (5.62, 11.84), (5.82, 11.60), stroke: ck)
  line((5.57, 11.88), (5.57, 12.12), stroke: ck); line((5.67, 11.88), (5.67, 12.12), stroke: ck)
  content((5.62, 12.24), text("O", size: 7.5pt)); content((5.96, 11.54), text("O", size: 7.5pt))
  line(..zig(6.14, 11.58, 2, 0.28, 0.24), stroke: cr)
  content((7.00, 11.72), text("OH", size: 7.5pt, fill: rd))

  // 下排右：双酚 A 缩水甘油醚片段
  content((7.58, 11.58), text("+", size: 11pt))
  content((8.05, 11.74), text("HO", size: 7.5pt, fill: rd))
  line((8.38, 11.70), (8.56, 11.92), (8.72, 11.66), (8.90, 11.90), stroke: ck)
  content((8.68, 11.50), text("HO", size: 7.5pt)); content((9.02, 11.96), text("O", size: 7.5pt))
  line((9.12, 12.02), (9.26, 12.12), stroke: ck)
  hexc((9.68, 12.18), 0.42)
  line((10.10, 12.18), (10.26, 12.18), (10.18, 12.47), stroke: ck)
  line((10.26, 12.18), (10.38, 12.45), stroke: ck); line((10.26, 12.18), (10.42, 12.18), stroke: ck)
  hexc((10.84, 12.18), 0.42)
  line((11.26, 12.18), (11.40, 11.94), stroke: ck); content((11.50, 11.88), text("O", size: 7.5pt))
  line((11.62, 11.82), (11.78, 11.60), (11.94, 11.82), (12.08, 11.58), stroke: ck)
  content((11.88, 11.44), text("HO", size: 7.5pt)); content((12.18, 11.64), text("OH", size: 7.5pt))

  // ── 下部闭环：流程箭头先画，色块与文字后画覆盖
  translate((0, 1.25))
  arw((2.95, 6.05), (3.95, 7.95), ab); arw((5.30, 5.02), (5.55, 7.90), ab)
  arw((8.82, 2.85), (6.55, 3.95), ab); arw((13.18, 8.30), (14.35, 6.30), ab)
  arw((8.60, 1.72), (3.15, 3.05), rd)
  wavy((14.10, 5.05), (12.15, 4.00), rd); wavy((7.20, 8.72), (9.20, 8.72), rd)
  // 敞口模具：前壁、侧壁、上沿、内腔织物与树脂层
  line((3.55, 8.08), (6.35, 8.08), (6.35, 8.55), (3.55, 8.55), close: true, fill: white, stroke: (paint: gs, thickness: 0.7pt))
  line((6.35, 8.08), (6.95, 9.10), (6.95, 9.55), (6.35, 8.55), close: true, fill: rgb("#eef0f2"), stroke: (paint: gs, thickness: 0.7pt))
  line((3.55, 8.55), (6.35, 8.55), (6.95, 9.55), (4.15, 9.55), close: true, fill: white, stroke: (paint: gs, thickness: 0.8pt))
  plate((3.92, 8.76), (6.06, 8.76), (6.55, 9.34), (4.41, 9.34), gl, rgb("#c08a2e"), n: 5)
  line((4.10, 8.86), (5.92, 8.86), (6.32, 9.26), (4.50, 9.26), close: true, fill: rgb(233, 190, 90, 55%), stroke: none)
  // 复材板（带厚度侧面）
  line((9.55, 8.30), (12.35, 8.50), (12.35, 8.28), (9.55, 8.08), close: true, fill: rgb("#a9741f"), stroke: none)
  plate((9.55, 8.30), (12.35, 8.50), (12.95, 9.42), (10.15, 9.22), gd, rgb("#8f5f18"), n: 6)
  // 三只烧杯：残留液、基体溶解、浸入乙二醇
  beaker(1.75, 3.55, 2.35, 1.12, 0.24, 0.55, rgb("#e8c98a"))
  beaker(9.65, 0.85, 2.55, 1.10, 0.24, 2.30, rgb("#8b8b8b"))
  line((8.60, 2.92), (10.70, 2.92), (10.70, 3.14), (8.60, 3.14), close: true, fill: rgb("#d9a13b"), stroke: none)
  plate((8.95, 1.10), (10.05, 0.95), (10.45, 2.45), (9.35, 2.60), rgb("#787878"), rgb("#3f3f3f"), n: 4)
  beaker(15.10, 3.55, 2.60, 1.10, 0.24, 1.95, rgb("#858585"))
  plate((14.30, 4.00), (15.40, 3.82), (15.80, 5.30), (14.70, 5.48), gd, rgb("#8f5f18"), n: 4)
  // 分离出的碳纤维织物
  plate((3.95, 4.30), (5.95, 4.05), (6.40, 4.72), (4.40, 4.97), rgb("#3a3a3a"), rgb("#1d1d1d"), n: 7)
  content((6.62, 5.42), text([Separated Carbon \ Fiber], weight: "bold"), anchor: "west")
  // 标注文字
  content((8.55, 9.15), text([Repolymerization], weight: "bold", fill: rd))
  content((13.05, 9.50), text([Composite], weight: "bold"), anchor: "west")
  content((13.05, 5.25), text([Heating], weight: "bold", fill: rd), angle: -28deg)
  content((5.85, 2.72), text([Evaporating Remnant EG], weight: "bold", size: 9.5pt, fill: rd), angle: -12deg)
  content((15.10, 3.15), text([Immersing in EG], weight: "bold"))
  content((9.65, 0.28), text([Polymer Matrix Dissolved], weight: "bold"))
})
