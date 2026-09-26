#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  line((0, 0), (3.36, 0), mark: (end: ">"))
  line((0, 0), (0, 2.55), mark: (end: ">"))
  circle((0, 0), radius: 1.85)
  let P = (-1.6, -1.18)
  let Z2 = (3.0, 2.18)
  let Q = (1.55, 1.12)
  let U = (1.82, 0)
  let Zb = (.6, .75)
  let Z = (.6, -.55)
  line(P, Z2)
  line(Z2, U, stroke: (dash: "dashed"))
  line(Z, U, stroke: (dash: "dashed"))
  line(Z, Zb, stroke: (dash: "dashed"))
  for p in (Q, U, P, Z2, Zb, Z) {
    circle(p, radius: .06, fill: black)
  }
  let r1 = .95
  arc((r1, 0), radius: r1, start: 0deg, stop: 40deg)
  let r2 = .6
  arc((r2, 0), radius: r2, start: 0deg, stop: -42deg, mark: (end: ">"))
  content((-.2, -.28), [O])
  content((3.3, -.25), [$x$])
  content((.08, 2.6), [$y$])
  content((-1.75, -1.4), [P])
  content((3.1, 2.3), [$Z_2$])
  content((1.65, 1.25), [Q])
  content((1.85, -.28), [U])
  content((.5, .95), [$overline(Z)$])
  content((.55, -.85), [Z])
  content((1.1, .42), [$theta_1$])
  content((1.05, -.42), [$-theta_2$])
})
