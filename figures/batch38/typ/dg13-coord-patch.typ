#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 24pt)

#canvas({
  import draw: *

  let t = (thickness: 2pt)
  let ucurve = (x) => 0.0058 + 0.01152 * x - 0.03552 * x * x
  let vcurve = (y) => 0.013 + 0.1072 * y - 0.0376 * y * y
  let ccurve = (x) => 0.0196 + 0.8656 * x + 0.0238 * x * x - 0.0248 * x * x * x

  let sample = (x0, x1, f) => {
    let pts = ()
    for i in range(0, 61) {
      let x = x0 + (x1 - x0) * i / 60
      pts.push((x, f(x)))
    }
    pts
  }
  let ysample = (y0, y1, f) => {
    let pts = ()
    for i in range(0, 61) {
      let y = y0 + (y1 - y0) * i / 60
      pts.push((f(y), y))
    }
    pts
  }

  line(path: true, ..sample(-4.16, 3.89, ucurve), stroke: t)
  line(path: true, ..ysample(-2.30, 2.98, vcurve), stroke: t)
  line(path: true, ..sample(-2.95, 3.53, ccurve), stroke: t)

  line((0.03, 0.905), (0.919, 0.905), stroke: t)
  line((0.919, 0.905), (0.919, -0.014), stroke: t)

  let lead = ()
  for i in range(0, 30) {
    let s = i / 30
    let a = (2.62, 0.78)
    let c = (1.50, 0.22)
    let b = (0.48, 0.40)
    lead.push((
      (1 - s) * (1 - s) * a.at(0) + 2 * s * (1 - s) * c.at(0) + s * s * b.at(0),
      (1 - s) * (1 - s) * a.at(1) + 2 * s * (1 - s) * c.at(1) + s * s * b.at(1)
    ))
  }
  line(path: true, ..lead, stroke: t, mark: (end: (symbol: ">", fill: black)))

  content((-1.36, 2.24), anchor: "center", [$v$ CC])
  content((-2.88, 0.24), anchor: "center", [$u$ CC])
  content((-0.58, 0.45), anchor: "center", [$d v$])
  content((-1.63, -1.55), anchor: "center", [$C$])
  content((0.45, -0.60), anchor: "center", [$d u$])
  content((2.76, 1.02), anchor: "center", [$d s$])
})
