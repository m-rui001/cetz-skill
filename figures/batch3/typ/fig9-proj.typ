#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1.1cm, {
  let ba = 18deg
  let aa = 62deg
  let bh = (calc.cos(ba), calc.sin(ba))
  let Atip = (1.35, 2.5)
  let foot = (1.94, 0.63)
  draw.line((0, 0), (4.4 * bh.at(0), 4.4 * bh.at(1)), mark: (end: ">"), stroke: 1pt)
  draw.line((0, 0), Atip, mark: (end: ">"), stroke: 1pt)
  draw.arc((0.75 * calc.cos(ba), 0.75 * calc.sin(ba)), radius: 0.75,
    start: ba, stop: aa, stroke: 0.7pt)
  draw.line(Atip, foot, stroke: (dash: "dashed", thickness: 0.7pt))
  let w = ((Atip.at(0) - foot.at(0)), (Atip.at(1) - foot.at(1)))
  let wl = calc.sqrt(w.at(0) * w.at(0) + w.at(1) * w.at(1))
  let wh = (w.at(0) / wl, w.at(1) / wl)
  draw.line((foot.at(0) + 0.22 * bh.at(0), foot.at(1) + 0.22 * bh.at(1)),
    (foot.at(0) + 0.22 * bh.at(0) + 0.22 * wh.at(0), foot.at(1) + 0.22 * bh.at(1) + 0.22 * wh.at(1)),
    stroke: 0.6pt)
  draw.line((foot.at(0) + 0.22 * bh.at(0) + 0.22 * wh.at(0), foot.at(1) + 0.22 * bh.at(1) + 0.22 * wh.at(1)),
    (foot.at(0) + 0.22 * wh.at(0), foot.at(1) + 0.22 * wh.at(1)), stroke: 0.6pt)
  draw.bezier((0.08, -0.14), (1.95, -0.1), (0.6, -0.44), (1.4, -0.42), stroke: 0.6pt)
  draw.content((1.0, 2.6), $arrow(A)$)
  draw.content((4.5, 1.3), $arrow(B)$)
  draw.content((0.82, 0.62), $theta$)
})
