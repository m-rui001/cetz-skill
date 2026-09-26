#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let P = (2.9, 4.4)
  let ux = (-.62, -.45)
  let uy = (1.0, .12)
  let uz = (0, 1.0)
  let sx = 2.0
  let sy = 2.2
  let sz = 2.2
  let V = (i, j, k) => (
    P.at(0) + i * sx * ux.at(0) + j * sy * uy.at(0) + k * sz * uz.at(0),
    P.at(1) + i * sx * ux.at(1) + j * sy * uy.at(1) + k * sz * uz.at(1)
  )
  // coordinate axes (drawn first, cube covers part of them)
  let O = (2.0, 3.0)
  line(O, (-.55, 1.2), mark: (end: ">"))
  line(O, (7.3, 3.65), mark: (end: ">"))
  line(O, (2.0, 8.1), mark: (end: ">"))
  content((-.85, .85), [$x$])
  content((7.35, 3.2), [$y$])
  content((2.25, 7.95), [$z$])
  // cube faces
  line(V(0, 0, 1), V(1, 0, 1), V(1, 1, 1), V(0, 1, 1), close: true, fill: luma(180), stroke: (thickness: .6pt))
  line(V(1, 0, 0), V(1, 1, 0), V(1, 1, 1), V(1, 0, 1), close: true, fill: luma(215), stroke: (thickness: .6pt))
  line(V(0, 1, 0), V(1, 1, 0), V(1, 1, 1), V(0, 1, 1), close: true, fill: luma(140), stroke: (thickness: .6pt))
  // unit vectors at the right face centre
  let c0 = ((V(1, 1, 1).at(0) + V(0, 1, 0).at(0) + V(1, 1, 0).at(0) + V(0, 1, 1).at(0)) / 4,
            (V(1, 1, 1).at(1) + V(0, 1, 0).at(1) + V(1, 1, 0).at(1) + V(0, 1, 1).at(1)) / 4)
  let th = (thickness: 1.8pt)
  line(c0, (c0.at(0) + 1.0 * ux.at(0), c0.at(1) + 1.0 * ux.at(1)), stroke: th, mark: (end: ">"))
  line(c0, (c0.at(0) + 1.0 * uy.at(0), c0.at(1) + 1.0 * uy.at(1)), stroke: th, mark: (end: ">"))
  line(c0, (c0.at(0) + 1.0 * uz.at(0), c0.at(1) + 1.0 * uz.at(1)), stroke: th, mark: (end: ">"))
  content((c0.at(0) - .95, c0.at(1) - .35), [$hat(i)$])
  content((c0.at(0) + .85, c0.at(1) - .55), [$hat(j)$])
  content((c0.at(0) + .35, c0.at(1) + .75), [$hat(k)$])
})
