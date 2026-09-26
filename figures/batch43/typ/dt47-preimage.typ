#set page(width: auto, height: auto, margin: 2pt)
#set text(size: 6.5pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let px = (x, y) => ((x - 634.0) / S, (174.0 - y) / S)
  let P = (pts) => pts.map(p => px(p.at(0), p.at(1)))

  let tb = (thickness: 1.15pt)
  let tr = (thickness: 0.8pt)
  let tc = (thickness: 1.3pt)
  let tg = (thickness: 1.0pt)
  let hdl = (symbol: ">", fill: black, length: 6.3pt, width: 2.5pt)
  let hdg = (symbol: ">", fill: black, length: 7pt, width: 3pt)

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

  // ---- outer boundary of X ----
  let leftEdge = ((48,12),(35,24),(26,36),(19,48),(14,60),(12,72),(11,84),(11,96),(14,108),
                  (17,120),(23,132),(31,144),(37,156),(40,168),(41,180),(39,192),(35,204),
                  (28,216),(19,228),(12,240),(7,252),(3,264),(2,276),(2,288),(3,300),(7,312),
                  (12,324),(19,336),(29,348))
  let rightEdge = ((322,12),(303,24),(294,36),(288,48),(284,60),(283,72),(284,84),(288,96),
                   (295,108),(305,120),(313,132),(318,144),(321,156),(322,168),(321,180),
                   (319,192),(313,204),(306,216),(294,228),(276,240),(259,252),(249,264),
                   (242,276),(238,288),(237,300),(237,312),(240,324),(244,336),(248,348))
  line(path: true, ..crm(P(leftEdge)), stroke: tb)
  line(path: true, ..crm(P(rightEdge)), stroke: tb)
  line(px(46, 8), px(324, 8), stroke: tb)
  line(px(30, 349), px(247, 349), stroke: tb)

  // ---- closed curve inside f^-1(Z) ----
  let loop = ((171,177),(155,168),(145,155),(144,140),(148,126),(158,114),(172,107),(188,107),
              (202,113),(214,124),(221,138),(221,152),(215,164),(210,175),(216.3,186.8),
              (221.6,200.7),(219.5,214.3),(210.1,227.0),(196.2,237.1),(178.8,243.7),
              (160.7,244.4),(143.3,237.7),(127.4,227.0),(117.6,213.5),(112.2,198.5),
              (113.2,184.6),(120.9,173.7),(133.5,167.8),(148.7,166.7),(162.9,169.6),(171,177))
  line(path: true, ..crm(P(loop)), stroke: tb)

  // ---- the S curve f^-1(Z) ----
  let scurve = ((83,105),(82,116),(86,130),(94,144),(105,155),(118,163),(133,169),(150,174),
                (171,178),(186,190),(198,203),(209,215),(221,225),(234,230),(246,233),(255,234))
  line(path: true, ..crm(P(scurve)), stroke: tb)

  content(px(176, 155), anchor: "center", [$x$])
  content(px(108, 88), anchor: "center", text(size: 7.8pt, $f^(-1)(Z)$))
  content(px(136, 373), anchor: "center", [$X$])

  // ---- f arrow ----
  line(px(339, 176), px(488, 176), stroke: tr, mark: (end: hdl))
  content(px(402, 151), anchor: "center", [$f$])

  // ---- rectangle Y ----
  line(px(522.5, 6.5), px(522.5, 347.5), stroke: tr)
  line(px(750, 6.5), px(750, 347.5), stroke: tr)
  line(px(522.5, 6.5), px(750, 6.5), stroke: tr)
  line(px(522.5, 347.5), px(750, 347.5), stroke: tr)
  content(px(639, 369), anchor: "center", [$Y$])

  // ---- circle + Z line inside Y ----
  circle(px(634, 174), radius: 66.0 / S, stroke: tc)
  line(px(523, 175), px(752, 175), stroke: tr)
  content(px(545, 194), anchor: "center", [$Z$])
  content(px(634, 148), anchor: "center", [$y$])
  circle(px(634, 176), radius: 10.0 / S, fill: black, stroke: none)

  // ---- g arrow ----
  let gc = ((753,187),(772,196),(795,203),(822,209),(855,214),(895,217),(940,218),(980,215),
            (1015,208),(1045,198),(1068,188),(1085,180))
  line(path: true, ..crm(P(gc)), stroke: tg, mark: (end: hdg))
  content(px(918, 205), anchor: "center", [$g$])

  // ---- R^1 axis ----
  line(px(1104, 2), px(1104, 350), stroke: tc)
  circle(px(1101, 177), radius: 10.0 / S, fill: black, stroke: none)
  content(px(1121, 172), anchor: "center", [$0$])
  content(px(1103, 366), anchor: "center", [$bold(R)^1$])
})
