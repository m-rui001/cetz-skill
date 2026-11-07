// ============================================================================
// 三相并网变流器：功率级 + 双模式（GFL / GFM）控制 + 小信号阻抗模型
// 源图：How Many Grid-Forming Converters Do We Need? A Perspective From
//       Small Signal Stability（IEEE Trans. Power Systems, 2024）
//       Fig. 1（上半 = (a) 功率级与控制框图）+ Fig. 2（下半 = (b) 阻抗模型）
//
// 版面（坐标系：cm，y 轴向上，原点在画布左下角）
//   (a)-功率级  黑虚线框：三相桥 ─ U*abc ─ L_F ─ 节点 V_abc ─ C_F 接地 ─ L_g ─ AC Grid
//   (a)-控制级  蓝虚线框：PWM / abc-dq 变换 / 功率计算 / PLL / 电流环
//                          + GFL 蓝区（PI_PLL, PI_PC, PI_VC）
//                          + GFM 橙区（fP, -PI_VC×2, 电流前馈）
//                          三个双掷"模式开关"决定走 GFL 还是 GFM 支路
//   (b)-阻抗模型：理想电压源 + Z_GFL/Z_GFM + Z_g 串到 AC grid，标出节点电压与注入电流
//
// 布局全部走网格：COL("列名") / ROW("行名")，改一处即可整体错位或缩放。
// ============================================================================
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Times New Roman", "DejaVu Serif"), size: 8pt)

#canvas({
  import draw: *

  // ======================= 0. 配色与线宽 =======================
  let INK = rgb("#1a1a1a")     // 信号线 / 方块边框 / 通用文字
  let BLUE = rgb("#1f77b4")    // GFL（跟网）支路
  let ORANGE = rgb("#e07b00")  // GFM（构网）支路
  let RED = rgb("#c0392b")     // PLL / 模式 1 / 模式开关
  let GREEN = rgb("#2e8b57")   // fP(s) 有功-频率下垂支路
  let PURPLE = rgb("#7d3c98")  // 导纳 / 阻抗（admittance, impedance）
  let GRAY = rgb("#8a8a8a")    // 控制框内侧浅灰边框
  let PANEL = rgb("#f2f2f2")   // GFL / GFM 区底色

  let LW = 0.8pt   // 信号线
  let TW = 0.6pt   // 方块细边框 / 器件符号

  // ======================= 1. 通用绘图函数 =======================

  // 文字：pos 处放一段文字，anchor 决定挂在点的哪一侧
  let txt(pos, body, size: 7.5pt, fill: INK, anchor: "center", weight: "regular") = content(
    pos, anchor: anchor, text(size: size, fill: fill, weight: weight, body),
  )

  // 方块：中心 (x,y)，宽 w，高 h，标签居中（PI 框用彩色边框区分 GFL/GFM）
  let block(x, y, w, h, body, fill: white, edge: INK, thick: TW, radius: 0.02, size: 8pt) = {
    rect((x - w / 2, y - h / 2), (x + w / 2, y + h / 2),
      radius: radius, fill: fill, stroke: (paint: edge, thickness: thick))
    content((x, y), anchor: "center", text(size: size, fill: INK, body))
  }

  // 求和点：小圆 + 圆圈内侧的 "+/-" 号；signs 为 ((dx, dy, 符号), ...)
  let sum-junction(x, y, signs: (), r: 0.21, size: 6pt) = {
    circle((x, y), radius: r, fill: white, stroke: (paint: INK, thickness: 0.85pt))
    for (dx, dy, s) in signs {
      content((x + dx, y + dy), anchor: "center", text(size: size, fill: INK, s))
    }
  }

  // 模式开关：转轴 (x,y) 接支路输出，1 号端子在右上、2 号端子在右下
  // 端子画空心圈 —— 空心 = 可切换触点，实心点 = 固定连接
  let switch(x, y) = {
    let (tx, ty1, ty2) = (x + 0.55, y + 0.45, y - 0.75)
    line((x, y), (tx, ty1), stroke: (paint: RED, thickness: 1.2pt))
    circle((x, y), radius: 0.055, fill: white, stroke: (paint: RED, thickness: 1.1pt))
    circle((tx, ty1), radius: 0.075, fill: white, stroke: (paint: RED, thickness: 1.1pt))
    circle((tx, ty2), radius: 0.075, fill: white, stroke: (paint: RED, thickness: 1.1pt))
    // 编号挂在端子左侧，避免相邻两个开关的"1""2"上下叠在一起
    txt((tx - 0.20, ty1), [1], size: 9pt, fill: RED, weight: "bold", anchor: "east")
    txt((tx - 0.20, ty2), [2], size: 9pt, fill: RED, weight: "bold", anchor: "east")
  }

  // PI 控制器方块：白底 + 彩色边框（GFL 蓝 / GFM 橙 / PLL 红）
  let pi-block(x, y, w, h, body, color, size: 8.5pt) = block(
    x, y, w, h, body, edge: color, thick: 1.0pt, size: size,
  )

  // 正交折线 + 单端箭头（arrow: "end" 表示箭头在末点、指向行进方向）
  let arrow-path(points, color: INK, w: LW, arrow: "end", dash: none) = line(
    ..points,
    stroke: (paint: color, thickness: w, dash: dash),
    mark: if arrow == "end" { (end: ">", fill: color) } else if arrow == "start" {
      (start: ">", fill: color)
    } else { none },
  )

  // 水平信号线：xa → xb；hops 列出的 x 处画半圆跨线（"跨过但不连接"）
  let wire(y, xa, xb, hops: (), color: INK, w: LW, arrow: "start", dash: none) = {
    let hr = 0.11
    let segs = ()
    let cur = xa
    for h in hops {
      segs.push((cur, h - hr))
      cur = h + hr
    }
    segs.push((cur, xb))
    for (i, s) in segs.enumerate() {
      let m = if arrow == "start" and i == 0 { (start: ">", fill: color) } else if arrow == "end" and i == segs.len() - 1 {
        (end: ">", fill: color)
      } else { none }
      line((s.at(0), y), (s.at(1), y), stroke: (paint: color, thickness: w, dash: dash), mark: m)
    }
    for h in hops {
      arc((h, y), start: 0deg, stop: 180deg, radius: hr, stroke: (paint: color, thickness: w))
    }
  }

  // 固定连接点（实心小圆）：只画在真正的连接处，交叉处不画
  let node(pos, r: 0.055, color: INK) = circle(pos, radius: r, fill: color, stroke: none)

  // 虚线区域框
  let dashed-region(x0, y0, x1, y1, color: INK, radius: 0.25) = rect(
    (x0, y0), (x1, y1), radius: radius, fill: none,
    stroke: (paint: color, thickness: 1.0pt, dash: (3.2pt, 2.0pt)),
  )

  // 电感（线圈）：x0..x1 之间 n 个上半圆
  let coil(x0, x1, y, n: 4, color: INK, w: 0.9pt) = {
    let r = (x1 - x0) / (2 * n)
    for i in range(n) {
      arc((x0 + r * (2 * i + 1), y), start: 0deg, stop: 180deg, radius: r,
        stroke: (paint: color, thickness: w))
    }
  }

  // 正弦圆：AC Grid / 理想电压源
  let ac-source(cx, cy, r) = {
    circle((cx, cy), radius: r, fill: white, stroke: (paint: INK, thickness: 0.95pt))
    let pts = ()
    for i in range(0, 25) {
      let t = i / 24
      pts.push((cx - r * 0.54 + t * r * 1.08, cy + r * 0.32 * calc.sin(t * 360deg)))
    }
    line(..pts, stroke: (paint: INK, thickness: 0.8pt))
  }

  // 三相桥（单桥臂 IGBT + 反并联二极管）：DC+/DC− 短母线、栅极、集电极/发射极，
  // 相位输出从桥臂中点向右引到方框边
  let igbt-leg(cx, cy) = {
    let g = cx - 0.34
    line((g, cy - 0.26), (g, cy + 0.26), stroke: (paint: INK, thickness: 1.0pt))  // 栅极条
    line((cx - 0.86, cy), (g, cy), stroke: (paint: INK, thickness: TW))            // 栅极引线
    line((g + 0.12, cy - 0.30), (g + 0.12, cy + 0.30), stroke: (paint: INK, thickness: TW))
    line((g + 0.12, cy + 0.17), (cx + 0.02, cy + 0.17), (cx + 0.02, cy + 0.50),
      stroke: (paint: INK, thickness: TW))                                        // 集电极
    line((g + 0.12, cy - 0.17), (cx + 0.02, cy - 0.17), (cx + 0.02, cy - 0.50),
      stroke: (paint: INK, thickness: TW))                                        // 发射极
    line((cx - 0.02, cy - 0.17), (cx - 0.20, cy - 0.17),
      stroke: (paint: INK, thickness: 0.55pt), mark: (end: ">", fill: INK, scale: 0.7))
    line((cx + 0.44, cy - 0.50), (cx + 0.44, cy + 0.50), stroke: (paint: INK, thickness: TW))
    line((cx + 0.32, cy - 0.36), (cx + 0.56, cy - 0.36), (cx + 0.44, cy - 0.14),
      close: true, fill: white, stroke: (paint: INK, thickness: 0.55pt))           // 二极管
    line((cx + 0.32, cy - 0.14), (cx + 0.56, cy - 0.14), stroke: (paint: INK, thickness: TW))
    line((cx - 0.40, cy + 0.50), (cx + 0.44, cy + 0.50), stroke: (paint: INK, thickness: TW))
    line((cx - 0.40, cy - 0.50), (cx + 0.44, cy - 0.50), stroke: (paint: INK, thickness: TW))
    line((cx + 0.02, cy), (cx + 0.86, cy), stroke: (paint: INK, thickness: TW))
  }

  // ======================= 2. 网格 =======================
  // 列：所有方块边、竖线、信号名都取这里的值
  let GX = (
    frame_l: 0.6, frame_r: 26.3,
    pwm: 1.65, trf_l: 0.95, trf_r: 2.35,
    conv_l: 2.0, conv_r: 3.7,
    bar: 4.55, ccl_l: 4.0, ccl_r: 13.4,
    sum: 5.95, wl_l: 6.7, wl_r: 7.9,
    filt_l: 7.0, filt_r: 9.1, pi_l: 7.2, pi_r: 8.9, sum2: 10.2,
    big_l: 6.5, big_r: 11.0, theta: 5.2,
    pcalc_l: 15.6, pcalc_r: 18.6,
    sw: 14.4, swt: 14.95, ff_l: 13.25, ff_r: 14.7,
    gfm_l: 15.0, gfm_r: 22.9, iqsum: 15.35, idsum: 15.9, green: 16.3,
    gfl_l: 16.8, gfl_r: 21.9, pil_l: 18.1, pil_r: 20.6,
    fp_l: 17.4, fp_r: 19.6, vc_l: 18.0, vc_r: 20.4,
    nvd: 21.0, nvq: 22.2, ngp: 21.5, gsum: 23.3, sig: 25.2,
  )
  // 行：从下往上；(b) 阻抗模型在最下，(a) 功率级在最上
  let GY = (
    b_top: 4.0, b_bot: 1.55, b_src: 2.6,
    pw: 17.9,
    c_top: 16.1, c_bot: 5.75,
    pwm: 15.58, trf: 14.5, big: 14.8, pcalc: 14.85, trf_out: 13.9,
    pll: 13.3, domega: 12.85, pc: 11.45, vc: 9.45,
    c_d: 11.0, c_q: 9.0, ccl_top: 12.32, ccl_bot: 8.05,
    filt_d: 11.66, filt_q: 8.36, wl_u: 10.38, wl_q: 9.63,
    fp: 8.25, idsum: 7.78, vc_up: 7.33, iqsum: 6.88, vc_dn: 6.43,
    gfm_top: 8.5, gfm_bot: 5.8,
  )
  let COL(i) = GX.at(i)
  let ROW(j) = GY.at(j)

  // ======================= 3. 两个大虚线框 =======================
  // Power Part：功率级（器件 + 无源滤波 + 电网），黑虚线
  dashed-region(COL("frame_l"), 16.4, COL("frame_r"), 18.7)
  txt((COL("frame_r") - 0.35, 16.9), [Power Part], size: 9.5pt, anchor: "east")
  // Control Part：全部控制逻辑，蓝虚线（与 GFL 同色，呼应"跟网控制"）
  dashed-region(COL("frame_l"), ROW("c_bot"), COL("frame_r"), ROW("c_top"), color: BLUE)
  txt((COL("frame_r") - 0.35, ROW("c_top") - 0.32), [Control Part], size: 9.5pt,
    fill: BLUE, anchor: "east")
  txt((COL("frame_l") + 0.2, 18.42), [(a)], size: 9pt, anchor: "west", weight: "bold")
  txt((COL("frame_l") + 0.2, 5.1), [(b)], size: 9pt, anchor: "west", weight: "bold")

  // ==========================================================================
  // 4. (a) 功率级（Power Part）
  //    这一路是能量通道：直流侧经三相桥逆变成交流，L_F/C_F 滤波后经 L_g 并入电网。
  //    U*abc 是调制波（来自控制级的 PWM），Iabc/Uabc 是并网点量（回送控制级）。
  // ==========================================================================
  let PWR = ROW("pw")

  // 三相桥（圆角方框 + 单桥臂符号）
  block(2.85, PWR, 1.7, 1.15, [], edge: INK, thick: 0.95pt, radius: 0.2)
  igbt-leg(2.85, PWR)
  txt((2.85, 17.1), [Three-phase], size: 7.5pt)
  txt((2.85, 16.85), [Converter], size: 7.5pt)

  // 桥输出 → 滤波电感：U*abc 与 I_Cabc 标在导体上（箭头指示电流正方向）
  line((COL("conv_r"), PWR), (5.15, PWR), stroke: (paint: INK, thickness: LW))
  node((4.05, PWR))
  txt((3.72, PWR + 0.28), $U^*_"abc"$, size: 8.5pt, anchor: "west")
  arrow-path(((4.55, PWR + 0.13), (5.0, PWR + 0.13)), w: 0.9pt, arrow: "end")
  txt((5.35, PWR + 0.30), $bold(I)_"Cabc"$, size: 8pt)
  coil(5.15, 6.15, PWR, n: 4)
  txt((5.65, PWR - 0.32), $L_F$, size: 8.5pt)

  // 滤波电容节点 V_abc：C_F 对地
  line((6.15, PWR), (6.75, PWR), stroke: (paint: INK, thickness: LW))
  node((6.75, PWR))
  txt((6.58, PWR + 0.28), $bold(V)_"abc"$, size: 8.5pt)
  line((6.75, PWR), (6.75, 17.55), stroke: (paint: INK, thickness: LW))
  line((6.49, 17.55), (7.01, 17.55), stroke: (paint: INK, thickness: 1.3pt))  // 电容上极板
  line((6.49, 17.39), (7.01, 17.39), stroke: (paint: INK, thickness: 1.3pt))  // 电容下极板
  line((6.75, 17.39), (6.75, 17.1), stroke: (paint: INK, thickness: LW))
  line((6.53, 17.1), (6.97, 17.1), stroke: (paint: INK, thickness: 0.9pt))    // 接地符号
  line((6.61, 17.0), (6.89, 17.0), stroke: (paint: INK, thickness: 0.9pt))
  line((6.69, 16.9), (6.81, 16.9), stroke: (paint: INK, thickness: 0.9pt))
  txt((7.1, 17.47), $C_F$, size: 8.5pt, anchor: "west")

  // 并网点 → 电网阻抗 L_g → AC Grid
  line((6.75, PWR), (10.4, PWR), stroke: (paint: INK, thickness: LW))
  arrow-path(((10.5, PWR + 0.13), (11.05, PWR + 0.13)), w: 0.9pt, arrow: "end")
  txt((10.78, PWR + 0.30), $bold(I)_"abc"$, size: 8pt)
  coil(11.2, 12.2, PWR, n: 4)
  txt((11.7, PWR - 0.32), $L_g$, size: 8.5pt)
  line((12.2, PWR), (22.68, PWR), stroke: (paint: INK, thickness: LW))
  txt((12.92, PWR + 0.28), $bold(U)_"abc"$, size: 8.5pt, anchor: "west")
  ac-source(23.3, PWR, 0.62)
  txt((23.3, 16.98), [AC Grid], size: 8.5pt)

  // 紫色标注：变流器在工作点线性化后的端口导纳（(b) 就是它的电路化表示）
  txt((12.9, 17.55), [Admittance model], size: 8.5pt, fill: PURPLE, anchor: "west")
  txt((12.9, 17.25), [GFL control: ], size: 8.5pt, fill: PURPLE, anchor: "west")
  txt((14.98, 17.25), $bold(Y)_"GFL"(s)$, size: 8.5pt, fill: PURPLE, anchor: "west")
  txt((12.9, 16.95), [GFM control: ], size: 8.5pt, fill: PURPLE, anchor: "west")
  txt((14.98, 16.95), $bold(Y)_"GFM"(s)$, size: 8.5pt, fill: PURPLE, anchor: "west")
  // 紫色虚线箭头指向"导纳"所描述的那段线路
  bezier((17.1, 16.82), (17.5, 17.75), (18.3, 17.95), (18.72, 17.66),
    stroke: (paint: PURPLE, thickness: 1.0pt, dash: (3pt, 2pt)),
    mark: (end: ">", fill: PURPLE))

  // ==========================================================================
  // 5. (a) 控制级公共部分：PWM、dq 变换、功率计算
  // ==========================================================================

  // ---- 5.1 PWM：把 dq 电压指令还原成三相调制波送回功率级 ----
  // 这是"控制级 → 功率级"的唯一通道，向上穿出控制框
  block(COL("pwm"), ROW("pwm"), 1.2, 0.45, [PWM], size: 8.5pt)
  arrow-path(((COL("pwm"), ROW("pwm") + 0.225), (COL("pwm"), PWR), (COL("conv_l"), PWR)),
    arrow: "end")

  // ---- 5.2 小 abc/dq：dq 电压指令 → abc（反变换），两个输入是 θ 与 U*dq ----
  rect((COL("trf_l"), 14.05), (COL("trf_r"), 14.95), fill: white,
    stroke: (paint: INK, thickness: 0.95pt))
  line((COL("trf_l"), 14.05), (COL("trf_r"), 14.95), stroke: (paint: INK, thickness: TW))
  txt((COL("trf_l") + 0.10, 14.85), [abc], size: 8pt, anchor: "north-west")
  txt((COL("trf_r") - 0.10, 14.15), [dq], size: 8pt, anchor: "south-east")
  arrow-path(((COL("pwm"), 14.95), (COL("pwm"), ROW("pwm") - 0.225)), arrow: "end")

  // ---- 5.3 大 abc/dq：采样量 → dq（正变换），输出六个 dq 量给各环路 ----
  rect((COL("big_l"), 14.3), (COL("big_r"), 15.3), fill: white,
    stroke: (paint: INK, thickness: 0.95pt))
  line((COL("big_l"), 14.3), (COL("big_r"), 15.3), stroke: (paint: INK, thickness: TW))
  txt((COL("big_l") + 0.12, 15.2), [abc], size: 8.5pt, anchor: "north-west")
  txt((COL("big_r") - 0.12, 14.4), [dq], size: 8.5pt, anchor: "south-east")
  for (x, lab) in ((6.9, $bold(I)_"Cabc"$), (8.0, $bold(V)_"abc"$), (9.1, $bold(I)_"abc"$)) {
    arrow-path(((x, 15.62), (x, 15.3)), arrow: "end")
    txt((x, 15.76), lab, size: 8pt)
  }
  for (x, lab) in ((6.75, $I_"Cd"$), (7.53, $I_"Cq"$), (8.31, $V_d$), (9.09, $V_q$),
    (9.87, $I_d$), (10.65, $I_q$)) {
    arrow-path(((x, 14.3), (x, 14.07)), arrow: "end")
    txt((x, ROW("trf_out")), lab, size: 8pt)
  }

  // ---- 5.4 功率计算：由三相电压电流算 PE、QE ----
  block(17.1, ROW("pcalc"), 3.0, 0.8, [])
  txt((17.1, ROW("pcalc") + 0.13), [Power], size: 8pt)
  txt((17.1, ROW("pcalc") - 0.13), [Calculation], size: 8pt)
  for (y, lab) in ((15.0, $bold(V)_"abc"$), (14.7, $bold(I)_"Cabc"$)) {
    txt((14.88, y), lab, size: 8pt, anchor: "east")
    arrow-path(((14.95, y), (COL("pcalc_l"), y)), arrow: "end")
  }
  for (y, lab) in ((15.0, $P_E$), (14.7, $Q_E$)) {
    arrow-path(((COL("pcalc_r"), y), (19.2, y)), arrow: "end")
    txt((19.28, y), lab, size: 8.5pt, anchor: "west")
  }

  // ==========================================================================
  // 6. PLL 支路（红）：Vq → PI_PLL → Δω → (加 ω0) → 1/s → θ
  //    θ 同时送给两个 dq 变换：GFL 模式下 PLL 锁住电网相位，整条控制都建在这个坐标上；
  //    GFM 模式下开关切到 2，θ 改由 fP(s) 的有功-频率下垂给出（机组自己"造"频率）。
  // ==========================================================================
  // GFL 区浅灰底（PI_PLL / PI_PC / PI_VC 三个环路都放在这一块里）
  rect((COL("gfl_l"), 8.75), (COL("gfl_r"), 13.6), radius: 0.25, fill: PANEL, stroke: none)
  txt((COL("gfl_l") + 0.35, 12.72), [Grid-following], size: 9pt, fill: BLUE,
    anchor: "west", weight: "bold")
  txt((COL("gfl_l") + 0.35, 12.36), [loop connection], size: 9pt, fill: BLUE,
    anchor: "west", weight: "bold")

  // Vq 取样线（红字 Vq、蓝线）：节点处同时引一路给 GFM 的电压环
  wire(ROW("pll"), COL("pil_r"), COL("sig"), arrow: "start", color: BLUE)
  txt((COL("sig") + 0.06, ROW("pll")), $V_q$, size: 9pt, fill: RED, anchor: "west")
  node((COL("nvq"), ROW("pll")), color: ORANGE)

  // PI_PLL：把 Vq 调零 —— "跟网"就是电压矢量相位由电网决定
  pi-block(19.35, ROW("pll"), 2.5, 0.4, $"PI"_"PLL"(s)$, RED)
  wire(ROW("pll"), COL("swt"), COL("pil_l"), color: BLUE, arrow: "start")

  // 模式开关 1：GFL(1) ↔ GFM(2)
  switch(COL("sw"), ROW("domega"))
  wire(ROW("domega"), 10.31, COL("sw"), color: RED, arrow: "start")
  txt((12.2, ROW("domega") + 0.24), $Δ ω$, size: 9pt, fill: RED)
  txt((13.95, 11.86), [mode], size: 7.5pt, fill: RED)
  txt((13.95, 11.62), [switch], size: 7.5pt, fill: RED)

  // ω0 + Δω 相加 → 积分成角度 θ
  sum-junction(10.1, ROW("domega"), signs: ((0.045, 0.085, "+"), (-0.045, -0.085, "+")))
  arrow-path(((10.1, 12.42), (10.1, ROW("domega") - 0.19)), arrow: "end")
  txt((9.96, 12.52), $ω_0$, size: 8.5pt, anchor: "east")
  block(8.7, ROW("domega"), 0.8, 0.4, $1/s$, size: 9pt)
  arrow-path(((9.91, ROW("domega")), (9.11, ROW("domega"))), arrow: "end")
  // θ 一路送小 abc/dq（反变换）、一路送大 abc/dq（正变换），两条用同一角度
  line((8.3, ROW("domega")), (COL("theta"), ROW("domega")), (COL("theta"), ROW("big")),
    stroke: (paint: INK, thickness: LW))
  txt((7.95, ROW("domega") + 0.26), $θ$, size: 9pt, anchor: "east")
  arrow-path(((COL("theta"), ROW("trf")), (COL("trf_r"), ROW("trf"))), arrow: "end")
  arrow-path(((COL("theta"), ROW("big")), (COL("big_l"), ROW("big"))), arrow: "end")

  // ==========================================================================
  // 7. 电流环（Current Control Loop，灰框）
  //    d/q 两路对称：Id_ref/Iq_ref 与实测 Id/Iq 相减 → PI_CC → 叠加滤波电压前馈
  //    KvF/(TvFs+1) 与 ωL_F 解耦项 → U*d / U*q → 再做 dq→abc → PWM
  // ==========================================================================
  rect((COL("ccl_l"), ROW("ccl_bot")), (COL("ccl_r"), ROW("ccl_top")), radius: 0.2,
    fill: none, stroke: (paint: GRAY, thickness: 0.8pt))
  txt((8.7, 12.14), [Current Control Loop], size: 9pt)

  // U*d / U*q 汇总母线（粗竖条，两路指令并在一起送 dq→abc）
  line((COL("bar"), 8.5), (COL("bar"), 11.5), stroke: (paint: INK, thickness: 2.6pt))
  arrow-path(((COL("bar") - 0.05, 9.75), (COL("pwm"), 9.75), (COL("pwm"), 14.05)),
    arrow: "end")

  // ---- d 轴链 ----
  sum-junction(COL("sum"), ROW("c_d"), signs: ((0.02, 0.10, "+"), (0.10, -0.02, "+"),
    (-0.02, -0.10, "-")))
  txt((4.78, ROW("c_d") + 0.26), $U^*_d$, size: 8.5pt, anchor: "west")
  arrow-path(((COL("sum") - 0.21, ROW("c_d")), (COL("bar") + 0.03, ROW("c_d"))), arrow: "end")
  block(8.05, ROW("c_d"), 1.7, 0.42, $"PI"_"CC"(s)$, size: 8.5pt)
  arrow-path(((COL("pi_l"), ROW("c_d")), (COL("sum") + 0.21, ROW("c_d"))), arrow: "end")

  // Id_ref 求和：Id_ref(+) − 实测 I_Cd(−)
  sum-junction(COL("sum2"), ROW("c_d"), signs: ((-0.02, -0.10, "-"), (0.10, 0.02, "+")))
  arrow-path(((COL("pi_r"), ROW("c_d")), (COL("sum2") - 0.21, ROW("c_d"))), arrow: "end")
  wire(ROW("c_d"), COL("sum2") + 0.21, COL("sw"), color: RED, arrow: "start")
  txt((11.85, ROW("c_d") + 0.26), $I_d^"ref"$, size: 9pt, fill: RED)

  // 滤波电压前馈 KvF/(TvFs+1)：Vd 经低通后直接叠加，抵消 LC 滤波器上的电压降
  block(8.05, ROW("filt_d"), 2.1, 0.5, $K_"VF"/(T_"VF"s + 1)$, size: 7.5pt)
  wire(ROW("filt_d"), COL("filt_r"), 9.62, arrow: "start")
  txt((9.7, ROW("filt_d")), $V_d$, size: 8.5pt, anchor: "west")
  arrow-path(((COL("filt_l"), ROW("filt_d")), (COL("sum"), ROW("filt_d")),
    (COL("sum"), ROW("c_d") + 0.21)), arrow: "end")

  // ---- q 轴链（与 d 轴镜像）----
  sum-junction(COL("sum"), ROW("c_q"), signs: ((0.02, 0.10, "+"), (0.10, -0.02, "+"),
    (-0.02, -0.10, "+")))
  txt((4.78, ROW("c_q") + 0.26), $U^*_q$, size: 8.5pt, anchor: "west")
  arrow-path(((COL("sum") - 0.21, ROW("c_q")), (COL("bar") + 0.03, ROW("c_q"))), arrow: "end")
  block(8.05, ROW("c_q"), 1.7, 0.42, $"PI"_"CC"(s)$, size: 8.5pt)
  arrow-path(((COL("pi_l"), ROW("c_q")), (COL("sum") + 0.21, ROW("c_q"))), arrow: "end")
  sum-junction(COL("sum2"), ROW("c_q"), signs: ((-0.02, 0.10, "-"), (0.10, 0.02, "+")))
  arrow-path(((COL("pi_r"), ROW("c_q")), (COL("sum2") - 0.21, ROW("c_q"))), arrow: "end")
  wire(ROW("c_q"), COL("sum2") + 0.21, COL("sw"), color: RED, arrow: "start")
  txt((11.85, ROW("c_q") + 0.26), $I_q^"ref"$, size: 9pt, fill: RED)

  block(8.05, ROW("filt_q"), 2.1, 0.5, $K_"VF"/(T_"VF"s + 1)$, size: 7.5pt)
  wire(ROW("filt_q"), COL("filt_r"), 9.62, arrow: "start")
  txt((9.7, ROW("filt_q")), $V_q$, size: 8.5pt, anchor: "west")
  arrow-path(((COL("filt_l"), ROW("filt_q")), (COL("sum"), ROW("filt_q")),
    (COL("sum"), ROW("c_q") - 0.21)), arrow: "end")

  // ---- ωL_F 交叉解耦：d 轴补 q 轴分量、q 轴补 d 轴分量，两条线在中间交叉 ----
  block(7.3, ROW("wl_u"), 1.2, 0.36, $ω L_F$, size: 8.5pt)
  block(7.3, ROW("wl_q"), 1.2, 0.36, $ω L_F$, size: 8.5pt)
  // I_Cd：从 d 轴求和点下方引出，一路进 ωL_F、一路就是反馈电流本身
  line((COL("sum2"), ROW("c_d") - 0.21), (COL("sum2"), ROW("wl_u")),
    stroke: (paint: INK, thickness: LW))
  arrow-path(((COL("wl_r"), ROW("wl_u")), (COL("sum2"), ROW("wl_u"))), arrow: "end")
  txt((COL("sum2") + 0.14, ROW("wl_u")), $I_"Cd"$, size: 8.5pt, anchor: "west")
  // I_Cq：从 q 轴求和点上方引出
  line((COL("sum2"), ROW("c_q") + 0.21), (COL("sum2"), ROW("wl_q")),
    stroke: (paint: INK, thickness: LW))
  arrow-path(((COL("wl_r"), ROW("wl_q")), (COL("sum2"), ROW("wl_q"))), arrow: "end")
  txt((COL("sum2") + 0.14, ROW("wl_q")), $I_"Cq"$, size: 8.5pt, anchor: "west")
  // 交叉：上框输出 → q 轴求和（下），下框输出 → d 轴求和（上）
  arrow-path(((COL("wl_l"), ROW("wl_u")), (6.45, ROW("wl_u")), (COL("sum"), 9.55),
    (COL("sum"), ROW("c_q") + 0.21)), arrow: "end")
  arrow-path(((COL("wl_l"), ROW("wl_q")), (6.45, ROW("wl_q")), (COL("sum"), 10.45),
    (COL("sum"), ROW("c_d") - 0.21)), arrow: "end")

  // 红字说明：开关在 1 位 = 跟网，2 位 = 构网
  txt((8.7, 7.75), [Mode 1: Grid-following control], size: 9.5pt, fill: RED)
  txt((8.7, 7.45), [Mode 2: Grid-forming control], size: 9.5pt, fill: RED)

  // ==========================================================================
  // 8. GFL 支路（蓝）：PI_PC 调有功、PI_VC 调电压
  //    跟网模式下变流器把电网当理想电压源：P/Q 由电流指令跟踪给定，
  //    所以三个 PI 的输出都是"电流指令"，经开关 1 号端子进入电流环。
  // ==========================================================================
  // PI_PC：Pref(+) − PE(−) → Id_ref（有功由 d 轴电流跟踪）
  pi-block(19.35, ROW("pc"), 2.5, 0.4, $"PI"_"PC"(s)$, BLUE)
  sum-junction(COL("gsum"), ROW("pc"), r: 0.24, signs: ((0.04, 0.13, "+"), (0.13, 0.0, "-")))
  wire(ROW("pc"), COL("pil_r"), COL("gsum") - 0.24, color: BLUE, arrow: "start")
  wire(ROW("pc"), COL("gsum") + 0.24, COL("sig"), color: BLUE, arrow: "start")
  txt((COL("sig") + 0.06, ROW("pc")), $P_E$, size: 9pt, fill: RED, anchor: "west")
  line((COL("gsum"), ROW("pc") + 0.42), (COL("gsum"), ROW("pc") + 0.24), stroke: (paint: INK, thickness: 0.7pt), mark: (end: ">", fill: INK, scale: 0.7))
  txt((COL("gsum"), ROW("pc") + 0.60), $P^"ref"$, size: 8.5pt)
  node((COL("ngp"), ROW("pc")), color: GREEN)   // PE 分一路给 fP(s)

  // PI_VC：Vd(−) 与 Vref(+) 相减 → Iq_ref（电压外环的误差给 q 轴电流）
  pi-block(19.35, ROW("vc"), 2.5, 0.4, $"PI"_"VC"(s)$, BLUE)
  sum-junction(COL("gsum"), ROW("vc"), r: 0.24, signs: ((0.04, 0.13, "+"), (0.04, -0.13, "-")))
  wire(ROW("vc"), COL("pil_r"), COL("gsum") - 0.24, color: BLUE, arrow: "start")
  wire(ROW("vc"), COL("gsum") + 0.24, COL("sig"), color: BLUE, arrow: "start")
  txt((COL("sig") + 0.06, ROW("vc")), $V_d$, size: 9pt, fill: RED, anchor: "west")
  line((COL("gsum"), ROW("vc") - 0.50), (COL("gsum"), ROW("vc") - 0.24), stroke: (paint: INK, thickness: 0.7pt), mark: (end: ">", fill: INK, scale: 0.7))
  txt((COL("gsum") + 0.18, ROW("vc") - 0.60), $V^"ref"$, size: 8.5pt, anchor: "west")
  node((COL("nvd"), ROW("vc")), color: ORANGE)  // Vd 分一路给 GFM 的电压环

  // 两个开关：1 号端子接 GFL 的 PI 输出，2 号端子接 GFM 的下垂/电压环
  switch(COL("sw"), ROW("c_d"))
  switch(COL("sw"), ROW("c_q"))
  // 蓝线跨越竖向馈线时用半圆跨线（跨过而不连接）
  wire(ROW("pc"), COL("swt"), COL("pil_l"), hops: (COL("green"),), color: BLUE, arrow: "start")
  wire(ROW("vc"), COL("swt"), COL("pil_l"), hops: (COL("idsum"), COL("green")),
    color: BLUE, arrow: "start")

  // ==========================================================================
  // 9. GFM 支路（橙/绿）：fP(s) 造频率、−PI_VC(s) 造电压支撑
  //    构网模式下变流器自己定频率与电压，所以开关切到 2 号端子：
  //      · PLL 输入改由 fP(s)（有功-频率下垂）给出 Δω → θ 由自己积分
  //      · 电流指令不再来自功率 PI，而由两个 −PI_VC(s) 加电流前馈给出
  // ==========================================================================
  rect((COL("gfm_l"), ROW("gfm_bot")), (COL("gfm_r"), ROW("gfm_top")), radius: 0.25,
    fill: PANEL, stroke: none)
  txt((15.9, 6.05), [Grid-forming loop connection], size: 8.5pt, fill: ORANGE,
    anchor: "west", weight: "bold")

  // 有功 → 频率：PE 经 fP(s) 得 Δω，送回 PLL 开关的 2 号端子（绿色）
  pi-block(18.5, ROW("fp"), 2.2, 0.5, $f_P (s)$, GREEN, size: 9pt)
  line((COL("ngp"), ROW("pc")), (COL("ngp"), ROW("fp")),
    stroke: (paint: GREEN, thickness: LW))
  wire(ROW("fp"), COL("fp_r"), COL("ngp"), hops: (COL("nvd"),), color: GREEN, arrow: "start")
  arrow-path(((COL("fp_l"), ROW("fp")), (COL("green"), ROW("fp")),
    (COL("green"), 12.1), (COL("swt"), 12.1)), color: GREEN, arrow: "end")

  // 两级 −PI_VC(s)：一级吃 Vd、一级吃 Vq，输出分别叠加到 Id_ref / Iq_ref
  pi-block(19.2, ROW("vc_up"), 2.4, 0.4, $"-PI"_"VC"(s)$, ORANGE)
  pi-block(19.2, ROW("vc_dn"), 2.4, 0.4, $"-PI"_"VC"(s)$, ORANGE)
  // Vd（近）→ 上管 → Id 支路；Vq（远）→ 下管 → Iq 支路
  line((COL("nvd"), ROW("vc")), (COL("nvd"), ROW("vc_up")),
    stroke: (paint: ORANGE, thickness: LW))
  wire(ROW("vc_up"), COL("vc_r"), COL("nvd"), color: ORANGE, arrow: "start")
  line((COL("nvq"), ROW("pll")), (COL("nvq"), ROW("vc_dn")),
    stroke: (paint: ORANGE, thickness: LW))
  wire(ROW("vc_dn"), COL("vc_r"), COL("nvq"), color: ORANGE, arrow: "start")

  // 两个相加点：电流前馈（虚线）+ 电压环输出 → 送开关 2 号端子
  sum-junction(COL("idsum"), ROW("idsum"), signs: ((-0.10, 0.02, "+"), (0.02, -0.10, "+")))
  sum-junction(COL("iqsum"), ROW("iqsum"), signs: ((-0.10, 0.02, "+"), (0.02, -0.10, "+")))
  arrow-path(((COL("vc_l"), ROW("vc_up")), (COL("idsum"), ROW("vc_up")),
    (COL("idsum"), ROW("idsum") - 0.21)), color: ORANGE, arrow: "end")
  arrow-path(((COL("vc_l"), ROW("vc_dn")), (COL("iqsum"), ROW("vc_dn")),
    (COL("iqsum"), ROW("iqsum") - 0.21)), color: ORANGE, arrow: "end")

  // 电流前馈虚线框（Id / Iq 由外部给定，构网时用来叠加负载电流）
  rect((COL("ff_l"), 6.05), (COL("ff_r"), 8.0), radius: 0.15, fill: none,
    stroke: (paint: GRAY, thickness: 0.9pt, dash: (3pt, 2pt)))
  txt((14.1, 7.55), $I_d$, size: 8.5pt)
  txt((14.1, 7.2), $I_q$, size: 8.5pt)
  txt((13.95, 6.78), [current], size: 6.8pt)
  txt((13.95, 6.52), [feedforward], size: 6.8pt)
  wire(ROW("idsum"), COL("ff_r"), COL("idsum") - 0.21, color: ORANGE, arrow: "start",
    dash: (2.6pt, 1.8pt))
  wire(ROW("iqsum"), COL("ff_r"), COL("iqsum") - 0.21, color: ORANGE, arrow: "start",
    dash: (2.6pt, 1.8pt))

  // 橙线：Id_ref / Iq_ref 由 GFM 侧给出，上行到 2 号端子
  arrow-path(((COL("idsum"), ROW("idsum") + 0.21), (COL("idsum"), ROW("c_d") - 0.75),
    (COL("swt") + 0.075, ROW("c_d") - 0.75)), color: ORANGE, arrow: "end")
  arrow-path(((COL("iqsum"), ROW("iqsum") + 0.21), (COL("iqsum"), ROW("c_q") - 0.75),
    (COL("swt") + 0.075, ROW("c_q") - 0.75)), color: ORANGE, arrow: "end")

  // ==========================================================================
  // 10. (b) 小信号阻抗模型：把上面两套控制折算成一个串在理想电压源后的阻抗
  //     ΔUs = 0 → 端口电压 ΔV' = −Z·ΔI'，所以"注入电流"箭头指向源侧。
  // ==========================================================================
  let BT = ROW("b_top")
  let BB = ROW("b_bot")
  // 紫色标题：Z_GFL / Z_GFM 二选一（取决于上面三个开关的位置）
  txt((2.4, 4.9), [GFL control: ], size: 9pt, fill: PURPLE, anchor: "west")
  txt((4.36, 4.9), $bold(Z)_"GFL"(s)$, size: 9pt, fill: PURPLE, anchor: "west")
  txt((2.4, 4.55), [GFM control: ], size: 9pt, fill: PURPLE, anchor: "west")
  txt((4.36, 4.55), $bold(Z)_"GFM"(s)$, size: 9pt, fill: PURPLE, anchor: "west")

  // 理想电压源（ΔUs = 0）：内阻为零，所有动态都折到后面的 Z 上
  ac-source(3.4, ROW("b_src"), 0.62)
  line((3.4, ROW("b_src") + 0.62), (3.4, BT), (7.2, BT), stroke: (paint: INK, thickness: LW))
  line((3.4, ROW("b_src") - 0.62), (3.4, BB), (23.6, BB), stroke: (paint: INK, thickness: LW))

  // 串联阻抗 Z_GFL / Z_GFM（紫色文字：两种模式对应两个不同的端口阻抗）
  rect((7.2, BT - 0.25), (11.2, BT + 0.25), fill: white, stroke: (paint: INK, thickness: 0.95pt))
  txt((9.2, BT - 0.02), $Z_"GFL"(s) "/" Z_"GFM"(s)$, size: 8pt, fill: PURPLE)
  // 注入电流（负号表示流出变流器）：紫色箭头 + 矩阵
  arrow-path(((10.8, BT - 0.62), (7.6, BT - 0.62)), color: PURPLE, w: 1.0pt, arrow: "end")
  txt((9.28, BT - 1.02), $-$, size: 9pt, anchor: "east")
  txt((9.4, BT - 1.02), $mat(delim: "[", Δ I_d'; Δ I_q')$, size: 8pt, anchor: "west")

  line((11.2, BT), (16.2, BT), stroke: (paint: INK, thickness: LW))
  node((12.9, BT), r: 0.075)
  txt((13.45, BT - 0.42), $mat(delim: "[", Δ V_d'; Δ V_q')$, size: 8pt, anchor: "west")

  // 电网阻抗 Zg → AC grid
  rect((16.2, BT - 0.25), (20.2, BT + 0.25), fill: white, stroke: (paint: INK, thickness: 0.95pt))
  txt((18.2, BT + 0.5), $bold(Z)_g (s)$, size: 9pt)
  line((20.2, BT), (23.6, BT), stroke: (paint: INK, thickness: LW))
  circle((23.6, BT), radius: 0.09, fill: white, stroke: (paint: INK, thickness: 0.9pt))
  // 右侧竖直连接（两端空心端子 = 电网端口），箭头交代电流回路正方向
  line((23.6, BT - 0.09), (23.6, 3.15), stroke: (paint: INK, thickness: LW),
    mark: (start: ">", fill: INK))
  line((23.6, 2.85), (23.6, BB + 0.09), stroke: (paint: INK, thickness: LW),
    mark: (end: ">", fill: INK))
  circle((23.6, BB), radius: 0.09, fill: white, stroke: (paint: INK, thickness: 0.9pt))
  txt((23.05, 2.55), [AC grid], size: 9pt, fill: PURPLE, anchor: "east")

  // 紫色说明 + ΔUs 定义
  txt((4.5, 2.95), [ideal voltage source], size: 9pt, fill: PURPLE, anchor: "west")
  txt((4.5, 2.62), [behind the impedance], size: 9pt, fill: PURPLE, anchor: "west")
  txt((4.5, 1.9), $Δ U_s = mat(delim: "[", Δ U_(s d); Δ U_(s q)) = mat(delim: "[", 0; 0)$,
    size: 9pt, anchor: "west")
})
