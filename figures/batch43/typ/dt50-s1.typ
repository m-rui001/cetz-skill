#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 7pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => ((x - 600.0) / S, (200.0 - y) / S)
  let P = (pts) => pts.map(p => px(p.at(0), p.at(1)))
  let t = (thickness: 1.2pt)
  let hd = (symbol: ">", fill: black, length: 5.5pt, width: 3.8pt)

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
      let p0 = wrap(pts, i - 1); let p1 = pts.at(i)
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
    out.push(pts.at(0)); out
  }

  let f0 = (((839,2),
              (863,2),
              (896,8),
              (908,12),
              (939,32),
              (961,56),
              (981,92),
              (1005,122),
              (1041,153),
              (1073,172),
              (1085,185),
              (1099,213),
              (1101,256),
              (1097,272),
              (1087,292),
              (1070,310),
              (1040,326),
              (970,338),
              (878,342),
              (809,340),
              (703,332),
              (689,328),
              (665,316),
              (665,313),
              (651,304),
              (637,288),
              (625,268),
              (618,247),
              (617,196),
              (627,165),
              (641,137),
              (650,104),
              (663,82),
              (705,42),
              (734,26),
              (773,12)))
  let f13 = (((890,81),
              (873,86),
              (853,97),
              (830,102),
              (802,101),
              (775,91),
              (753,89),
              (721,102),
              (707,115),
              (677,165),
              (669,195),
              (670,218),
              (675,236),
              (681,250),
              (701,273),
              (732,289),
              (772,295),
              (833,299),
              (906,299),
              (946,293),
              (968,282),
              (985,268),
              (1000,246),
              (1009,212),
              (1008,190),
              (990,147),
              (972,120),
              (946,97),
              (917,83)))
  let f23 = (((883,122),
              (912,122),
              (924,126),
              (945,140),
              (959,164),
              (962,180),
              (959,211),
              (947,231),
              (933,244),
              (916,252),
              (892,256),
              (789,256),
              (742,248),
              (719,228),
              (710,205),
              (710,179),
              (713,167),
              (730,144),
              (745,131),
              (767,125),
              (786,126),
              (798,130),
              (813,141),
              (822,158),
              (833,162),
              (846,155),
              (853,137),
              (859,132)))
  let fh = (((885,150),
              (867,156),
              (849,173),
              (841,192),
              (837,214),
              (811,215),
              (802,181),
              (792,170),
              (780,164),
              (758,173),
              (753,181),
              (753,195),
              (761,207),
              (784,213),
              (810,215),
              (813,229),
              (821,235),
              (826,235),
              (835,227),
              (838,213),
              (890,207),
              (912,197),
              (922,187),
              (926,177),
              (922,164),
              (910,154)))

  line(path: true, ..crmc(P(f0)), stroke: t)
  line(path: true, ..crmc(P(f13)), stroke: t)
  line(path: true, ..crmc(P(f23)), stroke: t)
  line(path: true, ..crmc(P(fh)), stroke: t)

  circle(px(90, 250), radius: 92.0 / S, stroke: t)
  content(px(101, 372), anchor: "center", text(size: 6pt, [$S^1$]))

  let arrow = ((256,257),(290,241),(330,228),(370,216),(410,207),(450,200),(490,193),(530,189),(560,185),(597,180))
  line(path: true, ..crm(P(arrow)), stroke: t, mark: (end: hd))

  content(px(917, 218), anchor: "center", text(size: 6.5pt, [$f_1$]))
  content(px(970, 240), anchor: "center", text(size: 6pt, [$f_{frac(2,3)}$]))
  content(px(1027, 252), anchor: "center", text(size: 6pt, [$f_{frac(1,3)}$]))
  content(px(1120, 262), anchor: "center", text(size: 6.5pt, [$f_0$]))
})
