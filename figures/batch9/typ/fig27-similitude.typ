#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let O = (0, 0)
  let L = (1.6, .45)
  let ad = 55.4deg
  let ad1 = 39.1deg
  let Pd = (L.at(0) + 3.6 * calc.cos(ad), L.at(1) + 3.6 * calc.sin(ad))
  let Pd1 = (L.at(0) + 2.7 * calc.cos(ad1), L.at(1) + 2.7 * calc.sin(ad1))
  let Z = (L.at(0) + 2.35 * calc.cos(ad), L.at(1) + 2.35 * calc.sin(ad))
  // axes
  line(O, (4.5, 0), mark: (end: ">"))
  line(O, (0, 3.4), mark: (end: ">"))
  content((4.6, -.3), [$x$])
  content((-.35, 3.45), [$y$])
  content((-.32, -.38), [$O$])
  // rays
  line(L, Pd, mark: (end: ">"))
  line(L, Pd1, mark: (end: ">"))
  // angle arc between the rays
  let r = 1.05
  draw.arc((L.at(0) + r * calc.cos(ad), L.at(1) + r * calc.sin(ad)), radius: r, start: ad, stop: ad1, mark: (end: ">"))
  circle(Z, radius: .07, fill: black)
  content((2.75, 2.55), [$Z$])
  content((1.35, .15), [$L$])
  content((3.7, 3.6), [$d$])
  content((4.15, 2.3), [$d_1$])
})
