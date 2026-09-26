#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 7pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => ((x - 504.0) / S, (332.0 - y) / S)
  let t = (thickness: 1.15pt)
  let dsh = (thickness: 1.1pt, dash: "dashed")

  let a1 = px(502, 13)
  let a2 = px(590, 64)
  let a3 = px(611, 151)
  let a4 = px(557, 229)
  let a5 = px(452, 229)
  let a6 = px(391, 154)
  let a7 = px(415, 58)
  let c1 = px(498, 107)
  let c2 = px(505, 169)
  let ring = (a1, a2, a3, a4, a5, a6, a7)

  line(path: true, close: true, ..ring, stroke: t)
  for v in ring { line(c1, v, stroke: t) }
  for v in ring { line(c2, v, stroke: dsh) }
  line(c1, c2, stroke: t)
  circle(c1, radius: 8.5 / S, fill: black, stroke: none)
  circle(c2, radius: 7.5 / S, fill: black, stroke: none)

  let btl = px(29, 429)
  let bbl = px(29, 579)
  let bv = px(226, 503)
  let btr = px(416, 427)
  let bbr = px(416, 575)
  let bjl = px(89, 502)
  let bjr = px(349, 503)

  line(btl, bbl, stroke: t)
  line(btl, bv, stroke: t)
  line(bbl, bv, stroke: t)
  line(btr, bbr, stroke: t)
  line(btr, bv, stroke: t)
  line(bbr, bv, stroke: t)
  line(btl, bjl, stroke: dsh)
  line(bbl, bjl, stroke: dsh)
  line(bjl, bjr, stroke: dsh)
  line(btr, bjr, stroke: dsh)
  line(bbr, bjr, stroke: dsh)

  let ca = px(848, 367)
  let cb = px(724, 580)
  let cc = px(982, 580)
  let fab = px(792, 466)
  let fac = px(908, 466)
  let fbc = px(850, 580)

  line(path: true, close: true, ca, cb, cc, stroke: t)
  line(cc, fab, stroke: t)
  line(cb, fac, stroke: t)
  line(ca, fbc, stroke: t)

  content(px(500.5, 283), anchor: "center", [#text(weight: "bold", "(a)")])
  content(px(227, 635), anchor: "center", [#text(weight: "bold", "(b)")])
  content(px(853, 631), anchor: "center", [#text(weight: "bold", "(c)")])
  content(px(226.5, 524), anchor: "center", [$v$])
})
