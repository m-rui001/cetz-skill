#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *

  let tb = (thickness: 2.4pt)
  let td = (dash: (array: (9pt, 6pt)), thickness: 1.3pt)
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))

  let P = (0, 0)
  let T = (1.65, 0.95)
  let C = (2.0, 0.0 - 2.5)
  let S = add(T, C)

  let ctr = (3.06, 0.0 - 2.72)
  let r = 4.1
  let st = 61deg
  arc(add(ctr, (r * calc.cos(st), r * calc.sin(st))), radius: r,
      start: st, stop: 203deg, stroke: td)

  line(P, T, stroke: tb, mark: (end: ">"))
  line(P, C, stroke: tb, mark: (end: ">"))
  line(P, S, stroke: tb, mark: (end: ">"))
  line(T, S, stroke: td)
  line(C, S, stroke: td)

  content((0.35, 1.35), anchor: "west", [$arrow(a)_"tang"$])
  content((1.0, 0.12), anchor: "west", [$arrow(a)_"Total"$])
  content((0.1, 0.0 - 1.1), anchor: "west", [$arrow(a)_c$])
})
