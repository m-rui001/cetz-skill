#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 编译外观：双面板线稿平涂。(a) 上半左为竖直两段切口骨架（上段支撑盘管、下段三角锯齿），
// 顶/底/中框架横线、右侧 L 尺寸与七条引线标签；上半右为同心双圆截面，四色点 L 下标、
// 两条过心斜线标 Neutral Axis/Plane；中下红色放大引线连切口块，标 H、α、w、H_w、H_n；(a) 居中下方。
// (b) 左虚线框：硬币线稿+25mm+细杆、透明管插图三标签、分段灰臂+橙色虚线放大框；
// 右上虚线框黄色刚柔交替条+双括弧；右下虚线框 Bending cell、CAD 环、开槽环与红色尺寸；(b) 居中下方。
// 来源：Unlocking the Potential of Cable-Driven Continuum Robots: A Comprehensive Review and Future
//   Directions. Actuators 2024, 13, 52, Figure 5. DOI 10.3390/act13020052.
#canvas({
  import draw: *
  // 共享助手：椭圆弧（arc 锚点在起点）/ 标签+引线 / 双向尺寸 / 黑点
  let earch(c, rx, ry, a0, a1, ..st) = arc((c.at(0) + rx * calc.cos(a0), c.at(1) + ry * calc.sin(a0)), radius: (rx, ry), start: a0, stop: a1, ..st)
  let tag(body, at, tgt, anchor: "west") = { content(at, body, anchor: anchor); if tgt != none { line(at, tgt, stroke: 0.5pt) } }
  let dim(a, b, col: black) = line(a, b, stroke: col + 0.6pt, mark: (start: "stealth", end: "stealth"))
  let dot(p, col, r) = circle(p, radius: r, fill: col, stroke: none)
  let dsh = (dash: "dashed", thickness: 1pt)
  let mag = rgb("#d040c0")
  // (a) 上段 Second Segment：管体＋水平支撑盘（循环）
  rect((2.7, 10.9), (3.3, 14.0), fill: rgb("#cfe3da"), stroke: rgb("#446655") + 0.6pt)
  for i in range(7) { rect((2.62, 11.2 + i * 0.4), (3.38, 11.28 + i * 0.4), fill: rgb("#86c28a"), stroke: rgb("#3a7a44") + 0.4pt) }
  // (a) 下段 First Segment：管体＋三角锯齿折线
  rect((2.7, 7.7), (3.3, 10.9), fill: rgb("#cfe3da"), stroke: rgb("#446655") + 0.6pt)
  let zz = ((2.7, 7.75),)
  for i in range(9) { zz.push((if calc.rem(i, 2) == 0 { 3.3 } else { 2.7 }, 7.75 + (i + 1) * 0.35)) }
  line(..zz, stroke: rgb("#33507a") + 0.7pt)
  // (a) 顶/中/底框架横线与 L 竖直尺寸
  line((2.45, 14.0), (3.55, 14.0), stroke: 1pt)
  line((2.5, 10.9), (3.5, 10.9), stroke: 0.8pt)
  line((2.45, 7.7), (3.55, 7.7), stroke: 1pt)
  dim((4.05, 10.75), (4.05, 7.7))
  content((4.2, 9.2), $L$, anchor: "west")
  // (a) 骨架引线标签（逐字）
  tag([Top frame], (4.5, 14.05), (3.55, 14.0))
  tag([backbone], (4.6, 13.0), (3.32, 12.9))
  tag([support disk], (4.6, 11.9), (3.4, 11.8))
  tag([Second \ Segment], (2.2, 12.5), none, anchor: "east")
  tag([First \ Segment], (2.2, 9.0), none, anchor: "east")
  tag([Wires for tip-tool], (4.6, 9.5), (3.32, 9.3))
  tag([Top frame(Base frame)], (4.3, 10.95), (3.5, 10.9))
  tag([Base frame], (4.3, 7.45), (3.55, 7.7))
  // (a) 截面同心双圆＋圆心＋四色点与水平点线/品红竖线
  circle((9.7, 12.1), radius: 0.85, stroke: 0.7pt)
  circle((9.7, 12.1), radius: 0.6, stroke: 0.7pt)
  circle((9.7, 12.1), radius: 0.07, stroke: 0.6pt)
  line((9.7, 11.5), (9.7, 12.7), stroke: mag + 0.6pt)
  dot((9.7, 12.7), mag, 0.08)
  dot((9.7, 11.5), mag, 0.08)
  line((9.1, 12.1), (10.3, 12.1), stroke: (dash: "dotted", thickness: 0.6pt))
  dot((9.1, 12.1), red, 0.08)
  dot((10.3, 12.1), red, 0.08)
  content((9.7, 13.05), $L_(1,1)$)
  content((9.7, 11.15), $L_(1,2)$)
  content((8.8, 12.15), $L_(2,1)$, anchor: "east")
  content((10.7, 12.15), $L_(2,2)$)
  // (a) 两条过心斜线：Neutral Axis 与两处 Neutral Plane
  line((9.05, 10.95), (10.35, 13.25), stroke: 0.6pt)
  line((8.9, 12.9), (10.5, 11.3), stroke: 0.6pt)
  tag([Neutral \ Axis], (10.5, 13.3), none)
  tag([Neutral \ Plane], (8.75, 10.55), none, anchor: "north")
  tag([Neutral \ Plane], (10.7, 11.0), none)
  // (a) 红色放大引线：下段红框→放大切口块红框
  rect((2.62, 7.8), (3.38, 9.0), stroke: red + 0.7pt)
  line((3.38, 9.0), (6.6, 9.05), stroke: red + 0.6pt)
  line((3.38, 7.8), (6.6, 7.85), stroke: red + 0.6pt)
  rect((6.6, 7.8), (10.6, 9.05), stroke: red + 0.7pt)
  // (a) 切口块：两段斜灰带＋竖直虚线＋H/α/w/H_w/H_n 尺寸
  line((7.2, 8.95), (8.8, 8.7), (8.8, 8.4), (7.2, 8.65), close: true, fill: rgb("#9aa0a6"), stroke: rgb("#666666") + 0.4pt)
  line((8.8, 8.7), (10.4, 8.45), (10.4, 8.15), (8.8, 8.4), close: true, fill: rgb("#9aa0a6"), stroke: rgb("#666666") + 0.4pt)
  line((8.8, 7.85), (8.8, 9.0), stroke: (dash: "dashed", thickness: 0.5pt))
  line((9.6, 7.85), (9.6, 8.6), stroke: (dash: "dashed", thickness: 0.5pt))
  dim((7.0, 8.4), (7.0, 8.95))
  content((6.9, 8.65), $H$, anchor: "east")
  earch((7.55, 8.9), 0.35, 0.35, -90deg, -55deg, stroke: 0.5pt)
  content((7.62, 8.6), $alpha$)
  dim((8.8, 7.62), (9.6, 7.62))
  content((9.2, 7.42), $w$)
  dim((10.8, 8.5), (10.8, 9.0))
  content((10.95, 8.75), $H_w$)
  dim((10.3, 7.9), (10.3, 8.3))
  content((10.15, 8.1), $H_n$, anchor: "east")
  content((7.9, 7.0), [(a)])
  // (b) 左虚线框：硬币线稿＋25mm 红双箭头＋竖直细杆刻度
  rect((0.4, 0.6), (7.6, 6.6), stroke: dsh)
  rect((0.7, 4.5), (2.5, 6.3), fill: rgb("#e8eef7"), stroke: rgb("#557799") + 0.6pt)
  circle((1.35, 5.45), radius: 0.42, fill: rgb("#d8d8d8"), stroke: rgb("#666666") + 0.6pt)
  dim((1.05, 5.75), (1.65, 5.15), col: red)
  content((1.45, 5.85), [25mm], angle: -45deg)
  line((2.1, 4.6), (2.1, 6.2), stroke: rgb("#888888") + 1.2pt)
  for i in range(7) { line((2.03, 4.8 + i * 0.2), (2.17, 4.8 + i * 0.2), stroke: rgb("#444444") + 0.5pt) }
  // (b) 插图：透明管＋Elastic skeleton 中心杆＋Wire 红线＋Guidewire disc 环
  rect((3.0, 4.5), (7.3, 6.3), fill: rgb("#f2f5f7"), stroke: rgb("#333333") + 0.8pt)
  line((3.1, 4.75), (7.2, 5.6), (7.2, 6.15), (3.1, 5.3), close: true, fill: rgb("#dfe5ea"), stroke: rgb("#8899aa") + 0.5pt)
  line((3.7, 4.95), (6.9, 5.62), (6.9, 6.05), (3.7, 5.38), close: true, fill: rgb("#fdfeff"), stroke: rgb("#99aabb") + 0.5pt)
  line((3.8, 5.15), (6.8, 5.8), stroke: rgb("#a8b545") + 2pt)
  line((3.8, 5.05), (6.8, 5.7), stroke: red + 0.7pt)
  line((3.8, 5.27), (6.8, 5.92), stroke: red + 0.7pt)
  for x in (4.5, 5.4, 6.3) { circle((x, 5.45 + (x - 4.5) * 0.21), radius: (0.1, 0.38), stroke: rgb("#778899") + 0.6pt) }
  tag([Elastic skeleton], (5.3, 6.1), (5.3, 5.6), anchor: "south")
  tag([Wire], (3.25, 5.85), (3.9, 5.1))
  tag([Guidewire \ disc], (6.4, 5.3), (6.3, 5.55), anchor: "north")
  // (b) 分段灰臂（循环）＋红 wire 间隙＋Distal/Proximal End＋橙色虚线放大框
  rect((0.7, 0.9), (7.3, 3.9), fill: rgb("#e3e7ee"), stroke: none)
  for i in range(9) {
    let x = 1.0 + i * 0.66
    let y = 1.55 + i * 0.11
    line((x, y), (x + 0.56, y + 0.09), (x + 0.56, y + 0.62), (x, y + 0.53), close: true, fill: rgb("#9aa0a8"), stroke: rgb("#556677") + 0.5pt)
    line((x + 0.6, y + 0.15), (x + 0.6, y + 0.5), stroke: red + 0.7pt)
  }
  tag([Distal End], (0.85, 2.75), none)
  tag([Proximal End], (7.25, 1.35), none, anchor: "east")
  let od = (paint: orange, thickness: 0.8pt, dash: "dashed")
  line((3.15, 1.45), (5.5, 1.75), (5.6, 2.95), (3.25, 2.65), close: true, stroke: od)
  line((3.25, 2.65), (3.05, 4.5), stroke: od)
  line((5.6, 2.95), (7.25, 4.5), stroke: od)
  // (b) 右上虚线框：黄色刚柔交替条（循环）＋Rigid/Flexible unit 双箭头括弧
  rect((8.0, 4.9), (15.8, 6.6), stroke: dsh)
  let ux = 9.0
  for i in range(9) {
    let w = if calc.rem(i, 2) == 0 { 0.35 } else { 1.0 }
    let h = if calc.rem(i, 2) == 0 { 0.5 } else { 0.16 }
    rect((ux, 5.95 - h / 2), (ux + w, 5.95 + h / 2), fill: rgb("#e3cf16"), stroke: rgb("#a89500") + 0.5pt)
    ux += w
  }
  line((9.0, 5.5), (9.35, 5.5), stroke: 0.6pt, mark: (start: "stealth", end: "stealth", scale: 0.6))
  content((9.2, 5.2), [Rigid unit])
  dim((11.7, 5.5), (12.7, 5.5))
  content((12.2, 5.2), [Flexible unit])
  // (b) 右下虚线框左：竖直 Bending cell，绿块＋红 Wires＋Thread Eye 虚线小框
  rect((8.0, 0.6), (15.8, 4.6), stroke: dsh)
  line((8.6, 1.0), (8.6, 4.3), stroke: rgb("#99aabb") + 0.6pt)
  line((9.4, 1.0), (9.4, 4.3), stroke: rgb("#99aabb") + 0.6pt)
  earch((9.0, 4.3), 0.4, 0.1, 0deg, 360deg, stroke: rgb("#99aabb") + 0.6pt)
  earch((9.0, 1.0), 0.4, 0.1, 0deg, 360deg, stroke: rgb("#99aabb") + 0.6pt)
  for y in (1.3, 2.3, 3.3) { rect((8.72, y), (9.28, y + 0.7), fill: rgb("#b7c489"), stroke: rgb("#8a9a5a") + 0.4pt) }
  for x in (8.8, 9.0, 9.2) { line((x, 1.0), (x, 4.3), stroke: red + 0.7pt) }
  for y in (2.0, 3.0) { earch((9.0, y), 0.4, 0.09, 0deg, 360deg, stroke: rgb("#667788") + 0.5pt) }
  dim((8.45, 2.2), (8.45, 2.8))
  content((8.25, 2.5), [Bending cell], angle: 90deg)
  rect((9.32, 2.55), (9.48, 3.15), stroke: (dash: "dashed", thickness: 0.6pt))
  content((9.85, 2.85), [Thread Eye], angle: 90deg)
  line((9.7, 2.85), (9.5, 2.85), stroke: 0.5pt, mark: (end: "stealth"))
  content((9.0, 0.75), [Wires])
  line((8.85, 0.95), (8.8, 1.15), stroke: red + 0.6pt)
  line((9.15, 0.95), (9.2, 1.15), stroke: red + 0.6pt)
  // (b) 中：CAD 环，Top arc 双引线、Bottom arc 引线、顶面两对齐孔黑点
  rect((10.85, 2.0), (12.35, 3.0), fill: rgb("#cfd6dc"), stroke: none)
  earch((11.6, 2.0), 0.75, 0.28, 180deg, 360deg, fill: rgb("#cfd6dc"), stroke: rgb("#667788") + 0.6pt)
  earch((11.6, 3.0), 0.75, 0.28, 0deg, 360deg, fill: rgb("#e8edf1"), stroke: rgb("#667788") + 0.6pt)
  earch((11.6, 3.0), 0.45, 0.17, 0deg, 360deg, fill: rgb("#8a949b"), stroke: rgb("#556677") + 0.5pt)
  dot((11.15, 3.05), black, 0.05)
  dot((12.05, 3.05), black, 0.05)
  tag([Top arc], (11.2, 4.15), (11.15, 3.12), anchor: "south")
  line((11.5, 4.1), (12.2, 3.2), stroke: 0.5pt, mark: (end: "stealth"))
  content((10.3, 1.5), [Bottom arc], anchor: "west")
  line((12.1, 1.55), (11.95, 1.78), stroke: 0.5pt, mark: (end: "stealth"))
  // (b) 右：开槽环，Thread eye 双红引线、R0/R1 红色尺寸、对齐孔引线
  rect((13.45, 2.0), (14.95, 3.0), fill: rgb("#cfd6dc"), stroke: none)
  earch((14.2, 2.0), 0.75, 0.28, 180deg, 360deg, fill: rgb("#cfd6dc"), stroke: rgb("#667788") + 0.6pt)
  earch((14.2, 3.0), 0.75, 0.28, 0deg, 360deg, fill: rgb("#e8edf1"), stroke: rgb("#667788") + 0.6pt)
  earch((14.2, 3.0), 0.45, 0.17, 0deg, 360deg, fill: rgb("#8a949b"), stroke: rgb("#556677") + 0.5pt)
  line((14.45, 3.25), (14.9, 3.05), (14.9, 1.9), (14.45, 2.1), close: true, fill: white, stroke: rgb("#667788") + 0.5pt)
  content((14.2, 4.3), [Thread eye], anchor: "south")
  line((14.0, 4.15), (13.7, 3.1), stroke: red + 0.7pt, mark: (end: "stealth"))
  line((14.4, 4.15), (14.6, 3.1), stroke: red + 0.7pt, mark: (end: "stealth"))
  line((14.2, 2.9), (14.75, 2.7), stroke: red + 0.8pt, mark: (end: "stealth"))
  content((14.4, 2.5), $R_0$)
  line((14.2, 2.8), (14.2, 1.4), stroke: (paint: red, thickness: 0.6pt, dash: "dashed"))
  line((14.2, 1.7), (14.45, 1.6), stroke: red + 0.7pt, mark: (end: "stealth"))
  content((14.0, 1.55), $R_1$)
  content((12.9, 0.8), [Rigid unit alignment hole])
  line((12.4, 1.0), (12.05, 3.0), stroke: 0.5pt, mark: (end: "stealth"))
  line((13.3, 1.0), (13.9, 2.2), stroke: 0.5pt, mark: (end: "stealth"))
  content((7.9, 0.15), [(b)])
})