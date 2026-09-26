#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 11pt)

#canvas({
  import draw: *

  let ta = (thickness: 1.3pt)
  let tl = (thickness: 2.4pt)

  // dir = +1: counter-clockwise circulation (panel a)
  // dir = -1: top/bottom arrows reversed, heads converge at the
  //            top-right and bottom-left corners (panel b)
  let panel = (ox, dir, tag) => {
    let P = (p) => (p.at(0) + ox, p.at(1))
    let c = (2.05, 2.62)
    let r = .88
    let tr = (c.at(0) + r, c.at(1) + r)
    let tl_ = (c.at(0) - r, c.at(1) + r)
    let br = (c.at(0) + r, c.at(1) - r)
    let bl = (c.at(0) - r, c.at(1) - r)

    let (topa, topb) = if dir > 0 { (tr, tl_) } else { (tl_, tr) }
    let (bota, botb) = if dir > 0 { (bl, br) } else { (br, bl) }

    line(P(topa), P(topb), stroke: tl, mark: (end: ">"))
    line(P(bota), P(botb), stroke: tl, mark: (end: ">"))
    line(P(br), P(tr), stroke: tl, mark: (end: ">"))
    line(P(tl_), P(bl), stroke: tl, mark: (end: ">"))

    circle(P(c), radius: .10, fill: luma(15%), stroke: none)
    content(P((c.at(0), c.at(1) + r + .40)), anchor: "south", [$A_y$])
    content(P((c.at(0), c.at(1) - r - .40)), anchor: "north", [$A_y$])
    content(P((c.at(0) - r - .40, c.at(1))), anchor: "east", [$A_z$])
    content(P((c.at(0) + r + .40, c.at(1))), anchor: "west", [$A_z$])

    line(P((0, 0)), P((0, 3.75)), stroke: ta, mark: (end: ">"))
    line(P((0, 0)), P((3.75, 0)), stroke: ta, mark: (end: ">"))
    line(P((0, 0)), P((0.0 - 2.05, 0.0 - 2.05)), stroke: ta, mark: (end: ">"))
    content(P((0.0 - .28, 3.45)), anchor: "east", [$z$])
    content(P((3.62, 0.0 - .30)), anchor: "north", [$y$])
    content(P((0.0 - 2.25, 0.0 - 2.05)), anchor: "east", [$x$])
    content(P((1.6, 0.0 - 3.35)), anchor: "center", [#(tag)])
  }

  panel(0, 1, "(a)")
  panel(8.2, -1, "(b)")
})
