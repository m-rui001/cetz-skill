#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 12pt)

#canvas({
  import draw: *

  let t = (thickness: 1.1pt)
  // 100 px of the book figure = 1 canvas unit; origin sits on the 1st-order parent line

  let spikes = ((-0.57, 0.14), (-0.37, 0.28), (-0.20, 0.60),
    (0.19, 0.60), (0.36, 0.28), (0.57, 0.14),
    (3.17, 0.11), (3.51, 0.25), (3.89, 0.53),
    (4.64, 0.53), (5.02, 0.25), (5.39, 0.11))

  // broken axis
  line((-2.44, 0), (1.62, 0), stroke: t)
  line((1.62, 0), (1.75, 0.22), stroke: t)
  line((1.75, 0.22), (1.93, -0.20), stroke: t)
  line((1.93, -0.20), (2.06, 0), stroke: t)
  line((2.06, 0), (6.08, 0), stroke: t)

  for s in spikes {
    line((s.at(0), 0), (s.at(0), s.at(1)), stroke: t)
  }
  // parent lines carry arrowheads
  line((0, 0), (0, 2.29), stroke: t, mark: (end: ">"))
  line((4.26, 0), (4.26, 2.26), stroke: t, mark: (end: ">"))
  line((0, 1.86), (0.13, 1.97), stroke: t)
  line((4.13, 1.83), (4.26, 1.94), stroke: t)

  content((-0.29, 2.51), anchor: "south", [1st order])
  content((3.76, 2.51), anchor: "south", [2nd order])
  content((0.21, 1.91), anchor: "west", [Parent line])
  content((0.90, 1.28), anchor: "west", [$m^2 slash 4$])
  content((1.52, 0.92), anchor: "west", [Ghosts])
  content((1.30, 0.40), anchor: "west", [$m^4 slash 16$])
  line((0.90, 1.16), (0.24, 0.66), stroke: t)
  line((1.24, 0.30), (0.55, 0.18), stroke: t)

  content((0, -0.29), anchor: "north", [$nu_c$])
  content((4.26, -0.29), anchor: "north", [$2nu_c$])
  line((0.42, -0.49), (0.85, -0.49), stroke: t)
  content((1.05, -0.50), anchor: "center", [$overline(nu)$])
  line((1.25, -0.49), (2.36, -0.49), stroke: t, mark: (end: ">"))
})
