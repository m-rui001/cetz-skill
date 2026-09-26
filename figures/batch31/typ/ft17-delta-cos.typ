#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 12pt)

#canvas({
  import draw: *

  let t = (thickness: 1.25pt)
  let tb = (thickness: 2.4pt)

  // ---- top: two impulses at x = +/- a ----
  line((-5.6, 0), (5.6, 0), stroke: t)
  line((0, -0.6), (0, 4.2), stroke: t)
  for xa in (-2.1, 2.1) {
    line((xa, 0), (xa, 2.75), stroke: t)
  }
  content((-2.18, 2.86), anchor: "south-east", [$x = -a$])
  content((2.02, 2.86), anchor: "south-east", [$x = a$])
  content((-0.08, -0.24), anchor: "north-east", text(weight: "bold", [$0$]))
  content((3.35, -0.62), anchor: "north", text(weight: "bold", [$x$]))
  line((3.85, -0.75), (5.15, -0.75), stroke: tb, mark: (end: ">"))

  // ---- bottom: cosine with peak spacing 1/a ----
  let yb = -5.9
  let amp = 1.35
  let per = 2.15
  line((-5.6, yb), (5.6, yb), stroke: t)
  line((0, yb + 2.0), (0, yb - 2.5), stroke: t)

  let pts = ()
  for i in range(201) {
    let x = -5.6 + 11.2 * i / 200
    pts.push((x, yb + amp * calc.cos(2 * calc.pi * x / per)))
  }
  line(path: true, ..pts, stroke: t)

  // 1/a between the two leftmost peaks
  let k1 = -2 * per
  let k2 = -per
  let ya = yb + amp + 0.55
  line((k1, yb + amp), (k1, ya + 0.1), stroke: t)
  line((k2, yb + amp), (k2, ya + 0.1), stroke: t)
  line((k1 + 0.9, ya), (k1 + 0.08, ya), stroke: t, mark: (end: ">"))
  line((k2 - 0.9, ya), (k2 - 0.08, ya), stroke: t, mark: (end: ">"))
  content(((k1 + k2) / 2, ya), anchor: "center", text(weight: "bold", [$1 slash a$]))

  content((1.55, yb - 2.05), anchor: "north", text(weight: "bold", [$p$]))
  line((2.05, yb - 2.18), (3.35, yb - 2.18), stroke: tb, mark: (end: ">"))
})
