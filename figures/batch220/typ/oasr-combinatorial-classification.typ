#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：黑白线稿式分类树。左侧圆角根框「Combinatorial categorization of OASR」经圆角总线
// 分出三支（装配机器人／交互技术／装配目标），中列再分五类，末列六个对象框以交叉细线相接。
// 来源：Aerospace 2025, 12, 375, Figure 3（Combined space robot assembly classification schematic）。DOI 10.3390/aerospace12050375
#canvas({
  import draw: *
  set-style(stroke: 0.55pt)

  // —— 几何助手：折线拐角倒成小圆角 ——
  let add(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
  let sub(a, b) = (a.at(0) - b.at(0), a.at(1) - b.at(1))
  let mul(a, k) = (a.at(0) * k, a.at(1) * k)
  let unit(a) = mul(a, 1 / calc.sqrt(a.at(0) * a.at(0) + a.at(1) * a.at(1)))
  let elbow(pts, r: 0.13) = {
    let cur = pts.first()
    for i in range(1, pts.len() - 1) {
      let v = pts.at(i)
      let s = sub(v, mul(unit(sub(v, pts.at(i - 1))), r))
      let e = add(v, mul(unit(sub(pts.at(i + 1), v)), r))
      line(cur, s)
      bezier(s, e, v, v)
      cur = e
    }
    line(cur, pts.last())
  }

  // —— 圆角标签框：中心点 + 宽高 + 文案 ——
  let node(x, y, w, h, body) = {
    rect((x - w / 2, y - h / 2), (x + w / 2, y + h / 2), radius: 0.15, fill: white)
    content((x, y), text(size: 9pt, body))
  }

  // —— 四列地标坐标 ——
  let (rx0, rx1) = (0.30, 4.55)   // 根框列
  let (mx0, mx1) = (5.10, 9.00)   // 中列
  let (sx0, sx1) = (9.45, 14.50)  // 子类列
  let (ox0, ox1) = (15.90, 20.60) // 对象框列
  let mcx = (mx0 + mx1) / 2
  let scx = (sx0 + sx1) / 2
  let ocx = (ox0 + ox1) / 2

  // —— 子类行高与对象框行高 ——
  let ly = (6.20, 5.40, 4.55, 2.30, 1.00)
  let oy = (6.60, 5.40, 4.20, 3.00, 1.80, 0.60)

  // 根框
  node((rx0 + rx1) / 2, 3.45, rx1 - rx0, 0.95, [Combinatorial \ categorization of OASR])

  // 中列三个主类框
  node(mcx, ly.at(1), mx1 - mx0, 0.66, [Space assembly robots])
  node(mcx, 3.45, mx1 - mx0, 0.95, [Interactive techniques \ for space assemblies])
  node(mcx, 1.60, mx1 - mx0, 0.66, [Target assembly objects])

  // 子类框（上三属装配机器人，下二属装配目标）
  node(scx, ly.at(0), sx1 - sx0, 0.66, [Fixed assembly robots])
  node(scx, ly.at(1), sx1 - sx0, 0.66, [Semi-fixed assembly robot])
  node(scx, ly.at(2), sx1 - sx0, 0.66, [Floating assembly robot])
  node(scx, ly.at(3), sx1 - sx0, 0.66, [Non-arrayed structured objects])
  node(scx, ly.at(4), sx1 - sx0, 0.66, [Arrayed structural objects])

  // 末列六个装配对象框
  let olabels = (
    [Consumption loads, small \ components, etc.],
    [Standard components, \ connectors, etc.],
    [Main structure of large space \ facilities, etc.],
    [Standardized components, \ cell building blocks, etc.],
    [Functional structure docking \ assembly, etc.],
    [Modular structure docking \ installation, etc.],
  )
  for (i, y) in oy.enumerate() { node(ocx, y, ox1 - ox0, 0.90, olabels.at(i)) }

  // 根框到中列的三段总线
  elbow(((rx1, 3.45), (4.85, 3.45), (4.85, ly.at(1)), (mx0, ly.at(1))))
  elbow(((rx1, 3.45), (4.85, 3.45), (4.85, 1.60), (mx0, 1.60)))
  line((4.85, 3.45), (mx0, 3.45))

  // 装配机器人总线分出上三类
  elbow(((mx1, ly.at(1)), (9.22, ly.at(1)), (9.22, ly.at(0)), (sx0, ly.at(0))))
  elbow(((mx1, ly.at(1)), (9.22, ly.at(1)), (9.22, ly.at(2)), (sx0, ly.at(2))))
  line((9.22, ly.at(1)), (sx0, ly.at(1)))

  // 装配目标总线分出下两类
  elbow(((mx1, 1.60), (9.22, 1.60), (9.22, ly.at(3)), (sx0, ly.at(3))))
  elbow(((mx1, 1.60), (9.22, 1.60), (9.22, ly.at(4)), (sx0, ly.at(4))))

  // 中列三类之间的双向箭头
  line((mcx, 5.07), (mcx, 3.925), mark: (start: "stealth", end: "stealth"))
  line((mcx, 2.975), (mcx, 1.93), mark: (start: "stealth", end: "stealth"))

  // 子类到对象框的交叉连线（左端随子类，右端按原图错开附着）
  let links = (
    (6.20, 6.60), (6.20, 5.40),
    (5.40, 4.26), (5.40, 3.13),
    (4.55, 1.95), (4.55, 0.84),
    (2.30, 6.30), (2.30, 4.05), (2.30, 1.82),
    (1.00, 5.04), (1.00, 2.85), (1.00, 0.63),
  )
  for (yl, yr) in links { line((sx1, yl), (ox0, yr)) }
})
