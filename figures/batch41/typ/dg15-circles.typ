#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 46pt)

#canvas({
  import draw: *

  let t = (thickness: 4pt)
  let hd = (symbol: ">", fill: black, length: 30pt, width: 19pt)
  let ell = (cx, cy, rx, ry) => {
    let pts = ()
    for i in range(0, 73) {
      let a = i / 72 * 360deg
      pts.push((cx + rx * calc.cos(a), cy + ry * calc.sin(a)))
    }
    pts
  }

  line(path: true, ..ell(0, 0, 2.628, 4.851), stroke: t)
  circle((0, 0), radius: 0.28, fill: black, stroke: none)
  line((0, 0), (2.628, 0), stroke: t, mark: (end: hd))
  content((1.155, 1.223), anchor: "center", [$a$])

  let c = 6.635
  line(path: true, ..ell(c, 0, 3.746, 4.561), stroke: t)
  circle((c, 0), radius: 0.28, fill: black, stroke: none)
  line((c, 0), (c + 3.746, 0), stroke: t, mark: (end: hd))
  line((c, 0), (c, 4.561), stroke: t, mark: (end: hd))
  content((c - 0.716, 1.797), anchor: "center", [$b$])
  content((c + 1.581, -0.973), anchor: "center", [$a$])
})
