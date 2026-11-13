#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：电动汽车 LFP 电池管理系统功能框图。左侧 Battery pack 经三路橙色箭头（V1..Vn、I1..In、T1..Tn）
// 进入竖排 Measurement through sensors；向右依次为 SOC estimation、Battey capability estimation、
// RUL prediction；下方 SOH estimation（Cycle number 输入）、SOT estimation and thermal management
//（Fan/Heater 输出）、Cell balancing（放电开关与充电初始化信号）、Fault diagnosis（Leakage level）；
// 右侧 Signal transmission 经橙色双箭头接竖排 Controlled transceiver；顶部 Correspondence 回环，
// 右上 Charge/discharge current limitation。全部标签逐字保留。
// 来源：Batteries 2024, 10, 424, Figure 19 "Functional block diagram of battery management system for electric vehicles" DOI 10.3390/batteries10120424

#canvas({
  import draw: *
  let ink = black
  let orange = rgb("#e8873a")
  let gray = rgb("#d9d9d9")
  let cream = rgb("#fdf3c8")
  let lblue = rgb("#dbe7f5")
  let mblue = rgb("#ccd7e8")
  let peach = rgb("#fbdcc8")
  let lgreen = rgb("#cfe8c8")
  let box(cx, cy, w, h, s, fill, size: 7.2pt) = {
    rect((cx - w / 2, cy - h / 2), (cx + w / 2, cy + h / 2), fill: fill, stroke: 1pt + ink)
    content((cx, cy), text(size: size, s))
  }
  let tx(x, y, s, size: 7pt, anchor: "center") = content((x, y), text(size: size, s), anchor: anchor, frame: none)
  let arr(a, b, c: ink, t: 1pt) = line(a, b, stroke: (paint: c, thickness: t),
    mark: (end: "stealth", scale: 0.55, fill: c))

  // 电池包与三路测量箭头
  rect((1.75, 3.30), (2.25, 5.60), fill: gray, stroke: 1pt + ink)
  content((2.0, 4.45), text(size: 7.5pt, [Battery pack]), angle: 90deg, frame: none)
  arr((2.25, 5.35), (3.80, 5.35), c: orange, t: 2.2pt)
  arr((2.25, 4.80), (3.80, 4.80), c: orange, t: 2.2pt)
  arr((2.25, 4.25), (3.80, 4.25), c: orange, t: 2.2pt)
  tx(3.05, 5.60, [$V_1$ to $V_n$])
  tx(3.05, 5.05, [$I_1$ to $I_n$])
  tx(3.05, 4.50, [$T_1$ to $T_n$])

  // 测量汇总（竖排）
  rect((3.85, 2.95), (4.55, 6.00), fill: cream, stroke: 1pt + ink)
  content((4.20, 4.48), text(size: 7.2pt, [Measurement through sensors]), angle: 90deg, frame: none)

  // 上层估计链：SOC → 能力估计 → RUL
  box(7.40, 5.95, 1.65, 0.90, [SOC\ estimation], lblue)
  box(10.65, 6.00, 2.15, 1.05, [Battey\ capability\ estimation], mblue)
  box(12.85, 5.62, 1.55, 0.62, [RUL\ prediction], cream)

  // 下层估计：SOH、SOT 与热管理
  box(7.40, 4.55, 1.65, 0.80, [SOH\ estimation], lblue)
  box(7.40, 3.45, 1.85, 0.95, [SOT estimation\ and thermal\ management], lblue)

  // 均衡、故障诊断与信号发送
  box(9.45, 2.35, 1.70, 0.80, [Cell\ balancing], peach)
  box(9.55, 1.08, 1.65, 0.95, [Fault\ diagnosis], lgreen)
  box(13.55, 3.55, 1.75, 0.90, [Signal\ transmission], mblue)

  // 受控收发器（竖排双箭头块）
  rect((15.55, 1.60), (16.10, 5.30), fill: lblue, stroke: 1pt + ink)
  content((15.82, 3.45), text(size: 7.5pt, [Controlled transceiver]), angle: 90deg, frame: none)

  // 测量口到 SOC / SOT
  tx(5.05, 5.98, [$V_("Pack")$], size: 6.6pt, anchor: "west")
  arr((4.55, 5.85), (6.55, 5.85))
  tx(5.05, 5.62, [$I_("Pack")$], size: 6.6pt, anchor: "west")
  arr((4.55, 5.50), (6.55, 5.50))
  tx(5.05, 4.62, [$I_("Pack")$], size: 6.6pt, anchor: "west")
  line((4.55, 4.55), (5.45, 4.55), (5.45, 4.05), (6.45, 4.05), stroke: 1pt + ink,
    mark: (end: "stealth", scale: 0.55, fill: ink))
  tx(5.05, 3.95, [$V_("Pack")$], size: 6.6pt, anchor: "west")
  arr((4.55, 3.88), (6.45, 3.88))
  tx(5.05, 3.55, [$T_("Pack")$], size: 6.6pt, anchor: "west")
  arr((4.55, 3.48), (6.45, 3.48))

  // SOC 输出与至能力估计的输入
  arr((8.22, 5.85), (9.55, 5.85))
  tx(8.60, 6.10, [SOC], size: 7.2pt, anchor: "west")
  tx(9.00, 6.28, [$T_("Pack")$], size: 6.6pt, anchor: "east")
  tx(9.00, 5.75, [$V_("Pack")$], size: 6.6pt, anchor: "east")
  arr((9.05, 6.28), (9.55, 6.28))
  arr((9.05, 5.75), (9.55, 5.75))
  arr((11.72, 5.62), (12.05, 5.62))
  // SOC/SOH 纵向连接
  arr((7.40, 5.50), (7.40, 4.97))
  arr((7.40, 4.15), (7.40, 3.95))
  // SOH 输出 Capability、Cycle number 输入
  line((8.22, 4.70), (9.05, 4.70), (9.05, 5.45), stroke: 1pt + ink,
    mark: (end: "stealth", scale: 0.55, fill: ink))
  tx(9.85, 4.62, [Capability], size: 7pt)
  arr((9.40, 4.30), (8.22, 4.30))
  tx(8.85, 4.48, [Cycle number], size: 6.8pt)
  // SOT 输出 Fan / Heater
  arr((8.32, 3.70), (9.10, 3.70))
  tx(9.45, 3.70, [Fan], size: 7.2pt, anchor: "west")
  arr((8.32, 3.18), (9.10, 3.18))
  tx(9.45, 3.18, [Heater], size: 7.2pt, anchor: "west")

  // 均衡与故障诊断连线
  tx(7.30, 2.60, [$V_1$ to $V_n$  $V_("Pack")$], size: 6.8pt, anchor: "east")
  arr((7.95, 2.35), (8.60, 2.35))
  arr((8.60, 2.12), (7.55, 2.12))
  tx(6.95, 1.90, [Discharge switch signals], size: 6.8pt, anchor: "east")
  line((10.30, 2.62), (11.35, 2.62), (11.35, 3.55), (12.65, 3.55), stroke: 1pt + ink,
    mark: (end: "stealth", scale: 0.55, fill: ink))
  tx(11.05, 2.86, [End of balancing], size: 6.8pt, anchor: "west")
  line((13.55, 3.12), (11.35, 3.12), (11.35, 2.35), (10.30, 2.35), stroke: 1pt + ink,
    mark: (end: "stealth", scale: 0.55, fill: ink))
  tx(11.75, 2.12, [Charge initialize signal], size: 6.8pt, anchor: "west")
  // 故障诊断三路输入与 Leakage level 输出
  tx(8.55, 1.40, [$V_("Pack")$], size: 6.6pt, anchor: "east")
  arr((8.05, 1.33), (8.72, 1.33))
  tx(8.55, 1.10, [$I_("Pack")$], size: 6.6pt, anchor: "east")
  arr((8.05, 1.06), (8.72, 1.06))
  tx(8.55, 0.80, [$T_("Pack")$], size: 6.6pt, anchor: "east")
  arr((8.05, 0.80), (8.72, 0.80))
  line((10.38, 1.10), (12.35, 1.10), (12.35, 3.10), stroke: 1pt + ink,
    mark: (end: "stealth", scale: 0.55, fill: ink))
  tx(11.25, 1.34, [Leakage level], size: 6.8pt, anchor: "west")

  // 能力输出 Capability 进信号发送、Correspondence 回环与顶部限制
  line((11.00, 5.45), (11.00, 4.60), (13.90, 4.60), (13.90, 4.00), stroke: 1pt + ink,
    mark: (end: "stealth", scale: 0.55, fill: ink))
  tx(12.30, 4.82, [Capability], size: 7pt)
  line((7.40, 6.42), (7.40, 6.90), (15.70, 6.90), (15.70, 5.30), stroke: 1pt + ink,
    mark: (end: "stealth", scale: 0.55, fill: ink))
  tx(11.00, 7.05, [Correspondence], size: 7.2pt)
  line((12.85, 6.00), (12.85, 6.38), (15.90, 6.38), (15.90, 5.30), stroke: 1pt + ink)
  tx(13.05, 6.60, [Charge/discharge\ current limitation], size: 6.8pt)
  // 信号发送与收发器之间的橙色双箭头
  line((14.42, 3.55), (15.55, 3.55), stroke: (paint: orange, thickness: 2.6pt),
    mark: (start: "stealth", end: "stealth", scale: 0.6, fill: orange))
})
