#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1.1pt)
  let pt = (i) => (calc.cos(i * 45deg), calc.sin(i * 45deg))
  let mul = (k, w) => (k * w.at(0), k * w.at(1))
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let panel = (ox, out, sgn) => {
    for i in range(8) {
      let d = pt(i)
      line(add((ox, 0), mul(.55, d)), add((ox, 0), mul(3.4, d)), stroke: th)
      if out {
        line(add((ox, 0), mul(1.6, d)), add((ox, 0), mul(2.1, d)),
             stroke: th, mark: (end: ">"))
      } else {
        line(add((ox, 0), mul(2.1, d)), add((ox, 0), mul(1.6, d)),
             stroke: th, mark: (end: ">"))
      }
    }
    if sgn {
      line((ox - .2, 0), (ox + .2, 0), stroke: th)
      line((ox, -.2), (ox, .2), stroke: th)
    } else {
      line((ox - .22, 0), (ox + .22, 0), stroke: (thickness: 1.6pt))
    }
  }
  panel(-4.4, true, true)
  panel(4.4, false, false)
  content((-4.4, -4.3), [(a)])
  content((4.4, -4.3), [(b)])
})
