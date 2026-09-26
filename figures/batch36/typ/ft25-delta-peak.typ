#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 13pt)
#canvas({
  import draw: *
  let t = (thickness: 0.9pt)
  // 100 px of the book figure = 1 canvas unit; panel (b) baseline is y = 0
  let ya = 6.05
  // ---- (a)  delta at the origin and a second one at lambda_0
  content((-0.55, ya + 2.35), anchor: "north-west", [(a)])
  line((0.50, ya), (7.90, ya), stroke: t)
  line((1.10, ya), (1.10, 9.60), stroke: t)
  line((5.25, ya), (5.25, 8.42), stroke: t)
  content((5.45, ya - 0.12), anchor: "north", [$delta (lambda - lambda_0)$])
  // ---- (b)  the same two lines broadened into a peak
  content((-0.55, 3.05), anchor: "north-west", [(b)])
  line((0.55, 0), (8.00, 0), stroke: t)
  line((1.20, 0), (1.20, 3.05), stroke: t)
  line((5.25, 0), (5.25, 3.75), stroke: t)
  let pts = ()
  for i in range(0, 71) {
    let x = 4.05 + i * 0.045
    let u = x - 5.25
    let h = 2.30 / (1 + calc.pow(u / 0.36, 2))
    h = h + 0.16 * calc.exp(-calc.pow((u - 0.95) / 0.50, 2))
    pts.push((x, h))
  }
  line(path: true, ..pts, stroke: t)
  content((5.55, -0.12), anchor: "north", [$I (lambda - lambda_0)$])
})