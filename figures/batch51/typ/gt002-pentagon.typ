#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 9pt, weight: "bold", font: "Times New Roman")

#canvas({
  import draw: *
  let px = (x, y) => (x / 148, (296 - y) / 148)
  let t = (thickness: 0.57pt)
  let td = (thickness: 0.57pt, dash: (array: (3.4pt, 2.2pt)))
  let dot(p) = circle(p, radius: 0.064, fill: black, stroke: none)

  let T = px(150, 10)
  let UL = px(22, 105)
  let UR = px(280, 105)
  let LL = px(70, 256)
  let LR = px(231, 256)

  line(UL, T, stroke: td)
  line(T, UR, stroke: td)
  line(UL, LL, stroke: t)
  line(LL, LR, stroke: t)
  line(LR, UR, stroke: t)

  dot(T)
  dot(UL)
  dot(UR)
  dot(LL)
  dot(LR)

  content(px(213, 273), text(style: "italic")[x])
  content(px(295, 122), text(style: "italic")[y])
})
