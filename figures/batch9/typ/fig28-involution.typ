#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let r = 1.8
  let E = (-r, 0)
  let F = (r, 0)
  let L = (-.35, 0)
  let Mp = (.22, 0)
  let Z1 = (-1.16, 1.38)
  let Z = (.9, 1.56)
  let Zp = (.62, -1.68)
  circle((0, 0), radius: r)
  // horizontal line E-F extended
  line((E.at(0) - .25, 0), (F.at(0) + .25, 0))
  // vertical line through L, extended beyond the circle
  line((L.at(0), 2.35), (L.at(0), -3.1))
  // chords / construction lines
  line(Z1, Z)
  line(Z1, L)
  line(Z, L)
  line(Z, Zp)
  line(Zp, L)
  // secant through Z' and F, meeting the vertical line below the circle
  line((2.35, .8), (-.2, -3.05))
  content((E.at(0) - .55, -.35), [$E$])
  content((F.at(0) + .2, -.35), [$F$])
  content((L.at(0) - .5, -.4), [$L$])
  content((Mp.at(0) - .05, -.42), [$M'$])
  content((Z1.at(0) - .62, Z1.at(1) + .12), [$Z_1'$])
  content((Z.at(0) + .18, Z.at(1) + .1), [$Z$])
  content((Zp.at(0) + .12, Zp.at(1) - .1), [$Z'$])
})
