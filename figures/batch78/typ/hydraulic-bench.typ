// 液压试验台回路图（ISO 1219 符号）—— 可编辑 CeTZ 重绘
// 源图：Pressure Surge Analysis of a Test Bench for Biodegradable Hydraulic Oils
//       (Tribology in Industry, 2018) Fig.5 "The test bench"
// 说明：元件位置按源图像素坐标换算（1 单位 = 100 px，y 轴向上翻转）；
//       符号函数在上，布局与连线在下；线宽 0.6–0.7pt，全部黑白线稿。
//       源图底部的油箱被裁切，此处按 ISO 1219 补全为开口槽 T。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Arial",), size: 6pt)

#canvas({
  import draw: *;

  // 0. 笔触
  let LW = 0.7pt // 主油路 / 符号外框线宽
  let FW = 0.6pt // 符号内部细节（弹簧、线圈、虚线）线宽
  let st(t) = (paint: black, thickness: t)
  let st-dash(t) = (paint: black, thickness: t, dash: "dashed")
  let st-dotdash(t) = (paint: black, thickness: t, dash: "dash-dotted")
  let ST = st(LW) // 默认笔触：管路、符号外框
  let SF = st(FW) // 细节笔触：弹簧、线圈、信号线
  let DASH = st-dash(FW) // 泄油 / 先导虚线
  let DASHDOT = st-dotdash(0.65pt) // 控制块 / 加载块边界
  let flow-mark = (end: ">", fill: black, scale: 0.8)

  // 文字标注：anchor 决定文字块挂在坐标点的哪一侧
  let lab(pos, body, anchor: "center", size: 6pt) = content(
    pos,
    anchor: anchor,
    text(size: size, fill: black, body),
  )

  // 管路接头：小实心圆点
  let node(pos, r: 0.055) = circle(pos, radius: r, fill: black, stroke: none)

  // 折线锯齿（弹簧 / 电阻丝）：p1 → p2，n 个齿，振幅 amp
  let zig(p1, p2, n: 4, amp: 0.07) = {
    let (x1, y1) = (p1.at(0), p1.at(1))
    let (x2, y2) = (p2.at(0), p2.at(1))
    let (dx, dy) = (x2 - x1, y2 - y1)
    let len = calc.sqrt(dx * dx + dy * dy)
    let (ux, uy) = (dx / len, dy / len)
    let (px, py) = (-uy, ux) // 法向
    let pts = ()
    for i in range(0, 2 * n + 1) {
      let t = i / (2 * n)
      let s = if i == 0 or i == 2 * n {
        0
      } else if calc.odd(i) {
        amp
      } else {
        -amp
      }
      pts.push((x1 + dx * t + px * s, y1 + dy * t + py * s))
    }
    line(..pts, stroke: SF)
  }

  // 电气 / 传感信号箭头：短折线 + 实心箭头，tip 为箭头尖端，back 为来向
  let sig(tip, back: (1, 1), size: 0.42) = {
    let (tx, ty) = (tip.at(0), tip.at(1))
    let (bx, by) = (back.at(0), back.at(1))
    let n = calc.sqrt(bx * bx + by * by)
    let (bx, by) = (bx / n, by / n)
    let (px, py) = (-by, bx)
    line(
      (tx + bx * size, ty + by * size),
      (tx + bx * size * 0.60 + px * size * 0.34, ty + by * size * 0.60 + py * size * 0.34),
      (tx + bx * size * 0.34 - px * size * 0.12, ty + by * size * 0.34 - py * size * 0.12),
      (tx, ty),
      stroke: SF,
      mark: (end: ">", fill: black, scale: 0.7),
    )
  }

  // 1. 符号函数
  // 【液压泵】圆 + 腔内实心三角；三角指向出油侧（dir = +1 向右，-1 向左）
  let pump(pos, r: 0.45, dir: 1) = {
    let (x, y) = (pos.at(0), pos.at(1))
    circle(pos, radius: r, stroke: ST, fill: white)
    let q = r * 0.34
    line(
      (x - q * 0.20 * dir, y - q * 0.75),
      (x - q * 0.20 * dir, y + q * 0.75),
      (x + q * 1.72 * dir, y),
      close: true,
      fill: black,
      stroke: black,
    )
  }

  // 【电动机】圆 + 字母 M
  let motor(pos, r: 0.46, body: [M]) = {
    circle(pos, radius: r, stroke: ST, fill: white)
    lab(pos, body, size: 7pt)
  }

  // 【压力表】圆 + 指针（斜向）
  let gauge(pos, r: 0.34) = {
    let (x, y) = (pos.at(0), pos.at(1))
    circle(pos, radius: r, stroke: ST, fill: white)
    line((x - r * 0.42, y - r * 0.42), (x + r * 0.52, y + r * 0.52), stroke: st(0.8pt))
  }

  // 【压力阀】方框 + 顶部调压弹簧 + 内部斜线 + 端口三角（安全阀 / 溢流阀通用）
  let relief-valve(pos, w: 0.86, h: 0.80, spring: true, drain: false, arrow: false) = {
    let (x, y) = (pos.at(0), pos.at(1))
    let (l, b, r, t) = (x - w / 2, y - h / 2, x + w / 2, y + h / 2)
    rect((l, b), (r, t), stroke: ST, fill: white)
    line((l, b), (r, t), stroke: SF) // 阀芯斜线（可调）
    if spring {
      zig((x + 0.02, t), (x + 0.06, t + 0.50), n: 3, amp: 0.075) // 调压弹簧
    }
    if arrow {
      // 阀内流向（P → T）
      line((l + 0.14, b + 0.22), (r - 0.14, b + 0.22), stroke: SF, mark: flow-mark)
    }
    if drain {
      // 底部先导 / 泄油口：实心三角
      line((x - 0.10, b + 0.02), (x + 0.10, b + 0.02), (x, b + 0.16), close: true, fill: black, stroke: black)
    } else {
      // 底部通口三角（空心）
      line((x - 0.10, b + 0.01), (x + 0.10, b + 0.01), (x, b + 0.20), close: true, fill: white, stroke: SF)
    }
  }

  // 【换向阀】两联方框 + 通口 T 形封堵 + 直通箭头（二位二通、中位闭）
  let direction-valve(pos, w: 0.90, h: 0.95) = {
    let (x, y) = (pos.at(0), pos.at(1))
    let (l, b, r, t) = (x - w / 2, y - h / 2, x + w / 2, y + h / 2)
    let mid = y // 两个工位的中线 = 通口高度
    rect((l, b), (r, t), stroke: ST, fill: white)
    line((l, mid), (r, mid), stroke: ST) // 工位分隔线
    // 上工位：两侧封堵（T 形短杠）
    line((l, mid + 0.07), (l + 0.18, mid + 0.07), stroke: SF)
    line((l + 0.18, mid - 0.05), (l + 0.18, mid + 0.19), stroke: SF)
    line((r, mid + 0.07), (r - 0.18, mid + 0.07), stroke: SF)
    line((r - 0.18, mid - 0.05), (r - 0.18, mid + 0.19), stroke: SF)
    // 下工位：直通（箭头）
    line((l + 0.18, mid - 0.26), (r - 0.16, mid - 0.26), stroke: SF, mark: flow-mark)
  }

  // 【蓄能器】胶囊形（两端半圆）
  let accumulator(pos, w: 0.82, h: 1.92) = {
    let (x, y) = (pos.at(0), pos.at(1))
    rect((x - w / 2, y - h / 2), (x + w / 2, y + h / 2), radius: w / 2, stroke: ST, fill: white)
  }

  // 【过滤器】菱形 + 中间虚线
  let filter(pos, w: 1.03, h: 0.82) = {
    let (x, y) = (pos.at(0), pos.at(1))
    let (a, b) = (w / 2, h / 2)
    line((x - a, y), (x, y + b), (x + a, y), (x, y - b), close: true, fill: white, stroke: ST)
    line((x - a * 0.78, y), (x + a * 0.78, y), stroke: st-dash(0.65pt))
  }

  // 【冷却器】菱形 + 空气流箭头（热交换）
  let cooler(pos, w: 1.24, h: 0.88) = {
    let (x, y) = (pos.at(0), pos.at(1))
    let (a, b) = (w / 2, h / 2)
    line((x - a, y), (x, y + b), (x + a, y), (x, y - b), close: true, fill: white, stroke: ST)
    line((x - 0.14, y + 0.30), (x - 0.14, y - 0.30), stroke: SF, mark: (end: ">", fill: black, scale: 0.7))
    line((x + 0.14, y - 0.30), (x + 0.14, y + 0.30), stroke: SF, mark: (end: ">", fill: black, scale: 0.7))
  }

  // 【加热器 / 温控器】方框 + 内部电阻折线
  let heater(pos, w: 0.95, h: 0.90, label: [R]) = {
    let (x, y) = (pos.at(0), pos.at(1))
    rect((x - w / 2, y - h / 2), (x + w / 2, y + h / 2), stroke: ST, fill: white)
    zig((x - w * 0.34, y + h * 0.26), (x + w * 0.34, y + h * 0.26), n: 3, amp: 0.055)
    lab((x, y - h * 0.20), label, size: 6.5pt)
  }

  // 【油箱】顶部开口的槽
  let tank(x0, x1, ytop, depth) = {
    line((x0, ytop), (x0, ytop - depth), (x1, ytop - depth), (x1, ytop), stroke: st(0.8pt))
  }

  // 【虚线块】控制块 / 加载块的边界（点划线框 + 标题）
  let dashed-block(x0, y0, x1, y1, title: (), pos: none) = {
    rect((x0, y0), (x1, y1), stroke: st-dotdash(0.65pt), fill: none)
    if pos != none {
      lab(pos, title, size: 5.4pt)
    }
  }

  // 【风扇】横杆 + 两端外向三角（与电机同轴）
  let fan(pos, w: 1.10, h: 0.24) = {
    let (x, y) = (pos.at(0), pos.at(1))
    line((x - w / 2 + 0.16, y), (x + w / 2 - 0.16, y), stroke: ST)
    line((x - w / 2, y), (x - w / 2 + 0.18, y - h / 2), (x - w / 2 + 0.18, y + h / 2), close: true, fill: white, stroke: ST)
    line((x + w / 2, y), (x + w / 2 - 0.18, y - h / 2), (x + w / 2 - 0.18, y + h / 2), close: true, fill: white, stroke: ST)
  }

  // 【截止阀】两三角对顶（蝶形）
  let shutoff-valve(pos, w: 0.62, h: 0.52) = {
    let (x, y) = (pos.at(0), pos.at(1))
    let (a, b) = (w / 2, h / 2)
    line((x - a, y + b), (x + a, y + b), (x, y), close: true, fill: white, stroke: ST)
    line((x - a, y - b), (x + a, y - b), (x, y), close: true, fill: white, stroke: ST)
  }

  // 【温度传感器】圆 + 毛细管 + 感温点
  let thermometer(pos, r: 0.30) = {
    let (x, y) = (pos.at(0), pos.at(1))
    circle(pos, radius: r, stroke: ST, fill: white)
    line((x, y + r * 0.95), (x, y - r * 0.30), stroke: SF)
    circle((x, y - r * 0.34), radius: 0.045, fill: black, stroke: none)
  }

  // 【变压器】双绕组 + 铁芯（TR）：一次侧左进、二次侧右出
  let transformer(x0, y0, x1, y1) = {
    rect((x0, y0), (x1, y1), stroke: ST, fill: white)
    let cx = (x0 + x1) / 2
    let (yb, ya) = (y0 + 0.30, y1 - 0.30) // 绕组上下端
    let n = 4
    let rr = (ya - yb) / (2 * n)
    let xl = cx - 0.11
    let xr = cx + 0.11
    // 左（一次）绕组：半圆向左鼓；右（二次）绕组：半圆向右鼓
    for i in range(n) {
      arc((xl, yb + rr * (2 * i + 1)), start: 90deg, stop: 270deg, radius: rr, stroke: SF)
      arc((xr, yb + rr * (2 * i + 1)), start: -90deg, stop: 90deg, radius: rr, stroke: SF)
    }
    // 铁芯（双线）
    line((cx - 0.025, yb - 0.05), (cx - 0.025, ya + 0.05), stroke: SF)
    line((cx + 0.025, yb - 0.05), (cx + 0.025, ya + 0.05), stroke: SF)
    // 绕组引线：从绕组端部水平引出到框外
    line((xl, ya), (x0, ya), stroke: SF)
    line((xl, yb), (x0, yb), stroke: SF)
    line((xr, ya), (x1, ya), stroke: SF)
    line((xr, yb), (x1, yb), stroke: SF)
  }

  // 【转速开关】方框 + 圆 + 顶部转速给定输入（WSS）
  let speed-switch(pos, w: 0.93, h: 0.85) = {
    let (x, y) = (pos.at(0), pos.at(1))
    let (l, b, r, t) = (x - w / 2, y - h / 2, x + w / 2, y + h / 2)
    rect((l, b), (r, t), stroke: ST, fill: white)
    circle((x, y - 0.05), radius: 0.22, stroke: ST, fill: white)
    // 顶部给定值输入：小方框 + 转速箭头 n
    rect((x - 0.10, t), (x + 0.10, t + 0.12), stroke: SF, fill: white)
    line((x, t + 0.12), (x, t + 0.20), stroke: SF)
    line((l + 0.06, t + 0.28), (r - 0.02, t + 0.28), stroke: SF, mark: flow-mark)
  }

  // 【电位器】竖折线（W）
  let potentiometer(x, y0, y1) = {
    zig((x, y0), (x, y1), n: 4, amp: 0.045)
  }

  // 【显示 / 仪表箱】矩形 + 文字
  let display-box(x0, y0, x1, y1, body) = {
    rect((x0, y0), (x1, y1), stroke: ST, fill: white)
    content(((x0 + x1) / 2, (y0 + y1) / 2), body)
  }

  // 2. 布局常量
  // 主干压力 / 吸油路高度（源图 y ≈ 942 px）
  let RAIL = 8.16
  // 泵组中心线
  let XM = 5.00

  // 3. 油箱（T，补绘）
  // 源图底部被裁切，此处按 ISO 1219 补一个开口槽，所有回油 / 吸油支路汇入
  tank(1.30, 16.20, 0.55, 0.47)
  lab((15.70, 0.72), [T], anchor: "south-east", size: 6.5pt)

  // 4. 主泵组：HP1 + 驱动电机
  // 电机 M → 转速传感器 RSS → 联轴器 → 泵 HP1（泵坐在吸/压管路上）
  motor((XM, 10.70), r: 0.47)
  // 电机—传感器之间双线轴
  line((XM - 0.12, 10.23), (XM - 0.12, 9.92), stroke: ST)
  line((XM + 0.12, 10.23), (XM + 0.12, 9.92), stroke: ST)
  // 转速传感器 RSS：双圆环
  circle((XM, 9.50), radius: 0.42, stroke: ST, fill: white)
  circle((XM, 9.50), radius: 0.21, stroke: SF, fill: white)
  lab((5.54, 9.42), [RSS], anchor: "west", size: 6pt)
  // 传感器—泵：联轴器（两条横杠）
  line((XM - 0.14, 9.08), (XM - 0.14, 8.61), stroke: ST)
  line((XM + 0.14, 9.08), (XM + 0.14, 8.61), stroke: ST)
  line((XM - 0.30, 8.86), (XM + 0.30, 8.86), stroke: ST)
  line((XM - 0.30, 8.78), (XM + 0.30, 8.78), stroke: ST)
  // 液压泵 HP1（出油口朝右）
  pump((XM, RAIL), r: 0.45, dir: 1)
  lab((4.55, 7.62), [HP#sub[1]], anchor: "north-east", size: 6.5pt)

  // 吸油管路：油箱 → F1 → P1 → 泵（左侧竖直段）
  line((2.15, RAIL), (2.15, 1.71), stroke: ST)
  filter((2.15, 1.30))
  lab((1.80, 0.96), [F#sub[1]], anchor: "north-east", size: 6.5pt)
  line((2.15, 0.89), (2.15, 0.55), stroke: ST)

  // 压力管 P1（吸油侧压力表）
  line((3.58, 8.89), (3.58, RAIL), stroke: ST)
  gauge((3.58, 9.23), r: 0.34)
  lab((3.50, 9.80), [P#sub[1]], anchor: "south-east", size: 6.5pt)

  // 总管：油箱 → F1 → P1 → 泵吸油口（左段）
  line((2.15, RAIL), (XM - 0.45, RAIL), stroke: ST)
  // 压力管路主干：泵出口 → SV 泄油口 → 蓄能器阀 → P2 → 加载块
  line((XM + 0.45, RAIL), (9.55, RAIL), stroke: ST)
  node((3.58, RAIL))
  node((6.80, RAIL))
  node((8.08, RAIL))
  node((9.42, RAIL))
  // 主干 → 加载块（右侧下行，源图 x ≈ 950 px）
  line((9.55, RAIL), (9.55, 4.05), (11.27, 4.05), stroke: ST)

  // 5. 安全阀 SV（弹簧 + 电磁联锁）
  relief-valve((6.80, 10.65), w: 0.86, h: 0.80)
  lab((6.30, 10.12), [SV], anchor: "north-east", size: 6.5pt)
  // 阀—电机联锁线（源图由阀左口直连电机圆）
  line((5.47, 10.65), (6.37, 10.65), stroke: ST)
  sig((5.80, 10.34), back: (1, 1), size: 0.40)
  // 阀底泄油：虚线接回压力主干
  line((6.80, 10.25), (6.80, RAIL), stroke: DASH)

  // 6. 蓄能器 A + 阀 V
  accumulator((8.07, 10.46), w: 0.82, h: 1.90)
  lab((8.60, 11.30), [A], anchor: "south-west", size: 6.5pt)
  line((8.07, 9.51), (8.07, 9.36), stroke: ST)
  shutoff-valve((8.07, 9.10), w: 0.62, h: 0.52)
  line((8.07, 8.84), (8.07, RAIL), stroke: ST)
  lab((8.50, 9.06), [V], anchor: "west", size: 6.5pt)

  // 压力表 P2（泵出口压力）
  line((9.42, 8.89), (9.42, RAIL), stroke: ST)
  gauge((9.42, 9.23), r: 0.34)
  lab((9.06, 9.80), [P#sub[2]], anchor: "south-east", size: 6.5pt)

  // 7. HMG 3010：三路电气 / 信号线
  // 顶部数据采集仪：三路信号分别来自 RSS、P2、DCV 控制端
  display-box(3.75, 13.20, 5.80, 14.45, align(center)[
    #text(size: 6.5pt)[HMG] \
    #text(size: 6.5pt)[3010]
  ])
  // 通道 1：RSS 转速信号
  line((4.05, 13.20), (4.05, 9.72), (4.57, 9.72), stroke: SF)
  sig((4.05, 13.06), back: (-0.9, -1), size: 0.44)
  // 通道 2：P2 压力信号
  line((4.80, 13.20), (4.80, 11.71), (9.42, 11.71), (9.42, 9.57), stroke: SF)
  sig((4.80, 13.06), back: (-0.9, -1), size: 0.44)
  sig((9.42, 11.20), back: (0, 1), size: 0.44)
  // 通道 3：通往控制块 / 加载块（DCV 控制端）
  line((5.55, 13.20), (5.55, 12.11), (15.05, 12.11), (15.05, 8.15), (13.23, 8.15), (13.23, 7.42), stroke: SF)
  sig((5.55, 13.06), back: (-0.9, -1), size: 0.44)
  sig((14.80, 8.52), back: (0, 1), size: 0.44)

  // 8. 控制块（Control block）
  dashed-block(10.30, 8.95, 16.50, 11.60, title: align(center)[
    #text(size: 5.4pt)[Control] \
    #text(size: 5.4pt)[block]
  ], pos: (15.80, 10.55))
  // 变压器 TR：一次侧两点接入（左侧端子），二次侧出线接信号变换
  transformer(10.72, 9.62, 11.80, 11.22)
  lab((11.26, 9.40), [TR], anchor: "north", size: 6.5pt)
  line((10.30, 10.92), (10.72, 10.92), stroke: SF)
  line((10.30, 9.92), (10.72, 9.92), stroke: SF)
  node((10.56, 10.92), r: 0.05)
  node((10.56, 9.92), r: 0.05)
  // 二次侧并接后送入信号变换器（空心三角）
  line((11.72, 10.92), (11.72, 9.92), stroke: SF)
  line((11.72, 10.42), (12.10, 10.42), stroke: SF)
  line((12.10, 10.24), (12.10, 10.60), (12.50, 10.42), close: true, fill: white, stroke: ST)
  line((12.50, 10.42), (12.80, 10.42), stroke: SF)
  // 转速开关 WSS（顶部 n 给定输入）
  speed-switch((13.27, 10.02), w: 0.93, h: 0.85)
  lab((13.27, 9.47), [WSS], anchor: "north", size: 6.5pt)
  lab((13.68, 10.72), text(style: "italic")[n], anchor: "west", size: 6pt)
  // 电位器 W：WSS 输出端可调电阻
  line((13.74, 10.02), (14.38, 10.02), stroke: SF, mark: flow-mark)
  potentiometer(14.52, 9.80, 10.30)
  lab((14.66, 10.02), [W], anchor: "west", size: 6.5pt)

  // 9. 加载块（Loading block）
  dashed-block(11.03, 0.98, 15.55, 7.75, title: align(center)[
    #text(size: 5.4pt)[Loading] \
    #text(size: 5.4pt)[block]
  ], pos: (12.15, 6.90))
  // 块内节点：压力进 / 回油
  node((11.27, 4.05))
  node((14.90, 4.05))
  // 节点 → DCV 两侧通口
  line((11.27, 4.05), (11.27, 5.375), (12.80, 5.375), stroke: ST)
  line((13.70, 5.375), (14.90, 5.375), (14.90, 4.05), stroke: ST)
  // 节点 → PV 两侧通口（与换向阀并联 = 加载 / 卸荷）
  line((11.27, 4.05), (11.27, 2.75), (12.80, 2.75), stroke: ST)
  line((13.70, 2.75), (14.90, 2.75), (14.90, 4.05), stroke: ST)
  // 电液换向阀 DCV（二位二通、中位闭）+ 上部电磁 / 弹簧驱动
  direction-valve((13.25, 5.375), w: 0.90, h: 0.95)
  lab((12.66, 5.72), [DCV], anchor: "south-east", size: 6.5pt)
  // 电液驱动头（窄高框：可调斜线 + 电磁铁芯，源图为同形细高框）
  rect((13.00, 5.92), (13.46, 7.42), stroke: ST, fill: white)
  line((13.00, 7.02), (13.46, 7.32), stroke: SF)
  line((13.15, 6.94), (13.33, 6.94), (13.24, 6.78), close: true, fill: black, stroke: black)
  // 复位弹簧：阀体左上角 → 驱动头左侧
  zig((12.68, 5.90), (13.00, 6.36), n: 3, amp: 0.07)
  // 溢流阀 PV（加载压力设定）+ 泄油
  relief-valve((13.25, 2.75), w: 0.90, h: 0.90, spring: true, drain: true, arrow: true)
  lab((12.70, 3.06), [PV], anchor: "south-east", size: 6.5pt)
  line((13.25, 2.29), (13.25, 2.14), stroke: ST)
  line((13.25, 2.14), (13.25, 0.55), stroke: ST)
  // PV 先导虚线
  line((12.80, 2.75), (12.42, 2.33), (12.42, 1.30), stroke: DASH)
  // 加载块回油 → 油箱
  line((14.90, 4.05), (15.95, 4.05), (15.95, 0.55), stroke: ST)

  // 10. 温度控制：显示 → 温控器 R → 传感器 ST
  display-box(3.20, 5.60, 6.35, 6.80, align(center)[
    #text(size: 5.6pt)[Temperature]
    #linebreak()
    #text(size: 5.6pt)[display]
  ])
  // R 顶部电信号接温度显示
  line((3.61, 4.80), (3.61, 5.60), stroke: SF)
  sig((3.63, 5.12), back: (0, 1), size: 0.42)
  heater((3.645, 4.35), w: 0.95, h: 0.90)
  // R → 温度传感器 ST → 油箱
  line((3.61, 3.90), (3.61, 1.45), stroke: SF)
  sig((3.63, 2.55), back: (0, 1), size: 0.42)
  thermometer((3.61, 1.15), r: 0.30)
  lab((3.98, 1.02), [ST], anchor: "west", size: 6.5pt)
  line((3.61, 0.85), (3.61, 0.55), stroke: ST)

  // 11. 风机与电机（R 的电气联动）
  // 温控器 → 风机电机 → 循环泵电机（源图同一根电气母线）
  line((4.12, 4.20), (5.64, 4.20), stroke: SF)
  line((6.56, 4.20), (7.64, 4.20), stroke: SF)
  sig((5.42, 4.06), back: (1, -1), size: 0.44)
  sig((7.40, 4.06), back: (1, -1), size: 0.44)
  // 风机电机（HG2）+ 轴流风扇 V
  motor((6.10, 4.20), r: 0.44)
  lab((6.10, 4.82), [HG2], anchor: "south", size: 5.4pt)
  line((6.10, 3.76), (6.10, 3.62), stroke: ST)
  fan((6.10, 3.55), w: 1.10, h: 0.24)
  lab((5.45, 3.55), [V], anchor: "east", size: 6.5pt)
  // 风扇 → 冷却器 气流箭头
  line((5.86, 3.36), (5.86, 3.10), stroke: SF, mark: (end: ">", fill: black, scale: 0.8))
  line((6.36, 3.10), (6.36, 3.36), stroke: SF, mark: (end: ">", fill: black, scale: 0.8))

  // 12. 冷却 / 精滤回路（HP2 循环）
  // 电机（HF2）→ 泵 HP2，油路：油箱 → F2 → 泵 → 冷却器 C → 油箱
  motor((8.10, 4.20), r: 0.44)
  lab((8.10, 4.82), [HF2], anchor: "south", size: 5.4pt)
  line((7.98, 3.76), (7.98, 2.97), stroke: ST)
  line((8.22, 3.76), (8.22, 2.97), stroke: ST)
  arc((8.10, 3.37), start: 200deg, stop: 340deg, radius: 0.25, stroke: SF,
    mark: (end: "stealth", fill: black, scale: 0.7))
  pump((8.10, 2.55), r: 0.42, dir: -1)
  lab((8.58, 2.10), [HP#sub[2]], anchor: "north-west", size: 6.5pt)
  // 油路：C 左右两段 + 泵左右两段
  line((5.05, 2.55), (5.53, 2.55), stroke: ST)
  cooler((6.15, 2.55), w: 1.24, h: 0.88)
  lab((6.15, 1.92), [C], anchor: "north", size: 6.5pt)
  line((6.77, 2.55), (7.68, 2.55), stroke: ST)
  line((8.52, 2.55), (9.95, 2.55), stroke: ST)
  // 吸油立管 → 油箱
  line((5.05, 2.55), (5.05, 0.55), stroke: ST)
  // 精滤 F2 → 油箱
  line((9.95, 2.55), (9.95, 1.71), stroke: ST)
  filter((9.95, 1.30))
  lab((10.56, 0.96), [F#sub[2]], anchor: "north-west", size: 6.5pt)
  line((9.95, 0.89), (9.95, 0.55), stroke: ST)
})
