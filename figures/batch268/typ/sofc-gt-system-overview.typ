#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 两种固体氧化物燃料电池与燃气轮机耦合结构的并列线稿，上方为流体颜色图例，下方为部件图例。
// 来源：Aerospace 2026, 13, 263, Figure 1. DOI 10.3390/aerospace13030263
#canvas({
  import draw: *
  let blue = rgb("#4c9ed3")
  let green = rgb("#55bc99")
  let purple = rgb("#933a99")
  let dark-green = rgb("#12604a")
  let red = rgb("#ce171c")
  let orange = rgb("#e67e22")
  // 通用管线与设备符号。
  let pipe(points, color, dashed: false, arrow: true) = {
    line(..points,
      stroke: (paint: color, thickness: 1.2pt, dash: if dashed { "dashed" } else { "solid" }),
      mark: if arrow { (end: "stealth", fill: color) } else { none })
  }
  let exchanger(x, y) = {
    circle((x, y), radius: 0.32, stroke: 1pt, fill: white)
    line((x, y + 0.32), (x, y + 0.15), (x + 0.15, y + 0.07),
      (x - 0.15, y - 0.07), (x, y - 0.15), (x, y - 0.32), stroke: 1pt)
  }
  let wedge(x, y, flip: false) = {
    let s = if flip { -1 } else { 1 }
    line((x - 0.35 * s, y + 0.55), (x + 0.35 * s, y + 0.30), (x + 0.35 * s, y - 0.30),
      (x - 0.35 * s, y - 0.55), close: true, stroke: 1pt, fill: white)
  }
  let chamber(x, y) = {
    rect((x - 0.55, y - 0.35), (x + 0.55, y + 0.35), stroke: 1pt, fill: white)
    line((x - 0.37, y - 0.35), (x - 0.37, y + 0.35), (x + 0.37, y - 0.35),
      (x + 0.37, y + 0.35), (x - 0.37, y - 0.35), stroke: 0.7pt)
  }
  let cell(x, y) = {
    for (w, lo, hi, thickness, color) in (
      (0.9, -0.48, 0.48, 1pt, white),
      (0.9, 0.32, 0.48, 0.5pt, rgb("#dddddd")),
      (0.9, -0.48, -0.32, 0.5pt, rgb("#dddddd")),
      (0.65, -0.10, 0.10, 0.5pt, rgb("#aaaaaa")),
    ) { rect((x - w, y + lo), (x + w, y + hi), stroke: thickness, fill: color) }
    for (dy, label) in ((0.21, "Anode"), (-0.21, "Cathode")) {
      content((x, y + dy), [#text(size: 7pt)[#label]])
    }
  }
  let valve(x, y) = {
    line((x - 0.22, y + 0.12), (x + 0.22, y - 0.12), (x + 0.22, y + 0.12),
      (x - 0.22, y - 0.12), close: true, stroke: 0.9pt, fill: white)
    line((x, y + 0.12), (x, y + 0.23), stroke: 0.8pt)
  }
  let propeller(x, y) = {
    line((x, y - 0.8), (x - 0.06, y - 0.45), (x, y), (x + 0.06, y + 0.45), (x, y + 0.8), (x - 0.06, y + 0.45),
      (x, y), (x + 0.06, y - 0.45), close: true, stroke: 0.8pt, fill: rgb("#bbbbbb"))
  }
  let gearbox(x, y) = {
    rect((x - 0.50, y - 0.31), (x + 0.50, y + 0.31), stroke: 0.8pt, fill: white)
    for (dx, r) in ((-0.12, 0.21), (0.23, 0.13)) { circle((x + dx, y), radius: r, stroke: 0.7pt, fill: white) }
  }
  let motor(x, y) = {
    circle((x, y), radius: 0.37, stroke: 1pt, fill: white)
    content((x, y), [#text(size: 13pt)[M]])
  }
  let electronics(x, y) = {
    rect((x - 0.23, y - 0.23), (x + 0.23, y + 0.23), stroke: 0.8pt, fill: white)
    line((x - 0.23, y + 0.23), (x + 0.23, y - 0.23), stroke: 0.6pt)
    for (d, label) in ((0.12, "II"), (-0.12, "S")) { content((x + d, y + d), [#text(size: 6.5pt)[#label]]) }
  }
  // 顶部流体图例。
  rect((0, 11.9), (20.6, 13.05), stroke: 0.8pt)
  content((0.25, 12.47), anchor: "west", [*Fluid Color Code:*])
  for (x, y, color, label, dashed) in (
    (3.75, 12.72, blue, "Hydrogen (H2)", false),
    (3.75, 12.20, green, "Air (N2, O2, (H2O))", false),
    (8.60, 12.72, purple, "Anode Off-Gas (H2, H2O)", false),
    (8.60, 12.20, dark-green, "Cathode Off-Gas (N2, O2, (H2O))", false),
    (15.55, 12.72, red, "Exhaust Gas (H2O, N2, O2)", false),
    (15.55, 12.20, orange, "Electric connection", true),
  ) {
    pipe(((x, y), (x + 0.48, y)), color, dashed: dashed, arrow: false)
    content((x + 0.60, y), anchor: "west", [#text(size: 8pt)[#label]])
  }
  // 共用面板与热集成背景。
  let panel(x, variant) = {
    let shaft = 5.72
    let lower = 4.10
    let fuel = 9.12
    let air = 8.00
    let cx = x + 5.10
    let hx = x + 3.20
    let bx = x + 7.45
    let tx = x + 8.65
    let lx = x + 9.25
    if variant == "b" {
      line((x + 2.05, 10.35), (x + 2.05, 3.10), (x + 9.40, 3.10), stroke: (paint: rgb("#fff0d6"), thickness: 12pt))
      pipe(((lx, lower - 0.55), (lx, 3.10), (x + 2.05, 3.10), (x + 2.05, 7.68)), orange)
      pipe(((x + 2.05, 8.32), (x + 2.05, 10.35)), orange)
    }
    // 流体管线。
    for (points, color) in (
      (((x + 0.15, fuel), (hx - 0.32, fuel)), blue),
      (((hx + 0.32, fuel), (x + 4.02, fuel), (x + 4.02, 8.82), (cx - 0.90, 8.82)), blue),
      (((x + 9.00, 9.58), (x + 6.72, 9.58), (x + 6.72, 9.12), (bx - 0.55, 9.12)), blue),
      (((x + 0.45, 4.60), (x + 0.95, 4.60), (x + 0.95, 5.17)), green),
      (((x + 1.65, 6.05), (x + 1.65, air), (hx - 0.32, air)), green),
      (((hx + 0.32, air), (x + 4.00, air), (x + 4.00, 8.32), (cx - 0.90, 8.32)), green),
      (((cx + 0.90, 8.82), (x + 6.35, 8.82), (x + 6.35, 9.80), (hx, 9.80), (hx, 9.44)), purple),
      (((hx - 0.32, 8.88), (x + 2.55, 8.88), (x + 2.55, 9.98), (x + 6.65, 9.98), (x + 6.65, 8.68), (bx - 0.55, 8.68)), purple),
      (((cx + 0.90, 8.32), (x + 6.35, 8.32), (x + 6.35, 7.42), (hx, 7.42), (hx, 7.68)), dark-green),
      (((hx - 0.32, 7.76), (x + 2.55, 7.76), (x + 2.55, 7.22), (x + 6.65, 7.22), (x + 6.65, 8.45), (bx - 0.55, 8.45)), dark-green),
      (((bx + 0.55, 8.56), (tx, 8.56), (tx, shaft + 0.55)), red),
      (((tx, shaft - 0.55), (tx, 4.90), (lx, 4.90), (lx, lower + 0.55)), red),
    ) { pipe(points, color) }
    if variant == "a" {
      pipe(((lx, lower - 0.55), (lx, 3.10), (x + 9.65, 3.10)), red)
      pipe(((x + 1.65, 6.82), (x + 6.90, 6.82), (x + 6.90, 8.20)), green, dashed: true)
    }
    // 轴线与设备。
    for (a, b, y) in ((0.80, 9.00, shaft), (0.15, 9.50, lower)) { line((x + a, y), (x + b, y), stroke: 2pt) }
    wedge(x + 1.30, shaft)
    for y in (fuel, air) { exchanger(hx, y) }
    cell(cx, 8.56)
    chamber(bx, 8.56)
    for (wx, wy) in ((tx, shaft), (lx, lower)) { wedge(wx, wy, flip: true) }
    propeller(x + 0.15, lower)
    gearbox(x + 2.80, lower)
    motor(cx, lower)
    electronics(cx, 5.05)
    for (vx, vy) in ((x + 1.35, fuel), (x + 7.40, 9.58)) { valve(vx, vy) }
    if variant == "a" { valve(x + 3.10, 6.82) }
    // 电连接与面板文字。
    for points in (
      ((cx - 0.15, 8.08), (cx - 0.15, 5.28)),
      ((cx + 0.15, 8.08), (cx + 0.15, 5.28)),
      ((cx, 4.82), (cx, 4.47)),
    ) { pipe(points, orange, dashed: true, arrow: false) }
    for (dx, y, label) in ((0.15, 9.53, "Fuel Flow"), (0.35, 7.35, "Air Flow")) {
      content((x + dx, y), anchor: "west", [#text(size: 8pt)[#label]])
    }
    content((x + 4.75, 10.54), [#text(size: 8pt)[Adjustable Fuel Flow Bypass Valve]])
    let pos = if variant == "a" { (x + 3.50, 6.12) } else { (x + 3.35, 6.42) }
    content(pos, [#text(size: 8pt)[Adjustable Air\ Bypass Valve]])
    content((x + 4.85, 2.40), [#text(size: 12pt)[(#variant)]])
  }
  for (x, variant) in ((0, "a"), (10.55, "b")) { panel(x, variant) }
  // 底部部件图例。
  let gy = 0.85
  wedge(0.65, gy)
  exchanger(2.45, gy)
  chamber(4.50, gy)
  cell(6.75, gy)
  wedge(8.75, gy, flip: true)
  electronics(10.75, gy)
  motor(11.40, gy)
  gearbox(14.00, gy)
  propeller(16.25, gy)
  for (x, label) in (
    (0.65, [Compressor]), (2.45, [Heat\ Exchanger]), (4.50, [Combustion\ Chamber]), (6.75, [SOFC]),
    (8.75, [Turbine]), (11.10, [Power Electronics & el.\ Motor]), (14.00, [Gearbox]), (16.25, [Propeller]),
  ) { content((x, -0.30), anchor: "north", [#text(size: 8pt)[#align(center, label)]]) }
})
