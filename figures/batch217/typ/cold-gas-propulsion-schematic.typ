#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 冷气推进系统原理示意图：灰色圆形推进剂贮箱 → R 调压阀 → V 流量控制阀 → 收扩喷管，
// 含 Gas Release / Gas Expansion 虚线箭头与 Feed Lines & Valves、Nozzle 方括号标注。
// 来源：Aerospace 2024, 11(7), 502, Fig.2；DOI 10.3390/aerospace11070502
#canvas({
  import draw: *

  // 方形括号：dir=1 朝上、-1 朝下
  let bracket(x0, x1, y, dir) = {
    line((x0, y + dir * 0.22), (x0, y), (x1, y), (x1, y + dir * 0.22))
  }
  // 圆形阀体符号＋中心字母
  let valve(c, letter) = {
    circle(c, radius: 0.4, fill: white, stroke: 1pt)
    content(c, letter)
  }
  // 指引箭头：从标签指向部件
  let leader(from, to) = line(from, to, mark: (end: "stealth"), stroke: 0.8pt)

  // 推进剂贮箱（灰色平涂圆）
  circle((2.2, 0), radius: 1.8, fill: rgb("#c9c9c9"), stroke: 1pt)
  content((2.2, 0), [Propellant \ Tank])

  // 贮箱到喷管的馈管主线（穿过 R、V 阀）
  line((4.0, 0), (7.6, 0), stroke: 1.6pt)
  valve((4.8, 0), [R])
  valve((6.2, 0), [V])

  // 阀上方标签与指引箭头
  content((4.8, 1.7), [Pressure \ Regulator])
  leader((4.8, 1.15), (4.8, 0.45))
  content((7.0, 1.5), [Flow Control])
  leader((6.7, 1.2), (6.3, 0.45))

  // 阀组下方方括号＋标签
  bracket(4.4, 6.6, -0.55, -1)
  content((5.5, -1.15), [Feed Lines \ & Valves])

  // 喷管收扩轮廓：上下镜像，入口直段→收敛喉部→扩张段
  line((7.6, -1.0), (7.6, 1.0), stroke: 0.8pt)
  for s in (1, -1) {
    line((7.6, s * 1.0), (9.0, s * 1.0), stroke: 0.8pt)
    bezier((9.0, s * 1.0), (10.6, s * 0.35), (9.9, s * 1.0), (10.1, s * 0.35), stroke: 0.8pt)
    bezier((10.6, s * 0.35), (13.5, s * 1.0), (11.0, s * 0.95), (12.2, s * 1.0), stroke: 0.8pt)
  }

  // 腔内气体释放与扩张段虚线箭头
  line((7.9, 0), (9.7, 0), mark: (end: "stealth", fill: black), stroke: (dash: "dashed", thickness: 1.4pt))
  content((8.7, 0.5), [Gas Release])
  line((11.0, 0), (12.9, 0), mark: (end: "stealth", fill: black), stroke: (dash: "dashed", thickness: 1.4pt))
  content((12.0, 0.45), [Gas Expansion])

  // 喷管上方方括号＋标签
  bracket(9.2, 13.5, 1.5, 1)
  content((11.35, 1.95), [Nozzle])
})