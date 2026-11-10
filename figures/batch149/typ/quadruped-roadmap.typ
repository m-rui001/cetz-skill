// 四阶段路线图：四个平涂彩色圆角阶段框 + 横向箭头 + 底部时间轴刻度
// 来源：Quadruped Robots review, Robotics 2025, 14, 57 — Figure 10. DOI 10.3390/robotics14050057.

#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas({
  import draw: *

  // 阶段框几何：统一宽度、等间距、顶边对齐
  let w = 5.2
  let gap = 1.3
  let x0s = range(4).map(i => i * (w + gap))
  let top = 0
  let first-y = -1.05
  let line-gap = 0.44
  let pad = 0.55

  // 表驱动：每框的底色、标题与逐行说明文字
  let stages = (
    (fill: rgb("#d6d4f2"), title: "Current State", lines: (
      "- Advanced pro-", "totypes", "- Robust sensor fusion",
      "- Autonomous", "locomotion")),
    (fill: rgb("#c8f2c0"), title: "Near Future", lines: (
      "+ Enhanced en-", "ergy efficiency", "+ Improved AI control",
      "+ Better environ-", "ment interaction")),
    (fill: rgb("#fbf2c4"), title: "Mid-Term", lines: (
      "+ Wider com-", "mercialization", "+ Expanded ser-",
      "vice applications", "+ Higher autonomy", "and adaptability")),
    (fill: rgb("#f8c8cb"), title: "Long-Term", lines: (
      "+ Fully au-", "tonomous systems", "+ Reconfig-",
      "urable morphologies", "+ Advanced human-", "robot collaboration")),
  )

  // 逐框绘制圆角矩形、粗体标题与内容行
  for (i, s) in stages.enumerate() {
    let x0 = x0s.at(i)
    let x1 = x0 + w
    let cx = (x0 + x1) / 2
    let bot = first-y - (s.lines.len() - 1) * line-gap - pad
    rect((x0, top), (x1, bot), radius: 0.35, fill: s.fill, stroke: 1pt)
    content((cx, top - 0.42), text(weight: "bold", s.title))
    for (j, ln) in s.lines.enumerate() {
      content((cx, first-y - j * line-gap), ln)
    }
  }

  // 阶段之间的水平箭头
  let ay = -1.72
  for i in range(3) {
    line((x0s.at(i) + w + 0.12, ay), (x0s.at(i + 1) - 0.12, ay),
      stroke: 1.3pt, mark: (end: "stealth", fill: black, scale: 1.6))
  }

  // 底部时间轴：主线带箭头，刻度对齐各框中心
  let ty = -4.7
  let centers = x0s.map(x => x + w / 2)
  line((centers.at(0), ty), (x0s.at(3) + w + 0.3, ty),
    stroke: 1pt, mark: (end: "stealth", fill: black, scale: 1.6))
  for c in centers {
    line((c, ty + 0.22), (c, ty - 0.22), stroke: 1pt)
  }
})
