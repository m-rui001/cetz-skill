// 编译效果：2×2 四联缆绳约束连续体骨架图。(a) 直/弯骨架盘间距示意，红色 d、d+α、d−α 尺寸线与斜纹地面；(b) 三平台+水平骨架+斜拉约束缆，红色 F1、F2、F1'、F2'；(c) 试验台线稿：底座+竖直骨架+双平台；(d) CAD 线稿：三盘直栈与弯构型、盘间交叉缆。来源：Actuators 2024, 13(2), 52, Fig. 13。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Arial", "Segoe UI"), size: 10pt)

#let RED = rgb("#D40000")
#let TAN = rgb("#8a6a3b")
#let GRAY = rgb("#777777")
#let BLUE = rgb("#1878c8")

#canvas({
  import draw: *

  // 黑/红/蓝文字标签
  let tag(p, body, color: black, anchor: "center",
    size: 10pt) = content(p, text(fill: color, size: size, weight: "bold", body), anchor: anchor)

  // 斜纹固支地面
  let ground(x0, x1, y: 0) = {
    line((x0, y), (x1, y), stroke: 1.2pt)
    for i in range(0, calc.floor((x1 - x0) / 0.28)) {
      let x = x0 + 0.14 + i * 0.28
      line((x, y), (x - 0.22, y - 0.22), stroke: 0.9pt)
    }
  }

  // 倾斜间距盘的两端点坐标
  let ends(c, hw, ang) = {
    let e = (hw * calc.cos(ang), hw * calc.sin(ang))
    ((c.at(0) - e.at(0), c.at(1) - e.at(1)), (c.at(0) + e.at(0), c.at(1) + e.at(1)))
  }

  // 端点带实心圆的间距盘（可倾斜）
  let disk(c, hw, ang: 0deg) = {
    let (a, b) = ends(c, hw, ang)
    line(a, b, stroke: 1.4pt)
    circle(a, radius: 0.06, fill: black, stroke: none)
    circle(b, radius: 0.06, fill: black, stroke: none)
  }

  // 带中心毂与环布孔的 CAD 圆盘
  let plate(c, rx, ry) = {
    circle(c, radius: (rx, ry), fill: rgb("#eeeeee"), stroke: 0.9pt)
    circle(c, radius: 0.12, fill: white, stroke: 0.8pt)
    for i in range(0, 10) {
      let a = i * 36deg
      circle((c.at(0) + rx * 0.7 * calc.cos(a), c.at(1) + ry * 0.7 * calc.sin(a)),
        radius: 0.035, fill: white, stroke: 0.5pt)
    }
  }

  // 骨架杆与棕色缆绳
  let rod(a, b) = line(a, b, stroke: (paint: GRAY, thickness: 3.5pt))
  let cable(a, b) = line(a, b, stroke: (paint: TAN, thickness: 1pt))

  // 红色尺寸线+标签
  let dim(a, b, label, lp, anchor: "center") = {
    line(a, b, stroke: (paint: RED, thickness: 1pt))
    tag(lp, label, color: RED, anchor: anchor)
  }

  // 红色力箭头+标签
  let force(a, b, label, lp, anchor: "center") = {
    line(a, b, stroke: (paint: RED, thickness: 1.6pt), mark: (end: ">", fill: RED))
    tag(lp, label, color: RED, anchor: anchor)
  }

  // 固支脚三角
  let foot(x) = line((x - 0.22, 0), (x + 0.22, 0), (x, 0.3), close: true, fill: black, stroke: none)

  // (a) 直骨架与右弯骨架：盘间距 d、d+α、d−α 及虚线弧
  let panel-a() = {
    let d = 1.5
    ground(0.2, 3.2); foot(1.7)
    line((1.7, 0), (1.7, 2 * d), stroke: (paint: black, thickness: 3pt))
    disk((1.7, d), 0.95); disk((1.7, 2 * d), 0.95)
    dim((1.25, d), (1.25, 2 * d), $d$, (1.95, 1.5 * d))
    dim((2.15, 0), (2.15, d), $d$, (2.45, 0.5 * d))
    ground(3.7, 6.6); foot(4.7)
    bezier((4.7, 0), (5.6, 2.9), (4.75, 1.2), (5.0, 2.2), stroke: (paint: black, thickness: 3pt))
    let (m0, m1) = ends((4.95, 1.5), 0.85, -20deg)
    let (t0, _) = ends((5.6, 2.9), 0.9, -40deg)
    disk((4.95, 1.5), 0.85, ang: -20deg)
    disk((5.6, 2.9), 0.9, ang: -40deg)
    dim(t0, m0, $d + alpha$, (4.0, 2.6), anchor: "east")
    dim(m1, (5.15, 0), $d - alpha$, (5.95, 0.6), anchor: "west")
    bezier(t0, m0, (4.3, 2.6), (4.4, 1.9), stroke: (dash: "dashed", thickness: 0.7pt))
    bezier(m1, (5.15, 0), (5.35, 0.9), (5.3, 0.4), stroke: (dash: "dashed", thickness: 0.7pt))
  }

  // (b) 三平台、水平骨架、对角约束缆与四个红色力
  let panel-b() = {
    for x in (0.7, 3.1, 5.5) {
      rect((x - 0.11, 0), (x + 0.11, 3.2), fill: rgb("#dddddd"), stroke: 0.9pt)
    }
    rod((0.7, 1.6), (5.5, 1.6))
    cable((0.85, 2.85), (5.35, 0.75))
    force((0.85, 2.85), (2.5, 2.85), $F_2'$, (1.7, 3.15))
    force((0.85, 2.85), (0.85, 1.95), $F_1'$, (1.1, 2.4), anchor: "west")
    force((5.35, 0.75), (5.35, 1.65), $F_1$, (5.1, 1.2), anchor: "east")
    force((5.35, 0.75), (3.7, 0.75), $F_2$, (4.5, 0.45))
    tag((1.5, -0.35), [Platform 1], color: BLUE)
    tag((4.6, 3.5), [Platform 2], color: BLUE)
  }

  // (c) 试验台线稿：底座、竖直骨架、双平台与细缆
  let panel-c() = {
    ground(0.3, 3.6)
    rect((0.9, 0), (2.9, 0.3), fill: rgb("#dddddd"), stroke: 0.9pt)
    rod((1.9, 0.3), (1.9, 2.7))
    cable((1.05, 0.3), (0.95, 2.6)); cable((2.75, 0.3), (2.85, 2.6))
    cable((1.05, 0.3), (2.85, 2.6))
    for y in (1.4, 2.7) { plate((1.9, y), 1.0, 0.28) }
  }

  // (d) CAD 线稿：三盘直栈与弯构型，盘间交叉缆
  let panel-d() = {
    let ys = (0.35, 1.65, 2.95)
    rod((1.6, ys.at(0)), (1.6, ys.at(2)))
    for i in range(0, 2) {
      cable((0.95, ys.at(i) + 0.2), (2.25, ys.at(i + 1) - 0.2))
      cable((2.25, ys.at(i) + 0.2), (0.95, ys.at(i + 1) - 0.2))
    }
    for y in ys { plate((1.6, y), 1.0, 0.26) }
    plate((4.7, 0.35), 1.05, 0.22)
    bezier((4.7, 0.45), (5.8, 2.5), (4.75, 1.5), (5.1, 2.1), stroke: (paint: GRAY, thickness: 3.5pt))
    cable((3.8, 0.45), (6.2, 1.75)); cable((5.6, 0.45), (5.2, 1.75))
    plate((5.8, 2.5), 0.8, 0.9)
  }

  // 面板表驱动 2×2 布局与 (a)-(d) 字母
  let panels = (
    (at: (0, 0), cx: 3.4, fn: panel-a, letter: [(a)]),
    (at: (7.3, 0), cx: 3.1, fn: panel-b, letter: [(b)]),
    (at: (0, -4.5), cx: 1.95, fn: panel-c, letter: [(c)]),
    (at: (7.3, -4.5), cx: 3.6, fn: panel-d, letter: [(d)]),
  )
  for p in panels {
    scope({
      translate(p.at)
      (p.fn)()
      tag((p.cx, -0.75), p.letter, size: 11pt)
    })
  }
})
