#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let tv = (thickness: 2.2pt)
  let cur = (p0, p1, c1, c2) => bezier(p0, p1, c1, c2, stroke: th, mark: (end: ">"))
  let axes = (ox) => {
    line((ox, 0), (ox - 2.6, -2.6), stroke: th, mark: (end: ">"))
    line((ox, 0), (ox + 3.1, 0), stroke: th, mark: (end: ">"))
    line((ox, 0), (ox, 3.1), stroke: th, mark: (end: ">"))
    content((ox - 2.75, -2.75), [$x$])
    content((ox + 3.25, -.42), anchor: "west", [$y$])
    content((ox + .18, 2.95), anchor: "west", [$z$])
    for t in (1, 2) {
      line((ox + t, -.12), (ox + t, .12), stroke: th)
      content((ox + t, .38), [#(str(t))])
      line((ox - .12, t), (ox + .12, t), stroke: th)
      content((ox - .3, t), anchor: "east", [#(str(t))])
    }
    line((ox - .83, -.67), (ox - .67, -.83), stroke: th)
    content((ox - .62, -1.05), [1])
  }
  // (a) Cartesian basis, doubled
  axes(0)
  line((0, 0), (0, 2), stroke: tv, mark: (end: ">"))
  line((0, 0), (2, 0), stroke: tv, mark: (end: ">"))
  line((0, 0), (-1.5, -1.5), stroke: tv, mark: (end: ">"))
  content((1.55, 2.4), anchor: "west", [$2 hat(k)$])
  cur((1.5, 2.1), (0.3, 1.72), (0.95, 1.85), (0.6, 1.72))
  content((1.7, -1.55), anchor: "west", [$2 hat(j)$])
  cur((1.65, -1.25), (1.05, -.18), (1.5, -.75), (1.15, -.5))
  content((-2.95, .2), anchor: "east", [$2 hat(i)$])
  cur((-2.6, -.1), (-1.42, -.92), (-2.2, -.5), (-1.85, -.85))
  content((.2, -3.9), [(a)])
  // (b) skewed basis
  let ox = 8.2
  axes(ox)
  line((ox, 0), (ox - 2.15, .3), stroke: tv, mark: (end: ">"))
  line((ox, 0), (ox + 2.6, .55), stroke: tv, mark: (end: ">"))
  line((ox, 0), (ox + .95, 1.85), stroke: tv, mark: (end: ">"))
  content((ox + 1.65, 2.55), anchor: "west", [$arrow(e)_3$])
  cur((ox + 1.6, 2.25), (ox + 1.1, 1.5), (ox + 1.35, 1.9), (ox + 1.12, 1.7))
  content((ox - 2.35, -.75), anchor: "east", [$arrow(e)_1$])
  cur((ox - 2.2, -.5), (ox - 1.6, .12), (ox - 1.95, -.28), (ox - 1.75, -.12))
  content((ox + 3.05, -1.0), anchor: "west", [$arrow(e)_2$])
  cur((ox + 2.9, -.7), (ox + 2.0, .28), (ox + 2.6, -.3), (ox + 2.15, .05))
  content((ox + .2, -3.9), [(b)])
})
