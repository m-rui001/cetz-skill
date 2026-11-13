#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let c = black
  line((0, 0), (3.36, 0), stroke: (paint: c, thickness: 0.8pt), mark: (end: "stealth", fill: c))
  line((0, 0), (0, 2.55), stroke: (paint: c, thickness: 0.8pt), mark: (end: "stealth", fill: c))
  circle((0, 0), radius: 1.85, stroke: (paint: c, thickness: 0.8pt))
  let P = (-1.6, -1.18)
  let Z2 = (3.0, 2.18)
  let Q = (1.55, 1.12)
  let U = (1.82, 0)
  let Zb = (.6, .75)
  let Z = (.6, -.55)
  line(P, Z2, stroke: (paint: c, thickness: 0.8pt))
  line(Z2, U, stroke: (paint: c, thickness: 0.8pt, dash: "dashed"))
  line(Z, U, stroke: (paint: c, thickness: 0.8pt, dash: "dashed"))
  line(Z, Zb, stroke: (paint: c, thickness: 0.8pt, dash: "dashed"))
  for p in (Q, U, P, Z2, Zb, Z) {
    circle(p, radius: .06, fill: c)
  }
  let r1 = .95
  arc((r1, 0), radius: r1, start: 0deg, stop: 40deg, stroke: (paint: c, thickness: 0.8pt))
  let r2 = .6
  arc((r2, 0), radius: r2, start: 0deg, stop: -42deg, stroke: (paint: c, thickness: 0.8pt), mark: (end: "stealth", fill: c))
  content((-.15, -.4), [O])
  content((3.3, -.25), [$x$])
  content((-.18, 2.62), [$y$])
  content((-1.75, -1.4), [P])
  content((3.16, 2.48), [$Z_2$])
  content((1.65, 1.45), [Q])
  content((2.05, -.25), [U])
  content((.5, .95), [$overline(Z)$])
  content((.55, -.85), [Z])
  content((1.1, .42), [$theta_1$])
  content((1.12, -.72), [$-theta_2$])
})
