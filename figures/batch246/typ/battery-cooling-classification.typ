#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：电池冷却系统分类树。根部 Battery Cooling System 下分四支：Air-Cooling（Natural、Forced；
// Forced 再分 Air channel modifications/Fin addition/Cell arrangement modification）、Liquid-Cooling
//（Cold Plate Cooling、Micro Channel Cooling）、PCM-Cooling（Air-cooling PCM hybrid、Liquid-cooling
// PCM hybrid）、Thermoelectric Cooling（Thermoelectric Cooler (TEC)、Thermoelectric Generator (TEG)）。
// 节点为白底橙框（框宽按最长标签预留），支路以灰色折线连接。逐字保留全部标签。
// 来源：Batteries 2024, 10, 265, Figure 1 "The battery pack cooling classification used in this study". DOI 10.3390/batteries10080265

#canvas({
  import draw: *
  let ink = black
  let orange = rgb("#e07b39")
  let gray = rgb("#9a9a9a")
  let l2(a, b) = line(a, b, stroke: 0.9pt + gray)
  let node(c, w, h, body, fs: 6.0) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      radius: 0.05, fill: white, stroke: 0.8pt + orange)
    content(c, text(size: fs * 1pt)[#body], anchor: "center", frame: none)
  }

  // 根节点
  node((8.00, 7.85), 1.52, 0.30, [Battery Cooling System], fs: 7.6)

  // 四支主类
  let parents = ((2.00, 0.68, [Air-Cooling], 6.2), (5.95, 0.84, [Liquid-Cooling], 6.2),
    (10.00, 0.68, [PCM-Cooling], 6.2), (14.00, 1.10, [Thermoelectric \ Cooling], 5.4))
  l2((8.00, 7.49), (8.00, 7.30))
  l2((2.00, 7.30), (14.00, 7.30))
  for p in parents {
    l2((p.at(0), 7.30), (p.at(0), 7.04))
    node((p.at(0), 6.70), p.at(1), 0.32, p.at(2), fs: p.at(3))
  }

  // Air-Cooling 子树：Natural / Forced，Forced 再分三项
  l2((2.00, 6.38), (2.00, 6.05))
  l2((1.20, 6.05), (2.95, 6.05))
  l2((1.20, 6.05), (1.20, 5.80))
  l2((2.95, 6.05), (2.95, 5.80))
  node((1.20, 5.50), 0.50, 0.30, [Natural], fs: 6.0)
  node((2.95, 5.50), 0.50, 0.30, [Forced], fs: 6.0)
  l2((2.95, 5.20), (2.10, 5.20))
  l2((2.10, 5.20), (2.10, 2.30))
  for it in ((4.35, [Air channel \ modifications]), (3.35, [Fin addition]),
    (2.30, [Cell arrangement \ modification])) {
    l2((2.10, it.at(0)), (2.40, it.at(0)))
    node((3.15, it.at(0)), 0.82, 0.30, it.at(1), fs: 5.2)
  }

  // Liquid-Cooling / PCM / Thermoelectric 子树：各两个子项
  let leaves = (
    (5.95, ((4.95, 0.88, [Cold Plate Cooling]), (7.00, 0.80, [Micro Channel \ Cooling]))),
    (10.00, ((9.00, 0.90, [Air-cooling PCM \ hybrid]), (11.00, 0.90, [Liquid-cooling PCM \ hybrid]))),
    (14.00, ((13.00, 0.74, [Thermoelectric \ Cooler (TEC)]), (15.00, 0.74, [Thermoelectric \ Generator (TEG)]))),
  )
  for br in leaves {
    let px = br.at(0)
    l2((px, 6.38), (px, 5.95))
    l2((br.at(1).at(0).at(0), 5.95), (br.at(1).at(1).at(0), 5.95))
    for lf in br.at(1) {
      l2((lf.at(0), 5.95), (lf.at(0), 5.47))
      node((lf.at(0), 5.15), lf.at(1), 0.32, lf.at(2), fs: 5.0)
    }
  }
})
