#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 9pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 微腔放电(MCD)推力器结构示意图：上下对称铝电极夹氧化铝介质层，
// 中央微腔等离子体、右侧收敛喷管与红焰、顶部交流电源。
// 来源：Aerospace 2024, 11(7), 502, Figure 17（DOI 10.3390/aerospace11070502）。
#canvas({
  import draw: *

  // 配色
  let c-blue = rgb("#2f6fb5")
  let c-diel = rgb("#bcd2e8")
  let c-noz  = rgb("#9a9a45")
  let c-plas = rgb("#f7c500")
  let c-flame = rgb("#e3200f")
  let c-flow = rgb("#5faf2f")

  // 焰形轮廓助手：左尖右钝的喇叭形（幂函数采样上/下缘）
  let wedge(len, wid, p) = {
    let n = 8
    let up = ()
    let dn = ()
    for i in range(n + 1) {
      let t = i / n
      up.push((0.12 + t * len, wid * calc.pow(t, p)))
      dn.push((0.12 + t * len, -wid * calc.pow(t, p)))
    }
    up + ((0.12 + len + 0.07, wid * 0.52), (0.12 + len + 0.07, -wid * 0.52)) + dn.rev()
  }

  // 上下对称：铝基板电极、介质层、粗黑引线、橄榄色收敛喷管
  for sy in (1, -1) {
    rect((-1.35, sy * 0.95), (-0.32, sy * 3.15), fill: c-blue, stroke: black)
    rect((0.32, sy * 0.95), (1.35, sy * 3.15), fill: c-blue, stroke: black)
    rect((-0.32, sy * 0.82), (0.32, sy * 3.15), fill: c-diel, stroke: black)
    // 铝基板引线（粗黑）
    line((-3.3, sy * 0.55), (-1.35, sy * 0.55), stroke: (paint: black, thickness: 3pt))
    // 喷管收敛段
    line((1.35, sy * 0.85), (1.35, sy * 2.2), (2.6, sy * 2.2), (2.6, sy * 1.35),
         close: true, fill: c-noz, stroke: black)
  }

  // 顶部交流电源符号及其连线
  line((-0.2, 3.15), (-0.2, 3.8), stroke: black)
  line((0.2, 3.15), (0.2, 3.8), stroke: black)
  circle((0, 3.8), radius: 0.28, fill: white, stroke: black)
  // 单周期正弦符号（折线近似）
  line((-0.16, 3.8), (-0.08, 3.92), (0, 3.8), (0.08, 3.68), (0.16, 3.8),
       stroke: black)

  // 红色尾焰与外层橙黄内焰
  line(..wedge(2.33, 0.80, 0.60), close: true, fill: c-flame, stroke: black)
  line(..wedge(1.40, 0.34, 0.55), close: true, fill: rgb("#f28a10"), stroke: none)

  // 微腔等离子体放电（黄球）
  circle((0, 0), radius: 0.42, fill: c-plas, stroke: rgb("#c85a00"))

  // 绿色进气箭头
  line((-3.25, 0.17), (-0.9, 0.17), (-0.9, 0.34), (-0.42, 0),
       (-0.9, -0.34), (-0.9, -0.17), (-3.25, -0.17), close: true,
       fill: c-flow, stroke: black)
  content((-2.1, 0), [*Flow*], anchor: "center")

  // 标注：氧化铝介质层
  content((-2.55, 4.35), align(center)[*Aluminum Oxide* \ *Dielectric Layer*],
    anchor: "center", size: 8.5pt)
  line((-2.55, 3.9), (-2.55, 3.45), (-0.1, 3.45), (-0.1, 3.2),
       mark: (end: "stealth", fill: black), stroke: black)

  // 标注：交流电源电压
  content((0.6, 4.15), [20-125 kHz AC Voltage], anchor: "west", size: 8.5pt)
  line((0.55, 4.07), (0.24, 3.98), mark: (end: "stealth", fill: black), stroke: black)

  // 标注：铝基板
  content((-4.75, 2.85), [*Aluminum Substrate*], anchor: "west", size: 8.5pt)
  line((-4.75, 2.7), (-4.75, 2.45), (-1.6, 2.45),
       mark: (end: "stealth", fill: black), stroke: black)

  // 标注：超音速喷管
  content((1.55, 2.8), [*Supersonic Nozzle*], anchor: "west", size: 8.5pt)
  line((1.9, 2.47), (1.9, 2.24), mark: (end: "stealth", fill: black), stroke: black)

  // 标注：放电区温度
  content((-4.65, -1.75), [$T_0$ #sym.tilde 900 K Discharge], anchor: "west", size: 8.5pt)
  line((-0.8, -1.5), (-0.18, -0.42), mark: (end: "stealth", fill: black), stroke: black)

  // 标注：羽流温度（置于喷管下方，避免压住色块）
  content((2.72, -2.15), [$T_0$ #sym.tilde 500 K Exhaust Plume], anchor: "west", size: 8.5pt)
  line((2.45, -2.0), (2.45, -0.98), mark: (end: "stealth", fill: black), stroke: black)
})
