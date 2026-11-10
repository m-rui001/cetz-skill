#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 雷达测量几何图：中心黑色抛物面天线立于南北/东西十字轴上，点线椭圆为地面覆盖区，
// 红色视线射向左上卫星；红弧标注仰角 θ，紫弧标注方位角 φ，四个方位词加卫星名。
// 来源：Aerospace 2025, 12, 277, Figure 8 — radar azimuth angle (φ) and elevation angle (θ). DOI 10.3390/aerospace12040277.

#canvas({
  import draw: *

  let green = rgb("#3E7C33")
  let red = rgb("#D5231E")
  let purple = rgb("#6B2E8F")
  let navy = rgb("#1B3B5F")
  let ink = rgb("#111111")
  let thin = (paint: ink, thickness: 0.9pt)

  // 地标：椭圆与天线共用的中心 C、抛物面心、馈源点、卫星位置
  let C = (3.64, 2.32)
  let dish-c = (3.40, 2.66)
  let feed = (3.17, 2.88)
  let sat = (1.80, 4.30)

  // 助手：绕 o 点旋转 a 角
  let rot(p, a, o) = {
    let (x, y) = p
    let (ox, oy) = o
    (ox + (x - ox) * calc.cos(a) - (y - oy) * calc.sin(a),
     oy + (x - ox) * calc.sin(a) + (y - oy) * calc.cos(a))
  }
  // 助手：绕中心旋转的实心斜置椭圆（抛物面）
  let disc(p, rx, ry, a, n: 28, c: ink) = line(
    ..range(n).map(i => {
      let t = 2 * calc.pi * i / n
      rot((p.at(0) + rx * calc.cos(t), p.at(1) + ry * calc.sin(t)), a, p)
    }),
    fill: c, stroke: none, close: true,
  )
  // 助手：绕中心旋转的实心小矩形（卫星本体与太阳翼）
  let bar(p, w, h, a) = line(
    ..((p.at(0) - w / 2, p.at(1) - h / 2), (p.at(0) + w / 2, p.at(1) - h / 2),
      (p.at(0) + w / 2, p.at(1) + h / 2), (p.at(0) - w / 2, p.at(1) + h / 2)).map(q => rot(q, a, p)),
    fill: ink, stroke: none, close: true,
  )
  // 助手：粗体标签（fill 置白可遮住穿过的线）
  let lab(p, t, size: 10.5pt, c: ink, fill: none, anchor: "center") = content(
    p, text(size: size, weight: "bold", fill: c, t), fill: fill, padding: 0.05, anchor: anchor,
  )

  // 南北轴（带右向箭头）与地面覆盖椭圆
  line((0.28, C.at(1)), (6.92, C.at(1)), stroke: green + 1pt, mark: (end: "stealth", scale: 2))
  circle(C, radius: (2.98, 0.70), stroke: (paint: navy, thickness: 2pt, dash: "dotted"))
  // 东西向斜轴
  line((2.25, 0.65), (5.25, 3.65), stroke: green + 1pt)

  // 视线在地面的投影（点线）
  line(C, (2.22, 1.46), stroke: (paint: red, thickness: 1pt, dash: "dotted"))
  // 仰角 θ：由投影线绕左侧至视线，箭头收在顶端
  arc-through((2.92, 1.80), (2.34, 2.44), (2.94, 3.12),
    stroke: (paint: red, thickness: 2.2pt), mark: (end: "stealth"))
  // 方位角 φ：自斜轴扫至投影线，箭头收在左下
  bezier-through((4.70, 2.16), (3.52, 1.16), (2.50, 1.40),
    stroke: (paint: purple, thickness: 2.2pt), mark: (end: "stealth"))

  // 视线箭头指向卫星（先画，随后由天线本体压住线尾）
  line(feed, (1.88, 4.22), stroke: (paint: red, thickness: 2.2pt), mark: (end: "stealth"))
  // 天线：馈源支杆、抛物面（黑新月＝黑椭圆减白椭圆）、基座三角、馈源红点
  line((3.36, 2.74), feed, stroke: thin)
  disc(dish-c, 0.44, 0.145, 40deg)
  disc((dish-c.at(0) - 0.055, dish-c.at(1) + 0.065), 0.30, 0.052, 40deg, c: white)
  line((3.42, 2.30), (3.80, 2.30), (3.60, 2.56), fill: ink, stroke: none, close: true)
  circle(feed, radius: 0.035, fill: red, stroke: none)

  // 卫星：本体 + 两侧太阳翼 + 天线杆
  bar(sat, 0.17, 0.115, -35deg)
  bar(rot((sat.at(0) - 0.16, sat.at(1)), -35deg, sat), 0.13, 0.085, -35deg)
  bar(rot((sat.at(0) + 0.16, sat.at(1)), -35deg, sat), 0.13, 0.085, -35deg)
  line(sat, rot((sat.at(0) + 0.05, sat.at(1) + 0.16), -35deg, sat), stroke: thin)

  // 文字：方位词、雷达、卫星，角度符号用斜体
  lab((0.72, 2.32), [SOUTH])
  lab((6.16, 2.32), [NORTH])
  lab((4.88, 3.80), [WEST])
  lab((2.30, 0.38), [EAST])
  lab((3.95, 2.50), [RADAR], anchor: "west")
  lab((2.04, 4.34), [SATELLITE], anchor: "west")
  content((2.02, 2.46), text(size: 15pt, weight: "bold", style: "italic", fill: red)[θ])
  content((3.94, 0.94), text(size: 15pt, weight: "bold", style: "italic", fill: purple)[φ])
})
