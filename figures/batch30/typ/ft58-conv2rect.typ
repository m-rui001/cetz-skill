#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 12pt)

#canvas({
  import draw: *

  let t = (thickness: 1.3pt)
  let rect1 = (cx) => {
    line((cx - 1.62, 0), (cx + 1.62, 0), stroke: t)
    line((cx, -0.32), (cx, 2.25), stroke: t)
    line((cx - .85, 0), (cx - .85, 1.5), stroke: t)
    line((cx - .85, 1.5), (cx + .85, 1.5), stroke: t)
    line((cx + .85, 1.5), (cx + .85, 0), stroke: t)
    content((cx - .85, -0.18), anchor: "north-east", [$-a slash 2$])
    content((cx + .85, -0.18), anchor: "north-west", [$a slash 2$])
  }
  rect1(0)
  rect1(4.1)

  let cx = 9.3
  line((cx - 1.9, 0), (cx + 1.9, 0), stroke: t)
  line((cx, -0.32), (cx, 2.25), stroke: t)
  line((cx - 1.45, 0), (cx, 1.5), (cx + 1.45, 0), stroke: t)
  content((cx - 1.45, -0.18), anchor: "north-east", [$-a$])
  content((cx + 1.45, -0.18), anchor: "north-west", [$a$])
})
