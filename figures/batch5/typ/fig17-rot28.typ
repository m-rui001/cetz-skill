#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  line((0, 0), (4.7, 0), mark: (end: ">"))
  line((0, 0), (0, 4.3), mark: (end: ">"))
  content((-.2, -.3), [O])
  content((4.75, -.3), [$x$])
  content((.08, 4.4), [$y$])
  let A = (1.53, 4.31)
  let Z = (3.51, 4.80)
  let C = (4.96, 2.22)
  let Cp = (5.96, 3.33)
  let B = (.51, 1.47)
  let Bp = (3.62, .58)
  line(A, B)
  line(A, C)
  line(B, C)
  line(Z, B)
  line(Z, Bp)
  line(Z, C)
  line(Z, Cp)
  // dashed rotation arcs about Z, arrows at images B', C'
  let r1 = 4.35
  let a1 = -132deg
  arc((Z.at(0) + r1 * calc.cos(a1), Z.at(1) + r1 * calc.sin(a1)), radius: r1, start: a1, stop: -88.5deg, stroke: (dash: "dashed"), mark: (end: ">"))
  let r2 = 2.9
  let a2 = -60.7deg
  arc((Z.at(0) + r2 * calc.cos(a2), Z.at(1) + r2 * calc.sin(a2)), radius: r2, start: a2, stop: -31deg, stroke: (dash: "dashed"), mark: (end: ">"))
  for p in (A, Z, C, Cp, B, Bp) {
    circle(p, radius: .06, fill: black)
  }
  content((1.4, 4.5), [A])
  content((3.45, 5.0), [Z])
  content((6.1, 3.4), [C#sym.prime])
  content((4.9, 1.9), [C])
  content((.3, 1.3), [B])
  content((3.85, .55), [B#sym.prime])
  content((1.8, .95), [$2 theta$])
  content((5.45, 3.0), [$theta$])
})
