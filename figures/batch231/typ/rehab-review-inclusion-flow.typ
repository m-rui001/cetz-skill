#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 复刻 Actuators 2025, 14, 108 图1：文献检索与纳入流程图。青绿描边＋浅蓝平涂圆角框，
// 顶部粗体标题条，左侧四段竖排阶段标签（自下而上阅读），主栏四框纵向串联、右栏两框由支线汇入。
// DOI 10.3390/act14030108

#canvas({
  import draw: *
  // 配色与描边粗细
  let ink = rgb("#1c1c1c")
  let face = rgb("#dceff7")
  let teal = rgb("#2fcfc4")
  let lw = 0.9pt

  // 圆角卡片助手：两角点 + 居中文字
  let card(x0, y0, x1, y1, body, sz: 9pt, w: lw) = {
    rect((x0, y0), (x1, y1), radius: 0.16, fill: face,
      stroke: (paint: teal, thickness: w))
    content(((x0 + x1) / 2, (y0 + y1) / 2), align(center, text(size: sz, fill: ink, body)))
  }

  // 外框与标题条
  rect((0.20, 0.20), (15.80, 12.25), radius: 0.30, stroke: (paint: teal, thickness: 1.3pt))
  card(0.45, 11.30, 15.50, 12.05, [*Identification of Studies via Database and Register*], sz: 13pt)

  // 左栏四阶段竖排标签
  for (y0, y1, t) in (
    (8.35, 11.05, "IDENTIFICATION"),
    (5.80, 7.75, "SCREENING"),
    (3.55, 5.45, "ELIGIBILITY"),
    (0.62, 3.15, "INCLUDED"),
  ) {
    rect((0.40, y0), (1.15, y1), radius: 0.14, fill: face, stroke: (paint: teal, thickness: lw))
    content((0.775, (y0 + y1) / 2), text(size: 7.5pt, weight: "bold", fill: ink, t), angle: 90deg)
  }

  // 检索库与关键词两框
  card(1.60, 8.35, 5.70, 11.05, [
    Google Scholar, PubMed, \
    Scopus, Web of Science \
    database \
    (2014-2024)
  ])
  card(8.20, 8.35, 15.45, 11.05, [
    Adaptive Control, Robust Control, Sliding \
    mode control, PID control, Linear Quadratic \
    Regulator, PD control, Neural network based \
    control system, Non-Linear Control
  ])

  // 关键词箭头与标注
  line((5.70, 9.70), (8.20, 9.70), mark: (end: "stealth"), stroke: (paint: teal, thickness: lw))
  content((6.95, 9.88), text(size: 6.5pt, fill: ink, "Keywords"))

  // 主栏四框（纵向串联）
  card(1.50, 6.95, 7.50, 7.75, [Initial total article number = 364])
  card(1.50, 5.70, 7.50, 6.50, [Article assessed for eligibility = 200])
  card(1.50, 3.55, 7.45, 5.00, [
    Total number of article included in \
    the study \
    N = 153
  ])
  card(1.50, 1.10, 7.50, 2.20, [
    Articles included in the review \
    N = 101
  ])

  // 右栏两框
  card(9.20, 6.05, 15.55, 7.45, [
    Not containing pertinent information \
    N=164
  ])
  card(9.20, 2.25, 15.55, 3.70, [
    Excluded articles that have alternative \
    outcomes from our study purpose \
    N = 52
  ])

  // 主栏竖箭头（地标：中轴 x=4.50）
  let trunk = 4.50
  for (a, b) in ((6.95, 6.50), (5.70, 5.00), (3.55, 2.20)) {
    line((trunk, a), (trunk, b), mark: (end: "stealth"), stroke: (paint: teal, thickness: lw))
  }

  // 两条支线汇入右栏
  for y in (6.72, 3.45) {
    line((trunk, y), (9.20, y), mark: (end: "stealth"), stroke: (paint: teal, thickness: lw))
  }
})
