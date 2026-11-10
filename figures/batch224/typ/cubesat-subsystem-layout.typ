#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 编译结果：2U 立方星（UPSat）分系统布局剖视图 —— 上下横梁与五根立柱构成骨架，
// 左舱绿色 EPS 板与三只蓝色反作用轮（ADCS），中部 IAC 光学载荷圆筒穿出底板，
// 右舱 COMM/GPS 模块与 45° 展开的 GPS 天线，四道黄色 mNLP 探杆与红色天线带。
// 来源：Aerospace 2025, 12, 550, Figure 3 (UPSat subsystem layout)。DOI 10.3390/aerospace12060550。

#canvas({
  import draw: *

  // 配色
  let ink = rgb("#3a3a3a")
  let rail = rgb("#e4e4e4")
  let post = rgb("#d8d8d8")
  let blue = rgb("#1c2ed2")
  let green = rgb("#2f9e4f")
  let yellow = rgb("#e9b42c")
  let red = rgb("#bf2a22")
  let dark = rgb("#6d6d6d")

  // 助手：点 p 绕 c 旋转 a 弧度
  let rot(p, c, a) = {
    let dx = p.at(0) - c.at(0)
    let dy = p.at(1) - c.at(1)
    (c.at(0) + dx * calc.cos(a) - dy * calc.sin(a), c.at(1) + dx * calc.sin(a) + dy * calc.cos(a))
  }

  // 结构框架：上下横梁 + 五根立柱 + 螺栓
  rect((0.35, 6.85), (15.20, 7.42), fill: rail, stroke: 0.6pt + ink)
  rect((0.35, 0.70), (15.20, 1.27), fill: rail, stroke: 0.6pt + ink)
  for x in (0.75, 6.45, 10.45, 11.95, 13.45) {
    rect((x, 1.27), (x + 0.55, 6.85), fill: post, stroke: 0.6pt + ink)
  }
  for (x, y) in ((7.05, 7.13), (14.35, 7.13), (7.05, 0.98), (14.35, 0.98)) {
    circle((x, y), radius: 0.11, fill: rgb("#b8b8b8"), stroke: 0.6pt + ink)
  }

  // 黄色 mNLP 探杆与红色天线展开带（四道贯穿，先画以被部件覆盖）
  for y in (7.72, 5.23, 2.88, 0.40) {
    line((0.45, y), (10.15, y), stroke: 1.3pt + yellow)
    line((10.15, y), (14.95, y), stroke: 1.3pt + red)
  }
  line((0.62, 1.15), (0.62, 6.95), stroke: 2pt + yellow)

  // 左舱：侧壁电子件、白色模块与红色电池组
  rect((1.40, 2.55), (2.75, 5.65), fill: rgb("#f3f3f3"), stroke: 0.6pt + ink)
  rect((1.55, 3.00), (2.60, 4.60), fill: white, stroke: 0.5pt + ink)
  rect((2.95, 2.15), (3.10, 4.15), fill: red, stroke: 0.4pt + ink)
  rect((1.45, 1.45), (2.25, 1.95), fill: rgb("#cfcfcf"), stroke: 0.5pt + ink)

  // ADCS：灰色转子、安装支架、绿色 EPS 板、三只蓝色反作用轮
  circle((6.28, 4.05), radius: 0.72, fill: rgb("#8e8e8e"), stroke: 0.5pt + ink)
  rect((4.50, 2.30), (6.05, 6.60), fill: rgb("#d0d0d0"), stroke: 0.6pt + ink)
  rect((4.28, 1.35), (4.46, 6.75), fill: green, stroke: 0.4pt + ink)
  for y in (5.94, 4.50, 3.08) {
    circle((5.20, y), radius: 0.53, fill: white, stroke: 3.4pt + blue)
    circle((5.20, y), radius: 0.40, stroke: 0.8pt + blue)
  }

  // IAC 光学载荷：底部透镜先画，圆筒与镜筒后画覆盖
  circle((8.92, 1.15), radius: 0.58, fill: dark, stroke: 0.5pt + ink)
  rect((8.30, 1.25), (9.55, 4.45), fill: dark, stroke: 0.6pt + ink)
  rect((8.30, 3.45), (9.55, 3.80), fill: rgb("#8a8a8a"), stroke: 0.4pt + ink)
  rect((8.55, 4.45), (9.30, 5.05), fill: rgb("#555555"), stroke: 0.5pt + ink)

  // COMM 通信机与 GPS 接收模块
  rect((11.10, 2.85), (11.85, 4.35), fill: rgb("#b5b5b5"), stroke: 0.5pt + ink)
  rect((11.20, 4.35), (11.75, 4.85), fill: rgb("#8f8f8f"), stroke: 0.5pt + ink)
  rect((12.78, 3.05), (13.42, 5.55), fill: rgb("#c6c6c6"), stroke: 0.5pt + ink)
  rect((12.90, 4.15), (13.40, 4.85), fill: rgb("#efe6c6"), stroke: 0.5pt + ink)
  rect((12.86, 3.20), (13.38, 3.70), fill: rgb("#9a9a9a"), stroke: 0.4pt + ink)

  // GPS 天线：支座、旋转贴片板、双探杆、铰链
  rect((13.98, 6.25), (14.30, 6.80), fill: post, stroke: 0.5pt + ink)
  let c = (15.95, 4.55)
  let plate = ((0.95, 0.45), (0.95, -0.45), (-0.95, -0.45), (-0.95, 0.45))
  let pts = plate.map(q => rot((c.at(0) + q.at(0), c.at(1) + q.at(1)), c, -45deg))
  line(..pts, close: true, fill: rgb("#d5d5d5"), stroke: 0.6pt + ink)
  line((14.10, 6.65), (17.35, 2.95), stroke: 1.8pt + rgb("#b06a2c"))
  line((14.45, 6.30), (17.05, 3.25), stroke: 1.8pt + rgb("#b06a2c"))
  for p in ((14.20, 6.50), (14.55, 6.15)) {
    circle(p, radius: 0.13, fill: rgb("#555555"), stroke: none)
  }

  // 标签与引线（逐字照录原图）
  let labs = (
    ("SU_mNLP", (1.50, 8.62), (2.15, 8.40), (2.42, 7.78)),
    ("EPS", (3.45, 8.02), (3.90, 7.82), (4.36, 6.85)),
    ("ADCS", (5.30, 8.62), (5.60, 8.40), (5.45, 6.58)),
    ("OBC", (7.15, 8.22), (7.40, 8.02), (6.72, 6.88)),
    ("COMM", (9.05, 8.62), (9.45, 8.40), (10.62, 6.92)),
    ("GPS", (12.35, 8.62), (12.65, 8.40), (13.15, 5.62)),
    ("GPS antenna", (14.20, 8.62), (15.50, 8.38), (15.60, 5.55)),
    ("Structure", (0.80, -0.95), (2.55, -0.80), (3.60, 1.28)),
    ("IAC", (6.45, -0.95), (7.05, -0.80), (8.75, 2.10)),
    ("Antenna System", (11.85, -0.95), (14.35, -0.80), (14.90, 0.48)),
  )
  for (t, p, s, e) in labs {
    line(s, e, stroke: 0.5pt + ink)
    content(p, text(size: 9pt, weight: "bold", fill: rgb("#1a1a1a"), t), anchor: "west")
  }
})
