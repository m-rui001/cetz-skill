#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：桁架模块连接设计双面板线稿。(a) 多向球窝连接面板：中央八边形连接面盘，六条球头杆
// 呈放射状插入六角卡槽，右下为带连接柱塞与锁紧螺母的插头；标注 Receptacle、Connector plunger、
// Locking nut、Connector face。(b) 杆件-球节点装配：两端八边形球节点（带安装孔）经球节点连接件、
// 杆接头、套筒与长杆相连，含弹簧销与中点断裂画法；上方括号标注 Ball node fittings 与 Rod assembly，
// 引线标注 Rod joints、Sleeve、Rod、Spring pin、Ball node connector、Ball node，底部 ~1000 mm 尺寸。
// 来源：Aerospace 2025, 12, 375, Figure 50 "Truss module connection design". DOI 10.3390/aerospace12050375

#canvas({
  import draw: *
  let ink = black
  let thin = 0.4pt
  let gray = rgb("#cfcfcf")
  let lgray = rgb("#e2e2e2")
  let brass = rgb("#efe0c8")
  let t(pos, s, size: 7pt, anchor: "center") = content(
    pos, text(size: size)[#s], anchor: anchor, frame: none)
  let leader(a, b) = line(a, b, stroke: thin + ink)
  // 正多边形（flat: 是否平顶）
  let ngon(c, r, n, flat: false, fill: white, stroke: ink) = {
    let ph = if flat { 90deg } else { 0deg }
    let pts = range(n).map(i => {
      let a = ph + i * (360deg / n)
      (c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a))
    })
    if n == 6 {
      line(pts.at(0), pts.at(1), pts.at(2), pts.at(3), pts.at(4), pts.at(5),
        pts.at(0), fill: fill, stroke: stroke + 0.6pt)
    } else {
      line(pts.at(0), pts.at(1), pts.at(2), pts.at(3), pts.at(4), pts.at(5),
        pts.at(6), pts.at(7), pts.at(0), fill: fill, stroke: stroke + 0.6pt)
    }
  }
  // 斜置圆管/杆：a→b，halfw 半宽，四角填充
  let tube(a, b, halfw, fill: gray) = {
    let dx = b.at(0) - a.at(0)
    let dy = b.at(1) - a.at(1)
    let L = calc.sqrt(dx * dx + dy * dy)
    let nx = -dy / L * halfw
    let ny = dx / L * halfw
    line((a.at(0) + nx, a.at(1) + ny), (b.at(0) + nx, b.at(1) + ny),
      (b.at(0) - nx, b.at(1) - ny), (a.at(0) - nx, a.at(1) - ny),
      (a.at(0) + nx, a.at(1) + ny), fill: fill, stroke: 0.6pt + ink)
  }
  // 水平圆管：x1→x2，半高 hh
  let bar(x1, x2, y, hh, fill: gray) = {
    rect((x1, y - hh), (x2, y + hh), fill: fill, stroke: 0.6pt + ink)
  }
  // 分组括号：两端下折、中央下尖，标签位于上方
  let brace(x1, x2, y, label) = {
    let xm = (x1 + x2) / 2
    line((x1, y - 0.10), (x1, y), (xm - 0.10, y), (xm, y - 0.12),
      (xm + 0.10, y), (x2, y), (x2, y - 0.10), stroke: 0.7pt + ink)
    t((xm, y + 0.20), label, size: 7pt)
  }

  // ── (a) 多向球窝连接面板
  let C = (2.95, 5.25)
  for a in (30deg, 90deg, 150deg, 210deg, 270deg, 330deg) {
    let d = (calc.cos(a), calc.sin(a))
    let p1 = (C.at(0) + 0.42 * d.at(0), C.at(1) + 0.42 * d.at(1))
    let p2 = (C.at(0) + 1.02 * d.at(0), C.at(1) + 1.02 * d.at(1))
    tube(p1, p2, 0.10, fill: lgray)
    ngon(p2, 0.17, 6, flat: true, fill: rgb("#f4f4f4"))
    circle(p2, radius: 0.075, fill: gray, stroke: 0.6pt + ink)
  }
  ngon(C, 0.56, 8, flat: true, fill: rgb("#ececec"))
  circle(C, radius: 0.17, fill: white, stroke: 0.6pt + ink)
  // 插头：连接柱塞→本体→锁紧螺母（分离的铜螺母）
  tube((4.42, 4.28), (4.92, 3.92), 0.035, fill: rgb("#d8d8d8"))
  tube((4.92, 3.92), (6.18, 2.94), 0.12, fill: lgray)
  circle((5.02, 3.95), radius: 0.07, fill: rgb("#e8e8e8"), stroke: 0.6pt + ink)
  ngon((5.58, 2.44), 0.17, 6, fill: brass)
  circle((5.58, 2.44), radius: 0.05, fill: white, stroke: 0.5pt + ink)
  // 引线标注
  t((3.02, 7.06), [Receptacle], size: 8pt)
  leader((3.02, 6.90), (3.00, 6.22))
  t((5.72, 6.12), [Connector \ plunger], size: 8pt)
  leader((5.62, 5.95), (4.52, 4.22))
  t((6.30, 2.20), [Locking nut], size: 8pt)
  leader((5.98, 2.30), (5.75, 2.40))
  t((1.18, 1.86), [Connector face], size: 8pt)
  leader((2.30, 1.98), (2.52, 4.62))
  t((2.95, 1.10), [(a)], size: 8pt)

  // ── (b) 杆件与球节点装配
  let y0 = 4.60
  // 左球节点：八边形块＋四个安装孔＋中心球窝，右侧短颈
  ngon((7.55, y0), 0.34, 8, flat: true, fill: rgb("#e6e6e6"))
  for o in ((-0.15, -0.15), (0.15, -0.15), (-0.15, 0.15), (0.15, 0.15)) {
    circle((7.55 + o.at(0), y0 + o.at(1)), radius: 0.05, fill: white, stroke: 0.5pt + ink)
  }
  circle((7.55, y0), radius: 0.07, fill: white, stroke: 0.5pt + ink)
  bar(7.88, 8.03, y0, 0.08, fill: rgb("#d5d5d5"))
  // 球节点连接件、杆接头、套筒、长杆（中点断裂画法）
  bar(8.03, 8.34, y0, 0.085, fill: rgb("#e0e0e0"))
  bar(8.40, 8.62, y0, 0.115, fill: rgb("#dcdcdc"))
  bar(8.62, 8.88, y0, 0.100, fill: rgb("#dcdcdc"))
  bar(8.88, 9.50, y0, 0.125, fill: rgb("#d2d2d2"))
  bar(9.50, 10.85, y0, 0.080, fill: gray)
  bar(11.00, 12.00, y0, 0.080, fill: gray)
  line((10.85, y0 + 0.08), (10.90, y0 - 0.08), stroke: 0.6pt + ink)
  line((10.97, y0 + 0.08), (11.02, y0 - 0.08), stroke: 0.6pt + ink)
  bar(12.00, 12.22, y0, 0.100, fill: rgb("#dcdcdc"))
  bar(12.22, 12.44, y0, 0.115, fill: rgb("#dcdcdc"))
  bar(12.44, 12.53, y0, 0.08, fill: rgb("#d5d5d5"))
  // 右球节点
  ngon((12.85, y0), 0.34, 8, flat: true, fill: rgb("#e6e6e6"))
  for o in ((-0.15, -0.15), (0.15, -0.15), (-0.15, 0.15), (0.15, 0.15)) {
    circle((12.85 + o.at(0), y0 + o.at(1)), radius: 0.05, fill: white, stroke: 0.5pt + ink)
  }
  circle((12.85, y0), radius: 0.07, fill: white, stroke: 0.5pt + ink)
  // 弹簧销
  bar(8.56, 8.68, 4.45, 0.030, fill: rgb("#b8b8b8"))
  // 分组括号与引线标注
  brace(7.20, 8.90, 7.05, [Ball node fittings])
  brace(9.12, 13.20, 7.05, [Rod assembly])
  t((9.42, 6.30), [Rod joints], size: 7.4pt)
  leader((9.32, 6.18), (8.72, 4.73))
  t((9.86, 5.52), [Sleeve], size: 7.4pt)
  leader((9.78, 5.42), (9.20, 4.75))
  t((10.60, 6.30), [Rod], size: 7.4pt)
  leader((10.52, 6.18), (10.35, 4.70))
  t((9.42, 3.78), [Spring pin], size: 7.4pt)
  leader((9.30, 3.88), (8.62, 4.41))
  t((9.06, 3.28), [Ball node connector], size: 7.4pt)
  leader((8.92, 3.38), (8.24, 4.48))
  t((7.30, 3.66), [Ball node], size: 7.4pt)
  leader((7.38, 3.76), (7.50, 4.28))
  // ~1000 mm 尺寸线
  line((7.55, 3.55), (7.55, 2.85), stroke: 0.5pt + ink)
  line((12.85, 3.55), (12.85, 2.85), stroke: 0.5pt + ink)
  line((7.62, 2.95), (12.78, 2.95), stroke: 0.6pt + ink,
    mark: (start: "stealth", end: "stealth", scale: 0.5))
  t((10.20, 2.68), [\~ 1000 mm], size: 7.6pt)
  t((10.15, 1.10), [(b)], size: 8pt)
})
