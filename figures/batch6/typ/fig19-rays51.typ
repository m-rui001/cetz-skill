#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let L = (0, 2.0)
  let dtop = (1.67, 4.44)
  let Mp = (3.22, 1.44)
  let dptop = (2.22, 4.33)
  let Z = (1.21, 3.77)
  let Zp = (2.50, 3.51)
  line(L, dtop)
  line(Mp, dptop)
  line((0, 4.0), (3.44, 3.33))
  circle(Z, radius: .06, fill: black)
  circle(Zp, radius: .06, fill: black)
  circle(Mp, radius: .07, fill: black)
  content((1.6, 4.6), [d])
  content((2.3, 4.5), [d#sym.prime])
  content((1.02, 3.45), [Z])
  content((2.32, 3.18), [Z#sym.prime])
  content((3.3, 1.15), [M#sym.prime])
  content((-.25, 1.7), [L])
})
