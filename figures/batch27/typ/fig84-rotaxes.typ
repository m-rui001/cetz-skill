#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 11pt)

#canvas({
  import draw: *

  let ta = (thickness: 1.2pt)
  let td = (thickness: 1.1pt, dash: (array: (7pt, 5pt)))
  let tc = (thickness: 1.15pt)
  let tv = (thickness: 2.0pt)
  let u = (a) => (calc.cos(a), calc.sin(a))
  let sc = (p, k) => (p.at(0) * k, p.at(1) * k)
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))

  let ex = u(20deg)
  let ey = u(110deg)
  let T = (1.00, 1.62)

  let frame = (ox, primed, tag) => {
    let P = (p) => (p.at(0) + ox, p.at(1))
    line(P((-3.15, 0)), P((3.15, 0)), stroke: ta, mark: (end: ">"))
    line(P((0, 0.0 - 3.15)), P((0, 3.15)), stroke: ta, mark: (end: ">"))
    line(P(sc(ex, -2.95)), P(sc(ex, 2.95)), stroke: td, mark: (end: ">"))
    line(P(sc(ey, -2.45)), P(sc(ey, 2.65)), stroke: td, mark: (end: ">"))
    content(P((3.30, 0.0 - .30)), anchor: "north", [$x$])
    content(P((0.0 - .12, 3.30)), anchor: "east", [$y$])
    content(P(sc(ex, 3.15)), anchor: "south-west", [$x'$])
    content(P(sc(ey, 2.85)), anchor: "south-east", [$y'$])

    line(P((0, 0)), P(T), stroke: tv, mark: (end: ">"))
    if not primed {
      line(P((0, 0)), P((T.at(0), 0)), stroke: tc, mark: (end: ">"))
      line(P((0, 0)), P((0, T.at(1))), stroke: tc, mark: (end: ">"))
      line(P((0, T.at(1))), P(T), stroke: tc)
      line(P((T.at(0), 0)), P(T), stroke: tc)
      content(P((0.52, 0.0 - .18)), anchor: "north", [$A_x$])
      content(P((0.0 - .22, 1.00)), anchor: "east", [$A_y$])
    } else {
      let a = T.at(0) * ex.at(0) + T.at(1) * ex.at(1)
      let b = T.at(0) * ey.at(0) + T.at(1) * ey.at(1)
      let Cx = sc(ex, a)
      let Cy = sc(ey, b)
      line(P((0, 0)), P(Cx), stroke: tc, mark: (end: ">"))
      line(P((0, 0)), P(Cy), stroke: tc, mark: (end: ">"))
      line(P(Cy), P(T), stroke: tc)
      line(P(Cx), P(T), stroke: tc)
      content(P(add(sc(Cx, 0.62), (0.12, 0.0 - .34))), anchor: "north", [$A'_x$])
      content(P(add(sc(Cy, 0.55), (0.0 - .30, 0.06))), anchor: "east", [$A'_y$])
    }
    content(P((1.00, 0.86)), anchor: "west", [$arrow(A)$])
    content(P((0.0 - .15, 0.0 - 3.95)), anchor: "center", [#(tag)])
  }

  frame(0, false, "(a)")
  frame(8.9, true, "(b)")
})
