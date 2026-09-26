#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1.2pt)
  let td = (dash: "dashed", thickness: 1pt)
  let m1 = (1.7, -1.36)
  let m2 = (3.57, 0.68)
  let m3 = (-0.43, 0.68)
  let m4 = (-2.38, -1.36)
  let m5 = (0, 3.4)
  line((0, 0), (0, 4.2), stroke: th, mark: (end: ">"))
  line((0, 0), (5.95, 0), stroke: th, mark: (end: ">"))
  line((0, 0), (-1.96, -2.98), stroke: th, mark: (end: ">"))
  content((0.3, 4.05), anchor: "west", [$z$])
  content((6.05, -.7), anchor: "west", [$y$])
  content((-1.75, -3.35), anchor: "west", [$x$])
  for e in ((m3, m2), (m3, m4), (m4, m1), (m1, m2), (m5, m1), (m5, m2), (m5, m3), (m5, m4)) {
    line(e.at(0), e.at(1), stroke: td)
  }
  for p in (m1, m2, m3, m4, m5) { circle(p, radius: .11, fill: black, stroke: none) }
  content((0.35, 3.5), anchor: "west", [$m_5 (0, 0, 2a)$])
  content((-0.4, 1.6), anchor: "east", [$2a$])
  content((3.9, 1.05), anchor: "west", [$m_2$])
  content((3.9, 0.2), anchor: "west", [$(-a, a, 0)$])
  content((3.35, 0.1), anchor: "east", [$a$])
  content((2.85, -0.7), anchor: "west", [$a$])
  content((-0.45, 0.15), [$m_3$])
  content((-0.55, -0.55), anchor: "east", [$(-a, -a, 0)$])
  content((-2.55, -1.85), [$m_4$])
  content((-2.7, -2.45), [$(a, -a, 0)$])
  content((-1.45, -1.05), [$a$])
  content((0.17, -1.05), [$a$])
  content((2.1, -1.85), [$m_1$])
  content((2.2, -2.45), [$(a, a, 0)$])
})
