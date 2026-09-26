#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  let th = (thickness: 1pt)
  let td = (dash: "dashed", thickness: 1pt)
  let tv = (thickness: 2pt)
  let a = 155deg
  let ux = (calc.cos(a), calc.sin(a))
  let uy = (calc.cos(a + 90deg), calc.sin(a + 90deg))
  let A = (1.3, .75)
  let sk = (s, u) => (s * u.at(0), s * u.at(1))
  let add = (p, q) => (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let Ax = A.at(0) * ux.at(0) + A.at(1) * ux.at(1)
  let Ay = A.at(0) * uy.at(0) + A.at(1) * uy.at(1)
  let panel = (ox, primed) => {
    line((ox - 2.2, 0), (ox + 2.3, 0), stroke: th, mark: (end: ">"))
    line((ox, -2.5), (ox, 2.05), stroke: th, mark: (end: ">"))
    content((ox + 2.35, -.42), anchor: "west", [$x$])
    content((ox - .22, 1.9), anchor: "east", [$y$])
    let o = (ox, 0)
    line(add(o, sk(-1.75, ux)), add(o, sk(2.15, ux)), stroke: td, mark: (end: ">"))
    line(add(o, sk(-1.65, uy)), add(o, sk(2.25, uy)), stroke: td, mark: (end: ">"))
    content(add(o, sk(2.28, ux)), anchor: "east", [$x'$])
    content(add(o, sk(2.38, uy)), anchor: "east", [$y'$])
    arc(add(o, (1.55, 0)), radius: 1.55, start: 0deg, stop: a, stroke: th, mark: (end: ">"))
    line(o, add(o, A), stroke: tv, mark: (end: ">"))
    content(add(o, (.82, .3)), [$arrow(A)$])
    if primed {
      let Fx = add(o, sk(Ax, ux))
      let Fy = add(o, sk(Ay, uy))
      line(add(o, A), Fx, stroke: th, mark: (end: ">"))
      line(add(o, A), Fy, stroke: th, mark: (end: ">"))
      content(add(Fx, (.12, -.42)), anchor: "west", [$A'_x$])
      content(add(Fy, (-.22, .12)), anchor: "east", [$A'_y$])
    } else {
      line(add(o, A), (add(o, A).at(0), 0), stroke: th, mark: (end: ">"))
      line(add(o, A), (ox, A.at(1)), stroke: th, mark: (end: ">"))
      content((A.at(0) / 2 + ox, -.42), anchor: "center", [$A_x$])
      content((ox - .28, .92), anchor: "east", [$A_y$])
    }
  }
  panel(0, false)
  content((0, -3.1), [(a)])
  panel(5.2, true)
  content((5.2, -3.1), [(b)])
})
