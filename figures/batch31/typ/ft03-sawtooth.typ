#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 12pt)

#canvas({
  import draw: *

  let t = (thickness: 1.25pt)
  let P = 2.6
  let hh = 1.5

  // axes
  line((-7.3, 0), (8.4, 0), stroke: t)
  line((0, -2.7), (0, 3.4), stroke: t)

  // sawtooth: rising ramp of height 2h over one period, zero crossing at x = 0
  for k in range(-2, 3) {
    let a = k * P - P/2
    line((a, -hh), (a + P, hh), stroke: t)
    line((a + P, hh), (a + P, -hh), stroke: t)
  }
  // truncated tooth at the right edge
  line((6.5, -hh), (8.4, 0.69), stroke: t)

  // amplitude h, marked between the peak level and the axis
  let xm = -7.0
  line((xm - 0.42, hh), (xm + 0.42, hh), stroke: t)
  line((xm, 2.75), (xm, hh + 0.12), stroke: t, mark: (end: ">"))
  line((xm, -1.55), (xm, -0.12), stroke: t, mark: (end: ">"))
  content((xm, hh - 0.32), anchor: "north", [$h$])

  // period P, marked between two consecutive falls
  let y1 = -2.55
  let p1 = P/2
  let p2 = p1 + P
  line((p1, -2.05), (p1, y1 - 0.55), stroke: t)
  line((p2, -2.05), (p2, y1 - 0.55), stroke: t)
  line((p1 + 0.95, y1), (p1 + 0.1, y1), stroke: t, mark: (end: ">"))
  line((p2 - 0.95, y1), (p2 - 0.1, y1), stroke: t, mark: (end: ">"))
  content(((p1 + p2) / 2, y1), anchor: "center", [$P$])

  content((6.9, -0.42), anchor: "north", [$x$])
  line((7.45, -0.24), (8.45, -0.24), stroke: (thickness: 2.2pt), mark: (end: ">"))
})
