#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 编译外观：中灰底白色两行标题；左→右三阶段橙液白壳青电极，由扁平宽袋演变为双鼓包窄颈再到近方鼓包极窄中段，
// 配红＋/径向箭头、蓝−、绿 Maxwell 箭头、接地/终端与引线标签。
// 来源：A Review of Soft Robotic Actuators and Their Applications in Bioengineering, with an Emphasis on HASEL Actuators' Future Potential. Actuators 2024, 13, 524, Figure 2. DOI 10.3390/act13120524.
#canvas({
  import draw: *
  // 配色与命名笔画
  let bg = rgb("#a6a6a6")
  let orange = rgb("#f5a623")
  let cyan = rgb("#29abe2")
  let red = rgb("#e03131")
  let blue = rgb("#1c3faa")
  let green = rgb("#2f9e44")
  let shell-stroke = white + 3pt
  let electrode-stroke = cyan + 3pt
  let ink-stroke = black + 1.2pt
  let red-stroke = red + 1.4pt
  let blue-stroke = blue + 2.2pt
  let green-stroke = green + 1.2pt
  let lead-stroke = black + 1pt
  // 命名地标与阶段表
  let title-c = (9.6, 6.15)
  let base-y = 3.95
  let stages = (
    (gx: 0.45, l: 0.85, r: 5.55, bw: 0, bh: 0.36, nh: 0.36, tx: 5.95, v: "V1", dn: 4, ds: 0.7, kind: 0),
    (gx: 6.95, l: 7.25, r: 12.15, bw: 0.7, bh: 0.52, nh: 0.34, tx: 12.55, v: "V2", dn: 3, ds: 0.55, kind: 1),
    (gx: 13.35, l: 13.65, r: 18.55, bw: 0.68, bh: 0.68, nh: 0.13, tx: 18.95, v: "V3", dn: 3, ds: 0.7, kind: 2),
  )
  // 背景与标题
  rect((0, 0), (19.2, 8.0), fill: bg, stroke: none)
  content(title-c, text(size: 12pt, weight: "bold", fill: white)[#align(center)[Working principle of HASEL \ actuators]])
  // 接地符号助手：竖线＋三横递减
  let ground(x, y) = {
    line((x, y), (x, y - 0.45), stroke: ink-stroke)
    for i in range(3) {
      let w = 0.64 - i * 0.2
      line((x - w / 2, y - 0.45 - i * 0.11), (x + w / 2, y - 0.45 - i * 0.11), stroke: ink-stroke)
    }
  }
  // 终端助手：黑点＋短竖线＋电压标签
  let terminal(x, y, v) = {
    line((x, y + 0.45), (x, y), stroke: ink-stroke)
    circle((x, y + 0.45), radius: 0.045, fill: black, stroke: none)
    content((x, y + 0.62), text(weight: "bold")[#v], anchor: "south")
  }
  // 电荷行助手：红＋或蓝−循环排布
  let charge-row(cx, y, n, positive) = {
    for i in range(n) {
      let x = cx + (i - (n - 1) / 2) * 0.42
      if positive {
        line((x - 0.09, y), (x + 0.09, y), stroke: red-stroke)
        line((x, y - 0.09), (x, y + 0.09), stroke: red-stroke)
      } else {
        line((x - 0.07, y), (x + 0.07, y), stroke: blue-stroke)
      }
    }
  }
  // 径向箭头扇助手：鼓包内红色向外箭头
  let radial-fan(c, r0, r1) = {
    for i in range(8) {
      let a = i * 45deg
      let p0 = (c.at(0) + r0 * calc.cos(a), c.at(1) + r0 * calc.sin(a))
      let p1 = (c.at(0) + r1 * calc.cos(a), c.at(1) + r1 * calc.sin(a))
      line(p0, p1, mark: (end: "stealth"), stroke: red-stroke)
    }
  }
  // 圆弧锚点助手：圆心偏移起点
  let arc-at(c, r, a0, a1, ..st) = arc((c.at(0) + r * calc.cos(a0), c.at(1) + r * calc.sin(a0)), start: a0, stop: a1, radius: r, ..st)
  // 鼓包壳助手：扁平圆角矩形或双鼓包窄颈
  let pouch(l, r, cy, bw, bh, nh) = {
    if bw == 0 {
      rect((l, cy - nh), (r, cy + nh), radius: 0.12, fill: orange, stroke: shell-stroke)
    } else {
      let lc = l + bw
      let rc = r - bw
      let nl = l + 2 * bw
      let nr = r - 2 * bw
      let pts = (
        (l + 0.12, cy + bh), (lc + bw * 0.35, cy + bh), (nl + 0.12, cy + nh),
        (nr - 0.12, cy + nh), (rc - bw * 0.35, cy + bh), (r - 0.12, cy + bh),
        (r, cy + bh * 0.55), (r, cy - bh * 0.55), (r - 0.12, cy - bh),
        (rc - bw * 0.35, cy - bh), (nr - 0.12, cy - nh), (nl + 0.12, cy - nh),
        (lc + bw * 0.35, cy - bh), (l + 0.12, cy - bh), (l, cy - bh * 0.55), (l, cy + bh * 0.55),
      )
      hobby(..pts, close: true, ta: (2.5,) * pts.len(), tb: (2.5,) * pts.len(), fill: orange, stroke: shell-stroke)
    }
  }
  // 三阶段主体：表驱动壳、电极、电荷、接地与终端
  for s in stages {
    let cy = base-y
    let cx = (s.l + s.r) / 2
    let nl = s.l + 2 * s.bw
    let nr = s.r - 2 * s.bw
    pouch(s.l, s.r, cy, s.bw, s.bh, s.nh)
    line((s.gx - 0.4, cy), (s.l, cy), stroke: electrode-stroke)
    line((s.r, cy), (s.tx, cy), stroke: electrode-stroke)
    ground(s.gx, cy)
    terminal(s.tx, cy, s.v)
    let etop = if s.bw == 0 { s.l + 1.55 } else { nl }
    let ebot = if s.bw == 0 { s.r - 1.0 } else { nr }
    let eTopEnd = if s.bw == 0 { s.r } else { nr }
    let eBotStart = if s.bw == 0 { s.l } else { nl }
    line((etop, cy + s.nh + 0.06), (eTopEnd, cy + s.nh + 0.06), stroke: electrode-stroke)
    line((eBotStart, cy - s.nh - 0.06), (ebot, cy - s.nh - 0.06), stroke: electrode-stroke)
    let ccx = if s.bw == 0 { s.l + 2.3 } else { cx }
    charge-row(ccx, cy + s.nh + 0.26, 5, true)
    charge-row(ccx, cy - s.nh - 0.26, 5, false)
    // Maxwell 绿色下箭头排
    for i in range(s.dn) {
      let x = cx + (i - (s.dn - 1) / 2) * s.ds
      line((x, cy + s.nh - 0.06), (x, cy - s.nh + 0.06), mark: (end: "stealth"), stroke: green-stroke)
    }
    // 弯箭头／向心箭头与鼓包径向扇
    if s.kind == 0 {
      arc-at((cx - 1.4 + 0.12, cy), 0.22, 120deg, 240deg, stroke: green-stroke, mark: (end: "stealth"))
      arc-at((cx + 1.4 - 0.12, cy), 0.22, 60deg, -60deg, stroke: green-stroke, mark: (end: "stealth"))
    } else if s.kind == 1 {
      arc-at((nl + 0.12, cy), 0.22, 120deg, 240deg, stroke: green-stroke, mark: (end: "stealth"))
      arc-at((nr - 0.12, cy), 0.22, 60deg, -60deg, stroke: green-stroke, mark: (end: "stealth"))
      radial-fan((s.l + s.bw, cy), 0.12, 0.42)
      radial-fan((s.r - s.bw, cy), 0.12, 0.42)
    } else {
      line((nl, cy), (nl + 0.2, cy), mark: (end: "stealth"), stroke: green-stroke)
      line((nr, cy), (nr - 0.2, cy), mark: (end: "stealth"), stroke: green-stroke)
      radial-fan((s.l + s.bw, cy), 0.14, 0.52)
      radial-fan((s.r - s.bw, cy), 0.14, 0.52)
    }
  }
  // 引线标签助手：黑箭头指向目标
  let leader(body, lp, tp, anchor) = {
    line(lp, tp, mark: (end: "stealth"), stroke: lead-stroke)
    content(lp, text(weight: "bold", fill: white)[#align(center)[#body]], anchor: anchor)
  }
  // 逐字标签与引线目标
  leader([Electrode], (5.13, 4.87), (4.7, 4.37), "south")
  leader([Self-healing \ dielectric liquid], (1.63, 2.91), (1.38, 3.73), "north")
  leader([Elastomeric \ shell], (5.16, 2.72), (4.91, 3.52), "north")
  leader([Maxwell stress], (8.47, 2.17), (9.05, 3.82), "north")
  leader([Hydraulic pressure], (12.18, 2.72), (11.5, 3.52), "north")
})