#set page(width: auto, height: auto, margin: 12pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Arial", size: 11pt, weight: "bold")

// Fig.1: two phase-controlled paths meet at the second beam splitter.
#canvas(length: 1pt, {
  import draw: *
  let P = (x, y) => (.6*x, .6*y)
  let s = (thickness: .85pt)
  let beam = (a, b) => {
    line(P(..a), P(..b), stroke: s)
    let dx = b.at(0) - a.at(0)
    let dy = b.at(1) - a.at(1)
    let n = calc.sqrt(dx*dx + dy*dy)
    let ux = dx/n
    let uy = dy/n
    let bx = b.at(0) - 6.5*ux
    let by = b.at(1) - 6.5*uy
    line(P(..b), P(bx - 2.7*uy, by + 2.7*ux), P(bx + 2.7*uy, by - 2.7*ux), close: true, fill: black, stroke: none)
  }

  beam((-32, 0), (438, 0))
  beam((0, 0), (0, -92))
  beam((0, -92), (474, -92))
  beam((438, 0), (438, -129))
  rect(P(-110, -16), P(-32, 16), fill: white, stroke: .6pt)
  content(P(-71, 0), [#text(size: 10.2pt)[Source]])

  let rounded-box = (cx, cy, label) => {
    let points = ()
    let corners = ((20, 11, 0deg), (-20, 11, 90deg), (-20, -11, 180deg), (20, -11, 270deg))
    for corner in corners {
      for j in range(7) {
        let a = corner.at(2) + j * 90deg/6
        points.push(P(cx + corner.at(0) + 5*calc.cos(a), cy + corner.at(1) + 5*calc.sin(a)))
      }
    }
    line(..points, path: true, close: true, fill: white, stroke: .6pt)
    content(P(cx, cy), [#text(size: 6.8pt)[#label]])
  }
  rounded-box(116.5, 0, [PSA])
  rounded-box(319, -92, [PSB])

  // Thick diagonal plates are beam splitters; thin hatched plates are mirrors.
  line(P(-8, 17), P(12, -18), stroke: 3pt)
  line(P(427, -74), P(447, -108), stroke: 3pt)
  content(P(13, -26), [#text(size: 6pt)[BS]])
  content(P(417, -65), [#text(size: 6pt)[BS]])
  let mirror = (cx, cy, vx, vy, nx, ny) => {
    line(P(cx - 23*vx, cy - 23*vy), P(cx + 23*vx, cy + 23*vy), stroke: .65pt)
    for t in (-21, -14, -7, 0, 7, 14, 21) {
      let x = cx + t*vx
      let y = cy + t*vy
      line(P(x, y), P(x + 7*nx, y + 7*ny), stroke: .65pt)
    }
  }
  mirror(0, -92, .5, -.866, -.45, -.893)
  mirror(438, 0, .36, -.933, .12, .993)

  let detector = (cx, cy, a0, a1) => {
    let points = ()
    for j in range(25) {
      let a = a0 + (a1 - a0)*j/24
      points.push(P(cx + 21.5*calc.cos(a), cy + 21.5*calc.sin(a)))
    }
    line(..points, path: true, close: true, stroke: .6pt)
  }
  detector(474, -92, -90deg, 90deg)
  detector(438, -129, 180deg, 360deg)
  content(P(465, -126), [#text(size: 7.1pt)[Detectors]], anchor: "west")
})
