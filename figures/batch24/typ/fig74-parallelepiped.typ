#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 9.5pt)

#canvas({
  import draw: *

  let th = (thickness: 1.3pt)
  let tv = (thickness: 2.1pt)
  let td = (dash: (array: (7pt, 5pt)), thickness: 1.2pt)
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))

  let O = (0, 0)
  let A = (-1.65, 2.10)
  let B = (2.95, 0.15)
  let C = (1.85, 1.35)
  let AB = add(A, B)
  let AC = add(A, C)
  let ABC = add(A, add(B, C))
  let BC = add(B, C)
  let K = (0.02, 3.75)

  // plane containing B and C
  line((-4.65, 0.0 - 1.10), (2.65, 0.0 - 1.10), stroke: th)
  line((2.65, 0.0 - 1.10), (6.80, 2.37), stroke: th)
  line((6.80, 2.37), (0.65, 2.37), stroke: th)
  line((0.65, 2.37), (-4.65, 0.0 - 1.10), stroke: th)

  // hidden edges of the parallelepiped
  line(B, BC, stroke: td)
  line(C, BC, stroke: td)
  line(A, AB, stroke: td)
  line(A, AC, stroke: td)
  line(AC, ABC, stroke: td)
  line(AB, ABC, stroke: td)
  line(AB, B, stroke: td)
  line(AC, C, stroke: td)
  line(ABC, BC, stroke: td)

  // vectors
  line(O, K, stroke: tv, mark: (end: ">"))
  line(O, A, stroke: tv, mark: (end: ">"))
  line(O, B, stroke: tv, mark: (end: ">"))
  line(O, C, stroke: tv, mark: (end: ">"))

  // angle phi between the vertical and A
  arc((0, 0.7), radius: 0.7, start: 90deg, stop: 128deg, stroke: th)

  // curly brace marking the height
  bezier((0.38, 2.10), (0.10, 1.05), (0.38, 1.75), (0.32, 1.28), stroke: th)
  bezier((0.10, 1.05), (0.38, 0.02), (0.32, 0.82), (0.38, 0.35), stroke: th)

  content((-0.15, 4.15), [$arrow(B) times arrow(C)$])
  content((1.55, 4.1), anchor: "west", [Parallelepiped])
  content((-2.3, 0.0 - 0.72), [Plane containing both $arrow(B)$ and $arrow(C)$])
  content((-1.95, 1.8), anchor: "east", [$arrow(A)$])
  content((2.5, 0.0 - 0.45), [$arrow(B)$])
  content((1.95, 0.6), [$arrow(C)$])
  content((0.52, 2.15), anchor: "west", [Height is])
  content((0.52, 1.68), anchor: "west", [$abs(arrow(A)) cos(phi)$])
  content((3.55, 1.0), [Area of base])
  content((3.55, 0.48), [is $arrow(B) times arrow(C)$])
  content((-0.28, 1.0), anchor: "east", [$phi$])
})
