#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 11pt)

#canvas({
  import draw: *

  let te = (thickness: 1.0pt)
  let tw = (thickness: 2.7pt)
  let c = (0.0, 0.35)

  let ell = (rx, ry, a0, a1, n) => {
    let pts = ()
    for i in range(n) {
      let t = a0 + (a1 - a0) * i / (n - 1)
      pts.push((c.at(0) + rx * calc.cos(t), c.at(1) + ry * calc.sin(t)))
    }
    pts
  }

  // wire
  line((0, -3.7), (0, 3.1), stroke: tw, mark: (end: ">"))
  content((0.42, 2.55), anchor: "west", [$arrow(I)$])

  for rx in (0.42, 0.86, 1.34, 1.90, 2.52) {
    let ry = rx * 0.265
    line(path: true, close: true, ..ell(rx, ry, 0deg, 360deg, 73), stroke: te)
    // tangential heads: left side sweeps down-left, right side up-right
    line(path: true, ..ell(rx, ry, 148deg, 170deg, 7), stroke: te, fill: luma(18%), mark: (end: ">"))
    line(path: true, ..ell(rx, ry, 328deg, 350deg, 7), stroke: te, fill: luma(18%), mark: (end: ">"))
  }

  content((-2.62, -0.55), anchor: "north", [$arrow(B)$])
  content((2.62, -0.55), anchor: "north", [$arrow(B)$])
  content((-1.30, 2.35), anchor: "east", [Current-carrying])
  content((-1.30, 1.85), anchor: "east", [straight wire])
  content((-2.95, -1.75), anchor: "east", [(out of page])
  content((-2.95, -2.35), anchor: "east", [on this side)])
  content((1.55, -1.75), anchor: "west", [(into page])
  content((1.55, -2.35), anchor: "west", [on this side)])
})
