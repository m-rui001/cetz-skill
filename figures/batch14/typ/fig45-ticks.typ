#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let tv = (thickness: 2.2pt)
  let ux = (-.707, -.707)
  let uy = (1, 0)
  let uz = (0, 1)
  let sk = (s, u) => (s * u.at(0), s * u.at(1))
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let ax = (u, p, perp) => line(add(p, sk(-.13, perp)), add(p, sk(.13, perp)), stroke: th)
  line((0, 0), sk(2.9, ux), stroke: th, mark: (end: ">"))
  line((0, 0), (2.9, 0), stroke: th, mark: (end: ">"))
  line((0, 0), (0, 2.9), stroke: th, mark: (end: ">"))
  ax(ux, sk(1, ux), (.707, -.707))
  ax(ux, sk(2, ux), (.707, -.707))
  ax(uy, sk(1, uy), (0, 1))
  ax(uy, sk(2, uy), (0, 1))
  ax(uz, sk(1, uz), (1, 0))
  ax(uz, sk(2, uz), (1, 0))
  // unit vectors
  line((0, 0), sk(1, ux), stroke: tv, mark: (end: ">"))
  line((0, 0), sk(1, uy), stroke: tv, mark: (end: ">"))
  line((0, 0), sk(1, uz), stroke: tv, mark: (end: ">"))
  // axis labels
  content(sk(3.0, uz), anchor: "west", [$z$])
  content((3.0, -.42), anchor: "west", [$y$])
  content(add(sk(2.95, ux), (-.1, -.35)), anchor: "east", [$x$])
  // tick numbers
  content(add(sk(1, uz), (.28, -.05)), anchor: "west", [1])
  content(add(sk(2, uz), (.28, -.05)), anchor: "west", [2])
  content(add(sk(1, uy), (.05, -.42)), anchor: "center", [1])
  content(add(sk(2, uy), (.05, -.42)), anchor: "center", [2])
  content(add(sk(1, ux), (.42, -.2)), anchor: "west", [1])
  content(add(sk(2, ux), (.42, -.2)), anchor: "west", [2])
  // unit vector labels
  content((-0.42, .18), anchor: "east", [$hat(i)$])
  content((.45, .32), anchor: "west", [$hat(j)$])
  content((-0.42, .85), anchor: "east", [$hat(k)$])
})
