#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 12pt)

#canvas({
  import draw: *

  let t = (thickness: 1.25pt)
  let sp = 2.3         // comb period
  let bw = 0.48        // pulse width
  let bh = 1.69        // pulse height

  // axes
  line((-9.3, 0), (9.2, 0), stroke: t)
  line((0, -0.4), (0, 2.5), stroke: t)

  // open-bottomed pulses
  for k in range(-2, 4) {
    let c = k * sp
    line((c - bw/2, 0), (c - bw/2, bh), stroke: t)
    line((c + bw/2, 0), (c + bw/2, bh), stroke: t)
    line((c - bw/2, bh), (c + bw/2, bh), stroke: t)
  }

  // height h, broken double-headed arrow at the left
  let xm = -7.6
  line((xm - 0.6, bh), (xm + 0.6, bh), stroke: t)
  line((xm, bh + 1.0), (xm, bh + 0.18), stroke: t, mark: (end: ">"))
  line((xm, -1.15), (xm, -0.18), stroke: t, mark: (end: ">"))
  content((xm, 0.9), anchor: "center", [$bold(h)$])

  content((2.3, -0.53), anchor: "center", [$x$])
  line((2.95, -0.53), (4.35, -0.53), stroke: t, mark: (end: ">"))
})
