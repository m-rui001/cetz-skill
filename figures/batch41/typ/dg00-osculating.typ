#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw

#set text(size: 72pt)

#canvas({
  import draw: *
  let t = (thickness: 6.5pt)
  let a = 3.514
  let b = 7.196

  let ell = (cx, cy, rx, ry) => { let pts = ()
    for i in range(0, 73) { let ang = i / 72 * 360deg
      pts.push((cx + rx * calc.cos(ang), cy + ry * calc.sin(ang))) }
    pts }

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

  // osculating circle C_o
  line(path: true, ..ell(0, 0, a, b), stroke: t)
  // radius R_kappa
  line((0, 0), (-3.365, 2.061), stroke: t)
  circle((0, 0), radius: 0.30, fill: black, stroke: none)

  // curve C
  let c = ((-6.554, 3.986), (-5.203, 4.730), (-3.851, 5.608), (-2.500, 6.419),
           (-1.149, 7.061), (-0.473, 7.162), (0.757, 7.027), (1.892, 5.743),
           (2.905, 4.257), (3.919, 2.635), (4.932, 1.689), (5.541, 1.554),
           (6.689, 2.703))
  line(path: true, ..crm(c), stroke: t)

  // P and the normal N
  circle((0.757, 7.027), radius: 0.28, fill: black, stroke: none)
  line((0.757, 7.027), (0.135, 3.108), stroke: t,
    mark: (end: (symbol: ">", fill: black, length: 34pt, width: 15pt)))

  content((1.253, 8.095), anchor: "center", [$P$])
  content((1.351, 3.716), anchor: "center", [$"N"$])
  content((-1.520, -0.660), anchor: "center", [$R_kappa$])
  content((1.180, -0.800), anchor: "center", [$C_c$])
  content((-5.660, 3.520), anchor: "center", [$C$])
  content((4.560, -3.860), anchor: "center", [$C_o$])
})
