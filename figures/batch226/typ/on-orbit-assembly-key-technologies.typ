#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 编译结果：中央圆角框＋左右双向发散的思维导图线稿。一级分支用粗 S 线接入方框，
// 二级、三级标签为「文字＋下划线」，下划线以 S 弯汇入上级节点；全图纯黑细线，无填充无照片。
// 来源：Aerospace 2025, 12, 375, Figure 43 "Summary of key technologies for on-orbit assembly by space robots"。DOI 10.3390/aerospace12050375。
// (DOI 10.3390/aerospace12050375)

#let ink = rgb("#1b1b1b")
#let fs3 = 7.2pt   // 三级叶标签
#let fs2 = 7.6pt   // 二级分支
#let fs1 = 9pt     // 一级分支
#let fs0 = 10pt    // 中心标题

// 地标（cm）：中央方框四边与左右各级文字栏的贴边基准
#let bx0 = 13.55
#let bx1 = 18.35
#let bcy = 6.50
#let xl1 = 13.30    // 左侧一级文字右端
#let xr1 = 18.70    // 右侧一级文字左端
#let xl2 = 9.30     // 左侧二级文字右端
#let xr2 = 22.70    // 右侧二级文字左端
#let xl3 = 4.40     // 左侧叶文字右端
#let xr3 = 27.00    // 右侧叶文字左端

#let tls(t) = if type(t) == array { t } else { (t,) }
#let tw(t, k: 0.135) = tls(t).map(s => s.len()).fold(0, (a, b) => calc.max(a, b)) * k
#let tbody(t, s) = text(size: s, tls(t).join(linebreak()))

// 下划线相对文字中心的下沉量：随行数增加，避免压住末行
#let off(t, base, step) = base + step * (tls(t).len() - 1)

// 汇合点（纯算术，不含绘制）：各级下划线的起讫端
#let jl1(t, y) = (xl1 - tw(t, k: 0.175), y - off(t, 0.30, 0.21))
#let jr1(t, y) = (xr1 + tw(t, k: 0.175), y - off(t, 0.30, 0.21))
#let jl2(t, y) = (xl2 - tw(t, k: 0.145), y - off(t, 0.24, 0.17))
#let jr2(t, y) = (xr2 + tw(t, k: 0.145), y - off(t, 0.24, 0.17))

// 两端水平切线的 S 形连接线
#let link(a, b, w) = draw.bezier(
  a, b,
  (a.at(0) + (b.at(0) - a.at(0)) / 2, a.at(1)),
  (b.at(0) - (b.at(0) - a.at(0)) / 2, b.at(1)),
  stroke: (paint: ink, thickness: w),
)

// 左侧三级叶：右对齐文字＋下划线，下划线右端 S 弯汇入二级节点
#let leaf-l(y, t, j) = {
  draw.content((xl3 - 0.10, y), tbody(t, fs3), anchor: "east")
  draw.line((xl3 - tw(t), y - 0.22), (xl3 + 0.20, y - 0.22), stroke: (paint: ink, thickness: 0.45pt))
  link((xl3 + 0.20, y - 0.22), j, 0.45pt)
}

// 右侧三级叶：左对齐文字＋下划线，下划线左端 S 弯汇入二级节点
#let leaf-r(y, t, j) = {
  draw.content((xr3 + 0.10, y), tbody(t, fs3), anchor: "west")
  draw.line((xr3 - 0.20, y - 0.22), (xr3 + tw(t), y - 0.22), stroke: (paint: ink, thickness: 0.45pt))
  link((xr3 - 0.20, y - 0.22), j, 0.45pt)
}

// 左侧二级节点：文字＋下划线，右端 S 弯汇入一级分支
#let node-l(y, t, j) = {
  draw.content((xl2 - 0.10, y), tbody(t, fs2), anchor: "east")
  draw.line((jl2(t, y).at(0), y - off(t, 0.24, 0.17)), (xl2 + 0.28, y - off(t, 0.24, 0.17)), stroke: (paint: ink, thickness: 0.6pt))
  link((xl2 + 0.28, y - off(t, 0.24, 0.17)), j, 0.6pt)
}

// 右侧二级节点：文字＋下划线，左端 S 弯汇入一级分支
#let node-r(y, t, j) = {
  draw.content((xr2 + 0.10, y), tbody(t, fs2), anchor: "west")
  draw.line((xr2 - 0.28, y - off(t, 0.24, 0.17)), (jr2(t, y).at(0), y - off(t, 0.24, 0.17)), stroke: (paint: ink, thickness: 0.6pt))
  link((xr2 - 0.28, y - off(t, 0.24, 0.17)), j, 0.6pt)
}

// 左侧一级分支：粗下划线，右端粗 S 线接入方框
#let branch-l(y, t, be) = {
  draw.content((xl1 - 0.12, y), tbody(t, fs1), anchor: "east")
  draw.line((jl1(t, y).at(0), y - off(t, 0.30, 0.21)), (xl1 + 0.10, y - off(t, 0.30, 0.21)), stroke: (paint: ink, thickness: 1pt))
  link((xl1 + 0.10, y - off(t, 0.30, 0.21)), be, 1pt)
}

// 右侧一级分支：粗下划线，左端粗 S 线接入方框
#let branch-r(y, t, be) = {
  draw.content((xr1 + 0.12, y), tbody(t, fs1), anchor: "west")
  draw.line((xr1 - 0.10, y - off(t, 0.30, 0.21)), (jr1(t, y).at(0), y - off(t, 0.30, 0.21)), stroke: (paint: ink, thickness: 1pt))
  link((xr1 - 0.10, y - off(t, 0.30, 0.21)), be, 1pt)
}

#canvas({
  import draw: *

  // 中央圆角框与三行加粗标题
  draw.rect((bx0, bcy - 0.95), (bx1, bcy + 0.95), radius: 0.2, stroke: (paint: ink, thickness: 1pt))
  draw.content((bx0 + (bx1 - bx0) / 2, bcy),
    text(size: fs0, weight: "bold", align(center)[Key technologies for \ on-orbit assembly by \ space robots]),
    anchor: "center")

  // 左上一级：Robotic Morphology（机器人形态学）
  branch-l(8.20, "Robotic Morphology", (14.20, bcy + 0.95))
  let ja = jl1("Robotic Morphology", 8.20)
  for (y, t, ls) in (
    (11.55, "Robotics Organizational Structure", ((12.45, "Cellular Robots"), (11.85, "Multi-arm Robots"), (11.25, "Multipedal Robots"), (10.55, "Soft Robots"))),
    (8.85, "Structural Design of Joints", ((9.75, "Movement Range"), (9.15, "Accuracy"), (8.55, "Reliability"), (7.95, "Operational Flexibility"))),
    (7.05, "Sensors and Actuators", ()),
    (6.40, "End-effectors", ()),
    (5.75, "Kinematics and Dynamics", ()),
  ) {
    node-l(y, t, ja)
    for (ly, lt) in ls { leaf-l(ly, lt, jl2(t, y)) }
  }

  // 左下一级：On-orbit Multi-Robot Assembly Platform（在轨多机器人平台）
  let tb = ("On-orbit Multi-", "Robot Assembly", "Platform")
  branch-l(4.60, tb, (13.90, 5.55))
  for (ly, lt) in (
    (5.35, "Platform Layout & Optimization"),
    (4.75, "Spacecraft Docking & Mooring"),
    (4.15, "Material Transfer and Storage"),
    (3.55, "Material Inspection & Management"),
  ) { leaf-l(ly, lt, jl1(tb, 4.60)) }

  // 右上一级：On-orbit Assembly Interaction & Management（在轨装配交互与管理）
  let tr1 = ("On-orbit Assembly", "Interaction &", "Management")
  branch-r(9.60, tr1, (16.95, 7.45))
  for (y, t, ls) in (
    (11.15, "Ground Interactive Control", ((11.60, "Digital Twin Interaction"), (10.70, "Teleoperation Technology"))),
    (9.00, ("Mission Planning and", "Management"), ((9.70, "Task Sequence Planning"), (9.10, "Effectiveness Monitoring & Evaluation"), (8.50, "Fault Detection & Handling"))),
  ) {
    node-r(y, t, jr1(tr1, 9.60))
    for (ly, lt) in ls { leaf-r(ly, lt, jr2(t, y)) }
  }

  // 右中一级：Structural Design of Assembly Connections（装配连接结构设计）
  let tr2 = ("Structural Design of", "Assembly Connections")
  branch-r(5.60, tr2, (bx1, 6.25))
  for (y, t, ls) in (
    (6.95, ("Multi-Interface", "Mechanical Connection"), ((7.75, "Mortise & Tenon Connection"), (7.15, "Screw Connection"), (6.55, "Rivet Connection"), (5.95, "Plug-in Connection"), (5.35, "Bayonet Connection"))),
    (4.95, "Energy Connection Structure Design", ()),
    (4.35, "Structural Cushioning & Protection", ()),
  ) {
    node-r(y, t, jr1(tr2, 5.60))
    for (ly, lt) in ls { leaf-r(ly, lt, jr2(t, y)) }
  }

  // 右下一级：Ground-based Simulation（地面仿真）
  branch-r(2.90, "Ground-based Simulation", (16.55, 5.55))
  for (ly, lt) in (
    (3.60, "Microgravity"),
    (3.05, "Lighting Conditions"),
    (2.50, "Temperature Variation"),
    (1.95, "Space Radiation"),
  ) { leaf-r(ly, lt, jr1("Ground-based Simulation", 2.90)) }
})
