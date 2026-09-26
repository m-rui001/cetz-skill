#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Calibri", size: 11pt)

// Fig.12: successive channel transmissions between adaptive LOCCs.
#canvas(length: 1pt, {
  import draw: *
  let k = 1.4
  let P = (x, y) => (k*(x - 58), k*(109 - y))
  let light = rgb("dce6f2")
  let redline = rgb("c00000")
  let rr = (x0, y0, x1, y1, r) => {
    let points = ()
    for c in ((x1 - r, y0 + r, -90deg), (x1 - r, y1 - r, 0deg), (x0 + r, y1 - r, 90deg), (x0 + r, y0 + r, 180deg)) {
      for j in range(7) {
        let a = c.at(2) + 90deg*j/6
        points.push(P(c.at(0) + r*calc.cos(a), c.at(1) + r*calc.sin(a)))
      }
    }
    line(..points, path: true, close: true, fill: light, stroke: none)
  }
  for y in (61.5, 98.2) {
    line(P(87, y), P(237, y), stroke: 4.9pt)
    line(P(245, y), P(274.5, y), stroke: 4.9pt)
  }
  for (x, label) in ((96.4, [$Lambda_0$]), (157.0, [$Lambda_1$]), (218.0, [$Lambda_2$]), (255.2, [$Lambda_n$])) {
    rr(x, 57.5, x + 10.8, 103.4, 1.7)
    content(P(x + 5.4, 81), [#text(font: "Cambria Math", size: 10pt)[#label]])
  }
  content(P(69.4, 61.5), [#text(weight: "bold")[Alice]])
  content(P(69.4, 98.2), [#text(weight: "bold")[Bob]])
  for (x, y, label) in ((82.7,61.5,[a]),(82.7,98.2,[b]),(277.4,61.5,[a]),(277.4,98.2,[b])) {
    content(P(x,y), [#text(size: 10pt, weight: "bold")[#label]])
  }

  let transmission = (x, first) => {
    circle(P(x, 67), radius: 1.5, fill: redline, stroke: none)
    line(P(x, 67), P(x+25.5, 67), P(x+25.5, 75), path: true, stroke: (paint: redline, thickness: 1pt))
    line(P(x+25.5, 87), P(x+25.5, 93), P(x+50.4, 93), path: true, stroke: (paint: redline, thickness: 1pt))
    line(P(x+48.0, 91.6), P(x+50.4, 93), P(x+48.0, 94.4), stroke: (paint: redline, thickness: 1pt))
    content(P(x+25.5,81), [#text(font: "Cambria Math", size: 10pt)[$bold(cal(E))$]])
    content(P(x+6,70.8), [#text(size: 10pt)[a#sub[#(if first {[1]} else {[2]})]]])
    content(P(x+43.5,88.8), [#text(size: 10pt)[b#sub[#(if first {[1]} else {[2]})]]])
  }
  transmission(107.2, true)
  transmission(168.2, false)
  for (x,label) in ((114.6,[$rho_(bold(upright(a b)))^0$]),(175.6,[$rho_(bold(upright(a b)))^1$]),(236.6,[$rho_(bold(upright(a b)))^2$])) {
    content(P(x,52.6), [#text(font: "Cambria Math", size: 10pt)[#label]])
  }
  for x in (239.6, 243.3, 247.0) {
    circle(P(x,81.5), radius: 1.4, fill: black, stroke: none)
  }

  // Two smooth lobes meet at the brace's middle cusp.
  bezier(P(282.5,59), P(288.6,79.5), P(287.0,59), P(284.8,79.5), stroke: .7pt)
  bezier(P(288.6,79.5), P(282.5,100.4), P(284.8,79.5), P(287.0,100.4), stroke: .7pt)
  content(P(299.6,80), [#text(font: "Cambria Math", size: 10pt)[$rho_(bold(upright(a b)))^n$]])
})
