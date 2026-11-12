#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：飞机起落架材料相关机械失效的鱼骨因果图。主干指向右侧结果框 Landing Gear Material-Related
// Mechanical Failures；上方分类 Aluminium alloy components failures 经两条斜脊挂 5+6 组失效，
// 下方分类 Steel components failures 经两条斜脊挂 3+3 组失效。每组为粗体失效名＋其上方依次排列的
// 原因文字，短横骨接入斜脊。17 个失效与全部原因文字逐字保留。
// 来源：Aerospace 2025, 12, 266, Figure 3 "Aircraft landing gear failures and cause analysis based on reviewed failure investigation" DOI 10.3390/aerospace12030266

#canvas({
  import draw: *
  let ink = black
  let thick = (p, q) => line(p, q, stroke: 2.2pt + ink)
  // 失效组：从斜脊短骨引出粗体失效名，原因文字逐行叠在其上方
  let grpL(y, s, causes, xd) = {
    line((xd, y), (xd - 0.45, y), stroke: 1.2pt + ink)
    content((xd - 0.55, y), text(size: 7.5pt, weight: "bold", s), anchor: "east", frame: none)
    for (i, c) in causes.enumerate() {
      content((xd - 0.55, y + 0.31 + 0.30 * i), text(size: 7pt, c), anchor: "east", frame: none)
    }
  }
  let grpR(y, s, causes, xd) = {
    line((xd, y), (xd + 0.45, y), stroke: 1.2pt + ink)
    content((xd + 0.55, y), text(size: 7.5pt, weight: "bold", s), anchor: "west", frame: none)
    for (i, c) in causes.enumerate() {
      content((xd + 0.55, y + 0.31 + 0.30 * i), text(size: 7pt, c), anchor: "west", frame: none)
    }
  }
  let dxUL(y) = 4.90 + 1.30 * (y - 6.0) / 5.97
  let dxUR(y) = 13.60 - 3.60 * (y - 6.0) / 5.97
  let dxLL(y) = 4.90 + 1.10 * (6.0 - y) / 4.98
  let dxLR(y) = 13.60 - 3.40 * (6.0 - y) / 4.98

  // 主干与结果框
  line((0.90, 6.0), (16.30, 6.0), stroke: 3pt + ink,
    mark: (end: "stealth", scale: 0.8, fill: ink))
  rect((16.35, 5.20), (20.15, 6.80), stroke: 1.6pt + ink)
  content((18.25, 6.0), text(size: 7.8pt, weight: "bold",
    [Landing Gear Material-\ Related Mechanical\ Failures]))

  // 两个分类框与四条斜脊
  rect((5.55, 12.00), (10.65, 12.55), stroke: 1.6pt + ink)
  content((8.10, 12.27), text(size: 8.6pt, weight: "bold", [Aluminium alloy components failures]))
  thick((6.20, 12.00), (4.90, 6.0))
  thick((10.00, 12.00), (13.60, 6.0))
  rect((5.95, 0.48), (10.25, 1.02), stroke: 1.6pt + ink)
  content((8.10, 0.75), text(size: 8.6pt, weight: "bold", [Steel components failures]))
  thick((6.00, 1.02), (4.90, 6.0))
  thick((10.20, 1.02), (13.60, 6.0))

  // 铝件左簇（5 组）
  grpL(6.55, [Cylinder support fracture], ([corrosion fatigue],), dxUL(6.55))
  grpL(7.45, [ATF lock links fracture], ([fatigue cracking],), dxUL(7.45))
  grpL(8.35, [Right wheel flange failure], ([corrosion fatigue], [Design deficiency]), dxUL(8.35))
  grpL(9.55, [Drag Strut failure],
    ([corrosion], [anomalous high load/stress], [fatigue failure], [manufacturing deficiency]), dxUL(9.55))
  grpL(11.15, [Outer cylinder lug fracture], ([corrosion], [anomalous high load/stress]), dxUL(11.15))

  // 铝件右簇（6 组）
  grpR(6.50, [Strut bearing], ([corrosion fatigue],), dxUR(6.50))
  grpR(7.35, [Landing gear door hinge], ([improper maintenance],), dxUR(7.35))
  grpR(8.20, [Hydraulic actuator cylinder], ([corrosion fatigue],), dxUR(8.20))
  grpR(9.05, [Swing lever failure],
    ([abnormal silicon concentration], [manufacturing deficiency during forging stage]), dxUR(9.05))
  grpR(9.90, [Landing gear fork failure], ([fatigue failure], [stress concentration]), dxUR(9.90))
  grpR(10.75, [Trunnion fracture - 1],
    ([corrosion fatigue], [fatigue failure], [anomalous high load/stress]), dxUR(10.75))

  // 钢件左簇（3 组）
  grpL(4.95, [Truck beam failure], ([cracking], [abusive grinding/maintenance]), dxLL(4.95))
  grpL(3.90, [Undercarriage strut failure], ([design deficiency],), dxLL(3.90))
  grpL(2.85, [Cantilever spring fracture], ([corrosion fatigue], [damaged protective coating]), dxLL(2.85))

  // 钢件右簇（3 组）
  grpR(4.95, [Piston rod end fracture], ([high stress concentration], [fatigue failure]), dxLR(4.95))
  grpR(3.90, [Linkage and bolts], ([Human error], [overload/hard landing]), dxLR(3.90))
  grpR(2.85, [Trunnion fracture - 2], ([manufacturing deficiency], [fatigue failure]), dxLR(2.85))
})
