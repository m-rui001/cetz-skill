#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 12pt)

#canvas({
  import draw: *

  let t = (thickness: 0.8pt)
  let dsh = (thickness: 0.8pt, dash: (7pt, 5pt))
  // 148 px of the book figure = 1 canvas unit, origin where the chief ray meets the axis
  let arc = (cx, cy, r, a0, a1, n) => {
    let pts = ()
    for i in range(0, n + 1) {
      let a = (a0 + (a1 - a0) * i / n) * 1deg
      pts.push((cx + r * calc.cos(a), cy + r * calc.sin(a)))
    }
    pts
  }

  // optical axis, aperture plane and screen
  line((-3.56, 0), (4.70, 0), stroke: dsh)
  line((-0.04, 2.76), (-0.04, -3.09), stroke: t)
  line((4.65, 2.56), (4.65, -2.42), stroke: t)

  // the strip lens: flat right face, curved left face, slanted caps
  line((0.43, 1.26), (0.43, -1.30), stroke: t)
  let surf = ()
  for i in range(0, 40) {
    let s = i / 40
    surf.push((0.37 - 0.24 * calc.sin(180deg * s), 1.20 - 2.36 * s))
  }
  line(path: true, ..surf, stroke: t)
  line((0.38, 1.20), (0.43, 1.26), stroke: t)
  line((0.36, -1.16), (0.43, -1.30), stroke: t)

  // aperture width
  line((-0.53, 0.97), (-0.53, -0.99), stroke: (thickness: 1.0pt), mark: (start: ">", end: ">"))
  content((-0.72, 0.45), anchor: "center", [$w$])

  // rays
  line((-4.07, -0.78), (4.70, 0.90), stroke: t)
  line((-0.04, 1.22), (4.63, 0.51), stroke: t)
  line((-0.04, -1.03), (4.63, 0.51), stroke: t)
  line((-1.76, -0.22), (4.70, 0.46), stroke: t)

  // angles
  line(path: true, ..arc(0, 0, 1.79, 0, 10.8, 12), stroke: t)
  line(path: true, ..arc(0, 0, 1.69, 180, 190.8, 12), stroke: t)
  line(path: true, ..arc(3.28, 0, 0.41, 0, 18.2, 12), stroke: t)
  content((1.96, 0.22), anchor: "center", [$theta$])
  content((-1.90, -0.24), anchor: "center", [$theta$])
  content((3.58, 0.22), anchor: "center", [$alpha$])

  // fringe pattern recorded on the screen
  let fr = ()
  for i in range(0, 129) {
    let y = 2.28 - i * 0.032
    fr.push((4.18 + 0.28 * calc.sin((2.28 - y) / 0.52 * 360deg), y))
  }
  line(path: true, ..fr, stroke: t)
  line((4.20, -1.84), (3.52, -2.38), stroke: t)
  content((3.46, -2.44), anchor: "north-east", [$I (alpha)$])
})
