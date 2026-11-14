#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 锂离子电池老化机理剖面：铜集流体—碳负极—隔膜—正极—铝集流体，逐项标注析锂、SEI 破裂、颗粒开裂、
// CEI 生长、集流体腐蚀等退化路径及 LAM/LLI/CL 图例。来源：Batteries 2025, 11, 127, Figure 11. DOI 10.3390/batteries11040127
#canvas({
  import draw: *
  // 配色
  let cu = rgb("#b8511c"); let al = rgb("#93a8c0"); let an-f = rgb("#e9e7e2")
  let sep = rgb("#f5a623"); let cat-f = rgb("#cfe0c6"); let cat-l = rgb("#4f8a3d")
  let red = rgb("#d92b2b"); let brown = rgb("#a8490a"); let dend = rgb("#b08a4a")
  // 命名地标
  let cu-x = 1.03; let al-x = 18.0
  let sep-l = 8.78; let sep-r = 10.05; let top = 11.95
  // 射线法判断点是否在多边形内，用于极片内部铺纹理与锂离子
  let inside(p, poly) = {
    let (x, y) = p
    let c = 0
    let n = poly.len()
    for i in range(n) {
      let (x1, y1) = poly.at(i)
      let (x2, y2) = poly.at(calc.rem(i + 1, n))
      if (y1 > y) != (y2 > y) and x < (x2 - x1) * (y - y1) / (y2 - y1) + x1 { c += 1 }
    }
    calc.rem(c, 2) == 1
  }
  // 极片轮廓
  let an = ((2.95, 9.80), (4.50, 10.35), (7.40, 10.12), (8.42, 8.05), (7.45, 5.55), (4.25, 5.02), (2.90, 7.00))
  let cat = ((11.80, 10.50), (14.20, 10.50), (16.10, 8.20), (15.30, 5.95), (14.85, 5.05),
    (14.15, 6.15), (13.35, 5.10), (11.30, 5.30), (10.60, 7.90))
  // 红色粗箭头（退化路径），支持折线
  let arrow(..pts, t: 4.5pt,
    c: red) = line(..pts, stroke: (paint: c, thickness: t), mark: (end: "stealth", fill: c, scale: 1.8))
  // 星形颗粒开裂爆点
  let star(pos, r) = {
    let pts = range(12).map(i => {
      let a = 2 * calc.pi * i / 12
      let rr = if calc.rem(i, 2) == 0 { r } else { r * 0.42 }
      (pos.at(0) + rr * calc.cos(a), pos.at(1) + rr * calc.sin(a))
    })
    line(..pts, close: true, fill: rgb("#f9c74f"), stroke: (paint: red, thickness: 1.1pt))
  }
  // 溶剂分子（粉色小花）
  let solvent(pos) = {
    for k in range(5) {
      let a = 2 * calc.pi * k / 5
      circle((pos.at(0) + 0.11 * calc.cos(a), pos.at(1) + 0.11 * calc.sin(a)), radius: 0.085,
        fill: rgb("#f3a6b8"), stroke: (paint: rgb("#d9617c"), thickness: 0.5pt))
    }
    circle(pos, radius: 0.06, fill: rgb("#d9617c"), stroke: none)
  }
  // 集流体与隔膜
  rect((0.50, 3.10), (1.56, 12.10), radius: 0.5, fill: cu, stroke: (paint: rgb("#8c3a10"), thickness: 0.8pt))
  rect((17.45, 3.00), (18.55, 12.05), radius: 0.5, fill: al, stroke: (paint: rgb("#5f7590"), thickness: 0.8pt))
  rect((sep-l, 2.85), (sep-r, top), radius: 0.55, fill: sep, stroke: (paint: rgb("#c07a08"), thickness: 0.8pt))
  // 负极、正极本体
  line(..an, close: true, fill: an-f, stroke: (paint: rgb("#8e8a80"), thickness: 1pt))
  line(..cat, close: true, fill: cat-f, stroke: (paint: cat-l, thickness: 1.2pt))
  // 负极网格纹理 + 正极点阵涂层
  for i in range(20) {
    for j in range(14) {
      let p = (3.10 + i * 0.27, 5.30 + j * 0.35)
      if inside(p,
        an) and inside((p.at(0) + 0.15, p.at(1) + 0.15), an) { line(p, (p.at(0) + 0.15, p.at(1) + 0.15), stroke: (paint: rgb("#cbc8bf"), thickness: 0.4pt)) }
    }
  }
  for i in range(26) {
    for j in range(19) {
      let p = (10.75 + i * 0.21, 5.30 + j * 0.28)
      if inside(p, cat) { circle(p, radius: 0.035, fill: cat-l, stroke: none) }
    }
  }
  // 过渡金属溶解 / 铜溶解与枝晶生成路径
  arrow((11.95, 10.72), (9.30, 10.72), (9.30, 9.28))
  arrow((1.62, 9.95), (1.62, 10.62), (4.30, 10.62))
  // 两侧粘结剂
  rect((1.82, 6.05), (2.94, 9.55), radius: 0.52, fill: rgb("#f8eec6"), stroke: (paint: rgb("#cbb071"), thickness: 0.8pt))
  rect((16.18, 6.10), (17.30, 9.60), radius: 0.52, fill: rgb("#f8eec6"),
    stroke: (paint: rgb("#cbb071"), thickness: 0.8pt))
  // SEI 条带与石墨剥离尖刺
  line((4.30, 10.34), (6.65, 10.02), stroke: (paint: rgb("#9a958c"), thickness: 3.2pt))
  for k in range(3) {
    line((9.02, 7.10 + k * 0.42), (8.00, 7.30 + k * 0.42), (9.02, 7.52 + k * 0.42), close: true,
      fill: rgb("#4c7a2f"), stroke: (paint: rgb("#2f5a1c"), thickness: 0.5pt))
  }
  // 锂枝晶穿过隔膜底部
  line((10.05, 6.35), (10.90, 6.75), (11.60, 6.10), (12.50, 6.45), stroke: (paint: dend, thickness: 1.4pt))
  line((10.05, 6.02), (10.80, 5.86), (11.50, 6.55), (12.30, 6.20), stroke: (paint: dend, thickness: 1.4pt))
  line((9.05, 6.05), (8.40, 5.85), (7.80, 5.70), (7.20, 5.42), stroke: (paint: dend, thickness: 1.4pt))
  line((9.05, 6.38), (8.55, 6.20), (8.10, 6.32), (7.65, 6.05), stroke: (paint: dend, thickness: 1.2pt))
  // 颗粒开裂爆点
  star((10.95, 8.55), 0.55)
  star((10.90, 6.55), 0.58)
  // 锂离子：负极 / 正极 / 电解液
  for i in range(9) {
    for j in range(7) {
      let p = (3.55 + i * 0.55, 5.65 + j * 0.60)
      if inside(p, an) { circle(p, radius: 0.10, fill: rgb("#f7b731"), stroke: (paint: rgb("#c98a0c"), thickness: 0.5pt)) }
      let q = (11.10 + i * 0.55, 5.75 + j * 0.62)
      if inside(q, cat) { circle(q, radius: 0.10, fill: rgb("#f7b731"), stroke: (paint: rgb("#c98a0c"), thickness: 0.5pt)) }
    }
  }
  for p in ((2.12, 9.62), (2.20, 5.55), (16.55, 9.90), (16.62, 5.55), (16.40, 6.95)) {
    circle(p, radius: 0.10, fill: rgb("#f7b731"), stroke: (paint: rgb("#c98a0c"), thickness: 0.5pt))
  }
  // 溶剂共嵌入分子
  for p in ((6.95, 9.90), (6.72, 7.55), (7.05, 4.95), (8.30, 4.35), (10.10, 4.40)) { solvent(p) }
  // 负极底部 SEI 分解碎屑
  for p in ((4.15, 4.62), (4.55, 4.40), (5.00, 4.68), (5.50, 4.45), (5.95, 4.75), (6.30, 4.50)) {
    line((p.at(0) - 0.10, p.at(1) - 0.12), (p.at(0) + 0.12, p.at(1) + 0.10), (p.at(0) + 0.02, p.at(1) + 0.16),
      close: true, fill: rgb("#d8d5ce"), stroke: (paint: rgb("#9a968d"), thickness: 0.4pt))
  }
  // 开裂颗粒
  line((6.05, 5.72), (6.42, 6.15), (6.80, 5.75), (6.60, 5.35), (6.20, 5.40), close: true,
    fill: white, stroke: (paint: rgb("#b0aca3"), thickness: 0.7pt))
  line((6.42, 6.15), (6.38, 5.75), (6.74, 5.55), stroke: (paint: rgb("#b0aca3"), thickness: 0.5pt))
  // 铜集流体开裂
  line((1.60, 6.55), (1.88, 6.88), (1.66, 7.20), (1.92, 7.52), (1.62, 7.82),
    stroke: (paint: rgb("#f6e6d8"), thickness: 1.5pt))
  line((1.62, 8.35), (1.86, 8.60), (1.68, 8.88), stroke: (paint: rgb("#f6e6d8"), thickness: 1.2pt))
  // 铝集流体腐蚀（蓝色锯齿块）
  line((17.36, 9.55), (17.56, 9.28), (17.40, 9.02), (17.58, 8.78), (17.38, 8.52), (17.54, 8.28),
    (17.34, 8.04), (17.46, 7.76), (17.30, 7.96), (17.42, 8.34), (17.26, 8.70), (17.40, 9.10),
    (17.26, 9.38), close: true, fill: rgb("#2f6fb5"), stroke: none)
  // 正极底部 CEI 层
  line((11.38, 5.34), (13.28, 5.12), stroke: (paint: rgb("#8fbf72"), thickness: 3.6pt))
  // 析锂箭头、SEI 分解双向箭头、结构无序箭头
  arrow((7.85, 4.55), (8.35, 5.40), t: 4pt)
  line((5.15, 3.95), (5.15, 4.78), stroke: (paint: red, thickness: 3.6pt),
    mark: (start: "stealth", end: "stealth", fill: red, scale: 1.6))
  line((13.70, 9.55), (14.05, 9.05), stroke: (paint: red, thickness: 4pt))
  line((14.05, 9.05), (14.28, 8.85), stroke: (paint: rgb("#1f5fa8"), thickness: 4pt),
    mark: (end: "stealth", fill: rgb("#1f5fa8"), scale: 1.6))
  // 标注文字
  let lab(pos, body, size: 7pt, fill: brown,
    angle: 0deg) = content(pos, body, size: size, fill: fill, weight: "bold", angle: angle)
  lab((3.30, 11.80), [Copper dissolution\ and dendrite\ formation])
  lab((7.55, 11.55), [Solvent\ co-intercalation\ & graphite\ exfoliation])
  lab((12.35, 11.85), [Transition metal\ dissolution &\ electrolyte\ decomposition])
  lab((14.65, 11.00), [Structure\ disordering])
  lab((16.52, 10.45), [Aluminum\ corrosion])
  lab((2.95, 5.10), [Copper\ Cracking])
  lab((4.40, 3.00), [SEI layer\ decomposition and\ participation])
  lab((7.45, 3.35), [Particle cracking])
  lab((7.95, 2.42), [SEI formation\ and growth])
  lab((9.90, 1.85), [Lithium plating\ & dendrite\ formation])
  lab((11.40, 3.90), [Internal\ short\ circuits], fill: rgb("#1f5fa8"))
  lab((12.90, 3.75), [CEI layer\ growth])
  lab((14.95, 4.05), [Particle\ cracking])
  lab((16.15, 4.95), [Binder\ decomposition])
  // 极片内标签：先用极片同色块清出文字区，纹理不穿字
  rect((4.10, 8.28), (5.80, 8.86), fill: an-f, stroke: none)
  lab((4.95, 8.55), [Carbon\ Anode], fill: black)
  rect((7.22, 7.79), (7.88, 8.12), fill: an-f, stroke: none)
  lab((7.55, 7.95), [Li⁺], fill: black)
  rect((12.72, 7.70), (13.98, 8.00), fill: cat-f, stroke: none)
  lab((13.35, 7.85), [Cathode], size: 8pt, fill: black)
  // 竖排部件名
  lab((cu-x, 7.60), [Copper Current Collector], size: 8pt, fill: white, angle: 90deg)
  lab((9.42, 7.40), [Separator], size: 8pt, fill: black, angle: 90deg)
  lab((al-x, 7.55), [Aluminum Current Collector], size: 8pt, fill: white, angle: 90deg)
  lab((2.38, 7.80), [Binder], size: 7.5pt, fill: black, angle: 90deg)
  lab((16.74, 7.85), [Binder], size: 7.5pt, fill: black, angle: 90deg)
  // SEI 标签（白底块）
  rect((5.16, 10.00), (5.88, 10.40), fill: white, stroke: none)
  lab((5.52, 10.20), [SEI], fill: rgb("#4a463f"))
  // 图例：LAM / LLI / CL
  let key(x, c, name) = {
    rect((x, 0.42), (x + 0.42, 0.84), fill: c, stroke: none)
    content((x + 0.58, 0.63), name, anchor: "west", size: 8pt, weight: "bold")
  }
  key(7.90, rgb("#f08a3c"), "LAM")
  key(9.75, rgb("#e8622a"), "LLI")
  key(11.60, rgb("#8a4413"), "CL")
})
