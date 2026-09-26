#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw
#canvas({
  import draw: *
  let S = 148.0
  let Y0 = 6000.0
  let px = (x, y) => (x / S, (Y0 - y) / S)
  content(px(0, 200), anchor: "west", fill: none, [#text(size: 10pt)[$bold(x + y = y + x)$]])
  content(px(0, 650), anchor: "west", fill: none, [#text(size: 10pt)[vector addition]])
  content(px(0, 1100), anchor: "west", fill: none, [#text(size: 10pt)[negative vector]])
  content(px(0, 1550), anchor: "west", fill: none, [#text(size: 10pt)[zero vector]])
  content(px(0, 2000), anchor: "west", fill: none, [#text(size: 10pt)[multiplication by a real scalar]])
  content(px(0, 2450), anchor: "west", fill: none, [#text(size: 10pt)[$bold(x)$]])
  content(px(0, 2900), anchor: "west", fill: none, [#text(size: 10pt)[$bold(y)$]])
  content(px(0, 3350), anchor: "west", fill: none, [#text(size: 10pt)[$bold(-x)$]])
  content(px(0, 3800), anchor: "west", fill: none, [#text(size: 10pt)[$bold(2x)$]])
  content(px(0, 4250), anchor: "west", fill: none, [#text(size: 10pt)[$bold(2.5x)$]])
})
