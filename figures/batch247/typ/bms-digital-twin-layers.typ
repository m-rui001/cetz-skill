#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 分层数字孪生 BMS 架构：顶部屋脊写 Information to Second Party，下方为访问层蓝云、服务层绿云、
// 通信层粉云、存储层浅蓝云、物理资产灰云，底部数据池与六项图层图例，整体 18×25 cm 干净平涂线稿。
// 来源：Batteries 2025, 11, 298, Figure 5. DOI 10.3390/batteries11080298

#canvas({
  import draw: *

  // 配色
  let cream = rgb("#FBF2D2")
  let edge = rgb("#E2B072")
  let org = rgb("#F5B324")
  let orgedge = rgb("#CE8A05")
  let red = rgb("#B00000")
  let purp = rgb("#6B3AA0")
  let navy = rgb("#1F4E79")

  // 云团：上下两排小圆加圆角矩形，平涂无线，模拟分层色块
  let cloud(c, w, h, fill, n: 8) = {
    for i in range(n) {
      let x = c.at(0) - w / 2 + i * w / (n - 1)
      circle((x, c.at(1) + h * 0.26), radius: h * 0.28, fill: fill, stroke: none)
      circle((x, c.at(1) - h * 0.26), radius: h * 0.28, fill: fill, stroke: none)
    }
    rect((c.at(0) - w / 2, c.at(1) - h / 2), (c.at(0) + w / 2, c.at(1) + h / 2),
      radius: h * 0.26, fill: fill, stroke: none)
  }

  // 黄色药丸节点
  let node(c, w, h, label, size: 8.5pt) = {
    rect((c.at(0) - w / 2, c.at(1) - h / 2), (c.at(0) + w / 2, c.at(1) + h / 2),
      radius: h / 2, fill: org, stroke: (paint: orgedge, thickness: 0.6pt))
    content(c, text(size: size, weight: "bold", fill: black, label))
  }

  // 带箭头折线
  let arrow(..pts, color: black, th: 0.8pt) = line(..pts,
    stroke: (paint: color, thickness: th), mark: (end: "stealth", fill: color, scale: 0.55))

  // 安全层米色带
  let band(y0, y1) = rect((0.6, y0), (17.4, y1), radius: 0.1,
    fill: cream, stroke: (paint: edge, thickness: 0.7pt))

  // 屋顶：标题带
  line((0.6, 21.55), (9.0, 24.65), (17.4, 21.55), close: true,
    fill: cream, stroke: (paint: rgb("#E8B57E"), thickness: 1.2pt))
  content((9.0, 22.8), text(size: 13pt, weight: "bold", fill: red)[Information to Second Party])

  // 三条安全层带
  for (y0, y1) in ((17.7, 21.5), (8.6, 17.0), (5.8, 8.1)) { band(y0, y1) }

  // 访问层：蓝云 + 服务层绿云（右侧绿云压住蓝云边缘）
  cloud((5.35, 19.45), 8.5, 2.5, rgb("#3B6FB5"))
  cloud((13.25, 19.5), 8.0, 2.5, rgb("#6BA53F"))

  // 服务层内的虚拟模型绿云、物理资产灰云、存储层浅蓝云、通信层粉云
  cloud((13.2, 12.4), 7.6, 6.2, rgb("#D3E8C4"))
  cloud((3.9, 13.0), 4.4, 5.2, rgb("#DEDEDE"))
  cloud((12.5, 15.15), 5.9, 1.9, rgb("#C3DBEE"))
  cloud((8.1, 13.4), 4.0, 4.4, rgb("#F9CDD0"))

  // 数据池红色总线（先画，后由节点与文字压盖）
  line((5.35, 7.55), (15.3, 7.55), stroke: (paint: red, thickness: 1.2pt))
  arrow((5.35, 7.55), (5.35, 9.4), (6.9, 9.4), (6.9, 12.36), color: red, th: 1.2pt)
  line((14.05, 14.95), (14.05, 7.55), stroke: (paint: red, thickness: 1.2pt))

  // 三个数据库圆柱
  let db(x, col) = {
    circle((x, 5.95), radius: (0.4, 0.14), fill: col.darken(15%), stroke: none)
    rect((x - 0.4, 5.95), (x + 0.4, 6.75), fill: col, stroke: none)
    circle((x, 6.75), radius: (0.4, 0.14), fill: col.lighten(30%), stroke: (paint: col, thickness: 0.5pt))
  }
  for (x, col) in ((12.1, rgb("#C0392B")), (13.55, rgb("#8E5BB5")), (15.0, rgb("#C0392B"))) {
    line((x, 7.55), (x, 6.89), stroke: (paint: red, thickness: 1.2pt))
    db(x, col)
  }

  // 数据池标题
  content((0.95, 6.8), anchor: "west",
    text(size: 12.5pt, weight: "bold", fill: red)[Extended Data Pool / Context Data])

  // 访问层四个节点
  for (x, y, w, h, t) in (
    (2.05, 19.5, 1.8, 0.92, [HMI]),
    (5.55, 19.5, 3.9, 1.2, [Data \ Visualization]),
    (10.6, 19.5, 3.0, 1.2, [Data \ Analytics]),
    (14.65, 19.5, 3.5, 1.2, [Application]),
  ) { node((x, y), w, h, t) }

  // 服务层节点
  for (x, y, w, h, t) in (
    (3.9, 15.0, 3.0, 0.95, [Sensors]),
    (3.9, 13.45, 3.2, 0.95, [Actuators]),
    (3.9, 11.75, 2.9, 0.95, [Control]),
    (8.1, 14.85, 3.5, 1.2, [Data \ Acquisition]),
    (8.1, 13.0, 3.5, 1.2, [Edge \ Processing]),
    (12.5, 15.3, 3.8, 1.05, [Data \ Storage]),
    (12.3, 13.5, 3.0, 1.05, [Modeling]),
    (9.95, 10.25, 2.5, 0.92, [Behavior]),
    (12.45, 10.25, 2.5, 0.92, [Data- \ driven]),
    (14.6, 10.25, 2.2, 0.92, [Physical]),
    (16.55, 10.25, 1.4, 0.92, [\u{2026}]),
  ) { node((x, y), w, h, t) }

  // 竖排 Optimization
  rect((15.6, 11.0), (16.9, 15.7), radius: 0.65, fill: org,
    stroke: (paint: orgedge, thickness: 0.6pt))
  content((16.25, 13.35), text(size: 8.5pt, weight: "bold")[Optimization], angle: 90deg)

  // 访问层内部横向数据流
  arrow((9.1, 19.5), (7.62, 19.5))
  arrow((3.6, 19.5), (3.02, 19.5))
  arrow((14.65, 20.1), (14.65, 20.95), (5.55, 20.95), (5.55, 20.1))

  // 层间回传：Optimization 上行至 Application
  arrow((16.25, 15.72), (16.25, 18.85))
  // Modeling 曲线绕左侧送至 Data Analytics
  hobby((11.05, 13.85), (10.2, 15.0), (10.35, 17.4), (10.6, 18.88),
    stroke: (paint: black, thickness: 0.8pt), mark: (end: "stealth", scale: 0.55))

  // 物理资产—通信层连线
  arrow((5.4, 15.0), (6.32, 14.9))
  arrow((5.35, 11.75), (8.5, 11.75), (8.5, 12.36))
  arrow((9.85, 14.55), (10.62, 15.0))
  // 存储与建模
  arrow((13.8, 13.5), (15.57, 13.5))
  // 建模分派到虚拟模型四类
  for q in ((9.95, 10.72), (12.45, 10.72), (14.6, 10.72), (16.55, 10.72)) {
    arrow((12.3, 12.96), q, color: purp, th: 1pt)
  }

  // 左侧接口星点：HMI 下行、Sensors 接入、执行器与控制回传
  circle((1.5, 14.3), radius: 0.15, fill: rgb("#E8752A"), stroke: none)
  arrow((1.5, 19.04), (1.5, 14.47))
  arrow((2.4, 14.95), (1.64, 14.42))
  arrow((2.3, 13.45), (1.5, 13.45), (1.5, 14.13))
  arrow((2.45, 11.75), (1.0, 11.75), (1.0, 13.9), (1.38, 14.22))

  // 数据池下方装饰条
  for (y, col) in ((5.35, rgb("#E8B33C")), (5.1, rgb("#E8752A")), (4.85, rgb("#9A9A9A"))) {
    line((0.6, y), (17.4, y), stroke: (paint: col, thickness: 1.6pt))
  }

  // 图例：六类图层
  let sw(y, x, fill, label) = {
    cloud((x, y), 0.62, 0.5, fill, n: 5)
    content((x + 0.62, y), anchor: "west", text(size: 9.5pt, weight: "bold", fill: navy)[#label])
  }
  sw(4.0, 1.05, rgb("#DEDEDE"), [Physical asset (Physical twin)])
  sw(3.3, 1.05, rgb("#F9CDD0"), [Communication layer])
  sw(2.6, 1.05, rgb("#C3DBEE"), [Storage layer])
  sw(1.9, 1.05, rgb("#6BA53F"), [Service layer])
  sw(4.0, 9.9, rgb("#D3E8C4"), [Virtual Model (digital twin)])
  rect((9.6, 3.16), (10.2, 3.44), fill: cream, stroke: (paint: edge, thickness: 0.6pt))
  content((10.5, 3.3), anchor: "west", text(size: 9.5pt, weight: "bold", fill: navy)[Security layer])
  sw(2.6, 9.9, rgb("#3B6FB5"), [Access layer])
})
