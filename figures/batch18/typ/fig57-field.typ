#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let tv = (thickness: 2.4pt)
  let axes = (ox) => {
    line((ox, 0), (ox, 3.0), stroke: th, mark: (end: ">"))
    line((ox, 0), (ox + 2.9, 0), stroke: th, mark: (end: ">"))
    line((ox, 0), (ox - 1.5, -1.5), stroke: th, mark: (end: ">"))
  }
  axes(0)
  line((0.8, .5), (1.9, 1.7), stroke: tv, mark: (end: ">"))
  content((.2, -2.6), [(a)])
  let ox = 5.6
  axes(ox)
  for tx in (-1.5, -0.5, 0.5, 1.5) {
    for ty in (-0.35, 0.95, 2.2) {
      let vx = .75 * tx
      let l = calc.sqrt(vx * vx + 1.0)
      let tail = (ox + tx, ty - .3 * tx)
      line(tail, (tail.at(0) + 1.1 * vx / l, tail.at(1) + 1.1 / l), stroke: tv, mark: (end: ">"))
    }
  }
  content((ox + .2, -2.6), [(b)])
})
