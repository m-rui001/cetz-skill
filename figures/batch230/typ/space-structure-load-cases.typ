#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品: 三块奶白圆角面板纵向堆叠, 每块左端深蓝圆盘内绘白色线稿场景(地面吊装/火箭升空/月球与卫星),
// 右侧为粗体阶段名与逐条受力清单; 来源 Aerospace 2025, 12, 215, Figure 1 — Boundary and loading conditions of space structures. DOI 10.3390/aerospace12030215
#canvas({
  import draw: *

  let navy = rgb("#1e2a36")
  let paper = rgb("#fdfbf4")
  let ink = rgb("#f6f1e2")
  let st = (paint: ink, thickness: 1pt)
  let fine = (paint: ink, thickness: 0.7pt)
  let cut = (paint: navy, thickness: 0.6pt)

  // 四芒星: 两笔交叉短线
  let star(p, s) = {
    let (px, py) = p
    line((px, py + s), (px, py - s), stroke: fine)
    line((px - s * 0.6, py), (px + s * 0.6, py), stroke: fine)
  }

  // 地面操作: 机械臂吊起卫星, 右侧工作台与操作员
  let ground-art(c) = {
    let (x, y) = c
    let f = y - 1.5
    line((x - 1.95, f), (x + 1.95, f), stroke: st) // 地面基线
    rect((x - 2.05, f), (x - 1.5, f + 0.18), fill: ink, stroke: none) // 机械臂底座
    line((x - 1.78, f + 0.18), (x - 1.78, f + 0.95), stroke: st) // 立柱
    circle((x - 1.78, f + 0.95), radius: 0.08, fill: navy, stroke: (paint: ink, thickness: 0.9pt)) // 肩关节
    line((x - 1.78, f + 0.95), (x - 0.95, y + 0.7), stroke: st) // 大臂
    circle((x - 0.95, y + 0.7), radius: 0.08, fill: navy, stroke: (paint: ink, thickness: 0.9pt)) // 肘关节
    line((x - 0.95, y + 0.7), (x - 0.6, y + 0.98), stroke: st) // 小臂
    line((x - 0.6, y + 0.98), (x - 0.45, y + 1.08), stroke: fine) // 夹爪
    line((x - 0.6, y + 0.98), (x - 0.45, y + 0.86), stroke: fine)
    rect((x - 0.5, y + 0.95), (x + 0.12, y + 1.38), fill: ink, stroke: none) // 卫星本体
    line((x - 1.05, y + 1.16), (x - 0.5, y + 1.16), stroke: st) // 左侧太阳翼连杆
    line((x + 0.12, y + 1.16), (x + 0.62, y + 1.16), stroke: st) // 右侧太阳翼连杆
    rect((x - 1.5, y + 1.02), (x - 1.05, y + 1.3), stroke: fine) // 左太阳翼
    rect((x + 0.62, y + 1.02), (x + 1.07, y + 1.3), stroke: fine) // 右太阳翼
    line((x - 0.2, y + 1.38), (x - 0.2, y + 1.6), stroke: fine) // 卫星天线
    rect((x + 0.5, f + 0.68), (x + 1.35, f + 0.78), fill: ink, stroke: none) // 工作台面
    line((x + 0.58, f + 0.68), (x + 0.58, f), stroke: fine) // 台腿
    line((x + 1.27, f + 0.68), (x + 1.27, f), stroke: fine)
    rect((x + 0.62, f + 0.78), (x + 1.15, f + 1.18), fill: ink, stroke: none) // 显示器
    line((x + 0.68, f + 1.0), (x + 1.09, f + 1.0), stroke: cut) // 屏幕分线
    circle((x + 1.72, f + 1.46), radius: 0.12, fill: ink, stroke: none) // 操作员头部
    line((x + 1.72, f + 1.34), (x + 1.72, f + 0.6), stroke: st) // 躯干
    line((x + 1.72, f + 0.6), (x + 1.6, f), stroke: st) // 双腿
    line((x + 1.72, f + 0.6), (x + 1.84, f), stroke: st)
    line((x + 1.72, f + 1.12), (x + 1.42, f + 0.95), stroke: fine) // 手臂
  }

  // 飞行操作: 运载火箭与两侧助推器、尾焰、底部烟雾
  let flight-art(c) = {
    let (x, y) = c
    rect((x - 0.26, y - 1.2), (x + 0.26, y + 1.15), fill: ink, stroke: none) // 箭体
    line((x - 0.26, y + 1.15), (x, y + 1.8), (x + 0.26, y + 1.15), close: true, fill: ink, stroke: none) // 整流罩
    line((x - 0.26, y + 0.5), (x + 0.26, y + 0.5), stroke: cut) // 箭体环带
    line((x - 0.26, y - 0.3), (x + 0.26, y - 0.3), stroke: cut)
    line((x, y - 1.2), (x, y + 1.15), stroke: cut) // 中缝
    circle((x, y + 0.85), radius: 0.07, fill: navy, stroke: none) // 舷窗
    for s in (-1, 1) {
      rect((x + s * 0.3, y - 0.9), (x + s * 0.6, y + 0.55), fill: ink, stroke: none) // 助推器
      line((x + s * 0.6, y + 0.55), (x + s * 0.45, y + 0.92), (x + s * 0.3, y + 0.55), close: true, fill: ink, stroke: none)
      line((x + s * 0.3, y + 0.02), (x + s * 0.6, y + 0.02), stroke: cut) // 助推器环带
      line((x + s * 0.3, y - 0.9), (x + s * 0.45, y - 1.35),
        (x + s * 0.6, y - 0.9), close: true, fill: ink, stroke: none) // 尾焰
    }
    line((x - 0.22, y - 1.2), (x, y - 1.85), (x + 0.22, y - 1.2), close: true, fill: ink, stroke: none) // 主尾焰
    for (dx, r) in ((-1.5, 0.32), (-1.05, 0.44), (1.05, 0.44), (1.5, 0.32)) {
      circle((x + dx, y - 1.95), radius: r, fill: ink, stroke: (paint: navy, thickness: 0.8pt)) // 底部烟雾团
    }
  }

  // 空间操作: 月球(陨石坑+阴影排线)与小卫星
  let space-art(c) = {
    let (x, y) = c
    let mr = 1.55 // 月球半径
    circle((x - 0.4, y - 0.3), radius: mr, fill: ink, stroke: none) // 月球
    for (dx, dy,
      r) in ((-0.95, 0.4, 0.18), (-0.5, -0.15, 0.13), (-1.05, -0.45, 0.1), (-0.35, 0.85, 0.08), (-0.8, -0.9, 0.09)) {
      circle((x + dx, y + dy), radius: r, fill: navy, stroke: none) // 陨石坑
    }
    for k in range(7) {
      let yy = y - 1.05 + k * 0.36
      let d = calc.sqrt(calc.max(0, mr * mr - (yy - (y - 0.3)) * (yy - (y - 0.3))))
      line((x - 0.4 + d - 0.66, yy), (x - 0.4 + d - 0.14, yy), stroke: (paint: navy, thickness: 0.7pt)) // 明暗界线排线
    }
    group({ // 独立作用域, 旋转不外溢
      rotate(-20deg, origin: (x + 1.38, y + 1.42))
      circle((x + 1.38, y + 1.42), radius: (0.62, 0.17), stroke: fine) // 卫星环
    })
    rect((x + 1.25, y + 1.32), (x + 1.51, y + 1.52), fill: ink, stroke: none) // 卫星本体
    line((x + 1.22, y + 1.42), (x + 1.04, y + 1.42), stroke: fine) // 小翼
    line((x + 1.54, y + 1.42), (x + 1.72, y + 1.42), stroke: fine)
  }

  // 三阶段数据: 标题、逐字条目、场景绘制函数、星点(相对圆心)
  let panels = (
    (title: "Ground operations", art: ground-art,
      sparks: ((-1.7, 1.35, 0.1), (-1.1, 1.85, 0.07), (2.0, 0.85, 0.11), (-1.85, -0.55, 0.08), (1.35, 1.8, 0.09)),
      items: ("Vibrations", "Mechanical loading", "Hail impact", "Lightning strike", "Fire")),
    (title: "Flight operations", art: flight-art,
      sparks: ((-1.7, 1.45, 0.11), (-1.0, 1.9, 0.07), (1.85, 1.1, 0.12), (1.5, -1.2, 0.08), (-1.7, -0.7, 0.09), (2.0, 0.2, 0.07)),
      items: ("Vibrations", "Mechanical shock", "Thermal fluctuation", "Rain erosion",
        "Bird strike, hail impact", "Space debris impact", "Lightning strike", "Fire")),
    (title: "Space operations", art: space-art,
      sparks: ((-1.8, 1.2, 0.1), (-1.35, 1.72, 0.07), (1.95, 0.55, 0.1), (1.5, -1.6, 0.08), (-1.68, -0.78, 0.09), (0.95, 2.0, 0.07)),
      items: ("Vibrations", "Mechanical shock", "Thermal fluctuation", "Atomic oxygen",
        "Space debris impact", "Vacuum conditions", "Space dust", "Fire")),
  )

  for (i, p) in panels.enumerate() {
    let top = 20.5 - i * 6.95
    let my = top - 3.3
    // 圆角面板底板
    content((0, top),
      box(width: 13.2cm, height: 6.6cm, radius: 0.4cm, fill: paper, stroke: (paint: navy, thickness: 1pt)), anchor: "north-west")
    // 深蓝圆盘底与场景线稿
    circle((3.15, my), radius: 2.6, fill: navy, stroke: none)
    (p.art)((3.15, my))
    for (dx, dy, s) in p.sparks { star((3.15 + dx, my + dy), s) }
    // 阶段名与受力条目
    let hy = top - 1.05
    content((7.05, hy), text(size: 12pt, weight: "bold", p.title), anchor: "west")
    for (k, it) in p.items.enumerate() {
      let yy = hy - 0.8 - k * 0.58
      circle((7.12, yy), radius: 0.055, fill: navy, stroke: none)
      content((7.4, yy), text(size: 11pt, it), anchor: "west")
    }
  }
})
