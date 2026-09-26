#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1.3cm, {
  let ua = 20deg
  let va = -18deg
  let uh = (calc.cos(ua), calc.sin(ua))
  let vh = (calc.cos(va), calc.sin(va))
  let n = (-calc.sin(ua), calc.cos(ua))
  let vtip = (3.6 * vh.at(0), 3.6 * vh.at(1))
  let plen = 2.7
  let P = (plen * uh.at(0), plen * uh.at(1))
  let wh = ((vtip.at(0) - P.at(0)), (vtip.at(1) - P.at(1)))
  let wlen = calc.sqrt(wh.at(0) * wh.at(0) + wh.at(1) * wh.at(1))
  let w = (wh.at(0) / wlen, wh.at(1) / wlen)

  draw.line((0, 0), (4.6 * uh.at(0), 4.6 * uh.at(1)), mark: (end: ">"), stroke: 1.1pt)
  draw.line((0, 0), vtip, mark: (end: ">"), stroke: 1.1pt)
  draw.line(P, vtip, stroke: 0.7pt)
  draw.line((P.at(0) + 0.3 * uh.at(0), P.at(1) + 0.3 * uh.at(1)),
    (P.at(0) + 0.3 * uh.at(0) + 0.3 * w.at(0), P.at(1) + 0.3 * uh.at(1) + 0.3 * w.at(1)),
    stroke: 0.7pt)
  draw.line((P.at(0) + 0.3 * uh.at(0) + 0.3 * w.at(0), P.at(1) + 0.3 * uh.at(1) + 0.3 * w.at(1)),
    (P.at(0) + 0.3 * w.at(0), P.at(1) + 0.3 * w.at(1)), stroke: 0.7pt)
  draw.arc((1.1 * calc.cos(va), 1.1 * calc.sin(va)), radius: 1.1,
    start: va, stop: ua, stroke: 0.7pt)
  draw.line((-0.5 * uh.at(0) + 0.62 * n.at(0), -0.5 * uh.at(1) + 0.62 * n.at(1)),
    (3.1 * uh.at(0) + 0.62 * n.at(0), 3.1 * uh.at(1) + 0.62 * n.at(1)),
    mark: (start: "<", end: ">"), stroke: 0.7pt)

  draw.content((4.35 * uh.at(0), 4.35 * uh.at(1) - 0.35), $bold(u)$)
  draw.content((1.9 * vh.at(0), 1.9 * vh.at(1) - 0.35), $bold(v)$)
  draw.content((1.45 * calc.cos(1deg), 1.45 * calc.sin(1deg)), $theta$)
  draw.content((0.15, 1.35), $abs(bold(v)) cos theta$)
})
