#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 11.5pt)

#canvas({
  import draw: *

  let ta = (thickness: 1.25pt)
  let tv = (thickness: 2.9pt)

  // a right-handed triad: z up, y right, x down-left at 225°
  let triad = (ox, oy, L, pr) => {
    let P = (p) => (p.at(0) + ox, p.at(1) + oy)
    let d = if pr == "" { "" } else { "'" }
    line(P((0, 0)), P((0, L)), stroke: ta, mark: (end: ">"))
    line(P((0, 0)), P((L, 0)), stroke: ta, mark: (end: ">"))
    line(P((0, 0)), P((0.0 - L * 0.72, 0.0 - L * 0.72)), stroke: ta, mark: (end: ">"))
    content(P((0.10, L + .28)), anchor: "south", [$z#(d)$])
    content(P((L + .28, 0.0 - .10)), anchor: "west", [$y#(d)$])
    content(P((0.0 - L * 0.72 - .22, 0.0 - L * 0.72 - .28)), anchor: "north", [$x#(d)$])
  }

  triad(7.2, 5.0, 3.5, "")
  // primed triad, drawn with the same gap in z' the book shows
  let o = (2.6, 0.8)
  let P = (p) => (p.at(0) + o.at(0), p.at(1) + o.at(1))
  line(P((0, 0)), P((0, 1.85)), stroke: ta)
  line(P((0, 2.55)), P((0, 3.5)), stroke: ta, mark: (end: ">"))
  line(P((0, 0)), P((3.5, 0)), stroke: ta, mark: (end: ">"))
  line(P((0, 0)), P((0.0 - 2.52, 0.0 - 2.52)), stroke: ta, mark: (end: ">"))
  content(P((0.10, 3.78)), anchor: "south", [$z'$])
  content(P((3.78, 0.0 - .10)), anchor: "west", [$y'$])
  content(P((0.0 - 2.74, 0.0 - 2.80)), anchor: "north", [$x'$])

  // the vector, drawn in the unprimed frame but parallel to x'
  line((1.95, 3.55), (-1.35, 0.65), stroke: tv, mark: (end: ">"))
  content((0.15, 3.15), anchor: "east", [$arrow(v)$])
})
