#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 10pt)

#canvas({
  import draw: *

  let thin = (thickness: 1.15pt, paint: luma(32%))
  let dsh = (thickness: 1.0pt, dash: (array: (6pt, 5pt)), paint: luma(32%))

  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let mul = (p, k) => (p.at(0) * k, p.at(1) * k)
  let unit = (a) => (calc.cos(a), calc.sin(a))
  let perp = (v) => (0.0 - v.at(1), v.at(0))

  let head = (c, ang, tipR, baseR, wid) => {
    let u = unit(ang)
    let n = perp(u)
    let tip = add(c, mul(u, tipR))
    let b1 = add(add(c, mul(u, baseR)), mul(n, wid))
    let b2 = add(add(c, mul(u, baseR)), mul(n, 0.0 - wid))
    line(path: true, tip, b1, b2, tip, fill: luma(22%), stroke: none)
  }

  // shaft spans [r1, r2]; arrowhead sits at tipR; dashed tail runs to r2+tail
  let spokes = (c, ang0, tipR, r1, r2, wid, tail) => {
    for i in range(8) {
      let a = ang0 + i * 45deg
      let u = unit(a)
      line(add(c, mul(u, r1)), add(c, mul(u, r2)), stroke: thin)
      head(c, a, tipR, r1, wid)
      line(add(c, mul(u, r2)), add(c, mul(u, r2 + tail)), stroke: dsh)
    }
  }

  // q1: positive source, arrows point outward
  let q1 = (1.7, 8.5)
  for i in range(8) {
    let a = 8deg + i * 45deg
    let u = unit(a)
    line(add(q1, mul(u, 0.22)), add(q1, mul(u, 1.30)), stroke: thin)
    head(q1, a, 1.72, 1.30, 0.17)
    line(add(q1, mul(u, 1.72)), add(q1, mul(u, 2.45)), stroke: dsh)
  }
  content(q1, [$+$], anchor: "center")

  // q2: negative source, fat arrowheads point inward
  let q2 = (1.4, 2.3)
  spokes(q2, 12deg, 0.24, 1.02, 1.90, 0.24, 0.62)
  content(q2, [$-$], anchor: "center")

  // q3: negative source, larger
  let q3 = (10.0, 6.3)
  spokes(q3, 20deg, 0.30, 1.28, 2.35, 0.29, 0.75)
  content(q3, [$-$], anchor: "center")

  content((4.05, 6.55), anchor: "west", [$q_1$ field])
  content((2.75, 3.65), anchor: "west", [$q_2$ field])
  content((7.15, 4.55), anchor: "west", [$q_3$ field])

  // test point
  let tp = (5.55, 4.75)
  circle(tp, radius: .22, stroke: (thickness: 1.2pt, paint: luma(32%)))
  line(add(tp, (0.20, 0.12)), (6.35, 5.05), stroke: thin, mark: (end: ">"))
  bezier((6.95, 3.00), (6.45, 3.45), (6.80, 4.00), (5.78, 4.55),
         stroke: (thickness: 1.1pt, paint: luma(35%)), mark: (end: ">"))

  content((7.05, 2.45), anchor: "west", [You want to determine])
  content((7.05, 1.95), anchor: "west", [the total electric force])
  content((7.05, 1.45), anchor: "west", [at this point])
})
