#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.8pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => ((x - 252.0) / S, (227.0 - y) / S)
  let P = (pts) => pts.map(p => px(p.at(0), p.at(1)))

  let wrap = (pts, i) => {
    let k = pts.len()
    let j = i
    while j < 0 { j = j + k }
    while j >= k { j = j - k }
    pts.at(j)
  }

  let spl = (pts, closed, n: 7) => {
    let k = pts.len()
    let out = ()
    let rng = if closed { range(0, k) } else { range(0, k - 1) }
    for i in rng {
      let p0 = if closed { wrap(pts, i - 1) } else if i == 0 { pts.at(0) } else { pts.at(i - 1) }
      let p1 = pts.at(i)
      let p2 = if closed { wrap(pts, i + 1) } else { pts.at(i + 1) }
      let p3 = if closed { wrap(pts, i + 2) } else if i + 2 >= k { pts.at(k - 1) } else { pts.at(i + 2) }
      for j in range(0, n) {
        let u = j / n
        let w0 = -0.5 * u + u * u - 0.5 * u * u * u
        let w1 = 1.0 - 2.5 * u * u + 1.5 * u * u * u
        let w2 = 0.5 * u + 2.0 * u * u - 1.5 * u * u * u
        let w3 = -0.5 * u * u + 0.5 * u * u * u
        out.push((w0 * p0.at(0) + w1 * p1.at(0) + w2 * p2.at(0) + w3 * p3.at(0),
                  w0 * p0.at(1) + w1 * p1.at(1) + w2 * p2.at(1) + w3 * p3.at(1)))
      }
    }
    if not closed { out.push(pts.at(k - 1)) }
    out
  }

  let t = (thickness: 1.2pt)
  let hd = (symbol: ">", fill: black, length: 4.5pt, width: 2.2pt)

  let edge = ((182,173),(195,164),(276,116),(380,87),(434,90),(468,108),(486,143),(486,178),
              (464,240),(424,296),(380,340),(330,375),(291,402),(215,434),(162,444),(107,440),
              (80,428),(60,403),(59,331),(108,245),(170,184))
  let s = ((179,184),(181,251),(205,297),(242,323),(304,324),(313,328),(326,346),(330,375))

  line(path: true, close: true, ..P(spl(edge, true)), stroke: t)
  line(path: true, ..P(spl(s, false)), stroke: t)
  line(px(15.5, 301), px(372, 27), stroke: t)
  line(px(190, 178), px(206, 58), stroke: t, mark: (end: hd))
  circle(px(191, 175), radius: 7.0 / S, fill: black, stroke: none)

  content(px(388.5, 28), anchor: "center", [$H$])
  content(px(211, 38), anchor: "center", [$n._x$])
  content(px(334, 205), anchor: "center", [$X$])
  content(px(260, 348), anchor: "center", [$S$])
  content(px(37, 434), anchor: "center", [$partial X$])
})
