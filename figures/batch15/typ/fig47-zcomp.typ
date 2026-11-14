#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let tv = (thickness: 2pt)
  let td = (dash: "dashed", thickness: 1pt)
  let axes = (ox) => {
    line((ox, 0), (ox, 2.4), stroke: th, mark: (end: ">"))
    line((ox, 0), (ox + 2.0, 0), stroke: th, mark: (end: ">"))
    line((ox, 0), (ox - 1.05, -1.05), stroke: th, mark: (end: ">"))
    content((ox + .2, 2.15), anchor: "west", [$z$])
    content((ox + 2.15, -.35), anchor: "west", [$y$])
    content((ox - 1.2, -1.25), anchor: "east", [$x$])
  }
  // (a) the vector itself
  axes(0)
  line((0, 0), (1.15, 1.95), stroke: tv, mark: (end: ">"))
  content((.45, 1.3), anchor: "east", [$arrow(A)$])
  content((1.35, 2.1), anchor: "west", [$(0, 3, 3)$])
  content((.2, -1.95), [(a)])
  // (b) its y and z components
  let ox = 5.8
  let tip = (ox + 1.15, 1.95)
  axes(ox)
  line((ox, 0), tip, stroke: tv, mark: (end: ">"))
  line(tip, (tip.at(0), 0), stroke: td, mark: (end: ">"))
  line((ox, 0), (tip.at(0) - .12, 0), stroke: td, mark: (end: ">"))
  content((ox + .45, 1.55), anchor: "east", [$arrow(A)$])
  content((ox + .55, 2.2), anchor: "west", [$(0, 3, 3)$])
  content((ox + 1.45, 1.55), anchor: "west", [z-component ($A_z hat(k)$)])
  bezier((ox + 2.55, 1.3), (ox + 1.4, 1.0), (ox + 2.3, .85),
    (ox + 1.2, 1.08), stroke: th, mark: (end: "stealth", fill: black))
  content((ox + 1.35, -1.2), anchor: "west", [y-component ($A_y hat(j)$)])
  bezier((ox + 1.3, -.85), (ox + .62, -.2), (ox + .9, -.85),
    (ox + .52, -.1), stroke: th, mark: (end: "stealth", fill: black))
  content((ox + .2, -1.95), [(b)])
})
