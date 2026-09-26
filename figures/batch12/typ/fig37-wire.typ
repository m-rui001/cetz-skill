#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: .9pt)
  // straight wire along y
  line((0, -3.3), (0, 3.3), stroke: (thickness: 1.8pt), mark: (end: ">"))
  content((.3, 2.75), [$arrow(I)$])
  content((-3.3, 3.15), [Current-carrying])
  content((-2.75, 2.5), [straight wire])
  // concentric field circles seen in perspective
  for i in range(6) {
    let rx = .45 + i * .44
    let ry = rx * .3
    circle((0, 0), radius: (rx, ry), stroke: th)
    let h = .14
    line((rx - .075, -h), (rx + .075, -h), (rx, h), close: true, fill: black, stroke: none)
    line((0 - rx - .075, h), (0 - rx + .075, h), (0 - rx, 0 - h), close: true, fill: black, stroke: none)
  }
  content((-2.75, -1.55), [$arrow(B)$])
  content((2.45, -1.55), [$arrow(B)$])
  content((-3.4, -2.25), [(out of page])
  content((-3.25, -2.85), [on this side)])
  content((2.35, -2.25), [(into page])
  content((2.35, -2.85), [on this side)])
})
