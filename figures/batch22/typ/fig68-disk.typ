#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *

  let th = (thickness: 1.6pt)
  let O = (0, 0)

  let dot = (p) => circle(p, radius: .13, fill: black, stroke: none)

  let cross = (p) => {
    circle(p, radius: .19, stroke: th)
    line((p.at(0) - .13, p.at(1) - .13), (p.at(0) + .13, p.at(1) + .13), stroke: th)
    line((p.at(0) - .13, p.at(1) + .13), (p.at(0) + .13, p.at(1) - .13), stroke: th)
  }

  let bullet = (p) => {
    circle(p, radius: .19, stroke: th)
    circle(p, radius: .06, fill: black, stroke: none)
  }

  let hd = (P, d, s) => {
    let u = calc.sqrt(d.at(0) * d.at(0) + d.at(1) * d.at(1))
    let e = (P.at(0) + s * d.at(0) / u, P.at(1) + s * d.at(1) / u)
    let perp = (0.0 - d.at(1) / u, d.at(0) / u)
    line((P.at(0) + s * d.at(0) / u, P.at(1) + s * d.at(1) / u),
         (P.at(0) - s * d.at(0) / u + s * .75 * perp.at(0),
          P.at(1) - s * d.at(1) / u + s * .75 * perp.at(1)),
         (P.at(0) - s * d.at(0) / u - s * .75 * perp.at(0),
          P.at(1) - s * d.at(1) / u - s * .75 * perp.at(1)),
         close: true, fill: black, stroke: none)
  }

  // axes
  line((-3.42, 0), (5.38, 0), stroke: th, mark: (end: ">"))
  line((0, -2.5), (0, 5.58), stroke: th, mark: (end: ">"))
  content((0.24, 5.5), anchor: "west", [$z'$])
  content((5.45, 0.28), anchor: "west", [$y'$])

  // rotation curl on z' axis
  circle((0, 3.77), radius: (.78, .2), stroke: (thickness: 1.3pt))
  let ca = -20deg
  hd((0.78 * calc.cos(ca), 3.77 + 0.2 * calc.sin(ca)), (.35, .94), .13)

  // ---- mass 5 (upper right, v into page) ----
  let m5 = (2.23, 3.77)
  let l5 = (0.85, 4.54)
  line(O, m5, stroke: th, mark: (end: ">"))
  line(m5, l5, stroke: th, mark: (end: ">"))
  content((0.73, 2.12), anchor: "east", [$arrow(r_5)$])
  content((2.55, 4.02), anchor: "west", [$m_5$])
  content((0.95, 5.0), anchor: "west", [$arrow(L_5) = m_5 arrow(r_5) times arrow(v_5)$])
  cross((2.83, 3.46))
  content((3.15, 2.95), anchor: "west", [Velocity $arrow(v_5)$ is \ into page])

  // ---- mass 4 (left, v out of page) ----
  let m4 = (0.0 - 2.12, 1.31)
  let l4 = (0.0 - 1.62, 2.12)
  line(O, m4, stroke: th, mark: (end: ">"))
  line(m4, l4, stroke: th, mark: (end: ">"))
  content((-0.83, 1.1), anchor: "west", [$arrow(r_4)$])
  content((-2.32, 1.42), anchor: "east", [$m_4$])
  content((-2.1, 2.75), [$arrow(L_4) = m_4 arrow(r_4) times arrow(v_4)$])
  bullet((-2.65, 0.69))
  content((-2.95, 0.42), anchor: "east", [Velocity $arrow(v_4)$ is \ out of page])

  // ---- mass 1 (lower right, v into page) ----
  let m1 = (2.12, 0.0 - 1.15)
  let l1 = (2.65, 0.0 - 0.27)
  line(O, m1, stroke: th, mark: (end: ">"))
  line(m1, l1, stroke: th, mark: (end: ">"))
  content((0.72, 0.0 - 0.95), anchor: "east", [$arrow(r_1)$])
  content((1.85, 0.0 - 1.72), anchor: "east", [$m_1$])
  content((3.15, 0.0 - 0.55), anchor: "west", [$arrow(L_1) = m_1 arrow(r_1) times arrow(v_1)$])
  cross((2.9, 0.0 - 1.35))
  content((3.2, 0.0 - 1.9), anchor: "west", [Velocity $arrow(v_1)$ is \ into page])

  dot(m5)
  dot(m4)
  dot(m1)
})
