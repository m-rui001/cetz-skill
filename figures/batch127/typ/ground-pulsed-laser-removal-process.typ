#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 地基脉冲激光清除空间碎片流程示意（重绘自 Aerospace 2025, 12, 277, Fig.14. DOI 10.3390/aerospace12040277.）：地球、虚线轨道、降轨碎片点列、碎片变化网、再入烧毁爆点与地面激光站
#canvas({
  import draw: *

  // 画布边界
  rect((0, 0), (16, 9.4), stroke: none)

  // 放射星形（再入烧毁爆点），闭合折线填充
  let burst(c, ro, ri, col) = {
    let pts = ()
    for i in range(16) {
      let a = 22.5deg + i * 22.5deg
      let r = if calc.odd(i) { ri } else { ro }
      pts.push((c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a)))
    }
    line(..pts, close: true, fill: col, stroke: none)
  }

  // 命名地标坐标
  let earth-c = (5.19, 3.97)
  let r-earth = 1.16
  let r-atmo = 1.98
  let r-orbit = 3.36

  // 大气环与地球
  circle(earth-c, radius: r-atmo, fill: rgb("#1e56d6"), stroke: none)
  circle(earth-c, radius: r-earth, fill: rgb("#4fc3bb"), stroke: none)
  content(earth-c, text(size: 9pt)[Earth], anchor: "center")

  // 激光瞄准区（红框）
  rect((4.95, 4.55), (5.45, 4.88), stroke: (paint: red, thickness: 1pt))

  // 虚线轨道（整圆）
  circle(earth-c, radius: r-orbit, stroke: (paint: black, thickness: 0.8pt, dash: "dashed"))

  // 碎片运动方向（红色顺时针弧箭头，沿轨道）
  let dirarc(a0, a1) = {
    let pts = ()
    for i in range(10) {
      let a = a0 + (a1 - a0) * i / 9
      pts.push((earth-c.at(0) + r-orbit * calc.cos(a), earth-c.at(1) + r-orbit * calc.sin(a)))
    }
    line(..pts, stroke: (paint: red, thickness: 1.2pt), mark: (end: "stealth", fill: red, scale: 0.6))
  }
  dirarc(135deg, 90deg)
  dirarc(48deg, 18deg)

  // 初始碎片位置
  circle((5.44, 7.32), radius: 0.12, fill: rgb("#c8c8c8"),
         stroke: (paint: rgb("#666666"), thickness: 0.7pt))

  // 降轨轨迹折线
  let deorbit = ((5.44, 7.32), (6.10, 6.96), (6.70, 6.60), (7.25, 6.22), (7.62, 5.73),
                 (7.79, 4.97), (7.67, 4.30), (7.50, 3.63), (6.83, 3.13))
  line(..deorbit, stroke: (paint: rgb("#777777"), thickness: 0.8pt))

  // 降轨过程中的碎片点
  for p in ((7.62, 5.73), (7.79, 4.97), (7.67, 4.30), (7.50, 3.63)) {
    circle(p, radius: 0.11, fill: rgb("#c8c8c8"),
           stroke: (paint: rgb("#666666"), thickness: 0.7pt))
  }

  // 再入烧毁双层爆点
  burst((6.83, 3.13), 0.30, 0.10, red)
  burst((6.83, 3.13), 0.17, 0.06, rgb("#ffdd00"))

  // 碎片变化网（压缩圆作细长斜椭圆）
  group({
    translate((6.28, 6.56))
    rotate(-59deg)
    scale(x: 1, y: 0.23)
    circle((0, 0), radius: 0.74, fill: rgb(120, 200, 230, 60%),
           stroke: (paint: black, thickness: 0.9pt))
  })

  // 瞄准点到初始碎片的竖直箭头
  line((5.32, 4.95), (5.44, 7.10), stroke: (paint: black, thickness: 1pt),
       mark: (end: "stealth", scale: 0.7))

  // 地面激光站（照片转干净线稿）
  rect((11.64, 3.89), (14.74, 6.78), fill: rgb("#f2f2f0"),
       stroke: (paint: black, thickness: 0.8pt))
  line((11.64, 4.36), (14.74, 4.36), stroke: (paint: rgb("#999999"), thickness: 0.6pt))
  // 望远镜穹顶（半圆多边形）
  let dome = ()
  for i in range(19) {
    let a = i * 10deg
    dome.push((12.85 + 0.42 * calc.cos(a), 4.36 + 0.30 * calc.sin(a)))
  }
  line(..dome, close: true, fill: rgb("#dddddd"), stroke: (paint: black, thickness: 0.8pt))
  // 穹顶开缝与支架
  line((12.85, 4.36), (12.85, 4.66), stroke: (paint: black, thickness: 0.6pt))
  line((12.43, 4.36), (12.43, 4.10), stroke: (paint: black, thickness: 0.8pt))
  line((13.27, 4.36), (13.27, 4.10), stroke: (paint: black, thickness: 0.8pt))
  // 激光束（绿红绿三道）
  line((12.85, 4.66), (14.10, 6.55), stroke: (paint: rgb("#22a04a"), thickness: 1.2pt))
  line((12.85, 4.66), (13.85, 6.62), stroke: (paint: rgb("#d02b2b"), thickness: 0.9pt))
  line((12.85, 4.66), (13.60, 6.68), stroke: (paint: rgb("#22a04a"), thickness: 0.9pt))
  // 天线立柱
  line((13.75, 4.36), (13.75, 6.10), stroke: (paint: rgb("#888888"), thickness: 0.6pt))
  line((14.20, 4.36), (14.20, 6.30), stroke: (paint: rgb("#888888"), thickness: 0.6pt))

  // 激光照射路径（红虚线指向瞄准区）
  line((11.64, 5.95), (5.48, 4.85), stroke: (paint: red, thickness: 0.9pt, dash: "dashed"),
       mark: (end: "stealth", fill: red, scale: 0.6))
  line((11.64, 4.55), (5.48, 4.62), stroke: (paint: red, thickness: 0.9pt, dash: "dashed"),
       mark: (end: "stealth", fill: red, scale: 0.6))

  // 标签：Debris
  content((2.9, 8.5), text(weight: "bold", size: 12pt)[Debris], anchor: "center")
  line((3.7, 8.35), (5.34, 7.44), stroke: (paint: black, thickness: 1.2pt),
       mark: (end: "stealth", scale: 0.8))

  // 标签：Debris change net
  content((7.2, 8.2), text(weight: "bold", size: 12pt)[Debris change net], anchor: "center")
  line((6.95, 7.95), (6.55, 7.06), stroke: (paint: black, thickness: 1.2pt),
       mark: (end: "stealth", scale: 0.8))

  // 标签：Decelerate by electric force
  content((12.2, 7.55), text(weight: "bold", size: 12pt)[Decelerate by \ electric force],
          anchor: "center")
  line((10.2, 7.2), (7.80, 5.95), stroke: (paint: black, thickness: 1.2pt),
       mark: (end: "stealth", scale: 0.8))

  // 标签：Altitude, 1000km
  content((2.3, 6.35), text(weight: "bold", size: 12pt)[Altitude, 1000km], anchor: "center")

  // 标签：Burn up in the atmosphere
  content((9.6, 2.7), text(weight: "bold", size: 12pt)[Burn up in \ the atmosphere],
          anchor: "center")
  line((7.85, 2.95), (7.02, 3.10), stroke: (paint: black, thickness: 1.2pt),
       mark: (end: "stealth", scale: 0.8))

  // 标签：Ground-based laser
  content((13.19, 3.45), text(weight: "bold", size: 12pt)[Ground-based laser],
          anchor: "center")
})
