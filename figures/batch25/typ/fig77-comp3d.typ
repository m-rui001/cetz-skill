#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 11pt)

#canvas({
  import draw: *

  let ta = (thickness: 1.3pt)
  let tv = (thickness: 2.4pt)
  let td = (thickness: 1.4pt, dash: (array: (6pt, 4pt)))
  let tld = (thickness: 1.1pt)

  let E = (1.78, 2.32)

  let axes = (ox) => {
    let P = (p) => (p.at(0) + ox, p.at(1))
    line(P((0, 0)), P((0, 3.35)), stroke: ta, mark: (end: ">"))
    line(P((0, 0)), P((3.05, 0)), stroke: ta, mark: (end: ">"))
    line(P((0, 0)), P((0.0 - 1.72, 0.0 - 1.72)), stroke: ta, mark: (end: ">"))
    content(P((0.0 - .05, 3.55)), anchor: "south", [$z$])
    content(P((3.25, 0.0 - .12)), anchor: "west", [$y$])
    content(P((0.0 - 1.88, 0.0 - 1.80)), anchor: "north", [$x$])
  }

  // panel (a): bare vector
  axes(0)
  line((0, 0), E, stroke: tv, mark: (end: ">"))
  content((0.62, 1.85), anchor: "east", [$arrow(A)$])
  content((E.at(0) + .12, E.at(1) + .22), anchor: "south", [$(0, 3, 3$)])
  content((1.0, 0.0 - 2.55), anchor: "center", [(a)])

  // panel (b): vector plus dashed components
  let o = 7.4
  let P = (p) => (p.at(0) + o, p.at(1))
  axes(o)
  line(P((0, 0)), P(E), stroke: tv, mark: (end: ">"))
  line(P((0, 0)), P((E.at(0), 0)), stroke: td, mark: (end: ">"))
  line(P((E.at(0), 0)), P(E), stroke: td, mark: (end: ">"))
  content(P((0.62, 1.85)), anchor: "east", [$arrow(A)$])
  content(P((E.at(0) + .12, E.at(1) + .22)), anchor: "south", [$(0, 3, 3$)])

  let zc = P((E.at(0) + .05, 1.28))
  content(P((3.35, 2.30)), anchor: "west", [$z$-component ($A_z hat(k)$)])
  bezier(P((5.45, 1.75)), zc, P((6.35, 1.15)), P((3.30, 1.55)),
         stroke: tld, mark: (end: ">"))

  let yc = P((0.92, 0.0 - .10))
  content(P((3.55, 0.0 - 1.62)), anchor: "west", [$y$-component ($A_y hat(j)$)])
  bezier(P((3.70, 0.0 - 1.40)), yc, P((2.55, 0.0 - 1.85)), P((1.55, 0.0 - 1.30)),
         stroke: tld, mark: (end: ">"))

  content(P((1.0, 0.0 - 2.55)), anchor: "center", [(b)])
})
