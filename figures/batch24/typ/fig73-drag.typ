#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *

  let tg = (thickness: 2.2pt, paint: luma(58%))
  let tb = (thickness: 2.2pt)
  let tt = (thickness: 1.3pt)
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))

  let eq = [$Delta v = arrow(v)_"final" - arrow(v)_"initial"$]

  let panel = (ox, oy, ang, tag) => {
    let c = calc.cos(ang)
    let s = calc.sin(ang)
    let R = (p) => (c * p.at(0) - s * p.at(1), s * p.at(0) + c * p.at(1))
    let P = (p) => add((ox, oy), R(p))

    line(P((0, 0)), P((0, 2.0)), stroke: tg, mark: (end: ">"))
    line(P((0.32, 2.0)), P((0.32, 0.0 - 0.05)), stroke: tg, mark: (end: ">"))
    line(P((0, 0.85)), P((0, 0.0 - 0.05)), stroke: tb, mark: (end: ">"))

    content(P((-0.28, 1.8)), anchor: "east", [$arrow(v)_"final"$])
    content(P((0.5, 1.5)), anchor: "west", [$-arrow(v)_"initial"$])
    content(P((-0.62, 0.0 - 0.75)), anchor: "west", eq)
    bezier(P((0.0 - 0.5, 0.0 - 0.3)), P((0.0 - 0.08, 0.42)),
           P((0.0 - 0.75, 0.15)), P((0.0 - 0.35, 0.42)),
           stroke: tt, mark: (end: ">"))
    circle(P((0.0 - 0.1, 0.0 - 2.1)), radius: .42, stroke: tt)
    content(P((0.0 - 0.1, 0.0 - 2.1)), [#(tag)])
  }

  panel(0, 0, 0deg, [A])
  panel(4.0, 0.2, (0deg - 30deg), [B])

  // panel (c): in the book the resultant points along v_final and the tag sits below
  let K = (7.9, 0.6)
  let W = (p) => add(K, p)
  line(W((0, 0)), W((2.0, 0)), stroke: tg, mark: (end: ">"))
  line(W((2.0, 0.0 - 0.32)), W((0, 0.0 - 0.32)), stroke: tg, mark: (end: ">"))
  line(W((0, 0)), W((0.9, 0)), stroke: tb, mark: (end: ">"))
  content(W((0.35, 0.35)), anchor: "west", [$arrow(v)_"final"$])
  content(W((1.75, 0.0 - 0.5)), anchor: "west", [$-arrow(v)_"initial"$])
  content(W((0.0 - 0.1, 0.0 - 1.15)), anchor: "west", eq)
  bezier(W((0.0 - 0.15, 0.0 - 0.72)), W((0.0 - 0.05, 0.0 - 0.12)),
         W((0.0 - 0.45, 0.0 - 0.5)), W((0.0 - 0.2, 0.0 - 0.2)),
         stroke: tt, mark: (end: ">"))
  circle(W((0.55, 0.0 - 1.85)), radius: .42, stroke: tt)
  content(W((0.55, 0.0 - 1.85)), [C])
})
