#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *

  let ta = (thickness: 1.2pt)
  let tv = (thickness: 3.4pt)
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let u = (a) => (calc.cos(a), calc.sin(a))
  let sc = (p, k) => (p.at(0) * k, p.at(1) * k)

  let axes = (ox) => {
    line((ox, 0), (ox, 3.45), stroke: ta, mark: (end: ">"))
    line((ox, 0), (ox + 3.05, 0), stroke: ta, mark: (end: ">"))
    line((ox, 0), (ox - 1.62, 0.0 - 1.62), stroke: ta, mark: (end: ">"))
  }

  // panel (a): a single vector sitting in the y–z octant
  axes(0)
  line((0.95, 0.72), add((0.95, 0.72), sc(u(45deg), 1.75)), stroke: tv, mark: (end: ">"))
  content((1.1, 0.0 - 2.55), anchor: "center", [(a)])

  // panel (b): the same vector spread into a field — three rows of arrows
  // fanning outward from the z axis
  let o = 7.6
  axes(o)
  let arrow = (tx, ty, ang, len) => {
    let t = (tx + o, ty)
    line(t, add(t, sc(u(ang), len)), stroke: tv, mark: (end: ">"))
  }

  arrow(-0.88, -0.95, 102deg, 1.80)
  arrow(-0.20, -0.98, 96deg, 1.85)
  arrow(0.55, -0.98, 91deg, 1.85)
  arrow(1.30, -0.95, 79deg, 1.80)

  arrow(-1.55, 1.05, 133deg, 1.40)
  arrow(-0.62, 1.55, 112deg, 1.40)
  arrow(0.42, 1.52, 92deg, 1.40)
  arrow(1.38, 1.05, 66deg, 1.40)

  arrow(-1.95, 2.55, 140deg, 1.35)
  arrow(-0.95, 3.05, 118deg, 1.35)
  arrow(0.18, 3.15, 97deg, 1.35)
  arrow(1.30, 2.85, 68deg, 1.35)

  content((o + 1.1, 0.0 - 2.55), anchor: "center", [(b)])
})
