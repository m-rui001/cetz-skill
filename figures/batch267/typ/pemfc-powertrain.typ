#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：氢燃料电池飞机动力系统示意图（竖排三区）。上绿框为燃料供给：LH2 tank→阀→Heating→阳极，
// 阳极排气经 Rec. fan 回流，顶部 E-motor 驱动风扇，右侧 purged H2 排出。中蓝框为燃料电池与配电：
// Anode/Cathode 夹持带散热片的电堆，Converter 引出至右侧橙色接口，左侧蓝字 Fuel cell (PEMFC & power
// distribution)。下红框为空气回路：air inlet→Diffuser→Compressor→Cooling→Humidifier→阴极，阴极出气
// 回 Humidifier→Turbine→Nozzle→wet air outlet，Compressor 与 Turbine 同轴经 E-motor。逐字保留标签。
// 来源：Aerospace 2026, 13, 243, Figure 2 "Investigated fuel cell powertrain". DOI 10.3390/aerospace13030243

#canvas({
  import draw: *
  let ink = black
  let blue = rgb("#3f5fa0")
  let green = rgb("#8fae3f")
  let red = rgb("#b84742")
  let orange = rgb("#dd9a2e")
  let t(pos, s, size: 6.8pt, anchor: "center", fill: ink) = content(
    pos, text(size: size, fill: fill)[#s], anchor: anchor, frame: none)
  let arr(a, b) = line(a, b, stroke: 0.7pt + ink, mark: (end: "stealth", scale: 0.5))
  let l2(a, b) = line(a, b, stroke: 0.7pt + ink)
  let poly(..pts) = line(..pts, close: true, fill: white, stroke: 0.7pt + ink)
  let boxw(c, w, h, s, size: 7pt) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      fill: white, stroke: 0.7pt + ink)
    t(c, s, size: size)
  }
  // 蝶阀：一对对顶三角
  let valve(c) = {
    poly((c.at(0) - 0.13, c.at(1) - 0.11), (c.at(0) + 0.13, c.at(1) + 0.11),
      (c.at(0) + 0.13, c.at(1) - 0.11), (c.at(0) - 0.13, c.at(1) + 0.11))
    l2((c.at(0) - 0.13, c.at(1)), (c.at(0) + 0.13, c.at(1)))
  }

  // ── 三区边框
  rect((0.30, 9.60), (10.20, 11.90), stroke: 1pt + green)
  rect((2.30, 5.15), (9.60, 9.35), stroke: 1pt + blue)
  rect((0.30, 0.40), (9.70, 4.95), stroke: 1pt + red)
  rect((9.60, 6.30), (10.30, 6.90), stroke: 1pt + orange)

  // ── 上部：液氢罐→阀门→加热→阳极；风机回流与放空
  rect((0.85, 11.02), (2.15, 11.52), fill: white, stroke: 0.7pt + ink)
  circle((0.86, 11.27), radius: (0.10, 0.25), fill: white, stroke: 0.7pt + ink)
  t((1.55, 11.27), [LH#sub[2] tank], size: 7pt)
  l2((2.15, 11.27), (2.97, 11.27))
  valve((3.10, 11.27))
  l2((3.23, 11.27), (3.28, 11.27))
  l2((3.28, 11.27), (3.28, 10.84))
  boxw((3.28, 10.62), 0.55, 0.20, [Heating])
  l2((3.28, 10.42), (3.28, 9.05))
  arr((3.28, 9.05), (3.42, 9.05))
  boxw((5.30, 10.95), 0.55, 0.18, [E-motor])
  l2((5.27, 10.77), (5.27, 10.42))
  l2((5.33, 10.77), (5.33, 10.42))
  boxw((5.30, 10.20), 0.62, 0.20, [Rec. fan])
  l2((4.65, 9.05), (4.65, 9.62))
  l2((4.65, 9.62), (4.95, 9.62))
  arr((4.95, 9.62), (4.95, 10.08))
  l2((4.68, 10.20), (3.28, 10.20))
  arr((3.28, 10.20), (3.28, 10.44))
  l2((5.92, 10.20), (7.56, 10.20))
  valve((7.70, 10.20))
  arr((7.83, 10.20), (8.95, 10.20))
  t((8.20, 10.68), [purged \ H#sub[2]], size: 6.8pt)

  // ── 中部：阳极/阴极夹持电堆与变流器
  t((0.33, 7.95), [Fuel cell \ (PEMFC & \ power \ distribution)], size: 7pt, anchor: "west", fill: blue)
  boxw((4.05, 9.05), 0.60, 0.16, [Anode], size: 7.2pt)
  boxw((4.05, 5.55), 0.60, 0.16, [Cathode], size: 7.2pt)
  rect((3.45, 5.80), (4.65, 8.80), fill: rgb("#f4f4f4"), stroke: 0.7pt + ink)
  for k in range(11) {
    let x = 3.55 + 0.10 * k
    l2((x, 5.90), (x, 8.70))
  }
  arr((4.65, 6.60), (6.68, 6.60))
  boxw((7.35, 6.60), 0.65, 0.20, [Converter])
  arr((8.00, 6.60), (9.55, 6.60))

  // ── 下部：空气回路与涡轮
  boxw((5.55, 4.45), 2.25, 0.22, [Humidifier])
  arr((4.05, 4.67), (4.05, 5.45))
  l2((4.65, 5.55), (6.75, 5.55))
  l2((6.75, 5.55), (6.75, 4.95))
  arr((6.75, 4.95), (6.75, 4.70))
  boxw((3.55, 3.95), 0.55, 0.20, [Cooling])
  arr((3.55, 4.05), (3.55, 4.31))
  // 扩压器、压气机
  poly((1.35, 2.50), (1.35, 2.80), (1.95, 2.95), (1.95, 2.35))
  poly((2.70, 2.55), (2.70, 3.15), (3.10, 3.30), (3.10, 2.35))
  arr((0.55, 2.65), (1.33, 2.65))
  arr((1.97, 2.65), (2.55, 2.65))
  l2((3.05, 3.22), (3.55, 3.42))
  arr((3.55, 3.42), (3.55, 3.80))
  // 压气机–涡轮同轴，中置 E-motor
  boxw((5.55, 2.85), 0.75, 0.22, [E-motor])
  l2((3.12, 2.80), (4.78, 2.80))
  l2((3.12, 2.90), (4.78, 2.90))
  l2((6.32, 2.80), (6.95, 2.80))
  l2((6.32, 2.90), (6.95, 2.90))
  poly((7.00, 3.35), (7.45, 3.15), (7.45, 2.55), (7.00, 2.35))
  l2((6.35, 4.23), (6.35, 3.85))
  l2((6.35, 3.85), (7.10, 3.85))
  arr((7.10, 3.85), (7.10, 3.32))
  // 尾喷管与湿空气出口
  l2((7.45, 2.85), (7.75, 2.85))
  poly((7.75, 2.45), (7.75, 2.85), (8.35, 2.95), (8.35, 2.35))
  arr((8.37, 2.65), (9.35, 2.65))
  t((0.72, 2.30), [air \ inlet], size: 6.8pt)
  t((1.64, 2.12), [Diffuser], size: 6.8pt)
  t((1.95, 3.42), [Compressor], size: 6.8pt)
  t((7.62, 3.40), [Turbine], size: 6.8pt, anchor: "west")
  t((7.98, 2.10), [Nozzle], size: 6.6pt)
  t((8.95, 2.05), [wet air \ outlet], size: 6.6pt)
})
