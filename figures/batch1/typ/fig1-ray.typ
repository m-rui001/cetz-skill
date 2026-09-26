#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1.3cm, {
  draw.line((0, 0), (5.2, 0), mark: (end: ">"))
  draw.line((0, 0), (0, 3.4), mark: (end: ">"))
  draw.content((5.15, -0.15), $x$, anchor: "north")
  draw.content((-0.15, 3.35), $y$, anchor: "east")
  draw.content((-0.08, -0.12), [O], anchor: "north-east")

  draw.line((0.75, 1.05), (4.7, 2.15), mark: (end: ">"))
  draw.circle((0.75, 1.05), radius: 0.07, fill: black, stroke: none)
  draw.circle((2.53, 1.55), radius: 0.07, fill: black, stroke: none)
  draw.circle((3.52, 1.82), radius: 0.07, fill: black, stroke: none)
  draw.content((0.75, 0.85), [A], anchor: "north")
  draw.content((2.53, 1.35), [Z], anchor: "north")
  draw.content((3.52, 1.62), [Z#sym.prime], anchor: "north")
})
