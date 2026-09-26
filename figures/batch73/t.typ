#import "@preview/cetz:0.4.2"
#set page(width: 100pt, height: 60pt, margin: 0pt)
#cetz.canvas({
  let S = 148.0
  let Y0 = 730.0
  let px = (x, y) => (x / S, (Y0 - y) / S)
  let st = (t: 0.55pt) => (paint: black, thickness: t, cap: "round")
  let p0 = px(3.5, 237.0)
  let p1 = px(145.0, 52.0)
  line(stroke: st(), p0.at(0), p0.at(1))
})
