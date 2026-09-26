#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  // axes
  line((0, 0), (5.5, 0), mark: (end: ">"))
  line((0, 0), (0, 4.4), mark: (end: ">"))
  content((-.15, -.3), [O])
  content((5.45, -.28), [$x$])
  content((.12, 4.45), [$y$])
  // rotation rays from A
  let A = (2.15, .8)
  let Z = (3.0, 3.36)
  let Zp = (4.6, 1.9)
  line(A, Z, stroke: (dash: "dashed"))
  line(A, Zp, stroke: (dash: "dashed"))
  circle(A, radius: .06, fill: black)
  content((2.05, .5), [A])
  content((3.0, 3.5), [Z])
  content((4.75, 1.8), [Z#sym.prime])
  // angle arc, arrow toward Z' ray
  let r = 1.45
  let a0 = 71.6deg
  arc((A.at(0) + r * calc.cos(a0), A.at(1) + r * calc.sin(a0)), radius: r, start: a0, stop: 24.2deg, mark: (end: ">"))
  content((3.15, 2.15), [$alpha$])
  // rotation direction arrow
  bezier((1.45, .49), (.29, 1.73), (1.75, 1.15), (1.05, 1.85), mark: (end: ">"))
  content((.5, 1.9), [+])
})
