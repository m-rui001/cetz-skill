#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let tv = (thickness: 1.6pt)
  let ep = (rx, ry, d) => (rx * calc.cos(d), ry * calc.sin(d))
  let tri = (P, d, s) => {
    let perp = (0.0 - d.at(1), d.at(0))
    line((P.at(0) + s * d.at(0), P.at(1) + s * d.at(1)),
         (P.at(0) - s * d.at(0) + s * .8 * perp.at(0),
          P.at(1) - s * d.at(1) + s * .8 * perp.at(1)),
         (P.at(0) - s * d.at(0) - s * .8 * perp.at(0),
          P.at(1) - s * d.at(1) - s * .8 * perp.at(1)),
         close: true, fill: black, stroke: none)
  }
  line((0, -2.6), (0, 2.15), stroke: tv, mark: (end: ">"))
  for r in ((.37, .09), (.70, .17), (1.07, .26), (1.50, .36), (2.00, .48)) {
    let rx = r.at(0)
    let ry = r.at(1)
    for i in range(36) {
      line(ep(rx, ry, i * 10deg), ep(rx, ry, (i + 1) * 10deg), stroke: th)
    }
    tri((rx, 0), (.58, .81), .072)
    tri((0.0 - rx, 0), (0.0 - .58, .81), .072)
  }
  content((-3.15, 2.0), anchor: "west", [Current-carrying])
  content((-2.75, 1.5), anchor: "west", [straight wire])
  content((.25, 1.8), anchor: "west", [$arrow(I)$])
  content((-1.85, -.9), anchor: "east", [$arrow(B)$])
  content((1.85, -.9), anchor: "west", [$arrow(B)$])
  content((-1.9, -1.6), anchor: "east", [(out of page])
  content((-1.9, -2.05), anchor: "east", [(on this side)])
  content((1.9, -1.6), anchor: "west", [(into page)])
  content((1.9, -2.05), anchor: "west", [(on this side)])
})
