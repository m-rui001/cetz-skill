#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#canvas(length: 1cm, {
  draw.circle((0, 0), radius: 1.6)
  draw.arc((0, 0), radius: 1.05, start: 0deg, stop: 33deg, stroke: red)
  draw.arc((0, 0), radius: 0.55, start: -33deg, stop: 0deg, stroke: blue)
  draw.line((0, 0), (2, 0))
  draw.line((0, 0), (1.7, 1.1))
})
