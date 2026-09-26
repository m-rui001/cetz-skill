#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.3pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => ((x - 634.0) / S, (174.0 - y) / S)
  let P = (pts) => pts.map(p => px(p.at(0), p.at(1)))

  // parametric ellipse arc in source pixel space
  let ell = (cx, cy, rx, ry, t0, t1, n: 40) => {
    let out = ()
    for i in range(0, n + 1) {
      let a = ((t0 + (t1 - t0) * i / n) * 3.14159265) / 180.0
      out.push((cx + rx * calc.cos(a), cy + ry * calc.sin(a)))
    }
    out
  }

  let rr = (x0, y0, x1, y1, r) => {
    let a = ()
    for p in (ell(x0 + r, y0 + r, r, r, 180, 270, n: 8),
              ell(x1 - r, y0 + r, r, r, 270, 360, n: 8),
              ell(x1 - r, y1 - r, r, r, 0, 90, n: 8),
              ell(x0 + r, y1 - r, r, r, 90, 180, n: 8)) {
      for q in p { a.push(q) }
    }
    a
  }

  let crm = (pts, n: 7) => {
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

  let t = (thickness: 1.0pt)
  let td = (thickness: 1.0pt, dash: (array: (2.4pt, 2.2pt)))
  let hd = (symbol: ">", fill: black, length: 5.4pt, width: 2.4pt)

  // ---------- square ----------
  line(path: true, close: true, ..P(rr(16, 18, 155, 152, 9)), stroke: t)

  // ---------- arrow 1 ----------
  line(px(198, 83.5), px(399, 83.5), stroke: t, mark: (end: hd))
  content(px(297, 56), anchor: "center", [Glue])
  content(px(299.5, 112), anchor: "center", [top to bottom])

  // ---------- cylinder ----------
  line(path: true, ..P(ell(453.5, 84.5, 17.5, 33.0, 0, 360)), stroke: t)
  line(px(453.5, 51.5), px(717, 51.5), stroke: t)
  line(px(453.5, 117.5), px(717, 117.5), stroke: t)
  line(path: true, ..P(ell(717.0, 84.5, 18.0, 33.0, -90, 90)), stroke: t)
  line(path: true, ..P(ell(717.0, 84.5, 18.0, 33.0, 90, 270)), stroke: td)
  content(px(579, 183), anchor: "center", [Cylinder])

  // ---------- arrow 2 ----------
  line(px(776, 83.5), px(975, 83.5), stroke: t, mark: (end: hd))
  content(px(873.5, 57), anchor: "center", [Glue])
  content(px(875.5, 112), anchor: "center", [ends of cylinder])

  // ---------- torus ----------
  line(path: true, ..P(ell(1127.0, 85.0, 117.0, 60.0, 0, 360)), stroke: t)
  line(path: true, ..P(ell(1127.5, 83.5, 47.5, 19.5, 0, 360)), stroke: t)
  let loopSolid = ((1072,97),(1082,90),(1086,82),(1081,73),(1071,66),(1057,61),(1042,60),
                   (1028,63),(1017,69),(1011,77),(1011,86),(1014,94))
  let loopDash = ((1014,94),(1023,101),(1035,105),(1048,106),(1061,102),(1072,97))
  line(path: true, ..crm(P(loopSolid)), stroke: t)
  line(path: true, ..crm(P(loopDash)), stroke: td)
  content(px(1125, 180.5), anchor: "center", [Torus])

  // ---------- long arc G ----------
  let gpts = ((148,224),(166,232),(180,238),(200,247),(220,255),(240,263),(260,269),
              (280,275),(300,280),(320,285),(340,289),(360,293),(380,296),(400,299),
              (420,302),(440,304),(460,306),(480,307),(500,308),(520,309),(540,310),
              (560,310),(580,311),(600,311),(620,310),(640,310),(660,309),(680,309),
              (700,308),(720,307),(740,306),(760,305),(780,304),(800,301),(820,300),
              (840,297),(860,294),(880,291),(900,288),(920,284),(940,280),(960,276),
              (980,271),(1000,266),(1020,260),(1040,253),(1060,245),(1085,234))
  line(path: true, ..crm(P(gpts), n: 5), stroke: t, mark: (end: hd))
  content(px(623.5, 332), anchor: "center", text(size: 7pt, [$G$]))
})
