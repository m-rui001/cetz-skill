#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 重绘效果：右上 GNSS 卫星（白筒身＋两翼深蓝太阳板）向左侧 GNSS-RO CubeSat 发出三条绿色信号线，
// 信号掠过大米黄电离层圆内的淡紫大气层边缘后弯折下行；中央为蓝海绿陆地球，五个英文标签齐全。
// 来源：Aerospace 2025, 12, 550, Figure 7 "GNSS-RO concept"（DOI: 10.3390/aerospace12060550）

#canvas({
  import draw: *
  // 配色
  let cream = rgb("#f9e0b6")
  let air = rgb("#c9cbef")
  let sea = rgb("#3b63b4")
  let land = rgb("#23a54c")
  let sig = rgb("#1e9e48")
  let navy = rgb("#1f3864")
  let ink = rgb("#2b2b2b")
  let cx = 7.3
  let cy = 3.95
  // 助手：线性插值、四边形内参数取点（u 沿底边，v 向上）
  let lerp(a, b, t) = (a.at(0) + (b.at(0) - a.at(0)) * t, a.at(1) + (b.at(1) - a.at(1)) * t)
  let qp(q, u, v) = lerp(lerp(q.at(0), q.at(1), u), lerp(q.at(3), q.at(2), u), v)
  // 地球经纬换算：以球心为原点、半径为单位的相对坐标
  let g(u, v) = (cx + u * 1.85, cy + v * 1.85)

  // 电离层：最外层米黄大圆
  circle((cx, cy), radius: 3.35, fill: cream, stroke: none)
  // 大气层：淡紫内圈
  circle((cx, cy), radius: 2.45, fill: air, stroke: none)
  // 地球：海洋底色圆
  circle((cx, cy), radius: 1.85, fill: sea, stroke: ink + 0.6pt)

  // 陆地：欧洲、亚洲、非洲、阿拉伯、马达加斯加、南美一角
  let shapes = (
    ((-0.36, 0.40), (-0.26, 0.50), (-0.14, 0.46), (-0.02, 0.52), (0.12, 0.46), (0.26, 0.50),
     (0.40, 0.44), (0.54, 0.48), (0.68, 0.42), (0.80, 0.44), (0.88, 0.32), (0.86, 0.20),
     (0.74, 0.24), (0.62, 0.18), (0.50, 0.26), (0.40, 0.20), (0.32, 0.30), (0.22, 0.34),
     (0.10, 0.30), (0.00, 0.36), (-0.12, 0.32), (-0.24, 0.34)),
    ((-0.18, 0.26), (-0.04, 0.30), (0.10, 0.24), (0.20, 0.16), (0.28, 0.08), (0.32, -0.02),
     (0.24, -0.08), (0.18, -0.20), (0.20, -0.34), (0.12, -0.48), (0.04, -0.56), (-0.04, -0.46),
     (-0.08, -0.30), (-0.16, -0.22), (-0.26, -0.24), (-0.32, -0.12), (-0.34, 0.02), (-0.28, 0.16)),
    ((0.26, 0.02), (0.38, 0.08), (0.44, -0.02), (0.36, -0.08), (0.28, -0.04)),
    ((0.26, -0.34), (0.31, -0.38), (0.28, -0.48), (0.24, -0.40)),
    ((-0.60, -0.50), (-0.40, -0.55), (-0.30, -0.68), (-0.38, -0.82), (-0.55, -0.80), (-0.66, -0.66)),
  )
  for s in shapes {
    line(..s.map(p => g(p.at(0), p.at(1))), close: true, fill: land, stroke: ink + 0.4pt)
  }

  // 信号：自卫星水平向左、过大气层边缘后弯折指向 CubeSat
  for i in (0, 1, 2) {
    let d = (0.06 * i, -0.26 * i)
    let p0 = (12.30 + d.at(0), 6.45 + d.at(1))
    let pb = (8.05 + d.at(0), 6.45 + d.at(1))
    let p1 = (3.58 + d.at(0), 4.18 + d.at(1))
    line(p0, pb, stroke: sig + 1.4pt, mark: (end: "stealth"))
    bezier(pb, p1, (pb.at(0) - 1.7, pb.at(1)), (p1.at(0) + 1.7, p1.at(1) + 1.55),
      stroke: sig + 1.4pt, mark: (end: "stealth"))
  }

  // GNSS 卫星：筒身、喇叭口、灰色接头与两片太阳翼
  line((12.55, 6.02), (13.12, 6.16), (13.12, 6.66), (12.55, 6.52), close: true,
    fill: rgb("#f4f4f4"), stroke: ink + 0.6pt)
  circle((12.45, 6.10), radius: 0.17, fill: white, stroke: ink + 0.6pt)
  circle((12.45, 6.10), radius: 0.06, fill: none, stroke: ink + 0.5pt)
  line((13.12, 6.16), (13.30, 6.20), (13.30, 6.62), (13.12, 6.66), close: true,
    fill: rgb("#b9b9b9"), stroke: ink + 0.5pt)
  // 太阳翼：沿 -32° 轴铺开的三段电池板（手工旋转坐标，避免变换状态）
  let wing(c, l, w) = {
    let ax = (0.848, -0.530)
    let nx = (0.530, 0.848)
    let pt(s, t) = (c.at(0) + ax.at(0) * l * s + nx.at(0) * w * t,
                    c.at(1) + ax.at(1) * l * s + nx.at(1) * w * t)
    line(pt(-0.5, -0.5), pt(0.5, -0.5), pt(0.5, 0.5), pt(-0.5, 0.5), close: true,
      fill: navy, stroke: ink + 0.5pt)
    for k in (-0.25, 0, 0.25) {
      line(pt(k, -0.5), pt(k, 0.5), stroke: ink + 0.4pt)
    }
  }
  wing((12.00, 6.95), 1.05, 0.44)
  wing((13.95, 6.32), 1.15, 0.46)
  line((12.62, 6.58), (12.44, 6.72), stroke: ink + 0.5pt)
  line((13.16, 6.36), (13.44, 6.24), stroke: ink + 0.5pt)

  // GNSS-RO CubeSat：正面、侧面、顶面三块板
  let fF = ((1.95, 2.35), (2.80, 2.49), (2.80, 4.72), (1.95, 4.58))
  let fS = ((2.80, 2.49), (3.22, 2.34), (3.22, 4.56), (2.80, 4.72))
  let fT = ((1.95, 4.58), (2.80, 4.72), (3.22, 4.56), (2.37, 4.42))
  line(..fF, close: true, fill: rgb("#e9e9e9"), stroke: ink + 0.6pt)
  line(..fS, close: true, fill: rgb("#dccba6"), stroke: ink + 0.6pt)
  line(..fT, close: true, fill: rgb("#cfcfcf"), stroke: ink + 0.6pt)
  // 正面电池片：2 列 × 3 行
  for c in (0.08, 0.54) {
    for r in (0.06, 0.37, 0.68) {
      let cell = ((c, r), (c + 0.38, r), (c + 0.38, r + 0.27), (c, r + 0.27))
      line(..cell.map(p => qp(fF, p.at(0), p.at(1))), close: true,
        fill: navy, stroke: ink + 0.3pt)
    }
  }
  // 侧面金色电池片：3 段
  for r in (0.06, 0.37, 0.68) {
    let cell = ((0.12, r), (0.88, r), (0.88, r + 0.27), (0.12, r + 0.27))
    line(..cell.map(p => qp(fS, p.at(0), p.at(1))), close: true,
      fill: rgb("#c9a961"), stroke: ink + 0.3pt)
  }
  // 顶面细部与细长天线
  line(qp(fT, 0.25, 0.35), qp(fT, 0.72, 0.35), stroke: ink + 0.4pt)
  line((1.98, 4.56), (1.28, 5.48), stroke: ink + 0.4pt)
  line((2.10, 4.60), (1.62, 5.30), stroke: ink + 0.4pt)
  line((2.50, 4.40), (2.06, 5.10), stroke: ink + 0.4pt)

  // 文字标签（最后绘制，确保不被遮挡）
  content((0.35, 5.32), [GNSS-RO CubeSat], anchor: "west")
  content((12.55, 7.12), [GNSS Satellite], anchor: "west")
  content((10.45, 6.62), [GNSS Signal], anchor: "south")
  content((cx, 1.80), [Atmosphere])
  content((cx, 1.12), [Ionosphere])
})
