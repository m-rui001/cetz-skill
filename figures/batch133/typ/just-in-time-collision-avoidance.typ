#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 编译外观：黑底左右两颗地球线稿，黄色轨道线带交叉 × 标记，右侧红色 JCA 机动箭头与 ΔL 夹角标注。
// 来源：Aerospace 2025, 12, 277, Figure 40（空间碎片碰撞规避总体概念示意）. DOI 10.3390/aerospace12040277.
#canvas({
  import draw: *

  // —— 配色 ——
  let ocean = rgb(20, 55, 108)
  let land = rgb(200, 184, 140)
  let yel = rgb(255, 222, 0)
  let red = rgb(228, 26, 26)

  // 黑色面板底
  rect((0, 0), (21.0, 8.6), fill: black, stroke: none)

  // 共享数据：单位坐标下的简化陆地轮廓（非洲 / 欧亚 / 南美）
  let landmasses = (
    ((0.05, 0.55), (0.3, 0.55), (0.45, 0.5), (0.5, 0.35), (0.55, 0.25), (0.5, 0.1), (0.4, 0.0),
      (0.3, -0.2), (0.22, -0.4), (0.15, -0.6), (0.0, -0.62), (-0.1, -0.4), (-0.12, -0.15),
      (-0.3, -0.05), (-0.38, 0.1), (-0.35, 0.3), (-0.32, 0.45), (-0.1, 0.55)),
    ((-0.55, 0.6), (-0.4, 0.78), (-0.15, 0.7), (0.0, 0.75), (0.2, 0.82), (0.45, 0.7), (0.65, 0.72),
      (0.85, 0.74), (0.95, 0.55), (0.9, 0.4), (0.85, 0.25), (0.6, 0.3), (0.5, 0.35),
      (0.45, 0.45), (0.2, 0.55), (-0.05, 0.55), (-0.3, 0.55), (-0.5, 0.5)),
    ((-0.95, 0.2), (-0.7, 0.15), (-0.55, 0.05), (-0.48, -0.15), (-0.42, -0.32), (-0.5, -0.45), (-0.62, -0.58),
      (-0.75, -0.62), (-0.85, -0.42), (-0.88, -0.3), (-0.94, -0.12), (-0.99, 0.1)),
  )

  // 共享数据：单位坐标下的两条轨道曲线（近竖直 / 近水平），交于 (0, 0.18)
  let orbits = (
    ((0.12, 1.02), (0.1, 0.7), (0.05, 0.45), (0.0, 0.18), (-0.05, -0.1), (-0.2, -0.5), (-0.42, -0.92)),
    ((-1.02, 0.02), (-0.6, 0.2), (-0.25, 0.26), (0.0, 0.18), (0.3, 0.1), (0.7, -0.1), (0.98, -0.4)),
  )

  // 共享数据：轨道端点的小横杠
  let ticks = (
    ((0.02, 1.04), (0.28, 0.96)),
    ((-0.56, -0.86), (-0.26, -1.02)),
    ((-1.0, 0.14), (-1.0, -0.1)),
    ((0.98, -0.28), (0.98, -0.52)),
  )

  // 绘制一个地球：海洋球体 + 简化陆地
  let globe(c, R) = {
    circle(c, radius: R, fill: ocean, stroke: rgb(8, 18, 38))
    for m in landmasses {
      line(..m.map(p => (c.at(0) + p.at(0) * R, c.at(1) + p.at(1) * R)),
        fill: land, stroke: none, close: true)
    }
  }

  // 绘制轨道、端点横杠与交叉 × 标记
  let track(c, R) = {
    for o in orbits {
      line(..o.map(p => (c.at(0) + p.at(0) * R, c.at(1) + p.at(1) * R)),
        stroke: (paint: yel, thickness: 1.1pt))
    }
    for t in ticks {
      line((c.at(0) + t.at(0).at(0) * R, c.at(1) + t.at(0).at(1) * R),
           (c.at(0) + t.at(1).at(0) * R, c.at(1) + t.at(1).at(1) * R),
        stroke: (paint: yel, thickness: 1.1pt))
    }
    let p = (c.at(0), c.at(1) + 0.18 * R)
    line((p.at(0) - 0.13 * R, p.at(1) + 0.13 * R), (p.at(0) + 0.13 * R, p.at(1) - 0.13 * R),
      stroke: (paint: yel, thickness: 1.5pt))
    line((p.at(0) - 0.13 * R, p.at(1) - 0.13 * R), (p.at(0) + 0.13 * R, p.at(1) + 0.13 * R),
      stroke: (paint: yel, thickness: 1.5pt))
  }

  // —— 地标坐标 ——
  let c1 = (5.3, 4.35)
  let c2 = (13.8, 4.35)
  let R = 3.4
  let ec = (c2.at(0) + 0.2 * R, c2.at(1) + 0.87 * R)
  let v2 = (c2.at(0) + 0.12 * R, c2.at(1) + 0.12 * R)

  // 左：原始接近态势
  globe(c1, R)
  track(c1, R)
  content((c1.at(0) - R - 0.2, c1.at(1) + 0.75), anchor: "east",
    text(fill: white, weight: "bold", size: 11pt)[Debris A])
  content((c1.at(0) - 0.7, c1.at(1) - R - 0.35), anchor: "center",
    text(fill: white, weight: "bold", size: 11pt)[Debris B])

  // 右：JCA 机动后错开 ΔL
  globe(c2, R)
  track(c2, R)
  content((c2.at(0) - R - 0.2, c2.at(1) + 0.75), anchor: "east",
    text(fill: white, weight: "bold", size: 11pt)[Debris A])
  content((c2.at(0) - 0.7, c2.at(1) - R - 0.35), anchor: "center",
    text(fill: white, weight: "bold", size: 11pt)[Debris B])

  // 红色机动点（若干圈前实施 JCA）
  circle(ec, radius: 0.42, fill: red, stroke: none)

  // 右侧红色说明文字
  content((18.05, 7.6), anchor: "west", text(fill: red, weight: "bold", size: 10.5pt)[
    JCA action \
    several orbits \
    before \
    potential \
    impact
  ])

  // 指向机动点的粗红箭头
  line((17.85, 7.33), (14.98, 7.31),
    stroke: (paint: red, thickness: 2.6pt), mark: (end: "stealth", fill: red, scale: 2))

  // ΔL 夹角：由交会点向左张开的双箭头
  line(v2, (c2.at(0) - 0.45 * R, c2.at(1) + 0.55 * R),
    stroke: (paint: red, thickness: 1.3pt), mark: (end: "stealth", fill: red, scale: 1.4))
  line(v2, (c2.at(0) - 0.36 * R, c2.at(1) - 0.28 * R),
    stroke: (paint: red, thickness: 1.3pt), mark: (end: "stealth", fill: red, scale: 1.4))
  content((v2.at(0) + 0.28, v2.at(1) - 0.15),
    [#text(fill: white, weight: "bold", size: 9pt)[ΔL]],
    frame: "rect", fill: black, stroke: none, padding: 1.5pt)
})
