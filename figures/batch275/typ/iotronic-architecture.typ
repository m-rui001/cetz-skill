#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 淡黄色云内布置绿色 IoTronic 架构模块，左侧为叠卡客户端，下方为通信图例与双向通道。
// 来源：Sensors 2025, 25, 1763, Figure 4: IoTronic's architectural schema. DOI: 10.3390/s25061763
#canvas({
  import draw: *
  let ink = rgb("#202020")
  let green = rgb("#95c47b")
  let light-green = rgb("#c2ddb0")
  let orange = rgb("#ffa300")
  let cloud = rgb("#fff3cd")
  let purple = rgb("#b7a8d4")
  let edge = (paint: ink, thickness: 1pt)
  let api = (9.1, 6.1)
  let dashboard = (6.45, 6.35)
  let queue = (12.75, 8.05)
  let conductor = (12.75, 5.55)
  let database = (12.75, 2.95)
  let agent = (17.55, 6.25)
  let tunnel = (22.75, 6.25)
  let router = (17.55, 3.95)
  // 共享文字、矩形与端点助手，算术运算符两侧保留空格。
  let label(p, s, size: 10pt, angle: 0deg) = {
    content(p, text(size: size, s), angle: angle, anchor: "center", frame: none)
  }
  let box(p, w, h, s, fill: green, angle: 0deg) = {
    rect((p.at(0) - w / 2, p.at(1) - h / 2),
      (p.at(0) + w / 2, p.at(1) + h / 2), fill: fill, stroke: edge)
    label(p, s, angle: angle)
  }
  let head(p, toward, kind: "solid") = {
    let dx = toward.at(0) - p.at(0)
    let dy = toward.at(1) - p.at(1)
    let n = calc.sqrt(dx * dx + dy * dy)
    let u = (dx / n, dy / n)
    let v = (-u.at(1), u.at(0))
    let q = (p.at(0) + 0.22 * u.at(0), p.at(1) + 0.22 * u.at(1))
    let a = (q.at(0) + 0.075 * v.at(0), q.at(1) + 0.075 * v.at(1))
    let b = (q.at(0) - 0.075 * v.at(0), q.at(1) - 0.075 * v.at(1))
    if kind == "diamond" {
      let m = (p.at(0) + 0.11 * u.at(0), p.at(1) + 0.11 * u.at(1))
      line(p, (m.at(0) + 0.075 * v.at(0), m.at(1) + 0.075 * v.at(1)), q,
        (m.at(0) - 0.075 * v.at(0), m.at(1) - 0.075 * v.at(1)),
        close: true, fill: white, stroke: edge)
    } else {
      line(p, a, b, close: true,
        fill: if kind == "rest" { white } else { ink }, stroke: edge)
    }
  }
  let link(points, kind: "solid") = {
    line(..points, stroke: edge)
    head(points.first(), points.at(1), kind: kind)
    head(points.last(), points.at(points.len() - 2), kind: kind)
  }
  // 云形背景包围全部云端服务。
  hobby(
    (6.0, 4.95), (4.9, 5.5), (4.65, 6.45), (5.2, 7.4), (6.3, 7.7),
    (6.25, 8.9), (7.2, 10.05), (8.7, 10.55), (10.25, 10.3),
    (11.25, 11.15), (12.8, 11.15), (14.0, 10.7),
    (14.8, 11.6), (16.25, 11.65), (17.4, 11.15),
    (18.6, 11.7), (20.0, 11.55), (21.0, 10.55),
    (22.45, 10.1), (23.8, 9.25), (24.0, 8.1),
    (23.75, 7.5), (24.45, 6.45), (24.15, 5.2), (22.65, 4.3),
    (21.5, 4.15), (21.2, 3.05), (19.8, 2.25), (17.9, 2.3),
    (17.25, 1.45), (15.5, 0.95), (13.75, 1.1), (12.5, 1.85),
    (10.65, 1.55), (8.9, 1.85), (7.65, 2.8), (6.2, 2.95), (5.3, 3.65),
    close: true, fill: cloud, stroke: edge,
  )
  // REST 与普通通信线先于模块绘制。
  link(((4.05, 9.9), (8.75, 9.2)), kind: "rest")
  link(((4.05, 6.35), (5.3, 6.35)))
  link(((7.6, 6.35), (8.75, 6.35)), kind: "rest")
  link(((6.45, 5.65), (6.45, 1.95), (22.55, 1.95), (22.55, 5.53)))
  link(((12.75, 4.85), (12.75, 4.0)))
  link(((17.55, 5.53), (17.55, 4.75)))
  // 菱形端点表示 AMQP pub/sub 与 RPC。
  for points in (
    ((9.45, 7.95), (12.42, 7.95)),
    ((12.75, 7.44), (12.75, 6.25)),
    ((13.08, 7.9), (17.72, 7.9), (17.72, 7.13)),
    ((13.08, 8.32), (19.55, 8.32), (19.55, 6.25), (21.6, 6.25)),
  ) { link(points, kind: "diamond") }
  // 左侧叠卡分别表示命令行客户端与浏览器。
  for item in (
    ((2.9, 9.9), [IoTronic\ command\ line client], green),
    ((2.9, 6.35), [Web\ browser], orange),
  ) {
    let p = item.at(0)
    for d in (0.34, 0.17, 0) {
      rect((p.at(0) - 1.15 - d, p.at(1) - 0.7 + d),
        (p.at(0) + 1.15 - d, p.at(1) + 0.7 + d), fill: item.at(2), stroke: edge)
    }
    label(p, item.at(1))
  }
  // 服务模块及竖排 API 标签。
  box(dashboard, 2.3, 1.4, [Dashboard])
  box(api, 0.7, 7.5, [IoTronic API server], angle: -90deg)
  box(conductor, 2.3, 1.4, [IoTronic\ conductor])
  for item in ((agent, 2.5, [IoTronic\ WAMP\ agent]), (tunnel, 2.3, [WS tunnel\ agent])) {
    let p = item.at(0)
    box((p.at(0) + 0.16, p.at(1) + 0.16), item.at(1), 1.44, [])
    box(p, item.at(1), 1.44, item.at(2))
  }
  // 开口队列及独立标签。
  line((12.42, 8.57), (12.42, 7.44), (13.08, 7.44), (13.08, 8.57), stroke: edge)
  for y in (7.66, 7.87, 8.08) { line((12.42, y), (13.08, y), stroke: edge) }
  label((13.95, 7.13), [IoTronic\ AMQP\ queues])
  // 数据库圆柱采用浅色顶面与绿色筒身。
  rect((11.82, 2.3), (13.68, 3.75), fill: green, stroke: none)
  bezier((11.82, 2.3), (13.68, 2.3), (11.82, 1.94), (13.68, 1.94), fill: green, stroke: edge)
  for x in (11.82, 13.68) { line((x, 2.3), (x, 3.75), stroke: edge) }
  circle((12.75, 3.75), radius: (0.93, 0.24), fill: light-green, stroke: edge)
  label(database, [IoTronic\ database])
  // 三个叠置圆盘表示 WAMP 路由器。
  for d in (0.3, 0.15, 0) {
    let x = router.at(0) + d
    let y = router.at(1) + d
    circle((x, y), radius: 0.5, fill: rgb("#d0d0d0"), stroke: edge)
    line((x - 0.35, y - 0.35), (x + 0.35, y + 0.35), stroke: edge)
    line((x - 0.35, y + 0.35), (x + 0.35, y - 0.35), stroke: edge)
  }
  label((18.95, 4.28), [WAMP\ router])
  // 彩色双向通道采用虚线描边。
  for item in ((17.6, 0.42, 3.43, purple), (23.22, 0.48, 5.5, light-green)) {
    let x = item.at(0)
    let lo = item.at(1)
    let hi = item.at(2)
    let outline = (
      (x, lo), (x - 0.23, lo + 0.23), (x - 0.1, lo + 0.23),
      (x - 0.1, hi - 0.23), (x - 0.23, hi - 0.23), (x, hi),
      (x + 0.23, hi - 0.23), (x + 0.1, hi - 0.23),
      (x + 0.1, lo + 0.23), (x + 0.23, lo + 0.23),
    )
    line(..outline, close: true, fill: item.at(3),
      stroke: (paint: ink, thickness: 1pt, dash: "dashed"))
  }
  label((15.72, 0.52), [WAMP control\ channel])
  label((25.02, 1.08), [Web service tunnel\ (WebSocket)])
  // 左下角图例逐字保留三种通信名称。
  for item in (
    (1.82, "rest", [REST communication]),
    (1.12, "diamond", [AMQP pub/sub and RPC]),
    (0.42, "solid", [other communication]),
  ) {
    link(((0.55, item.at(0)), (2.4, item.at(0))), kind: item.at(1))
    content((2.62, item.at(0)), text(size: 10pt, item.at(2)), anchor: "west", frame: none)
  }
})