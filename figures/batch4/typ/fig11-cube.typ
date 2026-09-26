#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1.2cm, {
  let t = (0.75, 0.6)
  let g1 = luma(150)
  let g2 = luma(205)
  let g3 = luma(175)
  draw.line((0, 0), (1.7, 0), (1.7, 1.7), (0, 1.7), fill: g1, stroke: 0.7pt, close: true)
  draw.line((0, 1.7), (1.7, 1.7), (1.7 + t.at(0), 1.7 + t.at(1)), (t.at(0), 1.7 + t.at(1)),
    fill: g2, stroke: 0.7pt, close: true)
  draw.line((1.7, 0), (1.7 + t.at(0), t.at(1)), (1.7 + t.at(0), 1.7 + t.at(1)), (1.7, 1.7),
    fill: g3, stroke: 0.7pt, close: true)
  draw.line((0.85, 0.6), (0.85, 2.9), mark: (end: ">"), stroke: 0.7pt)
  draw.line((1.2, 0.85), (3.4, 0.85), mark: (end: ">"), stroke: 0.7pt)
  draw.line((0.9, 0.8), (-0.55, -0.4), mark: (end: ">"), stroke: 0.7pt)
  draw.content((0.72, 2.95), $z$, anchor: "south")
  draw.content((3.45, 0.75), $y$, anchor: "north-west")
  draw.content((-0.6, -0.55), $x$, anchor: "north-east")
  draw.content((0.78, 0.95), [O])
  draw.content((-0.18, 0.85), $b$, anchor: "east")
  draw.content((0.85, -0.22), $b$, anchor: "north")
  draw.content((2.3, 0.12), $b$)
})
