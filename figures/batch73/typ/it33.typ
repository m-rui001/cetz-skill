#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let S = 148.0
  let Y0 = 730.0
  let px = (x, y) => (x / S, (Y0 - y) / S)
  let st = (t: 0.55pt) => (paint: black, thickness: t, cap: "round")

  // ---- parallelogram: x + y = y + x
  let O = px(3.5, 237.0)
  let tx = px(145.0, 52.0)
  let ty = px(293.0, 237.0)
  let ts = px(428.0, 52.0)
  line(stroke: st(), O, tx)
  line(stroke: st(), tx, px(125.0, 94.0))
  line(stroke: st(), tx, px(109.0, 82.0))
  line(stroke: st(), O, ty)
  line(stroke: st(), ty, px(245.0, 247.0))
  line(stroke: st(), ty, px(245.0, 228.0))
  line(stroke: st(t: 0.62pt), O, ts)
  line(stroke: none, fill: black, close: true, ts, px(381.0, 61.0), px(385.0, 82.0))

  // dashed top side (x tip -> sum tip)
  for d in ((171,183),(196,208),(221,233),(246,258),(271,283),
            (296,308),(321,333),(347,358),(371,383),(397,408)) {
    line(stroke: st(t: 0.5pt), px(d.at(0), 51.2), px(d.at(1), 51.2))
  }
  // dashed right side (sum tip -> y tip)
  for d in ((410,76.5,418,68.0),(395,96.5,403,88.0),(380,116.5,388,108.0),
            (365,136.5,373,128.0),(350,157.0,358,148.0),(335,177.0,343,168.0),
            (320,197.0,328,188.0),(305,217.0,313,208.0)) {
    line(stroke: st(t: 0.5pt), px(d.at(0), d.at(1)), px(d.at(2), d.at(3)))
  }

  // ---- negative vector
  line(stroke: st(), px(551.8, 233.9), px(691.1, 48.1))
  line(stroke: st(), px(691.1, 48.1), px(671.0, 91.0))
  line(stroke: st(), px(691.1, 48.1), px(658.0, 77.0))
  line(stroke: st(), px(769.2, 48.2), px(629.1, 235.1))
  line(stroke: st(), px(629.1, 235.1), px(638.0, 215.0))
  line(stroke: st(), px(629.1, 235.1), px(648.0, 218.0))

  // ---- multiplication by a real scalar
  line(stroke: st(), px(472.3, 647.3), px(567.5, 551.5))
  line(stroke: st(), px(567.5, 551.5), px(541.0, 592.0))
  line(stroke: st(), px(567.5, 551.5), px(527.0, 578.0))
  line(stroke: st(t: 0.5pt), px(466.0, 645.5), px(493.0, 645.5))

  line(stroke: st(), px(565.5, 647.5), px(755.0, 458.0))
  line(stroke: st(), px(755.0, 458.0), px(729.0, 498.0))
  line(stroke: st(), px(755.0, 458.0), px(715.0, 484.0))
  line(stroke: st(t: 0.5pt), px(648.0, 550.5), px(675.0, 550.5))
  line(stroke: st(t: 0.5pt), px(559.0, 645.5), px(586.0, 645.5))

  line(stroke: st(), px(661.5, 645.5), px(896.0, 411.0))
  line(stroke: st(), px(896.0, 411.0), px(870.0, 451.0))
  line(stroke: st(), px(896.0, 411.0), px(856.0, 437.0))
  line(stroke: st(t: 0.5pt), px(839.0, 456.5), px(866.0, 456.5))
  line(stroke: st(t: 0.5pt), px(745.0, 550.5), px(773.0, 550.5))
  line(stroke: st(t: 0.5pt), px(653.0, 643.5), px(680.0, 643.5))

  // ---- zero vector
  circle(px(161.5, 581.2), radius: 8.25 / S, fill: black, stroke: none)

  // ---- labels
  content(px(401.0, 15.5), anchor: "center", [#text(size: 6.5pt)[$bold(x + y = y + x)$]])
  content(px(42.5, 120.0), anchor: "center", [#text(size: 6.1pt)[$bold(x)$]])
  content(px(135.0, 278.5), anchor: "center", [#text(size: 6.0pt)[$bold(y)$]])
  content(px(132.0, 320.0), anchor: "center", [#text(size: 7.2pt)[vector addition]])
  content(px(563.0, 125.0), anchor: "center", [#text(size: 6.1pt)[$bold(x)$]])
  content(px(719.5, 181.5), anchor: "center", [#text(size: 6.5pt)[$bold(-x)$]])
  content(px(637.0, 322.0), anchor: "center", [#text(size: 6.7pt)[negative vector]])
  content(px(169.5, 626.5), anchor: "center", [#text(size: 6.7pt)[zero vector]])
  content(px(481.5, 560.0), anchor: "center", [#text(size: 6.1pt)[$bold(x)$]])
  content(px(637.5, 489.0), anchor: "center", [#text(size: 6.0pt)[$bold(2x)$]])
  content(px(791.0, 413.0), anchor: "center", [#text(size: 5.9pt)[$bold(2.5x)$]])
  content(px(659.0, 711.0), anchor: "center",
          [#text(size: 6.9pt)[multiplication by a real scalar]])
})
