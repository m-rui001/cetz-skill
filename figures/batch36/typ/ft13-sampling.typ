#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 10pt)

#canvas({
  import draw: *

  let t = (thickness: 1.0pt)
  // 148 px of the book figure = 1 canvas unit, y up from the bottom edge
  let g = (x, c, w) => calc.exp(-calc.pow((x - c) / w, 2))
  // one wavelet: a tall positive bump followed by a shallow negative dip
  let wave = (x, c) => 0.30 * g(x, c, 0.105) - 0.10 * g(x, c + 0.30, 0.11)
  let envelope = (x, c, h) => h * g(x, c, 0.95) - 0.17 * h / 0.66 * g(x, c, 0.17)
  let curve = (x0, x1, step, f) => {
    let pts = ()
    let n = int((x1 - x0) / step)
    for i in range(0, n + 1) { pts.push((x0 + i * step, f(x0 + i * step))) }
    pts
  }

  // ---- panel A: Phi(v), one wavelet above a short axis
  let ya = 4.34
  line((1.31, ya), (2.26, ya), stroke: t)
  line((1.45, ya), (1.45, 4.69), stroke: t)
  line(path: true, ..curve(1.36, 2.22, 0.012, x => wave(x, 1.66) + ya), stroke: t)
  content((2.10, 4.62), anchor: "center", [$Phi (v)$])
  line((1.66, 4.17), (1.66, 3.70), stroke: t, mark: (end: ">"))

  // ---- panel B: Phi_s(v), the wavelet repeated with period 0.54
  let yb = 3.20
  line((0.74, yb), (2.23, yb), stroke: t)
  line((1.45, yb), (1.45, 3.56), stroke: t)
  line(path: true, ..curve(0.62, 2.30, 0.012, x => {
    let s = 0
    for k in range(-2, 2) { s = s + wave(x, 1.66 + k * 0.56) }
    s + yb
  }), stroke: t)
  content((2.06, 3.62), anchor: "center", [$Phi_s (v)$])
  line((2.64, 3.34), (3.11, 3.34), stroke: t, mark: (end: ">"))

  // ---- panel C: Phi_p(v), the train stretched out
  line((3.51, yb), (8.69, yb), stroke: t)
  line(path: true, ..curve(3.44, 8.72, 0.014, x => {
    let s = 0
    for k in range(0, 5) { s = s + wave(x, 4.05 + k * 1.16) }
    s + yb
  }), stroke: t)
  for x in (4.56, 5.71, 7.16) { line((x, yb), (x, 3.56), stroke: t) }
  content((6.30, 3.90), anchor: "center", [$Phi_p (v)$])

  // ---- panel D: F(t), the smooth spectrum with a central dip
  let yd = 1.13
  line((0.04, yd), (2.84, yd), stroke: t)
  line((1.45, yd), (1.45, 1.80), stroke: t)
  line(path: true, ..curve(0.04, 2.84, 0.02, x => envelope(x, 1.45, 0.66) + yd), stroke: t)
  content((1.78, 2.16), anchor: "center", [$F (t)$])

  // the two vertical double arrows that tie the panels together
  for x in (1.28, 1.42) {
    let d = if x < 1.35 { (2.95, 2.51) } else { (2.51, 2.95) }
    line((x, d.at(0)), (x, d.at(1)), stroke: t, mark: (end: ">"))
  }
  for x in (5.54, 5.68) {
    let d = if x < 5.61 { (2.95, 2.51) } else { (2.51, 2.95) }
    line((x, d.at(0)), (x, d.at(1)), stroke: t, mark: (end: ">"))
  }

  // ---- panel E: the sampled comb under a dashed envelope
  line((4.32, yd), (7.15, yd), stroke: t)
  line((5.71, yd), (5.71, 2.11), stroke: t)
  for k in range(-4, 5) {
    let x = 5.71 + k * 0.34
    let h = calc.max(0.05, envelope(x, 5.71, 0.95))
    line((x, yd), (x, yd + h), stroke: t)
  }
  line(path: true, ..curve(4.36, 7.06, 0.04, x => envelope(x, 5.71, 0.95) + yd + 0.06),
    stroke: (thickness: 1.0pt, dash: (4pt, 3pt)))

  // leaders down to alpha_0, alpha_1, alpha_2
  for (x0, y0, x1) in ((5.90, 1.55, 6.05), (6.24, 1.30, 6.72), (6.58, 1.15, 7.50)) {
    line((x0, y0), (x1, 0.20), stroke: t)
  }
  content((5.95, 0.12), anchor: "north", [$alpha_0$])
  content((6.72, 0.12), anchor: "north", [$alpha_1$])
  content((7.50, 0.12), anchor: "north", [$alpha_2$])
  content((8.10, 0.12), anchor: "north", [etc.])
})
