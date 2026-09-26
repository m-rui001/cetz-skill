#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let td = (dash: "dashed", thickness: 1pt)
  let tv = (thickness: 2pt)
  let a = 32deg
  let u = (calc.cos(a), calc.sin(a))
  let v = (0.0 - calc.sin(a), calc.cos(a))
  let P = (1.5, 1.9)
  let panel = (ox, car) => {
    line((ox - 3.2, 0), (ox + 3.2, 0), stroke: th, mark: (end: ">"))
    line((ox, -3.0), (ox, 3.0), stroke: th, mark: (end: ">"))
    line((ox - 2.6 * u.at(0), 0 - 2.6 * u.at(1)), (ox + 2.6 * u.at(0), 2.6 * u.at(1)), stroke: td)
    line((ox - 2.6 * v.at(0), 0 - 2.6 * v.at(1)), (ox + 2.6 * v.at(0), 2.6 * v.at(1)), stroke: td)
    content((ox + 3.15, -.45), anchor: "west", [$x$])
    content((ox - .25, 2.85), anchor: "east", [$y$])
    content((ox + 2.45 * u.at(0) + .3, 2.45 * u.at(1) + .2), [$x'$])
    content((ox + 2.5 * v.at(0) - .35, 2.5 * v.at(1) + .2), [$y'$])
    let p = (ox + P.at(0), P.at(1))
    line((ox, 0), p, stroke: tv, mark: (end: ">"))
    if car {
      line((ox, 0), (ox + P.at(0), 0), stroke: th, mark: (end: ">"))
      line((ox + P.at(0), 0), p, stroke: th, mark: (end: ">"))
      line((ox, 0), (ox, P.at(1)), stroke: th, mark: (end: ">"))
      line((ox, P.at(1)), p, stroke: th, mark: (end: ">"))
      content((ox + P.at(0) / 2, -.45), [$A_x$])
      content((ox - .3, P.at(1) / 2), anchor: "east", [$A_y$])
      content((p.at(0) - .35, p.at(1) - .35), anchor: "east", [$arrow(A)$])
    } else {
      let t1 = P.at(0) * u.at(0) + P.at(1) * u.at(1)
      let t2 = P.at(0) * v.at(0) + P.at(1) * v.at(1)
      let f1 = (ox + t1 * u.at(0), t1 * u.at(1))
      let f2 = (ox + t2 * v.at(0), t2 * v.at(1))
      line((ox, 0), f1, stroke: th, mark: (end: ">"))
      line((ox, 0), f2, stroke: th, mark: (end: ">"))
      line(f1, p, stroke: th)
      line(f2, p, stroke: th)
      content((f1.at(0) + .35, f1.at(1) - .45), [$A'_x$])
      content((f2.at(0) - .3, f2.at(1) - .45), anchor: "east", [$A'_y$])
      content((p.at(0) - .3, p.at(1) - .4), anchor: "east", [$arrow(A)$])
    }
    content((ox + .2, -3.9), if car { [(a)] } else { [(b)] })
  }
  panel(0, true)
  panel(8.2, false)
})
