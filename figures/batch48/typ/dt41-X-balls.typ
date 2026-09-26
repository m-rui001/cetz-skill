#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.5pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => ((x - 446.0) / S, (196.0 - y) / S)
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
    out.push(if closed { pts.at(0) } else { pts.at(k - 1) })
    out
  }

  let t = (thickness: 1.15pt)
  let hd = (symbol: ">", fill: black, length: 6.6pt, width: 2.7pt)

  let oval = ((234,60),(289,62),(358,85),(405,118),(448,168),(474,215),(477,256),(461,294),
              (421,331),(369,355),(304,371),(193,371),(136,359),(88,339),(28,287),(16,252),
              (20,212),(68,142),(150,81))
  let b1 = ((154,191),(182,193),(199,212),(199,238),(180,257),(153,258),(132,238),(134,207))
  let b2 = ((336,204),(358,205),(378,223),(378,253),(354,272),(330,270),(312,253),(312,223))

  line(path: true, close: true, ..P(spl(oval, true)), stroke: t)
  line(path: true, close: true, ..P(spl(b1, true)), stroke: t)
  line(path: true, close: true, ..P(spl(b2, true)), stroke: t)
  circle(px(163.5, 226), radius: 6.5 / S, fill: black, stroke: none)
  circle(px(343.5, 238), radius: 6.7 / S, fill: black, stroke: none)

  let fpath = ((378,91),(400,85.5),(420,81.5),(440,78.5),(460,76.5),(480,75.5),(500,74.5),
               (520,74.5),(540,75.5),(560,76.5),(580,78.5),(600,80.5),(620,82.5),(640,85.5),
               (660,88.5),(680,91.5),(700,95.5),(720,100),(740,104.5),(760,110),(780,117),
               (800,124),(818,131),(836,138))
  let gpath = ((366,275),(380,283),(400,289),(420,295.5),(440,300),(460,303),(480,304.5),
               (510,304.5),(540,301.5),(570,297),(600,291.5),(630,283),(660,274),(690,263),
               (720,251),(750,236.5),(775,223),(798,211),(817,200),(835,188))

  line(path: true, ..P(spl(fpath, false)), stroke: t, mark: (end: hd))
  line(path: true, ..P(spl(gpath, false)), stroke: t, mark: (end: hd))

  content(px(252, 36), anchor: "center", [$X$])
  content(px(548.5, 45), anchor: "center", [$f$])
  content(px(565.5, 331), anchor: "center", [$f._i$])
  content(px(314, 288), anchor: "center", [$partial B_i$])
  content(px(858, 161), anchor: "center", [$bold(R)^n$])
})
