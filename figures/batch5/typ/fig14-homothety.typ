#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  line((0, 0), (5.3, 0), mark: (end: ">"))
  line((0, 0), (0, 4.0), mark: (end: ">"))
  content((-.2, -.3), [O])
  content((5.25, -.3), [$x$])
  content((.08, 4.05), [$y$])
  let A = (.45, 1.45)
  let Z = (2.68, 2.08)
  let Zp = (4.18, 2.45)
  line(A, (5.1, 2.78), mark: (end: ">"))
  circle(A, radius: .06, fill: black)
  circle(Z, radius: .06, fill: black)
  circle(Zp, radius: .06, fill: black)
  content((.35, 1.1), [A])
  content((2.55, 1.72), [Z])
  content((4.1, 2.1), [Z#sym.prime])
})
