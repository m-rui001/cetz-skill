#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw

#set text(size: 64pt)

#canvas({
  import draw: *
  let t = (thickness: 6.5pt)
  let dsh = (thickness: 6.5pt, dash: (12pt, 10pt))

  let crm = (pts, n: 8) => {
    let ext = (pts.at(0), ..pts, pts.at(-1))
    let out = ()
    for i in range(0, pts.len() - 1) {
      let p0 = ext.at(i)
      let p1 = ext.at(i + 1)
      let p2 = ext.at(i + 2)
      let p3 = ext.at(i + 3)
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
    out.push(pts.at(-1))
    out
  }

  let solid = ((0, 0), (0.71, 0.28), (1.39, 0.61), (2.06, 0.94), (2.74, 1.24),
               (3.41, 1.63), (4.09, 2.01), (4.76, 2.46), (5.44, 2.92), (6.11, 3.35),
               (6.79, 3.73), (7.47, 4.06), (8.14, 4.31), (8.82, 4.54), (9.49, 4.72),
               (10.34, 4.89))
  let up = ((0, 0), (1.39, 1.88), (2.06, 2.87), (3.41, 4.03), (4.09, 4.54),
            (5.44, 5.09), (6.79, 5.30), (8.14, 5.28), (8.82, 5.20), (10.34, 4.89))
  let low = ((0, 0), (1.39, 0.11), (2.74, 0.23), (4.09, 0.49), (4.76, 0.69),
             (6.11, 1.40), (8.14, 3.32), (8.82, 3.88), (10.34, 4.89))

  line(path: true, ..crm(up, n: 12), stroke: dsh)
  line(path: true, ..crm(low, n: 12), stroke: dsh)
  line(path: true, ..crm(solid, n: 6), stroke: t)

  circle((0, 0), radius: 0.30, fill: black, stroke: none)
  circle((10.34, 4.89), radius: 0.30, fill: black, stroke: none)

  content((-0.74, 0.13), anchor: "center", [$P_1$])
  content((11.14, 4.51), anchor: "center", [$P_2$])
})
