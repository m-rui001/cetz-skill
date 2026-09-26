#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 12pt)

#canvas({
  import draw: *

  let t = (thickness: 1.3pt)
  let b = 1.0
  let h = 2.6
  let P = 2.2
  let box = (cx) => {
    line((cx - b/2, 0), (cx - b/2, h), stroke: t)
    line((cx - b/2, h), (cx + b/2, h), stroke: t)
    line((cx + b/2, h), (cx + b/2, 0), stroke: t)
  }

  // baseline + central axis
  line((-6.0, 0), (8.4, 0), stroke: t)
  line((0, -1.0), (0, 4.05), stroke: t)

  for c in (-4.4, -2.2, 0.0, 2.2, 4.4, 6.6) { box(c) }

  // period 1/nu_0 between the centres of box -2.2 and box 0
  let yd = 3.55
  line((-2.2, yd - 0.38), (-2.2, yd + 0.38), stroke: t)
  line((-2.2, yd), (-1.45, yd), stroke: t, mark: (end: ">"))
  content((-0.62, yd), anchor: "center", [$1/nu_0$])
  line((0.72, yd), (0.08, yd), stroke: t, mark: (end: ">"))

  // width b of box -2.2
  let yb = 1.62
  line((-3.25, yb), (-2.78, yb), stroke: t, mark: (end: ">"))
  content((-2.2, yb), anchor: "center", [$b$])
  line((-1.12, yb), (-1.66, yb), stroke: t, mark: (end: ">"))

  // height h of box 2.2, broken around the label
  let xh = 2.2
  line((xh, 1.72), (xh, 2.45), stroke: t, mark: (end: ">"))
  line((xh, 1.18), (xh, 0.18), stroke: t, mark: (end: ">"))
  content((xh, 1.45), anchor: "center", [$h$])
})
