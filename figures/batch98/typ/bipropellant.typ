// 编译效果：双组元推进系统原理图。最左 Pressurant 大圆右口分上下对称两支：
// 小圆 R（左上 Pressure Regulator 斜指箭头）→ 灰圆角矩形 Fuel/Oxidizer Tank →
// 小圆 V（左上 Flow Control 斜指箭头）→ 汇入燃烧室左壁中点小圆 I（下方 Injector 上指箭头）；
// 浅灰燃烧室矩形内左灰带 + Combustion 文字与蓝色星芒、右侧竖直虚线、Gaseous Products 跨虚线流箭头；
// 右壁接收缩-扩张喷管（上下镜像 bezier），上方 Nozzle 括号标签，出口黑色虚线右箭头 Exhaustion；
// 燃烧室上方 Combustion Chamber 括号标签。
// 来源：Propulsion Technologies for CubeSats: Review. Aerospace 2024, 11(7), 502.
// DOI 10.3390/aerospace11070502, Figure 11.
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10.5pt, weight: "bold")
#import "@preview/cetz:0.4.2": canvas, draw

#let blue = rgb("#2A6DB5")
#let gray-fill = rgb("#D9D9D9")
#let struct = 1.2pt

#canvas(length: 1cm, {
  import draw: *
  // 语义坐标常量：主链中线、支路偏移、各段 x 位置、喷管半径参数
  let yC = 3.0
  let dy = 0.9
  let pressR = 1.25
  let branchX = 3.35
  let rX = 4.05
  let smallR = 0.4
  let tankX = 6.35
  let tankW = 3.3
  let vR = 8.75
  let mergeX = 9.45
  let iX = 10.05
  let iR = 0.42
  let chX0 = 10.45
  let chX1 = 12.85
  let chY0 = 1.7
  let chY1 = 4.3
  let dashX = 12.55
  let throatX = 15.1
  let throatR = 0.5
  let exitX = 17.8
  let exitR = 1.0
  let mir = (p) => (p.at(0), 2 * yC - p.at(1))
  let wire = (pts) => line(..pts, stroke: struct)
  // 共享 helper：带字母小圆（R/V/I）
  let reg-circle = (at, letter) => {
    circle(at, radius: smallR, stroke: struct, fill: white)
    content(at, letter)
  }
  // 共享 helper：灰底圆角贮箱矩形 + 居中标签
  let tank = (at, w, label) => {
    rect((at.at(0) - w / 2, at.at(1) - 0.525), (at.at(0) + w / 2, at.at(1) + 0.525),
      radius: 0.15, fill: gray-fill, stroke: struct)
    content(at, label)
  }
  // 共享 helper：上方括号（两端下_tick、中央上_tick）+ 居中文字
  let bracket-label = (x0, x1, y, text) => {
    line((x0, y - 0.25), (x0, y), (x1, y), (x1, y - 0.25), stroke: 0.8pt)
    line(((x0 + x1) / 2, y), ((x0 + x1) / 2, y + 0.25), stroke: 0.8pt)
    content(((x0 + x1) / 2, y + 0.32), anchor: "south", text)
  }
  // 共享 helper：指向箭头 + 起点外侧文字（向下指则文字在上，向上指则文字在下）
  let point-arrow = (from, to, text) => {
    line(from, to, stroke: 1.0pt, mark: (end: ">", fill: black, length: .25, width: .18))
    content(from, anchor: if to.at(1) < from.at(1) { "south" } else { "north" }, text)
  }
  // 共享 helper：黑色虚线流箭头 + 标签（straddle 时两行文字骑跨箭头）
  let dashed-flow = (a, b, label, straddle: false) => {
    line(a, b, stroke: (paint: black, thickness: 1.4pt, dash: "dashed"),
      mark: (end: "stealth", fill: black, length: .3, width: .22))
    let m = ((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2)
    if straddle { content(m, label) } else { content((m.at(0), m.at(1) + 0.12), anchor: "south", label) }
  }

  // 增压剂大圆 + 右口主线分叉竖线
  circle((1.5, yC), radius: pressR, stroke: struct, fill: white)
  content((1.5, yC), [Pressurant])
  wire(((1.5 + pressR, yC), (branchX, yC)))
  wire(((branchX, yC - dy), (branchX, yC + dy)))
  // 上下两支同一循环生成：R → 贮箱 → V → 汇合竖线
  for (label, s) in (("Fuel Tank", dy), ("Oxidizer Tank", -dy)) {
    let y = yC + s
    wire(((branchX, y), (rX - smallR, y)))
    reg-circle((rX, y), [R])
    wire(((rX + smallR, y), (tankX - tankW / 2, y)))
    tank((tankX, y), tankW, label)
    wire(((tankX + tankW / 2, y), (vR - smallR, y)))
    reg-circle((vR, y), [V])
    wire(((vR + smallR, y), (mergeX, y)))
  }
  wire(((mergeX, yC - dy), (mergeX, yC + dy)))
  wire(((mergeX, yC), (iX - iR, yC)))
  // 喷注器小圆 I + 下方 Injector 上指箭头；两支调节器斜指箭头
  reg-circle((iX, yC), [I])
  point-arrow((iX - 0.05, 1.6), (iX - 0.05, yC - iR - 0.05), [Injector])
  point-arrow((3.6, 4.6), (rX - 0.12, yC + dy + smallR + 0.02), [Pressure #linebreak() Regulator])
  point-arrow((8.45, 4.6), (vR - 0.08, yC + dy + smallR + 0.02), [Flow #linebreak() Control])

  // 燃烧室：浅灰矩形 + 左部灰带 + 内右竖直虚线
  rect((chX0, chY0), (chX1, chY1), fill: rgb("#F2F2F2"), stroke: 0.9pt)
  rect((chX0, chY0), (11.75, chY1), fill: gray-fill, stroke: none)
  line((dashX, chY0), (dashX, chY1), stroke: (thickness: 0.9pt, dash: "dashed"))
  // 室内左：Combustion 文字 + 蓝色爆炸星芒（for 循环尖角闭合 path）
  content((11.6, 3.5), [Combustion])
  let pts = ()
  for i in range(24) {
    let a = i * 15deg
    let r = if calc.odd(i) { 0.28 } else if calc.rem(i, 4) == 0 { 0.55 } else { 0.42 }
    pts.push((11.15 + r * calc.cos(a), 2.75 + r * calc.sin(a)))
  }
  line(..pts, close: true, fill: white, stroke: blue + 1.2pt)
  // 室内右：Gaseous Products 骑跨虚线流箭头
  dashed-flow((11.75, 2.95), (14.6, 2.95), [Gaseous #linebreak() Products], straddle: true)
  // 燃烧室上方括号标签
  bracket-label(chX0, chX1, 4.55, [Combustion Chamber])

  // 喷管：喉部/出口半径参数推导 bezier，上下镜像（收缩段 + 扩张段）
  let p0 = (chX1, chY1)
  for p in (p0, mir(p0)) {
    let s = if p.at(1) > yC { 1 } else { -1 }
    let t = (throatX, yC + s * throatR)
    let e = (exitX, yC + s * exitR)
    bezier(p, t, (p.at(0) + 0.9, p.at(1)), (throatX - 0.9, t.at(1)), stroke: struct)
    bezier(t, e, (throatX + 0.9, t.at(1)), (exitX - 0.9, e.at(1) - 0.2 * s), stroke: struct)
  }
  // 喷管上方括号标签 + 出口 Exhaustion 虚线右箭头
  bracket-label(13.6, exitX, 4.5, [Nozzle])
  dashed-flow((16.0, yC), (18.3, yC), [Exhaustion])
})