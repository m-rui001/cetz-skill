#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 11pt)

#canvas({
  import draw: *

  let ta = (thickness: 1.3pt)
  let td = (thickness: 1.15pt, dash: (array: (7pt, 5pt)))
  let u = (a) => (calc.cos(a), calc.sin(a))
  let sc = (p, k) => (p.at(0) * k, p.at(1) * k)
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let dot = (p) => circle(p, radius: .10, fill: luma(15%), stroke: none)

  // ---- panel (a): y' and z' tilted, the mass line horizontal ----
  let A = (ox) => {
    let P = (p) => (p.at(0) + ox, p.at(1))
    let ey = u(27deg)
    let ez = u(118deg)
    line(P(sc(ey, -2.75)), P(sc(ey, 3.05)), stroke: ta, mark: (end: ">"))
    line(P(sc(ez, -2.30)), P(sc(ez, 2.95)), stroke: ta, mark: (end: ">"))
    content(P(sc(ey, 3.25)), anchor: "west", [$y'$])
    content(P(sc(ez, 3.12)), anchor: "south", [$z'$])

    let L = (-1.78, 0)
    let R = (1.78, 0)
    let T = (0, 2.78)
    line(P(L), P(R), stroke: td)
    line(P((0, 0)), P(T), stroke: td)
    line(P(T), P(L), stroke: td)
    line(P(T), P(R), stroke: td)
    content(P((-0.92, 0.22)), anchor: "south", [$a$])
    content(P((0.92, 0.22)), anchor: "south", [$a$])
    content(P((0.20, 1.45)), anchor: "west", [$2a$])
    dot(P(L))
    content(P(add(L, (-.24, .22))), anchor: "east", [$m_3$])
    content(P(add(L, (-.24, 0.0 - .22))), anchor: "east", [$m_4$])
    dot(P(R))
    content(P(add(R, (.24, .22))), anchor: "west", [$m_2$])
    content(P(add(R, (.24, 0.0 - .22))), anchor: "west", [$m_1$])
    dot(P(T))
    content(P(add(T, (.24, .18))), anchor: "west", [$m_5$])
    content(P((0.2, 0.0 - 3.35)), anchor: "center", [(a)])
  }

  // ---- panel (b): y' horizontal, z' vertical ----
  let B = (ox) => {
    let P = (p) => (p.at(0) + ox, p.at(1))
    line(P((-3.05, 0)), P((3.15, 0)), stroke: ta, mark: (end: ">"))
    line(P((0, 0.0 - 2.95)), P((0, 3.05)), stroke: ta, mark: (end: ">"))
    content(P((3.35, 0.0 - .28)), anchor: "north", [$y'$])
    content(P((.26, 3.12)), anchor: "west", [$z'$])

    let L = (-2.05, 0.92)
    let R = (1.55, -1.42)
    let T = (1.55, 2.22)
    line(P((0, 0)), P(T), stroke: td)
    line(P((0, 0)), P(L), stroke: td)
    line(P((0, 0)), P(R), stroke: td)
    line(P(L), P(T), stroke: td)
    line(P(T), P(R), stroke: td)
    content(P((-0.30, 1.28)), anchor: "east", [$2a$])
    content(P((-1.12, 0.22)), anchor: "north", [$a$])
    content(P((0.62, 0.0 - 0.92)), anchor: "north", [$a$])
    dot(P(L))
    content(P(add(L, (-.24, .26))), anchor: "east", [$m_3$])
    content(P(add(L, (-.24, 0.0 - .18))), anchor: "east", [$m_4$])
    dot(P(R))
    content(P(add(R, (.24, .20))), anchor: "west", [$m_2$])
    content(P(add(R, (.24, 0.0 - .26))), anchor: "west", [$m_1$])
    dot(P(T))
    content(P(add(T, (.26, .10))), anchor: "west", [$m_5$])
    content(P((0.2, 0.0 - 3.35)), anchor: "center", [(b)])
  }

  A(0)
  B(9.4)
})
