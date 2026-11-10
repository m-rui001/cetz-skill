#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 分支流程示意图（干净线稿平涂）：左侧废锂电池图标 + 预处理框，右侧上/中/下三个灰面板分属 Other / Cathode / Anode 菱形分支，各带分隔线、下行箭头与两行说明文字。
// 来源：Batteries 2024, 10, 38, Figure 4（DOI 10.3390/batteries10010038）。
#canvas({
  import draw: *

  // 配色
  let magenta = rgb(232, 0, 200)
  let teal = rgb(78, 190, 184)
  let blue = rgb(20, 105, 200)
  let grey = rgb(125, 125, 125)
  let edge = rgb(198, 198, 198)
  let pink = rgb(250, 228, 232)

  // 三个灰色圆角面板（上 / 中 / 下）
  for (y0, y1) in ((10.85, 13.55), (3.75, 10.50), (0.55, 3.30)) {
    rect((6.9, y0), (23.5, y1), radius: 0.3, stroke: (paint: edge, thickness: 1.8pt))
  }

  // 菱形组件块
  let diamond(cx, cy, hw, hh, col, label) = {
    line((cx - hw, cy), (cx, cy + hh), (cx + hw, cy), (cx, cy - hh), close: true, stroke: (paint: col, thickness: 2pt))
    content((cx, cy), label, size: 9.5pt)
  }
  diamond(8.8, 12.20, 1.45, 0.85, teal, [Other])
  diamond(8.8, 7.50, 1.65, 1.10, blue, [Cathode])
  diamond(8.8, 2.05, 1.60, 1.00, grey, [Anode])

  // 各面板分隔线 + 向下粗箭头
  for (col, y, x0, x1, ax) in (
    (teal, 12.62, 10.4, 23.2, 16.9),
    (blue, 6.50, 11.0, 22.9, 16.8),
    (grey, 1.95, 10.5, 23.2, 17.0),
  ) {
    line((x0, y), (x1, y), stroke: (paint: col, thickness: 2pt))
    line((ax, y - 0.12), (ax, y - 0.85), stroke: (paint: col, thickness: 2pt), mark: (end: "stealth", fill: col, scale: 1.7))
  }

  // 上方面板文字（Other）
  content((16.9, 13.02), [Chemical and physical methods for separation of components], size: 9.5pt)
  content((16.9, 11.52), [Plastic case/ binder / separator / PFA components /current], size: 9pt)
  content((16.9, 11.08), [collectors / electrolyte solvent / electrolyte salt], size: 9pt)

  // 中方面板文字（Cathode 三条工艺）
  content((11.7, 9.72), [*Hydrometallurgy:* inorganic acid leaching / organic acid], anchor: "west", size: 9pt)
  content((11.7, 9.24), [leaching/ ammonia leaching / bioleaching / solvometallurgy.], anchor: "west", size: 9pt)
  content((11.7, 8.14), [*Pyrometallurgy:* high temperature pyrometallurgy / low], anchor: "west", size: 9pt)
  content((11.7, 7.66), [temperature pyrolysis / microwave treatments], anchor: "west", size: 9pt)
  content((11.7, 6.88), [*Mechanochemical method:* high energy ball milling], anchor: "west", size: 9pt)

  // 中方面板产物
  content((15.9, 5.28), [Li, Co, Ni, Mn in form of oxides and /or salts or regenerated], size: 9pt)
  content((15.9, 4.80), [LCO, LMO, NMC, NCA, LFP], size: 9pt)

  // 下方面板文字（Anode）
  content((17.2, 2.66), [Chemical and physical methods for separation of components], size: 9.5pt)
  content((16.9, 0.98), [Graphene/ Lithium salts/ regenerated graphite], size: 9pt)

  // 左侧：废锂电池图标（倾斜圆柱）
  circle((3.7, 10.95), radius: 2.2, fill: pink, stroke: (paint: magenta, thickness: 2.2pt))
  let c0 = (3.7, 10.95)
  let ang = -20deg
  let rp(x, y) = {
    let ca = calc.cos(ang)
    let sa = calc.sin(ang)
    (c0.at(0) + x * ca - y * sa, c0.at(1) + x * sa + y * ca)
  }
  // 壳体
  line(rp(-0.62, -1.05), rp(0.62, -1.05), rp(0.62, 1.05), rp(-0.62, 1.05), close: true,
    fill: rgb(244, 214, 216), stroke: (paint: rgb(160, 120, 120), thickness: 0.8pt))
  // 正极帽
  line(rp(-0.45, 1.05), rp(0.45, 1.05), rp(0.45, 1.32), rp(-0.45, 1.32), close: true,
    fill: rgb(205, 205, 210), stroke: (paint: rgb(150, 150, 155), thickness: 0.8pt))
  // 凸点
  line(rp(-0.18, 1.32), rp(0.18, 1.32), rp(0.18, 1.5), rp(-0.18, 1.5), close: true,
    fill: rgb(185, 185, 190), stroke: (paint: rgb(150, 150, 155), thickness: 0.8pt))
  // 标签
  content(rp(0, 0), [*Waste* \ *LIB*], angle: 70deg, size: 8.5pt)

  // 左侧：预处理框
  rect((0.45, 4.5), (5.85, 7.75), radius: 0.35, stroke: (paint: magenta, thickness: 2.2pt))
  content((3.15, 7.18), [*Pre-treatments*], size: 12pt)
  for (i, s) in ("Discharge", "Dismantle", "Separate", "Size reduction").enumerate() {
    content((3.15, 6.58 - i * 0.44), s, size: 9.5pt)
  }

  // 品红粗箭头：圆 → 框，框 → 中面板
  line((3.7, 8.70), (3.7, 7.82), stroke: (paint: magenta, thickness: 3pt), mark: (end: "stealth", fill: magenta, scale: 1.8))
  line((5.88, 6.10), (6.84, 6.10), stroke: (paint: magenta, thickness: 3pt), mark: (end: "stealth", fill: magenta, scale: 1.8))
})
