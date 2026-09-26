#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *

  let tb = (thickness: 2.2pt)
  let tt = (thickness: 1.4pt)
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let mul = (s, p) => (s * p.at(0), s * p.at(1))

  let panel = (ox, oy, ang, tag) => {
    let c = calc.cos(ang)
    let s = calc.sin(ang)
    let R = (p) => (c * p.at(0) - s * p.at(1), s * p.at(0) + c * p.at(1))
    let P = (p) => add((ox, oy), R(p))
    let A = add((ox, oy), R((0.55, 0.0 - 2.6)))
    let B = add((ox, oy), R((0.55, 0.0 - 0.75)))
    line(A, B, stroke: tb, mark: (end: ">"))
    line(add((ox, oy), R((0.95, 0.0 - 0.75))), add((ox, oy), R((0.95, 0.0 - 2.6))),
         stroke: tb, mark: (end: ">"))
    line(add((ox, oy), R((0.55, 0.6))), add((ox, oy), R((0.55, 1.6))),
         stroke: tb, mark: (end: ">"))
    circle((ox, oy), radius: .42, stroke: tt)
    content((ox, oy), [#(tag)])
    content(add((ox, oy), R((0.35, 0.0 - 1.7))), anchor: "east", [$arrow(v)_"initial"$])
    content(add((ox, oy), R((1.15, 0.0 - 1.7))), anchor: "west", [$-arrow(v)_"initial"$])
    content(add((ox, oy), R((0.8, 1.15))), anchor: "west", [$arrow(v)_"final"$])
  }

  panel(0, 0, 0deg, [A])
  panel(6.6, 0.4, (0deg - 45deg), [B])

  // panel (c) is drawn flat in the book: arrows above the tag circle
  let K = (13.6, 0.2)
  let W = (p) => add(K, p)
  line(W((-2.7, 0.75)), W((-1.15, 0.75)), stroke: tb, mark: (end: ">"))
  line(W((-1.15, 0.3)), W((-2.7, 0.3)), stroke: tb, mark: (end: ">"))
  line(W((0.5, 0.75)), W((2.7, 0.75)), stroke: tb, mark: (end: ">"))
  circle(K, radius: .42, stroke: tt)
  content(K, [C])
  content(W((-2.7, 1.15)), anchor: "west", [$arrow(v)_"initial"$])
  content(W((-2.4, 0.0 - 0.12)), anchor: "west", [$-arrow(v)_"initial"$])
  content(W((1.1, 1.15)), anchor: "west", [$arrow(v)_"final"$])
})
