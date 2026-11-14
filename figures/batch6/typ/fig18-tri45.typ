#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  line((0, 0), (0, 2.35), mark: (end: "stealth", fill: black))
  content((-.25, 2.4), [$y$])
  let A = (2.04, 4.36)
  let Bp = (5.18, 3.91)
  let Cp = (.40, 3.91)
  let B = (.51, 1.67)
  let C = (5.45, 1.67)
  let Ap = (2.18, .09)
  line(A, B, C, close: true)
  line(Ap, Bp, Cp, close: true)
  // dashed theta arcs at C', C, A'
  let r = .7
  // arc 的 pos 是弧起点；起点放在顶点圆上，圆心即顶点。扫描方向为逆时针短弧。
  arc((Cp.at(0) + r * calc.cos(-65deg), Cp.at(1) + r * calc.sin(-65deg)),
    radius: r, start: -65deg, stop: 0deg, stroke: (dash: "dashed"))
  arc((C.at(0) + r * calc.cos(142deg), C.at(1) + r * calc.sin(142deg)), radius: r,
    start: 142deg, stop: 180deg, stroke: (dash: "dashed"))
  arc((Ap.at(0) + r * calc.cos(52deg), Ap.at(1) + r * calc.sin(52deg)), radius: r,
    start: 52deg, stop: 115deg, stroke: (dash: "dashed"))
  content((1.01, 3.52), [$theta$])
  content((4.77, 1.91), [$theta$])
  content((2.26, 0.81), [$theta$])
  content((1.95, 4.55), [A])
  content((5.5, 3.95), [B#sym.prime])
  content((.05, 4.0), [C#sym.prime])
  content((.3, 1.45), [B])
  content((5.75, 1.6), [C])
  content((2.1, -.25), [A#sym.prime])
})
