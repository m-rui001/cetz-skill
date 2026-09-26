#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let td = (dash: "dashed", thickness: 1pt)
  let a = 20deg
  let u = (calc.cos(a), calc.sin(a))
  let v = (calc.cos(a + 90deg), calc.sin(a + 90deg))
  // unprimed axes
  line((-2.6, 0), (2.6, 0), stroke: th, mark: (end: ">"))
  line((0, -2.9), (0, 2.5), stroke: th, mark: (end: ">"))
  content((2.55, -.45), anchor: "west", [$x$])
  content((-.2, 2.35), anchor: "east", [$y$])
  // rotated axes (dashed)
  line((0 - 2.5 * u.at(0), 0 - 2.5 * u.at(1)), (2.6 * u.at(0), 2.6 * u.at(1)), stroke: td, mark: (end: ">"))
  line((0 - 1.7 * v.at(0), 0 - 1.7 * v.at(1)), (2.7 * v.at(0), 2.7 * v.at(1)), stroke: td, mark: (end: ">"))
  content((2.2, 1.15), anchor: "west", [$x'$])
  content((-1.35, 2.5), anchor: "east", [$y'$])
  // angle marks
  arc((.85, 0), radius: .85, start: 0deg, stop: a, stroke: th)
  arc((0, .85), radius: .85, start: 90deg, stop: 90deg + a, stroke: th)
  content((1.05, .18), anchor: "west", [$theta$])
  content((-.22, 1.05), anchor: "east", [$theta$])
})
