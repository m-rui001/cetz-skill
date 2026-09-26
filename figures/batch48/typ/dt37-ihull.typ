#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 7pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => ((x - 278.0) / S, (276.0 - y) / S)
  let P = (pts) => pts.map(p => px(p.at(0), p.at(1)))

  let wrap = (pts, i) => {
    let k = pts.len()
    let j = i
    while j < 0 { j = j + k }
    while j >= k { j = j - k }
    pts.at(j)
  }

  let crm = (pts, n: 6) => {
    let ext = (pts.at(0), ..pts, pts.at(-1))
    let out = ()
    for i in range(0, pts.len() - 1) {
      let p0 = ext.at(i); let p1 = ext.at(i + 1)
      let p2 = ext.at(i + 2); let p3 = ext.at(i + 3)
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
    out.push(pts.at(-1)); out
  }

  let crmc = (pts, n: 6) => {
    let k = pts.len()
    let out = ()
    for i in range(0, k) {
      let p0 = wrap(pts, i - 1); let p1 = wrap(pts, i)
      let p2 = wrap(pts, i + 1); let p3 = wrap(pts, i + 2)
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
    out
  }

  let t = (thickness: 1.15pt)

  // ---- boundary of X (traced centerline) ----
  let outline = ((505,6),(523,8),(533,19),(537,84),(519,183),(495,246),(495,327),(519,400),
                 (523,437),(515,479),(493,513),(463,529),(430,527),(317,475),(232,457),
                 (155,463),(80,491),(51,489),(33,478),(13,427),(13,346),(25,303),(55,247),
                 (63,182),(61,113),(79,75),(118,47),(166,33),(228,33),(333,49),(385,47),(452,31))
  line(path: true, close: true, ..crm(P(outline)), stroke: t)

  // ---- f^{-1}(y) curve ----
  let curve = ((57,248),(68,248),(86,249),(104,249),(122,246),(140,241),(158,233),(176,227),
               (194,223),(212,219),(230,216),(254,215),(278,215),(296,216),(312,218),(328,222),
               (344,226),(362,234),(380,242),(398,246),(416,251),(434,253),(458,253),(482,252),
               (497,247))
  line(path: true, ..crm(P(curve)), stroke: t)

  // ---- neighbourhood V ----
  let vell = ((315,186),(345,196),(350,225),(332,259),(309,264),(289,250),(286,222),(298,195))
  line(path: true, close: true, ..crmc(P(vell)), stroke: t)
  circle(px(320.5, 220.0), radius: 8.0 / S, fill: black, stroke: none)

  content(px(153.5, 195), anchor: "center", [$f^(-1)(y)$])
  content(px(307.5, 240.5), anchor: "center", [$x$])
  content(px(310, 288), anchor: "center", [$V$])
  content(px(260, 489), anchor: "center", [$X$])
})
