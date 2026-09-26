#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1.4pt)
  let panel = (ox, cw, tag) => {
    line((ox, 0), (ox, 5.7), stroke: th, mark: (end: ">"))
    line((ox, 0), (ox + 5.3, 0), stroke: th, mark: (end: ">"))
    line((ox, 0), (ox - 2.3, -2.4), stroke: th, mark: (end: ">"))
    content((ox - .15, 5.9), anchor: "east", [$z$])
    content((ox + 5.45, -.5), anchor: "west", [$y$])
    content((ox - 2.5, -2.5), anchor: "east", [$x$])
    let c = (ox + 2.95, 3.65)
    let s = 1.25
    let tl = (c.at(0) - s, c.at(1) + s)
    let tr = (c.at(0) + s, c.at(1) + s)
    let bl = (c.at(0) - s, c.at(1) - s)
    let br = (c.at(0) + s, c.at(1) - s)
    line(tl, tr, stroke: (thickness: 2.3pt),
         mark: (end: if cw { "<" } else { ">" }))
    line(bl, br, stroke: (thickness: 2.3pt),
         mark: (end: if cw { ">" } else { "<" }))
    line(br, tr, stroke: (thickness: 2.3pt), mark: (end: ">"))
    line(bl, tl, stroke: (thickness: 2.3pt), mark: (end: "<"))
    circle(c, radius: .1, fill: black, stroke: none)
    content((c.at(0), c.at(1) + s + .42), [$A_y$])
    content((c.at(0), c.at(1) - s - .62), [$A_y$])
    content((c.at(0) - s - .35, c.at(1)), anchor: "east", [$A_z$])
    content((c.at(0) + s + .35, c.at(1)), anchor: "west", [$A_z$])
    content((ox + 1.4, -3.6), [(#(tag))])
  }
  panel(0, true, [a])
  panel(10.5, false, [b])
})
