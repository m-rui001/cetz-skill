#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 12pt)

#canvas({
  import draw: *

  let t = (thickness: 1.25pt)
  let d = 1.1          // spacing between consecutive harmonics
  let hs = (2.55, -0.8, 0.75, -0.85, 1.25, -0.55)

  // axes
  line((-6.8, 0), (8.9, 0), stroke: t)
  line((0, -1.05), (0, 2.85), stroke: t)

  // odd harmonics reach up, even ones are marked below the axis
  for k in range(1, 7) {
    let x = k * d
    line((x, 0), (x, hs.at(k - 1)), stroke: t)
    let lbl = if k == 1 { "" } else { str(k) }
    content((x, -1.05), anchor: "north", [$#lbl nu_0$])
  }

  // frequency axis label
  content((2.35, 2.24), anchor: "center", [$nu$])
  line((2.85, 2.24), (4.05, 2.24), stroke: t, mark: (end: ">"))
})
