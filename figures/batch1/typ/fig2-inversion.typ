#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1.4cm, {
  let r = 1.6
  let ux = calc.cos(33deg)
  let uy = calc.sin(33deg)
  let z2 = (3.3 * ux, 3.3 * uy)
  let q = (r * ux, r * uy)
  let p = (-r * ux, -r * uy)
  let zb = (0.85 * ux, 0.85 * uy)
  let z = (0.85 * ux, -0.85 * uy)

  draw.circle((0, 0), radius: r)
  draw.line((0, 0), (3.6, 0), mark: (end: ">"))
  draw.line((0, 0), (0, 2.7), mark: (end: ">"))
  draw.line(p, z2)
  draw.line(z2, (r, 0), stroke: (dash: "dashed"))
  draw.line(z, (r, 0), stroke: (dash: "dashed"))
  draw.line(zb, z, stroke: (dash: "dashed"))
  draw.arc((1.05, 0), radius: 1.05, start: 0deg, stop: 33deg,
    stroke: (dash: "dashed"), mark: (end: ">"))
  draw.arc((0.55 * calc.cos(-33deg), 0.55 * calc.sin(-33deg)),
    radius: 0.55, start: -33deg, stop: 0deg, stroke: (dash: "dashed"))

  draw.content((-0.12, -0.05), [O], anchor: "east")
  draw.content((3.55, -0.15), $x$, anchor: "north")
  draw.content((-0.12, 2.65), $y$, anchor: "east")
  draw.content((p.at(0) - 0.18, p.at(1) - 0.12), [P])
  draw.content((q.at(0) + 0.12, q.at(1) + 0.12), [Q])
  draw.content((r + 0.08, -0.12), [U], anchor: "north-west")
  draw.content((z2.at(0) + 0.1, z2.at(1) + 0.08), $Z_2$, anchor: "south-west")
  draw.content((zb.at(0) - 0.05, zb.at(1) + 0.14), $overline(Z)$, anchor: "south")
  draw.content((z.at(0), z.at(1) - 0.14), [Z], anchor: "north")
  draw.content((1.25 * calc.cos(16deg), 1.25 * calc.sin(16deg)), $theta_2$)
  draw.content((0.42, -0.3), $-theta_2$)
})
