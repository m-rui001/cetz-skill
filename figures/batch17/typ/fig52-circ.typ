#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let tv = (thickness: 1.8pt)
  let panel = (ox, cw) => {
    line((ox, 0), (ox, 3.0), stroke: th, mark: (end: ">"))
    line((ox, 0), (ox + 3.0, 0), stroke: th, mark: (end: ">"))
    line((ox, 0), (ox - 1.5, -1.5), stroke: th, mark: (end: ">"))
    content((ox - .16, 2.72), anchor: "east", [$z$])
    content((ox + 3.05, -.38), anchor: "west", [$y$])
    content((ox - 1.38, -1.62), anchor: "west", [$x$])
    let s = .62
    let cx = ox + 1.75
    let cy = 2.05
    let bl = (cx - s, cy - s)
    let br = (cx + s, cy - s)
    let tr = (cx + s, cy + s)
    let tl = (cx - s, cy + s)
    circle((cx, cy), radius: .07, fill: black, stroke: none)
    if cw {
      line(br, tr, stroke: tv, mark: (end: ">"))
      line(tr, tl, stroke: tv, mark: (end: ">"))
      line(tl, bl, stroke: tv, mark: (end: ">"))
      line(bl, br, stroke: tv, mark: (end: ">"))
    } else {
      line(tl, tr, stroke: tv, mark: (end: ">"))
      line(br, tr, stroke: tv, mark: (end: ">"))
      line(tl, bl, stroke: tv, mark: (end: ">"))
      line(br, bl, stroke: tv, mark: (end: ">"))
    }
    content((cx, cy + s + .3), [$A_y$])
    content((cx, cy - s - .3), [$A_y$])
    content((cx - s - .28, cy), anchor: "east", [$A_z$])
    content((cx + s + .28, cy), anchor: "west", [$A_z$])
  }
  panel(0, true)
  content((.4, -2.6), [(a)])
  panel(6.6, false)
  content((7.0, -2.6), [(b)])
})
