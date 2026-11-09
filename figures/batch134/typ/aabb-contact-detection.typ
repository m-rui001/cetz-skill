#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 重绘：Mechanics of Space Debris Removal 图44 轴对齐包围盒两级接触检测
// 来源：Aerospace 2025, 12, 277, Figure 44. DOI 10.3390/aerospace12040277.
// 干净线稿平涂：蓝色网格 + 红色节点 + 黑框 + 间距 d
#canvas({
  import draw: *

  // 三次贝塞尔取 y 值
  let bez(P, t) = {
    let m = 1 - t
    let y0 = P.at(0).at(1)
    let y1 = P.at(1).at(1)
    let y2 = P.at(2).at(1)
    let y3 = P.at(3).at(1)
    m * m * m * y0 + 3 * m * m * t * y1 + 3 * m * t * t * y2 + t * t * t * y3
  }

  // 网片上/下边界控制点（相对网箱左下角）
  let TOP = ((0.25, 4.55), (2.6, 5.55), (4.7, 6.30), (6.45, 6.50))
  let BOT = ((0.25, 2.35), (2.6, 1.35), (4.7, 0.40), (6.45, 0.05))

  // 网片参数化：u 沿流向，v 跨向
  let netpt(dx, u, v) = {
    let yt = bez(TOP, u)
    let yb = bez(BOT, u)
    (dx + 0.25 + u * 6.2, yb + v * (yt - yb))
  }

  let net-blue = rgb("#1c2ecc")
  let net-red = rgb("#d81420")
  let us = range(13).map(i => i / 12)
  let allv = (0, 0.2, 0.4, 0.6, 0.8, 1)

  // 绘制一个网箱：外框 + 纵横网格线 + 红色节点
  let net-box(dx) = {
    rect((dx, 0), (dx + 6.5, 6.5), stroke: 0.6pt)
    for u in us {
      line(..range(11).map(k => netpt(dx, u, k / 10)), stroke: net-blue + 0.5pt)
    }
    for v in (0.2, 0.4, 0.6, 0.8) {
      line(..range(49).map(k => netpt(dx, k / 48, v)), stroke: net-blue + 0.5pt)
    }
    for u in us {
      for v in allv {
        circle(netpt(dx, u, v), radius: 0.05, fill: net-red, stroke: none)
      }
    }
  }

  // ---- (a) 网箱与目标箱分离：第一层检测 ----
  net-box(0)
  content((1.45, 0.85), [Net Box \ $N$], anchor: "center")
  rect((9.2, 2.2), (11.4, 4.3), stroke: 0.6pt)
  content((10.3, 3.25), [Target Box \ $T$], anchor: "center")
  line((7.0, 3.25), (9.0, 3.25), stroke: 1.1pt, mark: (end: "stealth"))

  // ---- (b) 两箱相交：第二层检测 ----
  let dx = 12.4
  net-box(dx)
  content((dx + 1.45, 0.85), [Net Box \ $N$], anchor: "center")
  // 目标箱跨过网箱右边界（白底遮住网格）
  rect((dx + 5.5, 2.6), (dx + 7.7, 4.4), fill: white, stroke: 0.6pt)
  content((dx + 6.6, 3.5), [Target Box \ $T$], anchor: "center")
  // 网面与目标箱的最近间距 d（双向箭头）
  line((dx + 4.95, 5.35), (dx + 5.55, 4.45), stroke: 0.7pt,
    mark: (start: "stealth", end: "stealth"))
  content((dx + 4.75, 4.95), [$d$], anchor: "center")

  // 子图标题
  content((3.25, -0.55), [(a) Net approaching the target (First level detection)], anchor: "north")
  content((dx + 3.25, -0.55), [(b) Two boxes intersect (Second level detection)], anchor: "north")

  // 不可见边界框，固定画布尺寸
  rect((-0.4, -1.35), (dx + 8.2, 6.9), stroke: (paint: white, thickness: 0.01pt))
})
