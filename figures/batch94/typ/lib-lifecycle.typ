// 编译效果：一条品红粗链从左上到右下串起 7 个描边圆圈节点（1→6 加底部 0），
// 节点内含极简线稿图标，右侧为编号+英文标签；三条嵌套回环弧（紫/蓝/青绿）
// 分别从节点 2/3/5 经白底彩描边椭圆标签（Recycling / Repairing Healing /
// Reuse Second life）绕左下回到节点 0，另有一条橙黄弧从节点 5 绕右下回到 0。
// 来源：A Review of Lithium-Ion Battery Recycling: Technologies, Sustainability,
// and Open Issues. Batteries 2024, 10(1), 38. DOI 10.3390/batteries10010038, Figure 3。
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10.5pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 调色板（近似原图）
#let MAG = rgb("#E021C8")
#let PUR = rgb("#7A1FD0")
#let BLU = rgb("#3A6FD8")
#let TEA = rgb("#17C3B2")
#let ORA = rgb("#F5B800")
#let INK = rgb("#1a1a1a")

// 语义坐标：主链等步长对角排布，节点 0 在底部
#let STEP = (1.15, -0.75)
#let CHAIN = (
  ("1", [Mining for Critical Raw Materials], "pickaxe"),
  ("2", [LIB components fabrication], "molecules"),
  ("3", [LIB manufacturing], "cell-teal"),
  ("4", [End use], "laptop-car"),
  ("5", [Waste LIBs], "cell-pink"),
  ("6", [Landfill disposal], "truck"),
)
#let NODES = CHAIN.enumerate().map(((i, it)) => (
  num: it.at(0), label: it.at(1), icon: it.at(2),
  pos: (i * STEP.at(0), i * STEP.at(1)),
)) + ((
  num: "0", label: [Waste LIB collection and\ pretreatments], icon: "tools",
  pos: (3.95, -5.15),
),)

// 回环弧表：颜色、起点、终点、弧经过点（即椭圆标签位置）、标签行
#let LOOPS = (
  (col: PUR, from: "2", to: "0", via: (-0.1, -2.1), lines: ("Recycling",)),
  (col: BLU, from: "3", to: "0", via: (1.1, -2.85), lines: ("Repairing", "Healing")),
  (col: TEA, from: "5", to: "0", via: (2.45, -3.7), lines: ("Reuse", "Second life")),
  (col: ORA, from: "5", to: "0", via: (5.2, -4.1), lines: none),
)

#canvas({
  import draw: *
  let ls = (paint: INK, thickness: 1.1pt)
  let add(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
  let npos(n) = NODES.find(it => it.num == n).pos

  // 极简线稿图标：内部坐标相对自身原点，调用时平移到节点中心
  let ic-pickaxe() = {
    line((-0.25, -0.1), (0.1, 0.25), stroke: ls) // 镐柄
    arc-through((-0.05, 0.3), (0.18, 0.28), (0.3, 0.1), stroke: ls) // 镐头
    line((0.02, -0.28), (0.16, -0.12), (0.3, -0.28), close: true, stroke: ls) // 矿石堆
    line((0.0, -0.28), (0.32, -0.28), stroke: ls)
  }
  let ic-molecules() = {
    line((-0.24, 0.2), (-0.24, -0.2), stroke: ls) // 层状电极片
    line((-0.12, 0.2), (-0.12, -0.2), stroke: ls)
    for y in (-0.12, 0, 0.12) { line((-0.24, y), (-0.12, y), stroke: ls) }
    for p in ((0.12, 0.2), (0.22, 0.12), (0.08, 0.08), (0.2, 0.26)) {
      circle(p, radius: 0.035, stroke: ls) // 分子团簇
    }
    line((0.02, -0.08), (0.1, -0.16), (0.18, -0.08), (0.26, -0.16), stroke: ls) // 锯齿链
  }
  let ic-cell(col) = {
    let st = (paint: col, thickness: 1.2pt)
    circle((0, 0.18), radius: (0.15, 0.05), stroke: st) // 电池芯顶盖
    line((-0.15, 0.18), (-0.15, -0.16), stroke: st)
    line((0.15, 0.18), (0.15, -0.16), stroke: st)
    arc-through((-0.15, -0.16), (0, -0.22), (0.15, -0.16), stroke: st) // 底弧
    line((0, 0.23), (0, 0.3), stroke: st) // 极耳
    line((-0.05, 0.1), (-0.05, -0.12), stroke: st) // 卷绕示意
  }
  let ic-laptop-car() = {
    line((-0.28, 0.28), (-0.28, 0.06), (0.0, 0.06), (0.0, 0.28), close: true, stroke: ls) // 笔记本屏幕
    line((-0.32, 0.0), (0.04, 0.0), stroke: ls) // 底座
    line((0.0, -0.16), (0.05, -0.16), (0.09, -0.08), (0.2, -0.08), (0.24, -0.16), (0.3, -0.16), stroke: ls) // 车身
    circle((0.08, -0.2), radius: 0.04, stroke: ls)
    circle((0.24, -0.2), radius: 0.04, stroke: ls)
  }
  let ic-truck() = {
    line((-0.02, 0.06), (0.22, 0.24), (0.3, 0.14), (0.06, -0.04), close: true, stroke: ls) // 倾斜车斗
    line((0.12, -0.08), (0.28, -0.08), (0.28, -0.16), (0.1, -0.16), stroke: ls) // 驾驶室
    circle((0.2, -0.2), radius: 0.04, stroke: ls)
    line((-0.3, -0.26), (-0.12, -0.06), (0.02, -0.26), close: true, stroke: ls) // 料堆
    for p in ((-0.16, 0.06), (-0.22, 0.0), (-0.1, 0.0)) {
      circle(p, radius: 0.02, fill: INK, stroke: none) // 落料
    }
  }
  let ic-tools() = {
    line((-0.22, -0.26), (0.12, 0.1), stroke: ls) // 螺丝刀杆
    line((0.12, 0.1), (0.26, 0.24), stroke: (paint: INK, thickness: 2.4pt)) // 手柄
    line((-0.16, 0.1), (0.2, -0.24), stroke: ls) // 扳手柄
    arc-through((-0.28, 0.12), (-0.2, 0.26), (-0.08, 0.2), stroke: ls) // 扳手开口
    arc-through((0.12, -0.28), (0.24, -0.28), (0.26, -0.16), stroke: ls)
  }
  let ICONS = (
    pickaxe: ic-pickaxe, molecules: ic-molecules,
    cell-teal: () => ic-cell(TEA), cell-pink: () => ic-cell(rgb("#E88A9A")),
    laptop-car: ic-laptop-car, truck: ic-truck, tools: ic-tools,
  )

  // 共享回环 helper：由 起点/经过点/终点 推导圆心半径画弧，经过点处放椭圆标签
  let loop-back(col, a, b, via, lines) = {
    arc-through(a, via, b, stroke: (paint: col, thickness: 2.6pt))
    if lines != none {
      circle(via, radius: (0.95, 0.28 + 0.15 * lines.len()),
        fill: white, stroke: (paint: col, thickness: 1.6pt))
      content(via, text(size: 9pt, weight: "bold", lines.join(linebreak())))
    }
  }

  // 先画四条回环弧与椭圆标签，垫在主链下面
  for lp in LOOPS {
    loop-back(lp.col, npos(lp.from), npos(lp.to), lp.via, lp.lines)
  }
  // 主链：相邻节点间的品红粗连接段
  for i in range(5) {
    line(NODES.at(i).pos, NODES.at(i + 1).pos, stroke: (paint: MAG, thickness: 3pt))
  }
  // 节点：白底描边圆圈 + 线稿图标 + 编号 + 右侧标签
  for nd in NODES {
    let zero = nd.num == "0"
    let col = if zero { ORA } else { MAG }
    circle(nd.pos, radius: 0.42, fill: white, stroke: (paint: col, thickness: 1.6pt))
    group({ translate(nd.pos); ICONS.at(nd.icon)() })
    content(add(nd.pos, (0.5, if zero { -0.35 } else { 0.15 })),
      text(size: 16pt, weight: "bold", nd.num), anchor: "south-west")
    content(add(nd.pos, (0.95, if zero { -0.45 } else { 0.28 })),
      text(nd.label), anchor: "west")
  }
})
