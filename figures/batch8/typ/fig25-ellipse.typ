#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let O = (0, 0)
  let At = (1.35, 3.15)
  let Z = (3.55, 3.6)
  let Bt = (2.7, .75)
  let A = (2.25, 2.55)
  let B = (1.85, 1.25)
  // axes
  line(O, (3.9, 0))
  line(O, (0, 3.9), mark: (end: ">"))
  content((4.05, -.3), [$x$])
  content((-.4, 3.7), [$y$])
  content((-.35, -.35), [$O$])
  // parallelogram O At Z Bt
  line(O, At)
  line(At, Z)
  line(Z, Bt)
  line(Bt, O)
  // inner vectors
  line(O, A)
  line(O, B)
  circle(A, radius: .06, fill: black)
  circle(B, radius: .06, fill: black)
  // angle arcs
  let r1 = .95
  let aAt = calc.atan2(At.at(1) - O.at(1), At.at(0) - O.at(0))
  arc((r1 * calc.cos(aAt), r1 * calc.sin(aAt)), radius: r1, start: aAt, stop: 90deg, stroke: (dash: "dashed"))
  let aB = calc.atan2(B.at(1), B.at(0))
  let aBt = calc.atan2(Bt.at(1), Bt.at(0))
  let r2 = .75
  arc((r2 * calc.cos(aBt), r2 * calc.sin(aBt)), radius: r2, start: aBt, stop: aB, stroke: (dash: "dashed"))
  content((.55, 3.0), [$omega t$])
  content((1.55, .95), [$-omega t$])
  // point labels
  content((1.15, 3.35), [$A_t$])
  content((3.6, 3.75), [$Z$])
  content((2.55, .4), [$B_t$])
  content((2.35, 2.75), [$A$])
  content((1.95, 1.35), [$B$])
})
