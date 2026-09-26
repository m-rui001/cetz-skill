#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Arial", size: 11pt)

// Fig.2: EM is the solid path; the two CM measurements use dotted branches.
#canvas(length: 1pt, {
  import draw: *
  let P = (x, y) => (.55*x, .55*y)
  let s = (thickness: 1pt)
  let dotted = (thickness: 1pt, dash: (array: (.8pt, 1pt)))
  let arrow = (points, style) => {
    line(..points.map(p => P(..p)), path: true, stroke: style)
    let tip = points.at(points.len() - 1)
    let tail = points.at(points.len() - 2)
    let dx = tip.at(0) - tail.at(0)
    let dy = tip.at(1) - tail.at(1)
    let n = calc.sqrt(dx*dx + dy*dy)
    let ux = dx/n
    let uy = dy/n
    let bx = tip.at(0) - 10*ux
    let by = tip.at(1) - 10*uy
    line(P(..tip), P(bx - 3.5*uy, by + 3.5*ux), P(bx + 3.5*uy, by - 3.5*ux), close: true, fill: black, stroke: none)
  }
  let dot = (x, y) => circle(P(x, y), radius: 2.3, fill: black, stroke: none)
  let cup = (cx, cy, label) => {
    let points = ()
    for j in range(25) {
      let a = 180deg + 180deg*j/24
      points.push(P(cx + 23*calc.cos(a), cy + 23*calc.sin(a)))
    }
    line(..points, path: true, close: true, stroke: .6pt)
    content(P(cx, cy - 10.5), [#text(size: 8.2pt)[#label]])
  }

  line(P(40, 53), P(40, -179), stroke: (thickness: 1pt, dash: (array: (5.2pt, 4.2pt))))
  line(P(277, 50), P(277, -179), stroke: (thickness: 1pt, dash: (array: (5.2pt, 4.2pt))))
  content(P(-11, 33), [#text(weight: "bold")[ALICE]])
  content(P(391, 37), [#text(weight: "bold")[BOB]])

  circle(P(327, -2), radius: .55*40.5, stroke: .6pt)
  content(P(327, -2), [#text(size: 12pt)[$lr(|Psi_(+) ⟩)$]])
  line(P(0, 0), P(287, 0), stroke: s)
  dot(0, 0)
  dot(287, 0)
  dot(327, -42.5)
  dot(327, -55)

  arrow(((0, 0), (0, -50)), s)
  rect(P(-22, -102), P(25, -50), fill: white, stroke: .6pt)
  content(P(1.5, -76), [EM])
  dot(1, -104)
  arrow(((1, -104), (1, -147), (363, -147)), s)
  arrow(((327, -42.5), (328, -113), (363, -113)), s)
  arrow(((0, 0), (-89, 0), (-89, -50)), dotted)
  arrow(((327, -55), (397, -55), (397, -73)), dotted)

  cup(-89, -50, [$A_"CM"$])
  cup(397, -73, [$B_"CM"$])
  let points = ()
  for j in range(25) {
    let a = -90deg + 180deg*j/24
    points.push(P(363 + 33.5*calc.cos(a), -129 + 33.5*calc.sin(a)))
  }
  line(..points, path: true, close: true, stroke: .6pt)
  content(P(378, -129), [#text(size: 8.2pt)[$B_"EM"$]])
})
