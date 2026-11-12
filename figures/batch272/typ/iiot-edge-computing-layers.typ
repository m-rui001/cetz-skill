#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：IIoT–边缘计算三层架构。云层（Big data processing/Data warehousing/Model training）右接云框：
// 数据库圆柱、地球、服务器机架以红色双向箭头互联；边缘层（Local network/Data processing and control/
// Data chashing/Storage and response）右接两对 Edge Node / Server，组间 Wireless Connections 双向箭头；
// 设备层（Sensors/Actuators/Controllers/Edge links）右接无线天线与 PLC/平板/阀门/机械臂/工厂线稿图标。
// 层间用红色虚线分隔，云-边与边-端以双向箭头衔接。逐字保留全部标签（含原文 Data chashing）。
// 来源：Sensors 2025, 25, 213, Figure 6 "Architecture of IIoT–edge computing". DOI 10.3390/s25010213

#canvas({
  import draw: *
  let ink = black
  let red = rgb("#d9534f")
  let gfill = rgb("#e3f1dd")
  let gstr = rgb("#6f9e50")
  let bfill = rgb("#e0e9f7")
  let bstr = rgb("#5b84c4")
  let yfill = rgb("#fdf2cc")
  let ystr = rgb("#c99a1f")
  let t(pos, s, size: 6.6pt, anchor: "center", fill: ink) = content(
    pos, text(size: size, fill: fill)[#s], anchor: anchor, frame: none)
  let panel(c, hw, hh, fill, stroke) = rect((c.at(0) - hw, c.at(1) - hh),
    (c.at(0) + hw, c.at(1) + hh), radius: 0.20, fill: fill, stroke: 1pt + stroke)
  let dbl(a, b) = line(a, b, stroke: 0.9pt + red,
    mark: (start: "stealth", end: "stealth", scale: 0.45))
  // 条目列表：起始点、行距、内容
  let bullets(x, y, list) = {
    for (i, s) in list.enumerate() {
      circle((x + 0.06, y - i * 0.37), radius: 0.022, fill: ink, stroke: none)
      t((x + 0.20, y - i * 0.37), s, size: 6.8pt, anchor: "west")
    }
  }
  // 数据库圆柱：矩形＋顶部椭圆＋两道分层线
  let db(pos) = {
    rect((pos.at(0) - 0.22, pos.at(1) - 0.28), (pos.at(0) + 0.22, pos.at(1) + 0.28),
      fill: white, stroke: 0.7pt + ink)
    circle((pos.at(0), pos.at(1) + 0.28), radius: (0.22, 0.075), fill: white, stroke: 0.7pt + ink)
    line((pos.at(0) - 0.22, pos.at(1) + 0.10), (pos.at(0) + 0.22, pos.at(1) + 0.10), stroke: 0.5pt + ink)
    line((pos.at(0) - 0.22, pos.at(1) - 0.10), (pos.at(0) + 0.22, pos.at(1) - 0.10), stroke: 0.5pt + ink)
  }
  // 服务器机架：三层薄箱
  let server(pos) = {
    for k in (0.28, 0.06, -0.16) {
      rect((pos.at(0) - 0.24, pos.at(1) + k - 0.10), (pos.at(0) + 0.24, pos.at(1) + k + 0.10),
        fill: white, stroke: 0.6pt + ink)
      line((pos.at(0) - 0.16, pos.at(1) + k), (pos.at(0) - 0.06, pos.at(1) + k), stroke: 0.5pt + ink)
    }
  }
  // 地球：圆＋两条经线椭圆＋赤道
  let globe(pos) = {
    circle(pos, radius: 0.27, fill: white, stroke: 0.7pt + ink)
    circle(pos, radius: (0.10, 0.27), fill: none, stroke: 0.5pt + ink)
    line((pos.at(0) - 0.27, pos.at(1)), (pos.at(0) + 0.27, pos.at(1)), stroke: 0.5pt + ink)
  }
  // 无线信号：圆点＋三段向外弧
  let wifi(pos) = {
    circle((pos.at(0), pos.at(1)), radius: 0.035, fill: ink, stroke: none)
    for r in (0.15, 0.26, 0.37) {
      arc(pos, start: 38deg, stop: 142deg, radius: r, stroke: 0.7pt + gstr)
    }
  }

  // ── 云层：条目面板与云框
  panel((2.85, 9.25), 2.15, 1.05, gfill, gstr)
  bullets(1.05, 9.72, ([Big data processing], [Data warehousing], [Model training]))
  t((2.85, 8.62), [Cloud Layer], size: 7.6pt, fill: gstr)
  rect((5.35, 8.15), (13.75, 10.30), radius: 0.20, fill: none, stroke: 1pt + bstr)
  t((5.60, 10.10), [Cloud], size: 6.8pt, anchor: "west", fill: red)
  circle((9.55, 9.12), radius: (3.25, 0.88), fill: rgb("#cfeaf2"), stroke: 0.9pt + bstr)
  db((7.35, 9.10))
  globe((8.95, 9.18))
  server((10.60, 9.10))
  dbl((7.62, 9.15), (8.66, 9.15))
  dbl((9.23, 9.15), (10.34, 9.15))
  dbl((10.50, 8.80), (7.45, 8.80))

  // ── 层间分隔与云–边双向箭头
  line((0.50, 7.75), (13.90, 7.75), stroke: (paint: red, thickness: 0.7pt, dash: "dashed"))
  dbl((6.90, 8.13), (6.90, 7.47))
  dbl((11.90, 8.13), (11.90, 7.47))

  // ── 边缘层：条目面板与边缘节点框
  panel((2.85, 6.05), 2.15, 1.45, bfill, bstr)
  bullets(1.05, 7.02, ([Local network], [Data processing and control],
    [Data chashing], [Storage and response]))
  t((2.85, 5.05), [Edge Layer], size: 7.6pt, fill: red)
  rect((5.35, 4.55), (13.75, 7.45), radius: 0.20, fill: none, stroke: 1pt + bstr)
  t((7.55, 6.98), [Edge Node / Server], size: 6.6pt, fill: bstr)
  t((11.75, 6.98), [Edge Node / Server], size: 6.6pt, fill: bstr)
  db((6.85, 6.05))
  server((8.05, 6.05))
  db((10.85, 6.05))
  server((12.05, 6.05))
  dbl((7.12, 6.05), (7.78, 6.05))
  dbl((11.12, 6.05), (11.78, 6.05))
  dbl((8.36, 6.05), (10.54, 6.05))
  t((9.45, 5.55), [Wireless Connections], size: 6.8pt, fill: red)

  // ── 层间分隔与边–端双向箭头
  line((0.50, 4.20), (13.90, 4.20), stroke: (paint: red, thickness: 0.7pt, dash: "dashed"))
  dbl((9.50, 4.53), (9.50, 3.97))

  // ── 设备层：条目面板与设备图标框
  panel((2.85, 2.50), 2.15, 1.40, yfill, ystr)
  bullets(1.05, 3.42, ([Sensors], [Actuators], [Controllers], [Edge links]))
  t((2.85, 1.55), [Device Layer], size: 7.6pt, fill: ystr)
  rect((5.35, 1.10), (13.75, 3.95), radius: 0.20, fill: none, stroke: 1pt + ystr)
  for x in (6.15, 7.70, 9.25, 10.80, 12.35) {
    wifi((x, 3.30))
  }
  // 简化设备线稿：PLC、平板、阀门、机械臂、工厂
  rect((5.85, 1.65), (6.55, 2.35), fill: white, stroke: 0.6pt + ink)
  for k in (1.78, 1.95, 2.12) {
    rect((5.95, k - 0.05), (6.12, k + 0.05), fill: yfill, stroke: 0.5pt + ink)
  }
  rect((7.25, 1.70), (7.95, 2.35), radius: 0.06, fill: white, stroke: 0.6pt + ink)
  circle((7.60, 1.82), radius: 0.035, fill: none, stroke: 0.5pt + ink)
  line((8.55, 2.05), (9.15, 2.05), stroke: 0.7pt + ink)
  line((8.62, 1.85), (8.62, 2.25), (8.85, 2.05), (8.62, 1.85), stroke: 0.7pt + ink)
  line((9.08, 1.85), (9.08, 2.25), (8.85, 2.05), (9.08, 1.85), stroke: 0.7pt + ink)
  line((9.75, 1.70), (9.75, 2.30), (10.25, 2.10), (10.55, 2.32), stroke: 0.8pt + ink)
  circle((9.75, 1.70), radius: 0.05, fill: yfill, stroke: 0.6pt + ink)
  circle((10.25, 2.10), radius: 0.045, fill: yfill, stroke: 0.6pt + ink)
  circle((10.55, 2.32), radius: 0.045, fill: yfill, stroke: 0.6pt + ink)
  rect((11.15, 1.65), (12.45, 2.30), fill: white, stroke: 0.6pt + ink)
  for k in (11.35, 11.75, 12.15) {
    rect((k, 2.00), (k + 0.18, 2.30), fill: yfill, stroke: 0.5pt + ink)
  }
})
