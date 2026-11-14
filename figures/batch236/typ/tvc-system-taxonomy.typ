#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 编译结果：白底黑线框图，顶部一个总标题框「Thrust vector control systems」，
// 经一条横向母线分出 5 个一级类别框，各框下再用左侧竖轨挂 2~4 个二级方案框；
// 全部为加粗无衬线文字、细实线框与折线连接，无填充色。
// 来源：Aerospace 2024, 11(9), 739, Figure 20 "Various thrust vector control systems of rockets".
// DOI: 10.3390/aerospace11090739

#canvas({
  import draw: *

  // 共享助手：按 "上|下" 拆行，生成框内居中加粗标签
  let lbl(s, w) = block(
    width: w,
    align(center, text(size: 9.5pt, weight: "bold", s.split("|").join(linebreak()))),
  )

  // 共享助手：中心坐标 + 宽高画一个细线框并放标签
  let node(cx, cy, w, h, s) = {
    rect(
      (cx - w / 2, cy - h / 2),
      (cx + w / 2, cy + h / 2),
      stroke: (paint: black, thickness: 0.55pt),
    )
    content((cx, cy), lbl(s, w * 1cm - 0.16cm))
  }

  // 命名地标：根框、母线、一级框带、二级行距
  let root-c = (8.70, 10.00)
  let root-w = 7.00
  let root-h = 1.15
  let bus-y = 9.00
  let tier1-y = 8.00
  let tier1-w = 2.82
  let child-w = 2.64
  let child-dx = 0.63
  let box-h = 1.20
  let row0 = 6.30
  let row-step = 1.75
  let col-x(i) = 1.90 + 3.40 * i

  // 表驱动：5 个一级类别及其下挂的二级方案（逐字照录原图）
  let cols = (
    (name: "Movable|platform", kids: ("Gimbal|mechanism", "Stewart|platform", "Hinge")),
    (name: "Secondary|injection", kids: ("Liquid|injection", "Gas|injection")),
    (name: "Movable|nozzle",
      kids: ("Flexible|nozzle joint", "Ball and|socket joint", "Rotatable|offset nozzle", "Supersonic|split line")),
    (name: "Mechanical|deflection", kids: ("Jet deflector", "Jet tab", "Jetevator", "Jet vane")),
    (name: "Others", kids: ("Vernier|thruster", "Differentially|throttling")),
  )

  // 先画全部连接线：根框下引 → 横向母线 → 各列下引
  line((root-c.at(0), root-c.at(1) - root-h / 2), (root-c.at(0), bus-y), stroke: 0.55pt)
  line(
    (col-x(0), bus-y),
    (col-x(cols.len() - 1), bus-y),
    stroke: 0.55pt,
  )
  for (i, c) in cols.enumerate() {
    line((col-x(i), bus-y), (col-x(i), tier1-y + box-h / 2), stroke: 0.55pt)
  }

  // 再画各级左侧竖轨与每个子框的短横支线（子框整体右移，竖轨落在框外）
  for (i, c) in cols.enumerate() {
    let cx = col-x(i)
    let rail-x = cx - tier1-w / 2 + 0.25
    let last-y = row0 - row-step * (c.kids.len() - 1)
    line((rail-x, tier1-y - box-h / 2), (rail-x, last-y), stroke: 0.55pt)
    for (k, _) in c.kids.enumerate() {
      let y = row0 - row-step * k
      line((rail-x, y), (cx + child-dx - child-w / 2, y), stroke: 0.55pt)
    }
  }

  // 最后画框与文字，盖住线头
  node(root-c.at(0), root-c.at(1), root-w, root-h, "Thrust vector control systems")
  for (i, c) in cols.enumerate() {
    node(col-x(i), tier1-y, tier1-w, box-h, c.name)
    for (k, kid) in c.kids.enumerate() {
      node(col-x(i) + child-dx, row0 - row-step * k, child-w, box-h, kid)
    }
  }
})
