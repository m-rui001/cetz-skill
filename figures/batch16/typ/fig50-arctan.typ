#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let td = (dash: "dashed", thickness: 1pt)
  let tv = (thickness: 2pt)
  let r = 3.2
  let a1 = 145deg
  let a2 = 70deg
  let P = (ang) => (r * calc.cos(ang), r * calc.sin(ang))
  let tan = (ang) => (calc.sin(ang), 0.0 - calc.cos(ang))
  let P1 = P(a1)
  let P2 = P(a2)
  let L = 1.9
  arc((r * calc.cos(175deg), r * calc.sin(175deg)), radius: r, start: 175deg, stop: 5deg, stroke: td)
  line((0, 0), P1, stroke: th)
  line((0, 0), P2, stroke: th)
  line(P1, (P1.at(0) + L * tan(a1).at(0), P1.at(1) + L * tan(a1).at(1)), stroke: tv, mark: (end: ">"))
  line(P2, (P2.at(0) + L * tan(a2).at(0), P2.at(1) + L * tan(a2).at(1)), stroke: tv, mark: (end: ">"))
  arc((.75 * calc.cos(a2), .75 * calc.sin(a2)), radius: .75, start: a2, stop: a1, stroke: th)
  content((1.25 * calc.cos(107.5deg), 1.25 * calc.sin(107.5deg)), [$Delta theta$])
  content((-1.72, .62), [$r$])
  content((.95, 1.72), [$r$])
  content((-0.9, 2.42), [$r Delta theta$])
  content((-1.62, 3.55), anchor: "east", [$arrow(v)_"initial"$])
  content((2.95, 2.75), anchor: "west", [$arrow(v)_"final"$])
})
