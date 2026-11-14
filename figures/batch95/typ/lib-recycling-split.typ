// 锂离子电池回收分流流程图 —— 语义重绘（线稿，非照片）
// 源图：A Review of Lithium-Ion Battery Recycling: Technologies,
//       Sustainability, and Open Issues. Batteries 2024, 10(1), 38.
//       DOI 10.3390/batteries10010038，Figure 4。
//
// 编译版面（横向约 25cm × 纵向约 14cm）：
//   左列 —— 品红描边大圆，内含旋转 -30° 的电池芯线稿（圆柱+顶帽+色带）
//           与竖排 "Waste LIB"；品红向下箭头接到品红圆角 "Pre-treatments"
//           框（Discharge / Dismantle / Separate / Size reduction）；
//           框右侧品红向右箭头指向右列。
//   右列 —— 三个上下堆叠的浅灰描边圆角面板，左侧各一个彩描边菱形决策
//           节点（Other / Cathode / Anode），右侧文字区含粗水平分隔线
//           与线中点向下的同色箭头，箭头下方为回收产物文字。
// 配色：品红 #E5009D、teal #3BBFAD、blue #0F6FE8、gray #6E6A67。
// 三个右面板由 PANELS 表 + panel() 助手循环生成；菱形 / 水平线+下箭头 /
// 圆角面板 / 左列圆 / 箭头 / 预处理框均为共享助手，坐标全部由常量推导。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Arial", "Segoe UI"), size: 8.5pt, fill: rgb("#1a1a1a"))

#canvas(length: 1cm, {
  import draw: *

  // 配色与线型
  let INK = rgb("#1a1a1a")
  let MAGENTA = rgb("#E5009D")   // 左列：废电池 / 预处理 / 连接箭头
  let TEAL = rgb("#3BBFAD")      // 面板 1：Other
  let BLUE = rgb("#0F6FE8")      // 面板 2：Cathode
  let GRAY = rgb("#6E6A67")      // 面板 3：Anode
  let EDGE = rgb("#D8D8D8")      // 右列面板浅灰描边

  // 语义坐标常量
  let LEFT_X = 2.85              // 左列中心 x
  let CIRC_CY = 10.7             // 废电池圆心 y
  let CIRC_R = 1.9               // 废电池圆半径
  let BOX_X0 = 0.7               // 预处理框左 / 右 / 上 / 下
  let BOX_X1 = 5.0
  let BOX_TOP = 7.35
  let BOX_BOT = 3.7
  let BOX_CX = (BOX_X0 + BOX_X1) / 2

  let PAN_X0 = 7.0               // 右列面板左 / 右边界
  let PAN_X1 = 24.6
  let DIA_X = 9.2                // 菱形中心 x 与半宽 / 半高
  let DIA_HW = 1.7
  let DIA_HH = 1.0
  let TXT_X0 = 11.3              // 右侧文字区左 / 右边界与中心
  let TXT_X1 = 24.1
  let TXT_CX = (TXT_X0 + TXT_X1) / 2

  let TOP = 13.5                 // 第一个面板顶边
  let GAP = 0.5                  // 面板间距
  let LH = 0.46                  // 单行文字行高
  let PAD = 0.45                 // 面板内上 / 下留白
  let RULE_DROP = 0.12           // 标题行到水平线的间距
  let RULE_ARROW = 0.55          // 水平线中点向下箭头长度
  let AFTER_RULE = 0.35          // 箭头尖端到首行产物的间距
  let GROUP_GAP = 0.30           // bold 引导词组之间的额外间距

  // 共享助手
  // 文字落位：anchor 控制对齐，body 内可含 *bold* 与 #linebreak()
  let put(pos, body, anchor: "center", size: 8.5pt) = content(pos, anchor: anchor, text(size: size, body))

  // 菱形决策节点：闭合四点 + 居中标签
  let diamond(c, col, label) = {
    let (x, y) = c
    line((x - DIA_HW, y), (x, y + DIA_HH), (x + DIA_HW, y), (x, y - DIA_HH),
      close: true, stroke: (paint: col, thickness: 2.4pt))
    put(c, label, size: 9.5pt)
  }

  // 粗水平分隔线 + 线中点向下的同色箭头（分开绘制）
  let rule-arrow(y, col) = {
    line((TXT_X0, y), (TXT_X1, y), stroke: (paint: col, thickness: 2.6pt))
    line((TXT_CX, y), (TXT_CX, y - RULE_ARROW),
      stroke: (paint: col, thickness: 2.6pt), mark: (end: ">", fill: col, scale: 1.0))
  }

  // 由内容推导面板高度（避免手抄绝对坐标）
  let panel-h(rows, rtitle, outs) = {
    let h = 2 * PAD + RULE_ARROW + AFTER_RULE + outs.len() * LH
    if rtitle != none { h += LH + RULE_DROP }
    for (b, n) in rows { h += n * LH + GROUP_GAP }
    h
  }

  // 单个右面板：圆角框 + 菱形 + 右侧自上而下的文字 / 分隔线 / 产物
  let panel(ytop, h, col, dlabel, rows, rtitle, outs) = {
    rect((PAN_X0, ytop - h), (PAN_X1, ytop), radius: 0.45,
      stroke: (paint: EDGE, thickness: 1.6pt))
    diamond((DIA_X, ytop - h / 2), col, dlabel)
    let cy = ytop - PAD
    if rtitle != none {
      put((TXT_CX, cy), rtitle, anchor: "north", size: 9pt)
      cy -= LH + RULE_DROP
    }
    for (body, n) in rows {
      put((TXT_X0, cy), body, anchor: "north-west")
      cy -= n * LH + GROUP_GAP
    }
    rule-arrow(cy, col)
    cy -= RULE_ARROW + AFTER_RULE
    for o in outs {
      put((TXT_CX, cy), o, anchor: "north")
      cy -= LH
    }
  }

  // 品红连接箭头（向下 / 向右共用）
  let mag-arrow(a, b) = line(a, b,
    stroke: (paint: MAGENTA, thickness: 2.6pt), mark: (end: ">", fill: MAGENTA, scale: 1.2))

  // 废电池圆：品红描边圆 + 旋转 -30° 的电池芯线稿 + 竖排 "Waste LIB"
  let waste-circle() = {
    circle((LEFT_X, CIRC_CY), radius: CIRC_R,
      stroke: (paint: MAGENTA, thickness: 2.6pt))
    group({
      translate((LEFT_X, CIRC_CY))
      rotate(-30deg)
      // 圆柱本体（浅粉）+ 底部色带 + 顶帽 + 正极凸头
      rect((-0.6, -1.15), (0.6, 0.95), radius: 0.14,
        fill: rgb("#F6E3E3"), stroke: (paint: INK, thickness: 0.8pt))
      rect((-0.5, -1.05), (0.5, -0.5), radius: 0.08,
        fill: rgb("#C8862A"), stroke: (paint: INK, thickness: 0.5pt))
      line((-0.6, 0.62), (0.6, 0.62), stroke: (paint: INK, thickness: 0.5pt))
      rect((-0.42, 0.95), (0.42, 1.2), fill: rgb("#C9C9C9"), stroke: (paint: INK, thickness: 0.7pt))
      rect((-0.16, 1.2), (0.16, 1.4), fill: rgb("#9A9A9A"), stroke: (paint: INK, thickness: 0.6pt))
      content((0, 0.12), anchor: "center", angle: 90deg,
        text(size: 10pt, weight: "bold", [Waste #linebreak() LIB]))
    })
  }

  // 预处理框：品红圆角矩形 + bold 标题 + 四行居中工序
  let pretreat-box() = {
    rect((BOX_X0, BOX_BOT), (BOX_X1, BOX_TOP), radius: 0.5,
      fill: white, stroke: (paint: MAGENTA, thickness: 2.4pt))
    put((BOX_CX, BOX_TOP - 0.55), [*Pre-treatments*], size: 11pt)
    let y = BOX_TOP - 1.15
    for item in ([Discharge], [Dismantle], [Separate], [Size reduction]) {
      put((BOX_CX, y), item, size: 9pt)
      y -= 0.5
    }
  }

  // 右列：三个分流面板（表驱动）
  // 每行 = (color, 菱形标签, bold 引导词组[(正文,行数)], 分隔线上方标题, 产物行)
  let CHEM = [Chemical and physical methods for separation of components]
  let PANELS = (
    (TEAL, [Other], (), CHEM, (
      [Plastic case/ binder / separator / PFA components /current],
      [collectors / electrolyte solvent / electrolyte salt],
    )),
    (BLUE, [Cathode], (
      ([*Hydrometallurgy:* inorganic acid leaching / organic acid #linebreak() leaching/ ammonia leaching / bioleaching / solvometallurgy.], 2),
      ([*Pyrometallurgy:* high temperature pyrometallurgy / low #linebreak() temperature pyrolysis / microwave treatments], 2),
      ([*Mechanochemical method:* high energy ball milling], 1),
    ), none, (
      [Li, Co, Ni, Mn in form of oxides and /or salts or regenerated],
      [LCO, LMO, NMC, NCA, LFP],
    )),
    (GRAY, [Anode], (), CHEM, (
      [Graphene/ Lithium salts/ regenerated graphite],
    )),
  )

  // 自上而下堆叠：顶边由上一面板高度 + 间距推导
  let ytop = TOP
  for (col, dl, rows, rt, outs) in PANELS {
    let h = panel-h(rows, rt, outs)
    panel(ytop, h, col, dl, rows, rt, outs)
    ytop -= h + GAP
  }

  // 左列：废电池 → 预处理 → 右列
  waste-circle()
  mag-arrow((LEFT_X, CIRC_CY - CIRC_R), (LEFT_X, BOX_TOP + 0.05))   // 圆 → 预处理框（向下）
  pretreat-box()
  let boxmid = (BOX_TOP + BOX_BOT) / 2
  mag-arrow((BOX_X1, boxmid), (PAN_X0 - 0.15, boxmid))              // 预处理框 → 右列（向右）
})
