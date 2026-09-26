#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let O = (0, 0)
  let A = (2.6, 1.05)
  let Z = (1.15, 1.9)
  let Zp = (Z.at(0) + A.at(0), Z.at(1) + A.at(1))
  // axes
  line(O, (4.3, 0), mark: (end: ">"))
  line(O, (0, 3.1), mark: (end: ">"))
  content((4.45, -.15), [$x$])
  content((-.35, 3.15), [$y$])
  content((-.3, -.35), [$O$])
  // dashed OA and OZ
  line(O, A, stroke: (dash: "dashed"))
  line(O, Z, stroke: (dash: "dashed"))
  // ZZ' solid
  line(Z, Zp)
  // dots
  circle(A, radius: .06, fill: black)
  circle(Z, radius: .06, fill: black)
  circle(Zp, radius: .06, fill: black)
  content((2.8, .95), [$A$])
  content((.95, 1.95), [$Z$])
  content((3.6, 3.1), [$Z'$])
})
