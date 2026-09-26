#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw
#canvas({
  import draw: *
  ellipse((0,0), rx: 2, ry: 1, angle: 20deg)
  ellipse((3,0), radius: (2,1))
})
