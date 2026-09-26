#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 16pt)

#canvas({
  import draw: *

  let t = (thickness: 1.25pt)
  let dsh = (thickness: 1.5pt, dash: (9pt, 6pt))

  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let sub = (p, q) => (p.at(0) - q.at(0), p.at(1) - q.at(1))
  let sc = (p, k) => (p.at(0) * k, p.at(1) * k)

  let arc = (cx, cy, r, a0, a1, n) => {
    let pts = ()
    for i in range(n + 1) {
      let a = a0 + (a1 - a0) * i / n
      pts.push((cx + r * calc.cos(a), cy + r * calc.sin(a)))
    }
    pts
  }

  let A = (9.6, 3.7)
  let B = (-6.0, 5.2)
  let C = add(A, B)
  let p = (0.0, 1.45)
  let q = (0.78, 0.0)

  // axes
  line((-8.0, 0), (10.1, 0), stroke: t)
  line((0, 0), (0, 9.6), stroke: t)
  content((0, -0.32), anchor: "north", [real axis])
  content((-0.45, 8.1), anchor: "east", [imaginary \ axis])

  // dashed parallels that close the parallelogram rule
  line(B, C, stroke: dsh)
  line(A, C, stroke: dsh)

  // uncertainty arrows through the tip, masked by the region drawn on top
  line(sub(C, sc(p, 1.2)), add(C, sc(p, 1.2)), stroke: t,
    mark: (start: ">", end: ">"))
  line(sub(C, sc(q, 1.3)), add(C, sc(q, 1.3)), stroke: t,
    mark: (start: ">", end: ">"))

  // hatched uncertainty region at the tip of c
  let verts = (add(C, p), add(C, q), sub(C, p), sub(C, q))
  line(close: true, fill: white, ..verts)
  for i in range(-6, 7) {
    let dx = i * 0.12
    let half = p.at(1) * (1 - calc.abs(dx) / q.at(0))
    if half > 0.12 {
      line((C.at(0) + dx, C.at(1) - half), (C.at(0) + dx, C.at(1) + half), stroke: t)
    }
  }
  line(close: true, stroke: t, ..verts)

  // the three phasors
  line((0, 0), A, stroke: t, mark: (end: ">"))
  line((0, 0), B, stroke: t, mark: (end: ">"))
  line((0, 0), sub(C, sc(p, 0.8)), stroke: t, mark: (end: ">"))

  // curved double arrows at the free tips
  line(path: true, ..arc(B.at(0), B.at(1), 0.9, 99deg, 214deg, 24),
    stroke: t, mark: (start: ">", end: ">"))
  line(path: true, ..arc(A.at(0), A.at(1), 0.9, -39deg, 81deg, 24),
    stroke: t, mark: (start: ">", end: ">"))

  content((2.82, 4.95), anchor: "center", [$overline(c)$])
  content((-3.02, 3.03), anchor: "center", [$overline(b)$])
  content((4.73, 2.2), anchor: "center", [$overline(a)$])
})
