#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1.1cm, {
  draw.line((0, 0), (3.6 * calc.cos(20deg), 3.6 * calc.sin(20deg)),
    mark: (end: ">"), stroke: 1pt)
  draw.line((0, 0), (2.3 * calc.cos(58deg), 2.3 * calc.sin(58deg)),
    mark: (end: ">"), stroke: 1pt)
  draw.arc((0.7 * calc.cos(20deg), 0.7 * calc.sin(20deg)), radius: 0.7,
    start: 20deg, stop: 58deg, stroke: 0.7pt)
  draw.content((0.85 * calc.cos(58deg) - 0.25, 0.85 * calc.sin(58deg) + 0.2), $arrow(A)$)
  draw.content((3.75 * calc.cos(20deg), 3.75 * calc.sin(20deg) - 0.25), $arrow(B)$)
  draw.content((0.95 * calc.cos(39deg), 0.95 * calc.sin(39deg)), $theta$)
})
