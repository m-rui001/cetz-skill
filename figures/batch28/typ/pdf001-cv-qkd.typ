#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Arial", size: 11pt)
#let turn-text = rotate

// Fig. 9: a generic CV-QKD experiment. Geometry is rebuilt from basic
// components: modulators, a fibre loop, a splitter, and two photodiodes.
#canvas(length: 1pt, {
  import draw: *
  let k = 1.089
  let P = (x, y) => (k * x, k * y)
  let s = (thickness: 1.05pt)
  let box = (x0, y0, x1, y1, label) => {
    rect(P(x0, y0), P(x1, y1), fill: white, stroke: s)
    content(P((x0 + x1)/2, (y0 + y1)/2), label)
  }

  // The continuous beam path is masked by the component faces.
  line(P(30, 0), P(172.1, 0), stroke: s)
  circle(P(132.9, 10.1), radius: k * 10.1, stroke: s)
  box(0, -7.2, 30, 8.8, [Laser])
  box(38.4, -5.6, 59.2, 6.6, [AM])
  box(65.8, -5.4, 86.6, 6.7, [PM])
  box(95.4, -8.1, 111.0, 25.0, [#turn-text(90deg)[#text(size: 9.2pt)[MUX]]])
  box(156.5, -8.1, 172.1, 25.0, [#turn-text(90deg)[#text(size: 9.2pt)[DEMUX]]])
  line(P(74.7, 18.6), P(95.4, 18.6), stroke: s)
  content(P(83.0, 23.5), [#text(font: "Verdana", size: 9.2pt)[Ref]])

  // Both DEMUX outputs cross at the grey beam splitter. The crossing
  // does not contain a junction dot.
  line(P(172.1, 18.3), P(187.4, 18.1), P(205.3, 1.9), stroke: s)
  line(P(172.1, 0), P(187.4, 0), P(205.3, 16.6), stroke: s)
  line(P(190.1, 9.4), P(205.8, 9.4), stroke: (paint: luma(61%), thickness: 2.4pt))
  line(P(205.3, 16.6), P(209.1, 16.6), stroke: s)
  line(P(205.3, 1.9), P(209.1, 1.9), stroke: s)

  let detector = (cy) => {
    let points = (P(209.1, cy - 5.5),)
    for j in range(19) {
      let a = -90deg + 180deg * j / 18
      points.push(P(209.1 + 5.7*calc.cos(a), cy + 5.5*calc.sin(a)))
    }
    line(..points, path: true, close: true, fill: black, stroke: none)
  }
  detector(16.6)
  detector(1.9)

  // Separate electrical leads enter the balanced receiver, whose output
  // is the difference of the two photodiode currents.
  line(P(214.8, 16.6), P(222.4, 16.6), P(222.4, 13.0), stroke: .35pt)
  line(P(214.8, 1.9), P(222.4, 1.9), P(222.4, 5.1), stroke: .35pt)
  rect(P(217.0, 5.1), P(227.2, 13.0), fill: white, stroke: .7pt)
  line(P(219.4, 9.2), P(224.8, 9.2), stroke: 1.4pt)
})
