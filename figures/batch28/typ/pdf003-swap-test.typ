#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Times New Roman", size: 11pt)

// Fig. 19: ancilla Hadamards, a controlled SWAP, and ancilla measurement.
#canvas(length: 1pt, {
  import draw: *
  let P = (x, y) => (x, y)
  let wire = (thickness: .6pt)
  line(P(24, 0), P(168, 0), stroke: wire)
  line(P(24, -25), P(168, -25), stroke: wire)
  line(P(24, -41.5), P(168, -41.5), stroke: wire)
  content(P(10, 0), [#text(size: 12pt)[$lr(|0 ⟩)$]])
  content(P(10, -25), [#text(size: 12pt)[$lr(|psi ⟩)$]])
  content(P(10, -41.5), [#text(size: 12pt)[$lr(|phi.alt ⟩)$]])

  let hadamard = (x) => {
    rect(P(x - 9, -7.6), P(x + 9, 7.6), fill: white, stroke: wire)
    content(P(x, .2), [#text(size: 13pt)[$H$]])
  }
  hadamard(57)
  hadamard(125)

  line(P(91, 0), P(91, -41.5), stroke: wire)
  circle(P(91, 0), radius: 2.2, fill: black, stroke: none)
  for y in (-25, -41.5) {
    line(P(88.2, y - 2.8), P(93.8, y + 2.8), stroke: wire)
    line(P(88.2, y + 2.8), P(93.8, y - 2.8), stroke: wire)
  }

  rect(P(157.5, -8.4), P(178.5, 8.4), fill: white, stroke: wire)
  bezier(P(159, -3.7), P(177, -3.7), P(163.8, 1.8), P(172.2, 1.8), stroke: wire)
  line(P(167.8, -4.8), P(174, 6.2), stroke: wire)
})
