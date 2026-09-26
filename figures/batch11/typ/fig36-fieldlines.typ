#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  // ---- (a) two vortices between two curved streamlines ----
  circle((1.3, 4.4), radius: .72)
  circle((1.3, .1), radius: .72)
  let ah = (p, a) => {
    let u = (calc.cos(a), calc.sin(a))
    line((p.at(0) - .16 * u.at(0), p.at(1) - .16 * u.at(1)), (p.at(0) + .16 * u.at(0), p.at(1) + .16 * u.at(1)), mark: (end: ">"), stroke: (thickness: .8pt))
  }
  ah((1.3, 5.12), 180deg)
  ah((1.3, 3.68), 0deg)
  ah((1.3, .82), 180deg)
  ah((1.3, -.62), 0deg)
  bezier((-.5, 3.5), (3.1, 3.5), (.5, 2.5), (2.1, 2.5))
  bezier((-0.5, 1.0), (3.1, 1.0), (.5, 2.0), (2.1, 2.0))
  ah((1.3, 2.62), 0deg)
  ah((1.3, 1.9), 180deg)
  content((1.3, 4.4), [1])
  content((1.3, .1), [3])
  content((1.3, 2.25), [2])
  content((1.2, -1.6), [(a)])
  // ---- (b) shear profile ----
  let ox = 4.6
  for i in range(7) {
    let y = 3.1 - i * .52
    if i < 4 {
      let L = 1.5 + i * .18
      line((ox, y), (ox + L, y), mark: (end: ">"))
    } else {
      let L = 1.5 - (i - 4) * .35
      line((ox + 1.7, y), (ox + 1.7 - L, y), mark: (end: ">"))
    }
  }
  content((ox + .85, 3.1), [6])
  content((ox + .85, 2.06), [5])
  content((ox + .85, 1.02), [4])
  content((ox + .8, -1.6), [(b)])
  // ---- (c) radial star ----
  let cx = 9.6
  let cy = 1.6
  line((cx - 1.7, cy), (cx + 1.7, cy))
  for i in range(8) {
    let a = i * 45deg
    let u = (calc.cos(a), calc.sin(a))
    if a != 0deg and a != 180deg {
      line((cx + 1.55 * u.at(0), cy + 1.55 * u.at(1)), (cx - 1.55 * u.at(0), cy - 1.55 * u.at(1)), mark: (end: ">"))
    }
  }
  line((cx, cy), (cx, cy + 1.6), mark: (end: ">"))
  line((cx, cy), (cx, cy - 1.6), mark: (end: ">"))
  content((cx + .55, cy + 1.05), [7])
  content((cx - .1, -1.6), [(c)])
})
