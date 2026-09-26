#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Arial", size: 11pt)

// Fig. 16: an open chain of repeaters, with ellipses for the omitted nodes.
#canvas(length: 1pt, {
  import draw: *
  let k = 1.12
  let P = (x, y) => (k * x, k * y)
  let node = (x, label) => content(P(x, .5), label)
  let repeater = (x, index) => node(x, [#text(font: "Calibri", weight: "bold")[r#sub[#text(size: 6.1pt)[#index]]]])
  let s = (thickness: .85pt)
  node(10.7, [Alice])
  node(26.5, [#text(font: "Calibri", weight: "bold")[a]])
  repeater(69.8, [1])
  repeater(96.5, [i])
  repeater(144.7, [i+1])
  repeater(173.1, [N])
  node(216.5, [#text(font: "Calibri", weight: "bold")[b]])
  node(231.0, [Bob])
  line(P(30.7, 0), P(64.4, 0), stroke: s)
  line(P(101.6, 0), P(135.3, 0), stroke: s)
  line(P(178.2, 0), P(211.9, 0), stroke: s)
  for x in (75.1, 79.4, 83.7, 88.0) {
    circle(P(x, 0), radius: k*.95, fill: black, stroke: none)
  }
  for x in (154.0, 158.3, 162.6, 166.9) {
    circle(P(x, 0), radius: k*.95, fill: black, stroke: none)
  }
  content(P(46.0, -5.5), [#text(font: "Cambria Math", size: 8.3pt)[$cal(E)_0$]])
  content(P(121.3, -5.5), [#text(font: "Cambria Math", size: 8.3pt)[$cal(E)_i$]])
  content(P(195.3, -5.5), [#text(font: "Cambria Math", size: 8.3pt)[$cal(E)_N$]])
})
