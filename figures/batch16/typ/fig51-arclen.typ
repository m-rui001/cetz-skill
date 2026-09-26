#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let td = (dash: "dashed", thickness: 1pt)
  let tv = (thickness: 2pt)
  let mv = 3.0
  let T = (0, 0)
  let R = (mv * calc.cos(-25deg), mv * calc.sin(-25deg))
  let dTB = 155deg + 80deg
  let B = (R.at(0) + mv * calc.cos(dTB), R.at(1) + mv * calc.sin(dTB))
  let cur = (p0, p1, c1, c2) => bezier(p0, p1, c1, c2, stroke: th, mark: (end: ">"))
  // particle path (dashed)
  arc((-4.35, -2.0), radius: 7.913, start: 135.3deg, stop: 29deg, stroke: td)
  // arc of radius |v| joining the two vector tips: length = |v| delta-theta
  arc(T, radius: mv, start: 155deg, stop: 235deg, stroke: th)
  // velocity triangle
  line(T, R, stroke: tv, mark: (end: ">"))
  line(R, B, stroke: tv, mark: (end: ">"))
  line(T, B, stroke: tv, mark: (end: ">"))
  // angle at the head of the upper vector
  arc((R.at(0) + .65 * calc.cos(155deg), R.at(1) + .65 * calc.sin(155deg)), radius: .65, start: 155deg, stop: 235deg, stroke: th)
  content((1.42, -1.68), [$Delta theta$])
  // callouts
  content((-2.85, 1.15), anchor: "west", [length = $|Delta arrow(v)|$])
  cur((-0.75, 1.05), (0.18, -0.62), (-0.15, 0.35), (0.42, -0.2))
  content((4.6, 1.6), anchor: "west", [length = $|arrow(v)_"final"| = |arrow(v)|$])
  cur((4.7, 1.15), (3.05, -0.42), (3.9, 0.75), (3.35, 0.05))
  content((3.6, -5.3), anchor: "west", [length = $|arrow(v)_"initial"| = |arrow(v)|$])
  cur((3.75, -4.75), (3.28, -2.92), (4.35, -4.0), (3.6, -3.35))
  content((-3.6, -6.0), anchor: "west", [length = $|arrow(v)| Delta theta$])
  cur((-1.0, -5.6), (-0.62, -2.35), (-1.55, -4.4), (-1.2, -3.1))
})
