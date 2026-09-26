#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  line((0, 0), (4.3, 0), mark: (end: ">"))
  line((0, 0), (0, 3.4), mark: (end: ">"))
  let A = (3.64, 3.13)
  let B = (.91, 1.91)
  let C = (3.91, .80)
  let Ap = (2.40, 1.36)
  let G = (2.82, 1.98)
  line(A, B, C, close: true)
  line(A, Ap)
  for p in (A, B, C, Ap, G) {
    circle(p, radius: .06, fill: black)
  }
  content((-.2, -.3), [O])
  content((4.25, -.28), [$x$])
  content((.08, 3.45), [$y$])
  content((3.6, 3.3), [A])
  content((.6, 1.9), [B])
  content((3.95, .6), [C])
  content((2.2, 1.1), [A#sym.prime])
  content((2.95, 2.0), [G])
})
