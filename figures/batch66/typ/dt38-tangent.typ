#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.5pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => (x / S, (557.0 - y) / S)
  let t = (thickness: 0.8pt)

  line(px(13,279.5), px(560,277.0), stroke: t)
  line(px(285.5,13), px(287.5,547), stroke: t)

  content(px(337,25), anchor: "center", [#text(size: 6.5pt)[$f(bold(R)^1)$]])
  content(px(583,277.5), anchor: "center", [#text(size: 6.5pt)[$Z$]])
})
