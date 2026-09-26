#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  line((0, 0), (4.8, 0), mark: (end: ">"))
  line((0, 0), (0, 3.33), mark: (end: ">"))
  line((-1.73, -1.31), (3.73, 3.24), mark: (start: "<", end: ">"))
  let Z = (2.27, 1.78)
  line(Z, (2.27, 0), stroke: (dash: "dashed"))
  circle(Z, radius: .06, fill: black)
  let r = 1.0
  arc((r * calc.cos(10deg), r * calc.sin(10deg)), radius: r, start: 10deg, stop: 217deg, mark: (end: ">"))
  content((-.2, 3.4), [$y$])
  content((4.75, -.25), [$x$])
  content((-1.8, -1.55), [$a$])
  content((-.2, -.3), [O])
  content((2.15, 2.0), [Z])
  content((2.55, 1.66), [$(x, y)$])
  content((1.15, 1.35), [$r$])
  content((-.55, .85), [$theta$])
  content((2.4, .6), [$y$])
  content((1.3, -.25), [$x$])
})
