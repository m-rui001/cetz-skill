#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *
  // 电弧加热推力器放电系统示意图（Aerospace 2024, 11(7), 502, Fig.16；DOI 10.3390/aerospace11070502）——灰底部件＋逐字标注的干净线稿

  let gray = rgb(222, 222, 222)
  let lw = 0.8pt

  // 推进剂储箱（左侧圆角矩形）
  rect((0, 0.3), (2.7, 2.7), radius: 0.35, fill: gray, stroke: lw)
  content((1.35, 1.5), [Propellant #linebreak() Storage], align: center)

  // 储箱到阀门的管路
  line((2.7, 1.5), (3.23, 1.5), stroke: lw)

  // 流量控制阀 V（圆）
  circle((3.65, 1.5), radius: 0.42, fill: white, stroke: lw)
  content((3.65, 1.5), [V])

  // 阀门到放电腔的管路
  line((4.07, 1.5), (5.0, 1.5), stroke: lw)

  // 流量控制标注及其指向阀门顶部的箭头
  content((3.65, 2.6), [Flow Control], align: center)
  line((3.65, 2.4), (3.65, 1.95), stroke: lw, mark: (end: "stealth"))

  // 放电腔体外框
  rect((5.0, 0.15), (9.4, 2.85), stroke: lw)

  // 腔体内上下两路虚线气流
  line((5.3, 2.35), (7.3, 2.35), stroke: (paint: black, thickness: lw, dash: "dashed"), mark: (end: "stealth"))
  line((5.3, 0.65), (7.3, 0.65), stroke: (paint: black, thickness: lw, dash: "dashed"), mark: (end: "stealth"))

  // 阴极（中部灰块）及指向电弧的箭头
  rect((5.5, 1.25), (7.3, 1.75), fill: gray, stroke: lw)
  content((6.4, 1.5), [Cathode])
  line((7.3, 1.5), (7.7, 1.5), stroke: lw, mark: (end: "stealth"))

  // 上、下两块阳极
  rect((7.9, 2.1), (9.35, 2.6), fill: gray, stroke: lw)
  content((8.62, 2.35), [Anode])
  rect((7.9, 0.4), (9.35, 0.9), fill: gray, stroke: lw)
  content((8.62, 0.65), [Anode])

  // 阴极与阳极之间的两段锯齿电弧
  line((7.75, 1.6), (8.1, 1.9), (8.45, 1.7), (8.8, 2.05), stroke: 1.1pt)
  line((7.75, 1.4), (8.1, 1.1), (8.45, 1.3), (8.8, 0.95), stroke: 1.1pt)

  // 电弧标注
  content((8.6, 1.5), [Arc], align: center)

  // 右侧加热气体排出的两股箭头
  line((9.4, 2.35), (10.2, 2.7), stroke: lw, mark: (end: "stealth"))
  line((9.4, 0.65), (10.2, 0.3), stroke: lw, mark: (end: "stealth"))
  content((10.85, 1.5), [Heated Gas #linebreak() Exhaust], align: center)
})
