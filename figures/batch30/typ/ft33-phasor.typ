#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 12pt)

#canvas({
  import draw: *

  let tt = (thickness: 2.6pt)
  let tv = (thickness: 3.0pt)
  let u = (a) => (calc.cos(a), calc.sin(a))
  let sc = (p, k) => (p.at(0) * k, p.at(1) * k)
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))

  // axes
  line((0, 0), (5.4, 0), stroke: tt)
  line((0, 0), (0, 4.4), stroke: tt)
  content((-0.18, 4.35), anchor: "east", "Imaginary")
  content((-0.18, 3.85), anchor: "east", "axis")
  content((5.35, -0.22), anchor: "north", "Real axis")

  // phasors: c = a + b
  let A = sc(u(20deg), 3.6)
  let B = sc(u(62deg), 3.1)
  let C = add(A, B)
  line((0, 0), A, stroke: tv, mark: (end: ">"))
  line((0, 0), B, stroke: tv, mark: (end: ">"))
  line((0, 0), C, stroke: tv, mark: (end: ">"))
  content(add(sc(u(20deg), 2.55), (0.1, 0.12)), anchor: "south-west", [$overline(a)$])
  content(add(sc(u(62deg), 1.9), (-0.34, 0.06)), anchor: "east", [$overline(b)$])
  content((2.35, 3.12), anchor: "south",
          [$overline(c) = overline(a) + overline(b)$])

  // angle sweep nu, from the real axis up past c
  let R = 4.95
  let a0 = 0deg
  let a1 = 55deg
  let pts = ()
  for i in range(25) {
    pts.push(sc(u(a0 + (a1 - a0) * i / 24), R))
  }
  line(path: true, ..pts, stroke: tv, mark: (end: ">"))
  content(add(sc(u(22deg), R + 0.34), (0, 0)), anchor: "west", [$nu$])
})
