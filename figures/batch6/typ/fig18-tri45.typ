#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  line((0, 0), (0, 2.35), mark: (end: ">"))
  content((-.25, 2.4), [$y$])
  let A = (2.04, 4.36)
  let Bp = (5.18, 3.91)
  let Cp = (.40, 3.91)
  let B = (.51, 1.67)
  let C = (5.45, 1.67)
  let Ap = (2.18, .09)
  line(A, B, C, close: true)
  line(Ap, Bp, Cp, close: true)
  // dashed theta arcs at C', C, A'
  let r = .8
  let c1 = Cp
  arc((c1.at(0) + r * calc.cos(15deg), c1.at(1) + r * calc.sin(15deg)), radius: r, start: 15deg, stop: -87deg, stroke: (dash: "dashed"))
  let c2 = C
  arc((c2.at(0) + r * calc.cos(100deg), c2.at(1) + r * calc.sin(100deg)), radius: r, start: 100deg, stop: 190deg, stroke: (dash: "dashed"))
  let c3 = Ap
  arc((c3.at(0) + r * calc.cos(137deg), c3.at(1) + r * calc.sin(137deg)), radius: r, start: 137deg, stop: 26deg, stroke: (dash: "dashed"))
  content((1.15, 3.45), [$theta$])
  content((4.55, 2.15), [$theta$])
  content((2.3, 1.05), [$theta$])
  content((1.95, 4.55), [A])
  content((5.35, 3.95), [B#sym.prime])
  content((.05, 4.0), [C#sym.prime])
  content((.3, 1.45), [B])
  content((5.6, 1.6), [C])
  content((2.1, -.25), [A#sym.prime])
})
