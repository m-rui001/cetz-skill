// 编译外观：CubeSat 双极推力器（CAT）磁喷管示意图。
//   右半为浅灰 SPACECRAFT 块，标签在其内部右下角；
//   黑色粗阶梯轮廓为法拉第屏蔽：左侧窄开口壁向右阶跃为更宽的上下壳体；
//   壳体内上下各嵌一块深灰永磁体；蓝色等离子体衬套自左壁喉部
//   以漏斗形收敛、向右扩为圆柱（分段蓝近似渐变）；
//   深色螺旋天线正弦环跨绕圆柱，两端为竖直环边，馈线自右上引出；
//   右中白色矩形为推进剂入口，黑箭头向左指入衬套；
//   左侧为阶跃蓝渐变的发散羽流，七条磁场线箭头向左扇出（中间四条虚线）；
//   全部标签逐字保留原文，折行与原图一致，引线指向各自部件。
// 来源：Propulsion Technologies for CubeSats: Review. Aerospace 2024,
//   11(7), 502, Figure 30. DOI 10.3390/aerospace11070502.
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1cm, {
  import draw: *

  // 命名地标：喉部中心为原点，其余坐标均由此派生
  let throat-r = 0.4      // 喉部半高
  let wall-x = 0.0        // 屏蔽左开口壁
  let step-x = 0.95       // 阶梯转折处
  let house-x = 3.8       // 壳体右壁
  let open-y = 2.5        // 开口壁半高
  let house-y = 3.0       // 壳体半高
  let liner-r = 1.1       // 衬套圆柱半高
  let shoulder-x = 1.55   // 漏斗肩位置
  let liner-x = 3.7       // 衬套右端
  let feed-y = 1.35       // 天线环顶 / 馈线高度

  // 引线 + 标签助手：anchor 取标签最靠近引线起点的角
  let tag(p, target, body, anchor: "center") = {
    content(p, body, anchor: anchor, padding: 0.1)
    line(p, target, mark: (end: ">"), stroke: 0.9pt)
  }

  // 航天器浅灰块与内部右下角标签
  rect((1.0, -3.4), (10.5, 3.35), fill: rgb("#c9c9c9"), stroke: none)
  content((8.6, -3.05), [SPACECRAFT])

  // 羽流：同一条凹形发散边界按 t 截断成嵌套面，由浅入深近似蓝色渐变
  let lerp(a, b, t) = (
    a.at(0) + (b.at(0) - a.at(0)) * t,
    a.at(1) + (b.at(1) - a.at(1)) * t,
  )
  let mir(p) = (p.at(0), -p.at(1))
  let flare(t, c) = {
    let (p0, p1, p2, p3) = ((0, throat-r), (-3.6, 1.0), (-5.4, 2.4), (-6.8, 3.6))
    let (q0, q1, q2) = (lerp(p0, p1, t), lerp(p1, p2, t), lerp(p2, p3, t))
    let (r0, r1) = (lerp(q0, q1, t), lerp(q1, q2, t))
    let e = lerp(r0, r1, t)
    merge-path(close: true, fill: rgb(c), stroke: none, {
      bezier(p0, e, q0, r0)
      line(e, mir(e))
      bezier(mir(e), mir(p0), mir(r0), mir(q0))
    })
  }
  for (t, c) in ((1.0, "#e9eefb"), (0.78, "#cfdcf9"),
                 (0.56, "#a9c0f6"), (0.34, "#7ba0f3")) {
    flare(t, c)
  }

  // 永磁体：上下对称的深灰块
  for s in (1, -1) {
    rect((1.1, s * 1.9), (3.7, s * 2.9),
         fill: rgb("#808080"), stroke: 0.6pt + rgb("#555555"))
  }

  // 等离子体衬套：深蓝凹形漏斗 + 中蓝圆柱 + 浅蓝右段（阶跃渐变）
  merge-path(close: true, fill: rgb("#2459e6"), stroke: none, {
    bezier((0, throat-r), (shoulder-x, liner-r), (0.8, 0.5), (1.2, 0.75))
    line((shoulder-x, liner-r), (shoulder-x, -liner-r))
    bezier((shoulder-x, -liner-r), (0, -throat-r), (1.2, -0.75), (0.8, -0.5))
  })
  rect((shoulder-x, -liner-r), (liner-x, liner-r),
       fill: rgb("#3f6ff2"), stroke: none)
  rect((2.7, -liner-r), (liner-x, liner-r),
       fill: rgb("#6f96f6"), stroke: none)

  // 法拉第屏蔽：上下对称阶梯粗黑轮廓，右壁为推进剂入口留缺口
  for (s, stub) in ((1, 1.45), (-1, -0.65)) {
    line((wall-x, s * throat-r), (wall-x, s * open-y),
         (step-x, s * open-y), (step-x, s * house-y),
         (house-x, s * house-y), (house-x, stub),
         stroke: 1.8pt)
  }

  // 螺旋天线：两条竖直环边 + 正弦环 + 顶部右引馈线
  for x in (1.75, 3.25) {
    line((x, -feed-y), (x, feed-y), stroke: 1.6pt + rgb("#333333"))
  }
  hobby((1.75, feed-y), (2.05, 1.1), (2.5, 0),
        (2.95, -1.1), (3.25, -feed-y),
        stroke: 1.6pt + rgb("#333333"))
  hobby((3.25, feed-y), (3.6, feed-y + 0.1), (4.0, feed-y), (5.2, feed-y),
        stroke: 1.6pt + rgb("#333333"))

  // 推进剂入口：白矩形（仅上下边框）+ 向左黑箭头与右侧标签
  rect((liner-x, -0.6), (5.2, 0.55), fill: white, stroke: none)
  line((liner-x, 0.55), (5.2, 0.55), stroke: 0.8pt)
  line((liner-x, -0.6), (5.2, -0.6), stroke: 0.8pt)
  line((5.5, 0), (3.95, 0), mark: (end: ">"), stroke: 1.2pt)
  content((5.7, 0), [PROPELLANT IN], anchor: "west")

  // 磁喷管磁场线：按角度扇出七条箭头，中间四条虚线
  for a in (30, 12, 6, 0, -6, -12, -30) {
    let rad = a * calc.pi / 180
    let ey = 6.0 * calc.sin(rad)
    let ex = -6.35 * calc.cos(rad)
    let d = if calc.abs(a) == 30 or a == 0 { "solid" } else { "dashed" }
    hobby((0, 0.4 * a / 30), (-3.0, 0.3 * ey), (ex, ey),
          mark: (end: ">"), stroke: (thickness: 0.9pt, dash: d))
  }

  // 逐字标签与引线（两行折行依原图）
  tag((0.3, 3.75), (1.7, 2.5),
      [PERMANENT\ MAGNETS], anchor: "south-east")
  tag((-0.75, 1.85), (0.8, 0.75),
      [PLASMA\ LINER], anchor: "south-east")
  tag((-6.0, 2.1), (-5.5, 2.6),
      [MAGNETIC\ NOZZLE], anchor: "east")
  tag((-1.45, -2.6), (-0.05, -2.45),
      [FARADAY\ SHIELD], anchor: "east")
  tag((6.1, 1.7), (5.05, 1.38),
      [HELICON\ ANTENNA], anchor: "south-west")
})
