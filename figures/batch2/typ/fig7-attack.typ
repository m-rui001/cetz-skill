#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 0.9cm, {
  let W = 5.0
  let H = 2.4
  let labs = ("0.05", "0.1", "0.15", "0.2", "0.25", "0.3", "0.35", "0.4")
  draw.rect((0, 0), (W, H), stroke: 0.7pt)
  for i in range(1, 9) {
    let y = i * 0.3
    draw.line((0, y), (-0.12, y), stroke: 0.6pt)
    draw.content((-0.25, y), labs.at(i - 1), anchor: "east")
  }
  for i in range(0, 5) {
    let x = i * W / 4
    draw.line((x, 0), (x, -0.12), stroke: 0.6pt)
    draw.content((x, -0.3), str(i * 50), anchor: "north")
  }
  let spikes = ((0.06, 2.4), (0.15, 0.36), (0.3, 0.18), (0.45, 0.09),
    (0.95, 0.15), (1.0, 0.54), (1.08, 0.12), (1.6, 0.33), (1.72, 0.51),
    (2.55, 0.09), (2.62, 0.27), (2.7, 0.24), (3.3, 0.36), (3.45, 0.57),
    (4.0, 0.05), (4.85, 0.42), (4.95, 0.12))
  for s in spikes {
    draw.line((s.at(0), 0), (s.at(0), s.at(1)), stroke: 0.7pt)
  }
  draw.content((W / 2, -0.75), [Time (k)], anchor: "north")
  draw.content((-1.3, H / 2), rotate(-90deg, $abs(x_k)$), anchor: "center")
})
