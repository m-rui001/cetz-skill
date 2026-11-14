#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 三联火箭推进剖面示意图：上为固体发动机（药柱+喷管），中为液体发动机（双贮箱+阀门+燃烧室），
// 下为混合发动机（液氧箱+药柱环），红色箭头示燃气流向，橙色/青色平涂区分燃料与氧化剂。
// 来源：Aerospace 2024, 11(9), 739, Figure 1 — Three types of bi-propellant rocket propulsion. DOI 10.3390/aerospace11090739。

#canvas({
  import draw: *

  let fuel = rgb("#F9AE4E")
  let lox = rgb("#BFE0E2")
  let flame = rgb("#D8261C")
  let metal = rgb("#9AA3A8")
  let lw = 1.1pt
  let red-s = (paint: flame, thickness: 1pt)
  let k = 0.5523

  // 胶囊贮箱：平涂 + 左端白色端盖，再描边
  let tank(x0, x1, y0, y1, c, band: 0.45) = {
    let r = (y1 - y0) / 2
    rect((x0, y0), (x1, y1), radius: r, fill: c, stroke: none)
    rect((x0, y0), (x0 + band, y1), fill: white, stroke: none)
    rect((x0, y0), (x1, y1), radius: r, stroke: lw)
  }

  // 机身：左端半圆封头 + 平直右端（与喷管入口齐平）
  let body(x0, x1, y0, y1) = {
    let r = (y1 - y0) / 2
    let xa = x0 + r
    let yc = (y0 + y1) / 2
    line((x1, y1), (xa, y1))
    bezier((xa, y1), (x0, yc), (xa - k * r, y1), (x0, yc + k * r))
    bezier((x0, yc), (xa, y0), (x0, yc - k * r), (xa - k * r, y0))
    line((xa, y0), (x1, y0))
  }

  // 收缩-扩张喷管：喉部收缩段 + 扩张段，上下对称
  let nozzle(x, yc, h0, h1, w: 1.55) = {
    let xt = x + 0.4 * w
    let ht = 0.44 * h0
    bezier((x, yc + h0), (xt, yc + ht), (xt - 0.45, yc + h0), (xt - 0.38, yc + ht))
    bezier((xt, yc + ht), (x + w, yc + h1), (xt + 0.3, yc + ht), (x + w - 0.45, yc + h1))
    bezier((x, yc - h0), (xt, yc - ht), (xt - 0.45, yc - h0), (xt - 0.38, yc - ht))
    bezier((xt, yc - ht), (x + w, yc - h1), (xt + 0.3, yc - ht), (x + w - 0.45, yc - h1))
  }

  // 喷管出口平行射流
  let jets(x, ys, len: 0.95) = {
    for y in ys {
      line((x, y), (x + len, y), stroke: red-s, mark: (end: "stealth"))
    }
  }

  // 阀门：灰色圆盘 + 交叉斜线
  let valve(p, r: 0.26) = {
    let (x, y) = p
    circle(p, radius: r, fill: rgb("#EDEDED"), stroke: lw)
    line((x - 0.7 * r, y - 0.7 * r), (x + 0.7 * r, y + 0.7 * r), stroke: lw)
    line((x - 0.7 * r, y + 0.7 * r), (x + 0.7 * r, y - 0.7 * r), stroke: lw)
  }

  // 标签：居中内容
  let lab(p, t, size: 9pt, anchor: "center") = content(p, text(size: size, t), anchor: anchor)

  // 面板 (a) 固体发动机
  rect((2.3, 11.9), (8.55, 12.5), radius: 0.25, fill: fuel, stroke: none)
  rect((2.3, 10.5), (8.55, 11.1), radius: 0.25, fill: fuel, stroke: none)
  body(1.45, 8.6, 10.4, 12.6)
  rect((1.55, 11.33), (2.25, 11.57), fill: rgb("#1E8A3C"), stroke: none)
  nozzle(8.6, 11.5, 1.1, 0.95, w: 1.6)
  // 药柱内孔燃气箭头
  for x in (3.3, 5.0, 6.7) {
    for dy in (0.24, -0.24) {
      bezier((x, 11.5 + dy), (x + 0.75, 11.5 + dy), (x + 0.3, 11.5 + dy + 0.12), (x + 0.52, 11.5 + dy + 0.12), stroke: red-s, mark: (end: "stealth"))
    }
  }
  jets(10.4, (10.75, 11.25, 11.75, 12.25))
  lab((1.4, 11.45), [Ignitor], size: 9.5pt, anchor: "east")
  lab((5.35, 12.2), [*Solid Fuel Grain (Fuel + Oxidizer)*], size: 8.5pt)
  lab((5.35, 10.8), [*Solid Fuel Grain (Fuel + Oxidizer)*], size: 8.5pt)
  lab((5.3, 9.9), [*Solid Rocket Propulsion*], size: 10pt)
  lab((5.3, 9.55), [(a)], size: 9pt)

  // 面板 (b) 液体发动机
  tank(1.2, 5.4, 8.0, 8.9, fuel)
  tank(1.2, 5.4, 6.8, 7.7, lox)
  // 输送管路：两路汇入喷注器
  line((5.4, 8.45), (6.4, 8.2), (7.3, 7.95), stroke: (paint: metal, thickness: 2.2pt))
  line((5.4, 7.25), (6.4, 7.5), (7.3, 7.78), stroke: (paint: metal, thickness: 2.2pt))
  valve((6.4, 8.2))
  valve((6.4, 7.5))
  body(7.25, 8.55, 7.4, 8.3)
  circle((7.38, 7.85), radius: 0.13, fill: flame, stroke: none)
  // 燃烧室内燃气扩散
  line((7.55, 7.95), (8.1, 8.08), stroke: red-s, mark: (end: "stealth"))
  line((7.55, 7.72), (8.1, 7.6), stroke: red-s, mark: (end: "stealth"))
  nozzle(8.55, 7.85, 0.45, 0.72, w: 1.5)
  jets(10.15, (7.32, 7.67, 8.03, 8.38))
  lab((3.55, 8.45), [*Liquid Fuel*], size: 9.5pt)
  lab((3.55, 7.25), [*Liquid Oxidizer*], size: 9.5pt)
  lab((8.9, 6.85), [*Combustion Chamber*], size: 9pt)
  lab((4.6, 6.3), [*Liquid Rocket Propulsion*], size: 10pt)
  lab((4.6, 5.95), [(b)], size: 9pt)

  // 面板 (c) 混合发动机
  tank(0.6, 4.5, 3.5, 4.9, lox, band: 0.6)
  line((4.5, 4.2), (5.15, 4.2), (5.62, 4.2), stroke: (paint: metal, thickness: 2.2pt))
  valve((5.15, 4.2), r: 0.3)
  body(5.6, 10.4, 3.35, 5.05)
  rect((5.95, 4.45), (10.2, 4.95), radius: 0.2, fill: fuel, stroke: none)
  rect((5.95, 3.45), (10.2, 3.95), radius: 0.2, fill: fuel, stroke: none)
  // 氧化剂喷入内孔
  for dy in (-0.17, -0.06, 0.06, 0.17) {
    line((6.02, 4.2 + 0.55 * dy), (6.55, 4.2 + 1.5 * dy), stroke: (paint: rgb("#2F7FC1"), thickness: 0.9pt), mark: (end: "stealth"))
  }
  // 燃气沿内孔流向喷管
  bezier((6.7, 4.34), (10.3, 4.3), (7.9, 4.37), (9.2, 4.33), stroke: red-s, mark: (end: "stealth"))
  bezier((6.7, 4.06), (10.3, 4.1), (7.9, 4.03), (9.2, 4.07), stroke: red-s, mark: (end: "stealth"))
  nozzle(10.4, 4.2, 0.85, 0.95, w: 1.55)
  jets(11.95, (3.55, 3.95, 4.45, 4.85))
  lab((3.0, 4.2), [*Liquid Oxidizer*], size: 9.5pt)
  lab((8.05, 4.7), [*Solid Fuel Grain (Fuel)*], size: 8.5pt)
  lab((8.05, 3.7), [*Solid Fuel Grain (Fuel)*], size: 8.5pt)
  lab((5.6, 2.9), [*Hybrid Rocket Propulsion*], size: 10pt)
  lab((5.6, 2.55), [(c)], size: 9pt)
})
