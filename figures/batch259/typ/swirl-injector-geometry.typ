#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 左侧为带切面标记的喷注器纵剖图，右侧为带斜线环形流道的 A–A 横剖图。
// 来源：Aerospace 2024, 11(9), 739, Figure 14；DOI: 10.3390/aerospace11090739
#canvas({
  import draw: *

  let ink = rgb("#292929")
  let gray = rgb("#969994")
  let fine = (paint: ink, thickness: 0.65pt)
  let dim = (paint: gray, thickness: 0.65pt)
  let center = (5.90, 2.55)
  let outer = 2.30
  let inner = 1.73
  let tangent = calc.acos(inner / outer)

  // 共享坐标、标签与箭头助手。
  let add(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
  let sub(a, b) = (a.at(0) - b.at(0), a.at(1) - b.at(1))
  let mul(a, s) = (a.at(0) * s, a.at(1) * s)
  let dot(a, b) = a.at(0) * b.at(0) + a.at(1) * b.at(1)
  let polar(a, r) = add(center, (r * calc.cos(a), r * calc.sin(a)))
  let label(p, body, angle: 0deg, color: ink, size: 11pt) = {
    content(p, text(size: size, fill: color, body),
      angle: angle, anchor: "center", frame: none)
  }
  let arrow(a, b, color: ink, width: 0.65pt, scale: 0.6) = {
    line(a, b, stroke: (paint: color, thickness: width),
      mark: (end: "stealth", scale: scale, fill: color))
  }

  // 纵剖外壳及轴线上大小交替的切向入口孔。
  let shell-left = 0.12
  let shell-right = 2.02
  let axis = 0.80
  let bottom = 0.25
  let top = 4.85
  rect((shell-left, bottom), (shell-right, top), stroke: fine, fill: white)
  for y in (0.33, 4.77) {
    circle((axis, y), radius: (0.095, 0.035), stroke: fine, fill: none)
  }
  for (y, rx, ry) in (
    (0.94, 0.090, 0.095),
    (1.98, 0.090, 0.130),
    (3.15, 0.100, 0.130),
    (4.18, 0.090, 0.095),
  ) {
    circle((axis, y), radius: (rx, ry), stroke: fine, fill: white)
  }
  circle((axis, 0.94), radius: 0.018, fill: gray, stroke: none)

  // A–A 剖切指示：上、下两支实心箭头均向左。
  for (stem-a, stem-b, y, ty) in (
    ((axis, 4.25), (axis, 5.38), 5.25, 5.52),
    ((axis, -0.26), (axis, 0.72), -0.13, -0.43),
  ) {
    line(stem-a, stem-b, stroke: fine)
    line((1.77, y), (axis, y), stroke: fine)
    let tip = (axis, y)
    line(tip, (axis + 0.49, y + 0.085),
      (axis + 0.49, y - 0.085), tip,
      close: true, fill: ink, stroke: none)
    label((1.65, ty), [A])
  }

  // 纵剖中的入口半径引线与倾斜标签。
  arrow((1.62, 3.35), (0.86, 4.10), color: gray, scale: 0.55)
  label((1.44, 3.83), $R phi.alt$, angle: -44deg, color: gray)

  // 环形通道分区；每区由外圆弧和与内圆相切的两条边围成。
  let sectors = 8
  for k in range(sectors) {
    let start = k * 45deg
    let poly = ()
    for j in range(17) {
      poly.push(polar(start + j * 45deg / 16, outer))
    }
    for j in range(17) {
      poly.push(polar(start + tangent + (16 - j) * 45deg / 16, inner))
    }

    // 用直线与分区边界求交，生成严格限制在流道内的排线。
    let direction = start + 65deg
    let along = (calc.cos(direction), calc.sin(direction))
    let normal = (-along.at(1), along.at(0))
    for h in range(-23, 24) {
      let offset = h * 0.17
      let hits = ()
      for i in range(poly.len()) {
        let a = poly.at(i)
        let b = poly.at(calc.rem(i + 1, poly.len()))
        let da = dot(sub(a, center), normal) - offset
        let db = dot(sub(b, center), normal) - offset
        if (da <= 0 and db > 0) or (db <= 0 and da > 0) {
          hits.push(add(a, mul(sub(b, a), da / (da - db))))
        }
      }
      let ordered = hits.sorted(key: p => dot(sub(p, center), along))
      for i in range(0, ordered.len() - 1, step: 2) {
        line(ordered.at(i), ordered.at(i + 1),
          stroke: (paint: ink, thickness: 0.48pt))
      }
    }
  }

  // 外圆轮廓、八条切向分隔线与干净的中心空腔。
  circle(center, radius: outer, fill: none, stroke: fine)
  for k in range(sectors) {
    let a = k * 45deg
    line(polar(a, outer), polar(a + tangent, inner), stroke: fine)
  }
  circle(center, radius: inner, fill: white, stroke: fine)

  // 出口半径 Rx：中心十字及指向内壁的径向箭头。
  let exit-point = polar(153deg, inner)
  line(add(center, (-0.10, 0)), add(center, (0.10, 0)), stroke: fine)
  line(add(center, (0, -0.10)), add(center, (0, 0.10)), stroke: fine)
  arrow(add(center, (-0.08, 0.04)), exit-point, color: gray, scale: 0.55)
  label((5.36, 3.04), $R_x$, angle: -27deg, color: gray)

  // 入口半径 Rφ：下左侧双向尺寸线与两条竖直投影线。
  let dim-y = 1.08
  let left-witness = 4.17
  let right-witness = 4.53
  line((left-witness, 2.30), (left-witness, 0.82), stroke: fine)
  line((right-witness, 1.31), (right-witness, 0.82), stroke: fine)
  line((2.96, dim-y), (4.78, dim-y), stroke: dim)
  arrow((3.46, dim-y), (left-witness, dim-y), color: gray, scale: 0.55)
  arrow((4.78, dim-y), (right-witness, dim-y), color: gray, scale: 0.55)
  label((3.35, 1.30), $R phi.alt$, color: gray)
})
