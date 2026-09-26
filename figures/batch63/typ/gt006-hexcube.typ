#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let px = (x, y) => (x / 148, (367 - y) / 148)
  let t = (thickness: 0.5pt)
  let td = (thickness: 0.5pt, dash: (array: (3.0pt, 2.8pt)))
  let dot(p) = circle(p, radius: 0.061, fill: black, stroke: none)

  // dashed square
  let A = px(117, 33)
  let B = px(399, 33)
  let C = px(399, 313)
  let D = px(117, 313)
  line(A, B, stroke: td)
  line(B, C, stroke: td)
  line(C, D, stroke: td)
  line(D, A, stroke: td)

  // hexagon
  let L = px(186, 172)
  let TL = px(221, 111)
  let TR = px(291, 111)
  let R = px(326, 172)
  let BR = px(291, 233)
  let BL = px(221, 233)
  line(L, TL, stroke: t)
  line(TL, TR, stroke: t)
  line(TR, R, stroke: t)
  line(R, BR, stroke: t)
  line(BR, BL, stroke: t)
  line(BL, L, stroke: t)

  // spokes to the dashed boundary
  line(L, px(117, 172), stroke: t)
  line(TL, px(117, 33), stroke: t)
  line(TR, px(256, 33), stroke: t)
  line(R, px(398, 172), stroke: t)
  line(BR, px(399, 313), stroke: t)
  line(BL, px(257, 314), stroke: t)

  dot(L)
  dot(TL)
  dot(TR)
  dot(R)
  dot(BR)
  dot(BL)
})
