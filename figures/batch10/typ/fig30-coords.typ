#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let O = (0, 0)
  // axes
  line(O, (7.4, 0), mark: (end: ">"))
  line(O, (0, 4.9), mark: (end: ">"))
  content((7.6, -.35), [$x$])
  content((.25, 4.6), [$y$])
  // basis vectors (thick)
  line(O, (1.0, 2.25), stroke: (thickness: 1.6pt), mark: (end: ">"))
  line(O, (2.15, 0), stroke: (thickness: 1.6pt), mark: (end: ">"))
  // vector A
  line(O, (6.3, 1.8), mark: (end: ">"))
  content((.55, 2.5), [$arrow(e)_1$])
  content((1.6, 3.5), [$(1, 3)$])
  content((1.7, -.55), [$arrow(e)_2$])
  content((3.2, -.5), [$(4, 0)$])
  content((2.9, 1.5), [$arrow(A)$])
  content((6.75, 1.95), [$(7, 2)$])
})
