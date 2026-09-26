#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 12pt)

#canvas({
  import draw: *

  let t = (thickness: 1.15pt)
  // book figure is ~1000 px wide; 133 px per canvas unit keeps text and ink matched
  let k = 2.2

  let r = (deg) => {
    if deg < 35 {
      0.99 - 0.0014 * deg
    } else if deg < 80 {
      0.94 - 0.006 * (deg - 35)
    } else {
      calc.max(0.60, 0.67 - 0.00025 * (deg - 80))
    }
  }
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let v = (rr, deg) => (rr * k * calc.cos(deg * 1deg), rr * k * calc.sin(deg * 1deg))

  // axes
  line((-1.72 * k, 0), (1.70 * k, 0), stroke: t)
  line((0, -0.80 * k), (0, 1.23 * k), stroke: t)
  line((-1.02 * k, -0.05 * k), (-1.02 * k, 0.09 * k), stroke: t)
  content((-1.02 * k, -0.16 * k), anchor: "north", [#text(style: "italic")[−1,0]])
  content((1.02 * k, -0.16 * k), anchor: "north", [#text(style: "italic")[1,0]])

  // spiral
  let pts = ()
  for i in range(0, 135) {
    let deg = i * 2.5
    pts.push(v(r(deg), deg))
  }
  line(path: true, ..pts, stroke: t)

  // the four vectors
  let V1 = v(0.86, 35)
  let V2 = v(0.63, 78)
  let V3 = v(0.62, 137)
  let V4 = v(0.60, 163)
  for p in (V1, V2, V3, V4) {
    line((0, 0), p, stroke: t, mark: (end: ">"))
  }
  content(add(V1, (0.10, 0.16)), anchor: "south-west", [$v_1$])
  content(add(V2, (0.13, 0.15)), anchor: "south-west", [$v_2$])
  content(add(V3, (-0.10, 0.12)), anchor: "south-east", [$v_3$])
  content(add(V4, (-0.11, 0.06)), anchor: "south-east", [$v_4$])
})
