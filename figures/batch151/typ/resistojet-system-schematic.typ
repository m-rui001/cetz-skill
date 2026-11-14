#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 图：Resistojet 电阻加热推进系统原理 —— 储罐 → 调压阀 R → 阀门 V → 加热室 → 喷管
// 出处：Aerospace 2024, 11(7), 502, Figure 5；DOI 10.3390/aerospace11070502；CAD 渲染转干净线稿平涂
#canvas({
  import draw: *
  // 地标坐标：主轴线、储罐、阀件、加热室框、喷管喉部与出口
  let ax = 2.5
  let tank = (2.6, 2.9)
  let tank-r = 2.2
  let reg = (5.55, ax)
  let val = (6.75, ax)
  let htr = (9.0, ax)
  let box-l = 7.75
  let box-r = 10.75
  let box-b = 1.0
  let box-t = 3.55
  let throat = 12.9
  let noz-out = 15.7
  let rv = 0.42
  let wire = rgb("#2a4b9b")
  let gray = rgb("#d9d9d9")
  let gray2 = rgb("#cfcfcf")
  // 储罐（灰色大圆）与两行标签
  circle(tank, radius: tank-r, fill: gray, stroke: 1.2pt)
  content(tank, align(center, text(size: 11pt)[Propellant \ Tank]))
  // 储罐出流点起的粗管线：到 R、V 与加热室左缘
  let exit-x = tank.at(0) + calc.sqrt(tank-r * tank-r - (ax - tank.at(1)) * (ax - tank.at(1)))
  line((exit-x, ax), (reg.at(0) - rv, ax), stroke: 2.5pt)
  line((reg.at(0) + rv, ax), (val.at(0) - rv, ax), stroke: 2.5pt)
  line((val.at(0) + rv, ax), (box-l, ax), stroke: 2.5pt)
  // 调压阀 R 与阀门 V（表驱动循环）
  for (c, ch) in ((reg, "R"), (val, "V")) {
    circle(c, radius: rv, fill: white, stroke: 1pt)
    content(c, text(size: 9pt, ch))
  }
  // Pressure Regulator 标签及两条指示箭头
  content((5.4, 3.9), align(center)[Pressure \ Regulator], anchor: "south")
  line((5.0, 3.78), (5.42, 3.0), stroke: 0.9pt, mark: (end: "stealth"))
  line((6.15, 3.78), (6.7, 3.0), stroke: 0.9pt, mark: (end: "stealth"))
  // Feed Lines & Valves 托架（含中央下垂尖）与标签
  line((4.95, 2.05), (4.95, 1.9), (7.35, 1.9), (7.35, 2.05), stroke: 0.9pt)
  line((5.95, 1.9), (6.15, 1.68), (6.35, 1.9), stroke: 0.9pt)
  content((6.15, 1.6), align(center)[Feed Lines \ & Valves], anchor: "north")
  // 加热室蓝框与上方、框内左上标签
  rect((box-l, box-b), (box-r, box-t), stroke: (paint: wire, thickness: 1pt))
  content((9.25, box-t + 0.15), [Flow Control], anchor: "south")
  content((box-l + 0.12, box-t - 0.15), text(size: 9.5pt)[Gas Release], anchor: "north-west")
  // 加热圆体（内嵌 Heating 标签）与电阻加热器锯齿符号
  circle(htr, radius: 0.6, fill: gray2, stroke: 1pt)
  content(htr, text(size: 8.5pt)[Heating])
  line((8.45, 0.85), (8.65, 0.85), stroke: 1pt)
  line((8.65, 0.85), (8.76, 1.1), (8.88, 0.6), (9.0, 1.1), (9.12, 0.6), (9.24, 1.1), (9.35, 0.85), stroke: 1pt)
  line((9.35, 0.85), (9.55, 0.85), stroke: 1pt)
  line((9.0, 1.1), (9.0, 1.82), stroke: 1pt, mark: (end: "stealth"))
  // 加热后气流的粗虚线箭头（穿出蓝框进入喷管）
  line((9.62, ax), (11.9, ax),
    stroke: (paint: black, thickness: 2pt, dash: "dashed"), mark: (end: "stealth", fill: black))
  // 喷管上下壁：镜像两段三次曲线在喉部相接（bezier 参数序＝起点,终点,控制1,控制2）
  for s in (-1, 1) {
    let m(y) = ax + s * (y - ax)
    bezier((box-r, m(3.10)), (throat, m(2.90)), (11.6, m(3.10)), (12.2, m(2.90)), stroke: 1.2pt)
    bezier((throat, m(2.90)), (noz-out, m(4.25)), (13.6, m(2.90)), (14.6, m(3.60)), stroke: 1.2pt)
  }
  // Nozzle 括线（含中央凸尖）与标签
  line((11.9, 4.62), (11.9, 4.42), (noz-out, 4.42), (noz-out, 4.62), stroke: 0.9pt)
  line((13.7, 4.42), (13.9, 4.62), (14.1, 4.42), stroke: 0.9pt)
  content((13.9, 4.70), [Nozzle], anchor: "south")
  // 排气方向两行文字（喷管出口右侧）
  content((noz-out + 0.25, 2.62), align(left)[Heated Gas \ Exhaustion], anchor: "west")
})
