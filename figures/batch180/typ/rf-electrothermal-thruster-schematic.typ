#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 射频电热推力器(Pocket Rocket)结构剖面示意图, 平涂线稿重绘
// 来源: Aerospace 2024, 11(7), 502, Figure 19；DOI 10.3390/aerospace11070502

#canvas({
  import draw: *

  // ---------------- 配色 ----------------
  let c-alu = rgb("#d6d6d6")
  let c-macor = rgb("#eeeeee")
  let c-cav = rgb("#fbfbfb")
  let c-org = rgb("#f4a259")
  let c-mag = rgb("#c62fb4")
  let c-alm = rgb("#dc8ec6")
  let c-hatch = rgb("#7f7f7f")

  // 矩形内排线助手: sign = 1 为 "/", -1 为 "\"
  let hatch(a, b, spacing: 0.2, sign: 1, scol: c-hatch, w: 0.3pt) = {
    let x0 = calc.min(a.at(0), b.at(0))
    let x1 = calc.max(a.at(0), b.at(0))
    let y0 = calc.min(a.at(1), b.at(1))
    let y1 = calc.max(a.at(1), b.at(1))
    if sign == 1 {
      let c = x0 - y1
      while c < x1 - y0 {
        let lo = calc.max(y0, x0 - c)
        let hi = calc.min(y1, x1 - c)
        if hi - lo > 0.05 { line((lo + c, lo), (hi + c, hi), stroke: scol + w) }
        c += spacing
      }
    } else {
      let c = x0 + y0
      while c < x1 + y1 {
        let lo = calc.max(y0, c - x1)
        let hi = calc.min(y1, c - x0)
        if hi - lo > 0.05 { line((c - lo, lo), (c - hi, hi), stroke: scol + w) }
        c += spacing
      }
    }
  }

  // ---------------- 关键地标 ----------------
  let ymid = 2.2   // 推力器轴线
  let L = -0.35    // 左壁
  let R = 4.0      // 机体右缘
  let yT = 4.6     // 机体顶
  let yB = 0.2     // 机体底
  let xa = 2.72    // rf 馈线轴线
  let xth = 7.4    // 膨胀管喉部

  // 左侧上下进气/压力块(铝, 排线)
  for (a, b) in (((L, 4.05), (1.2, yT)), ((L, yB), (1.2, 0.75))) {
    rect(a, b, fill: c-alu, stroke: black + 0.8pt)
    hatch(a, b, spacing: 0.16)
  }

  // 左壁, 中部留出 plenum window 缺口
  line((L, yT), (L, 3.2), stroke: black + 0.8pt)
  line((L, 1.4), (L, yB), stroke: black + 0.8pt)

  // 铝机体(剖面排线)
  rect((1.2, yB), (R, yT), fill: c-alu, stroke: black + 0.9pt)
  hatch((1.2, yB), (R, yT), spacing: 0.2)

  // Macor 陶瓷内衬
  rect((1.7, 0.6), (3.8, 4.2), fill: c-macor, stroke: black + 0.6pt)
  hatch((1.7, 0.6), (3.8, 4.2), spacing: 0.42, sign: -1, scol: rgb("#b2b2b2"))

  // 放电腔
  rect((2.0, 1.45), (3.45, 2.95), fill: c-cav, stroke: black + 0.6pt)

  // 氧化铝绝缘薄层(横贯腔体)
  rect((1.7, 2.09), (4.05, 2.31), fill: c-alm, stroke: rgb("#b4649f") + 0.6pt)

  // 两片电极(橙色排线小块, 上下错位)
  for (a, b) in (((2.55, 2.40), (2.95, 2.85)), ((2.30, 1.55), (2.70, 2.00))) {
    rect(a, b, fill: c-org, stroke: rgb("#a86a2a") + 0.6pt)
    hatch(a, b, spacing: 0.12, scol: rgb("#b87838"), w: 0.35pt)
  }

  // rf 同轴馈线: 由射频圈分别接到上下电极
  line((2.85, 4.95), (2.85, 2.85), stroke: black + 0.8pt)
  line((2.42, 4.95), (2.42, 2.00), stroke: black + 0.8pt)

  // 等离子体羽流(品红平涂): 喷口直段 + 右向收尖
  let xn = 2.45      // 喷口
  let xm = 4.0       // 直段末
  let xt = 5.35      // 羽流尖端
  line((xn, ymid + 0.12), (xm, ymid + 0.12), (xt, ymid), (xm, ymid - 0.12), (xn, ymid - 0.12),
       close: true, fill: c-mag, stroke: rgb("#8e1a80") + 0.6pt)

  // 接地符号
  line((xa, yB), (xa, -0.42), stroke: black + 0.8pt)
  for (dy, w) in ((0.0, 0.66), (0.12, 0.40), (0.24, 0.16)) {
    let y = -0.42 - dy
    line((xa - w / 2, y), (xa + w / 2, y), stroke: black + 0.8pt)
  }

  // 膨胀管: 自机体右缘收敛至喉部再外张(上下对称)
  bezier((R, yT), (xth, 2.7), (5.5, yT), (6.8, 2.7), stroke: black + 0.9pt)
  bezier((xth, 2.7), (8.6, 3.6), (8.0, 2.7), (8.2, 3.6), stroke: black + 0.9pt)
  bezier((R, yB), (xth, 1.7), (5.5, yB), (6.8, 1.7), stroke: black + 0.9pt)
  bezier((xth, 1.7), (8.6, 0.8), (8.0, 1.7), (8.2, 0.8), stroke: black + 0.9pt)

  // 顶部射频圈
  circle((xa, 5.4), radius: 0.45, fill: white, stroke: black + 0.8pt)
  content((xa, 5.4), text(size: 9pt)[rf])

  // 进气口标注
  content((0.15, 5.45), [Gas Inlet])
  line((0.42, 5.2), (0.42, 4.62), stroke: black + 0.7pt, mark: (end: "stealth"))

  // 压力计标注
  content((-0.1, -1.05), [Pressure Gauge])
  line((0.5, -0.75), (0.5, 0.16), stroke: black + 0.7pt, mark: (end: "stealth"))

  // Plenum Window 括线 + 标注
  line((L, 3.2), (-0.85, 3.2), stroke: black + 0.6pt)
  line((-0.85, 3.2), (-0.85, 1.4), stroke: black + 0.6pt)
  line((-0.85, 1.4), (L, 1.4), stroke: black + 0.6pt)
  content((-1.05, 2.6), [Plenum], anchor: "east")
  content((-1.05, 2.33), [Window], anchor: "east")

  // Plenum Chamber 标注
  content((-1.05, 1.15), [Plenum], anchor: "east")
  content((-1.05, 0.88), [Chamber], anchor: "east")
  line((-0.75, 1.25), (-0.2, 1.55), stroke: black + 0.6pt, mark: (end: "stealth"))

  // 右侧材料引线标注(置于膨胀管曲线内侧, 互不相交)
  content((4.95, 5.35), [Aluminium], anchor: "west")
  line((4.85, 5.28), (3.9, 4.62), stroke: black + 0.6pt, mark: (end: "stealth"))

  content((5.35, 4.35), [Macor], anchor: "west")
  line((5.30, 4.33), (3.70, 3.55), stroke: black + 0.6pt, mark: (end: "stealth"))

  content((5.35, 2.95), [Alumina], anchor: "west")
  line((5.50, 2.98), (3.90, 2.34), stroke: black + 0.6pt, mark: (end: "stealth"))

  // 膨胀管标注
  content((4.45, -0.9), [Expansion Tube], anchor: "west")
  line((4.40, -0.78), (4.15, 0.24), stroke: black + 0.6pt, mark: (end: "stealth"))
})
