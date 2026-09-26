#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1.3cm, {
  draw.line((0, 0), (4.6, 0), mark: (end: ">"))
  draw.line((0, 0), (0, 3.6), mark: (end: ">"))
  draw.content((4.55, -0.15), $x$, anchor: "north")
  draw.content((-0.1, -0.12), [O], anchor: "north-east")

  draw.line((0.55, 1.35), (4.2, 2.95), mark: (end: ">"))
  draw.content((4.15, 3.12), $d$)
  draw.circle((0.9, 1.5), radius: 0.07, fill: black, stroke: none)
  draw.circle((1.95, 1.97), radius: 0.07, fill: black, stroke: none)
  draw.circle((3.45, 2.63), radius: 0.07, fill: black, stroke: none)
  draw.content((0.9, 1.3), [Z], anchor: "north")
  draw.content((1.95, 1.77), [M], anchor: "north")
  draw.content((3.45, 2.43), [Z#sym.prime], anchor: "north")
})
