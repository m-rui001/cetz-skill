#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Arial", size: 11pt)

// Fig.13: direct channel (red) compared with an LOCC resource simulation.
#canvas(length: 1pt, {
  import draw: *
  let k = 1.6
  let P = (x, y) => (k*(x - 112), k*(152 - y))
  let channel = rgb("ff0000")
  let resource = rgb("00b050")
  let panel = rgb("93b1d5")
  let local = rgb("dbe5f1")
  let rs = (paint: channel, thickness: 1.1pt)
  let gs = (paint: resource, thickness: 1.6pt)

  rect(P(157.8, 66.4), P(182.9, 138.8), fill: panel, stroke: none)
  line(P(124.4, 72.3), P(170.6, 72.3), stroke: rs)
  circle(P(124.4, 72.3), radius: 2.3, fill: channel, stroke: none)
  line(P(169.7, 131.8), P(217.5, 131.8), stroke: rs)
  bezier(P(144.2, 68), P(207.4, 129.9), P(185, 39), P(179, 58), stroke: (paint: channel, thickness: .7pt))
  // Open V heads preserve the original line drawing; the curve itself has no fill.
  line(P(213.4, 130), P(217.5, 131.8), P(213.4, 133.6), stroke: rs)
  line(P(203.4, 126.0), P(207.4, 129.9), P(208.6, 124.4), stroke: (paint: channel, thickness: .7pt))
  bezier(P(163, 75.2), P(140, 91), P(149, 76.3), P(140, 83), stroke: gs)
  line(P(140, 91), P(140, 117), stroke: gs)
  bezier(P(140, 117), P(162, 131.8), P(140, 125), P(151, 130), stroke: gs)
  line(P(170.4, 126.5), P(170.4, 77.7), stroke: (thickness: .45pt, dash: (array: (2.5pt, 2pt))))
  line(P(170.4, 77.7), P(169.9, 79), P(170.9, 79), close: true, fill: black, stroke: none)

  let lo = (cx, cy) => {
    let points = ()
    for corner in ((6, 3.4, 0deg), (-6, 3.4, 90deg), (-6, -3.4, 180deg), (6, -3.4, 270deg)) {
      for j in range(7) {
        let a = corner.at(2) + 90deg*j/6
        points.push(P(cx + corner.at(0) + 1.8*calc.cos(a), cy - corner.at(1) - 1.8*calc.sin(a)))
      }
    }
    line(..points, path: true, close: true, fill: local, stroke: none)
    content(P(cx, cy), [#text(size: 6.7pt, weight: "bold")[LO]])
  }
  lo(170.6, 72.3)
  lo(169.7, 131.8)
  content(P(173.8, 103), [#text(size: 8pt)[CC]], anchor: "west")
  content(P(116.0, 72.3), [#text(size: 17pt)[$bold(rho)$]])
  content(P(132.0, 105.5), [#text(size: 20pt)[$bold(sigma)$]])
  content(P(171.1, 147), [#text(font: "Cambria Math", size: 20pt)[𝓣]])
  content(P(203, 92), [#text(font: "Cambria Math", fill: channel, size: 16pt)[$bold(cal(E))$]])
  content(P(220, 132), [#text(font: "Cambria Math", size: 14pt)[$bold(cal(E))(bold(rho))$]], anchor: "west")
  content(P(130.4, 77), [#text(size: 8.5pt)[a]])
  content(P(151.0, 85), [#text(size: 8.5pt)[a′]])
  content(P(152.0, 134.5), [#text(size: 8.5pt)[b′]])
  content(P(207.7, 141), [#text(size: 8.5pt)[b]])
})
