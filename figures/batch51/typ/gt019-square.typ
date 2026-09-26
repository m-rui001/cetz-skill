#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let px = (x, y) => (x / 148, (194 - y) / 148)
  let tk = (thickness: 1.72pt)
  let tn = (thickness: 0.55pt)
  let td = (thickness: 0.55pt, dash: (array: (3.6pt, 2.9pt)))
  let tdb = (thickness: 0.86pt, dash: (array: (3.6pt, 2.9pt)))
  let dotL(p) = circle(p, radius: 0.054, fill: black, stroke: none)
  let dotS(p) = circle(p, radius: 0.041, fill: black, stroke: none)

  let TL = px(109, 20.5)
  let TR = px(366.5, 20.5)
  let BL = px(110, 192)
  let BR = px(365.5, 192)
  let IL = px(194, 106)
  let IR = px(280, 106)

  line(TL, TR, stroke: tk)
  line(TL, BL, stroke: tk)
  line(TR, BR, stroke: tk)
  line(BL, BR, stroke: tdb)
  line(TL, IL, stroke: tn)
  line(IL, IR, stroke: tn)
  line(IR, TR, stroke: tn)
  line(IL, BL, stroke: td)
  line(IR, BR, stroke: td)

  dotL(TL)
  dotL(TR)
  dotL(BL)
  dotL(BR)
  dotS(IL)
  dotS(IR)
})
