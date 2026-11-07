// ============================================================================
// 挖掘机工作装置 · 二维侧视工程简图（源图 Fig.1 重绘）
// 源论文：Joint simulation and experimental verification of
//        electromechanical-hydraulic ... hydraulic excavator
//        (Scientific Reports, 2025)，Fig.1 "Model diagram of the excavator
//        working device"
// 源图为 3D CAD 着色渲染（蓝底、黄色臂架、青色草图基准框与坐标系三轴）。
// 本图改为黑白二维线稿：只用零件轮廓、铰点、液压缸连接关系表达结构；
// 蓝色背景、黄色渐变、草图基准框、坐标三轴全部略去。
// 线宽：臂架轮廓 0.9pt / 缸筒 0.7pt / 活塞杆 0.6pt / 中心线与转角弧 0.6pt。
// 坐标单位：源图 1 单位 = 100 px（已按 x、y 方向的像素位置换算并翻转 y）。
// ============================================================================
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Arial", "Segoe UI"), size: 5pt)

#canvas({
  import draw: *

  // ------------------------- 线宽 / 字体常量 -------------------------
  let LW-MEMBER = 0.9pt  // 臂架（动臂 / 斗杆 / 铲斗）轮廓
  let LW-DETAIL = 0.8pt  // 摇杆、连杆等短杆件
  let LW-CYL = 0.7pt     // 液压缸缸筒（双线）
  let LW-ROD = 0.6pt     // 活塞杆（单线）
  let LW-THIN = 0.6pt    // 中心线、转角弧、剖面线、引出线
  let INK = black
  let FS = 5pt
  let FS-S = 4.4pt

  // ------------------------- 铰点坐标（命名常量）-------------------------
  let A = (0.70, 3.68)    // 动臂根部铰点（底座-动臂）
  let B = (11.00, 7.62)   // 肘铰点（动臂-斗杆）
  let C = (13.02, 2.34)   // 斗铰点（斗杆-铲斗）
  let D = (12.80, 3.13)   // 摇杆铰点（斗杆-摇杆）
  let E = (13.86, 2.14)   // 连杆铰点（连杆-铲斗）
  let F = (0.90, 0.24)    // 底座回转中心
  let P1 = (1.52, 2.60)   // 动臂缸：缸筒端（底座支座）
  let P2 = (3.62, 5.36)   // 动臂缸：活塞杆端（动臂下腹板）
  let P3 = (5.50, 8.02)   // 斗杆缸：缸筒端（动臂顶部凸台）
  let P4 = (10.85, 9.27)  // 斗杆缸：活塞杆端（斗杆耳板）
  let P5 = (12.27, 7.47)  // 铲斗缸：缸筒端（斗杆支座）
  let P6 = (13.93, 3.23)  // 铲斗缸：活塞杆端（摇杆端部）

  // ------------------------- 臂架轮廓（命名常量）-------------------------
  // 动臂：根部 A → 上弦 → 顶部凸台（斗杆缸铰座）→ 肘部铰座 B → 下弦 → A
  let BOOM-OUTLINE = (
    (0.70, 3.68),   // A
    (0.95, 4.05),
    (1.35, 4.58),
    (1.85, 5.18),
    (2.45, 5.82),
    (3.05, 6.36),
    (3.65, 6.80),
    (4.25, 7.14),
    (4.85, 7.46),
    (5.40, 8.10),   // 凸台顶（斗杆缸缸筒铰座）
    (5.62, 7.84),
    (6.60, 7.85),
    (7.80, 7.86),
    (9.00, 7.90),
    (10.05, 7.96),
    (10.55, 8.04),
    (10.86, 7.90),
    (11.02, 7.70),
    (11.04, 7.52),  // 肘部铰座右缘
    (10.86, 7.40),
    (10.20, 7.26),
    (9.20, 7.10),
    (8.00, 6.90),
    (6.80, 6.66),
    (5.80, 6.42),
    (5.00, 6.15),
    (4.20, 5.80),
    (3.50, 5.36),
    (2.90, 4.92),
    (2.30, 4.46),
    (1.70, 4.06),
    (1.15, 3.80),
  )
  // 斗杆：肘部铰点 B 处头部 → 上耳板 P4 / 铲斗缸支座 P5 → 杆身 → 斗铰点 C
  let ARM-OUTLINE = (
    (10.85, 9.27),  // P4 斗杆缸活塞杆端
    (10.66, 8.62),
    (10.58, 8.04),
    (10.72, 7.48),
    (11.02, 6.96),
    (11.42, 6.12),
    (11.78, 5.28),
    (12.06, 4.48),
    (12.30, 3.72),
    (12.46, 3.22),
    (12.56, 2.90),
    (12.70, 2.52),
    (12.86, 2.26),  // 斗铰点 C 的耳孔下缘
    (13.12, 2.18),
    (13.34, 2.34),
    (13.44, 2.66),
    (13.40, 3.02),
    (13.20, 3.62),
    (13.02, 4.30),
    (12.80, 5.10),
    (12.58, 5.90),
    (12.40, 6.64),
    (12.32, 7.18),
    (12.42, 7.36),
    (12.27, 7.47),  // P5 铲斗缸缸筒铰座
    (11.98, 7.76),
    (11.50, 8.28),
    (11.10, 8.82),
  )
  // 铲斗：耳孔 C → 后耳板（连杆铰点 E 处）→ 弧形背板 → 斗底 → 斗刃 → 前腹板
  let BUCKET-OUTLINE = (
    (13.02, 2.34),  // 与斗杆共用斗铰点 C
    (13.30, 2.46),
    (13.54, 2.44),  // 耳板
    (13.72, 2.36),
    (13.96, 2.22),  // 后耳板（连杆铰点 E）
    (14.04, 2.00),
    (14.04, 1.50),  // 背板外鼓
    (13.92, 1.06),
    (13.66, 0.72),  // 斗底后跟
    (13.25, 0.52),
    (12.70, 0.42),
    (12.15, 0.40),
    (11.84, 0.52),  // 斗刃前缘（斗齿）
    (11.82, 0.86),
    (12.00, 1.28),  // 前腹板
    (12.20, 1.62),
    (12.44, 1.90),  // 斗口下唇
    (12.72, 2.16),  // 斗口上唇（回到耳孔）
  )

  // 铲斗斗刃（斗齿布置段）与斗刃加强板的两端
  let BUCKET-EDGE = ((13.20, 0.53), (11.90, 0.47))
  let BUCKET-LIP = ((12.55, 0.56), (11.95, 0.52))

  // ------------------------- 基础向量工具 -------------------------
  let add(p, q) = (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let sub(p, q) = (p.at(0) - q.at(0), p.at(1) - q.at(1))
  let scl(p, k) = (p.at(0) * k, p.at(1) * k)
  let uni(p) = {
    let l = calc.sqrt(p.at(0) * p.at(0) + p.at(1) * p.at(1))
    (p.at(0) / l, p.at(1) / l)
  }
  let nrm(p) = (-p.at(1), p.at(0))
  let mix(p, q, t) = (p.at(0) + (q.at(0) - p.at(0)) * t, p.at(1) + (q.at(1) - p.at(1)) * t)

  // ------------------------- 绘图函数 -------------------------
  // member：臂架多边形（闭合轮廓 + 白底 + 可选剖面线）
  let member(pts, lw: LW-MEMBER, hatch: none) = {
    line(..pts, close: true, fill: white, stroke: (paint: INK, thickness: lw))
    if hatch != none {
      let (h0, h1, n, span) = hatch
      let ax = uni(sub(h1, h0))
      let td = uni(add(scl(ax, 0.75), scl(nrm(ax), 0.66)))
      for i in range(n) {
        let c = mix(h0, h1, (i + 0.5) / n)
        line(sub(c, scl(td, span / 2)), add(c, scl(td, span / 2)), stroke: (paint: INK, thickness: LW-THIN))
      }
    }
  }

  // cylinder：液压缸（缸筒双线、活塞杆单线，缸口导向套表示两段套接）
  // gap 为缸筒端部与铰点之间留出的耳环（clevis）长度
  let cylinder(p0, p1, frac: 0.64, w: 0.16, gap: 0.12) = {
    let ax = uni(sub(p1, p0))
    let nx = nrm(ax)
    let pb = add(p0, scl(ax, gap))  // 缸筒端（与铰点留出耳环）
    let pm = mix(pb, p1, frac)      // 缸筒与活塞杆的分界（导向套位置）
    // 缸筒：白底闭合轮廓（遮挡其后的臂架轮廓），双线表示筒壁
    line(add(pb, scl(nx, w)), add(pm, scl(nx, w)), sub(pm, scl(nx, w)), sub(pb, scl(nx, w)),
      close: true, fill: white, stroke: (paint: INK, thickness: LW-CYL))
    // 耳环颈（销孔到缸底的两条短线）
    line(add(p0, scl(nx, 0.055)), add(pb, scl(nx, w)), stroke: (paint: INK, thickness: LW-CYL))
    line(sub(p0, scl(nx, 0.055)), sub(pb, scl(nx, w)), stroke: (paint: INK, thickness: LW-CYL))
    // 缸口导向套（双短线）
    line(add(pm, scl(nx, w)), sub(pm, scl(nx, w)), stroke: (paint: INK, thickness: LW-CYL))
    line(add(add(pm, scl(nx, w)), scl(ax, 0.09)), add(sub(pm, scl(nx, w)), scl(ax, 0.09)), stroke: (paint: INK, thickness: LW-CYL))
    // 活塞杆：单线，插入缸筒内一小段
    line(add(pm, scl(ax, -0.18)), p1, stroke: (paint: INK, thickness: LW-ROD))
  }

  // pin：铰点销轴（外圈 + 轴心）
  let pin(p, r: 0.115) = {
    circle(p, radius: r, fill: white, stroke: (paint: INK, thickness: 0.8pt))
    circle(p, radius: r * 0.40, fill: INK, stroke: none)
  }

  // link-bar：摇杆 / 连杆（双线短杆件）
  let link-bar(p, q, w: 0.085) = {
    let ax = uni(sub(q, p))
    let nx = nrm(ax)
    line(add(p, scl(nx, w)), add(q, scl(nx, w)), stroke: (paint: INK, thickness: LW-DETAIL))
    line(sub(p, scl(nx, w)), sub(q, scl(nx, w)), stroke: (paint: INK, thickness: LW-DETAIL))
    line(add(p, scl(nx, w)), sub(p, scl(nx, w)), stroke: (paint: INK, thickness: LW-DETAIL))
    line(add(q, scl(nx, w)), sub(q, scl(nx, w)), stroke: (paint: INK, thickness: LW-DETAIL))
  }

  // bucket：铲斗轮廓（闭合壳板 + 斗刃加强筋 + 沿斗刃的斗齿）
  let bucket(pts, edge-a, edge-b, lip: none, n: 4, h: 0.20) = {
    line(..pts, close: true, fill: white, stroke: (paint: INK, thickness: LW-MEMBER))
    // 斗刃加强板（与斗底平行的一条细线）
    if lip != none {
      line(lip.at(0), lip.at(1), stroke: (paint: INK, thickness: LW-THIN))
    }
    let ax = uni(sub(edge-b, edge-a))
    let nx = nrm(ax)  // 指向斗外（下方）
    for i in range(n) {
      let c = mix(edge-a, edge-b, (i + 0.6) / (n + 0.6))
      line(sub(c, scl(ax, 0.07)), add(c, scl(nx, h)), stroke: (paint: INK, thickness: 0.8pt))
      line(add(c, scl(ax, 0.07)), add(c, scl(nx, h)), stroke: (paint: INK, thickness: 0.8pt))
    }
  }

  // dimension-arc：铰点转角弧（cetz 的 arc 以起点定位，故先算出弧的起点）
  let dimension-arc(c, r, a0, a1) = {
    let at(a) = (c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a))
    arc(at(a0), radius: r, start: a0, stop: a1, stroke: (paint: INK, thickness: LW-THIN))
    line(at(a0 + 5deg), at(a0), mark: (end: ">", scale: 0.45), stroke: (paint: INK, thickness: LW-THIN))
    line(at(a1 - 5deg), at(a1), mark: (end: ">", scale: 0.45), stroke: (paint: INK, thickness: LW-THIN))
  }

  // 文字与引出线
  let tag(p, body, size: FS, anchor: "center", angle: 0deg) = content(
    p, anchor: anchor, angle: angle, text(size: size, fill: INK, body),
  )
  let lead(p, q) = line(p, q, stroke: (paint: INK, thickness: LW-THIN))

  // ==========================================================================
  // 底座 / 回转平台
  // ==========================================================================
  // 底盘（履带架上方平台）
  member(((0.20, 0.14), (1.60, 0.14), (1.60, 0.36), (0.20, 0.36)))
  // 底座立柱（回转平台与动臂、动臂缸的支承座）
  member(((0.46, 0.32), (0.46, 3.30), (0.80, 3.30), (1.28, 2.58), (1.28, 0.32)),
    hatch: ((0.60, 0.60), (0.60, 1.25), 2, 0.42))
  // 动臂根部支座（立柱顶部的小凸台，承铰点 A）
  member(((0.54, 3.26), (0.54, 3.74), (0.68, 3.82), (0.88, 3.58), (0.88, 3.26)))
  // 动臂缸铰座（立柱右侧悬臂，承缸筒端 P1）
  member(((1.20, 2.82), (1.56, 2.60), (1.20, 2.40)))
  // 回转中心标记（中心线 + 小圆）
  line((0.62, 0.24), (1.18, 0.24), stroke: (paint: INK, thickness: LW-THIN, dash: "dashed"))
  circle(F, radius: 0.075, stroke: (paint: INK, thickness: LW-THIN))

  // ==========================================================================
  // 动臂（Boom）：A 根部 → 肘部 B，断面加剖面线以示臂架
  // ==========================================================================
  member(BOOM-OUTLINE, hatch: ((6.40, 6.82), (6.40, 7.47), 5, 0.75))
  // 动臂根部铰座凸台（A 处）
  circle(A, radius: 0.30, fill: white, stroke: (paint: INK, thickness: LW-MEMBER))
  // 顶部凸台（斗杆缸缸筒铰座，P3 处）
  circle(P3, radius: 0.20, fill: white, stroke: (paint: INK, thickness: LW-MEMBER))

  // ==========================================================================
  // 动臂液压缸：底座支座 P1 → 动臂下腹板 P2
  // ==========================================================================
  cylinder(P1, P2, frac: 0.58, w: 0.15)

  // ==========================================================================
  // 铲斗（Bucket）：斗铰点 C 悬挂，斗口朝左，斗刃 4 个斗齿
  // ==========================================================================
  bucket(BUCKET-OUTLINE, BUCKET-EDGE.at(0), BUCKET-EDGE.at(1), lip: (BUCKET-LIP.at(0), BUCKET-LIP.at(1)), n: 4, h: 0.20)

  // ==========================================================================
  // 斗杆（Arm）：肘部 B → 斗铰点 C
  // ==========================================================================
  member(ARM-OUTLINE)
  // 斗杆上耳板端部凸台（P4 处）
  circle(P4, radius: 0.20, fill: white, stroke: (paint: INK, thickness: LW-MEMBER))
  // 铲斗缸支座凸台（P5 处）
  circle(P5, radius: 0.23, fill: white, stroke: (paint: INK, thickness: LW-MEMBER))

  // ==========================================================================
  // 斗杆液压缸：动臂凸台 P3 → 斗杆耳板 P4
  // ==========================================================================
  cylinder(P3, P4, frac: 0.66, w: 0.15)

  // ==========================================================================
  // 铲斗液压缸：斗杆支座 P5 → 摇杆端部 P6
  // ==========================================================================
  cylinder(P5, P6, frac: 0.62, w: 0.16, gap: 0.24)

  // ==========================================================================
  // 摇杆（Rocker）：斗杆 D → 摇杆端部 P6
  // ==========================================================================
  link-bar(D, P6, w: 0.085)
  // ==========================================================================
  // 连杆（Connecting rod）：摇杆端部 P6 → 铲斗耳板 E
  // ==========================================================================
  link-bar(P6, E, w: 0.085)

  // ==========================================================================
  // 铰点销轴：A/B/C 主铰点 + D/E 摇杆连杆铰点 + P1…P6 液压缸铰点
  // ==========================================================================
  // 动臂根部销轴 A
  pin(A)
  // 肘部销轴 B（动臂-斗杆）
  pin(B)
  // 斗铰销轴 C（斗杆-铲斗）
  pin(C)
  // 摇杆销轴 D（斗杆-摇杆）
  pin(D, r: 0.10)
  // 连杆销轴 E（连杆-铲斗）
  pin(E, r: 0.10)
  // 动臂缸销轴 P1（底座端）
  pin(P1, r: 0.10)
  // 动臂缸销轴 P2（动臂端）
  pin(P2, r: 0.10)
  // 斗杆缸销轴 P3（动臂端）
  pin(P3, r: 0.10)
  // 斗杆缸销轴 P4（斗杆端）
  pin(P4, r: 0.10)
  // 铲斗缸销轴 P5（斗杆端）
  pin(P5, r: 0.10)
  // 铲斗缸销轴 P6（摇杆端）
  pin(P6, r: 0.095)

  // ==========================================================================
  // 转角弧（各铰点的工作转角范围）
  // ==========================================================================
  // 动臂根部转角弧（A，动臂俯仰角）
  dimension-arc(A, 1.30, 96deg, 176deg)
  // 肘铰点转角弧（B，斗杆相对动臂的摆角）
  dimension-arc(B, 1.20, 245deg, 305deg)

  // ==========================================================================
  // 零件名与铰点编号
  // ==========================================================================
  // 零件名：底座
  tag((0.82, 2.05), [Base], size: FS-S, angle: 90deg)
  // 零件名：动臂
  tag((4.62, 6.58), [Boom], angle: 33deg)
  // 零件名：斗杆
  tag((12.40, 4.95), [Arm], size: FS-S, angle: -70deg)
  // 零件名：铲斗
  tag((13.02, 1.16), [Bucket], size: FS-S)

  // 零件名：动臂缸（引出线指向缸筒）
  tag((2.02, 2.42), [Boom cylinder], size: FS-S, anchor: "west")
  lead((2.44, 2.52), (2.50, 3.80))
  // 零件名：斗杆缸
  tag((7.38, 9.02), [Arm cylinder], size: FS-S, angle: 13deg)
  // 零件名：铲斗缸
  tag((13.94, 5.16), [Bucket cylinder], size: FS-S, angle: -68deg)
  // 零件名：摇杆
  tag((13.06, 4.02), [Rocker], size: FS-S)
  // 零件名：连杆（引出线指向连杆）
  tag((14.12, 2.58), [Link], size: FS-S, angle: 90deg)
  lead((14.05, 2.50), (13.90, 2.40))

  // 铰点编号 A / B / C / D / E
  tag((0.44, 3.34), [A])
  tag((10.24, 6.44), [B])
  lead((10.32, 6.50), (10.92, 7.42))
  tag((12.22, 2.56), [C])
  lead((12.32, 2.52), (12.88, 2.38))
  tag((12.24, 3.34), [D])
  tag((14.12, 2.14), [E], anchor: "west")
  // 回转中心 F
  tag((0.90, 0.02), [F], size: FS-S)
  // 液压缸铰点 P1 … P6
  tag((1.70, 2.30), [P1], size: FS-S)
  tag((3.92, 5.96), [P2], size: FS-S)
  lead((3.84, 5.88), (3.68, 5.44))
  tag((4.98, 8.42), [P3], size: FS-S)
  lead((5.08, 8.36), (5.42, 8.10))
  tag((10.36, 9.54), [P4], size: FS-S)
  lead((10.52, 9.48), (10.80, 9.33))
  tag((12.56, 7.80), [P5], size: FS-S)
  lead((12.48, 7.74), (12.30, 7.53))
  tag((13.60, 3.46), [P6], size: FS-S)
  lead((13.70, 3.40), (13.90, 3.28))
})
