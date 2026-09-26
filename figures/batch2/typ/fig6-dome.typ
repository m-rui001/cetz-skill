#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1.1cm, {
  draw.bezier((-2.2, 0.0), (2.2, 0.0), (-1.0, 2.1), (1.0, 2.1), stroke: 1.2pt)
  draw.circle((0, 0.4), radius: (1.72, 0.3), stroke: 0.7pt)
  draw.bezier((-0.05, 1.6), (-1.1, 0.45), (-0.6, 1.1), (-0.95, 0.75),
    stroke: (dash: "dotted", thickness: 0.6pt))
  draw.bezier((0.0, 1.6), (-0.45, 0.45), (-0.25, 1.1), (-0.4, 0.75),
    stroke: (dash: "dotted", thickness: 0.6pt))
  draw.bezier((0.05, 1.6), (0.5, 0.45), (0.3, 1.1), (0.45, 0.75),
    stroke: (dash: "dotted", thickness: 0.6pt))
  draw.bezier((0.1, 1.6), (1.12, 0.45), (0.7, 1.1), (1.0, 0.75),
    stroke: (dash: "dotted", thickness: 0.6pt))
  draw.line((-0.6, -0.75), (-0.6, 1.4), stroke: (dash: "dotted", thickness: 0.9pt))
  draw.line((0.35, -0.95), (0.35, 1.8), stroke: (dash: "dotted", thickness: 0.9pt))
  draw.bezier((-1.75, 1.85), (-0.64, 1.32), (-1.25, 1.8), (-0.9, 1.62),
    stroke: 0.7pt, mark: (end: ">"))
  draw.bezier((1.55, 2.15), (0.42, 1.68), (1.05, 2.05), (0.65, 1.9),
    stroke: 0.7pt, mark: (end: ">"))
  draw.content((-2.35, 1.9), $f(bold(x))$)
  draw.content((1.65, 2.2), $f(bold(a))$)
  draw.content((-0.6, -1.05), $bold(x)$)
  draw.content((0.35, -1.25), $bold(a)$)
})
