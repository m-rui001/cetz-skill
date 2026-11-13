#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：pHRI 综述的 PRISMA 式检索流程图。顶部黄色标题带；左列三个竖排阶段标签 Identification/
// Screening/Included；Level 1 与 Level 2 两级检索框及右侧剔除数；SL1/SL2 两个子级及其记录数与
// screening 前剔除项；两行粉色 screening 框与右侧排除清单；底部两个绿色纳入框（n=34、n=64）；
// 连线标注 24、10、2、62。全部数字与文字逐字保留。
// 来源：Robotics 2025, 14, 27, Figure 2 "Flow diagram of the paper search performed" DOI 10.3390/robotics14030027

#canvas({
  import draw: *
  let ink = black
  let yellow = rgb("#f5c518")
  let peach = rgb("#f9d3b4")
  let cyan = rgb("#2fc3f0")
  let lblue = rgb("#cfe9f7")
  let green = rgb("#b7e2b7")
  let lgreen = rgb("#d9f2d9")
  let pink = rgb("#f6c6e8")
  let band = rgb("#cfe4f7")
  // 矩形信息块：中心、宽、高、文字、填充色、字号、圆角
  let box(cx, cy, w, h, s, fill, size: 7.6pt, r: 0.06) = {
    rect((cx - w / 2, cy - h / 2), (cx + w / 2, cy + h / 2), radius: r,
      fill: fill, stroke: 1pt + ink)
    content((cx, cy), text(size: size, s))
  }
  let arrow(a, b) = line(a, b, stroke: 1.2pt + ink, mark: (end: "stealth", scale: 0.5, fill: ink))
  let lbl(p, s) = content(p, text(size: 8pt, weight: "bold", s), frame: none)

  // 竖排阶段带
  rect((0.70, 14.0), (1.50, 19.0), fill: band, stroke: 1pt + ink)
  rect((0.70, 7.40), (1.50, 13.6), fill: band, stroke: 1pt + ink)
  rect((0.70, 0.90), (1.50, 7.00), fill: band, stroke: 1pt + ink)
  content((1.10, 16.5), text(size: 8.5pt, weight: "bold", [Identification]), angle: 90deg, frame: none)
  content((1.10, 10.5), text(size: 8.5pt, weight: "bold", [Screening]), angle: 90deg, frame: none)
  content((1.10, 3.95), text(size: 8.5pt, weight: "bold", [Included]), angle: 90deg, frame: none)

  // 顶部标题带
  box(11.45, 18.95, 16.9, 0.8,
    [*Identification of studies via SCOPUS and IEEE Xplore databases\ (from January 2010 to December 2024)*],
    yellow, size: 9.2pt, r: 0.14)

  // 两级检索：级别 chips 与记录数/剔除框
  box(3.10, 17.45, 2.80, 1.20, [*Level 1*\ Human-Robot\ Collaboration], peach, size: 7.8pt, r: 0.16)
  box(7.60, 17.45, 6.20, 1.50,
    [Number of records identified from:\ SCOPUS Database (n = 41,161)\ IEEE Database (n = 46,036)\ Total = 87,197],
    rgb("#fbe3d0"), size: 7.4pt)
  box(17.40, 17.45, 5.60, 1.10, [Records excluded by filtering:\ n= 75,939], white, size: 7.4pt)
  box(3.10, 15.55, 2.80, 1.35, [*Level 2*\ Physical\ Human-Robot\ Interaction], cyan, size: 6.9pt, r: 0.16)
  box(7.60, 15.55, 6.20, 1.50,
    [Number of records identified from:\ SCOPUS Database (n = 3,829)\ IEEE Database (n = 7,429)\ Total = 11,258],
    lblue, size: 7.4pt)
  box(17.40, 15.55, 5.60, 1.10, [Records excluded by filtering:\ n= 5,430], white, size: 7.4pt)

  // 两个子级
  box(5.40, 13.75, 4.20, 1.00, [*Sub-Level 1 (SL1)*\ Physical Human-Robot\ Contact Models], green, size: 7.0pt, r: 0.10)
  box(12.60, 13.75, 4.20, 1.00, [*Sub-Level 2 (SL2)*\ Physical Human-Robot\ Contact Measuring], green, size: 7.0pt, r: 0.10)
  box(5.40, 12.15, 5.60, 1.50,
    [Number of records identified from:\ SCOPUS Database = 237\ IEEE Xplore Database = 863\ Total = 1,100],
    lgreen, size: 7.4pt)
  box(11.80, 11.10, 4.80, 1.50,
    [Number of records identified from:\ SCOPUS Database = 356\ IEEE Xplore Database = 4,372\ Total = 4,728],
    lgreen, size: 7.4pt)
  box(17.20, 11.65, 5.60, 1.90,
    [Records removed before screening:\ - Duplicates in SL1 (n= 106)\ - Duplicates in SL2 (n=162)\ - Cross-checking dupl. (n=550)],
    white, size: 7.4pt)

  // 两行筛选框与排除清单
  box(5.00, 8.90, 4.60, 1.00, [Number of records screened\ n = 719], pink, size: 7.6pt)
  box(17.20, 8.90, 5.40, 1.30,
    [Records excluded:\ - No pHRI in industry (n= 547)\ - Improving inherent safety (n=125)\ - Collision avoidance (n=21)],
    white, size: 7.2pt)
  box(11.80, 6.40, 4.20, 1.00, [Number of records screened\ n = 4,291], pink, size: 7.6pt)
  box(17.20, 5.90, 5.40, 1.40,
    [Records excluded:\ - No pHRI in industry (n= 3,805)\ - Improving inherent safety (n=328)\ - Collision avoidance (n=86)],
    white, size: 7.2pt)

  // 两个纳入框
  box(5.00, 2.20, 5.40, 2.00,
    [Number of records included in the\ review dealing with\ *Physical H-R Contact Models*\ *n = 34*],
    green, size: 7.6pt)
  box(11.80, 1.90, 5.40, 2.10,
    [Number of records included in the\ review dealing with\ *Safety Evaluation and Impact\ Assessment*\ *n = 64*],
    green, size: 7.4pt)

  // 主干箭头
  arrow((7.60, 16.70), (7.60, 16.30))
  arrow((10.70, 17.45), (14.60, 17.45))
  arrow((10.70, 15.55), (14.60, 15.55))
  line((7.60, 14.80), (7.60, 14.55), (5.40, 14.55), (5.40, 14.25), stroke: 1.2pt + ink,
    mark: (end: "stealth", scale: 0.5, fill: ink))
  line((7.60, 14.55), (12.60, 14.55), (12.60, 14.25), stroke: 1.2pt + ink,
    mark: (end: "stealth", scale: 0.5, fill: ink))
  arrow((5.40, 13.25), (5.40, 12.90))
  arrow((12.60, 13.25), (12.60, 11.85))
  arrow((5.40, 11.40), (5.40, 9.40))
  arrow((8.20, 12.10), (14.40, 12.10))
  arrow((14.20, 11.10), (14.40, 11.10))
  arrow((11.80, 10.35), (11.80, 6.90))
  arrow((7.30, 8.90), (14.50, 8.90))
  arrow((13.90, 6.40), (14.50, 6.40))
  arrow((4.40, 8.40), (4.40, 3.20))
  arrow((5.60, 8.40), (5.60, 3.20))
  arrow((11.80, 5.90), (11.80, 2.95))
  line((9.70, 6.20), (6.60, 6.20), (6.60, 3.20), stroke: 1.2pt + ink,
    mark: (end: "stealth", scale: 0.5, fill: ink))
  // 汇入数量
  lbl((4.05, 5.60), [24])
  lbl((5.95, 5.60), [10])
  lbl((7.45, 6.38), [2])
  lbl((12.15, 4.55), [62])
})
