#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.5pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => ((x - 617.0) / S, (215.0 - y) / S)
  let P = (pts) => pts.map(p => px(p.at(0), p.at(1)))
  let sh = (pts, dx, dy) => pts.map(p => (p.at(0) + dx, p.at(1) + dy))

  let wrap = (pts, i) => {
    let k = pts.len()
    let j = i
    while j < 0 { j = j + k }
    while j >= k { j = j - k }
    pts.at(j)
  }

  let crmc = (pts, n: 7) => {
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
  let hd = (symbol: ">", fill: black, length: 6pt, width: 2.7pt)

  let z1 = ((176,40),(228,44),(270,75),(299,131),(307,196),(293,254),(266,286),(213,312),
            (156,316),(130,308),(108,285),(106,258),(114,243),(127,239),(138,188),(121,139),
            (108,137),(92,115),(86,81),(110,54))
  let z2 = ((602,34),(653,34),(685,46),(721,90),(738,135),(742,215),(726,262),(685,296),
            (649,308),(574,306),(558,298),(546,276),(546,249),(570,214),(577,171),(565,140),
            (531,109),(524,78),(543,50))
  let z3 = ((1081,33),(1145,42),(1176,70),(1204,140),(1206,208),(1196,246),(1173,278),
            (1133,300),(1062,310),(1023,296),(1009,273),(1013,242),(1037,207),(1041,171),
            (1030,143),(997,114),(988,79),(1017,44))
  let c1 = ((121,139),(161,154),(170,177),(167,206),(133,238),(87,238),(62,210),(64,175),(90,146))
  let c2 = ((514,125),(553,132),(573,165),(567,214),(538,238),(498,232),(476,196),(484,146))
  let c3 = ((962,129),(1004,146),(1014,192),(994,229),(948,242),(919,222),(913,180),(927,148))

  for z in (sh(z1, -3, 0), sh(z2, -1, 0), sh(z3, 2, 0)) {
    line(path: true, close: true, ..crmc(P(z)), stroke: t)
  }
  for c in (sh(c1, -3, 0), sh(c2, -1, 0), sh(c3, 2, 0)) {
    line(path: true, close: true, ..crmc(P(c)), stroke: t)
  }

  line(px(430, 187), px(326, 187), stroke: t, mark: (end: hd))
  line(px(774, 187.5), px(886, 187.5), stroke: t, mark: (end: hd))

  content(px(28, 191), anchor: "center", [$X''$])
  content(px(507, 268), anchor: "center", [$X$])
  content(px(956.5, 268), anchor: "center", [$X'$])
  content(px(180.5, 340), anchor: "center", [$Z$])
  content(px(607.5, 341), anchor: "center", [$Z$])
  content(px(1066.5, 343), anchor: "center", [$Z$])
  content(px(191, 403.5), anchor: "center", [$hash (X'' ∩ Z) = 2$])
  content(px(1091.5, 407), anchor: "center", [$hash (X' ∩ Z) = 0$])
})
