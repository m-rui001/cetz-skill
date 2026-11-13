#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  line((0, 0), (4.8, 0), stroke: (paint: black, thickness: 0.8pt), mark: (end: "stealth", fill: black))
  line((0, 0), (0, 3.33), stroke: (paint: black, thickness: 0.8pt), mark: (end: "stealth", fill: black))
  line((-1.73, -1.31), (3.73, 3.24), stroke: (paint: black, thickness: 0.8pt), mark: (start: "stealth", end: "stealth", fill: black))
  let Z = (2.27, 1.78)
  line(Z, (2.27, 0), stroke: (paint: black, thickness: 0.8pt, dash: "dashed"), mark: (end: "stealth", fill: black))
  circle(Z, radius: .06, fill: black)
  let r = 1.0
  arc((r * calc.cos(90deg), r * calc.sin(90deg)), radius: r, start: 90deg, stop: 217deg, stroke: (paint: black, thickness: 0.8pt), mark: (end: "stealth", fill: black))
  content((-.2, 3.4), [$y$])
  content((4.75, -.25), [$x$])
  content((-1.8, -1.55), [$a$])
  content((-.2, -.3), [O])
  content((2.1, 2.18), [Z])
  content((2.85, 1.66), [$(x, y)$])
  content((1.15, 1.35), [$r$])
  content((-.72, 1.05), [$theta$])
  content((2.58, .6), [$y$])
  content((1.3, -.25), [$x$])
})
