#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 14pt)

#canvas({
  import draw: *

  let t = (thickness: 0.5pt)
  // 148 px of the book figure = 1 canvas unit; origin where x, y and z meet

  // axes: no arrowheads in the source
  line((-2.54, -1.00), (3.10, 1.22), stroke: t)   // x
  line((-3.72, 1.69), (3.28, -1.49), stroke: t)   // y
  line((0.00, 0.04), (0.00, 2.51), stroke: t)     // z
  content((-3.75, 1.80), anchor: "center", [$y$])
  content((3.21, 1.37), anchor: "center", [$x$])

  // the band runs along y, offset from the axis; both ends are torn off
  let ua = (-2.99, 2.37)
  let ub = (3.16, -0.07)
  let la = (-3.16, 1.97)
  let lb = (3.21, -0.73)
  line(ua, ub, stroke: t)
  line(la, lb, stroke: t)

  let tear = (p, q) => {
    let d = (q.at(0) - p.at(0), q.at(1) - p.at(1))
    let n = (-d.at(1) * 0.30, d.at(0) * 0.30)
    let pts = ()
    for i in range(7) {
      let s = i / 6
      let w = if i == 0 or i == 6 { 0.0 } else if calc.even(i) { 0.5 } else { -0.5 }
      pts.push((p.at(0) + d.at(0) * s + n.at(0) * w, p.at(1) + d.at(1) * s + n.at(1) * w))
    }
    pts
  }
  line(path: true, ..tear(ua, la), stroke: t)
  line(path: true, ..tear(lb, ub), stroke: t)

  // offset measured along x, from the y axis to the near edge
  line((1.10, -0.47), (1.82, -0.15), stroke: t, mark: (start: ">", end: ">"))
  content((1.44, -0.06), anchor: "center", [$a$])
})
