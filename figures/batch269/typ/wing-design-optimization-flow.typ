#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：增材制造无人机机翼设计优化流程图。两路并行：Approach 1（蓝）Pressure map Through CFD→
// Scalar stress field through static analysis→Variable thickness lattice design；Approach 2（绿）
// Printing at different temperatures→Mechanical properties measurements→Distinct material behavior in
// the infill versus the shell；两路汇聚到黑框 Design Verification through static analysis。
// 逐字保留六个步骤与两路标题。
// 来源：Aerospace 2026, 13, 50, Figure 1 "Flowchart of the design optimization approach followed for the wing model". DOI 10.3390/aerospace13010050

#canvas({
  import draw: *
  let ink = black
  let blue = rgb("#1a73b8")
  let green = rgb("#2e8b57")
  let t(pos, s, size: 6.0pt, anchor: "center") = content(
    pos, text(size: size)[#s], anchor: anchor, frame: none)
  let tb(pos, s, size: 8pt, fill: ink) = content(
    pos, text(size: size, weight: "bold", fill: fill)[#s], anchor: "center", frame: none)
  let rbox(c, s, stroke) = {
    rect((c.at(0) - 1.25, c.at(1) - 0.46), (c.at(0) + 1.25, c.at(1) + 0.46),
      radius: 0.14, fill: white, stroke: 1pt + stroke)
    t(c, s)
  }
  let arr(a, b, c) = line(a, b, stroke: 1pt + c, mark: (end: "stealth", scale: 0.55, fill: c))
  let polyarr(c, ..pts) = line(..pts, stroke: 1pt + c, mark: (end: "stealth", scale: 0.55, fill: c))

  // 第一路：CFD 压力图 → 静力分析应力场 → 变厚度点阵
  tb((0.82, 3.20), [Approach 1], size: 8pt, fill: blue)
  rbox((2.85, 3.20), [Pressure map \ Through CFD], blue)
  rbox((5.55, 3.20), [Scalar stress field \ through static \ analysis], blue)
  rbox((8.25, 3.20), [Variable thickness \ lattice design], blue)
  arr((4.10, 3.20), (4.28, 3.20), blue)
  arr((6.80, 3.20), (6.98, 3.20), blue)

  // 第二路：不同温度打印 → 力学性能测量 → 壳/填充材料差异
  tb((0.82, 1.05), [Approach 2], size: 8pt, fill: green)
  rbox((2.85, 1.05), [Printing at different \ temperatures], green)
  rbox((5.55, 1.05), [Mechanical \ properties \ measurements], green)
  rbox((8.25, 1.05), [Distinct material \ behavior in the infill \ versus the shell], green)
  arr((4.10, 1.05), (4.28, 1.05), green)
  arr((6.80, 1.05), (6.98, 1.05), green)

  // 汇聚到设计验证框
  rect((10.10, 1.75), (12.95, 3.10), radius: 0.14, fill: white, stroke: 1pt + ink)
  t((11.52, 2.42), [Design Verification \ through static \ analysis])
  polyarr(blue, (9.50, 3.20), (10.58, 3.20), (10.58, 3.08))
  polyarr(green, (9.50, 1.05), (10.58, 1.05), (10.58, 1.77))
})
