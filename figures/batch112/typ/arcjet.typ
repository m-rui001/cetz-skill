// 电弧喷射推进器（Arcjet）结构示意
// 编译效果：左侧灰色圆角框内两行 "Propellant Storage"；粗黑管道穿过带 "V" 的白色
// 圆圈，其上方 "Flow Control" 以短黑箭头下指该圆；管道继续进入蓝色细线腔体，腔体右肩
// 上下各向内收拢，止于阳极间隙。腔心灰色 "Cathode" 方条右端接灰色锥尖，其上下各一条
// 右向虚线气流箭头，锥尖出口处另有两条短虚线箭头射入间隙。右侧上下两块灰色 "Anode"，
// 右端细引线向外张开；两阳极之间为蓝灰闪电形电弧，右侧标 "Arc"，其后虚线箭头指向右端
// 两行标签 "Heated Gas Exhaust"。
// 来源：Propulsion Technologies for CubeSats: Review. Aerospace 2024, 11(7), 502, Figure 16.
// DOI 10.3390/aerospace11070502
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1cm, {
  import draw: *

  // —— 配色 ——
  let gray = rgb("#d9d9d9")
  let blue = rgb("#2e3f7a")
  let arc-fill = rgb("#b7c4d6")

  // —— 基准：阴极轴线与腔体轮廓 ——
  let y-mid = 0                       // 阴极轴线（全图水平基准）
  let x-wall = 6.30                   // 腔体左壁
  let y-top = 1.45                    // 腔体上壁
  let y-bot = -1.45                   // 腔体下壁
  let x-shoulder = 9.30               // 肩部起弯处
  let x-gap = 10.25                   // 阳极左端面（放电间隙入口）
  let x-anode-r = 13.70               // 阳极右端面
  let y-anode-in = 0.42               // 阳极内表面
  let y-anode-out = 1.02              // 阳极外表面
  let y-anode-mid = (y-anode-in + y-anode-out) / 2

  // —— 基准：阴极、气流与电弧 ——
  let x-cath-l = 6.80                 // 阴极左端
  let x-cath-r = 9.20                 // 阴极右端（锥尖起点）
  let y-cath = 0.25                   // 阴极半高
  let x-cone = 10.15                  // 锥尖顶点
  let y-flow = 0.62                   // 腔底气流的偏移
  let x-flow-r = 9.35                 // 腔内气流箭头终点
  let x-arc = 11.15                   // 电弧左端

  // —— 共用助手：虚线箭头（实心箭头单绘，避免轮廓被虚线切碎）、标签 ——
  let darrow(a, b, w: 1.6pt, s: 1.9) = {
    let dx = b.at(0) - a.at(0)
    let dy = b.at(1) - a.at(1)
    let l = calc.sqrt(dx * dx + dy * dy)
    let c = (b.at(0) - dx / l * 0.17 * s, b.at(1) - dy / l * 0.17 * s)
    draw.line(a, c, stroke: (paint: black, thickness: w, dash: "dashed"))
    draw.line(c, b, stroke: (paint: black, thickness: w),
      mark: (end: ">", fill: black, scale: s))
  }
  let lab(pos, body, anchor: "center") = draw.content(pos, body, anchor: anchor)

  // —— 推进剂储箱：灰色圆角框 ——
  draw.rect((0.30, -2.15), (4.15, 2.15), radius: 0.42,
    fill: gray, stroke: (paint: black, thickness: 1.1pt))
  lab((2.22, 0.26), [Propellant])
  lab((2.22, -0.30), [Storage])

  // —— 主输送管与流量控制阀（V 圆）——
  let x-v = 5.10
  let r-v = 0.42
  draw.line((4.15, y-mid), (x-v - r-v, y-mid), stroke: (paint: black, thickness: 3pt))
  draw.line((x-v + r-v, y-mid), (x-wall, y-mid), stroke: (paint: black, thickness: 3pt))
  draw.circle((x-v, y-mid), radius: r-v,
    fill: white, stroke: (paint: black, thickness: 1.2pt))
  lab((x-v, y-mid), [V])

  // —— Flow Control 标签及其下指箭头 ——
  lab((x-v + 0.85, 1.82), [Flow Control])
  draw.line((x-v + 0.62, 1.50), (x-v + 0.24, 0.88),
    stroke: (paint: black, thickness: 1.1pt), mark: (end: ">", fill: black, scale: 1.5))

  // —— 放电腔：左壁、上下壁与内收肩部 ——
  draw.line((x-wall, y-bot), (x-wall, y-top), (x-shoulder, y-top),
    stroke: (paint: blue, thickness: 0.9pt))
  draw.line((x-wall, y-bot), (x-shoulder, y-bot), stroke: (paint: blue, thickness: 0.9pt))
  draw.bezier((x-shoulder, y-top), (x-gap, y-anode-out), (9.90, y-top), (9.95, y-anode-out),
    stroke: (paint: blue, thickness: 0.9pt))
  draw.bezier((x-shoulder, y-bot), (x-gap, -y-anode-out), (9.90, y-bot), (9.95, -y-anode-out),
    stroke: (paint: blue, thickness: 0.9pt))

  // —— 阴极：灰色方条 + 右指锥尖 ——
  draw.rect((x-cath-l, -y-cath), (x-cath-r, y-cath),
    fill: gray, stroke: (paint: black, thickness: 1pt))
  draw.line((x-cath-r, -y-cath), (x-cone, y-mid), (x-cath-r, y-cath),
    close: true, fill: gray, stroke: (paint: black, thickness: 1pt))
  lab(((x-cath-l + x-cath-r) / 2, y-mid), [Cathode])

  // —— 腔内气流：阴极上下两条右向虚线箭头 ——
  darrow((x-cath-l, y-flow), (x-flow-r, y-flow))
  darrow((x-cath-l, -y-flow), (x-flow-r, -y-flow))

  // —— 锥尖出口：两条短虚线箭头射入阳极间隙 ——
  darrow((x-cone + 0.22, 0.12), (x-arc - 0.15, 0.12), w: 1.3pt, s: 1.5)
  darrow((x-cone + 0.22, -0.12), (x-arc - 0.15, -0.12), w: 1.3pt, s: 1.5)

  // —— 阳极对：上下两块灰色方条 ——
  draw.rect((x-gap, y-anode-in), (x-anode-r, y-anode-out),
    fill: gray, stroke: (paint: black, thickness: 1.1pt))
  draw.rect((x-gap, -y-anode-out), (x-anode-r, -y-anode-in),
    fill: gray, stroke: (paint: black, thickness: 1.1pt))
  lab(((x-gap + x-anode-r) / 2, y-anode-mid), [Anode])
  lab(((x-gap + x-anode-r) / 2, -y-anode-mid), [Anode])

  // —— 阳极引线：自右端向外张开 ——
  draw.line((x-anode-r, y-anode-mid), (15.45, 1.18), stroke: (paint: black, thickness: 0.8pt))
  draw.line((x-anode-r, -y-anode-mid), (15.45, -1.18), stroke: (paint: black, thickness: 0.8pt))

  // —— 电弧：蓝灰闪电形闭合多边形，置于两阳极之间 ——
  let bolt = ((0, 0.00), (0.42, 0.24), (0.70, 0.08), (1.10, 0.28), (1.48, 0.08),
    (1.90, 0.18), (1.55, -0.02), (1.16, -0.06), (0.78, -0.22), (0.46, -0.06), (0.16, -0.16))
  draw.line(..bolt.map(p => (p.at(0) + x-arc, p.at(1))),
    close: true, fill: arc-fill, stroke: (paint: blue, thickness: 0.9pt))
  lab((x-arc + 2.40, y-mid), [Arc])

  // —— 排气：自电弧区右指的虚线箭头与两行标签 ——
  darrow((x-arc + 2.87, y-mid), (x-arc + 4.00, y-mid))
  lab((x-arc + 5.13, 0.26), [Heated Gas])
  lab((x-arc + 5.13, -0.30), [Exhaust])
})
