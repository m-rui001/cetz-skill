#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 8pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => (x / S, (317.0 - y) / S)
  let t = (thickness: 0.6pt)
  let hH = (symbol: ">", fill: black, length: 1.9pt, width: 2.7pt)
  let hV = (symbol: ">", fill: black, length: 2.5pt, width: 1.9pt)

  line(px(83.7,76), px(371.9,76), stroke: t, mark: (end: hH))
  line(px(83.7,259.4), px(371.9,259.4), stroke: t, mark: (end: hH))
  line(px(59.0,226.2), px(59.0,102.9), stroke: t, mark: (end: hV))
  line(px(397.6,225.2), px(397.6,101.9), stroke: t, mark: (end: hV))

  content(px(62.75,69.5), anchor: "center", [$X$])
  content(px(401.4,70.8), anchor: "center", [$Y$])
  content(px(58,253.8), anchor: "center", [$U$])
  content(px(400.4,254.8), anchor: "center", [$V$])
  content(px(228,33.8), anchor: "center", [#text(size: 7.5pt)[$f$]])
  content(px(231,296.5), anchor: "center", [$g$])
  content(px(28.75,162.6), anchor: "center", [$ϕ$])
  content(px(432,165.2), anchor: "center", [#text(size: 7.5pt)[$psi$]])
  content(px(548,143.75), anchor: "west", [$ϕ(0) = x$])
  content(px(548,191.75), anchor: "west", [$psi(0) = y$])
})
