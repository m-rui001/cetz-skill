// Microgrid 结构与分层控制单线图
// 源图：MAS-Based Distributed Coordinated Control and Optimization in Microgrid
//       (IEEE Trans. Power Electronics, 2017, Aalborg University preprint) Fig. 1 "Microgrid structure"
//
// 拓扑（自左向右 / 自上而下）：
//   Main grid（输电铁塔）→ Isolation switch → PCC 母线 → 三条 Local bus
//   Local bus 1：AC/DC + DC/AC 变流器链 → Wind Turbine；灯泡 / 住宅负载
//   Local bus 2：AC/DC + DC/DC 变流器链 → PV array；电机 / 住宅负载
//   Local bus 3：Power Conversion system → ESS（Flywheel + Battery）；Conventional 机组
//   灰色虚线：MGCC/EMS 与各 Local bus（本地控制器）之间的通信 / 控制通道
//
// 说明：源图里的照片图标（铁塔、风机、光伏板、住宅、灯泡、电机、飞轮、电池、电脑、电厂）
//       全部改为简洁线稿，拓扑、标签与箭头方向保持不变。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Times New Roman", "Segoe UI"), size: 8.4pt)

#canvas({
  import draw: *

  // ======================= 配色与线型 =======================
  let INK = rgb("#1a1a1a")        // 图标与母线墨色
  let POWER = rgb("#c02a1c")      // 功率线：源图为红色粗线
  let COMM = rgb("#5d686c")       // 通信线：灰色虚线
  let TITLE = rgb("#2f6fa8")      // "Microgrid" / "Main grid" 的蓝色标题
  let GREEN = rgb("#dfe9cf")      // AC/DC 变流器底色
  let PINK = rgb("#f6d3cf")       // DC/AC、DC/DC 变流器底色
  let ORANGE = rgb("#f7cfa2")     // Power Conversion system 底色
  let GREYBOX = rgb("#9aa0a2")    // 变流器外框（本地控制器）浅灰虚线

  let thin = (paint: INK, thickness: 0.55pt, cap: "round")   // 图标主线条
  let thinn = (paint: INK, thickness: 0.4pt, cap: "round")    // 图标细线条
  let bold = (paint: INK, thickness: 0.9pt, cap: "round")     // 结构线（隔离开关等）

  // 母线：粗实线（源图为深灰粗杆）
  let bus(a, b) = line(a, b, stroke: (paint: INK, thickness: 2.1pt))

  // 功率线：深红粗实线 + 箭头；double 对应源图里的双向箭头
  let pw(a, b, double: false) = line(
    a, b,
    stroke: (paint: POWER, thickness: 1.45pt, cap: "round"),
    mark: if double { (start: ">", end: ">", fill: POWER) } else { (end: ">", fill: POWER) },
  )

  // 通信线：灰色粗虚线 + 箭头（默认双向）
  let cm(a, b, double: true) = line(
    a, b,
    stroke: (paint: COMM, thickness: 1.5pt, cap: "round", dash: (1.4pt, 1.0pt)),
    mark: if double { (start: ">", end: ">", fill: COMM) } else { (end: ">", fill: COMM) },
  )

  // 文字
  let lbl(x, y, body, size: 8.4pt, anchor: "center", fill: INK, weight: "regular") = content(
    (x, y), anchor: anchor, text(size: size, fill: fill, weight: weight, body),
  )
  // 两行文字（如 "Local / Controller"）
  let lbl2(x, y, a, b, size: 7.7pt, anchor: "center", dy: 0.20) = {
    lbl(x, y + dy, a, size: size, anchor: anchor)
    lbl(x, y - dy, b, size: size, anchor: anchor)
  }

  // ======================= 图标函数（照片 → 线稿） =======================

  // 输电铁塔：代表外部主电网（Main grid）；源图是铁塔照片
  let pylon(cx) = {
    let y0 = 9.70
    let yTop = 17.75
    let wAt(y) = 0.85 + (0.22 - 0.85) * (y - y0) / (yTop - y0)
    // 两条主腿
    line((cx - 0.85, y0), (cx - 0.22, yTop), stroke: thin)
    line((cx + 0.85, y0), (cx + 0.22, yTop), stroke: thin)
    // 五段塔身的横隔与交叉斜材
    for i in range(0, 5) {
      let ya = y0 + (yTop - y0) * i / 5
      let yb = y0 + (yTop - y0) * (i + 1) / 5
      let wa = wAt(ya)
      let wb = wAt(yb)
      line((cx - wa, ya), (cx + wa, ya), stroke: thinn)
      line((cx - wa, ya), (cx + wb, yb), stroke: thinn)
      line((cx + wa, ya), (cx - wb, yb), stroke: thinn)
    }
    // 塔头小三角
    line((cx - 0.22, yTop), (cx, 18.06), (cx + 0.22, yTop), stroke: thin)
    // 下层横担（与主电网母线同高）
    line((cx - 1.02, 16.60), (cx + 1.02, 16.60), stroke: thin)
    line((cx - 1.02, 16.60), (cx, 16.86), (cx + 1.02, 16.60), stroke: thinn)
    // 上层横担
    line((cx - 0.78, 17.45), (cx + 0.78, 17.45), stroke: thin)
    line((cx - 0.78, 17.45), (cx, 17.66), (cx + 0.78, 17.45), stroke: thinn)
    // 横担端部的悬垂绝缘子串（挂线短杆 + 小横纹）
    for (dx, ay) in ((-1.02, 16.60), (1.02, 16.60), (-0.78, 17.45), (0.78, 17.45)) {
      line((cx + dx, ay), (cx + dx, ay - 0.07), stroke: thinn)
      for k in range(0, 3) {
        let yy = ay - 0.09 - k * 0.045
        let hw = 0.065 - k * 0.008
        line((cx + dx - hw, yy), (cx + dx + hw, yy), stroke: thinn)
      }
    }
  }

  // 风机：锥形塔架 + 机舱 + 三叶片；源图是风机照片
  let wind-turbine(cx, cy) = {
    let hub = (cx, cy + 1.42)
    // 塔架
    line((cx - 0.09, cy), (cx - 0.035, cy + 1.24), stroke: thin)
    line((cx + 0.09, cy), (cx + 0.035, cy + 1.24), stroke: thin)
    line((cx - 0.09, cy), (cx + 0.09, cy), stroke: thin)
    // 机舱
    line(
      (cx - 0.11, cy + 1.22), (cx + 0.17, cy + 1.22), (cx + 0.17, cy + 1.36),
      (cx - 0.11, cy + 1.36), close: true, fill: white, stroke: thin,
    )
    // 轮毂
    circle(hub, radius: 0.06, fill: white, stroke: thin)
    // 三片叶片（120° 均布）
    for a in (90deg, 210deg, 330deg) {
      let tip = (hub.at(0) + 0.62 * calc.cos(a), hub.at(1) + 0.62 * calc.sin(a))
      let e1 = (hub.at(0) + 0.085 * calc.cos(a + 78deg), hub.at(1) + 0.085 * calc.sin(a + 78deg))
      let e2 = (hub.at(0) + 0.085 * calc.cos(a - 78deg), hub.at(1) + 0.085 * calc.sin(a - 78deg))
      line(e1, tip, e2, close: true, fill: white, stroke: thinn)
    }
  }

  // 光伏板：倾斜组件阵列（透视）+ 支架；源图是光伏电站照片
  let pv-array(cx, cy) = {
    let x0 = cx - 0.82
    let x1 = cx + 0.60
    let yb = cy + 0.16
    let h = 1.30
    let sk = 0.16                // 透视：右端抬高
    // 组件外框（平行四边形，略微透视）
    line((x0, yb), (x1, yb + sk), (x1, yb + sk + h), (x0, yb + h), close: true, fill: white, stroke: thin)
    // 电池片网格：3 条竖缝 + 4 条横缝
    for i in range(1, 5) {
      let t = i / 5
      let xa = x0 + (x1 - x0) * t
      let ya = yb + sk * t
      line((xa, ya), (xa, ya + h), stroke: thinn)
    }
    for j in range(1, 4) {
      let t = j / 4
      line((x0, yb + h * t), (x1, yb + sk + h * t), stroke: thinn)
    }
    // 支架：两条立腿 + 底横杆
    line((x0 + 0.20, yb), (x0 + 0.12, yb - 0.16), stroke: thin)
    line((x1 - 0.18, yb + sk), (x1 - 0.10, yb + sk - 0.16), stroke: thin)
    line((x0 + 0.06, yb - 0.16), (x1 + 0.02, yb + sk - 0.16), stroke: thinn)
  }

  // 住宅：双坡屋顶 + 门 + 两扇窗 + 烟囱；源图是居民楼照片
  let house(cx, cy) = {
    rect((cx - 0.55, cy), (cx + 0.55, cy + 0.62), fill: white, stroke: thin)
    line(
      (cx - 0.67, cy + 0.58), (cx, cy + 1.00), (cx + 0.67, cy + 0.58), (cx - 0.67, cy + 0.58),
      close: true, fill: white, stroke: thin,
    )
    // 门
    rect((cx - 0.10, cy), (cx + 0.10, cy + 0.33), fill: white, stroke: thinn)
    circle((cx + 0.05, cy + 0.17), radius: 0.018, fill: INK, stroke: none)
    // 左右窗
    rect((cx - 0.42, cy + 0.26), (cx - 0.22, cy + 0.46), stroke: thinn)
    line((cx - 0.32, cy + 0.26), (cx - 0.32, cy + 0.46), stroke: thinn)
    line((cx - 0.42, cy + 0.36), (cx - 0.22, cy + 0.36), stroke: thinn)
    rect((cx + 0.22, cy + 0.26), (cx + 0.42, cy + 0.46), stroke: thinn)
    line((cx + 0.32, cy + 0.26), (cx + 0.32, cy + 0.46), stroke: thinn)
    // 烟囱
    rect((cx + 0.30, cy + 0.68), (cx + 0.42, cy + 0.92), fill: white, stroke: thinn)
  }

  // 灯泡：玻璃泡 + 灯丝 + 螺纹灯座 + 光晕；源图是灯泡照片
  let lamp(cx, cy) = {
    // 灯座
    rect((cx - 0.11, cy), (cx + 0.11, cy + 0.13), fill: white, stroke: thin)
    for k in range(0, 3) {
      line((cx - 0.11, cy + 0.035 + k * 0.04), (cx + 0.11, cy + 0.035 + k * 0.04), stroke: thinn)
    }
    // 颈部
    line((cx - 0.10, cy + 0.15), (cx - 0.09, cy + 0.22), stroke: thin)
    line((cx + 0.10, cy + 0.15), (cx + 0.09, cy + 0.22), stroke: thin)
    // 玻璃泡
    circle((cx, cy + 0.47), radius: 0.26, fill: white, stroke: thin)
    // 灯丝：两根引线 + W 形灯丝
    line((cx - 0.06, cy + 0.30), (cx - 0.06, cy + 0.42), stroke: thinn)
    line((cx + 0.06, cy + 0.30), (cx + 0.06, cy + 0.42), stroke: thinn)
    line(
      (cx - 0.06, cy + 0.42), (cx - 0.03, cy + 0.50), (cx, cy + 0.42),
      (cx + 0.03, cy + 0.50), (cx + 0.06, cy + 0.42), stroke: thinn,
    )
    // 光晕
    for a in (58deg, 90deg, 122deg) {
      line(
        (cx + 0.31 * calc.cos(a), cy + 0.47 + 0.31 * calc.sin(a)),
        (cx + 0.39 * calc.cos(a), cy + 0.47 + 0.39 * calc.sin(a)), stroke: thinn,
      )
    }
  }

  // 电机：机身 + 散热筋 + 端盖 + 出轴 + 底脚 + 接线盒；源图是电机照片
  let motor(cx, cy) = {
    line(
      (cx - 0.34, cy + 0.10), (cx - 0.34, cy + 0.60), (cx + 0.34, cy + 0.60),
      (cx + 0.34, cy + 0.10), close: true, fill: white, stroke: thin,
    )
    // 左端圆弧端盖
    line(
      (cx - 0.34, cy + 0.10), (cx - 0.46, cy + 0.16), (cx - 0.46, cy + 0.54),
      (cx - 0.34, cy + 0.60), stroke: thin,
    )
    // 散热筋
    for i in range(0, 5) {
      let x = cx - 0.24 + i * 0.10
      line((x, cy + 0.16), (x, cy + 0.54), stroke: thinn)
    }
    // 出轴与联轴
    line((cx + 0.34, cy + 0.35), (cx + 0.52, cy + 0.35), stroke: thin)
    circle((cx + 0.57, cy + 0.35), radius: 0.05, stroke: thinn)
    // 底脚
    line((cx - 0.30, cy + 0.10), (cx - 0.30, cy), (cx - 0.14, cy), stroke: thinn)
    line((cx + 0.18, cy), (cx + 0.34, cy), (cx + 0.34, cy + 0.10), stroke: thinn)
    // 接线盒
    rect((cx - 0.16, cy + 0.60), (cx + 0.10, cy + 0.74), fill: white, stroke: thinn)
  }

  // 飞轮：外轮缘 + 轮辐 + 轮毂；源图是飞轮照片
  let flywheel(cx, cy, r: 0.32) = {
    circle((cx, cy), radius: r, fill: white, stroke: thin)
    circle((cx, cy), radius: r * 0.70, stroke: thinn)
    circle((cx, cy), radius: r * 0.19, fill: white, stroke: thin)
    for i in range(0, 6) {
      let a = i * 60deg
      line(
        (cx + r * 0.19 * calc.cos(a), cy + r * 0.19 * calc.sin(a)),
        (cx + r * 0.70 * calc.cos(a), cy + r * 0.70 * calc.sin(a)), stroke: thinn,
      )
    }
  }

  // 电池：电芯外壳 + 正极帽 + 电量条；源图是电池照片
  let battery(cx, cy) = {
    rect((cx - 0.21, cy + 0.04), (cx + 0.21, cy + 0.86), radius: 0.06, fill: white, stroke: thin)
    rect((cx - 0.09, cy + 0.86), (cx + 0.09, cy + 0.98), radius: 0.03, fill: white, stroke: thin)
    // 极性符号
    line((cx - 0.06, cy + 0.72), (cx + 0.06, cy + 0.72), stroke: thinn)
    line((cx, cy + 0.66), (cx, cy + 0.78), stroke: thinn)
    // 电量条
    for k in range(0, 3) {
      let yy = cy + 0.16 + k * 0.13
      line((cx - 0.13, yy), (cx + 0.13, yy), stroke: thinn)
    }
  }

  // 常规机组：冷却塔 + 烟囱 + 厂房；源图是电厂照片
  let power-plant(cx, cy) = {
    // 冷却塔（双曲线收缩塔身，逐点采样左右轮廓）
    let tower(x, h, hw) = {
      let pl = ()
      let pr = ()
      for i in range(0, 10) {
        let t = i / 9
        let half = hw * (1 - 0.35 * t) * (1 - 0.26 * calc.sin(t * calc.pi))
        pl.push((x - half, cy + 0.06 + t * h))
        pr.push((x + half, cy + 0.06 + t * h))
      }
      line(..pl, stroke: thin)
      line(..pr, stroke: thin)
      line(pl.last(), pr.last(), stroke: thinn)
    }
    tower(cx - 0.34, 0.92, 0.30)
    tower(cx + 0.52, 0.68, 0.21)
    line((cx - 0.64, cy + 0.06), (cx - 0.04, cy + 0.06), stroke: thin)
    line((cx + 0.31, cy + 0.06), (cx + 0.73, cy + 0.06), stroke: thinn)
    // 烟囱（带两道箍）
    line((cx + 0.10, cy + 0.34), (cx + 0.10, cy + 1.22), stroke: thin)
    line((cx + 0.17, cy + 0.34), (cx + 0.17, cy + 1.22), stroke: thin)
    line((cx + 0.07, cy + 1.22), (cx + 0.20, cy + 1.22), stroke: thinn)
    for k in range(0, 2) {
      let yy = cy + 0.66 + k * 0.22
      line((cx + 0.09, yy), (cx + 0.18, yy), stroke: thinn)
    }
    // 厂房
    line(
      (cx - 1.00, cy + 0.06), (cx - 1.00, cy + 0.48), (cx - 0.72, cy + 0.48),
      (cx - 0.72, cy + 0.06), stroke: thinn,
    )
    for i in range(0, 3) {
      rect((cx - 0.97 + i * 0.09, cy + 0.16), (cx - 0.92 + i * 0.09, cy + 0.28), stroke: thinn)
    }
  }

  // EMS 终端（MGCC 中央控制器）：显示器 + 主机 + 键盘；源图是电脑照片
  let ems-terminal(cx, cy) = {
    // 主机
    line(
      (cx - 0.86, cy + 0.28), (cx - 0.66, cy + 0.28), (cx - 0.66, cy + 1.04),
      (cx - 0.86, cy + 1.04), close: true, fill: white, stroke: thin,
    )
    line((cx - 0.83, cy + 0.62), (cx - 0.69, cy + 0.62), stroke: thinn)
    line((cx - 0.83, cy + 0.52), (cx - 0.69, cy + 0.52), stroke: thinn)
    circle((cx - 0.76, cy + 0.40), radius: 0.035, stroke: thinn)
    // 显示器外壳
    rect((cx - 0.58, cy + 0.56), (cx + 0.32, cy + 1.46), radius: 0.05, fill: white, stroke: thin)
    // 屏幕 + 屏内趋势曲线与数据行
    rect((cx - 0.50, cy + 0.65), (cx + 0.24, cy + 1.38), fill: rgb("#eef4f8"), stroke: thinn)
    line(
      (cx - 0.44, cy + 0.78), (cx - 0.30, cy + 0.94), (cx - 0.16, cy + 0.82),
      (cx - 0.02, cy + 1.04), (cx + 0.10, cy + 0.90),
      stroke: (paint: TITLE, thickness: 0.5pt),
    )
    line((cx - 0.44, cy + 0.72), (cx + 0.18, cy + 0.72), stroke: thinn)
    line((cx - 0.44, cy + 0.68), (cx - 0.02, cy + 0.68), stroke: thinn)
    // 支架与底座
    line((cx - 0.16, cy + 0.56), (cx - 0.08, cy + 0.34), stroke: thin)
    line((cx + 0.10, cy + 0.56), (cx + 0.02, cy + 0.34), stroke: thin)
    line(
      (cx - 0.26, cy + 0.28), (cx + 0.20, cy + 0.28), (cx + 0.20, cy + 0.34),
      (cx - 0.26, cy + 0.34), close: true, fill: white, stroke: thin,
    )
    // 键盘
    line(
      (cx - 0.40, cy + 0.08), (cx + 0.38, cy + 0.08), (cx + 0.46, cy + 0.22),
      (cx - 0.32, cy + 0.22), close: true, fill: white, stroke: thin,
    )
  }

  // 双向变流器方框：对角斜线分开两种端口，左上 / 右下写端口名
  let converter(cx, cy, tl, br, fill) = {
    let w = 2.05
    let h = 1.05
    let x0 = cx - w / 2
    let x1 = cx + w / 2
    let y0 = cy - h / 2
    let y1 = cy + h / 2
    line(
      (x0, y0), (x1, y0), (x1, y1), (x0, y1), close: true, fill: fill,
      stroke: (paint: INK, thickness: 0.7pt),
    )
    line((x0, y0), (x1, y1), stroke: (paint: INK, thickness: 0.7pt))
    content((x0 + 0.16, y1 - 0.16), anchor: "north-west", text(size: 9.0pt, style: "italic", tl))
    content((x1 - 0.16, y0 + 0.16), anchor: "south-east", text(size: 9.0pt, style: "italic", br))
  }

  // ======================= 版面常量 =======================
  let TOPY = 16.60      // 主电网母线（Main grid 进线）
  let PCCY = 13.30      // PCC 母线
  let LBY = 10.90       // 三条 Local bus
  let C1 = 5.55         // Local bus 1 变流器列中心
  let C2 = 12.35        // Local bus 2 变流器列中心
  let L1 = 8.05         // Local bus 1 负载串中心（灯泡 / 住宅）
  let L2 = 14.55        // Local bus 2 负载串中心（电机 / 住宅）

  // ======================= 微电网外框 =======================
  rect((3.25, 3.55), (25.55, 17.92), radius: 0.35, fill: none,
    stroke: (paint: TITLE, thickness: 0.8pt, dash: (3pt, 2pt)))
  lbl(22.45, 17.30, [Microgrid], size: 14.7pt, fill: TITLE, weight: "bold")

  // ======================= 主电网 + 进线 =======================
  pylon(1.45)
  lbl2(1.45, 8.82, [Main], [grid], size: 11.9pt, dy: 0.29)
  // 铁塔横担 → 主电网母线（功率进线）
  line((2.47, TOPY), (3.90, TOPY), stroke: (paint: INK, thickness: 1.2pt))

  // ======================= 母线 =======================
  bus((3.90, TOPY), (24.60, TOPY))
  bus((3.90, PCCY), (24.60, PCCY))
  bus((4.35, LBY), (8.85, LBY))
  bus((11.00, LBY), (15.60, LBY))
  bus((18.55, LBY), (22.70, LBY))
  lbl(21.60, PCCY + 0.34, [PCC], size: 10.5pt)

  // ======================= 隔离开关 =======================
  // 竖直导体 + 打开的刀闸（铰点在下方，刀片向右上抬起）
  line((8.40, TOPY), (8.40, 15.55), stroke: bold)
  line((8.40, 14.72), (8.40, PCCY), stroke: bold)
  circle((8.40, 14.72), radius: 0.045, fill: white, stroke: thin)
  line((8.40, 14.72), (8.93, 15.40), stroke: bold)
  circle((8.40, 15.55), radius: 0.038, fill: INK, stroke: none)
  lbl2(9.12, 15.15, [Isolation], [switch], size: 9.8pt, anchor: "west")

  // ======================= MGCC/EMS 中央控制器 =======================
  ems-terminal(13.30, 14.34)
  lbl(13.76, 15.46, [MGCC/EMS], size: 10.5pt, anchor: "west")

  // ======================= Local bus 1：AC/DC + DC/AC（风机） =======================
  lbl(4.48, LBY + 0.52, [Local bus], size: 9.0pt, anchor: "west")
  rect((4.35, 7.75), (6.75, 10.55), radius: 0.05, fill: none,
    stroke: (paint: GREYBOX, thickness: 0.55pt, dash: (2.2pt, 1.6pt)))
  converter(C1, 9.875, [AC], [DC], GREEN)
  converter(C1, 8.375, [DC], [AC], PINK)
  // 功率线：母线 ↔ 变流器、变流器 ↔ 变流器为双向
  pw((C1, LBY), (C1, 10.42), double: true)
  pw((C1, 9.34), (C1, 8.91), double: true)
  pw((C1, 6.95), (C1, 7.84))
  lbl2(5.74, 7.35, [Local], [Controller], size: 7.2pt, anchor: "west", dy: 0.16)

  // 负载 1：灯泡 → 住宅（源图中两个负载串联挂在同一条支路上）
  pw((L1, LBY), (L1, 10.42))
  lamp(L1, 9.42)
  lbl(L1 + 0.55, 9.94, [Loads], size: 8.7pt, anchor: "west")
  pw((L1, 9.40), (L1, 8.62))
  house(L1, 7.55)
  lbl(L1 + 0.80, 7.94, [Loads], size: 8.7pt, anchor: "west")
  lbl2(L1 + 0.84, 8.90, [Local], [Controller], size: 7.8pt, anchor: "west", dy: 0.18)

  // ======================= Local bus 2：AC/DC + DC/DC（光伏） =======================
  lbl(11.12, LBY + 0.52, [Local bus], size: 9.0pt, anchor: "west")
  rect((11.15, 7.75), (13.55, 10.55), radius: 0.05, fill: none,
    stroke: (paint: GREYBOX, thickness: 0.55pt, dash: (2.2pt, 1.6pt)))
  converter(C2, 9.875, [AC], [DC], PINK)
  converter(C2, 8.375, [DC], [DC], GREEN)
  pw((C2, LBY), (C2, 10.42), double: true)
  pw((C2, 9.34), (C2, 8.91), double: true)
  pw((C2, 6.54), (C2, 7.84))

  // 负载 2：电机 → 住宅
  pw((L2, LBY), (L2, 10.44))
  motor(L2, 9.60)
  lbl(L2 + 0.76, 9.94, [Loads], size: 8.7pt, anchor: "west")
  pw((L2, 9.58), (L2, 8.62))
  house(L2, 7.55)
  lbl(L2 + 0.78, 7.94, [Loads], size: 8.7pt, anchor: "west")
  lbl2(L2 + 0.82, 8.92, [Local], [Controller], size: 7.8pt, anchor: "west", dy: 0.18)

  // ======================= Local bus 3：PCS / 常规机组 / ESS =======================
  lbl(18.55, LBY + 0.52, [Local bus], size: 9.0pt, anchor: "west")
  rect((18.70, 8.90), (20.60, 10.10), radius: 0.04, fill: ORANGE,
    stroke: (paint: INK, thickness: 0.7pt))
  lbl(19.65, 9.76, [Power], size: 8.5pt)
  lbl(19.65, 9.50, [Conversion], size: 8.5pt)
  lbl(19.65, 9.24, [system], size: 8.5pt)
  pw((19.65, LBY), (19.65, 10.13), double: true)
  pw((19.65, 8.87), (19.65, 7.72), double: true)

  // 常规机组
  power-plant(21.72, 8.85)
  lbl(21.72, 8.52, [Conventional], size: 9.0pt)
  pw((21.72, LBY), (21.72, 10.08), double: true)

  // ESS：飞轮 + 电池
  rect((18.60, 5.35), (21.45, 7.70), radius: 0.05, fill: none,
    stroke: (paint: INK, thickness: 0.8pt, dash: (2.6pt, 1.8pt)))
  lbl(18.92, 7.40, [ESS], size: 10.1pt, anchor: "west", weight: "bold")
  flywheel(19.42, 6.42, r: 0.31)
  lbl(19.42, 5.82, [Flywheel], size: 8.7pt)
  battery(20.68, 5.96)
  lbl(20.68, 5.82, [Battery], size: 8.7pt)

  // ======================= RES：风机 + 光伏 =======================
  rect((3.60, 4.35), (13.95, 6.95), radius: 0.05, fill: none,
    stroke: (paint: INK, thickness: 0.8pt, dash: (4pt, 2pt, 0.8pt, 2pt)))
  lbl(8.60, 6.30, [RES], size: 11.2pt, weight: "bold")
  wind-turbine(5.55, 4.82)
  lbl(5.55, 4.56, [Wind Turbine], size: 8.7pt)
  pv-array(12.35, 4.84)
  lbl(12.35, 4.56, [PV array], size: 8.7pt)

  // ======================= 通信 / 控制通道（灰色虚线） =======================
  // MGCC/EMS ↔ 主电网母线
  cm((13.10, TOPY), (13.10, 15.80))
  // MGCC/EMS ↔ PCC 母线
  cm((13.30, PCCY), (13.30, 14.40))
  // MGCC/EMS ↔ 三条 Local bus（各本地控制器接入点）
  cm((12.72, 14.60), (7.02, LBY + 0.02))
  cm((12.54, 14.62), (12.98, LBY + 0.02), double: false)
  cm((13.66, 15.02), (21.05, LBY + 0.02))

  // ======================= 图例 =======================
  line((9.10, 2.72), (10.10, 2.72), stroke: (paint: POWER, thickness: 1.6pt, cap: "round"))
  lbl(10.24, 2.72, [Power], size: 8.7pt, anchor: "west")
  line((13.40, 2.72), (14.40, 2.72),
    stroke: (paint: COMM, thickness: 1.6pt, cap: "round", dash: (1.4pt, 1.0pt)))
  lbl(14.54, 2.72, [Communication / control], size: 8.7pt, anchor: "west")
})
