#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 外观：白底细黑线稿卫星激光测距原理图（卫星框+角反射器+倾斜望远镜光路+距离-时间散点）
// 来源：Mechanics of Space Debris Removal: A Review, Aerospace 2025, 12, 277, Figure 9. DOI 10.3390/aerospace12040277.
#canvas({
  import draw: *
  let cr = rgb("#d42a20")
  let org = rgb("#e8491d")

  // 共享助手：以 C 为心、沿管轴 ang 的局部坐标 (a 轴向, b 法向) 转世界坐标
  let rp(C, ang, a, b) = {
    let ca = calc.cos(ang)
    let sa = calc.sin(ang)
    (C.at(0) + a * ca - b * sa, C.at(1) + a * sa + b * ca)
  }

  // 卫星方框与标题
  rect((5.9, 7.8), (8.3, 10.0), stroke: 0.8pt)
  content((7.1, 10.32), [satellite])

  // 卫星上两个红色反射目标点
  let d1 = (6.35, 9.40)
  let d2 = (7.30, 8.35)
  circle(d1, radius: 0.15, fill: cr, stroke: none)
  circle(d2, radius: 0.15, fill: cr, stroke: none)

  // 角反射器外轮廓（折线闭合，碗状）
  let outer = ((3.15, 9.50), (3.50, 9.30), (3.58, 8.98), (3.42, 8.66), (3.08, 8.45),
    (2.72, 8.42), (2.45, 8.58), (2.32, 8.85), (2.36, 9.18), (2.58, 9.42))
  line(..outer, close: true, stroke: 0.8pt)

  // 角反射器内部碗口弧线（前缘）
  bezier((2.34, 9.00), (3.56, 8.92), (2.80, 8.60), (3.20, 8.62), stroke: 0.7pt)

  // 三条棱线由边缘汇聚到中心
  let M = (2.92, 9.02)
  line((2.58, 9.42), M, stroke: 0.7pt)
  line((3.58, 8.98), M, stroke: 0.7pt)
  line((3.08, 8.45), M, stroke: 0.7pt)

  // 反射器指向两个红点的箭头
  line((3.60, 9.10), (6.16, 9.38), stroke: 0.8pt, mark: (end: "stealth", scale: 2))
  line((3.62, 8.50), (7.16, 8.37), stroke: 0.8pt, mark: (end: "stealth", scale: 2))

  // 反射器标签
  content((2.55, 7.55), [retroreflector])

  // 倾斜镜筒（管轴 50°，中心 C）
  let ang = 50deg
  let C = (3.6, 2.65)
  line(rp(C, ang, 1.05, 0.42), rp(C, ang, 1.05, -0.42),
    rp(C, ang, -1.05, -0.42), rp(C, ang, -1.05, 0.42), close: true, stroke: 0.9pt)

  // 侧挂激光器
  let Lc = rp(C, ang, 0.55, 0.55)
  line(rp(Lc, ang, 0.30, 0.32), rp(Lc, ang, 0.30, -0.32),
    rp(Lc, ang, -0.30, -0.32), rp(Lc, ang, -0.30, 0.32), close: true, stroke: 0.8pt)

  // 尾部探测器
  let Dc = rp(C, ang, -1.32, 0)
  line(rp(Dc, ang, 0.30, 0.33), rp(Dc, ang, 0.30, -0.33),
    rp(Dc, ang, -0.30, -0.33), rp(Dc, ang, -0.30, 0.33), close: true, stroke: 0.8pt)

  // 设备标签（随镜筒倾角旋转）
  content(rp(C, ang, 0.30, 1.05), [laser], angle: 50deg)
  content((2.18, 1.90), [detec- #linebreak() tor], angle: 50deg)

  // 发射 Tx 与接收 Rx 光路
  line((4.25, 3.55), (5.90, 7.75), stroke: (paint: org, thickness: 1.1pt), mark: (end: "stealth", scale: 2.2))
  line((6.60, 7.60), (4.50, 3.60), stroke: (paint: org, thickness: 1.1pt), mark: (end: "stealth", scale: 2.2))
  content((4.55, 5.70), [Tx])
  content((6.10, 5.45), [Rx])

  // 距离-时间坐标轴
  line((4.85, 0.85), (4.85, 3.45), stroke: (paint: org, thickness: 1.2pt), mark: (end: "stealth", scale: 2.2))
  line((4.85, 0.85), (8.35, 0.85), stroke: (paint: org, thickness: 1.2pt), mark: (end: "stealth", scale: 2.2))
  content((5.60, 3.40), [range])
  content((8.75, 0.85), [time])

  // 两组 CCR 回波散点（表驱动）
  let ccr1 = ((5.15, 2.78), (5.35, 2.84), (5.55, 2.78), (5.75, 2.86), (5.98, 2.80),
    (6.22, 2.92), (6.48, 2.86), (6.75, 2.97), (7.02, 2.93))
  let ccr2 = ((5.15, 1.98), (5.35, 2.04), (5.55, 1.96), (5.75, 2.06), (5.98, 1.99),
    (6.22, 2.10), (6.48, 2.16), (6.78, 2.10), (7.02, 2.20))
  for p in ccr1 { circle(p, radius: 0.075, fill: black, stroke: none) }
  for p in ccr2 { circle(p, radius: 0.075, fill: black, stroke: none) }
  content((7.85, 2.80), [CCR1])
  content((7.85, 1.95), [CCR2])
})
