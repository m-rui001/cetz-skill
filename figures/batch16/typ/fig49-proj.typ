#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let td = (dash: "dashed", thickness: 1pt)
  let tv = (thickness: 1.8pt)
  let a = 65deg
  let u = (calc.cos(a), calc.sin(a))
  let A = (2.2, .85)
  let panel = (ox, par) => {
    line((ox - 1.6, 0), (ox + 3.4, 0), stroke: th, mark: (end: ">"))
    line((ox - 1.5 * u.at(0), 0 - 1.5 * u.at(1)), (ox + 2.6 * u.at(0), 2.6 * u.at(1)), stroke: th, mark: (end: ">"))
    content((ox + 3.5, -.42), anchor: "west", [$x$])
    content((ox + 1.25, 2.45), anchor: "west", [$y$])
    arc((ox - 1.35, 0), radius: 1.35, start: 180deg, stop: 245deg, stroke: th, mark: (end: ">"))
    line((ox, 0), (ox + A.at(0), A.at(1)), stroke: if par { tv } else { th }, mark: (end: ">"))
    if par { content((ox + 2.35, 1.0), anchor: "west", [$arrow(A)$]) }
    else { content((ox + 1.45, 1.05), anchor: "west", [$arrow(A)$]) }
    if par {
      let fx = A.at(0) - A.at(1) * u.at(0) / u.at(1)
      let ty = A.at(1) / u.at(1)
      line((ox + A.at(0), A.at(1)), (ox + fx, 0), stroke: td)
      line((ox + A.at(0), A.at(1)), (ox + ty * u.at(0), ty * u.at(1)), stroke: td)
      line((ox, 0), (ox + fx, 0), stroke: th, mark: (end: ">"))
      line((ox, 0), (ox + ty * u.at(0), ty * u.at(1)), stroke: th, mark: (end: ">"))
    } else {
      let ty = A.at(0) * u.at(0) + A.at(1) * u.at(1)
      let cx = A.at(0) + ty * u.at(0)
      let cy = ty * u.at(1)
      line((ox + A.at(0), 0), (ox + cx, cy), stroke: td)
      line((ox + ty * u.at(0), ty * u.at(1)), (ox + cx, cy), stroke: td)
      line((ox, 0), (ox + A.at(0), 0), stroke: tv, mark: (end: ">"))
      line((ox, 0), (ox + ty * u.at(0), ty * u.at(1)), stroke: tv, mark: (end: ">"))
    }
  }
  panel(0, true)
  content((-1.6, 3.4), anchor: "west", [Components formed \ by parallel projection \ add to give vector $arrow(A)$])
  bezier((-1.1, 2.35), (.15, .35), (-1.6, 1.3), (-.7, .3))
  line((-.1, .5), (.15, .35), stroke: th, mark: (end: ">"))
  content((.3, -2.5), [(a)])
  let ox = 6.4
  panel(ox, false)
  content((ox - 1.5, 3.4), anchor: "west", [Components formed \ by perpendicular proj- \ ection do not add to \ give vector $arrow(A)$])
  bezier((ox - 1.0, 2.35), (ox + .15, .35), (ox - 1.5, 1.3), (ox - .6, .3))
  line((ox - .1, .5), (ox + .15, .35), stroke: th, mark: (end: ">"))
  content((ox + .3, -2.5), [(b)])
})
