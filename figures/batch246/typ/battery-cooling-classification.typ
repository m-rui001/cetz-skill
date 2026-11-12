#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：电池冷却系统分类树。根部 Battery Cooling System 下分四支：Air-Cooling（Natural、Forced；
// Forced 再分 Air channel modifications/Fin addition/Cell arrangement modification）、Liquid-Cooling
//（Cold Plate Cooling、Micro Channel Cooling）、PCM-Cooling（Air-cooling PCM hybrid、Liquid-cooling
// PCM hybrid）、Thermoelectric Cooling（Thermoelectric Cooler (TEC)、Thermoelectric Generator (TEG)）。
// 节点上下保留橙色弧线装饰，支路以灰色折线连接。逐字保留全部标签。
// 来源：Batteries 2024, 10, 265, Figure 1 "The battery pack cooling classification used in this study". DOI 10.3390/batteries10080265

#canvas({
  import draw: *
  let ink = black
  let orange = rgb("#e07b39")
  let gray = rgb("#9a9a9a")
  let l2(a, b) = line(a, b, stroke: 0.9pt + gray)
  let node(c, w, h, s, size: 6.6pt) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      radius: 0.05, fill: white, stroke: 0.8pt + orange)
    content(c, text(size: size)[#s], anchor: "center", frame: none)
    arc((c.at(0), c.at(1) + h + 0.04), start: 65deg, stop: 115deg, radius: w * 1.25,
      stroke: 1.2pt + orange, mode: "OPEN")
    arc((c.at(0), c.at(1) - h - 0.04), start: 245deg, stop: 295deg, radius: w * 1.25,
      stroke: 1.2pt + orange, mode: "OPEN")
  }

  // 根节点
  node((8.00, 7.85), 1.55, 0.30, [Battery Cooling System], size: 8.2pt)

  // 四支主类
  let parents = ((2.00, [Air-Cooling]), (5.95, [Liquid-Cooling]),
    (10.00, [PCM-Cooling]), (14.00, [Thermoelectric \ Cooling]))
  l2((8.00, 7.49), (8.00, 7.30))
  l2((2.00, 7.30), (14.00, 7.30))
  for p in parents {
    l2((p.at(0), 7.30), (p.at(0), 7.06))
    node((p.at(0), 6.70), 0.66, 0.34, p.at(1), size: 6.4pt)
  }

  // Air-Cooling 子树：Natural / Forced，Forced 再分三项
  l2((2.00, 6.36), (2.00, 6.05))
  l2((1.20, 6.05), (2.95, 6.05))
  l2((1.20, 6.05), (1.20, 5.82))
  l2((2.95, 6.05), (2.95, 5.82))
  node((1.20, 5.50), 0.55, 0.30, [Natural], size: 6.2pt)
  node((2.95, 5.50), 0.55, 0.30, [Forced], size: 6.2pt)
  l2((2.95, 5.20), (2.10, 5.20))
  l2((2.10, 5.20), (2.10, 2.30))
  for it in ((4.35, [Air channel \ modifications]), (3.35, [Fin addition]),
    (2.30, [Cell arrangement \ modification])) {
    l2((2.10, it.at(0)), (2.28, it.at(0)))
    node((3.15, it.at(0)), 0.87, 0.30, it.at(1), size: 5.8pt)
  }

  // Liquid-Cooling / PCM / Thermoelectric 子树：各两个子项
  let leaves = (
    (5.95, ((5.10, [Cold Plate Cooling]), (6.80, [Micro Channel \ Cooling]))),
    (10.00, ((9.15, [Air-cooling PCM \ hybrid]), (10.85, [Liquid-cooling PCM \ hybrid]))),
    (14.00, ((13.10, [Thermoelectric \ Cooler (TEC)]), (14.90, [Thermoelectric \ Generator (TEG)]))),
  )
  for br in leaves {
    let px = br.at(0)
    l2((px, 6.36), (px, 5.95))
    l2((br.at(1).at(0).at(0), 5.95), (br.at(1).at(1).at(0), 5.95))
    for lf in br.at(1) {
      l2((lf.at(0), 5.95), (lf.at(0), 5.47))
      node((lf.at(0), 5.15), 0.80, 0.30, lf.at(1), size: 5.8pt)
    }
  }
})
