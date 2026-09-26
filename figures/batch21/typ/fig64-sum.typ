#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let tv = (thickness: 2pt)
  let O = (0, 0)
  let A = (2.05, .72)
  let P = (2.6, 4.6)
  line((-.55, 0), (5.3, 0), stroke: th, mark: (end: ">"))
  line((0, -.55), (0, 5.7), stroke: th, mark: (end: ">"))
  content((5.45, -.5), anchor: "west", [$x$])
  content((-.3, 5.85), anchor: "east", [$y$])
  line(O, A, stroke: tv, mark: (end: ">"))
  line(A, P, stroke: tv, mark: (end: ">"))
  line(O, P, stroke: tv, mark: (end: ">"))
  content((1.5, 1.15), anchor: "east", [$arrow(A)$])
  content((2.32, 2.9), anchor: "east", [$arrow(B)$])
  content((.5, 5.1), anchor: "west", [$arrow(C) = arrow(A) + arrow(B)$])
  bezier((.62, 4.75), (1.82, 3.42), (-.35, 4.1), (1.15, 3.05),
         stroke: th, mark: (end: ">"))
  bezier((1.15, 4.72), (1.42, 2.5), (.45, 3.9), (1.05, 3.1),
         stroke: th, mark: (end: ">"))
  line((2.28, .06), (2.28, .66), stroke: th, mark: (start: "<", end: ">"))
  bezier((2.9, -.85), (2.32, -.05), (3.5, -.55), (2.15, -.4), stroke: th,
         mark: (end: ">"))
  content((3.05, -1.05), anchor: "west", [$A_y hat(j)$])
  line((2.95, 0), (2.95, 4.6), stroke: th)
  line((2.83, 4.6), (3.07, 4.6), stroke: th)
  line((2.83, 0), (3.07, 0), stroke: th)
  bezier((3.15, .78), (3.5, 2.66), (3.48, 1.05), (3.48, 2.35), stroke: th)
  bezier((3.5, 2.66), (3.15, 4.55), (3.48, 2.95), (3.48, 4.3), stroke: th)
  content((3.72, 2.7), anchor: "west", [$B_y hat(j)$])
  content((4.55, 2.35), anchor: "west", [$C_y hat(j) = A_y hat(j) + B_y hat(j)$])
  content((1.3, -1.9), [(a)])
})
