#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 左侧为断电的平直 IPMC，右侧为通电后弯曲的 IPMC；蓝色膜内分布红色溶剂化阳离子。
// 来源：Actuators 2025, 14, 258, Figure 4，DOI: 10.3390/act14060258
#canvas({
  import draw: *
  let ink = rgb("#111111")
  let membrane = rgb("#ace5f7")
  let metal = rgb("#4b7183")
  let water = rgb("#176584")
  let ion-red = rgb("#df270b")
  let ion-light = rgb("#f15b14")
  let arrow-red = rgb("#ff0808")
  let wire = (paint: ink, thickness: 1.35pt)
  let label(p, s, anchor: "center", size: 11pt, color: ink) = {
    content(p, text(size: size, fill: color, weight: "bold", s),
      anchor: anchor, frame: none)
  }
  let segment(a, b) = { line(a, b, stroke: wire) }
  let arrow(a, b) = {
    line(a, b, stroke: (paint: arrow-red, thickness: 2pt),
      mark: (end: "stealth", scale: 0.8, fill: arrow-red))
  }
  let ion(p) = {
    for d in ((0, .29), (.29, 0), (0, -.29), (-.29, 0)) {
      circle((p.at(0) + d.at(0), p.at(1) + d.at(1)),
        radius: .092, fill: water, stroke: none)
    }
    circle(p, radius: .195, fill: ion-red, stroke: none)
    circle((p.at(0) - .045, p.at(1) + .035),
      radius: .115, fill: ion-light, stroke: none)
  }
  let left = (x: 1.3, right: 4.15, bottom: 2.3, top: 7.6)
  let right = (bottom: 1.8, top: 7.9)
  let edge(t) = 8.58 + .94 * calc.pow(2 * t - 1, 2)
  let height(t) = right.bottom + (right.top - right.bottom) * t
  let curve(offset) = {
    let points = ()
    for i in range(41) {
      let t = i / 40
      points.push((edge(t) + offset, height(t)))
    }
    points
  }
  let band(a, b, color) = {
    let points = curve(a)
    let back = curve(b)
    for i in range(41) { points.push(back.at(40 - i)) }
    line(..points, close: true, fill: color, stroke: none)
  }

  // 断电电路：电源、断开的开关和两端接线。
  line((left.x + .10, 7.12), (.7, 7.12), (.7, 8.12),
    (2.12, 8.12), stroke: wire)
  segment((2.12, 7.91), (2.12, 8.33))
  segment((2.37, 7.99), (2.37, 8.25))
  segment((2.37, 8.12), (3.23, 8.12))
  segment((3.23, 8.12), (3.82, 8.41))
  line((3.98, 8.12), (4.65, 8.12), (4.65, 7.12),
    (left.right - .1, 7.12), stroke: wire)
  label((1.93, 8.43), "−", size: 12pt)
  label((2.62, 8.43), "+", size: 12pt)
  label((4.1, 8.58), "off", size: 12pt)

  // 平直聚合物膜及其两侧金属电极。
  rect((left.x, left.bottom), (left.right, left.top),
    fill: membrane, stroke: none)
  for x in (left.x, left.right - .20) {
    rect((x, left.bottom), (x + .20, left.top),
      fill: metal, stroke: none)
  }

  // 断电状态的阳离子均匀分布。
  for x in (2.0, 3.52) {
    for y in (2.83, 3.89, 4.95, 6.01, 7.07) { ion((x, y)) }
  }

  // 通电电路：闭合连接、电源极性和红色状态标签。
  line((9.45, 7.48), (8.65, 7.48), (8.65, 8.4),
    (10.21, 8.4), stroke: wire)
  segment((10.21, 8.18), (10.21, 8.62))
  segment((10.43, 8.09), (10.43, 8.71))
  line((10.43, 8.4), (13.22, 8.4), (13.22, 7.48),
    (12.55, 7.48), stroke: wire)
  label((9.99, 8.68), "−", size: 12pt)
  label((10.67, 8.73), "+", size: 12pt)
  label((12.92, 8.73), "on", size: 12pt, color: arrow-red)

  // 弯曲膜和弧形电极由同一组命名边界派生。
  band(0, 3.28, membrane)
  band(0, .19, metal)
  band(3.09, 3.28, metal)

  // 两侧电极的负、正电荷沿弯曲轮廓排列。
  for i in range(12) {
    let t = .04 + i * .079
    label((edge(t) - .22, height(t)), "−", size: 10pt)
    label((edge(t) + 3.50, height(t)), "+", size: 10pt)
  }

  // 通电状态的溶剂化阳离子向负极一侧富集。
  for p in (
    (9.57, 6.96), (9.26, 6.08), (10.38, 6.22),
    (11.56, 6.81), (9.91, 5.32), (9.18, 5.08),
    (9.17, 4.13), (11.10, 4.62), (10.04, 3.74),
    (9.40, 3.08), (11.62, 2.83),
  ) { ion(p) }

  // 红色迁移箭头从离子附近向负极外侧延伸。
  arrow((9.87, 5.32), (7.87, 5.32))
  arrow((9.11, 4.13), (7.17, 4.13))
  arrow((11.56, 2.83), (9.64, 2.83))

  // 三条引线分别指向金属电极、溶剂化阳离子和膜本体。
  segment((4.05, 4.05), (4.72, 3.43))
  label((4.62, 3.10), "Metal electrode", anchor: "west", size: 11pt)
  segment((3.57, 2.85), (4.66, 1.84))
  label((4.69, 1.70), "Solvated cation", anchor: "west", size: 11pt)
  segment((2.52, 2.49), (4.53, .70))
  label((4.76, .78), "Polymer", anchor: "west", size: 11pt)
  label((4.76, .26), "membrane", anchor: "west", size: 11pt)
})
