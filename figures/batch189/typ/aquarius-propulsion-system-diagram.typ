#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// AQUARIUS 水基推进系统组成线稿（源：Aerospace 2024, 11(7), 502, Fig.9；DOI 10.3390/aerospace11070502）：加压罐、左侧仪表阀组、双路调节阀、汽化室、ΔV 与 RCS 推力器阵列
#canvas({
  import draw: *
  let ink = rgb("#333333")
  let st = (paint: ink, thickness: 0.7pt)
  let thin = (paint: ink, thickness: 0.55pt)
  let dashc = (paint: rgb("#b3b3b3"), thickness: 0.5pt, dash: "dashed")
  let red = rgb("#c0392b")
  let arrow = (paint: red, thickness: 0.6pt)

  // 通用文字标签
  let lbl(p, body, size: 9pt, anchor: "west") = draw.content(p, text(size: size, body), anchor: anchor)

  // 蝶形阀符号
  let valve(x, y, w: 0.26, h: 0.16) = {
    draw.line((x - w, y - h), (x - w, y + h), (x, y), close: true, stroke: thin)
    draw.line((x + w, y - h), (x + w, y + h), (x, y), close: true, stroke: thin)
    draw.line((x - w, y - h), (x - w, y + h), stroke: thin)
    draw.line((x + w, y - h), (x + w, y + h), stroke: thin)
  }

  // 过滤器双菱形
  let filt(x, y, r: 0.22) = {
    draw.line((x, y + r), (x + r, y), (x, y - r), (x - r, y), close: true, stroke: thin)
    draw.line((x, y + r * 0.55), (x + r * 0.55, y), (x, y - r * 0.55), (x - r * 0.55, y), close: true, stroke: thin)
  }

  // 压力传感器
  let psensor(x, y) = {
    draw.circle((x, y), radius: 0.2, stroke: thin)
    draw.content((x, y), text(size: 7.5pt, "P"))
  }

  // 推力器方块
  let thruster(x, y) = {
    draw.rect((x - 0.15, y - 0.15), (x + 0.15, y + 0.15), stroke: thin)
    draw.rect((x - 0.05, y - 0.05), (x + 0.05, y + 0.05), stroke: thin)
  }

  // 版面分隔虚线
  draw.line((-0.45, 6.4), (-0.45, -0.95), stroke: dashc)
  draw.line((-5.6, 4.6), (3.1, 4.6), stroke: dashc)

  // 加压罐：外壁与内部水囊
  draw.circle((0, 8.2), radius: 1.4, stroke: st)
  draw.circle((0, 7.9), radius: 0.7, stroke: thin)
  lbl((0.3, 9.05), [Pressurizing \ gas], size: 8pt, anchor: "center")
  lbl((0, 7.9), [Liquid \ water], size: 7.5pt, anchor: "center")

  // 罐体引出与左侧支管
  draw.line((0, 9.6), (0, 10.15), (-1.55, 10.15), (-1.55, 6.85), (0, 6.85), stroke: st)

  // 左侧仪表与阀门组
  draw.line((-1.55, 9.72), (-1.89, 9.72), stroke: thin)
  psensor(-2.1, 9.72)
  lbl((-2.42, 9.72), [Tank P sensor], anchor: "east")
  draw.line((-1.55, 9.12), (-1.82, 9.12), stroke: thin)
  valve(-2.08, 9.12)
  lbl((-2.45, 9.12), [Gas Drain Valve], anchor: "east")
  draw.line((-1.55, 8.45), (-1.82, 8.45), stroke: thin)
  valve(-2.08, 8.45)
  lbl((-2.45, 8.45), [Water Drain Valve\*], anchor: "east")
  draw.line((-1.55, 7.85), (-1.89, 7.85), stroke: thin)
  psensor(-2.1, 7.85)
  lbl((-2.42, 7.85), [Water P sensor\*], anchor: "east")

  // 双路调节阀支路
  draw.line((0, 6.85), (0, 6.6), stroke: st)
  draw.line((-0.6, 6.6), (0.55, 6.6), stroke: st)
  for x in (-0.6, 0.55) {
    draw.line((x, 6.6), (x, 6.36), stroke: st)
    filt(x, 6.12)
    draw.line((x, 5.9), (x, 5.77), stroke: thin)
    valve(x, 5.6)
    draw.line((x, 5.44), (x, 5.17), stroke: thin)
    valve(x, 5.0)
    draw.line((x, 4.84), (x, 4.4), stroke: st)
  }
  lbl((-1.2, 5.6), [Regulation valve\*], size: 8.5pt, anchor: "east")
  lbl((1.15, 5.6), [Regulation valve], size: 8.5pt, anchor: "west")

  // 双密封说明框
  draw.rect((-5.55, 5.8), (-3.98, 6.26), radius: 0.08, stroke: thin)
  lbl((-4.765, 6.03), [\*: double seal], size: 8.5pt, anchor: "center")

  // 汽化室主体
  draw.rect((-0.8, 3.6), (0.8, 4.4), stroke: st)
  lbl((0, 4.0), [Vapor], size: 9.5pt, anchor: "center")

  // 汽化室排水阀与压力传感器
  draw.line((-0.8, 4.0), (-1.86, 4.0), stroke: st)
  valve(-1.58, 4.0)
  lbl((-2.02, 4.0), [VC Drain Valve], anchor: "east")
  draw.line((0.8, 4.0), (1.61, 4.0), stroke: st)
  psensor(1.81, 4.0)
  lbl((2.1, 4.0), [VC P sensor], anchor: "west")

  // 汽化室引注
  lbl((2.35, 4.78), [Vaporization Chamber], size: 8.5pt, anchor: "west")
  draw.line((2.3, 4.72), (0.76, 4.3), stroke: arrow, mark: (end: "stealth"))

  // 加压罐引注
  lbl((1.9, 8.7), [Pressurizing Tank], anchor: "west")
  draw.line((1.85, 8.66), (1.34, 8.52), stroke: arrow, mark: (end: "stealth"))
  lbl((1.9, 7.5), [Water Bladder], anchor: "west")
  draw.line((1.85, 7.55), (0.67, 7.88), stroke: arrow, mark: (end: "stealth"))

  // 汽化室出口分流总管
  draw.line((0, 3.6), (0, 3.15), stroke: st)
  draw.line((-2.3, 3.15), (2.35, 3.15), stroke: st)

  // 六条推力器支路（ΔV 两路 + RCS 四路）
  for x in (-2.3, -1.6, 0.4, 1.05, 1.7, 2.35) {
    draw.line((x, 3.15), (x, 2.84), stroke: st)
    filt(x, 2.6)
    draw.line((x, 2.38), (x, 2.12), stroke: thin)
    valve(x, 1.95)
    draw.line((x, 1.79), (x, 1.45), stroke: st)
    thruster(x, 1.3)
  }

  // 推力器阀组名称
  lbl((-2.55, 1.95), [ΔV Thruster \ valve], size: 9pt, anchor: "east")
  lbl((2.65, 1.9), [RCS \ Thruster \ Valve], size: 9pt, anchor: "west")

  // 底部括号（两组）
  let bracket(x1, x2, y, d: 0.13) = {
    draw.line((x1, y), (x1, y - d), (x1 + 0.1, y - d - 0.06), stroke: thin)
    draw.line((x2, y), (x2, y - d), (x2 - 0.1, y - d - 0.06), stroke: thin)
  }
  bracket(-2.5, -1.4, 1.03)
  bracket(0.2, 2.55, 1.03)

  // 底部隔热层注释框（左：ΔV；右：RCS）
  lbl((-2.3, 0.78), [Delta-V Thruster], size: 8.5pt, anchor: "center")
  draw.rect((-3.8, 0.6), (-0.85, -0.85), radius: 0.06, stroke: thin)
  for (i, t) in ([Pre-heater], [DVT Thermal Insulator], [Nozzle]).enumerate() {
    lbl((-3.68, 0.34 - i * 0.38), t, size: 8pt)
  }

  lbl((1.5, 0.78), [RCS Thruster], size: 8.5pt, anchor: "center")
  draw.rect((0.1, 0.6), (3.0, -0.85), radius: 0.06, stroke: thin)
  for (i, t) in ([Pre-heater], [RCT Thermal Insulator], [Nozzle]).enumerate() {
    lbl((0.22, 0.34 - i * 0.38), t, size: 8pt)
  }
})
