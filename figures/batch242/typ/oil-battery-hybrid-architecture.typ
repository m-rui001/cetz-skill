#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 编译结果：左侧蓝色虚线框内为“发动机→发电机→整流→直流母线”动力链，其下为“电池↔DC/DC↔母线”
// 支路；中间一竖条深蓝直流母线，标注 DC bus；右侧虚线框内两路“DC/AC→电机→螺旋桨”分布式推进，
// 两排之间以省略号表示可扩展。红字为两个分区标题，蓝箭头表示功率流向。
// 来源：Aerospace 2025, 12, 895, Figure 1 (DOI 10.3390/aerospace12100895)

#canvas({
  import draw: *

  // 配色与地标坐标
  let c-arr = rgb("#2e75b6")          // 功率连线蓝
  let c-frm = rgb("#2e75b6")          // 分区虚线框蓝
  let c-bus = rgb("#1f4e79")          // 直流母线深蓝
  let c-red = rgb("#c00000")          // 分区标题红
  let hb = 0.92                       // 方块高
  let r1 = 3.00                       // 上排中心线 y
  let r2 = 1.46                       // 下排中心线 y
  let g1 = (0.10, 0.22, 9.26, 4.59)   // 左分区框
  let g2 = (10.63, 0.22, 18.48, 4.59) // 右分区框
  let bus-l = 9.90                    // 母线左沿
  let bus-r = 10.22                   // 母线右沿

  // 共享助手：圆角方块 + 居中粗体标签
  let blk(cx, cy, w, t) = {
    rect((cx - w / 2, cy - hb / 2), (cx + w / 2, cy + hb / 2), radius: 0.14, stroke: 1.1pt, fill: white)
    content((cx, cy), text(weight: "bold", t))
  }
  // 共享助手：功率箭头，两端留 0.08 间隙；both 为双向
  let arr(a, b, both: false) = if both {
    line(a, b, stroke: (paint: c-arr, thickness: 1.7pt), mark: (start: "stealth", end: "stealth"))
  } else {
    line(a, b, stroke: (paint: c-arr, thickness: 1.7pt), mark: (end: "stealth"))
  }
  // 共享助手：相邻方块之间连线，端点由各自宽度派生
  let chain-arr(boxes, y) = {
    for i in range(boxes.len() - 1) {
      let (_, x0, w0) = boxes.at(i)
      let (_, x1, w1) = boxes.at(i + 1)
      arr((x0 + w0 / 2 + 0.08, y), (x1 - w1 / 2 - 0.08, y))
    }
  }

  // 两个虚线分区框
  for g in (g1, g2) {
    rect((g.at(0), g.at(1)), (g.at(2), g.at(3)), radius: 0.10, stroke: (paint: c-frm, thickness: 1.2pt, dash: "dashed"))
  }

  // 直流母线竖条
  rect((bus-l, 0.53), (bus-r, 4.02), fill: c-bus, stroke: none)

  // 左框上排：发动机 → 发电机 → 整流
  let chain = (("aeroengine", 1.78, 2.49), ("Generator", 5.20, 2.22), ("AC-DC", 7.95, 1.81))
  for (t, cx, w) in chain {
    blk(cx, r1, w, t)
  }
  chain-arr(chain, r1)
  // 整流输出并入母线
  let (_, xa, wa) = chain.at(2)
  arr((xa + wa / 2 + 0.08, r1), (bus-l - 0.08, r1))

  // 左框下排：电池 ↔ DC/DC ↔ 母线（双向）
  let bat = (("Battery", 5.00, 1.81), ("DC-DC", 7.95, 1.81))
  for (t, cx, w) in bat {
    blk(cx, r2, w, t)
  }
  let (_, xb, wb) = bat.at(0)
  let (_, xc, wc) = bat.at(1)
  arr((xb + wb / 2 + 0.08, r2), (xc - wc / 2 - 0.08, r2), both: true)
  arr((xc + wc / 2 + 0.08, r2), (bus-l - 0.08, r2), both: true)

  // 右框：两路 DC/AC → 电机 → 螺旋桨
  let prop = (("DC-AC", 11.86, 1.65), ("Motor", 14.38, 1.71), ("Propeller", 17.00, 2.03))
  for y in (r1, r2) {
    for (t, cx, w) in prop {
      blk(cx, y, w, t)
    }
    // 母线分出支路
    let (_, xp, wp) = prop.at(0)
    arr((bus-r + 0.08, y), (xp - wp / 2 - 0.08, y))
    chain-arr(prop, y)
  }

  // 两排之间的省略号，表示推进支路可继续扩展
  for (_, cx, _w) in prop {
    for k in (-1, 0, 1) {
      circle((cx, 2.23 + k * 0.20), radius: 0.045, fill: black, stroke: none)
    }
  }

  // 分区标题与母线标注
  content((4.68, 4.28), text(fill: c-red, weight: "bold", "Oil-battery hybrid power system"))
  content((14.55, 4.28), text(fill: c-red, weight: "bold", "Distributed Propulsion System"))
  content((9.86, 4.34), text(fill: c-bus, weight: "bold", "DC bus"))
})
