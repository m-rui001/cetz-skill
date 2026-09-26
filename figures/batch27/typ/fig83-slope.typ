#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 12pt)

#canvas({
  import draw: *

  let ta = (thickness: 1.15pt)
  let tf = (thickness: 2.7pt)
  let ang = 28deg
  let u = (a) => (calc.cos(a), calc.sin(a))
  let sc = (p, k) => (p.at(0) * k, p.at(1) * k)
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
  // rotate a local (along-plane, off-plane) pair into page coordinates
  let R = (p) => (p.at(0) * calc.cos(ang) - p.at(1) * calc.sin(ang),
                  p.at(0) * calc.sin(ang) + p.at(1) * calc.cos(ang))

  let ex = sc(u(208deg), 1)   // +x: down the plane
  let ey = sc(u(118deg), 1)   // +y: off the plane
  // block centre: bottom edge rests on the plane line
  let C = sc(ey, .52)
  let P = (p) => add(C, p)

  // inclined plane — its lower end doubles as the +x axis
  line(sc(u(28deg), 3.9), sc(u(28deg), -3.9), stroke: ta, mark: (end: ">"))
  content(add(sc(u(28deg), -4.05), (0.05, 0.18)), anchor: "east", [$x$])

  // block: rounded rectangle built from four sampled corner arcs
  let w = .95
  let h = .80
  let r = .30
  let corners = ((w - r, h - r, 0deg), (0.0 - w + r, h - r, 90deg),
                 (0.0 - w + r, 0.0 - h + r, 180deg), (w - r, 0.0 - h + r, 270deg))
  let pts = ()
  for c in corners {
    for j in range(9) {
      let a = c.at(2) + j * 90deg / 8
      pts.push((c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a)))
    }
  }
  line(path: true, close: true, ..pts.map(p => P(R(p))),
       stroke: (thickness: 1.15pt))

  // axes
  line(P((0, 0)), P(sc(ey, 3.5)), stroke: ta, mark: (end: ">"))
  line(P((0, 0)), P(sc(ey, -1.35)), stroke: ta)
  content(P(add(sc(ey, 3.7), (0.1, 0.1))), anchor: "south", [$y$])

  // forces
  line(P((0, 0)), P(sc(ey, 2.0)), stroke: tf, mark: (end: ">"))
  line(P((0, 0)), P(sc(u(28deg), 1.9)), stroke: tf, mark: (end: ">"))
  line(P((0, 0)), P((0.0 - .12, 0.0 - 2.45)), stroke: tf, mark: (end: ">"))
  content(P(add(sc(ey, 2.3), (0.30, 0.10))), anchor: "south-west", [$arrow(F)_n$])
  content(P(add(sc(u(28deg), 2.2), (0.10, 0.30))), anchor: "south-west", [$arrow(F)_f$])
  content(P((0.30, 0.0 - 2.35)), anchor: "north-west", [$arrow(F)_g$])
})
