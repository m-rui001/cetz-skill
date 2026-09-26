#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1.2cm, {
  let A = (2.3, 0.9)
  let Z = (3.1, 3.4)
  let Zp = (4.9, 1.6)
  draw.line((0, 0), (5.4, 0), mark: (end: ">"))
  draw.line((0, 0), (0, 4.2), mark: (end: ">"))
  draw.content((-0.1, -0.15), [O], anchor: "north-east")
  draw.line(A, Z, stroke: (dash: "dashed"))
  draw.line(A, Zp, stroke: (dash: "dashed"))
  draw.arc((A.at(0) + 0.9 * calc.cos(72deg), A.at(1) + 0.9 * calc.sin(72deg)),
    radius: 0.9, start: 72deg, stop: 15deg,
    stroke: (dash: "dashed"), mark: (end: ">"))
  draw.bezier((1.6, 0.7), (0.35, 1.7), (1.35, 1.35), (0.8, 1.65),
    stroke: 0.8pt, mark: (end: ">"))
  draw.content((0.55, 1.95), [+])
  draw.content((A.at(0) - 0.05, A.at(1) - 0.25), [A], anchor: "north")
  draw.content((Z.at(0), Z.at(1) + 0.15), [Z], anchor: "south")
  draw.content((Zp.at(0) + 0.12, Zp.at(1) - 0.05), [Z#sym.prime])
  draw.content((3.25, 1.8), $alpha$)
})
