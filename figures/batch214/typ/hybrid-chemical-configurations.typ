#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 编译外观：横向黑白线稿流程图 + 浅灰平涂；左起圆形增压罐、R 调压器、灰色圆角推进剂贮箱、
// V 流量控制阀、喷注器 I，中部星形分解区与灰色固体药柱，右侧燃烧室接收扩喷管与排气。
// 来源：Aerospace 2024, 11(7), 502, Fig.15；DOI 10.3390/aerospace11070502
// 来源：Aerospace 2024, 11(7), 502, Fig. 15(a) 混合化学推进系统构型。

#canvas({
  import draw: *

  set-style(stroke: (paint: black, thickness: 0.9pt), fill: none)

  // ---- 共享助手 ----
  let thin = (paint: black, thickness: 0.7pt)
  let lab(p, b, size: 9pt) = content(p, b, size: size, anchor: "center")
  let node(p, n) = {                      // 圆形阀/喷注器符号
    circle(p, radius: 0.42, fill: white, stroke: thin)
    content(p, n, size: 8.5pt)
  }
  let arrow(a, b) = line(a, b, stroke: thin, mark: (end: "stealth", size: 0.12))
  let burst(c, r1: 0.62, r2: 0.40, inner: 0.16, n: 12) = {   // 分解区星形爆闪
    for k in range(n) {
      let ang = (k + 0.15) * 360deg / n
      let rr = if calc.even(k) { r1 } else { r2 }
      line(
        (c.at(0) + inner * calc.cos(ang), c.at(1) + inner * calc.sin(ang)),
        (c.at(0) + rr * calc.cos(ang), c.at(1) + rr * calc.sin(ang)),
        stroke: thin,
      )
    }
  }

  // ---- 地标坐标（x 为主线，y=0 为流道中心）----
  let xPre = 2.9                       // 增压罐圆心
  let rPre = 1.7
  let xReg = 5.6                       // 调压器 R
  let xTankL = 6.6                     // 贮箱左右缘
  let xTankR = 10.7
  let xVlv = 12.2                      // 流量控制阀 V
  let xInj = 14.1                      // 喷注器 I
  let xBed = 16.6                      // 药柱左缘
  let xGrainR = 20.0                   // 药柱右缘
  let yCh = 2.15                       // 燃烧室半高
  let xChEnd = 22.6                    // 等直段末端
  let xThroat = 24.6                   // 喷管喉部
  let xExit = 27.0                     // 喷管出口
  let yThroat = 0.55

  // ---- 增压罐 ----
  circle((xPre, 0), radius: rPre, stroke: thin)
  lab((xPre, 0), "Pressurant", size: 9.5pt)

  // ---- 管路：增压罐 → R → 贮箱 ----
  line((xPre + rPre, 0), (xReg - 0.42, 0), stroke: thin)
  node((xReg, 0), "R")
  line((xReg + 0.42, 0), (xTankL, 0), stroke: thin)

  // ---- 推进剂贮箱（浅灰圆角矩形）----
  rect((xTankL, -2.45), (xTankR, 2.45), radius: 0.65, fill: rgb(86%, 86%, 86%), stroke: thin)
  lab((8.65, 0), [Propellant #linebreak() Tank], size: 10pt)

  // ---- 管路：贮箱 → V → 喷注器 I ----
  line((xTankR, 0), (xVlv - 0.42, 0), stroke: thin)
  node((xVlv, 0), "V")
  line((xVlv + 0.42, 0), (xInj - 0.42, 0), stroke: thin)
  node((xInj, 0), "I")

  // ---- 进料系统标记括号 ----
  line((10.4, -0.95), (13.2, -0.95), stroke: thin)
  line((10.4, -0.95), (10.4, -0.62), stroke: thin)
  line((13.2, -0.95), (13.2, -0.62), stroke: thin)
  lab((11.8, -1.55), "Feed System")

  // ---- 燃烧室壁与收扩喷管轮廓 ----
  line((xBed - 0.7, yCh), (xChEnd, yCh), stroke: thin)
  line((xBed - 0.7, -yCh), (xChEnd, -yCh), stroke: thin)
  line((xChEnd, yCh), (xThroat, yThroat), stroke: thin)
  line((xChEnd, -yCh), (xThroat, -yThroat), stroke: thin)
  line((xThroat, yThroat), (xExit, 1.2), stroke: thin)
  line((xThroat, -yThroat), (xExit, -1.2), stroke: thin)

  // ---- 固体药柱（灰色块）与催化床分隔线 ----
  rect((xBed, -yCh), (xGrainR, yCh), fill: rgb(78%, 78%, 78%), stroke: thin)
  line((xBed, -yCh), (xBed + 0.9, yCh), stroke: thin)

  // ---- 药柱前端第二个 I 标记 ----
  node((xBed + 0.55, 0.72), "I")

  // ---- 主流虚线（含方向箭头）----
  line(
    (xInj + 0.42, 0), (xChEnd - 0.2, 0),
    stroke: (paint: black, thickness: 0.9pt, dash: "dashed"),
    mark: (end: "stealth", size: 0.12),
  )

  // ---- 分解区星形爆闪（药柱上缘外侧）----
  burst((xBed - 0.55, 1.42))

  // ---- 上方标签与指引箭头 ----
  lab((5.85, 2.6), [Pressure #linebreak() Regulator])
  arrow((5.5, 1.8), (5.62, 0.52))
  lab((11.9, 2.6), [Flow #linebreak() Control])
  arrow((12.0, 1.8), (12.15, 0.52))
  lab((13.95, 2.6), "Injector")
  arrow((13.9, 1.85), (14.02, 0.55))
  lab((17.1, 2.78), "Decomposition")

  // ---- 下方标签：催化床 / 固体推进剂 ----
  lab((14.7, -2.65), "Catalyst bed")
  arrow((15.25, -2.25), (16.35, -1.05))
  lab((18.9, -2.95), "Solid Propellant")
  arrow((18.3, -2.55), (17.9, -1.1))
  arrow((19.8, -2.55), (19.5, -1.1))

  // ---- 右侧标签：燃烧产物 / 喷管 / 排气 ----
  lab((21.2, 0.95), [Burned #linebreak() Propellant])
  line((25.0, 2.55), (27.6, 2.55), stroke: thin)
  line((25.0, 2.55), (25.0, 2.25), stroke: thin)
  line((27.6, 2.55), (27.6, 2.25), stroke: thin)
  lab((26.3, 3.0), "Nozzle")
  lab((28.9, 0.35), [Hot Gases #linebreak() Exhaust])
})
