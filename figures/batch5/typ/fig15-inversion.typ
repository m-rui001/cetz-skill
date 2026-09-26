#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  line((0, 0), (4.6, 0), mark: (end: ">"))
  line((0, 0), (0, 4.7), mark: (end: ">"))
  content((-.2, -.3), [O])
  content((4.55, -.3), [$x$])
  content((.08, 4.75), [$y$])
  line((-.2, 1.45), (4.9, 3.65), mark: (end: ">"))
  let Z = (.16, 1.6)
  let M = (1.44, 2.22)
  let Zp = (4.0, 3.2)
  circle(Z, radius: .06, fill: black)
  circle(M, radius: .06, fill: black)
  circle(Zp, radius: .06, fill: black)
  content((.1, 1.25), [Z])
  content((1.4, 1.85), [M])
  content((3.9, 2.85), [Z#sym.prime])
  content((4.75, 3.85), [d])
})
