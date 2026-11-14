// 纳米压印光刻（NIL）工艺与受力示意图 —— 三组多面板重绘
// 源图：Review of Industrialization Development of Nanoimprint Lithography
//       Technology（MDPI Chips, 2025）Figure 1 + Figure 2 + Figure 4
//
// 版面自上而下：
//   (a) Figure 1  六步循环工艺，2×3 网格（上排 1→2→3，右侧下行 3→4，
//                 下排 4→5→6，左侧回到 1），红色循环箭头串起六步；
//   (b) Figure 2  (a) 基本结构 (b) 理想状态（UV + 加热） (c) 实际受压状态；
//   (c) Figure 4  (a) 复合 PET/PVA 模板结构 (b) 受压后的内力 / 反力。
//
// 配色：硅胶 / PDMS 浅青、光刻胶黄、基底深蓝、PET/PVA 紫、模板黑、
//       UV 紫色箭头、加热红色波浪、循环 / 面板框红色。
// 线宽：结构线 0.5–0.8pt，引线 0.4pt，力箭头 1.2–2.4pt。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Segoe UI", "Arial"), size: 6.8pt, fill: rgb("#1a1a1a"))

#canvas(length: 1cm, {
  import draw: *

  // 配色与线型
  let INK = rgb("#1a1a1a")      // 结构线 / 文字
  let STAMP = rgb("#141414")    // 母模：黑
  let PDMS = rgb("#8fd3d8")     // 硅胶 / PDMS：浅青
  let RESIST = rgb("#f2e34c")   // 光刻胶：黄
  let SUB = rgb("#2b2b8f")      // 基底：深蓝
  let PET = rgb("#b07cc6")      // PET/PVA 复合薄层：紫
  let UV = rgb("#7b4fb5")       // UV 照射：紫
  let HEAT = rgb("#d9342b")     // 加热：红
  let CYC = rgb("#e2382a")      // 循环箭头：红
  let FRAME = rgb("#e03a2c")    // 面板框：红点线

  let EDGE = (paint: INK, thickness: 0.5pt)   // 块体轮廓
  let LEAD = (paint: INK, thickness: 0.5pt)   // 标签引线

  // 通用助手

  // 统一文字标签：可指定锚点 / 字号 / 颜色 / 背景（压在箭头上的文字要白底）
  let lbl(pos, body, anchor: "center", size: 6.8pt, fill: INK, angle: 0deg, bg: none) = {
    let t = text(size: size, fill: fill, body)
    let inner = if bg == none { t } else { box(fill: bg, inset: 1.2pt, t) }
    content(pos, anchor: anchor, angle: angle, inner)
  }

  // 标签引线：从文字边缘指向被标注的层，末端带小箭头
  let leader(a, b, scale: 0.9) = line(a, b, stroke: LEAD, mark: (end: ">", fill: INK, scale: scale))

  // 带齿模板：底板 + 齿列合成单一闭合轮廓，避免齿根出现接缝线。
  //   dir =  1 齿朝上（Figure 1 第 1 步的黑色母模）；
  //   dir = -1 齿朝下（压印时压在光刻胶上的硅胶模）。
  //   teeth 为齿数，齿宽 = 齿槽宽 = w / (2*teeth - 1)，全图共用同一节距。
  let stamp(x, y, w, h, teeth, dir: 1, ht: 0.55, fill: STAMP) = {
    let t = w / (2 * teeth - 1)
    let ye = if dir > 0 { y + h } else { y }  // 齿所依附的底板边
    let yt = ye + dir * ht                    // 齿顶高度
    let pts = ()
    if dir > 0 {
      pts.push((x + w, y))
      pts.push((x + w, y + h))
    } else {
      pts.push((x + w, y + h))
      pts.push((x + w, y))
    }
    // 自右向左排齿：齿根 → 齿顶 → 齿根，回到两条齿之间的底板边
    for i in range(teeth) {
      let j = teeth - 1 - i
      let xa = x + 2 * t * j
      pts.push((xa + t, ye))
      pts.push((xa + t, yt))
      pts.push((xa, yt))
      pts.push((xa, ye))
    }
    if dir > 0 { pts.push((x, y)) } else { pts.push((x, y + h)) }
    line(..pts, close: true, fill: fill, stroke: EDGE)
  }

  // 齿槽中的光刻胶：与 stamp 同一节距，方块正好落在齿与齿之间
  let gap-blocks(x, y, w, teeth, h, fill: RESIST) = {
    let t = w / (2 * teeth - 1)
    for i in range(teeth - 1) {
      let xa = x + t + 2 * t * i
      rect((xa, y), (xa + t, y + h), fill: fill, stroke: EDGE)
    }
  }

  // 单层薄板；label 非空时写在板右侧（对应源图右侧的文字标注）
  let layer(x, y, w, h, fill, label: none, size: 6.6pt) = {
    rect((x, y), (x + w, y + h), fill: fill, stroke: EDGE)
    if label != none { lbl((x + w + 0.10, y + h / 2), label, anchor: "west", size: size) }
  }

  // 基底 + 光刻胶叠层：(x, y) 为基底左下角，向上依次是基底、光刻胶
  let substrate-stack(x, y, w, base-h: 0.50, resist-h: 0.25) = {
    layer(x, y, w, base-h, SUB)
    if resist-h > 0 { layer(x, y + base-h, w, resist-h, RESIST) }
  }

  // UV 照射：一组紫色竖直箭头，自上而下打到膜面
  let uv-arrows(xs, ytop, ybot) = {
    for x in xs {
      line(
        (x, ytop), (x, ybot),
        stroke: (paint: UV, thickness: 2.0pt),
        mark: (end: ">", fill: UV, scale: 1.2),
      )
    }
  }

  // 加热：三条并排的正弦波浪线，自膜面向上升起（源图为红色弹簧状波浪）
  let heat-waves(cx, ytop, ybot, amp: 0.12, lines: 3, periods: 2.4) = {
    for k in range(lines) {
      let xs = cx + (k - (lines - 1) / 2) * 0.21
      let pts = ()
      for i in range(25) {
        let t = i / 24
        pts.push((xs + amp * calc.sin(2 * calc.pi * periods * t), ytop + (ybot - ytop) * t))
      }
      line(..pts, stroke: (paint: HEAT, thickness: 1.0pt, cap: "round"))
    }
  }

  // 外部压缩：粗黑向下箭头（压头施加的正压力）
  let compression-arrows(xs, ytop, ybot) = {
    for x in xs {
      line(
        (x, ytop), (x, ybot),
        stroke: (paint: INK, thickness: 2.8pt),
        mark: (end: ">", fill: INK, scale: 0.95),
      )
    }
  }

  // 膜内张力：水平双向箭头；画得比膜长，表示张力把膜沿面内拉长
  let tension-arrow(x0, x1, y) = line(
    (x0, y), (x1, y),
    stroke: (paint: INK, thickness: 1.2pt),
    mark: (start: ">", end: ">", fill: INK, scale: 1.0),
  )

  // 受压后的压印膜：齿被压短（只剩齿桩），齿槽内光刻胶被挤到与原齿同高。
  // y 为膜底面（= 齿桩顶端所在高度）。
  let pressed-film(x, y, w, teeth, stub: 0.30, res: 0.28) = {
    let t = w / (2 * teeth - 1)
    for i in range(teeth) {
      let xa = x + 2 * t * i
      rect((xa, y - stub), (xa + t, y), fill: PDMS, stroke: EDGE)
    }
    for i in range(teeth - 1) {
      let xa = x + t + 2 * t * i
      rect((xa, y - res), (xa + t, y), fill: RESIST, stroke: EDGE)
    }
  }

  // 红色循环箭头（可折线）
  let cycle-arrow(pts, w: 1.5pt) = line(
    ..pts,
    stroke: (paint: CYC, thickness: w, cap: "round"),
    mark: (end: ">", fill: CYC, scale: 1.1),
  )

  // 组框：整组图的外框 + 组标号 (a)/(b)/(c) + 一句组名，避免与子面板标号混淆
  let group-frame(x0, y0, x1, y1, tag, title: "") = {
    rect(
      (x0, y0), (x1, y1), radius: 0.42,
      stroke: (paint: FRAME, thickness: 0.8pt, dash: (3.2pt, 2.0pt)),
    )
    lbl((x0 + 0.30, y1 - 0.30), tag, anchor: "west", size: 9.5pt)
    if title != "" { lbl((x0 + 1.05, y1 - 0.31), title, anchor: "west", size: 7.0pt, fill: rgb("#555555")) }
  }

  // 子面板框：沿用源图的红点线圆角框 + 源图 (a)(b)(c) 子标号
  let panel-frame(x0, y0, x1, y1, tag) = {
    rect(
      (x0, y0), (x1, y1), radius: 0.34,
      stroke: (paint: FRAME, thickness: 0.8pt, dash: (1.9pt, 1.7pt)),
    )
    lbl((x0 + 0.26, y1 - 0.26), tag, anchor: "west", size: 7.6pt)
  }

  // (a) Figure 1：六步循环工艺流程
  //     上排：1 母模 → 2 涂硅胶 → 3 揭下硅胶模
  //     下排：6 光刻胶成形 ← 5 硅胶压印 + UV/加热 ← 4 胶 + 基底
  let CX1 = 6.10    // 左列（第 1 / 第 6 步）
  let CX2 = 12.00   // 中列（第 2 / 第 5 步）
  let CX3 = 17.90   // 右列（第 3 / 第 4 步）
  let SW = 3.20     // 模板总宽
  let NT = 5        // 齿数（全图统一节距）
  let ROWA = 16.30  // 上排母模底板下缘
  let RESPLANE = 12.65 // 下排光刻胶底面（= 基底顶面），也等于第 5 步齿顶高度

  group-frame(0.45, 11.15, 23.85, 18.45, [(a)], title: "Process cycle")

  // 第 1 步：黑色母模，齿朝上；这一步只是把图形化基板摆好
  stamp(CX1 - SW / 2, ROWA, SW, 0.50, NT, dir: 1, ht: 0.40)
  lbl((CX1, 15.90), [Imprinting graphic substrate], size: 6.6pt)

  // 第 2 步：把硅胶浇在母模上（齿被胶包住），等待固化
  stamp(CX2 - SW / 2, ROWA, SW, 0.50, NT, dir: 1, ht: 0.40)
  layer(CX2 - SW / 2 - 0.06, 16.80, SW + 0.12, 0.62, PDMS)
  lbl((CX2 - 0.10, 18.02), [silica gel], size: 6.6pt)
  // 两个细箭头从标签指向硅胶上表面（源图画法）
  line((CX2 - 0.42, 17.94), (CX2 - 0.85, 17.44), stroke: LEAD, mark: (end: ">", fill: INK, scale: 0.9))
  line((CX2 + 0.28, 17.94), (CX2 + 0.85, 17.44), stroke: LEAD, mark: (end: ">", fill: INK, scale: 0.9))
  lbl((CX2, 15.90), [Disperse silicone onto the], size: 6.6pt)
  lbl((CX2, 15.63), [substrate for curing], size: 6.6pt)

  // 第 3 步：揭下硅胶 —— 浅青齿片悬在母模上方，齿形与母模互补
  stamp(CX3 - SW / 2, ROWA, SW, 0.50, NT, dir: 1, ht: 0.40)
  stamp(CX3 - SW / 2, 17.88, SW, 0.34, NT, dir: -1, ht: 0.40, fill: PDMS)
  lbl((CX3, 15.90), [Silicone peeling], size: 6.6pt)

  // 第 4 步：光刻胶旋涂在基底上（黄薄层 + 深蓝基底）；
  //      胶层/基底的英文名直接写在板右侧，与源图"photoresist / substrate"一致 ----
  layer(CX3 - 1.70, 12.15, 3.40, 0.50, SUB, label: [substrate], size: 6.6pt)
  layer(CX3 - 1.70, 12.65, 3.40, 0.25, RESIST, label: [photoresist], size: 6.6pt)

  // 第 5 步：硅胶模压下来，齿间空腔被光刻胶填满，UV + 加热固化
  stamp(CX2 - SW / 2, 13.20, SW, 0.50, NT, dir: -1, ht: 0.55, fill: PDMS)
  gap-blocks(CX2 - SW / 2, RESPLANE, SW, NT, 0.55)
  // UV 从上方照到膜面（左右两组），加热从中间作用在膜上
  uv-arrows((CX2 - 1.35, CX2 - 0.65, CX2 + 1.35), 14.55, 13.72)
  heat-waves(CX2 + 0.35, 14.78, 13.72)
  lbl((CX2 - 2.05, 14.98), [UV irradiation], size: 6.6pt)
  lbl((CX2 + 1.02, 15.02), [heat], size: 6.6pt)
  lbl((CX2, 11.62), [Formed silicone embossing], size: 6.6pt)

  // 第 6 步：脱模后留下的光刻胶凸起（位置正是第 5 步的齿槽）
  layer(CX1 - 1.70, 12.15, 3.40, 0.50, SUB)
  gap-blocks(CX1 - 1.70, RESPLANE, 3.40, NT, 0.25)
  lbl((CX1, 11.62), [Photoresist embossing], size: 6.6pt)
  lbl((CX1, 11.36), [molding], size: 6.6pt)

  // 红色循环箭头：1→2→3→4→5→6→1，顺时针闭合
  cycle-arrow(((8.05, 16.55), (10.25, 16.55)))                 // 1 → 2
  cycle-arrow(((13.70, 16.55), (16.15, 16.55)))                // 2 → 3
  cycle-arrow(((18.55, 15.45), (18.55, 13.35)))                // 3 → 4（下行）
  cycle-arrow(((16.05, 13.40), (13.90, 13.40)))                // 4 → 5
  cycle-arrow(((10.25, 12.86), (7.98, 12.86)))                 // 5 → 6
  cycle-arrow(((4.35, 12.86), (3.10, 12.86), (3.10, 16.55), (4.35, 16.55))) // 6 → 1

  // (b) Figure 2：基本结构 / 理想状态 / 实际受压状态
  group-frame(0.45, 5.60, 23.85, 11.00, [(b)], title: "Working states")
  panel-frame(0.70, 5.80, 8.15, 10.45, [(a)])
  panel-frame(8.40, 5.80, 15.85, 10.45, [(b)])
  panel-frame(16.10, 5.80, 23.60, 10.45, [(c)])

  // 2(a) 基本结构：PDMS 齿模 + 光刻胶 + 基底，齿尖与胶面之间留一点间隙
  let AX = 4.85
  stamp(AX - 1.65, 9.38, 3.30, 0.45, NT, dir: -1, ht: 0.40, fill: PDMS) // 齿 8.98–9.38
  substrate-stack(AX - 1.75, 8.05, 3.50, base-h: 0.60, resist-h: 0.24)  // 基底 8.05–8.65 + 胶 8.65–8.89
  lbl((1.00, 9.62), [PDMS], anchor: "west")
  leader((1.62, 9.58), (3.20, 9.50))
  lbl((1.00, 8.87), [Photoresist], anchor: "west")
  leader((2.50, 8.85), (3.12, 8.87))
  lbl((1.55, 7.80), [Substrate], anchor: "west")
  leader((2.32, 7.92), (3.14, 8.30))

  // 2(b) 理想状态：齿槽被胶填满，只有 UV 自上而下 + 加热，没有压头施加外力，
  //      所以硅胶齿保持完整、膜厚不变 ----
  let BX = 12.10
  layer(BX - 1.75, 8.05, 3.50, 0.60, SUB)                                // 基底 8.05–8.65
  gap-blocks(BX - 1.65, 8.65, 3.30, NT, 0.40)                           // 齿槽内的胶 8.65–9.05
  stamp(BX - 1.65, 9.05, 3.30, 0.45, NT, dir: -1, ht: 0.40, fill: PDMS)  // 硅胶模 9.05–9.50
  uv-arrows((BX - 1.30, BX - 0.45, BX + 1.35), 10.08, 9.54)
  heat-waves(BX + 0.40, 10.10, 9.54)
  lbl((9.55, 10.24), [UV Irradiation], anchor: "west")
  lbl((12.60, 10.26), [Heating], anchor: "west")
  lbl((BX, 6.40), [Ideal State], size: 7.4pt)

  // 2(c) 实际受压状态：压头往下压（垂直向下的粗箭头），
  //      硅胶齿被压短变平，膜沿面内被拉长，因此画水平双向箭头表示"向内拉着膜"的张力 ----
  let CX = 19.85
  layer(CX - 2.00, 8.05, 4.00, 0.65, SUB)                                // 基底 8.05–8.70
  pressed-film(CX - 1.90, 9.00, 4.00, NT, stub: 0.30, res: 0.28)         // 齿桩 + 被挤起的胶
  layer(CX - 2.10, 9.00, 4.20, 0.30, PDMS)                               // 压扁后的膜 9.00–9.30
  // 面内张力：箭头伸出膜两端，表示膜被横向拉长
  tension-arrow(CX - 2.65, CX + 2.65, 9.15)
  lbl((CX, 9.15), [Internal Tension of Imprinting Film], size: 5.8pt, bg: white)
  compression-arrows((CX - 1.50, CX, CX + 1.50), 10.02, 9.35)
  lbl((CX, 10.24), [External Compression], size: 6.6pt)
  lbl((CX, 6.40), [Actual Work Situation], size: 7.4pt)

  // (c) Figure 4：复合 PET/PVA 模板的结构与受力
  group-frame(0.45, 0.30, 23.85, 5.40, [(c)], title: "Composite mold and forces")
  panel-frame(0.70, 0.50, 11.70, 4.85, [(a)])
  panel-frame(11.90, 0.50, 23.60, 4.85, [(b)])

  // 4(a) 结构：PDMS 中夹一层 PET/PVA 薄层，下方才是光刻胶与目标基底
  let DX = 3.40
  // 带齿 PDMS 本体：齿朝下，上层 0.60 厚；齿与底板一次成形，齿根没有接缝
  stamp(DX, 3.42, 5.20, 0.60, NT, dir: -1, ht: 0.40, fill: PDMS)
  layer(DX, 3.70, 5.20, 0.08, PET)                       // PET/PVA 夹层
  layer(DX, 2.40, 5.20, 0.22, RESIST)                    // 光刻胶
  layer(DX, 1.85, 5.20, 0.55, SUB)                       // 目标基底
  lbl((6.00, 4.30), [PDMS], size: 7.0pt)
  lbl((9.05, 4.38), [PET/PVA], anchor: "west", size: 7.0pt)
  leader((9.00, 4.28), (8.28, 3.76))
  lbl((6.55, 2.82), [PDMS], anchor: "west")
  lbl((0.95, 2.95), [Photoresist], anchor: "west")
  leader((2.28, 2.90), (3.40, 2.52))
  lbl((6.00, 1.55), [Target Substrate], size: 7.0pt)

  // 4(b) 受力：外部压缩自上而下压在复合膜上；PDMS 保护区被两侧拉伸（水平双向箭头）；
  //      PET/PVA 夹层被压后弹性回顶，所以反作用力箭头从下往上指向齿底界面 ----
  let EX = 14.35
  layer(EX, 2.76, 6.50, 0.64, SUB)                          // 目标基底 2.76–3.40
  pressed-film(EX, 3.70, 6.50, NT, stub: 0.30, res: 0.28)   // 齿桩 + 被挤起的胶
  layer(13.90, 3.70, 7.40, 0.28, PDMS)                      // 压扁后的复合膜 3.70–3.98
  tension-arrow(13.25, 21.95, 3.84)
  lbl((17.65, 3.84), [Internal tension within PDMS protected area], size: 5.8pt, bg: white)
  compression-arrows((14.70, 17.45, 20.20), 4.46, 3.98)
  lbl((17.75, 4.68), [External Compression], size: 6.6pt)
  lbl((17.65, 2.32), [PET/PVA Reaction Force], size: 6.6pt)
  // 反作用力：PET/PVA 被齿压缩后向上顶，箭头从标签指向齿下的界面
  line((16.60, 2.50), (16.15, 3.38), stroke: LEAD, mark: (end: ">", fill: INK, scale: 0.9))
  line((18.70, 2.50), (19.05, 3.38), stroke: LEAD, mark: (end: ">", fill: INK, scale: 0.9))
})
