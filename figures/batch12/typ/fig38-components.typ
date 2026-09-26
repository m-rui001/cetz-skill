#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let tv = (thickness: 1.8pt)
  let th = (thickness: .9pt)
  let O = (0, 0)
  let A = (2.55, .62)
  let Ct = (2.0, 3.25)
  let gx = 2.95
  // axes
  line((-.55, 0), (5.5, 0), stroke: th, mark: (end: ">"))
  line((0, -.65), (0, 4.35), stroke: th, mark: (end: ">"))
  content((5.65, -.35), anchor: "west", [$x$])
  content((-.18, 4.4), anchor: "east", [$y$])
  // vectors
  line(O, A, stroke: tv, mark: (end: ">"))
  line(A, Ct, stroke: tv, mark: (end: ">"))
  content((1.3, .85), [$arrow(A)$])
  content((2.1, 2.0), anchor: "east", [$arrow(B)$])
  content((.5, 4.05), anchor: "west", [$arrow(C) = arrow(A) + arrow(B)$])
  // curved pointer from the C label onto the resultant
  bezier((.95, 3.6), (2.05, 2.5), (.5, 2.95), (1.55, 2.4))
  line((1.92, 2.62), (2.05, 2.5), stroke: th, mark: (end: ">"))
  // projection guide + ticks
  line((gx, 0), (gx, 3.25), stroke: th)
  line((gx - .2, 3.25), (gx + .2, 3.25), stroke: th)
  line((gx - .2, .62), (gx + .2, .62), stroke: th)
  // brace over the whole C_y height
  let br = (x, y0, y1, w) => {
    let ym = (y0 + y1) / 2
    bezier((x, y1), (x + w, ym), (x + w * .95, y1), (x + w, ym + (y1 - ym) * .45))
    bezier((x + w, ym), (x, y0), (x + w, ym - (ym - y0) * .45), (x + w * .95, y0))
  }
  br(3.2, -.05, 3.25, .3)
  content((3.72, 1.95), anchor: "west", [$B_y hat(j)$])
  content((4.65, 1.6), anchor: "west", [$C_y hat(j) = A_y hat(j) + B_y hat(j)$])
  // squiggle pointer to the A_y part
  bezier((3.05, -1.15), (2.72, .28), (3.5, -.55), (2.4, -.25))
  line((2.72, .1), (2.72, .28), stroke: th, mark: (end: ">"))
  content((3.15, -1.55), anchor: "west", [$A_y hat(j)$])
  content((1.15, -2.35), [(a)])
})
