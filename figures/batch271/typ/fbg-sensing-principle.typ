#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：光纤布拉格光栅（FBG）传感原理线稿。左侧上为宽带入射谱 Light Input（P–λ 坐标），经折线箭头
// 进入光纤；光纤自外向内为 Coating/Cladding/Core 三层，芯内刻周期 Λ 的光栅 FBG；反射支路向下回到
// 窄带反射谱 Light Reflected（峰位 λ_B）；透射支路向右为带两个凹陷的透射谱 Light Transmitted。
// 逐字保留 P、λ、Light Input、Coating、Cladding、Core、Λ、FBG、Light Reflected、λ_B、Light Transmitted。
// 来源：Sensors 2025, 25, 2289, Figure 2 "The working principle of an FBG as a sensor". DOI 10.3390/s25072289

#canvas({
  import draw: *
  let ink = black
  let blue = rgb("#cfdcf0")
  let lblue = rgb("#e3ecf8")
  let spec = rgb("#d9d9d9")
  let t(pos, s, size: 7pt, anchor: "center") = content(
    pos, text(size: size)[#s], anchor: anchor, frame: none)
  let l2(a, b) = line(a, b, stroke: 0.8pt + ink)
  let leader(a, b) = line(a, b, stroke: 0.5pt + ink)
  let arr(a, b) = line(a, b, stroke: 0.8pt + ink, mark: (end: "stealth", scale: 0.5))
  let polyarr(..pts) = line(..pts, stroke: 0.8pt + ink, mark: (end: "stealth", scale: 0.5))
  // 谱坐标轴：原点、向上轴长、向右轴长
  let axes(o, hx, hy) = {
    l2(o, (o.at(0), o.at(1) + hy))
    l2(o, (o.at(0) + hx, o.at(1)))
    t((o.at(0) - 0.22, o.at(1) + hy), [P], size: 8pt)
    t((o.at(0) + hx + 0.18, o.at(1) - 0.16), [λ], size: 8pt)
  }

  // ── 入射谱（宽带）
  axes((1.00, 5.10), 1.70, 1.00)
  line((1.05, 5.10), (1.30, 5.45), (1.55, 5.82), (1.75, 5.88), (2.05, 5.82),
    (2.30, 5.55), (2.55, 5.10), (1.05, 5.10), fill: spec, stroke: 0.8pt + ink)
  t((2.98, 5.55), [Light Input], size: 7.4pt, anchor: "west")

  // ── 反射谱（窄带，峰位 λ_B）
  axes((1.00, 1.55), 1.85, 1.45)
  line((1.05, 1.55), (1.40, 1.57), (1.52, 2.30), (1.57, 3.00), (1.63, 2.30),
    (1.76, 1.57), (2.70, 1.55), (1.05, 1.55), fill: spec, stroke: 0.8pt + ink)
  t((2.78, 1.95), [Light Reflected], size: 7.4pt, anchor: "west")
  t((1.57, 1.32), [λ#sub[B]], size: 7.4pt)

  // ── 光纤三层与光栅
  rect((4.10, 3.95), (9.70, 4.45), fill: lblue, stroke: 0.8pt + ink)
  rect((4.20, 4.05), (9.60, 4.35), fill: blue, stroke: 0.6pt + ink)
  rect((4.30, 4.13), (9.50, 4.27), fill: rgb("#eef3fb"), stroke: 0.6pt + ink)
  for k in range(12) {
    let x = 6.20 + 0.10 * k
    line((x, 4.14), (x, 4.26), stroke: 1.2pt + ink)
  }
  line((6.25, 4.55), (6.55, 4.55), stroke: 0.8pt + ink,
    mark: (start: "stealth", end: "stealth", scale: 0.45))
  l2((6.25, 4.47), (6.25, 4.55))
  l2((6.55, 4.47), (6.55, 4.55))
  t((6.40, 4.68), [Λ], size: 8pt)
  // 层名引线
  t((8.45, 5.18), [Coating], size: 7.2pt)
  leader((8.40, 5.08), (9.36, 4.46))
  t((8.12, 4.90), [Cladding], size: 7.2pt)
  leader((8.08, 4.80), (9.34, 4.36))
  t((7.90, 4.64), [Core], size: 7.2pt)
  leader((7.86, 4.56), (9.32, 4.22))
  t((7.00, 3.52), [FBG], size: 7.4pt)
  leader((7.00, 3.64), (7.00, 4.10))

  // ── 入射/反射/透射光路箭头
  polyarr((2.70, 5.10), (3.95, 5.10), (3.95, 4.20), (4.08, 4.20))
  polyarr((4.08, 4.06), (2.15, 4.06), (2.15, 1.64))
  polyarr((9.70, 4.20), (10.90, 4.20))

  // ── 透射谱（宽带带两个被反射的凹陷）
  axes((10.60, 3.80), 2.60, 1.35)
  line((10.65, 3.80), (10.85, 4.50), (11.00, 4.72), (11.35, 4.78),
    (11.62, 4.75), (11.67, 4.35), (11.73, 4.75), (12.00, 4.78),
    (12.28, 4.74), (12.33, 4.34), (12.39, 4.74), (12.70, 4.70),
    (12.95, 4.50), (13.10, 3.80), (10.65, 3.80), fill: spec, stroke: 0.8pt + ink)
  t((11.45, 5.60), [Light Transmitted], size: 7.4pt)
})
