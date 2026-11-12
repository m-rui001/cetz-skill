#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 太阳热推进（STP）系统示意图：太阳光聚焦→加热推进剂→推力器喷出动能
// 来源：Aerospace 2024, 11(7), 502, Figure 40（CAD 渲染转干净线稿平涂；DOI 10.3390/aerospace11070502）
#canvas({
  import draw: *

  // —— 配色常量 ——
  let c-conc = rgb("#FCFC62")  // 聚光器浅黄
  let c-abs = rgb("#F6A623")   // 吸收器橙黄
  let c-thr = rgb("#F47421")   // 推力器橙红
  let c-ray = rgb("#E63329")   // 光路/能量箭头红
  let c-prop = rgb("#2B35AF")  // 推进剂箭头蓝

  // —— 助手 1：椭圆折线点集（支持旋转） ——
  let ep-pts(center, rx, ry, rot) = {
    let out = ()
    for i in range(0, 72) {
      let t = i * 5deg
      let x = rx * calc.cos(t)
      let y = ry * calc.sin(t)
      out.push((
        center.at(0) + x * calc.cos(rot) - y * calc.sin(rot),
        center.at(1) + x * calc.sin(rot) + y * calc.cos(rot),
      ))
    }
    out
  }

  // —— 助手 2：实心水平箭头（杆高 sw、头宽 hw、头长 hl） ——
  let harrow(x0, x1, y, sw, hw, hl, fc) = {
    let xs = x1 - hl
    line((x0, y + sw / 2), (xs, y + sw / 2), (xs, y + hw / 2), (x1, y),
      (xs, y - hw / 2), (xs, y - sw / 2), (x0, y - sw / 2),
      fill: fc, stroke: none, close: true)
  }

  // 地标：聚光器中心
  let E = (4.5, 3.0)

  // 1 聚光器：倾斜椭圆浅黄平涂
  line(..ep-pts(E, 2.0, 2.45, -20deg), close: true, fill: c-conc, stroke: black)
  // 2 椭圆内倾斜文字
  content(E, [Concentrator], angle: -55deg)

  // 3 未聚焦太阳光：两条红细线自上而下
  line((4.75, 8.35), (4.75, 4.75), stroke: (paint: c-ray, thickness: 0.9pt))
  line((5.7, 8.35), (5.7, 4.25), stroke: (paint: c-ray, thickness: 0.9pt))

  // 4 椭圆内聚焦光路斜线
  line((4.75, 4.75), (5.7, 1.55), stroke: (paint: c-ray, thickness: 0.9pt))

  // 5 聚焦太阳光：两条带箭头红线指向吸收器左端
  line((6.6, 4.0), (8.8, 3.5), stroke: (paint: c-ray, thickness: 0.9pt),
    mark: (end: "stealth", fill: c-ray))
  line((6.8, 2.2), (8.8, 2.7), stroke: (paint: c-ray, thickness: 0.9pt),
    mark: (end: "stealth", fill: c-ray))

  // 6 吸收器/换热器：筒身 + 左端圆 + 右端面椭圆
  rect((9.7, 2.2), (15.5, 4.4), fill: c-abs, stroke: black)
  circle((9.7, 3.3), radius: 1.1, fill: c-abs, stroke: black)
  line(..ep-pts((15.5, 3.3), 0.5, 1.1, 0deg), close: true, fill: c-abs, stroke: black)
  // 7 吸收器标签
  content((12.7, 3.65), [Absorber/])
  content((12.7, 2.95), [Heat Exchanger])

  // 8 推进剂（氢气）蓝色下行实心箭头
  line((13.15, 7.55), (13.55, 7.55), (13.55, 5.25), (13.8, 5.25),
    (13.35, 4.35), (12.9, 5.25), (13.15, 5.25),
    fill: c-prop, stroke: none, close: true)
  content((13.4, 7.9), [Propellant (GH2)])

  // 9 推力器：左窄右宽梯形（加宽以容纳标签）
  line((16.6, 3.95), (18.1, 4.35), (18.1, 2.25), (16.6, 2.65),
    fill: c-thr, stroke: black, close: true)
  content((17.35, 3.3), text(size: 8pt)[Thruster])

  // 10 红色气流箭头：吸收器出口→推力器左缘
  harrow(15.55, 16.6, 3.3, 0.3, 0.72, 0.25, c-ray)

  // 11 推力器出口短管
  rect((18.1, 2.98), (18.32, 3.62), fill: c-ray, stroke: black)

  // 12 红色动能箭头：出口→右
  harrow(18.32, 19.9, 3.3, 0.36, 0.9, 0.45, c-ray)

  // 13 其余文字标签
  content((5.25, 8.95), [Unfocused])
  content((5.25, 8.5), [Solar Energy])
  content((7.75, 5.35), [Focused])
  content((7.75, 4.9), [Solar Energy])
  content((19.15, 4.95), [Kinetic])
  content((19.15, 4.5), [Energy])
})
