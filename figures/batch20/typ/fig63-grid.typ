#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let ta = (thickness: 1.5pt)
  let hl = .22
  let hw = .13
  let arrow = (x0, x1, y) => {
    line((x0, y), (x1 - hl, y), stroke: ta)
    line((x1 - hl, y - hw), (x1, y), (x1 - hl, y + hw),
         close: true, fill: black, stroke: none)
  }
  for row in range(5) {
    let y = 3.5 - row * .7
    for i in range(7) {
      let x0 = .15 + i * 1.25
      arrow(x0, x0 + (if i == 2 and row == 0 { 1.16 } else if i == 3 and row == 3 {
                          1.12 } else { 1.0 }), y)
    }
  }
  let tag = (p, s) => {
    circle(p, radius: .28, fill: white, stroke: th)
    content(p, [#(s)])
  }
  tag((.71, 3.15), [1])
  tag((7.09, 2.45), [3])
  tag((2.87, 1.05), [2])
  line((.15, -.35), (9.35, -.35), stroke: th, mark: (end: ">"))
  for t in ((.15, [0]), (3.79, [$1 / 2$]), (7.42, [1])) {
    let x = t.at(0)
    line((x, -.72), (x, .02), stroke: th)
    content((x, -1.05), t.at(1))
  }
  content((9.45, -1.05), [x])
})
