#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.5pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => (x / S, (319.0 - y) / S)
  let t = (thickness: 1.05pt)
  let hd = (symbol: ">", fill: black, length: 3.9pt, width: 2.9pt)

  circle(px(330.7, 189.0), radius: 126.0 / S, stroke: t)
  line(px(12, 218), px(686, 214.5), stroke: t)
  line(px(348, 184), px(348, 91), stroke: (thickness: 1.15pt), mark: (end: hd))
  circle(px(348, 216), radius: 7.5 / S, fill: black, stroke: none)
  circle(px(348, 65), radius: 8.0 / S, fill: black, stroke: none)
  content(px(339, 30), anchor: "center", [#text(size: 6.8pt)[$phi_1(x)$]])
  content(px(255, 192), anchor: "center", [#text(size: 6.5pt)[$W$]])
  content(px(348, 236), anchor: "center", [#text(size: 6.5pt)[$x$]])
})
