#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let O = (0, 0)
  let Ct = (2.6, 4.3)
  let At = (4.35, .5)
  let th = (thickness: 1.5pt)
  // axes
  line(O, (0, 5.1), mark: (end: ">"))
  content((-.4, 4.85), [$y$])
  // horizontal projection line with left-pointing arrow at C tip
  line((4.6, Ct.at(1)), (Ct.at(0) + .12, Ct.at(1)), mark: (end: ">"))
  // dashed vertical through A tip
  line((At.at(0), 4.6), (At.at(0), -.35), stroke: (dash: "dashed"))
  // vectors
  line(O, Ct, stroke: th, mark: (end: ">"))
  line(O, At, stroke: th, mark: (end: ">"))
  line(At, Ct, stroke: th, mark: (end: ">"))
  content((1.15, 2.35), [$arrow(C)$])
  content((2.0, -.05), [$arrow(A)$])
  content((3.05, 2.25), [$arrow(B)$])
  // top equation with squiggle arrow down to the horizontal line
  content((1.1, 5.5), [$C_x hat(i) = A_x hat(i) + B_x hat(i)$])
  bezier((2.55, 5.15), (2.5, 4.65), (2.75, 5.0), (2.3, 4.8), mark: (end: ">"))
  // right label
  content((4.95, 3.1), [$B_x hat(i)$])
  content((4.95, 2.5), [is negative])
  bezier((4.62, 3.35), (4.42, 4.25), (4.75, 3.5), (4.3, 4.1), mark: (end: ">"))
})
