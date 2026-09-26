#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let O = (0, 0)
  let A0 = (1.15, 2.0)
  let Z = (2.55, 2.62)
  let A1 = (2.35, .95)
  // axes
  line(O, (4.1, 0), mark: (end: ">"))
  line(O, (0, 3.3), mark: (end: ">"))
  content((4.25, -.3), [$x$])
  content((-.35, 3.35), [$y$])
  content((-.32, -.35), [$O$])
  // ray through A0 and Z, extended
  let d = (Z.at(0) - A0.at(0), Z.at(1) - A0.at(1))
  line((A0.at(0) - .95 * d.at(0), A0.at(1) - .95 * d.at(1)), A0, stroke: (dash: "dashed"))
  line(A0, (Z.at(0) + 1.15 * d.at(0), Z.at(1) + 1.15 * d.at(1)), mark: (end: ">"))
  // OA0, OA1
  line(O, A0)
  line(O, A1)
  circle(Z, radius: .06, fill: black)
  circle(A1, radius: .06, fill: black)
  content((.95, 2.2), [$A_0$])
  content((2.5, 2.3), [$Z$])
  content((2.5, .8), [$A_1$])
})
