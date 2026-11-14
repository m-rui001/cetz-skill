// 编译效果：黑白气动控制原理图。左列 Pressure/Vacuum Pump 大圆内上下蓝色实心三角，
// 最左竖直外框把两泵左口与底部回路相连；两泵右口各接 ISO 两位电磁阀（左格竖直双向箭头、
// 右格双堵口 T），右口汇合后经带斜箭头小先导阀、Proportional Valves（左格向上箭头+细控制线）、
// 单向阀、Pressure/Vacuum Sensors 小圆，至右端橙框内蓝色粗条 Soft Actuators；
// 顶部 Microcontroller 圆角框发出/接收黑色控制线；各组件下方粗体多行标签，Flex Sensors 在右上。
// 来源：Pneumatically Actuated Soft Robotic Hand and Wrist Exoskeleton for Motion Assistance
// in Rehabilitation. Actuators 2024, 13(5), 180. DOI 10.3390/act13050180, Figure 3.
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10.5pt)
#import "@preview/cetz:0.4.2": canvas, draw

#let blue = rgb("#4A7EBB")
#let orange = rgb("#C87137")
#let pipe = 1.6pt   // 管路/控制线粗
#let boxw = 1.1pt   // 组件轮廓
#let thin = 0.6pt   // 比例阀细控制线

#canvas(length: 1cm, {
  import draw: *
  // 坐标工具与共享 helper
  let px = (p, d) => (p.at(0) + d, p.at(1))
  let py = (p, d) => (p.at(0), p.at(1) + d)
  let label-below = (at, lines) => content(at, anchor: "north",
    text(weight: "bold", lines.map(l => [#l]).join(linebreak())))
  let wire = (pts, arrow: false, w: pipe) => line(..pts,
    stroke: (paint: black, thickness: w),
    mark: if arrow { (end: ">", fill: black, length: .3, width: .22) } else { none })
  // 泵：圆 + 上下蓝色实心三角
  let pump = (at, label) => {
    circle(at, radius: .95, stroke: boxw)
    let tri = (b, a) => line((at.at(0) - .25, b), (at.at(0) + .25, b), (at.at(0), a),
      close: true, fill: blue, stroke: rgb("#3A6EA5") + .8pt)
    tri(at.at(1) + .42, at.at(1) + .93)
    tri(at.at(1) - .42, at.at(1) - .93)
    label-below(py(at, -1.15), label)
  }
  // 两位阀：并排两方格；kind="sol" 左格双向箭头，"prop" 左格向上箭头+细控制线；右格双堵口 T
  let valve2 = (at, kind, label) => {
    let (w, h) = if kind == "prop" { (2.2, 1.1) } else { (2.0, 1.05) }
    let (x, y) = at
    rect((x - w / 2, y - h / 2), (x + w / 2, y + h / 2), stroke: boxw)
    line((x, y - h / 2), (x, y + h / 2), stroke: boxw)
    let cx = x - w / 4
    if kind == "prop" {
      line((cx, y - h / 2 + .12), (cx, y + h / 2 - .12), stroke: .9pt,
        mark: (end: ">", fill: black, length: .22, width: .16))
      line((x - w / 2 + .05, y + h / 2 + .18), (x + w / 2 - .05, y + h / 2 + .18), stroke: thin)
      line((x - w / 2 + .05, y - h / 2 - .18), (x + w / 2 - .05, y - h / 2 - .18), stroke: thin)
      line((x + .55, y - h / 2 - .2), (x + .55, y + h / 2 + .5), stroke: thin)
    } else {
      line((cx, y - .35), (cx, y + .35), stroke: .9pt,
        mark: (start: ">", end: ">", fill: black, length: .2, width: .15))
    }
    let rx = x + w / 4
    for s in (1, -1) {
      line((rx - .18, y + s * .22), (rx + .18, y + s * .22), stroke: .9pt)
      line((rx, y + s * .22), (rx, y + s * h / 2), stroke: .9pt)
    }
    label-below(py(at, -h / 2 - .28), label)
  }
  // 传感器：小圆 + 标签
  let sensor = (at, label) => {
    circle(at, radius: .2, stroke: boxw, fill: white)
    label-below(py(at, -.45), label)
  }
  // 单向阀：小三角指向右
  let check-valve = (at) => line((at.at(0) - .12, at.at(1) - .14),
    (at.at(0) - .12, at.at(1) + .14), (at.at(0) + .14, at.at(1)), close: true, stroke: .9pt)
  // 软执行器：橙描边矩形 + 蓝色粗水平条
  let actuator-box = (at) => {
    rect((at.at(0) - 2.575, at.at(1) - .585), (at.at(0) + 2.575, at.at(1) + .585),
      stroke: orange + 2.2pt)
    rect((at.at(0) - 2.3, at.at(1) - .08), (at.at(0) + 2.25, at.at(1) + .08),
      radius: .08, fill: blue, stroke: none)
  }

  // 组件位置命名表
  let P = (
    pumpP: (1.8, 5.7), pumpV: (1.8, 2.75),
    solP: (5.35, 5.75), solV: (5.0, 2.75),
    pilot: (7.68, 4.25), prop: (9.2, 4.25),
    senP: (11.3, 4.25), senV: (13.1, 4.25),
    act: (16.78, 4.25), mc: (10.375, 7.35),
  )
  let topY = 7.35
  let mergeX = 6.9
  let pumpP-R = px(P.pumpP, .95)
  let pumpV-R = px(P.pumpV, .95)

  // 外框回路：左竖线 + 底横线接 Vacuum Solenoids 底；两支箭头入泵左口
  wire(((.3, topY), (.3, 1.6), (4.1, 1.6), (4.1, 2.225)))
  wire(((.3, P.pumpP.at(1)), px(P.pumpP, -.95)), arrow: true)
  wire(((.3, P.pumpV.at(1)), px(P.pumpV, -.95)), arrow: true)
  // 主气路：泵→电磁阀→汇合→先导阀→比例阀→单向阀→传感器→执行器
  wire((pumpP-R, px(P.solP, -1.0)), arrow: true)
  wire((px(P.solP, 1.0), (mergeX, P.solP.at(1)), (mergeX, P.solV.at(1)), px(P.solV, 1.0)), arrow: true)
  wire(((mergeX, 4.25), px(P.pilot, -.43)))
  wire((px(P.pilot, .43), px(P.prop, -1.1)))
  wire((px(P.prop, 1.1), px(P.senP, -.2)))
  wire((px(P.senP, .2), px(P.senV, -.2)))
  wire((px(P.senV, .2), px(P.act, -2.575)))
  wire((px(P.solV, -1.0), pumpV-R), arrow: true)
  // 控制线：顶横线入 Microcontroller 左；下接 Pressure Solenoids 与先导阀；
  // 传感器上行折入顶横线右段；执行器上行至顶横线右端再左折入 Microcontroller 右口
  wire(((.3, topY), px(P.mc, -1.675)))
  wire(((5.15, topY), py(P.solP, .525)), arrow: true)
  wire(((7.8, topY), py(P.pilot, .25)), arrow: true)
  wire((py(P.senP, .2), (P.senP.at(0), 5.9), (12.5, 5.9), (12.5, topY)))
  wire((py(P.senV, .2), (P.senV.at(0), topY)))
  wire(((16.0, P.act.at(1)), (16.0, topY), px(P.mc, 1.675)), arrow: true)

  // 组件摆位
  pump(P.pumpP, ("Pressure", "Pump"))
  pump(P.pumpV, ("Vacuum", "Pump"))
  valve2(P.solP, "sol", ("Pressure", "Solenoids", "(6x)"))
  valve2(P.solV, "sol", ("Vacuum", "Solenoids", "(6x)"))
  // 先导小阀：小方格 + 交叉斜线 + 左上斜箭头
  rect(px(py(P.pilot, -.25), -.43), px(py(P.pilot, .25), .43), stroke: boxw)
  line((7.35, 4.0), (8.01, 4.5), stroke: .9pt)
  wire(((7.93, 3.9), (7.33, 4.7)), arrow: true, w: .9pt)
  valve2(P.prop, "prop", ("Proportional", "Valves", "(6x)"))
  check-valve((10.62, 4.25))
  sensor(P.senP, ("Pressure", "Sensors", "(6x)"))
  sensor(P.senV, ("Vacuum", "Sensors", "(6x)"))
  actuator-box(P.act)
  // 执行器下方标签与指向上箭头；右上 Flex Sensors 标签与向下箭头
  wire(((16.0, 3.05), (16.0, 3.665)), arrow: true)
  label-below((16.0, 2.9), ("Soft Actuators", "(6x)"))
  content((18.1, 5.45), anchor: "south",
    text(weight: "bold", ("Flex Sensors", "(6x)").map(l => [#l]).join(linebreak())))
  wire(((18.1, 5.3), (18.1, 4.36)), arrow: true)
  // Microcontroller 圆角框
  rect((8.7, 6.975), (12.05, 7.725), radius: .18, stroke: black + 1.4pt, fill: white)
  content(P.mc, text(size: 12pt, weight: "bold")[Microcontroller])
})
