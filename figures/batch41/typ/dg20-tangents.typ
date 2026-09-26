#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw

#set text(size: 66pt)

#canvas({
  import draw: *
  let t = (thickness: 6.5pt)
  let hd = (symbol: ">", fill: black, length: 38pt, width: 24pt)

  // Catmull-Rom smoothing through measured points
  let crm(pts, n: 10) = {
    let ext = (pts.at(0), ..pts, pts.at(-1))
    let out = ()
    for i in range(0, pts.len() - 1) {
      let p0 = ext.at(i)
      let p1 = ext.at(i + 1)
      let p2 = ext.at(i + 2)
      let p3 = ext.at(i + 3)
      for j in range(0, n) {
        let u = j / n
        let a = -0.5 * u + u * u - 0.5 * u * u * u
        let b = 1.0 - 2.5 * u * u + 1.5 * u * u * u
        let c = 0.5 * u + 2.0 * u * u - 1.5 * u * u * u
        let d = -0.5 * u * u + 0.5 * u * u * u
        out.push((a * p0.at(0) + b * p1.at(0) + c * p2.at(0) + d * p3.at(0),
                  a * p0.at(1) + b * p1.at(1) + c * p2.at(1) + d * p3.at(1)))
      }
    }
    out.push(pts.at(-1))
    out
  }

  let c1 = ((-4.12, -1.24), (-3.11, -0.75), (-1.76, -0.25), (0, 0),
            (1.62, -0.14), (3.31, -0.82), (5.00, -1.22), (6.35, -1.34))
  let c2 = ((4.70, 7.77), (4.20, 5.74), (3.31, 4.14), (2.98, 3.72), (1.62, 2.34),
            (0, 0), (-0.90, -1.69), (-1.76, -3.88), (-2.45, -5.74))

  line(path: true, ..crm(c1), stroke: t)
  line(path: true, ..crm(c2), stroke: t)

  // tangent arrows
  line((0, 0), (4.46, 0.07), stroke: t, mark: (end: hd))
  line((0, 0), (2.23, 4.39), stroke: t, mark: (end: hd))

  // angle arc between tangents
  let arc = ()
  for i in range(0, 25) {
    let a = (2.0 + i * 61.0 / 24) * 1deg
    arc.push((1.55 * calc.cos(a), 1.55 * calc.sin(a)))
  }
  line(path: true, ..arc, stroke: t)

  content((-0.53, 1.30), anchor: "center", [$P$])
  content((5.74, 0.14), anchor: "center", [$t_1$])
  content((2.37, 5.61), anchor: "center", [$t_2$])
  content((2.16, 1.35), anchor: "center", [$theta$])
  content((-5.34, -0.27), anchor: "center", [$C_1$])
  content((-0.47, -4.73), anchor: "center", [$C_2$])
})
