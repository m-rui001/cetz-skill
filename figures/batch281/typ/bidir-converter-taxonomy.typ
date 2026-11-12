#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：双向 DC-DC 变换器拓扑三级分类树。根节点分隔离/非隔离两簇，非隔离下分 Classical /
// Coupled-Inductor / Advanced Structures，隔离下分 Transformer-Based / Resonant and Soft-Switching /
// Modular and Multiport；每个二级类目再列具体拓扑（共 27 个叶子标签）。
// 各级同色系描边与浅底区分族别；正交折线自上而下，叶节点由左侧主干分支接入。
// 来源：Actuators 2025, 14, 347, Figure 2 "Classification of bidirectional DC-DC converter topologies"。DOI 10.3390/act14070347

#canvas({
  import draw: *
  let ink = black
  let purple = rgb("#6a3fb5")
  let red = rgb("#d0342c")
  let orange = rgb("#e07b28")
  // 节点盒（只画框与底色）
  let box(c, w, h, fill: white, stroke: ink) = rect(
    (c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
    fill: fill, stroke: 0.6pt + stroke)
  // 居中文字
  let t(pos, s, size: 6.6pt, fill: ink) = content(
    pos, text(size: size, fill: fill)[#s], anchor: "center", frame: none)
  // 折线箭头与直线
  let poly(..pts) = line(..pts, stroke: 0.6pt + ink, mark: (end: "stealth", scale: 0.6))
  let arr(a, b) = line(a, b, stroke: 0.6pt + ink, mark: (end: "stealth", scale: 0.6))

  // 根节点与两个一级分支
  box((8.20, 7.80), 2.30, 0.48, fill: rgb("#7a4bc8"), stroke: purple)
  t((8.20, 7.80), [Bidirectional \ DC-DC Converter \ Topologies], size: 7pt, fill: white)
  box((4.00, 6.85), 1.45, 0.42, fill: red, stroke: red)
  t((4.00, 6.85), [Non-Isolated \ Topologies], size: 6.8pt, fill: white)
  box((11.60, 6.85), 1.40, 0.42, fill: orange, stroke: orange)
  t((11.60, 6.85), [Isolated \ Topologies], size: 6.8pt, fill: white)
  poly((7.45, 7.32), (7.45, 7.10), (4.00, 7.10), (4.00, 7.27))
  poly((8.95, 7.32), (8.95, 7.10), (11.60, 7.10), (11.60, 7.27))

  // 六个二级类目（内容用 content 以支持换行）
  let cats = (
    (1.55, [Classical \ Converters], rgb("#2e9e4f"), rgb("#d9f0dd")),
    (4.00, [Coupled-Inductor \ Converters], rgb("#1f8ed6"), rgb("#d7ecfb")),
    (6.45, [Advanced \ Structures], rgb("#d81b60"), rgb("#fbd9e5")),
    (8.90, [Transformer-Based \ Converters], rgb("#1f6fd6"), rgb("#d7e4fb")),
    (11.35, [Resonant and Soft- \ Switching Converters], rgb("#8a4b1f"), rgb("#f6e3cf")),
    (13.80, [Modular and \ Multiport Converters], purple, rgb("#e6dcf5")),
  )
  for (x, s, edge, fill) in cats {
    box((x, 5.85), 1.08, 0.46, fill: fill, stroke: edge)
    t((x, 5.85), s, size: 5.6pt, fill: edge)
  }
  // 一级到二级的总线式连线
  line((1.55, 6.52), (6.45, 6.52), stroke: 0.6pt + ink)
  line((4.00, 6.43), (4.00, 6.52), stroke: 0.6pt + ink)
  for x in (1.55, 4.00, 6.45) { poly((x, 6.52), (x, 6.31)) }
  line((8.90, 6.52), (13.80, 6.52), stroke: 0.6pt + ink)
  line((11.60, 6.43), (11.60, 6.52), stroke: 0.6pt + ink)
  for x in (8.90, 11.35, 13.80) { poly((x, 6.52), (x, 6.31)) }

  // 各二级类目下的具体拓扑（左主干 + 逐个分支箭头）
  let leaves = (
    (1.55, ([Buck], [Boost], [Buck-Boost])),
    (4.00, ([Ćuk], [Zeta/Sepic], [Split-Pi])),
    (6.45, ([Switched \ Capacitor], [Interleaved], [Cascade], [Multilevel], [Quadratic],
            [Modular Buck- \ Boost], [Four-Quadrant \ Converter])),
    (8.90, ([Flyback], [Forward], [Push-Pull], [Half-Bridge], [Full-Bridge])),
    (11.35, ([Dual Active \ Bridge], [Dual Half- \ Bridge], [LLC Resonant \ Converter])),
    (13.80, ([Modular Multilevel \ Converter], [Multiport \ Converter])),
  )
  for (x, names) in leaves {
    let n = names.len()
    let step = if n >= 6 { 0.70 } else { 0.85 }
    let last = 5.10 - step * (n - 1)
    let trunk = x - 1.04
    line((x, 5.39), (trunk, 5.39), (trunk, last), stroke: 0.6pt + ink)
    for (i, name) in names.enumerate() {
      let y = 5.10 - step * i
      box((x, y), 0.94, 0.30)
      t((x, y), name, size: 5.2pt)
      arr((trunk, y), (x - 0.94, y))
    }
  }
})
