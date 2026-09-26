#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1.6pt)
  let cav = (p0, p1, c1, c2) => bezier(p0, p1, c1, c2, stroke: th, mark: (end: ">"))
  let panel = (ox, form, top, right, bottom, left) => {
    content((ox, 0), form)
    // from the top-right note
    cav((ox + 1.55, 1.85), (ox + .5, .38), (ox + 1.6, .95), (ox + 1.3, .35))
    content((ox + 1.75, 1.7), anchor: "west", top)
    // from the right note
    cav((ox + 2.35, -.05), (ox + .8, .12), (ox + 2.35, .65), (ox + 1.5, .45))
    content((ox + 1.75, -.85), anchor: "west", right)
    // from the bottom note
    cav((ox + .55, -1.35), (ox + .12, -.42), (ox + .65, -.95), (ox + .5, -.5))
    content((ox + .55, -2.15), anchor: "west", bottom)
    // from the left note
    cav((ox - 1.5, -1.0), (ox - .78, -.22), (ox - 1.5, -.35), (ox - 1.25, -.2))
    content((ox - 1.65, -1.95), anchor: "west", left)
  }
  panel(0,
    [$Gamma^r_{r theta} = 0$],
    [in the $hat(e)_r$ direction],
    [has zero \ magnitude],
    [caused by a \ change in $theta$],
    [The change \ in $\hat(e)_r$])
  panel(7.6,
    [$Gamma^theta_{r theta} = frac(1, r)$],
    [in the $hat(e)_theta$ direction],
    [varies inversely \ with distance],
    [caused by a \ change in $theta$],
    [The change \ in $\hat(e)_r$])
})
