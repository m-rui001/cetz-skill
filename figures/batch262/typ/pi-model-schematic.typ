#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 四个绿色广义 play 算子内含带方向箭头的平行四边形滞回环，蓝色权重汇入求和器，橙色并联支路接入。
// 来源：Actuators 2025, 14, 321，Figure 9，Schematic diagram of PI models. DOI: 10.3390/act14070321
#canvas({
  import draw: *

  // 共享配色、线型及标注助手。
  let ink = rgb("#111111")
  let wire = rgb("#484848")
  let green = rgb("#d5e7d0")
  let green-edge = rgb("#82b363")
  let blue = rgb("#d8e6fb")
  let blue-edge = rgb("#7193c2")
  let orange = rgb("#ffe7cb")
  let orange-edge = rgb("#d99c00")
  let thin = (paint: ink, thickness: 0.65pt)
  let circuit = (paint: wire, thickness: 1.05pt)
  let edge = (paint: ink, thickness: 1.05pt)
  let label(p, body, size: 10pt, anchor: "center") = {
    content(p, text(size: size, body), anchor: anchor, frame: none)
  }
  let arrow(a, b, color: wire, width: 1.05pt, scale: 0.65) = {
    line(a, b, stroke: (paint: color, thickness: width),
      mark: (end: "stealth", scale: scale, fill: color))
  }
  let flow(a, b) = {
    arrow(a, b, color: ink, width: 0.9pt, scale: 0.42)
  }
  let blend(a, b, t) = {
    (a.at(0) + t * (b.at(0) - a.at(0)),
     a.at(1) + t * (b.at(1) - a.at(1)))
  }
  let bus-y = 12.1
  let bottom = 6.0
  let top = 11.0
  let axis-y = 8.5
  let sum = (10.35, 2.35)
  let sum-r = 0.72
  let operators = (
    (2.35, 2.0, 0.0, $1$, $-r_1$, $r_1$),
    (7.35, 1.6, 0.34, $2$, $-r_2$, $r_2$),
    (13.30, 1.2, 0.68, $n-1$, $-r_(n-1)$, $r_(n-1)$),
    (18.30, 0.8, 1.02, $n$, $-r_n$, $r_n$),
  )

  // 输入总线及绕过所有算子的右侧并联支路。
  line((2.35, bus-y), (18.30, bus-y), stroke: circuit)
  arrow((10.35, 13.1), (10.35, bus-y))
  label((10.35, 13.50), $x(t)$, size: 15pt)
  line((18.30, bus-y), (21.25, bus-y), (21.25, 1.85),
    stroke: circuit)
  arrow((21.25, 1.85), (16.55, 1.85))
  arrow((15.0, 1.85), (10.87, 1.85))
  arrow((sum.at(0), sum.at(1) - sum-r), (10.35, 0.65))
  label((10.35, 0.22), $y(t)$, size: 15pt)

  // 四路连接线按各块边界终止，避免穿过文字。
  for item in operators {
    let x = item.at(0)
    arrow((x, bus-y), (x, top))
    arrow((x, bottom), (x, 5.2))
    let target = if x < 5 {
      (9.63, 2.35)
    } else if x < 10 {
      (9.83, 2.85)
    } else if x < 16 {
      (10.87, 2.85)
    } else {
      (11.07, 2.35)
    }
    arrow((x, 3.65), target)
  }

  // 绿色算子块：坐标轴、逐字标签、不同阈值的有向滞回环。
  for (x, h, inset, index, negative-r, positive-r) in operators {
    rect((x - 2.13, bottom), (x + 2.13, top),
      radius: 0.20, fill: green,
      stroke: (paint: green-edge, thickness: 1.1pt))
    arrow((x - 2.06, axis-y), (x + 1.98, axis-y),
      color: ink, width: 0.65pt, scale: 0.52)
    arrow((x, bottom + 0.15), (x, top - 0.15),
      color: ink, width: 0.65pt, scale: 0.52)
    label((x + 0.14, 10.80), $Gamma_#index [x](t)$,
      size: 9pt, anchor: "west")
    label((x - 0.14, 8.27), $0$, size: 9pt)

    let a = (x - 1.70, axis-y - h)
    let b = (x + inset, axis-y - h)
    let c = (x + 1.70, axis-y + h)
    let d = (x - inset, axis-y + h)
    line(a, b, c, d, a, stroke: edge)
    for (u, v) in ((a, b), (d, c)) {
      flow(blend(u, v, 0.42), blend(u, v, 0.23))
      flow(blend(u, v, 0.60), blend(u, v, 0.79))
    }
    flow(blend(a, d, 0.38), blend(a, d, 0.23))
    flow(blend(b, c, 0.69), blend(b, c, 0.85))

    // 阈值与横轴标签在白底衬上，避开回线斜边。
    let reach = (1.70 + inset) / 2 + 0.34
    let rp = (x + reach, 8.27)
    let rn = (x - reach, 8.27)
    rect((rn.at(0) - 0.27, 8.08), (rn.at(0) + 0.24, 8.42),
      fill: green, stroke: none)
    rect((rp.at(0) - 0.22, 8.08), (rp.at(0) + 0.32, 8.42),
      fill: green, stroke: none)
    label(rp, positive-r, size: 8.5pt)
    label(rn, negative-r, size: 8.5pt)
    rect((x + 1.66, 8.54), (x + 2.10, 8.82), fill: green, stroke: none)
    label((x + 1.89, 8.68), $x(t)$, size: 9pt)

    let memory-y = 8.9
    let right-x = x + inset + (1.70 - inset) * (h + 0.4) / (2 * h)
    line((x, memory-y), (right-x, memory-y), stroke: edge)
    flow((x + 0.48, memory-y), (x + 0.14, memory-y))
    flow((x + 0.54, memory-y), (x + 0.88, memory-y))
    circle((x, memory-y), radius: 0.043, fill: ink, stroke: none)
    label((x - 0.13, memory-y + 0.02), $M_0$,
      size: 9pt, anchor: "east")

    // 蓝色倒三角为对应支路的权重系数。
    line((x - 0.78, 5.2), (x + 0.78, 5.2), (x, 3.65),
      close: true, fill: blue,
      stroke: (paint: blue-edge, thickness: 1.05pt))
    label((x, 4.83), text(fill: rgb("#496388"), $p_#index$),
      size: 13pt)
  }

  // 两行省略号说明中间算子与权重支路按同样方式延续。
  label((10.30, 8.17), $dots.h$, size: 25pt)
  label((10.30, 4.59), $dots.h$, size: 25pt)

  // 橙色并联映射及浅灰色求和节点。
  rect((15.0, 1.35), (16.55, 2.35), radius: 0.16,
    fill: orange, stroke: (paint: orange-edge, thickness: 1.1pt))
  label((15.775, 1.85), $G[bullet]$, size: 18pt)
  circle(sum, radius: sum-r, fill: rgb("#f5f5f5"),
    stroke: (paint: rgb("#686868"), thickness: 1.1pt))
  label(sum, text(size: 30pt, "Σ"))
})
