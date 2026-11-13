#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 逆喷流凹腔减阻/隔热原理图：左端自由来流箭头压向脱体激波弧，机体凹腔开口朝右接逆喷流；
// 孔口立一道马赫盘、上下张开桶形激波，孔口两侧各一个回流涡，凹腔上下端各一段再压缩激波，
// 七个英文标签用细引线指到对应结构；通体黑白线稿、无填充色块。
// 来源：Aerospace 2026, 13, 47, Figure 1 "Reverse-Jet Principal Schematic". DOI 10.3390/aerospace13010047

#canvas({
  import draw: *

  // —— 地标：对称轴、孔口、凹腔壁、喷孔上下壁 ——
  let axis = 3.44
  let mouth = 5.59
  let cav = 6.62
  let s0 = 3.28
  let s1 = 3.62

  // 细引线＋右对齐标签助手
  let callout(body, from, to) = {
    line(from, to, stroke: 0.45pt, mark: (end: (symbol: "stealth", length: 0.10, width: 0.07, inset: 0.03, fill: black)))
    content((from.at(0) - 0.08, from.at(1)), anchor: "east", text(size: 8.5pt, body))
  }

  // 圆弧助手：给定圆心与起止角（arc 的定位点在弧起点上）
  let ring(center, a0, a1, r, ..style) = {
    let p = (center.at(0) + r * calc.cos(a0), center.at(1) + r * calc.sin(a0))
    arc(p, start: a0, stop: a1, radius: r, ..style)
  }

  // 脱体激波：机体前方左凸大圆弧
  ring((7.40, axis), 113deg, 246deg, 2.03, stroke: 1.4pt)
  // 机体凹腔外壁：右凸大圆弧，上下端敞口
  ring((9.15, axis), 89deg, 268deg, 2.53, stroke: 1.4pt)
  // 再压缩激波：凹腔上下端各一段短弧
  bezier((7.95, 6.40), (7.05, 6.00), (6.78, 5.36), (6.89, 4.96), stroke: 1.4pt)
  bezier((8.05, 0.55), (7.10, 0.88), (6.84, 1.52), (6.95, 1.97), stroke: 1.4pt)
  // 喷孔上下壁：孔口直通凹腔
  line((mouth, s1), (cav, s1 - 0.02), stroke: 1.4pt)
  line((mouth, s0), (cav, s0 + 0.02), stroke: 1.4pt)
  // 马赫盘：孔口处一道竖粗线
  line((mouth, s0 - 0.01), (mouth, s1 + 0.01), stroke: 2.6pt)
  // 桶形激波：孔口上下张开的粗曲线
  bezier((mouth, s1), (5.70, 3.88), (5.85, 4.20), (6.05, 4.37), stroke: 1.4pt)
  bezier((mouth, s0), (5.70, 3.02), (5.85, 2.70), (6.05, 2.51), stroke: 1.4pt)
  // 回流涡：上顺、下逆的环形箭头
  ring((6.27, 4.03), 333deg, 112deg, 0.30, stroke: 0.8pt,
    mark: (end: (symbol: "stealth", length: 0.13, width: 0.10, inset: 0.03, fill: black)))
  ring((6.19, 2.88), 30deg, 254deg, 0.30, stroke: 0.8pt,
    mark: (end: (symbol: "stealth", length: 0.13, width: 0.10, inset: 0.03, fill: black)))
  // 自由来流箭头（左→右）
  line((2.27, 3.37), (4.05, 3.37), stroke: 1.3pt,
    mark: (end: (symbol: "stealth", length: 0.26, width: 0.20, inset: 0.09, fill: black)))
  // 逆喷流箭头（右→左）
  line((8.73, 3.47), (6.87, 3.47), stroke: 1.3pt,
    mark: (end: (symbol: "stealth", length: 0.26, width: 0.20, inset: 0.09, fill: black)))
  // 六个引线标签
  callout([recompression shock wave], (4.90, 6.10), (6.93, 5.76))
  callout([recirculation region], (4.66, 5.07), (6.26, 3.97))
  callout([Mach disk], (4.13, 4.00), (5.55, 3.50))
  callout([detached shock wave], (3.84, 2.83), (5.39, 3.15))
  callout([barrel shaped shock wave], (4.45, 1.89), (5.96, 2.55))
  callout([shear layer], (4.16, 0.96), (6.26, 2.86))
  // 无引线标签：来流与逆喷流
  content((2.67, 3.66), anchor: "center", text(size: 8.5pt, [free-flowing]))
  content((7.82, 3.76), anchor: "center", text(size: 8.5pt, [reverse jet]))
})
