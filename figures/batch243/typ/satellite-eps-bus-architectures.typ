#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：卫星 EPS 母线系统七联图。(a) 非调节架构：PV Array→Unidirectional Converter→Battery/Load；
// (b) 调节架构：PV Array 经单向变换器、Battery 经双向变换器共同供电给 Load；(c) DET：PV ARRAY→DC-DC
// →LOADS，Battery Pack 双向挂接；(d) MPPT：PV→DC-DC→DC-DC→LOADS，Battery Pack 双向挂接；(e)(f)(g) 分布/
// 分散架构：BUS→Isolated DC-DC（或两级 DC-DC）→开关→LOADS。逐字保留全部标签与 (a)–(g) 分图号。
// 来源：Aerospace 2025, 12, 97, Figure 5 "EPS bus systems: (a) unregulated and (b) regulated EPS architectures...". DOI 10.3390/aerospace12020097

#canvas({
  import draw: *
  let ink = black
  let gold = rgb("#f2e34c")
  let pvfill = rgb("#9fb3c8")
  let peach = rgb("#f4c7a1")
  let green = rgb("#dbe8b4")
  let lav = rgb("#d9d2e9")
  let cyan = rgb("#c9f2ee")
  let bg1 = rgb("#f4f1e8")
  let bg2 = rgb("#e8eff4")
  let bg3 = rgb("#eef4e6")
  let t(pos, s, size: 5.2pt, anchor: "center", angle: 0deg) = content(
    pos, text(size: size)[#s], anchor: anchor, angle: angle, frame: none)
  let l2(a, b) = line(a, b, stroke: 0.7pt + ink)
  let arr(a, b) = line(a, b, stroke: 0.7pt + ink, mark: (end: "stealth", scale: 0.45))
  let darr(a, b) = line(a, b, stroke: 0.7pt + ink,
    mark: (start: "stealth", end: "stealth", scale: 0.4))
  let blk(c, w, h, s, fill: white, size: 5.2pt) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      fill: fill, stroke: 0.7pt + ink)
    t(c, s, size: size)
  }
  // PV 阵列：带剖面线的板＋左上标签
  let pv(c, label: [PV Array]) = {
    rect((c.at(0) - 0.30, c.at(1) - 0.30), (c.at(0) + 0.30, c.at(1) + 0.30),
      fill: pvfill, stroke: 0.7pt + ink)
    for k in (0.18, 0.34, 0.50) {
      line((c.at(0) - 0.30 + k, c.at(1) - 0.30), (c.at(0) - 0.30 + k * 0.4, c.at(1) + 0.30),
        stroke: 0.5pt + ink)
    }
    t((c.at(0), c.at(1) + 0.44), label, size: 5.4pt)
  }
  // 电池符号：长短横线两组
  let batt(c) = {
    line((c.at(0) - 0.13, c.at(1) + 0.05), (c.at(0) + 0.13, c.at(1) + 0.05), stroke: 0.9pt + ink)
    line((c.at(0) - 0.06, c.at(1) - 0.05), (c.at(0) + 0.06, c.at(1) - 0.05), stroke: 0.9pt + ink)
    l2((c.at(0), c.at(1) + 0.27), (c.at(0), c.at(1) + 0.05))
    l2((c.at(0), c.at(1) - 0.05), (c.at(0), c.at(1) - 0.27))
  }
  // 开关盒：方框＋双触点＋斜杆
  let sw(c) = {
    rect((c.at(0) - 0.22, c.at(1) - 0.11), (c.at(0) + 0.22, c.at(1) + 0.11),
      fill: rgb("#ececec"), stroke: 0.6pt + ink)
    circle((c.at(0) - 0.10, c.at(1)), radius: 0.022, fill: ink, stroke: none)
    circle((c.at(0) + 0.10, c.at(1)), radius: 0.022, fill: ink, stroke: none)
    line((c.at(0) - 0.10, c.at(1)), (c.at(0) + 0.13, c.at(1) + 0.06), stroke: 0.7pt + ink)
  }
  // 母线竖条＋竖排 BUS
  let busbar(x, y1, y2) = {
    rect((x - 0.18, y1), (x + 0.10, y2), fill: cyan, stroke: 0.7pt + ink)
    t((x - 0.04, (y1 + y2) / 2), [BUS], size: 6.4pt, angle: 90deg)
  }

  // ── (a) 非调节 EPS
  rect((0.20, 4.40), (4.40, 5.90), fill: bg1, stroke: 0.5pt + ink)
  pv((0.95, 5.15))
  blk((2.30, 5.12), 0.62, 0.42, [Unidirectional \ Converter], fill: rgb("#cddcf0"), size: 5.4pt)
  batt((3.55, 5.50))
  t((3.55, 5.83), [Battery], size: 5.2pt)
  blk((3.85, 4.98), 0.28, 0.18, [Load], size: 5.2pt)
  l2((1.25, 5.15), (1.68, 5.15))
  l2((2.92, 5.12), (3.55, 5.12))
  l2((3.55, 5.12), (3.55, 5.23))
  l2((3.55, 5.12), (3.55, 4.98))
  line((2.30, 4.70), (2.30, 4.82), (3.85, 4.82), (3.85, 4.80), stroke: 0.7pt + ink)
  t((2.30, 4.55), [(a)], size: 6.4pt)
  // ── (b) 调节 EPS
  rect((0.20, 2.20), (4.40, 4.10), fill: bg1, stroke: 0.5pt + ink)
  pv((0.90, 3.55))
  batt((0.90, 2.52))
  t((0.34, 2.52), [Battery], size: 5.2pt, anchor: "west")
  blk((2.35, 3.45), 0.62, 0.34, [Unidirectional \ Converter], fill: rgb("#cddcf0"), size: 5.2pt)
  blk((2.35, 2.72), 0.62, 0.34, [Bidirectional \ Converter], fill: rgb("#cddcf0"), size: 5.2pt)
  blk((3.90, 3.45), 0.28, 0.18, [Load], size: 5.2pt)
  l2((1.20, 3.55), (1.73, 3.55))
  l2((1.20, 2.52), (1.73, 2.52))
  l2((2.97, 3.45), (3.62, 3.45))
  l2((3.62, 3.45), (3.62, 3.32))
  line((2.97, 2.72), (3.62, 2.72), (3.62, 3.28), stroke: 0.7pt + ink)
  t((2.35, 2.30), [(b)], size: 6.4pt)
  // ── (c) DET 架构
  rect((4.40, 4.40), (9.90, 5.90), fill: bg2, stroke: 0.5pt + ink)
  pv((5.10, 5.15), label: [PV ARRAY])
  blk((6.55, 5.15), 0.42, 0.16, [DC-DC], fill: gold, size: 5.6pt)
  blk((8.30, 5.15), 0.55, 0.20, [LOADS], fill: lav, size: 5.6pt)
  blk((6.55, 4.62), 0.60, 0.16, [Battery Pack], fill: green, size: 5.2pt)
  arr((5.40, 5.15), (6.13, 5.15))
  arr((6.97, 5.15), (7.75, 5.15))
  darr((6.55, 4.98), (6.55, 4.78))
  t((6.55, 4.30), [(c)], size: 6.4pt)
  // ── (d) MPPT 架构
  rect((9.80, 4.40), (16.20, 5.90), fill: bg2, stroke: 0.5pt + ink)
  pv((10.50, 5.15), label: [PV ARRAY])
  blk((11.75, 5.15), 0.40, 0.16, [DC-DC], fill: gold, size: 5.6pt)
  blk((12.90, 5.15), 0.40, 0.16, [DC-DC], fill: gold, size: 5.6pt)
  blk((14.55, 5.15), 0.55, 0.20, [LOADS], fill: lav, size: 5.6pt)
  blk((12.90, 4.60), 0.60, 0.16, [Battery Pack], fill: green, size: 5.2pt)
  arr((10.80, 5.15), (11.35, 5.15))
  arr((12.15, 5.15), (12.50, 5.15))
  arr((13.30, 5.15), (14.00, 5.15))
  darr((12.90, 4.99), (12.90, 4.76))
  t((12.90, 4.30), [(d)], size: 6.4pt)

  // ── (e)(f)(g) 分布/分散架构：BUS 经隔离变换器到双路开关与 LOADS
  rect((4.40, 2.20), (8.30, 4.10), fill: bg3, stroke: 0.5pt + ink)
  busbar(4.65, 2.55, 3.75)
  blk((5.55, 3.12), 0.55, 0.24, [Isolated \ DC-DC], fill: peach, size: 4.8pt)
  blk((6.95, 3.52), 0.30, 0.12, [DC-DC], fill: gold, size: 4.8pt)
  blk((6.95, 2.72), 0.30, 0.12, [DC-DC], fill: gold, size: 4.8pt)
  sw((7.52, 3.52))
  sw((7.52, 2.72))
  blk((8.05, 3.12), 0.10, 0.45, [], fill: lav)
  t((8.05, 3.12), [LOADS], size: 4.8pt, angle: 90deg)
  arr((4.83, 3.12), (4.98, 3.12))
  l2((6.10, 3.12), (6.38, 3.12))
  l2((6.38, 3.12), (6.38, 3.52))
  l2((6.38, 3.12), (6.38, 2.72))
  l2((6.38, 3.52), (6.65, 3.52))
  arr((6.38, 2.72), (6.65, 2.72))
  arr((7.25, 3.52), (7.33, 3.52))
  arr((7.25, 2.72), (7.33, 2.72))
  arr((7.71, 3.52), (7.93, 3.52))
  arr((7.71, 2.72), (7.93, 2.72))
  t((6.20, 2.35), [(e)], size: 6.4pt)

  rect((8.30, 2.20), (12.10, 4.10), fill: bg3, stroke: 0.5pt + ink)
  busbar(8.55, 2.55, 3.75)
  blk((9.70, 3.12), 0.55, 0.24, [Isolated \ DC-DC], fill: peach, size: 4.8pt)
  sw((11.05, 3.52))
  sw((11.05, 2.72))
  blk((11.75, 3.12), 0.10, 0.45, [], fill: lav)
  t((11.75, 3.12), [LOADS], size: 4.8pt, angle: 90deg)
  arr((8.73, 3.12), (9.13, 3.12))
  l2((10.25, 3.12), (10.62, 3.12))
  l2((10.62, 3.12), (10.62, 3.52))
  l2((10.62, 3.12), (10.62, 2.72))
  arr((10.62, 3.52), (10.85, 3.52))
  arr((10.62, 2.72), (10.85, 2.72))
  arr((11.23, 3.52), (11.63, 3.52))
  arr((11.23, 2.72), (11.63, 2.72))
  t((10.10, 2.35), [(f)], size: 6.4pt)

  rect((12.10, 2.20), (16.20, 4.10), fill: bg3, stroke: 0.5pt + ink)
  busbar(12.35, 2.55, 3.75)
  blk((13.45, 3.52), 0.55, 0.22, [Isolated \ DC-DC], fill: peach, size: 4.8pt)
  blk((13.45, 2.72), 0.55, 0.22, [Isolated \ DC-DC], fill: peach, size: 4.8pt)
  sw((14.45, 3.52))
  sw((14.45, 2.72))
  blk((15.20, 3.12), 0.10, 0.45, [], fill: lav)
  t((15.20, 3.12), [LOADS], size: 4.8pt, angle: 90deg)
  arr((12.53, 3.12), (12.72, 3.12))
  l2((12.72, 3.12), (12.72, 3.52))
  l2((12.72, 3.12), (12.72, 2.72))
  arr((12.72, 3.52), (12.88, 3.52))
  arr((12.72, 2.72), (12.88, 2.72))
  arr((14.00, 3.52), (14.25, 3.52))
  arr((14.00, 2.72), (14.25, 2.72))
  arr((14.63, 3.52), (15.08, 3.52))
  arr((14.63, 2.72), (15.08, 2.72))
  t((13.60, 2.35), [(g)], size: 6.4pt)
})
