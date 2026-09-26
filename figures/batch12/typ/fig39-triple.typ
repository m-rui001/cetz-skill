#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let tv = (thickness: 1.8pt)
  let th = (thickness: .9pt)
  let td = (dash: "dashed", thickness: .9pt)
  // plane containing B and C
  line((-3.5, -2.0), (2.1, -2.0), (5.3, 1.45), (-.3, 1.45), close: true, stroke: th)
  let O = (.75, -.1)
  // right-angle mark at O
  line((O.at(0) - .22, O.at(1) + .05), (O.at(0) - .17, O.at(1) + .25), (O.at(0) + .03, O.at(1) + .3), stroke: th)
  // B x C out of the plane
  line(O, (.78, 2.75), stroke: tv, mark: (end: ">"))
  content((.1, 2.95), anchor: "west", [$arrow(B) times arrow(C)$])
  // A (not in the plane) with dashed drop
  line(O, (1.5, 1.5), stroke: tv, mark: (end: ">"))
  line((1.5, 1.5), (1.62, -.62), stroke: td)
  line(O, (1.62, -.62), stroke: td)
  content((1.72, 1.25), anchor: "west", [$arrow(A)$])
  // C and B in the plane
  line(O, (2.75, .85), stroke: tv, mark: (end: ">"))
  content((2.95, .3), anchor: "west", [$arrow(C)$])
  line(O, (3.45, .05), stroke: tv, mark: (end: ">"))
  content((3.55, -.5), anchor: "west", [$arrow(B)$])
  // A x (B x C) back in the plane
  line(O, (-1.45, -1.15), stroke: tv, mark: (end: ">"))
  content((-2.75, -1.3), anchor: "west", [$arrow(A) times (arrow(B) times arrow(C))$])
  content((-2.95, -1.9), anchor: "west", [(same plane as $arrow(B)$ and $arrow(C)$)])
  content((2.8, 2.45), anchor: "west", [Plane containing both $arrow(B)$ and $arrow(C)$])
  content((3.6, 1.85), anchor: "west", [(but not $arrow(A)$)])
})
