#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1.2pt)
  let tag = (p, s) => {
    circle(p, radius: .19, fill: white, stroke: th)
    content(p, s)
  }
  let panel = (cx, inward) => {
    for i in range(8) {
      let a = i * 45deg
      let u = (calc.cos(a), calc.sin(a))
      line((cx, 0), (cx + 2.0 * u.at(0), 2.0 * u.at(1)), stroke: th, mark: (end: ">"))
      if inward {
        line((cx + .85 * u.at(0), .85 * u.at(1)), (cx + .5 * u.at(0), .5 * u.at(1)),
             stroke: th, mark: (end: ">"))
      } else {
        line((cx + .5 * u.at(0), .5 * u.at(1)), (cx + .85 * u.at(0), .85 * u.at(1)),
             stroke: th, mark: (end: ">"))
      }
    }
  }
  panel(0, true)
  tag((0, 0), [4])
  tag((-.8, .95), [5])
  content((0, -2.6), [(a)])
  let ox = 4.8
  panel(ox, false)
  tag((ox, 0), [6])
  tag((ox - .8, .95), [8])
  tag((ox + .75, -.95), [7])
  content((ox, -2.6), [(b)])
})
