#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：LLM 嵌入的社交辅助机器人框架（design 1）。左侧 Therapist input 与 user request 两条输入，
// 中部 Decision / Entertain / Converse 三个虚线状态组（各自 Prompt n + GPT-4/GPT-4v），绿色决策连线、
// 蓝/青细线为请求与回馈总线，深蓝粗箭头指向右侧 Dynamic Content Retrieval / Emotion Recognition /
// Multi-modal Interactions 三个输出；下方 Σ 求和后写入 Script 缓冲区，再驱动 Low-level Controller 与
// Robot Sensor Module，底部回馈 Output = RGB image of user。逐字保留全部标签。
// 来源：Robotics 2024, 13, 112, Figure 1 "LLM-embedded framework architecture for socially assistive robot in design 1" DOI 10.3390/robotics13080112

#canvas({
  import draw: *
  let ink = black
  let blue = rgb("#1f5fa8")
  let navy = rgb("#123c6b")
  let cyan = rgb("#22b8e6")
  let green = rgb("#5aa832")
  let yellow = rgb("#e8a11c")
  let pfill = rgb("#f26522")
  let gfill = rgb("#f28bc9")
  let vfill = rgb("#e97fc6")
  let brown = rgb("#a0522d")
  let gray = rgb("#d9d9d9")
  // 有色小方块（Prompt / GPT）
  let blk(x, y, w, h, s, fill, tc) = {
    rect((x - w / 2, y - h / 2), (x + w / 2, y + h / 2), stroke: 0.9pt + ink, fill: fill)
    content((x, y), text(size: 7pt, fill: tc, s))
  }
  // 灰/白功能块
  let box(x, y, w, h, s, fill, size: 7.2pt) = {
    rect((x - w / 2, y - h / 2), (x + w / 2, y + h / 2), stroke: 1pt + ink, fill: fill)
    content((x, y), text(size: size, s))
  }
  // 虚线分组框与彩色组标题
  let grp(x1, y1, x2, y2, cx, cy, s, fill) = {
    rect((x1, y1), (x2, y2), stroke: (paint: ink, thickness: 1pt, dash: "dashed"))
    rect((cx - 1.0, cy - 0.19), (cx + 1.0, cy + 0.19), stroke: none, fill: fill)
    content((cx, cy), text(size: 7.6pt, s))
  }
  let txt(x, y, s, size: 6.9pt, anchor: "center") = content((x, y), text(size: size, s), anchor: anchor, frame: none)
  let wr(a, b, c, t: 1pt, arrow: true) = if arrow {
    line(a, b, stroke: (paint: c, thickness: t), mark: (end: "stealth", scale: 0.5, fill: c))
  } else {
    line(a, b, stroke: (paint: c, thickness: t))
  }

  // 顶部说明
  txt(9.5, 14.15, [Input = user request])
  txt(9.5, 13.85, [output = Script containing API calls to media sharing service])

  // 左侧输入块（带尖角指针）与机器人模块
  box(3.0, 12.6, 2.9, 1.2, [Therapist\ input =\ [patient information]], white, size: 6.8pt)
  line((2.75, 12.025), (3.0, 11.9), (3.25, 12.025), stroke: 1pt + ink)
  box(3.0, 10.8, 2.7, 1.35, [user request= “I\ want to listen\ to music.”], white, size: 7pt)
  line((2.7, 10.125), (3.0, 9.98), (3.3, 10.125), stroke: 1pt + ink)
  box(1.85, 7.0, 2.6, 1.35, [Robot\ Multi-\ modal\ behavior], gray)
  box(2.55, 4.75, 2.3, 0.9, [Low-level\ Controller], gray)
  box(2.55, 3.0, 2.3, 1.0, [Robot\ Sensor\ Module], gray)

  // 三个状态组：Decision / Entertain / Converse
  grp(6.05, 8.55, 8.75, 11.75, 7.40, 11.95, [Decision], rgb("#8cc63f"))
  rect((6.55, 10.25), (8.25, 11.40), stroke: 1.2pt + ink)
  blk(7.40, 11.10, 1.55, 0.38, [Prompt 1], pfill, white)
  blk(7.40, 10.62, 1.55, 0.38, [GPT-4], gfill, ink)
  grp(10.35, 11.45, 12.35, 13.35, 11.35, 13.55, [Entertain], rgb("#29c5f6"))
  rect((10.55, 11.60), (12.15, 13.10), stroke: 1.2pt + ink)
  blk(11.35, 12.80, 1.55, 0.38, [Prompt 2], pfill, white)
  blk(11.35, 12.25, 1.55, 0.38, [GPT-4], gfill, ink)
  grp(12.55, 5.85, 14.65, 11.15, 13.60, 11.35, [Converse], rgb("#f7c6a3"))
  rect((12.85, 9.90), (14.35, 10.95), stroke: 1.2pt + ink)
  blk(13.60, 10.70, 1.5, 0.38, [Prompt 3], pfill, white)
  blk(13.60, 10.20, 1.5, 0.38, [GPT-4v], vfill, ink)
  rect((12.85, 7.50), (14.35, 8.55), stroke: 1.2pt + ink)
  blk(13.60, 8.30, 1.5, 0.38, [Prompt 4], pfill, white)
  blk(13.60, 7.80, 1.5, 0.38, [GPT-4], gfill, ink)

  // 右侧三个输出块
  box(16.9, 13.5, 2.9, 0.6, [*Dynamic Content\ Retrieval*], brown, size: 7.4pt)
  box(17.6, 9.9, 2.9, 0.5, [*Emotion Recognition*], brown, size: 7.2pt)
  box(17.6, 7.9, 2.6, 0.6, [*Multi-modal\ Interactions*], brown, size: 7.2pt)

  // 输入连线：治疗师输入进 Entertain，用户请求进 Decision 与 Converse
  wr((4.3, 12.6), (10.35, 12.6), blue)
  wr((4.35, 10.8), (6.05, 10.8), blue)
  line((4.35, 10.45), (5.0, 10.45), (5.0, 8.4), (12.55, 8.4), stroke: (paint: blue, thickness: 1pt),
    mark: (end: "stealth", scale: 0.5, fill: blue))
  // 决策到娱乐/会话两路绿线
  line((8.25, 11.10), (9.2, 11.10), (9.2, 13.05), (10.35, 13.05), stroke: (paint: green, thickness: 1pt),
    mark: (end: "stealth", scale: 0.5, fill: green))
  line((8.75, 11.35), (9.6, 11.35), (9.6, 10.5), (12.55, 10.5), stroke: (paint: green, thickness: 1pt),
    mark: (end: "stealth", scale: 0.5, fill: green))
  // 三路深蓝粗箭头输出
  line((12.35, 13.3), (15.85, 13.3), (15.85, 13.22), stroke: (paint: navy, thickness: 3pt),
    mark: (end: "stealth", scale: 0.7, fill: navy))
  line((14.65, 10.15), (16.15, 10.15), stroke: (paint: navy, thickness: 3pt),
    mark: (end: "stealth", scale: 0.7, fill: navy))
  line((14.65, 7.8), (16.3, 7.8), stroke: (paint: navy, thickness: 3pt),
    mark: (end: "stealth", scale: 0.7, fill: navy))

  // 机器人回路：传感器→行为、脚本→控制器、控制器→传感器
  line((1.4, 3.25), (1.1, 3.25), (1.1, 6.325), (1.85, 6.325),
    stroke: (paint: blue, thickness: 0.8pt),
    mark: (end: "stealth", scale: 0.5, fill: blue))
  wr((4.55, 4.85), (3.7, 4.85), blue)
  wr((2.55, 4.3), (2.55, 3.5), blue)

  // Script 文档块与 Σ 求和点
  rect((4.55, 4.4), (5.65, 5.35), stroke: 1pt + ink, fill: white)
  line((4.72, 4.4), (4.72, 5.35), stroke: (paint: ink, thickness: 0.8pt))
  line((4.90, 4.4), (4.90, 5.35), stroke: (paint: ink, thickness: 0.8pt))
  content((5.30, 4.87), text(size: 7pt, [Script]), angle: 90deg, frame: none)
  circle((6.35, 6.25), radius: 0.22, stroke: 1pt + ink, fill: white)
  line((6.22, 6.25), (6.48, 6.25), stroke: (paint: ink, thickness: 0.8pt))
  line((6.35, 6.12), (6.35, 6.38), stroke: (paint: ink, thickness: 0.8pt))
  // Prompt 4 黄线进 Σ，Σ 输出写入 Script
  line((12.85, 8.30), (12.70, 8.30), (12.70, 6.55), (5.35, 6.55), (5.35, 6.25), (6.13, 6.25),
    stroke: (paint: yellow, thickness: 1pt), mark: (end: "stealth", scale: 0.5, fill: yellow))
  line((6.35, 6.47), (6.35, 6.85), (5.1, 6.85), (5.1, 5.35), stroke: (paint: blue, thickness: 1pt),
    mark: (end: "stealth", scale: 0.5, fill: blue))

  // 底部总线：RGB 图像回馈进 Converse，娱乐输出下行并入总线，青线进 Σ
  line((2.55, 2.5), (2.55, 2.1), (15.4, 2.1), stroke: (paint: cyan, thickness: 1pt))
  line((13.9, 2.1), (13.9, 5.85), stroke: (paint: cyan, thickness: 1pt),
    mark: (end: "stealth", scale: 0.5, fill: cyan))
  line((6.35, 2.1), (6.35, 6.03), stroke: (paint: cyan, thickness: 1pt),
    mark: (end: "stealth", scale: 0.5, fill: cyan))
  line((12.35, 12.0), (15.4, 12.0), (15.4, 2.1), stroke: (paint: blue, thickness: 0.9pt))
  txt(8.3, 2.28, [Output = RGB image of user])

  // 四个说明文字块
  txt(7.55, 7.62,
    [Input = user request\ output = user#sub[request] +\ entertain(user#sub[request])\ OR\ converse(user#sub[request])], size: 6.8pt)
  txt(8.15, 3.25,
    [Script serves as a buffer\ between LLM responses and\ the execution of these\ responses by the low-level\ controller], size: 6.5pt)
  txt(10.35, 5.55,
    [Input=response user request\ Output=Script containing\ textual to user +\ embedded atomic actions], size: 6.6pt)
})
