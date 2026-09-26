#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *

  let th = (thickness: 1.3pt)
  let td = (dash: "dashed", thickness: 1.3pt)

  let A = (2.57, 0.43)
  let B = (-0.73, 3.0)
  let C = (1.86, 3.5)

  let panel = (ox, show-sum) => {
    let O = (ox, 0)
    let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
    line(add(O, (-0.8, 0)), add(O, (4.8, 0)), stroke: th, mark: (end: ">"))
    line(add(O, (0, -1.2)), add(O, (0, 4.6)), stroke: th, mark: (end: ">"))
    content(add(O, (0.22, 4.45)), anchor: "west", [$y$])
    content(add(O, (4.92, -0.12)), anchor: "west", [$x$])
    line(O, add(O, A), stroke: th, mark: (end: ">"))
    line(O, add(O, B), stroke: th, mark: (end: ">"))
    content(add(O, (1.62, 0.85)), anchor: "west", [$arrow(A)$])
    content(add(O, (-0.88, 2.0)), anchor: "east", [$arrow(B)$])
    if show-sum {
      line(O, add(O, C), stroke: th, mark: (end: ">"))
      line(add(O, A), add(O, C), stroke: td, mark: (end: ">"))
      content(add(O, (0.15, 3.02)), anchor: "west", [$arrow(A) + arrow(B)$])
      content(add(O, (1.25, 1.8)), anchor: "west", [$arrow(C)$])
      content(add(O, (2.95, 2.3)), anchor: "west", [$arrow(B)$ (displaced)])
    }
  }

  panel(0, false)
  content((0, -1.75), [(a)])
  panel(8.3, true)
  content((8.3, -1.75), [(b)])
})
