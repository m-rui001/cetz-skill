#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 7.5pt)

#canvas({
  import draw: *

  let t = (thickness: 0.4pt)
  let dsh = (thickness: 0.55pt, dash: (7pt, 5pt))
  let a = 2.30
  let amp = 1.764
  let prof = (x) => amp / (1 + calc.pow(x / a, 2))

  line((-4.43, 0), (4.43, 0), stroke: t)
  circle((0, 0), radius: 0.05, stroke: t, fill: white)
  for x in (-1.95, 0.0, 1.96) { line((x, 0), (x, prof(x)), stroke: t) }
  let pts = ()
  for i in range(0, 149) {
    let x = -4.43 + i * 0.0595
    pts.push((x, prof(x)))
  }
  line(path: true, ..pts, stroke: dsh)

  content((-1.54, 2.92), anchor: "center", [$Gamma (p)$])
  line((-1.50, 2.73), (-0.68, 1.84), stroke: t, mark: (end: (symbol: ">", fill: black)))
  content((-3.28, 1.63), anchor: "center", [$Gamma (r) med delta (p + r)$])
  line((-2.82, 1.40), (-1.99, 0.52), stroke: t, mark: (end: (symbol: ">", fill: black)))
  content((3.29, 1.94), anchor: "center", [$Gamma (r) med delta (p - r)$])
  line((2.97, 1.77), (2.05, 0.72), stroke: t, mark: (end: (symbol: ">", fill: black)))

  content((1.13, -0.12), anchor: "center", [$p$])
  line((1.29, -0.12), (1.67, -0.12), stroke: t, mark: (end: (symbol: ">", fill: black)))
})
