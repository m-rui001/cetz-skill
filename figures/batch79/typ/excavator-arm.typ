// 挖掘机工作装置 · 二维侧视工程简图
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Arial", "Segoe UI"), size: 5pt)

#canvas({
  import draw: *

  let LW-MEMBER = 0.9pt
  let LW-DETAIL = 0.8pt
  let LW-CYL = 0.7pt
  let LW-ROD = 0.6pt
  let LW-THIN = 0.6pt
  let INK = black
  let FS = 5pt
  let FS-S = 4.4pt

  let A = (0.70, 3.68)
  let B = (11.00, 7.62)
  let C = (13.02, 2.34)
  let D = (12.80, 3.13)
  let E = (13.86, 2.14)
  let F = (0.90, 0.24)
  let P1 = (1.52, 2.60)
  let P2 = (3.62, 5.36)
  let P3 = (5.50, 8.02)
  let P4 = (10.85, 9.27)
  let P5 = (12.27, 7.47)
  let P6 = (13.93, 3.23)

  let BOOM-OUTLINE = (
    (0.70, 3.68), (0.95, 4.05), (1.35, 4.58), (1.85, 5.18),
    (2.45, 5.82), (3.05, 6.36), (3.65, 6.80), (4.25, 7.14),
    (4.85, 7.46), (5.40, 8.10), (5.62, 7.84), (6.60, 7.85),
    (7.80, 7.86), (9.00, 7.90), (10.05, 7.96), (10.55, 8.04),
    (10.86, 7.90), (11.02, 7.70), (11.04, 7.52), (10.86, 7.40),
    (10.20, 7.26), (9.20, 7.10), (8.00, 6.90), (6.80, 6.66),
    (5.80, 6.42), (5.00, 6.15), (4.20, 5.80), (3.50, 5.36),
    (2.90, 4.92), (2.30, 4.46), (1.70, 4.06), (1.15, 3.80),
  )

  let ARM-OUTLINE = (
    (10.85, 9.27), (10.66, 8.62), (10.58, 8.04), (10.72, 7.48),
    (11.02, 6.96), (11.42, 6.12), (11.78, 5.28), (12.06, 4.48),
    (12.30, 3.72), (12.46, 3.22), (12.56, 2.90), (12.70, 2.52),
    (12.86, 2.26), (13.12, 2.18), (13.34, 2.34), (13.44, 2.66),
    (13.40, 3.02), (13.20, 3.62), (13.02, 4.30), (12.80, 5.10),
    (12.58, 5.90), (12.40, 6.64), (12.32, 7.18), (12.42, 7.36),
    (12.27, 7.47), (11.98, 7.76), (11.50, 8.28), (11.10, 8.82),
  )

  let BUCKET-OUTLINE = (
    (13.02, 2.34), (13.30, 2.46), (13.54, 2.44), (13.72, 2.36),
    (13.96, 2.22), (14.04, 2.00), (14.04, 1.50), (13.92, 1.06),
    (13.66, 0.72), (13.25, 0.52), (12.70, 0.42), (12.15, 0.40),
    (11.84, 0.52), (11.82, 0.86), (12.00, 1.28), (12.20, 1.62),
    (12.44, 1.90), (12.72, 2.16),
  )
  let BUCKET-EDGE = ((13.20, 0.53), (11.90, 0.47))
  let BUCKET-LIP = ((12.55, 0.56), (11.95, 0.52))

  let add(p, q) = (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let sub(p, q) = (p.at(0) - q.at(0), p.at(1) - q.at(1))
  let scl(p, k) = (p.at(0) * k, p.at(1) * k)
  let uni(p) = {
    let l = calc.sqrt(p.at(0) * p.at(0) + p.at(1) * p.at(1))
    (p.at(0) / l, p.at(1) / l)
  }
  let nrm(p) = (-p.at(1), p.at(0))
  let mix(p, q, t) = (
    p.at(0) + (q.at(0) - p.at(0)) * t,
    p.at(1) + (q.at(1) - p.at(1)) * t,
  )

  let member(pts, lw: LW-MEMBER, hatch: none) = {
    line(..pts, close: true, fill: white, stroke: (paint: INK, thickness: lw))
    if hatch != none {
      let (h0, h1, n, span) = hatch
      let ax = uni(sub(h1, h0))
      let td = uni(add(scl(ax, 0.75), scl(nrm(ax), 0.66)))
      for i in range(n) {
        let c = mix(h0, h1, (i + 0.5) / n)
        line(sub(c, scl(td, span / 2)), add(c, scl(td, span / 2)),
          stroke: (paint: INK, thickness: LW-THIN))
      }
    }
  }

  let cylinder(p0, p1, frac: 0.64, w: 0.16, gap: 0.12) = {
    let ax = uni(sub(p1, p0))
    let nx = nrm(ax)
    let pb = add(p0, scl(ax, gap))
    let pm = mix(pb, p1, frac)
    line(add(pb, scl(nx, w)), add(pm, scl(nx, w)),
      sub(pm, scl(nx, w)), sub(pb, scl(nx, w)),
      close: true, fill: white, stroke: (paint: INK, thickness: LW-CYL))
    line(add(p0, scl(nx, 0.055)), add(pb, scl(nx, w)),
      stroke: (paint: INK, thickness: LW-CYL))
    line(sub(p0, scl(nx, 0.055)), sub(pb, scl(nx, w)),
      stroke: (paint: INK, thickness: LW-CYL))
    line(add(pm, scl(nx, w)), sub(pm, scl(nx, w)),
      stroke: (paint: INK, thickness: LW-CYL))
    line(add(add(pm, scl(nx, w)), scl(ax, 0.09)),
      add(sub(pm, scl(nx, w)), scl(ax, 0.09)),
      stroke: (paint: INK, thickness: LW-CYL))
    line(add(pm, scl(ax, -0.18)), p1,
      stroke: (paint: INK, thickness: LW-ROD))
  }

  let pin(p, r: 0.115) = {
    circle(p, radius: r, fill: white, stroke: (paint: INK, thickness: 0.8pt))
    circle(p, radius: r * 0.40, fill: INK, stroke: none)
  }

  let link-bar(p, q, w: 0.085) = {
    let ax = uni(sub(q, p))
    let nx = nrm(ax)
    line(add(p, scl(nx, w)), add(q, scl(nx, w)),
      stroke: (paint: INK, thickness: LW-DETAIL))
    line(sub(p, scl(nx, w)), sub(q, scl(nx, w)),
      stroke: (paint: INK, thickness: LW-DETAIL))
    line(add(p, scl(nx, w)), sub(p, scl(nx, w)),
      stroke: (paint: INK, thickness: LW-DETAIL))
    line(add(q, scl(nx, w)), sub(q, scl(nx, w)),
      stroke: (paint: INK, thickness: LW-DETAIL))
  }

  let bucket(pts, edge-a, edge-b, lip: none, n: 4, h: 0.20) = {
    line(..pts, close: true, fill: white,
      stroke: (paint: INK, thickness: LW-MEMBER))
    if lip != none {
      line(lip.at(0), lip.at(1), stroke: (paint: INK, thickness: LW-THIN))
    }
    let ax = uni(sub(edge-b, edge-a))
    let nx = nrm(ax)
    for i in range(n) {
      let c = mix(edge-a, edge-b, (i + 0.6) / (n + 0.6))
      line(sub(c, scl(ax, 0.07)), add(c, scl(nx, h)),
        stroke: (paint: INK, thickness: 0.8pt))
      line(add(c, scl(ax, 0.07)), add(c, scl(nx, h)),
        stroke: (paint: INK, thickness: 0.8pt))
    }
  }

  let dimension-arc(c, r, a0, a1) = {
    let at(a) = (c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a))
    arc(at(a0), radius: r, start: a0, stop: a1,
      stroke: (paint: INK, thickness: LW-THIN))
    line(at(a0 + 5deg), at(a0), mark: (end: ">", scale: 0.45),
      stroke: (paint: INK, thickness: LW-THIN))
    line(at(a1 - 5deg), at(a1), mark: (end: ">", scale: 0.45),
      stroke: (paint: INK, thickness: LW-THIN))
  }

  let tag(p, body, size: FS, anchor: "center", angle: 0deg) = content(
    p, anchor: anchor, angle: angle, text(size: size, fill: INK, body),
  )
  let lead(p, q) = line(p, q, stroke: (paint: INK, thickness: LW-THIN))

  // 底座 / 回转平台
  member(((0.20, 0.14), (1.60, 0.14), (1.60, 0.36), (0.20, 0.36)))
  member(((0.46, 0.32), (0.46, 3.30), (0.80, 3.30), (1.28, 2.58), (1.28, 0.32)),
    hatch: ((0.60, 0.60), (0.60, 1.25), 2, 0.42))
  member(((0.54, 3.26), (0.54, 3.74), (0.68, 3.82), (0.88, 3.58), (0.88, 3.26)))
  member(((1.20, 2.82), (1.56, 2.60), (1.20, 2.40)))
  line((0.62, 0.24), (1.18, 0.24),
    stroke: (paint: INK, thickness: LW-THIN, dash: "dashed"))
  circle(F, radius: 0.075, stroke: (paint: INK, thickness: LW-THIN))

  // 动臂及动臂液压缸
  member(BOOM-OUTLINE, hatch: ((6.40, 6.82), (6.40, 7.47), 5, 0.75))
  circle(A, radius: 0.30, fill: white,
    stroke: (paint: INK, thickness: LW-MEMBER))
  circle(P3, radius: 0.20, fill: white,
    stroke: (paint: INK, thickness: LW-MEMBER))
  cylinder(P1, P2, frac: 0.58, w: 0.15)

  // 铲斗、斗杆及液压缸
  bucket(BUCKET-OUTLINE, BUCKET-EDGE.at(0), BUCKET-EDGE.at(1),
    lip: (BUCKET-LIP.at(0), BUCKET-LIP.at(1)), n: 4, h: 0.20)
  member(ARM-OUTLINE)
  circle(P4, radius: 0.20, fill: white,
    stroke: (paint: INK, thickness: LW-MEMBER))
  circle(P5, radius: 0.23, fill: white,
    stroke: (paint: INK, thickness: LW-MEMBER))
  cylinder(P3, P4, frac: 0.66, w: 0.15)
  cylinder(P5, P6, frac: 0.62, w: 0.16, gap: 0.24)
  link-bar(D, P6, w: 0.085)
  link-bar(P6, E, w: 0.085)

  // 铰点销轴
  pin(A)
  pin(B)
  pin(C)
  pin(D, r: 0.10)
  pin(E, r: 0.10)
  pin(P1, r: 0.10)
  pin(P2, r: 0.10)
  pin(P3, r: 0.10)
  pin(P4, r: 0.10)
  pin(P5, r: 0.10)
  pin(P6, r: 0.095)

  // 转角弧
  dimension-arc(A, 1.30, 96deg, 176deg)
  dimension-arc(B, 1.20, 245deg, 305deg)

  // 零件名与引线
  tag((0.82, 2.05), [Base], size: FS-S, angle: 90deg)
  tag((4.62, 6.58), [Boom], angle: 33deg)
  tag((12.40, 4.95), [Arm], size: FS-S, angle: -70deg)
  tag((13.02, 1.16), [Bucket], size: FS-S)

  tag((2.02, 2.42), [Boom cylinder], size: FS-S, anchor: "west")
  lead((2.44, 2.52), (2.50, 3.80))
  tag((7.38, 9.02), [Arm cylinder], size: FS-S, angle: 13deg)
  tag((13.94, 5.16), [Bucket cylinder], size: FS-S, angle: -68deg)
  tag((14.35, 3.85), [Rocker], size: FS-S, anchor: "west")
  lead((14.30, 3.80), (13.45, 3.18))
  tag((14.35, 2.58), [Link], size: FS-S, angle: 90deg)
  lead((14.27, 2.50), (13.90, 2.40))

  // 铰点编号
  tag((0.25, 3.34), [A])
  tag((10.24, 6.44), [B])
  lead((10.32, 6.50), (10.92, 7.42))
  tag((12.22, 2.56), [C])
  lead((12.32, 2.52), (12.88, 2.38))
  tag((12.24, 3.34), [D])
  tag((14.12, 2.14), [E], anchor: "west")
  tag((0.90, 0.02), [F], size: FS-S)
  tag((1.70, 2.30), [P1], size: FS-S)
  tag((3.92, 5.96), [P2], size: FS-S)
  lead((3.84, 5.88), (3.68, 5.44))
  tag((4.98, 8.42), [P3], size: FS-S)
  lead((5.08, 8.36), (5.42, 8.10))
  tag((10.36, 9.54), [P4], size: FS-S)
  lead((10.52, 9.48), (10.80, 9.33))
  tag((12.56, 7.80), [P5], size: FS-S)
  lead((12.48, 7.74), (12.30, 7.53))
  tag((13.60, 3.46), [P6], size: FS-S)
  lead((13.70, 3.40), (13.90, 3.28))
})
