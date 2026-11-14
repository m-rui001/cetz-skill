#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 变刚度连续体机器人杠杆锁紧机构（Actuators 2024, 13(2), 52, Fig.10；DOI 10.3390/act13020052）
// 左：整机三维示意；中部：约束盘与驱动杆放大；右侧：解锁/锁紧原理简图
#canvas({
  import draw: *
  let orc = rgb("#f2a03d")
  let orc2 = rgb("#dd8f3c")
  let orl = rgb("#9c5a12")
  let gy = rgb("#a9a9a9")
  let gd = rgb("#6f6f6f")
  let bl = rgb("#4a86d8")
  let rd = rgb("#e02020")
  let gr = rgb("#d9f0d9")
  let gr2 = rgb("#bfe3bf")
  let lb = rgb("#dbe7f8")
  let lb2 = rgb("#c3d7f2")
  let gl = (paint: gd, thickness: 0.7pt)
  let ol = (paint: orl, thickness: 0.7pt)
  let lb9(t) = text(size: 9pt, t)

  // 椭圆用多边形折线近似
  let elps(cx, cy, rx, ry, fill: none, stroke: black, n: 36) = {
    let pts = range(n).map(i => {
      let a = 360deg * i / n
      (cx + rx * calc.cos(a), cy + ry * calc.sin(a))
    })
    line(..pts, close: true, fill: fill, stroke: stroke)
  }
  // 蛇形折线：弹簧 / 导线
  let zz(x, y0, y1, w: 0.15, n: 8, col: bl, thk: 1.1pt) = {
    let dy = (y1 - y0) / n
    let pts = range(n + 1).map(i => (
      x + (if i == 0 or i == n { 0 } else if calc.odd(i) { w } else { -w }),
      y0 + i * dy))
    line(..pts, stroke: (paint: col, thickness: thk))
  }
  // 带箭头的线段
  let arw(p1, p2, col: rd, thk: 1.4pt, both: false) = line(
    p1, p2,
    stroke: (paint: col, thickness: thk),
    mark: if both { (start: "stealth", end: "stealth") } else { (end: "stealth") })
  // 圆盘件：侧壁 + 底面 + 顶面
  let disk(cx, cy, rx, ry, th) = {
    rect((cx - rx, cy), (cx + rx, cy + th), fill: orc2, stroke: ol)
    elps(cx, cy, rx, ry, fill: orc2, stroke: ol)
    elps(cx, cy + th, rx, ry, fill: orc, stroke: ol)
  }
  // 圆弧离散点
  let arcp(cx, cy, r, a0, a1, n) = range(n + 1).map(i => {
    let a = (a0 + (a1 - a0) * i / n) * 1deg
    (cx + r * calc.cos(a), cy + r * calc.sin(a))
  })

  // 左侧：整机结构
  rect((0.2, 1.4), (11.4, 12.2), fill: rgb("#eeeeee"), stroke: none)
  for x in (2.6, 3.9, 7.3, 8.6) {
    line((x, 3.4), (x, 11.9), stroke: (paint: gy, thickness: 2.6pt))
  }
  line((5.6, 3.0), (5.6, 12.0), stroke: (paint: rgb("#3a3a3a"), thickness: 2.4pt))
  for x in (2.6, 3.9, 7.3, 8.6) { zz(x, 4.6, 8.9, n: 10) }
  disk(5.6, 4.3, 3.6, 0.9, 0.45)
  disk(5.6, 9.3, 3.6, 0.9, 0.45)
  // 盘面锁紧块
  for cy in (4.3, 9.3) {
    for a in (15, 105, 195, 285) {
      let px = 5.6 + 2.9 * calc.cos(a * 1deg)
      let py = cy + 0.45 + 0.72 * calc.sin(a * 1deg)
      rect((px - 0.15, py - 0.17), (px + 0.15, py + 0.17), fill: rd, stroke: none)
    }
  }
  // 电流回路与电池
  line((2.2, 9.55), (0.85, 9.55), (0.85, 7.3), stroke: (paint: black, thickness: 1pt))
  line((0.85, 6.3), (0.85, 4.7), (2.2, 4.7), stroke: (paint: black, thickness: 1pt))
  line((0.5, 7.3), (1.2, 7.3), stroke: (paint: rd, thickness: 1.6pt))
  line((0.58, 6.85), (1.12, 6.85), stroke: (paint: rd, thickness: 1.6pt))
  line((0.66, 6.3), (1.04, 6.3), stroke: (paint: rd, thickness: 1.6pt))
  arw((1.6, 4.9), (1.6, 8.4), both: true)
  content((0.45, 8.9), lb9[$I$], anchor: "east")
  content((1.78, 6.55), lb9[$F_t$], anchor: "west")
  // 局部放大指示
  elps(8.3, 9.5, 1.05, 0.85, fill: none,
    stroke: (paint: rgb("#1a9b5c"), thickness: 1.3pt, dash: "dashed"))
  arw((9.45, 9.5), (13.0, 9.5), col: rgb("#1a9b5c"), thk: 2pt)
  elps(5.6, 4.3, 3.1, 0.85, fill: none,
    stroke: (paint: bl, thickness: 1.3pt, dash: "dashed"))
  arw((8.85, 4.3), (13.0, 4.3), col: bl, thk: 2pt)
  // 左上与下方标注
  line((2.4, 12.5), (2.9, 10.3), stroke: (paint: black, thickness: 0.6pt))
  content((2.3, 12.6), lb9[Locking lever], anchor: "east")
  line((9.4, 12.5), (8.3, 10.2), stroke: (paint: black, thickness: 0.6pt))
  content((9.5, 12.6), lb9[Constraint disk], anchor: "west")
  line((2.9, 0.9), (3.1, 4.2), stroke: (paint: black, thickness: 0.6pt))
  content((2.8, 0.7), lb9[SMA], anchor: "east")

  // 中上：约束盘侧视放大
  rect((13.0, 6.4), (18.4, 12.2), fill: white,
    stroke: (paint: rgb("#3f9e6b"), thickness: 1pt))
  for x in (14.7, 16.9) {
    line((x, 7.8), (x, 12.0), stroke: (paint: gy, thickness: 2.4pt))
  }
  rect((14.2, 8.5), (17.4, 9.8), fill: orc, stroke: ol)
  rect((14.9, 9.7), (16.7, 10.0), fill: gy, stroke: gl)
  circle((15.7, 10.7), radius: 0.19, fill: rd, stroke: none)
  bezier((14.3, 8.4), (14.8, 6.9), (16.3, 7.3), (16.7, 8.3),
    stroke: (paint: bl, thickness: 1.6pt))
  rect((16.7, 9.1), (17.4, 9.7), fill: rgb("#f6c445"), stroke: gl)
  line((15.9, 10.8), (17.4, 11.6), stroke: (paint: black, thickness: 0.6pt))
  content((17.5, 11.6), lb9[Electrode], anchor: "west")
  line((15.9, 7.4), (14.9, 6.85), stroke: (paint: black, thickness: 0.6pt))
  content((14.7, 6.85), lb9[Thread], anchor: "east")

  // 中下：驱动杆与杠杆放大
  rect((13.0, 1.4), (18.4, 6.0), fill: white,
    stroke: (paint: bl, thickness: 1pt))
  let outr = arcp(12.4, 3.6, 4.7, -28, 28, 12)
  let inr = arcp(12.4, 3.6, 3.85, 28, -28, 12)
  line(..outr, ..inr, close: true, fill: gy, stroke: gl)
  rect((13.5, 3.5), (15.9, 4.65), fill: orc, stroke: ol)
  rect((15.3, 3.1), (16.2, 4.9), fill: orc2, stroke: ol)
  circle((15.95, 4.1), radius: 0.16, fill: rgb("#f6c445"), stroke: gl)
  content((16.5, 4.1), lb9[C], anchor: "west")
  content((16.7, 5.4), lb9[B], anchor: "west")
  circle((16.1, 1.9), radius: 0.15, fill: rd, stroke: none)
  content((16.6, 1.9), lb9[A], anchor: "west")

  // 右上：Unlock / Locked 原理
  rect((19.4, 6.4), (24.2, 12.2), fill: gr, stroke: (paint: gd, thickness: 0.8pt))
  rect((19.4, 11.4), (24.2, 12.2), fill: gr2, stroke: (paint: gd, thickness: 0.8pt))
  content((21.8, 11.8), lb9[Unlock])
  rect((24.7, 6.4), (29.5, 12.2), fill: lb, stroke: (paint: gd, thickness: 0.8pt))
  rect((24.7, 11.4), (29.5, 12.2), fill: lb2, stroke: (paint: gd, thickness: 0.8pt))
  content((27.1, 11.8), lb9[Locked])
  // 单个原理单元
  let cellc(x0, locked: false) = {
    rect((x0 + 0.35, 9.0), (x0 + 1.15, 10.4), fill: gy, stroke: gl)
    rect((x0 + 1.15, 9.0), (x0 + 2.85, 10.4), fill: orc, stroke: ol)
    rect((x0 + 2.85, 9.4), (x0 + 3.5, 10.2), fill: orc2, stroke: ol)
    line((x0 + 1.55, 11.0), (x0 + 1.55, 10.4), (x0 + 1.05, 9.95),
      (x0 + 1.55, 9.5), (x0 + 1.55, 8.95), stroke: (paint: black, thickness: 1.1pt))
    circle((x0 + 1.55, 11.0), radius: 0.12, fill: black, stroke: none)
    circle((x0 + 0.55, 10.75), radius: 0.11, fill: rd, stroke: none)
    zz(x0 + 1.55, 8.95, 7.75, w: 0.14, n: 6, col: gd, thk: 1.1pt)
    circle((x0 + 1.55, 7.75), radius: 0.1, fill: black, stroke: none)
    if locked {
      arw((x0 + 2.9, 11.1), (x0 + 4.35, 11.1))
      content((x0 + 4.4, 11.1), lb9[$F_1$], anchor: "west")
      arw((x0 + 2.1, 8.8), (x0 + 2.1, 7.5))
      content((x0 + 2.3, 8.15), lb9[$F_t$], anchor: "west")
      line((x0 + 0.75, 10.55), (x0 + 1.5, 10.55), stroke: (paint: black, thickness: 0.6pt))
      content((x0 + 0.7, 10.7), lb9[$alpha$], anchor: "east")
    }
  }
  cellc(19.4)
  cellc(24.7, locked: true)

  // 右下：杠杆简图
  rect((19.4, 1.4), (24.2, 6.0), fill: gr, stroke: (paint: gd, thickness: 0.8pt))
  rect((24.7, 1.4), (29.5, 6.0), fill: lb, stroke: (paint: gd, thickness: 0.8pt))
  let lever(x0, locked: false) = {
    let p = ((x0 + 1.0, 5.2), (x0 + 1.2, 3.9), (x0 + 1.75, 3.2), (x0 + 2.45, 2.05))
    line(..p, stroke: (paint: gy, thickness: 4.6pt))
    for q in p { circle(q, radius: 0.23, fill: gy, stroke: none) }
    rect((x0 + 1.85, 1.75), (x0 + 2.75, 3.45), fill: orc2, stroke: ol)
    circle((x0 + 2.1, 2.8), radius: 0.15, fill: rgb("#f6c445"), stroke: gl)
    content((x0 + 2.3, 2.8), lb9[C], anchor: "west")
    content((x0 + 0.75, 5.4), lb9[B], anchor: "east")
    circle((x0 + 2.5, 2.0), radius: 0.15, fill: rd, stroke: none)
    content((x0 + 2.65, 1.85), lb9[A], anchor: "west")
    if locked {
      line((x0 + 1.0, 5.2), (x0 + 2.5, 2.0),
        stroke: (paint: rd, thickness: 0.7pt, dash: "dashed"))
      content((x0 + 1.35, 4.1), lb9[$l_1$], anchor: "east")
      content((x0 + 1.85, 2.75), lb9[$l_2$], anchor: "east")
      arw((x0 + 0.6, 5.7), (x0 + 2.2, 5.7))
      content((x0 + 0.5, 5.7), lb9[$F_1$], anchor: "east")
      arw((x0 + 1.6, 1.8), (x0 + 0.4, 1.8))
      content((x0 + 1.7, 1.8), lb9[$F_2$], anchor: "west")
    }
  }
  lever(19.4)
  lever(24.7, locked: true)

  // 底部引线标注
  line((15.0, 1.0), (15.5, 2.6), stroke: (paint: black, thickness: 0.6pt))
  content((14.8, 0.8), lb9[Drive rod], anchor: "east")
  line((20.7, 1.0), (21.3, 2.2), stroke: (paint: black, thickness: 0.6pt))
  content((20.5, 0.8), lb9[Locking lever], anchor: "east")
  line((27.4, 1.0), (27.2, 1.8), stroke: (paint: black, thickness: 0.6pt))
  content((27.5, 0.8), lb9[Pivot], anchor: "west")
})
