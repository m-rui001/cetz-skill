#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let tv = (thickness: 1.8pt)
  let dot = (p) => circle(p, radius: .075, fill: black, stroke: none)
  let axes = (ox) => {
    line((ox, 0), (ox, 2.2), stroke: th, mark: (end: ">"))
    line((ox, 0), (ox + 2.0, 0), stroke: th, mark: (end: ">"))
    line((ox, 0), (ox - 1.15, -1.15), stroke: th, mark: (end: ">"))
    content((ox + .22, 1.95), anchor: "west", [$z$])
    content((ox + 2.15, -.32), anchor: "west", [$y$])
    content((ox - 1.3, -1.35), anchor: "east", [$x$])
  }
  // ---- (a) free displacement vector ----
  axes(0)
  let p0 = (1.15, -.75)
  let p1 = (2.35, 1.4)
  line(p0, p1, stroke: tv, mark: (end: ">"))
  dot(p0)
  dot(p1)
  content((2.55, 1.5), anchor: "west", [$(x_"end", y_"end", z_"end")$])
  content((1.1, -1.3), anchor: "center", [$(x_"start", y_"start", z_"start")$])
  content((.7, -2.3), [(a)])
  // ---- (b) same vector moved to the origin ----
  let ox = 7.0
  axes(ox)
  let q1 = (ox + 1.2, 2.15)
  line((ox, 0), q1, stroke: tv, mark: (end: ">"))
  dot((ox, 0))
  dot(q1)
  content((ox + .45, -.5), anchor: "center", [$(0, 0, 0)$])
  content((q1.at(0) + .25, q1.at(1) + .35), anchor: "west", [$(x_"end" - x_"start",$])
  content((q1.at(0) + .25, q1.at(1) - .1), anchor: "west", [$y_"end" - y_"start",$])
  content((q1.at(0) + .25, q1.at(1) - .55), anchor: "west", [$z_"end" - z_"start")$])
  content((ox + .7, -2.3), [(b)])
})
