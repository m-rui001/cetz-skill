#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：TPMS 换热器周期计算模型的等轴测线稿。蓝色薄板（长 55、厚 5）顶面为冷热流体交替的菱格通道，
// 红色下箭头为热侧入口（T_h,in、P_h,in），红色上箭头为热侧出口（m_dot_h,out，两处），右上蓝色箭头为
// 冷侧入口（T_c,in、P_c,in），左下蓝色箭头为冷侧出口（m_dot_c,out）；上方标注周期边界，左下标注绝热边界，
// 底边与右端分别给出 55、5 两个尺寸。逐字保留全部标签。
// 来源：Aerospace 2025, 12, 416, Figure 5 "The simulation model and boundary conditions" DOI 10.3390/aerospace12050416

#canvas({
  import draw: *
  let ink = black
  let red = rgb("#c0392b")
  let blue = rgb("#2f6f9f")
  let add(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
  let mul(a, k) = (a.at(0) * k, a.at(1) * k)
  let tx(p, s, size: 7.5pt) = content(p, text(size: size, s), frame: none)
  let arr(a, b, c, t: 1.5pt) = line(a, b, stroke: (paint: c, thickness: t),
    mark: (end: "stealth", scale: 0.65, fill: c))

  // 板体几何：u 为长度方向，v 为宽度方向，w 为厚度方向
  let p0 = (1.8, 2.0)
  let u = (10.4, 1.0)
  let v = (3.0, 2.2)
  let w = (0, -1.2)
  let p1 = add(p0, u)
  let p2 = add(p1, v)

  // 近端与右端侧面
  line(p0, p1, add(p1, w), add(p0, w), p0, fill: rgb("#4fb3d9"),
    stroke: 0.8pt + rgb("#186a8f"))
  line(p1, p2, add(p2, w), add(p1, w), p1, fill: rgb("#3a9cc4"),
    stroke: 0.8pt + rgb("#186a8f"))

  // 顶面：8 条冷热交替条带，带内菱形褶皱示意 TPMS 通道
  let n = 8
  for i in range(n) {
    let ds = mul(v, 1 / n)
    let a = add(p0, mul(v, i / n))
    let b = add(a, u)
    let d = add(a, ds)
    let base = if calc.odd(i) { rgb("#f7b3c2") } else { rgb("#9fdcea") }
    line(a, b, add(b, ds), d, a, fill: base, stroke: none)
    for k in range(8) {
      let ctr = add(add(a, mul(u, (k + 0.5) / 8)), mul(ds, 0.5))
      let h1 = mul(u, 1 / 16)
      let h2 = mul(ds, 0.45)
      line(add(ctr, h1), add(ctr, h2), add(ctr, mul(h1, -1)), add(ctr, mul(h2, -1)),
        add(ctr, h1), stroke: 0.5pt + rgb("#2b7fa5"))
    }
  }
  // 顶面周界重描，压住条带接缝
  let p3 = add(p0, v)
  line(p0, p1, p2, p3, p0, stroke: 1pt + rgb("#186a8f"))

  // 周期边界：从后缘引到左上标签，避开出口箭头
  line((7.25, 4.48), (6.55, 6.30), stroke: 0.8pt + ink)
  tx((5.95, 6.5), "Periodic boundary", size: 8pt)

  // 热侧：入口红下箭头与出口红上箭头（两处）
  arr((6.35, 4.35), (6.35, 3.05), red)
  line((5.55, 4.63), (6.32, 4.39), stroke: 0.6pt + ink)
  tx((4.35, 4.72), [$T_("h,in") quad P_("h,in")$], size: 8pt)
  arr((7.95, 3.55), (7.95, 4.95), red)
  line((8.05, 4.98), (9.18, 5.72), stroke: 0.6pt + ink)
  tx((9.85, 5.85), [$dot(m)_("h,out")$], size: 8pt)
  arr((9.75, 3.95), (9.75, 5.35), red)
  line((9.86, 5.40), (10.72, 6.08), stroke: 0.6pt + ink)
  tx((11.55, 6.20), [$dot(m)_("h,out")$], size: 8pt)

  // 冷侧：右上入口双箭头与左下出口箭头
  arr((13.95, 6.15), (12.95, 5.15), blue)
  arr((13.35, 6.35), (12.35, 5.35), blue)
  tx((14.55, 6.6), [$T_("c,in")$], size: 8pt)
  tx((14.85, 5.85), [$P_("c,in")$], size: 8pt)
  arr((2.0, 1.75), (0.6, 0.95), blue)
  tx((1.5, 0.62), [$dot(m)_("c,out")$], size: 8pt)

  // 绝热边界：左下标签与引线
  tx((4.5, 0.32), "Adiabatic boundary", size: 8pt)
  line((4.2, 0.55), (3.9, 1.2), stroke: 0.8pt + ink)

  // 尺寸：长 55 沿底边，厚 5 在右端
  line((6.3, 0.28), (12.25, 0.85), stroke: 0.7pt + ink,
    mark: (start: "bar", end: "bar", scale: 0.4))
  tx((9.4, 0.42), "55", size: 8pt)
  line((15.75, 3.95), (15.75, 5.15), stroke: 0.7pt + ink,
    mark: (start: "bar", end: "bar", scale: 0.4))
  tx((16.15, 4.55), "5", size: 8pt)
})
