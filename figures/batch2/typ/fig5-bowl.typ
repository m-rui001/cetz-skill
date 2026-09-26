#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1.1cm, {
  draw.bezier((-2.2, 1.6), (2.2, 1.6), (-0.73, -0.48), (0.73, -0.48), stroke: 1.2pt)
  draw.circle((0, 1.42), radius: (2.02, 0.4), stroke: 0.7pt)
  draw.bezier((-0.05, 0.06), (-1.15, 1.15), (-0.55, 0.35), (-0.95, 0.7),
    stroke: (dash: "dotted", thickness: 0.6pt))
  draw.bezier((0.0, 0.06), (-0.42, 1.2), (-0.2, 0.4), (-0.35, 0.75),
    stroke: (dash: "dotted", thickness: 0.6pt))
  draw.bezier((0.02, 0.06), (0.22, 1.2), (0.12, 0.4), (0.2, 0.75),
    stroke: (dash: "dotted", thickness: 0.6pt))
  draw.bezier((0.05, 0.06), (0.9, 1.15), (0.45, 0.35), (0.75, 0.7),
    stroke: (dash: "dotted", thickness: 0.6pt))
  draw.line((0, -1.15), (0, 2.15), stroke: (dash: "dotted", thickness: 0.9pt))
  draw.line((1.15, -0.75), (1.15, 1.35), stroke: (dash: "dotted", thickness: 0.9pt))
  draw.bezier((-1.5, -0.62), (-0.06, -0.04), (-0.95, -0.5), (-0.45, -0.42),
    stroke: 0.7pt, mark: (end: ">"))
  draw.bezier((2.45, 0.42), (1.2, 0.5), (1.95, 0.5), (1.55, 0.72),
    stroke: 0.7pt, mark: (end: ">"))
  draw.content((-2.05, -0.8), $f(bold(a))$)
  draw.content((2.55, 0.4), $f(bold(x))$)
  draw.content((0, -1.45), $bold(a)$)
  draw.content((1.15, -1.05), $bold(x)$)
})
