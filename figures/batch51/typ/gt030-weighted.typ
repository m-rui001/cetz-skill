#set page(width: auto, height: auto, margin: 2pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(size: 8.4pt, weight: "bold", font: "Times New Roman")

#canvas({
  import draw: *
  let px = (x, y) => (x / 148, (602 - y) / 148)
  let t = (thickness: 0.55pt)
  let dot(p) = circle(p, radius: 0.057, fill: black, stroke: none)

  let crm(pts) = {
    let n = pts.len()
    let out = ()
    for i in range(n - 1) {
      let p0 = if i == 0 { pts.at(0) } else { pts.at(i - 1) }
      let p1 = pts.at(i)
      let p2 = pts.at(i + 1)
      let p3 = if i + 2 < n { pts.at(i + 2) } else { pts.at(n - 1) }
      for j in range(8) {
        let u = j / 8
        let u2 = u * u
        let u3 = u2 * u
        let x = 0.5 * ((2 * p1.at(0)) + (-p0.at(0) + p2.at(0)) * u
          + (2 * p0.at(0) - 5 * p1.at(0) + 4 * p2.at(0) - p3.at(0)) * u2
          + (-p0.at(0) + 3 * p1.at(0) - 3 * p2.at(0) + p3.at(0)) * u3)
        let y = 0.5 * ((2 * p1.at(1)) + (-p0.at(1) + p2.at(1)) * u
          + (2 * p0.at(1) - 5 * p1.at(1) + 4 * p2.at(1) - p3.at(1)) * u2
          + (-p0.at(1) + 3 * p1.at(1) - 3 * p2.at(1) + p3.at(1)) * u3)
        out.push((x, y))
      }
    }
    out.push(pts.last())
    out
  }
  let curve(pts) = line(path: true, ..crm(pts), stroke: t)

  let headAt(p, q, m) = {
    let dx = q.at(0) - p.at(0)
    let dy = q.at(1) - p.at(1)
    let len = calc.sqrt(dx * dx + dy * dy)
    let ux = dx / len
    let uy = dy / len
    let tip = (m.at(0) + ux * 0.148, m.at(1) + uy * 0.148)
    let b1 = (m.at(0) - ux * 0.074 - uy * 0.068, m.at(1) - uy * 0.074 + ux * 0.068)
    let b2 = (m.at(0) - ux * 0.074 + uy * 0.068, m.at(1) - uy * 0.074 - ux * 0.068)
    line(tip, b1, b2, close: true, fill: black, stroke: none)
  }

  let F = px(403, 66)
  let B = px(70, 149)
  let E = px(403, 233)
  let G = px(570, 316)
  let H = px(903, 316)
  let D = px(403, 399)
  let A = px(70, 483)
  let C = px(403, 566)

  line(B, F, stroke: t)
  line(B, E, stroke: t)
  line(F, E, stroke: t)
  line(E, D, stroke: t)
  line(D, C, stroke: t)
  line(E, G, stroke: t)
  line(D, G, stroke: t)
  line(F, H, stroke: t)
  line(C, H, stroke: t)
  line(A, D, stroke: t)
  line(A, C, stroke: t)

  curve((px(403, 66), px(415, 100), px(431, 140), px(441, 160), px(452, 180), px(467, 200), px(482, 225), px(498, 245), px(515, 265), px(534, 285), px(556, 305), px(570, 316)))
  curve((px(403, 66), px(441, 100), px(478, 140), px(508, 180), px(525, 215), px(544, 245), px(552, 265), px(559, 285), px(566, 305), px(570, 316)))
  curve((px(403, 566), px(420, 520), px(438, 480), px(449, 460), px(473, 420), px(505, 380), px(515, 360), px(530, 335), px(548, 318), px(570, 316)))
  curve((px(403, 566), px(454, 520), px(488, 480), px(502, 460), px(527, 420), px(547, 380), px(558, 355), px(566, 330), px(570, 316)))

  headAt(B, F, px(246, 106))
  headAt(B, E, px(246, 194))
  headAt(F, E, px(404, 141))
  headAt(E, D, px(404, 309))
  headAt(D, C, px(404, 475))
  headAt(E, G, px(481, 272))
  headAt(D, G, px(482, 361))
  headAt(F, H, px(681, 205))
  headAt(C, H, px(681, 428))
  headAt(A, D, px(247, 439))
  headAt(A, C, px(246, 527))

  dot(F)
  dot(B)
  dot(E)
  dot(G)
  dot(H)
  dot(D)
  dot(A)
  dot(C)

  content(px(39, 148), text(style: "italic")[B])
  content(px(39, 482), text(style: "italic")[A])
  content(px(404, 30), text(style: "italic")[F])
  content(px(377, 266), text(style: "italic")[E])
  content(px(378, 370), text(style: "italic")[D])
  content(px(606, 319), text(style: "italic")[G])
  content(px(935, 318), text(style: "italic")[H])
  content(px(403, 592), text(style: "italic")[C])

  content(px(240, 70), [(9)9])
  content(px(240, 220), [(10)12])
  content(px(349, 148), [(0)3])
  content(px(458, 187), [(0)25])
  content(px(592, 218), [(18)25])
  content(px(655, 155), [(27)40])
  content(px(355, 287), [(5)5])
  content(px(443, 287), [(5)5])
  content(px(475, 325), [(12)12])
  content(px(240, 404), [(10)10])
  content(px(350, 480), [(3)4])
  content(px(450, 435), [(0)3])
  content(px(520, 445), [(1)3])
  content(px(655, 470), [(7)7])
  content(px(238, 553), [(5)5])
})
