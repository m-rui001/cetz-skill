#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 7pt)

#canvas({
  import draw: *

  let t = (thickness: 0.45pt)
  let dsh = (thickness: 0.45pt, dash: (6pt, 5pt))
  // 148 px of the book figure = 1 canvas unit, origin at O where axis, screen-line and rays meet
  let P = (5.38, 1.34)
  let Q = (0.22, 0.66)

  // incoming wavefronts and the arrow that pushes them along
  for x in (-1.65, -1.09) { line((x, 1.07), (x, -1.08), stroke: dsh) }
  line((-2.11, 0.35), (-0.63, 0.35), stroke: t, mark: (end: ">"))

  // optical axis, aperture plane S and the screen
  line((-2.11, 0), (5.39, 0), stroke: t)
  line((0, 2.35), (0, -2.15), stroke: t)
  line((5.38, 2.43), (5.38, -1.43), stroke: t)
  content((0.12, 2.42), anchor: "south-west", [$S$])

  // the two paths to the observation point
  line((0, 0), P, stroke: t)
  line(Q, P, stroke: t)
  line((0, 0), Q, stroke: t)
  content((-0.14, -0.06), anchor: "north-east", [$O$])
  content((0.30, 0.72), anchor: "south-west", [$Q$])
  content((5.46, 1.30), anchor: "west", [$P$])

  // path difference x sin(theta) marked off O, and the small delta-x foot at Q
  line((0.20, -0.10), (0.62, -0.52), stroke: t)
  content((0.72, -0.58), anchor: "north-west", [$x. sin theta$])
  line((0.02, 0.74), (0.22, 0.66), stroke: t)
  content((-0.14, 0.60), anchor: "east", [$delta x$])

  // height x of the secondary source above O
  line((-0.22, 0.48), (-0.22, 2.07), stroke: t, mark: (end: ">"))
  line((-0.22, 0.10), (-0.22, 0.30), stroke: t)
  content((-0.36, 1.32), anchor: "east", [$x$])

  // theta between the axis and the chief ray
  content((1.82, 0.13), anchor: "center", [$theta$])
  line((1.62, 0.92), (1.78, 0.62), stroke: t, mark: (end: ">"))
  line((1.62, -0.36), (1.72, -0.06), stroke: t, mark: (end: ">"))

  content((3.05, 0.46), anchor: "center", [$r_0$])
  content((2.55, 1.34), anchor: "center", [$r_0 - x. sin theta$])

  // propagation coordinate along the axis
  line((3.20, -0.46), (3.55, -0.46), stroke: t)
  line((3.85, -0.46), (4.25, -0.46), stroke: t, mark: (end: ">"))
  content((3.70, -0.46), anchor: "center", [$z$])

  // intensity recorded on the screen, drawn to the left of it
  let fr = ()
  for i in range(0, 120) {
    let y = -1.40 + i * 0.032
    let a = y / 0.85 * 360deg
    let x = 5.12 + 0.60 * calc.exp(-calc.pow(y / 0.22, 2)) + 0.07 * calc.cos(a) * calc.exp(-calc.abs(y) / 1.30)
    fr.push((x, y))
  }
  line(path: true, ..fr, stroke: t)
})
