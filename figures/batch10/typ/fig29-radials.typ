#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let panel = (ox, lab, inward) => {
    for i in range(8) {
      let a = i * 45deg
      let ux = calc.cos(a)
      let uy = calc.sin(a)
      let L = 1.7
      line((ox, 0), (ox + L * ux, L * uy))
      let s0 = if inward { 1.05 } else { .62 }
      let s1 = if inward { .62 } else { 1.05 }
      line((ox + s0 * ux, s0 * uy), (ox + s1 * ux, s1 * uy), mark: (end: ">"))
    }
    content((ox, -2.2), lab)
  }
  panel(0, [(a)], false)
  panel(4.8, [(b)], true)
})
