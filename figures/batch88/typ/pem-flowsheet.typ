// ============================================================
// PEM 水电解槽系统流程图（flowsheet + 电解单元剖视）
// 源图：Dynamic optimization of PEM water electrolyzers
//       (arXiv:2405.06766, 2024)  Figure 1 "Flowsheet for the current work"
//
// 版面分两块：
//   左 2/3 —— 主流程（去离子水 → 泵 → 电解槽 → 两个分离罐 → HX 回路 → 干燥 → 压缩 → 储氢 → 需求），
//             物流编号 1–16 逐个保留，箭头方向照源图；
//   右侧    —— 虚线椭圆内的电解单元剖视（Anode | 膜 | Cathode），
//             由电解槽右上角用一条细虚线引线牵出，椭圆本身不压主流程。
//
// 配色约定：颜色只用于物流（H2 红 / H⁺ 深蓝 / H2O 蓝），设备轮廓一律黑色，
//           去离子水罐用浅蓝填充（源图如此）。源图英文标签全部保留。
// ============================================================
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: "Arial", size: 8pt)

#canvas({
  import draw: *

  // ===================== 配色 =====================
  let INK = rgb("#1c1c1c")      // 设备与管路墨色
  let H2C = rgb("#c2382b")      // H2 物流：红
  let HPC = rgb("#1d3f8c")      // H+ 物流：深蓝
  let H2OC = rgb("#2c6cb0")     // H2O 物流：蓝
  let WATERC = rgb("#a9dcf1")   // 去离子水罐填充：浅蓝
  let MEMB = rgb("#d4d4d4")     // 膜（点状填充底）
  let MEMDOT = rgb("#8f8f8f")   // 膜上的孔点
  let GHOST = rgb("#8a8a8a")    // 剖视引出用的虚线

  // ===================== 线型 =====================
  // 设备轮廓 0.8pt；管路 0.7pt；膜/细节 0.55pt
  let eq = (paint: INK, thickness: 0.8pt)
  let pipe = (paint: INK, thickness: 0.7pt, cap: "round")
  let fine = (paint: INK, thickness: 0.55pt, cap: "round")

  // 小箭头（管路用，与 0.7pt 线宽匹配）
  let head = (end: ">", fill: INK, scale: 0.85)

  // ===================== 基础工具 =====================
  // 正交折线（无箭头）
  let seg(..pts) = line(..pts, stroke: pipe)
  // 正交折线 + 末端箭头：箭头方向即流向，照源图放
  let flow(..pts) = line(..pts, stroke: pipe, mark: head)

  // 半椭圆封头顶（sign: 1 向上 / -1 向下），用采样折线画，避免依赖 arc 的锚点语义
  let dome(cx, y, rx, ry, sign: 1, n: 18) = {
    let pts = ()
    for i in range(0, n + 1) {
      let a = i / n * calc.pi
      pts.push((cx - rx * calc.cos(a), y + sign * ry * calc.sin(a)))
    }
    pts
  }
  // 圆弧采样（叶轮、蜗壳内圆）
  let arcpts(cx, cy, r, a0, a1, n: 16) = {
    let pts = ()
    for i in range(0, n + 1) {
      let a = a0 + (a1 - a0) * i / n
      pts.push((cx + r * calc.cos(a), cy + r * calc.sin(a)))
    }
    pts
  }

  // 设备标签（anchor 用罗盘方位：center / west / east，避免手算文字宽度）
  let lbl(x, y, body, anchor: "center", size: 7.6pt, fill: INK) = content(
    (x, y), anchor: anchor, text(size: size, fill: fill, body),
  )

  // 物流编号：白底小标签，压在线上也不脏线
  let tag(x, y, body, anchor: "center") = content(
    (x, y), anchor: anchor,
    box(fill: white, inset: (x: 1.4pt, y: 0.4pt), text(size: 7.4pt, fill: INK, body)),
  )

  // 管路节点：源图用空心小圆点表示三通/接点
  let junction(x, y) = circle((x, y), radius: 0.045, fill: white, stroke: (paint: INK, thickness: 0.6pt))

  // 截止阀（蝶形），白填充盖住管身
  let valve(x, y) = {
    line((x - 0.13, y - 0.11), (x - 0.13, y + 0.11), (x, y), close: true, fill: white, stroke: eq)
    line((x + 0.13, y - 0.11), (x + 0.13, y + 0.11), (x, y), close: true, fill: white, stroke: eq)
  }

  // ===================== 设备符号 =====================

  // 立式圆筒：分离罐 / 储氢罐 / 吹扫氮气瓶共用（w 宽、h 高、封头深 capb/capt）
  let vessel(cx, yb, w, h, capb: 0.14, capt: 0.14) = {
    let rx = w / 2
    let yt = yb + h
    // 筒身两条侧壁
    line((cx - rx, yb + capb), (cx - rx, yt - capt), stroke: eq)
    line((cx + rx, yb + capb), (cx + rx, yt - capt), stroke: eq)
    // 下封头（向下鼓）与上封头（向上鼓）：close 自动补出水平弦线
    line(..dome(cx, yb + capb, rx, capb, sign: -1, n: 14), close: true, fill: white, stroke: eq)
    line(..dome(cx, yt - capt, rx, capt, sign: 1, n: 14), close: true, fill: white, stroke: eq)
  }

  // 去离子水罐：源图是浅蓝实心矩形，无封头
  let tank(x0, y0, x1, y1) = rect((x0, y0), (x1, y1), fill: WATERC, stroke: eq)

  // 干燥器：卧式容器，顶部两个切角（源图的“屋脊”切角外形）
  let dryer(x0, y0, x1, y1) = {
    let c = 0.20
    line(
      (x0, y0), (x0, y1 - c), (x0 + c, y1), (x1 - c, y1), (x1, y1 - c), (x1, y0),
      close: true, fill: white, stroke: eq,
    )
  }

  // 压缩机：圆 + 上下两条反向斜弦（源图的回转机械符号），中心线由管路直穿
  let compressor(cx, cy, r) = {
    circle((cx, cy), radius: r, fill: white, stroke: eq)
    line((cx - 0.78 * r, cy + 0.60 * r), (cx + 0.52 * r, cy + 0.855 * r), stroke: eq)
    line((cx - 0.78 * r, cy - 0.60 * r), (cx + 0.52 * r, cy - 0.855 * r), stroke: eq)
    line((cx - r, cy), (cx + r, cy), stroke: pipe)   // 物流 13 进入后从 15 穿出
  }

  // 离心泵：蜗壳 + 右上切线出口喉 + 开口 C 形叶轮 + 三角底座（源图的“圆 + 叶轮符号”）
  let pump(cx, cy) = {
    circle((cx, cy), radius: 0.27, fill: white, stroke: eq)
    line((cx - 0.12, cy - 0.24), (cx - 0.25, cy - 0.40), (cx + 0.25, cy - 0.40), (cx + 0.12, cy - 0.24), stroke: eq)
    line(..arcpts(cx - 0.01, cy, 0.135, 35deg, 325deg), stroke: eq)
    // 出口喉：白填充的矩形压在壳体右上，把壳线“切”出一个切线出口
    rect((cx + 0.06, cy + 0.14), (cx + 0.34, cy + 0.32), fill: white, stroke: eq)
  }

  // 换热器 HX：圆 + 折流锯齿 + 斜穿对角箭头（源图的圆内交叉线）
  let heat-exchanger(cx, cy) = {
    circle((cx, cy), radius: 0.26, fill: white, stroke: eq)
    line(
      (cx - 0.16, cy - 0.06), (cx - 0.08, cy + 0.07), (cx, cy - 0.06),
      (cx + 0.08, cy + 0.07), (cx + 0.16, cy - 0.06), stroke: fine,
    )
    line((cx - 0.36, cy - 0.36), (cx + 0.40, cy + 0.40), stroke: eq, mark: (end: ">", fill: INK, scale: 0.8))
  }

  // 电解槽：圆角矩形，内部写名
  let stack(x0, y0, x1, y1, label: [Electrolyzer Stack]) = {
    rect((x0, y0), (x1, y1), radius: 0.10, fill: white, stroke: eq)
    lbl((x0 + x1) / 2, (y0 + y1) / 2, label, size: 7.2pt)
  }

  // ===================== 版面常量（改这里即可整体挪动/缩放） =====================
  let XL = 0.50          // 15 号管线竖直车道（压缩机 → 储氢罐）
  let XT0 = 0.90         // 水罐 / 储氢罐左边界
  let XT1 = 2.00         // 右边界
  let XDEM0 = 2.78       // Hydrogen Demand 左
  let XDEM1 = 4.22       // 右
  let XPA = 3.45         // 14 号支管竖直车道
  let XDR0 = 4.62        // Dryer 左
  let XDR1 = 6.12        // 右
  let XSEP1 = 6.94       // O2 分离罐中心
  let XSEP2 = 8.61       // H2 分离罐中心
  let XST0 = 7.40        // 电解槽左
  let XST1 = 9.80        // 右
  let XHX = 2.55         // HX 中心（同时是 7/8/9 汇合后的竖直车道）

  let YHEAD = 10.15      // 顶部物流 13 / 6 的水平车道（压缩机中心高度）
  let YST0 = 3.10        // 电解槽下沿
  let YST1 = 4.30        // 上沿
  let YSEPB = 6.85       // 分离罐下沿
  let YSEPT = 8.28       // 分离罐上沿
  let YRIN = 5.95        // 3/4 号“回流上半圈”的水平车道
  let YMID = 5.10        // 8 号回流的水平车道
  let YLOOP = 6.46       // 7 号（O2 分离罐回流）的水平车道
  let YHX = 3.82         // HX 中心 / 10 号进料车道

  // ===================== 剖视总图：虚线椭圆 =====================
  // 椭圆只框住右侧剖视，主流程（含 4 号竖管）全在弧外，因此不会被遮。
  circle((15.35, 6.85), radius: (5.45, 4.10),
    stroke: (paint: GHOST, thickness: 0.7pt, dash: (4.5pt, 3pt)))
  // 引线：从电解槽右侧中部指向椭圆左下弧 —— 交代“这一块是电解槽的放大剖视”
  line((9.82, 3.72), (10.89, 4.50),
    stroke: (paint: GHOST, thickness: 0.55pt, dash: (3pt, 2.2pt)),
    mark: (end: "stealth", fill: GHOST, scale: 0.8))

  // ===================== 管路（按物流编号顺序） =====================
  // 1 去离子水罐 → 泵入口
  flow((XT1, 2.72), (4.65, 2.72))

  // 2 泵出口 → 电解槽西侧进料（下进料口）
  flow((5.26, 2.95), (6.20, 2.95), (6.20, 3.32), (XST0, 3.32))

  // 3 电解槽顶 → O2 分离罐底部（阳极侧两相流），并在 (7.45,5.95) 分出 8 号回流
  flow((8.05, YST1), (8.05, YRIN), (XSEP1, YRIN), (XSEP1, YSEPB))
  // 4 电解槽顶 → H2 分离罐底部（阴极侧两相流），走右侧一根竖管
  flow((9.45, YST1), (9.45, YRIN), (XSEP2, YRIN), (XSEP2, YSEPB))

  // 5 O2 分离罐顶部放空（O2 / H2O 蒸气 / 微量 H2 / N2）
  flow((XSEP1, YSEPT), (XSEP1, 8.62))

  // 6 H2 分离罐顶部湿氢 → 顶部车道 → 干燥器右侧
  flow((XSEP2, YSEPT), (XSEP2, YHEAD), (XDR1, YHEAD))

  // 7 O2 分离罐液位回流：出罐左侧 → 折下 → 西行 → 汇入 HX 前的竖直车道（9）
  flow((6.60, 7.10), (5.40, 7.10), (5.40, YLOOP), (XHX, YLOOP), (XHX, YHX + 0.26))

  // 8 由 3 号管路分出的另一路回流 → 向西并入同一条竖直车道（箭头指进竖管，同源图）
  flow((7.45, YRIN), (7.45, YMID), (XHX, YMID))

  // 10 HX 出口 → 电解槽西侧进料（与 2 号分开两个进料口，避免源图两条线几乎重合）
  flow((XHX + 0.26, YHX), (XST0, YHX))

  // 11 吹扫 N2：小氮气瓶 → 东行 → 上行 → 电解槽底（带截止阀）
  flow((4.91, 1.62), (4.91, 1.85), (7.68, 1.85), (7.68, YST0))
  valve(7.68, 2.35)

  // 12 干燥器顶部放空
  flow((5.37, 10.58), (5.37, 11.22))

  // 13 干燥器 → 压缩机（箭头指向压缩机），中途在 3.45 分出 14
  flow((XDR0, YHEAD), (2.11, YHEAD))

  // 14 支路 → Hydrogen Demand 顶部
  flow((XPA, YHEAD), (XPA, 8.15))

  // 15 压缩机 → 西行 → 下行 → 储氢罐
  flow((0.79, YHEAD), (XL, YHEAD), (XL, 8.05), (XT0, 8.05))

  // 16 储氢罐 → Hydrogen Demand
  flow((XT1, 7.72), (XDEM0, 7.72))

  // 13/14 的分叉点用节点圆点交代（与源图一致）
  junction(XPA, YHEAD)
  // 3/8 的分叉点
  junction(7.45, YRIN)

  // ===================== 设备 =====================
  // 压缩机（左上）：13 从右侧进、15 从左侧出，中心线直穿
  compressor(1.45, YHEAD, 0.66)
  lbl(1.45, 11.02, [Compressor], size: 8.2pt)

  // 干燥器
  dryer(XDR0, 9.72, XDR1, 10.58)
  lbl((XDR0 + XDR1) / 2, 9.48, [Dryer], size: 8.2pt)

  // 储氢罐（立式，封头较鼓）
  vessel(1.45, 6.85, 1.10, 2.10, capb: 0.20, capt: 0.30)
  lbl(1.45, 6.62, [Hydrogen], size: 8.0pt)
  lbl(1.45, 6.40, [Storage], size: 8.0pt)

  // Hydrogen Demand：矩形框，两行文字
  rect((XDEM0, 7.40), (XDEM1, 8.15), fill: white, stroke: eq)
  lbl((XDEM0 + XDEM1) / 2, 7.90, [Hydrogen], size: 7.4pt)
  lbl((XDEM0 + XDEM1) / 2, 7.66, [Demand], size: 7.4pt)

  // 去离子水罐 + 离心泵 + 吹扫氮气瓶
  tank(XT0, 1.55, XT1, 3.05)
  lbl(1.45, 1.28, [Deionized Water], size: 8.2pt)
  pump(4.92, 2.72)
  lbl(4.92, 2.14, [Pump], size: 8.2pt)
  vessel(4.91, 0.55, 0.42, 1.07, capb: 0.10, capt: 0.11)
  lbl(5.26, 1.06, [Purge N2], anchor: "west", size: 8.2pt)

  // 换热器 HX（7/8 汇流后经 9 进 HX，10 出 HX 回电解槽）
  heat-exchanger(XHX, YHX)
  lbl(XHX, 3.36, [HX], size: 8.2pt)

  // 两个分离罐（O2 在上左、H2 在上右）：竖圆筒，顶部出气、底部进两相流
  vessel(XSEP1, YSEPB, 0.68, YSEPT - YSEPB, capb: 0.16, capt: 0.13)
  vessel(XSEP2, YSEPB, 0.62, YSEPT - YSEPB, capb: 0.16, capt: 0.13)

  // 电解槽本体（剖视椭圆的“被放大件”）
  stack(XST0, YST0, XST1, YST1)

  // ===================== 与剖视有关的标签（主流程侧） =====================
  // 5 号放空气体组成（源图两行小字，第一行在上）
  lbl(XSEP1, 9.28, [O#sub[2], H#sub[2]O#sub[vap],], size: 6.8pt)
  lbl(XSEP1, 9.06, [trace H#sub[2], N#sub[2]], size: 6.8pt)

  // ===================== 物流编号 1–16 =====================
  tag(3.15, 2.94, [1])
  tag(6.34, 3.06, [2], anchor: "west")
  tag(7.72, 6.12, [3])
  tag(8.82, 5.72, [4])
  tag(XSEP1, 8.82, [5])
  tag(8.44, 8.72, [6], anchor: "east")
  tag(5.80, 7.26, [7])
  tag(4.60, 5.36, [8])
  tag(2.43, 4.62, [9], anchor: "east")
  tag(4.30, 4.02, [10])
  tag(6.55, 2.08, [11])
  tag(5.55, 11.06, [12], anchor: "west")
  tag(3.62, 10.36, [13], anchor: "west")
  tag(3.62, 9.16, [14], anchor: "west")
  tag(0.37, 9.16, [15], anchor: "east")
  tag(2.39, 7.90, [16])

  // ===================== 右侧：电解单元剖视 =====================
  // 外框：阳极腔 | 膜 | 阴极腔
  let CX0 = 12.95
  let CX1 = 18.45
  let CY0 = 4.80
  let CY1 = 8.50
  let MEM0 = 15.50
  let MEM1 = 15.90
  rect((CX0, CY0), (CX1, CY1), fill: white, stroke: eq)

  // 膜：浅灰底 + 规则孔点阵（源图是点状填充的灰带）
  rect((MEM0, CY0), (MEM1, CY1), fill: MEMB, stroke: none)
  for i in range(0, 4) {
    for j in range(0, 37) {
      let x = MEM0 + 0.055 + i * 0.098 + (if calc.rem(j, 2) == 0 { 0.0 } else { 0.049 })
      let y = CY0 + 0.05 + j * 0.1
      circle((x, y), radius: 0.016, fill: MEMDOT, stroke: none)
    }
  }
  // 膜两侧的分界线（与源图一致，膜带左右各一条竖线）
  line((MEM0, CY0), (MEM0, CY1), stroke: eq)
  line((MEM1, CY0), (MEM1, CY1), stroke: eq)

  // 腔室名
  lbl(14.15, 6.62, [Anode], size: 10pt)
  lbl(17.20, 6.62, [Cathode], size: 10pt)

  // 内部物流箭头：粗细与管路明显区分（源图是粗黑/彩色大箭头）
  // H2 由阴极析出并向左穿越膜（红）
  line((16.70, 7.70), (14.45, 7.70),
    stroke: (paint: H2C, thickness: 1.4pt), mark: (end: ">", fill: H2C, scale: 2.0))
  lbl(16.84, 7.70, [H#sub[2]], anchor: "west", size: 7.6pt, fill: H2C)
  // H+ 与 H2O 自阳极侧向右迁入阴极侧（深蓝 / 蓝）
  line((15.02, 5.80), (16.72, 5.80),
    stroke: (paint: HPC, thickness: 1.4pt), mark: (end: ">", fill: HPC, scale: 2.0))
  lbl(14.86, 5.80, [H#super[+]], anchor: "east", size: 7.6pt, fill: HPC)
  line((15.02, 5.30), (16.72, 5.30),
    stroke: (paint: H2OC, thickness: 1.4pt), mark: (end: ">", fill: H2OC, scale: 2.0))
  lbl(14.86, 5.30, [H#sub[2]O], anchor: "east", size: 7.6pt, fill: H2OC)

  // 剖视的四条外接物流（粗箭头，指向/来自管路系统的对应支路）
  // 3 阳极出口：O2 / H2O / trace H2 / N2
  line((CX0, 8.02), (11.82, 8.02),
    stroke: (paint: INK, thickness: 1.6pt), mark: (end: ">", fill: INK, scale: 2.0))
  tag(12.26, 8.22, [3])
  lbl(10.62, 8.48, [O#sub[2]], anchor: "west", size: 7.4pt)
  lbl(10.62, 8.06, [H#sub[2]O], anchor: "west", size: 7.4pt, fill: H2OC)
  lbl(10.62, 7.68, [Trace H#sub[2]], anchor: "west", size: 7.4pt)
  lbl(10.62, 7.34, [Trace N#sub[2]], anchor: "west", size: 7.4pt)

  // 2 阳极进水（与主流程 2 号同一股水）
  line((11.82, 5.34), (CX0, 5.34),
    stroke: (paint: INK, thickness: 1.6pt), mark: (end: ">", fill: INK, scale: 2.0))
  tag(12.32, 5.54, [2])
  lbl(11.68, 5.34, [H#sub[2]O], anchor: "east", size: 7.4pt, fill: H2OC)

  // 4 阴极出口：H2 / H2O
  line((CX1, 8.02), (19.58, 8.02),
    stroke: (paint: INK, thickness: 1.6pt), mark: (end: ">", fill: INK, scale: 2.0))
  tag(19.02, 8.22, [4])
  lbl(19.72, 8.08, [H#sub[2]], anchor: "west", size: 7.4pt, fill: H2C)
  lbl(19.72, 7.84, [H#sub[2]O], anchor: "west", size: 7.4pt, fill: H2OC)

  // 底部 N2 吹扫（由主流程 11 号来）
  line((14.26, 4.38), (14.26, CY0),
    stroke: (paint: INK, thickness: 1.6pt), mark: (end: ">", fill: INK, scale: 2.0))
  lbl(14.12, 4.58, [N#sub[2]], anchor: "east", size: 7.4pt)
})
