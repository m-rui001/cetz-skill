#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：DDS 中间件体系结构图。外框 DDS Domain 内三个 Domain Participant：顶部 DP3（Subscriber 的
// Data Reader 1/2/N 与 Publisher 的 Data Writer 1/2/N），左 DP1（Reader 1/2、Writer 1），右 DP2
//（Writer 1/2、Reader 1）。中央 Global Data Space 椭圆云内按色分列 Topic N/4/3/2/1；
// 五色点线表示发布/订阅主题连接，箭头指向订阅端或主题端，灰色为 Topic N、绿色 Topic 4、紫色 Topic 3、
// 粉色 Topic 2、橙色 Topic 1。逐字保留全部标签。
// 来源：Robotics 2025, 14, 63, Figure 6 "Architecture of DDS middleware". DOI 10.3390/robotics14050063

#canvas({
  import draw: *
  let ink = black
  let cyan = rgb("#d8f0f6")
  let cborder = rgb("#4aa3bd")
  let cloudc = rgb("#d6e9fb")
  let cbc = rgb("#6fa8dc")
  let pink = rgb("#d63384")
  let purple = rgb("#6f42c1")
  let green = rgb("#5c8a1b")
  let gray = rgb("#8c8c8c")
  let orange = rgb("#d9480f")
  // 线/箭头辅助
  let solid(a, b) = line(a, b, stroke: 0.7pt + ink)
  let frame(a, b, fill: none) = rect(a, b, fill: fill, stroke: 0.9pt + cborder)
  let t(pos, s, size: 6.4pt, anchor: "center") = content(
    pos, text(size: size)[#s], anchor: anchor, frame: none)
  let tb(pos, s, size: 8pt) = content(pos, text(size: size, weight: "bold")[#s],
    anchor: "center", frame: none)
  // 白色条目框（斜体加粗）
  let item(pos, w, s) = {
    rect((pos.at(0) - w, pos.at(1) - 0.16), (pos.at(0) + w, pos.at(1) + 0.16),
      fill: white, stroke: 0.6pt + ink)
    content(pos, text(size: 6pt, style: "italic", weight: "bold")[#s],
      anchor: "center", frame: none)
  }
  // 点线连接（终点带箭头）
  let conn(c, ..pts) = line(..pts, stroke: (paint: c, thickness: 0.8pt, dash: "dotted"),
    mark: (end: "stealth", scale: 0.45, fill: c))
  // 主题条：中心、文字、填充色
  let topic(pos, s, fill) = {
    rect((pos.at(0) - 0.63, pos.at(1) - 0.14), (pos.at(0) + 0.63, pos.at(1) + 0.14),
      radius: 0.03, fill: fill, stroke: 0.6pt + ink)
    content(pos, text(size: 6.6pt, style: "italic", weight: "bold")[#s],
      anchor: "center", frame: none)
  }

  // 外框 DDS Domain
  frame((0.25, 0.35), (15.35, 9.05))
  tb((7.80, 0.55), [DDS Domain], size: 9pt)

  // ── 顶部 DP3：Subscriber（三个 Reader）与 Publisher（三个 Writer）
  frame((0.55, 7.10), (15.05, 8.95), fill: cyan)
  tb((7.80, 8.76), [Domain Participant 3], size: 8.6pt)
  frame((0.80, 7.75), (7.65, 8.60), fill: rgb("#e8f7fa"))
  tb((4.22, 8.38), [Subscriber], size: 7.6pt)
  item((2.15, 8.08), 0.85, [Data Reader 1])
  item((4.00, 8.08), 0.85, [Data Reader 2])
  item((6.55, 8.08), 0.85, [Data Reader N])
  solid((4.95, 8.08), (5.15, 8.08))
  circle((5.30, 8.08), radius: 0.022, fill: ink, stroke: none)
  solid((5.45, 8.08), (5.65, 8.08))
  frame((7.85, 7.75), (14.80, 8.60), fill: rgb("#e8f7fa"))
  tb((11.32, 8.38), [Publisher], size: 7.6pt)
  item((9.00, 8.08), 0.85, [Data Writer 1])
  item((10.90, 8.08), 0.85, [Data Writer 2])
  item((13.55, 8.08), 0.85, [Data Writer N])
  solid((11.85, 8.08), (12.05, 8.08))
  circle((12.20, 8.08), radius: 0.022, fill: ink, stroke: none)
  solid((12.35, 8.08), (12.55, 8.08))

  // ── 左侧 DP1：Subscriber（Reader 1/2）、Publisher（Writer 1）
  frame((0.55, 0.95), (3.95, 6.35), fill: cyan)
  tb((2.25, 1.15), [Domain Participant 1], size: 7.6pt)
  frame((0.75, 3.95), (3.75, 6.05), fill: rgb("#e8f7fa"))
  item((2.25, 5.35), 0.80, [Data Reader 1])
  item((2.25, 4.83), 0.80, [Data Reader 2])
  tb((2.25, 4.20), [Subscriber], size: 7.4pt)
  frame((0.75, 1.35), (3.75, 3.60), fill: rgb("#e8f7fa"))
  item((2.25, 2.95), 0.80, [Data Writer 1])
  tb((2.25, 1.62), [Publisher], size: 7.4pt)

  // ── 右侧 DP2：Publisher（Writer 1/2）、Subscriber（Reader 1）
  frame((12.00, 0.95), (15.20, 6.35), fill: cyan)
  tb((13.60, 1.15), [Domain Participant 2], size: 7.6pt)
  frame((12.20, 4.15), (15.00, 6.00), fill: rgb("#e8f7fa"))
  item((13.60, 5.55), 0.80, [Data Writer 1])
  item((13.60, 5.03), 0.80, [Data Writer 2])
  tb((13.60, 4.42), [Publisher], size: 7.4pt)
  frame((12.20, 1.35), (15.00, 3.75), fill: rgb("#e8f7fa"))
  item((13.60, 3.15), 0.80, [Data Reader 1])
  tb((13.60, 1.62), [Subscriber], size: 7.4pt)

  // ── 中央 Global Data Space 云与五个主题条
  circle((7.90, 4.90), radius: (2.25, 1.55),
    fill: cloudc, stroke: 0.9pt + cbc)
  tb((7.90, 5.12), [Global Data Space], size: 7.6pt)
  topic((7.90, 6.05), [Topic N], rgb("#cfcfcf"))
  topic((7.90, 5.55), [Topic 4], rgb("#d9f0c0"))
  topic((7.90, 4.70), [Topic 3], rgb("#d2c4ea"))
  topic((7.90, 4.18), [Topic 2], rgb("#f4b6cc"))
  topic((7.90, 3.68), [Topic 1], rgb("#f2b8a8"))

  // ── 发布/订阅点线（粉色 Topic 2、紫色 Topic 3、灰色 Topic N、绿色 Topic 4、橙色 Topic 1）
  conn(pink, (7.27, 4.26), (6.55, 4.26), (6.55, 6.86), (2.15, 6.86), (2.15, 7.90))
  conn(purple, (7.27, 4.74), (6.90, 4.74), (6.90, 7.02), (4.00, 7.02), (4.00, 7.90))
  conn(gray, (8.53, 6.12), (9.45, 6.12), (9.45, 6.75), (6.30, 6.75), (6.30, 7.90))
  conn(green, (9.00, 7.90), (9.00, 6.65), (8.78, 6.65), (8.78, 5.55), (8.55, 5.55))
  conn(orange, (10.90, 7.90), (10.90, 6.55), (10.20, 6.55), (10.20, 3.60), (8.55, 3.60))
  conn(gray, (12.78, 5.55), (11.45, 5.55), (11.45, 5.98), (8.55, 5.98))
  conn(orange, (12.78, 5.03), (10.70, 5.03), (10.70, 3.76), (8.55, 3.76))
  conn(purple, (8.53, 4.70), (11.00, 4.70), (11.00, 3.15), (12.78, 3.15))
  conn(green, (7.27, 5.55), (5.55, 5.55), (5.55, 5.30), (3.07, 5.30))
  conn(orange, (7.27, 3.62), (4.90, 3.62), (4.90, 4.83), (3.07, 4.83))
  conn(pink, (3.07, 2.95), (5.10, 2.95), (5.10, 4.10), (7.25, 4.10))
})
