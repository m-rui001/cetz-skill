#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 单组元推进系统线稿：增压气瓶—调压器—推进剂贮箱—流量控制阀—喷注器—催化剂床—喷管
// 干净平涂风格，来源 Aerospace 2024, 11(7), 502, Figure 10；DOI 10.3390/aerospace11070502
#canvas({
  import draw: *

  // 线宽与文字助手
  let thin = (paint: black, thickness: 0.7pt)
  let pipe = (paint: black, thickness: 2.2pt)
  let grid = (paint: rgb(110, 110, 110), thickness: 0.4pt)
  let label(pos, body, size: 9pt) = content(pos, body, anchor: "center", size: size)
  let larrow(from, to) = line(from, to, stroke: thin, mark: (end: "stealth", fill: black))

  // 地标坐标
  let cy = 2.4
  let p1 = (1.5, cy)                 // 增压气瓶
  let r1 = (3.6, cy)                 // 调压器
  let tk0 = (4.75, 0.9)
  let tk1 = (7.6, 3.9)               // 贮箱对角
  let v1 = (8.3, cy)                 // 流量控制阀
  let i1 = (9.55, cy)                // 喷注器
  let cb0 = (9.95, 1.35)
  let cb1 = (11.05, 3.5)             // 催化剂床对角

  // 增压气瓶与至调压器细管
  circle(p1, radius: 0.95, stroke: thin)
  label(p1, [Pressurant])
  line((p1.at(0) + 0.95, cy), (r1.at(0) - 0.3, cy), stroke: thin)

  // 调压器 R
  circle(r1, radius: 0.3, stroke: thin)
  label(r1, [R], size: 8pt)

  // 推进剂贮箱（灰色平涂圆角矩形）
  rect(tk0, tk1, radius: 0.4, fill: rgb(214, 214, 214), stroke: thin)
  label((6.18, cy + 0.2), [Propellant])
  label((6.18, cy - 0.22), [Tank])

  // 主推进剂管路（粗实线）
  line((r1.at(0) + 0.3, cy), (tk0.at(0), cy), stroke: pipe)
  line((tk1.at(0), cy), (v1.at(0) - 0.32, cy), stroke: pipe)
  line((v1.at(0) + 0.32, cy), (i1.at(0) - 0.32, cy), stroke: pipe)
  line((i1.at(0) + 0.32, cy), (cb0.at(0), cy), stroke: pipe)

  // 流量控制阀 V 与喷注器 I
  circle(v1, radius: 0.32, stroke: thin)
  label(v1, [V], size: 8pt)
  circle(i1, radius: 0.32, stroke: thin)
  label(i1, [I], size: 8pt)

  // 催化剂床外壳与网格填料
  rect(cb0, cb1, fill: rgb(238, 238, 238), stroke: thin)
  for i in range(1, 5) {
    let x = cb0.at(0) + i * 0.22
    line((x, cb0.at(1)), (x, cb1.at(1)), stroke: grid)
  }
  for j in range(1, 6) {
    let y = cb0.at(1) + j * 0.358
    line((cb0.at(0), y), (cb1.at(0), y), stroke: grid)
  }

  // 催化剂床内分解星形
  let star = ()
  for i in range(24) {
    let a = 90deg - i * 15deg
    let r = if calc.odd(i) { 0.24 } else { 0.52 }
    star.push((10.5 + r * calc.cos(a), cy + r * calc.sin(a)))
  }
  line(..star, close: true, fill: white, stroke: thin)

  // 喷管壁：自床右缘先收敛至喉部再外张（拉瓦尔喷管）
  bezier((11.05, 3.5), (12.6, 2.8), (11.8, 3.5), (12.2, 2.8), stroke: thin)
  bezier((12.6, 2.8), (14.0, 3.3), (13.0, 2.8), (13.5, 3.3), stroke: thin)
  bezier((11.05, 1.35), (12.6, 2.0), (11.8, 1.35), (12.2, 2.0), stroke: thin)
  bezier((12.6, 2.0), (14.0, 1.5), (13.0, 2.0), (13.5, 1.5), stroke: thin)

  // 喷管括线标注
  line((12.6, 4.05), (14.1, 4.05), stroke: thin)
  line((12.6, 4.05), (12.6, 4.17), stroke: thin)
  line((14.1, 4.05), (14.1, 4.17), stroke: thin)
  line((13.35, 4.05), (13.35, 4.24), stroke: thin)
  label((13.35, 4.45), [Nozzle])

  // 压力调节器标注与引线
  label((3.25, 4.32), [Pressure])
  label((3.3, 3.98), [Regulator])
  larrow((3.35, 3.83), (3.52, 2.68))

  // 流量控制标注与引线
  label((8.2, 4.32), [Flow])
  label((8.2, 3.98), [Control])
  larrow((8.2, 3.83), (8.28, 2.72))

  // 喷注器标注与引线
  label((9.75, 4.05), [Injector])
  larrow((9.7, 3.85), (9.6, 2.74))

  // 推进剂分解说明（喷管内右侧）
  label((13.3, 2.75), [Propellant])
  label((13.3, 2.4), [Decomposition])

  // 供给系统括线（阀—喷注器下方）
  line((7.85, 1.0), (9.55, 1.0), stroke: thin)
  line((7.85, 1.0), (7.85, 1.18), stroke: thin)
  line((9.55, 1.0), (9.6, 1.35), stroke: thin)
  label((8.5, 0.68), [Feed System])

  // 催化剂床标注（床体正下方）
  label((10.95, 0.95), [Catalyst bed])

  // 高温燃气排气虚线与标注
  line((11.15, 2.15), (14.7, 2.15),
    stroke: (paint: black, thickness: 0.8pt, dash: "dashed"), mark: (end: "stealth", fill: black))
  label((15.4, 2.35), [Hot Gases])
  label((15.4, 2.0), [Exhaustion])
})
