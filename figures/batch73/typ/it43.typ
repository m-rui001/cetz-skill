// Itskov, Tensor Algebra for Engineers — double summation regions (src/it43-raw.png)
#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw

#let S = 148.0
#let Y0 = 369.0
#let px = (x, y) => (x / S, (Y0 - y) / S)

#let ink = (t: 0.5pt) => (paint: black, thickness: t, cap: "round")
#let gcol = rgb("#e8e8e8")
#let gl = (t: 0.4pt) => (paint: gcol, thickness: t, cap: "butt")
#let fillc = rgb("#f1f1f1")

#canvas({
  import draw: *

  // ---- shaded summation regions ----
  let regL = (px(35,336), px(35,299), px(72,299), px(72,262), px(109,262), px(109,225),
    px(146,225), px(146,188), px(183,188), px(183,151), px(220,151), px(220,114),
    px(294,114), px(294,336))
  let regR = (px(385,336), px(385,299), px(422,299), px(422,262), px(459,262), px(459,225),
    px(496,225), px(496,188), px(533,188), px(533,151), px(570,151), px(570,114),
    px(681,114), px(681,336))
  for r in (regL, regR) {
    line(stroke: none, fill: fillc, close: true, ..r)
  }

  // ---- light grid ----
  for x in (72,109,146,183,220,257,294) { line(stroke: gl(), px(x,39), px(x,336)) }
  for y in (39,76,113,150,187,224,261,298) { line(stroke: gl(), px(35,y), px(294,y)) }
  for x in (422,459,496,533,570,607,644,681) { line(stroke: gl(), px(x,39), px(x,336)) }
  for y in (39,76,113,150,187,224,261,298) { line(stroke: gl(), px(385,y), px(681,y)) }

  // ---- axes ----
  line(stroke: ink(t: 0.6pt), px(35,336), px(35,28))
  line(stroke: none, fill: black, close: true, px(35,3), px(28,28), px(41,28))
  line(stroke: ink(t: 0.6pt), px(35,335), px(316,335))
  line(stroke: none, fill: black, close: true, px(340,335), px(316,329), px(316,342))
  line(stroke: ink(t: 0.6pt), px(385,336), px(385,30))
  line(stroke: none, fill: black, close: true, px(385,5), px(379,30), px(392,30))
  line(stroke: ink(t: 0.6pt), px(385,335), px(674,335))
  line(stroke: none, fill: black, close: true, px(698,335), px(674,329), px(674,342))

  // ---- staircases ----
  line(stroke: ink(), ..(px(34,298), px(72,298), px(72,262), px(108,262), px(108,224), px(145,224),
    px(145,188), px(182,188), px(182,150), px(219,150)))
  line(stroke: ink(), ..(px(384,298), px(422,298), px(422,262), px(460,262), px(460,224), px(496,224),
    px(496,188), px(533,188), px(533,150), px(570,150)))

  // ---- vertical arrows (left panel) ----
  for a in ((52,302),(90,266),(127,228),(164,192),(201,154)) {
    line(stroke: ink(t: 0.45pt), px(a.at(0), 335), px(a.at(0), a.at(1) + 15))
    line(stroke: ink(t: 0.45pt), ..(px(a.at(0) - 4, a.at(1) + 15), px(a.at(0), a.at(1)),
      px(a.at(0) + 4, a.at(1) + 15)))
  }

  // ---- horizontal arrows (right panel) ----
  for a in ((533,170),(496,206),(459,243),(422,280),(385,317)) {
    line(stroke: ink(t: 0.45pt), px(a.at(0), a.at(1)), px(552, a.at(1)))
    line(stroke: ink(t: 0.45pt), ..(px(551, a.at(1) - 4), px(569, a.at(1) - 1), px(551, a.at(1) + 4)))
  }

  // ---- brace ----
  line(stroke: ink(t: 0.45pt), ..(px(571,157), px(576,163), px(576,219), px(589,232),
    px(576,245), px(576,319), px(571,323)))

  // ---- dashed rectangle corners ----
  for d in ((113,118),(126,134),(142,150)) { line(stroke: ink(t: 0.45pt), px(220,d.at(0)), px(220,d.at(1))) }
  for d in ((228,239),(246,256)) { line(stroke: ink(t: 0.45pt), px(d.at(0),113), px(d.at(1),113)) }
  for d in ((113,118),(127,134),(143,150)) { line(stroke: ink(t: 0.45pt), px(570,d.at(0)), px(570,d.at(1))) }
  line(stroke: ink(t: 0.45pt), px(583,113), px(591,113))

  // ---- dash-dot i = k lines ----
  for d in ((238,132,249,121),(263,107,274,96),(287,83,298,72)) {
    line(stroke: ink(t: 0.45pt), px(d.at(0), d.at(1)), px(d.at(2), d.at(3)))
  }
  for d in ((620,101,631,90),(645,76,656,65)) {
    line(stroke: ink(t: 0.45pt), px(d.at(0), d.at(1)), px(d.at(2), d.at(3)))
  }
  for d in ((280.5,89.5),(305.5,64.5),(613.5,108.5),(637.5,83.5),(662.5,59.5)) {
    circle(px(d.at(0), d.at(1)), radius: 1.1 / S, fill: black, stroke: none)
  }

  // ---- labels ----
  let tx = (x, y, s, t) => content(px(x, y), anchor: "center", [#text(size: s * 1pt)[#t]])
  tx(13.5, 26.5, 4.6, [$i$])
  tx(358.5, 26.5, 4.6, [$i$])
  tx(11.5, 133.5, 5.0, [∞])
  tx(362.0, 134.0, 5.0, [∞])
  tx(9.0, 205.0, 4.7, [3])
  tx(8.5, 242.0, 4.7, [2])
  tx(9.0, 279.0, 4.7, [1])
  tx(8.5, 316.0, 4.7, [0])
  tx(360.0, 205.0, 4.7, [3])
  tx(360.0, 242.0, 4.7, [2])
  tx(360.0, 279.0, 4.7, [1])
  tx(360.0, 316.0, 4.7, [0])
  tx(311.0, 45.0, 4.0, [$i = k$])
  tx(662.0, 45.0, 4.0, [$i = k$])
  tx(258.5, 199.5, 3.76, [summation])
  tx(254.0, 219.5, 3.73, [area])
  tx(623.5, 139.5, 3.76, [summation])
  tx(622.0, 158.5, 3.73, [area])
  tx(52.0, 359.0, 4.7, [0])
  tx(88.5, 359.0, 4.7, [1])
  tx(126.0, 359.0, 4.7, [2])
  tx(163.0, 359.0, 4.7, [3])
  tx(403.0, 359.0, 4.7, [0])
  tx(440.0, 359.0, 4.7, [1])
  tx(477.0, 359.0, 4.7, [2])
  tx(514.0, 359.0, 4.7, [3])
  tx(248.0, 361.5, 5.0, [∞])
  tx(599.0, 361.5, 5.0, [∞])
  tx(636.0, 232.0, 5.0, [∞])
  tx(317.5, 358.5, 4.4, [$k$])
  tx(674.5, 358.5, 4.4, [$k$])
  for d in ((8.5,157),(8.5,165.5),(8.5,174),(358.5,157),(358.5,165.5),(358.5,174),
    (197.5,360.5),(207.0,360.5),(216.5,360.5),(548.5,360.5),(558.0,360.5),(568.0,360.5),
    (597.5,231.5),(607.5,231.5),(617.0,231.5)) {
    circle(px(d.at(0), d.at(1)), radius: 1.15 / S, fill: black, stroke: none)
  }
})
