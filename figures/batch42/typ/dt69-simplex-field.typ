#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let t = (thickness: 1.5pt)
  let hd = (symbol: ">", fill: black, length: 5pt, width: 2.2pt)


  let top = (0, 1.588)
  let bl = (-1.318, -0.757)
  let br = (1.331, -0.757)
  let ml = (-0.676, 0.412)
  let mr = (0.676, 0.412)
  let mb = (0, -0.757)

  line(bl, top, stroke: t)
  line(top, br, stroke: t)
  line(bl, br, stroke: t)

  // arrows along the edges, pointing away from each midpoint
  line(ml, (-0.372, 0.966), stroke: t, mark: (end: hd))
  line(ml, (-0.980, -0.081), stroke: t, mark: (end: hd))
  line(mr, (0.372, 0.966), stroke: t, mark: (end: hd))
  line(mr, (1.014, -0.081), stroke: t, mark: (end: hd))
  line(mb, (-0.372, -0.770), stroke: t, mark: (end: hd))
  line(mb, (0.372, -0.770), stroke: t, mark: (end: hd))

  // edge extensions beyond the base vertices
  line(bl, (-2.027, -1.264), stroke: t, mark: (end: hd))
  line(br, (2.176, -1.264), stroke: t, mark: (end: hd))

  // inward arrows from outside
  line((-1.115, 0.730), (-0.743, 0.426), stroke: t, mark: (end: hd))
  line((1.115, 0.730), (0.743, 0.426), stroke: t, mark: (end: hd))
  line((0, 2.351), top, stroke: t)
  line((0, 1.995), (0, 1.928), stroke: t, mark: (end: hd))
  line((0, -1.426), mb, stroke: t)
  line((0, -1.284), (0, -1.217), stroke: t, mark: (end: hd))

  // six radial arrows at the centre
  line((0, 0.100), (0, 0.561), stroke: t, mark: (end: hd))
  line((0, -0.149), (0, -0.520), stroke: t, mark: (end: hd))
  line((-0.236, 0.155), (-0.574, 0.291), stroke: t, mark: (end: hd))
  line((0.236, 0.155), (0.608, 0.291), stroke: t, mark: (end: hd))
  line((-0.304, -0.115), (-0.608, -0.284), stroke: t, mark: (end: hd))
  line((0.304, -0.115), (0.642, -0.284), stroke: t, mark: (end: hd))

  for p in (ml, mr, mb, (0, 0)) {
    circle(p, radius: 0.075, fill: black, stroke: none)
  }
})
