#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：TinyML 综述 PRISMA 2020 筛选流程图。顶部标题条，下分双识别通道：左侧“数据库与注册库”
// 依次 Records identified→removed before screening→screened→excluded→sought→not retrieved→assessed→
// excluded→Studies included in review；右侧“其他方法”Citation searching→sought→not retrieved→assessed→
// excluded，末段并入 Studies included in review。左缘 Identification/Screening/Included 三条竖排阶段条，
// 逐字保留全部计数（n = 1880/270/100/1780/9/91/4/5/174/31/143/22/6/3/26）。
// 来源：Sensors 2025, 25, 3191, Figure 2 "PRISMA selection flowchart". DOI 10.3390/s25103191

#canvas({
  import draw: *
  let ink = black
  let orange = rgb("#f5a623")
  let blue = rgb("#a8c8e8")
  let bblue = rgb("#4a6fa5")
  let t(pos, s, size: 5.4pt, anchor: "center") = content(
    pos, text(size: size)[#s], anchor: anchor, frame: none)
  let boxw(c, w, h, s, size: 5.4pt) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      fill: white, stroke: 0.7pt + ink)
    content(c, text(size: size)[#s], anchor: "center", frame: none)
  }
  let arr(a, b) = line(a, b, stroke: 0.7pt + ink, mark: (end: "stealth", scale: 0.5))
  let arrp(..pts) = line(..pts, stroke: 0.7pt + ink, mark: (end: "stealth", scale: 0.5))

  // 外框、标题与两条橙色识别横幅
  rect((0.25, 0.35), (15.15, 8.95), stroke: 0.7pt + ink)
  t((7.70, 8.70),
    [PRISMA 2020 flow diagram for new systematic reviews which included \ searches of databases, registers and other sources], size: 5.8pt)
  rect((0.55, 7.95), (8.05, 8.35), fill: orange, stroke: 0.6pt + ink)
  t((4.30, 8.15), [Identification of studies via databases and registers], size: 6.0pt)
  rect((8.45, 7.95), (15.05, 8.35), fill: orange, stroke: 0.6pt + ink)
  t((11.75, 8.15), [Identification of studies via other methods], size: 6.0pt)

  // 左缘阶段条
  for ph in ((6.60, 7.70, [Identification]), (2.45, 6.35, [Screening]), (0.80, 1.95, [Included])) {
    rect((0.50, ph.at(0)), (0.82, ph.at(1)), radius: 0.10, fill: blue, stroke: 0.7pt + bblue)
    content((0.66, (ph.at(0) + ph.at(1)) / 2), text(size: 5.8pt, weight: "bold")[#ph.at(2)],
      anchor: "center", angle: 90deg, frame: none)
  }

  // 数据库通道
  boxw((2.55, 7.00), 1.55, 0.32, [Records identified from: \ Databases (n = 1880)])
  boxw((5.90, 6.95), 1.25, 0.62,
    [Records removed #emph[before] \ #emph[screening]: \ Records marked as \ ineligible by automation \ tools (n = 270)], size: 5.0pt)
  boxw((2.55, 5.55), 1.55, 0.28, [Records screened \ (n = 100)])
  boxw((5.90, 5.55), 1.25, 0.28, [Records excluded \ (n = 1780)])
  boxw((2.55, 4.25), 1.55, 0.32, [Reports sought for retrieval \ (n = 9)])
  boxw((5.90, 4.25), 1.25, 0.28, [Reports not retrieved \ (n = 91)])
  boxw((2.55, 2.95), 1.55, 0.36, [Reports assessed for eligibility \ (n = 4)])
  boxw((5.90, 2.95), 1.25, 0.44, [Reports excluded: \ Lack of low latency use case \ (n = 5)])
  boxw((2.55, 1.35), 1.55, 0.34, [Studies included in review \ (n = 26)])
  arr((4.10, 7.00), (4.63, 7.00))
  arr((2.55, 6.68), (2.55, 5.85))
  arr((4.10, 5.55), (4.63, 5.55))
  arr((2.55, 5.27), (2.55, 4.59))
  arr((4.10, 4.25), (4.63, 4.25))
  arr((2.55, 3.93), (2.55, 3.33))
  arr((4.10, 2.95), (4.63, 2.95))
  arr((2.55, 2.59), (2.55, 1.71))

  // 其他方法通道
  boxw((11.30, 7.00), 1.30, 0.32, [Records identified from: \ Citation searching (n = 174)])
  boxw((11.30, 4.55), 1.30, 0.32, [Reports sought for retrieval \ (n = 31)])
  boxw((13.95, 4.55), 1.10, 0.28, [Reports not retrieved \ (n = 143)])
  boxw((11.30, 2.60), 1.30, 0.32, [Reports assessed for eligibility \ (n = 22)])
  boxw((13.95, 2.55), 1.10, 0.62,
    [Reports excluded: \ Experiment used \ off-device inference \ (n = 6); Experiment \ lacked a use case (n = 3)], size: 5.0pt)
  arr((11.30, 6.68), (11.30, 4.89))
  arr((12.60, 4.55), (12.83, 4.55))
  arr((11.30, 4.23), (11.30, 2.94))
  arr((12.60, 2.60), (12.83, 2.60))
  arrp((11.30, 2.28), (11.30, 1.35), (4.12, 1.35))
})
