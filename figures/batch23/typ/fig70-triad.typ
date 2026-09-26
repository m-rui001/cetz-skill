#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *

  let th = (thickness: 1.5pt)
  let tt = (thickness: 1.1pt)
  let tb = (thickness: 1.9pt)
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let mul = (s, p) => (s * p.at(0), s * p.at(1))

  let tick = (p, d, s) => line(add(p, mul(-s, d)), add(p, mul(s, d)), stroke: tt)

  // ---------- panel (a) ----------
  let O = (0, 0)
  let ux = (-0.68, 0.0 - 0.73)
  let px = (0.0 - 0.73, 0.68)

  line(O, (0, 2.65), stroke: tt)
  line(O, (3.45, 0), stroke: tt)
  line(O, mul(2.55, ux), stroke: tt)
  tick((0, 1), (1, 0), .13)
  tick((0, 2), (1, 0), .13)
  tick((1, 0), (0, 1), .13)
  tick((2, 0), (0, 1), .13)
  tick(mul(1, ux), px, .13)

  line(O, (0, 2), stroke: tb, mark: (end: ">"))
  line(O, (2, 0), stroke: tb, mark: (end: ">"))
  line(O, mul(2, ux), stroke: tb, mark: (end: ">"))

  content((-0.26, 2.0), anchor: "east", [2])
  content((-0.26, 1.0), anchor: "east", [1])
  content((1.0, 0.28), [1])
  content((2.0, 0.28), [2])
  content((-0.5, 0.0 - 0.95), anchor: "west", [1])
  content((0, 2.85), [$z$])
  content((3.6, 0.0 - 0.08), anchor: "west", [$y$])
  content((-1.85, 0.0 - 2.0), [$x$])
  content((1.25, 1.9), anchor: "west", [$2 hat(k)$])
  content((1.75, 0.0 - 1.0), anchor: "west", [$2 hat(j)$])
  content((-1.42, 0.36), anchor: "east", [$2 hat(i)$])

  bezier((1.4, 1.72), (0.42, 1.35), (1.15, 1.42), (0.62, 1.28), stroke: tt, mark: (end: ">"))
  bezier((1.5, 0.0 - 1.02), (0.93, 0.0 - 0.35), (1.25, 0.0 - 0.55), (0.95, 0.0 - 0.42), stroke: tt, mark: (end: ">"))
  bezier((-1.32, 0.18), (-1.04, 0.0 - 0.47), (-1.42, 0.0 - 0.2), (-1.22, 0.0 - 0.42), stroke: tt, mark: (end: ">"))
  content((0, 0.0 - 2.6), [(a)])

  // ---------- panel (b) ----------
  let B = (8.6, 0)
  let bx = (-0.62, 0.0 - 0.62)
  let pbx = (0.0 - 0.62, 0.62)
  let addb = (p) => add(B, p)

  line(B, addb((0, 2.7)), stroke: tt)
  line(B, addb((2.95, 0)), stroke: tt)
  line(B, addb(mul(1.9, bx)), stroke: tt)
  tick(addb((0, 1)), (1, 0), .13)
  tick(addb((0, 2)), (1, 0), .13)
  tick(addb((1.08, 0)), (0, 1), .13)
  tick(addb((2.04, 0)), (0, 1), .13)
  tick(addb(mul(1, bx)), pbx, .13)

  line(B, addb((0.62, 1.31)), stroke: tb, mark: (end: ">"))
  line(B, addb((2.0, 1.04)), stroke: tb, mark: (end: ">"))
  line(B, addb((0.0 - 1.77, 0.19)), stroke: tb, mark: (end: ">"))

  content(addb((-0.26, 2.0)), anchor: "east", [2])
  content(addb((-0.26, 1.0)), anchor: "east", [1])
  content(addb((1.08, 0.28)), [1])
  content(addb((2.04, 0.28)), [2])
  content(addb((-0.45, 0.0 - 0.85)), anchor: "west", [1])
  content(addb((0, 2.9)), [$z$])
  content(addb((3.1, 0.0 - 0.08)), anchor: "west", [$y$])
  content(addb((-1.1, 0.0 - 1.35)), [$x$])
  content(addb((1.85, 1.95)), anchor: "west", [$arrow(e_3)$])
  content(addb((2.45, 0.0 - 0.45)), anchor: "west", [$arrow(e_2)$])
  content(addb((-1.9, 0.0 - 0.6)), anchor: "east", [$arrow(e_1)$])

  bezier(addb((1.8, 1.78)), addb((0.85, 1.78)), addb((1.55, 1.5)), addb((1.1, 1.62)), stroke: tt, mark: (end: ">"))
  bezier(addb((2.42, 0.0 - 0.28)), addb((1.3, 0.72)), addb((2.2, 0.15)), addb((1.5, 0.5)), stroke: tt, mark: (end: ">"))
  bezier(addb((-1.62, 0.0 - 0.45)), addb((-1.12, 0.0 - 0.1)), addb((-1.5, 0.0 - 0.28)), addb((-1.22, 0.0 - 0.12)), stroke: tt, mark: (end: ">"))
  content(addb((0, 0.0 - 2.6)), [(b)])
})
