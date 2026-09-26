#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let P = (3.5, 4.08)
  let Om = (4.67, 1.42)
  let Z2 = (.92, 2.83)
  let Z2p = (4.57, 3.15)
  let Z1p = (6.0, 1.17)
  circle((2.82, 2.19), radius: 2.0)
  circle((5.75, 3.48), radius: 2.32)
  line(Z2, (7.5, 6.01))
  line(P, Z1p)
  for p in (P, Om, Z2, Z2p, Z1p) {
    circle(p, radius: .06, fill: black)
  }
  content((3.35, 4.3), [P])
  content((.35, 2.85), [$Z_2$])
  content((1.0, .95), [$gamma_2$])
  content((4.8, 1.2), [$Omega$])
  content((4.7, 3.35), [$Z_2'$])
  content((5.4, 2.2), [d#sym.prime])
  content((6.1, .85), [$Z_1'$])
  content((7.55, 4.4), [$gamma_1$])
  content((7.35, 6.1), [d])
})
