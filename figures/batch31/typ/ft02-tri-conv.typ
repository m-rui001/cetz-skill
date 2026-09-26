#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 12pt)

#canvas({
  import draw: *

  let t = (thickness: 1.25pt)
  let dsh = (thickness: 1.25pt, dash: "dashed")
  let u = (a) => (calc.cos(a), calc.sin(a))
  let sc = (p, k) => (p.at(0) * k, p.at(1) * k)
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))

  // ---- top row: triangle wave train ----
  let w = 1.0
  let hh = 1.55
  let x0 = -0.2
  for k in range(7) {
    let a = x0 + k * w
    line((a, 0), (a + w/2, hh), (a + w, 0), stroke: t)
  }
  line((-1.2, 0), (9.2, 0), stroke: t)
  line((3.8, -0.5), (3.8, 4.0), stroke: t)
  line((7.0, 0), (7.45, 0.7), stroke: dsh)

  content((0.1, -2.3), anchor: "center", text(size: 22pt, weight: "bold", [$=$]))

  // ---- bottom row: rect * rect * comb ----
  let yb = -5.6
  let rectf = (cx) => {
    line((cx - 1.5, yb), (cx + 1.5, yb), stroke: t)
    line((cx, yb - 0.55), (cx, yb + 2.6), stroke: t)
    line((cx - .62, yb), (cx - .62, yb + 1.5), stroke: t)
    line((cx - .62, yb + 1.5), (cx + .62, yb + 1.5), stroke: t)
    line((cx + .62, yb + 1.5), (cx + .62, yb), stroke: t)
  }
  rectf(0.6)
  content((2.6, yb + 0.85), anchor: "center", text(size: 20pt, weight: "bold", [$* $]))
  rectf(4.6)
  content((6.6, yb + 0.85), anchor: "center", text(size: 20pt, weight: "bold", [$* $]))

  let xc = 9.6
  line((8.0, yb), (12.2, yb), stroke: t)
  for k in range(4) {
    line((xc - 1.5 + k * 1.0, yb), (xc - 1.5 + k * 1.0, yb + 2.4), stroke: t)
  }
  line((11.3, yb + 1.75), (12.5, yb + 1.75), stroke: dsh, mark: (end: ">"))
})
