#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let tv = (thickness: 2.4pt)
  let a = 31deg
  let u = (calc.cos(a), calc.sin(a))
  let n = (0.0 - calc.sin(a), calc.cos(a))
  let s = .75
  let rr = .27
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let mul = (k, w) => (k * w.at(0), k * w.at(1))
  let C = (0.2, 0.0)
  let B = add(C, mul(s, n))
  let ca = (i, j) => add(B, add(mul(i * (s - rr), u), mul(j * (s - rr), n)))
  line(add(C, mul(-3.9, u)), add(C, mul(3.9, u)), stroke: th)
  line(add(ca(-1, 1), mul(rr, n)), add(ca(1, 1), mul(rr, n)), stroke: th)
  line(add(ca(-1, -1), mul(0.0 - rr, n)), add(ca(1, -1), mul(0.0 - rr, n)),
       stroke: th)
  line(add(ca(1, -1), mul(rr, u)), add(ca(1, 1), mul(rr, u)), stroke: th)
  line(add(ca(-1, -1), mul(0.0 - rr, u)), add(ca(-1, 1), mul(0.0 - rr, u)),
       stroke: th)
  for c in ((ca(1, 1), 0deg), (ca(-1, 1), 90deg), (ca(-1, -1), 180deg),
            (ca(1, -1), 270deg)) {
    let A = c.at(0)
    let st = a + c.at(1)
    arc(add(A, mul(rr, (calc.cos(st), calc.sin(st)))), radius: rr,
        start: st, stop: st + 90deg, stroke: th)
  }
  line(B, add(B, (0, 0.0 - 2.25)), stroke: tv, mark: (end: ">"))
  line(B, add(B, mul(1.6, n)), stroke: tv, mark: (end: ">"))
  content((B.at(0) + .32, B.at(1) - 2.45), anchor: "west", [$arrow(F)_g$])
  content((B.at(0) + 1.6 * n.at(0) + .18, B.at(1) + 1.6 * n.at(1) + .22),
          anchor: "west", [$arrow(F)_n$])
})
