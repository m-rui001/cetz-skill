#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let A = (1.85, .45)
  let B = (-.55, 2.05)
  let S = (A.at(0) + B.at(0), A.at(1) + B.at(1))
  // ---- (a) ----
  line((-.9, 0), (3.1, 0), mark: (end: ">"))
  line((-.05, -.6), (-.05, 2.9), mark: (end: ">"))
  content((3.2, -.35), [$x$])
  content((.2, 2.75), [$y$])
  line((0, 0), A, mark: (end: ">"))
  line((0, 0), B, mark: (end: ">"))
  content((A.at(0) - .15, A.at(1) + .22), [$arrow(A)$])
  content((B.at(0) - .6, B.at(1) - .1), [$arrow(B)$])
  content((-.35, -1.6), [(a)])
  // ---- (b) ----
  let ox = 5.2
  line((ox - .9, 0), (ox + 3.1, 0), mark: (end: ">"))
  line((ox - .05, -.6), (ox - .05, 3.3), mark: (end: ">"))
  content((ox + 3.2, -.35), [$x$])
  content((ox + .2, 3.15), [$y$])
  line((ox, 0), (ox + A.at(0), A.at(1)), mark: (end: ">"))
  line((ox, 0), (ox + B.at(0), B.at(1)), mark: (end: ">"))
  line((ox, 0), (ox + S.at(0), S.at(1)), mark: (end: ">"))
  line((ox + A.at(0), A.at(1)), (ox + S.at(0), S.at(1)), stroke: (dash: "dashed"))
  content((ox + A.at(0) - .2, A.at(1) + .22), [$arrow(A)$])
  content((ox + B.at(0) - .62, B.at(1) - .1), [$arrow(B)$])
  content((ox + .35, S.at(1) - .75), [$arrow(A) + arrow(B)$])
  content((ox + 1.0, S.at(1) - 1.35), [$arrow(C)$])
  content((ox + 2.55, S.at(1) - .35), [$arrow(B)$ (displaced)])
  content((ox - .35, -1.6), [(b)])
})
