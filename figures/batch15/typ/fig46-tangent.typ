#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let tv = (thickness: 1.6pt)
  let dot = (p) => circle(p, radius: .07, fill: black, stroke: none)
  let px = (t) => .7 + .72 * t
  let py = (t) => 1.0 + 1.5 * t - .13 * t * t
  let dx = 0.72
  let dy = (t) => 1.5 - .26 * t
  let un = (t) => {
    let l = calc.sqrt(dx * dx + dy(t) * dy(t))
    (dx / l, dy(t) / l)
  }
  // axes
  line((-.6, 0), (5.2, 0), stroke: th, mark: (end: ">"))
  line((0, -.8), (0, 5.7), stroke: th, mark: (end: ">"))
  content((5.3, -.42), anchor: "west", [$x$])
  content((.25, 5.4), anchor: "west", [$y$])
  // the trajectory, sampled as a polyline
  line((px(0), py(0)), (px(.25), py(.25)), (px(.5), py(.5)), (px(.75), py(.75)),
       (px(1), py(1)), (px(1.25), py(1.25)), (px(1.5), py(1.5)), (px(1.75), py(1.75)),
       (px(2), py(2)), (px(2.25), py(2.25)), (px(2.5), py(2.5)), (px(2.75), py(2.75)),
       (px(3), py(3)), (px(3.25), py(3.25)), (px(3.5), py(3.5)), (px(3.75), py(3.75)),
       (px(4), py(4)), (px(4.25), py(4.25)), (px(4.5), py(4.5)), (px(4.75), py(4.75)),
       (px(5), py(5)), stroke: tv)
  // sample points
  for t in (0, 1, 2, 3, 4, 5) { dot((px(t), py(t))) }
  // tangent arrows
  for t in (2, 3, 4) {
    let u = un(t)
    line((px(t) - .34 * u.at(0), py(t) - .34 * u.at(1)),
         (px(t) + .42 * u.at(0), py(t) + .42 * u.at(1)), stroke: tv, mark: (end: ">"))
  }
  // labels
  content((.85, .55), anchor: "west", [$t = 1$])
  content((1.62, 2.05), anchor: "west", [$t = 2$])
  content((2.3, 2.75), anchor: "west", [$t = 3$])
  content((3.05, 3.6), anchor: "west", [$t = 4$])
  content((3.85, 4.55), anchor: "west", [$t = N - 1$])
  content((3.6, 5.5), anchor: "west", [$t = N$])
  content((1.9, 5.6), anchor: "west", [Tangent \ vectors])
  // two pointer curves onto the tangents
  bezier((2.05, 5.05), (2.5, 3.95), (1.55, 4.6), (2.5, 4.45))
  line((2.4, 4.1), (2.5, 3.95), stroke: th, mark: (end: ">"))
  bezier((3.55, 5.15), (3.35, 4.5), (3.75, 4.75), (3.3, 4.7))
  line((3.42, 4.62), (3.35, 4.5), stroke: th, mark: (end: ">"))
})
