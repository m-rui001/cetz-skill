#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw

#set text(size: 9.5pt)

#canvas({
  import draw: *
  let t = (thickness: 1.15pt)

  let crm = (pts, n: 10) => {
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

  let l1 = ((-1.453, 1.061), (-1.115, 0.959), (-0.777, 0.689), (-0.439, 0.284),
            (-0.169, 0.047), (0, 0))
  let l2 = ((0, 0), (0.236, 0.149), (0.574, 0.318), (0.912, 0.385), (1.250, 0.405),
            (1.588, 0.385), (1.926, 0.486), (2.196, 0.588))
  let l3 = ((0, 0), (-0.068, -0.257), (-0.101, -0.595), (0, -0.932),
            (0.101, -1.270), (0.149, -1.595))

  line(path: true, ..crm(l1), stroke: t)
  line(path: true, ..crm(l2), stroke: t)
  line(path: true, ..crm(l3), stroke: t)

  for p in ((-1.453, 1.061), (0, 0), (2.196, 0.588), (0.149, -1.595)) {
    circle(p, radius: 0.055, fill: black, stroke: none)
  }

  content((-0.628, 0.486), anchor: "center", [$L_1$])
  content((1.209, 0.176), anchor: "center", [$L_2$])
  content((0.300, -0.900), anchor: "center", [$L_3$])
})
