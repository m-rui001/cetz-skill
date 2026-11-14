#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 编译外观：左半 9×9 红色节点飞网 + 四角深绿子弹，右半圆框放大显示单个 cable element
// 来源：Mechanics of Space Debris Removal: A Review, Aerospace 2025, 12, 277, Figure 41. DOI 10.3390/aerospace12040277.
#canvas({
  import draw: *

  // 配色
  let cRed = rgb("#e51414")
  let cGreen = rgb("#46582f")
  let cBlue = rgb("#3c5fb8")
  let cDB = rgb("#1e6fbe")
  let cPur = rgb("#7a3cb4")

  // 向量助手
  let vadd(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
  let vsub(a, b) = (a.at(0) - b.at(0), a.at(1) - b.at(1))
  let vmul(a, k) = (a.at(0) * k, a.at(1) * k)
  let vunit(a) = vmul(a, 1 / calc.sqrt(a.at(0) * a.at(0) + a.at(1) * a.at(1)))

  // 单个 cable element：蓝杆 + 外侧锯齿弹簧 + 内侧白色阻尼块
  let cable(a, b, trim: 0.32, amp: 0.13, teeth: 6, side: 1) = {
    let u = vunit(vsub(b, a))
    let nrm = vmul((-u.at(1), u.at(0)), side)
    let p0 = vadd(a, vmul(u, trim))
    let p1 = vsub(b, vmul(u, trim))
    line(p0, p1, stroke: (paint: cBlue, thickness: 0.40))
    let pts = ()
    for k in range(0, 2 * teeth + 1) {
      let t = k / (2 * teeth)
      let off = if calc.odd(k) { amp } else { 0 }
      pts.push(vadd(vadd(p0, vmul(vsub(p1, p0), t)), vmul(nrm, 0.26 + off)))
    }
    line(..pts, stroke: 1.4pt)
    let cc = vadd(vmul(vadd(p0, p1), 0.5), vmul(nrm, -0.24))
    let s = 0.38
    rect((cc.at(0) - s / 2, cc.at(1) - s / 2), (cc.at(0) + s / 2, cc.at(1) + s / 2),
      fill: white, stroke: 1.3pt)
  }

  // 左：四颗子弹与牵引线（先画，网点覆盖其上）
  let bullets = (
    (c: (0.55, 13.0), lp: (1.35, 13.0), an: "west", name: "Bullet 1", corner: (1.6, 11.6)),
    (c: (10.65, 13.0), lp: (9.85, 13.0), an: "east", name: "Bullet 3", corner: (9.6, 11.6)),
    (c: (0.55, 2.2), lp: (1.35, 2.2), an: "west", name: "Bullet 2", corner: (1.6, 3.6)),
    (c: (10.65, 2.2), lp: (9.85, 2.2), an: "east", name: "Bullet 4", corner: (9.6, 3.6)),
  )
  for b in bullets {
    line(b.c, b.corner, stroke: 1.6pt)
    circle(b.c, radius: 0.45, fill: cGreen, stroke: none)
    content(b.lp, text(weight: "bold", size: 11pt, b.name), anchor: b.an)
  }

  // 左：9×9 网面
  let n = 9
  let pt(i, j) = (1.6 + i, 3.6 + j)
  // 网线
  for i in range(n) {
    for j in range(n) {
      if i < n - 1 { line(pt(i, j), pt(i + 1, j), stroke: 1.2pt) }
      if j < n - 1 { line(pt(i, j), pt(i, j + 1), stroke: 1.2pt) }
    }
  }
  // 网点
  for i in range(n) {
    for j in range(n) { circle(pt(i, j), radius: 0.15, fill: cRed, stroke: none) }
  }

  // 网面上被放大的区域（蓝虚线小圆）
  circle((5.6, 6.6), radius: 0.85, stroke: (paint: cDB, thickness: 1.8pt, dash: "dashed"))

  // 紫色指示箭头：小圆 → 放大视图
  line((6.55, 6.9), (14.0, 7.55), stroke: (paint: cPur, thickness: 2.6pt),
    mark: (end: "stealth", scale: 2.2))

  // 右：放大 cable element 单元
  let tl = (15.1, 8.1)
  let tr = (18.3, 8.1)
  let bl = (15.1, 5.1)
  let br = (18.3, 5.1)
  // 四条 cable element：弹簧一律朝外
  cable(tl, tr, side: 1)
  cable(bl, br, side: 1)
  cable(tl, bl, side: 1)
  cable(tr, br, side: 1)
  // 四个质量点
  for p in (tl, tr, bl, br) { circle(p, radius: 0.28, fill: cRed, stroke: none) }
  // 放大区域圆框
  circle((16.7, 6.6), radius: 2.75, stroke: (paint: cDB, thickness: 2pt, dash: "dashed"))

  // Mass point 标注
  content((14.6, 8.9), text(weight: "bold", size: 11pt, "Mass point"), anchor: "east")
  line((14.5, 8.85), (15.0, 8.3), stroke: 1.3pt, mark: (end: "stealth"))

  // 顶部标注文字（三行）
  content((14.0, 10.05), text(weight: "bold", size: 11pt,
    [One cable element,  no \ additional mass points, \ one segment]), anchor: "south-west")
  // 文字下方的上括号：横梁 + 两端上翘 + 中点上翘
  let by = 9.62
  line((14.5, by + 0.20), (14.5, by), (18.9, by), (18.9, by + 0.20), stroke: 1.4pt)
  line((16.7, by), (16.7, by + 0.24), stroke: 1.4pt)

  // Spring Damping Element 标注
  content((13.4, 2.4), text(weight: "bold", size: 11pt, "Spring Damping Element"), anchor: "west")
  line((16.25, 2.8), (16.6, 4.55), stroke: 1.3pt, mark: (end: "stealth"))
})
