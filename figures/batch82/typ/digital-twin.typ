// 面向智能制造的数字孪生设计总图（Digital twin for smart manufacturing）
// 源论文：Digital twin for smart manufacturing: A review
//        (HAL hal-04337931, 2023) Fig.2 "The design of the digital twin for manufacturing"
//
// 结构：
//   虚线圆角外框内，左右两个大圆：
//     左 Physical System —— 外圈弧段 Advanced Sensing / Network / High Speed Internet /
//                            Internet of Things；内部分 4 个扇区 Redesign / Perception /
//                            Maintenance / Connection；圆心机床
//     右 Digital System  —— 外圈弧段 Big Data / Artificial Intelligence / Cloud Computing；
//                            内部分 5 个扇区 Prognosis / Data Fusion / Diagnosis /
//                            Self-Learning / Computing；圆心机床
//   顶部粗弧箭头 Digital mapping（左→右），底部粗弧箭头 Feedback driving（右→左）
//   下方六个圆形能力图标：Analyze System Characteristics / System 3D Visualization VR/AR /
//                        System Data Integration / Intelligent Decision Making /
//                        System Optimization Operation / System Health Management
//
// 说明：源图里的彩色实心照片/剪影图标全部改为单色线稿（每个图标一个命名函数），
//       仅保留浅灰填充（圆环带 / 大箭头 / 图标底盘）区分面；全部线宽在 0.6–0.9pt 之间。
// 坐标：1 canvas 单位 = UNIT，圆弧与扇区全部由“圆心 + 半径 + 角度区间”参数生成。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Times New Roman", "Segoe UI"), size: 7pt)

#let UNIT = 0.72cm      // 1 个画布单位对应的实际长度
#let BAND-FS = 7.2pt    // 圆环弧段标签字号
#let FONT = ("Times New Roman", "Segoe UI")

// 圆环弧段标签文字（逐字贴弧排布，需先实测字宽）
#let BAND-LABELS = (
  "Advanced Sensing", "Network", "High Speed Internet", "Internet of Things",
  "Big Data", "Artificial Intelligence", "Cloud Computing",
)

#context {
  // 逐字实测字宽（单位 pt），用于把弧段文字均匀铺在圆弧上
  let band-w = (:)
  for lab in BAND-LABELS {
    band-w.insert(lab, lab.clusters().map(ch => measure(
      text(font: FONT, size: BAND-FS, weight: "bold", ch),
    ).width))
  }

  canvas(length: UNIT, {
    import draw: *

    // 一、配色与线型（单色线稿）
    let INK = rgb("#141414")   // 全部线条墨色
    let BAND = rgb("#e6e6e6")  // 圆环带填充（浅灰，用于区分环带）
    let DISK = rgb("#f0f0f0")  // 底部圆形图标底盘
    let ARROW = rgb("#f3f3f3") // 两侧大箭头填充（比环带更浅，避免与环带粘连）

    let LW-OUT = 0.9pt   // 大圆外轮廓、机床外壳
    let LW-MID = 0.8pt   // 外框、大箭头、图标底盘、引出线
    let LW-IN = 0.7pt    // 圆环内轮廓、扇区辐条、图标主线
    let LW-FINE = 0.6pt  // 刻度、按键、孔位等细节

    let st(w) = (paint: INK, thickness: w, cap: "round")

    // 二、几何参数（避免散落魔数）
    let R = 4.30                 // 大圆外半径
    let BW = 0.78                // 圆环带宽度
    let RI = R - BW              // 环内半径
    let LC = (6.20, 14.10)       // 左圆（Physical System）圆心
    let DC = (18.00, 14.10)      // 右圆（Digital System）圆心
    let MIDX = (LC.at(0) + DC.at(0)) / 2   // 两圆中线 x
    let R-ICON = 2.97            // 扇区内图标的放置半径
    let R-LBL = 2.10             // 扇区文字标签的放置半径
    let R-SQ = 1.80              // 左圆内菱形（顶点在 0°/90°/180°/270°）
    let R-PENT = 1.95            // 右圆内五边形（顶点在扇区边界上）
    let FRAME = (1.35, 8.95, 22.85, 19.05)  // 虚线外框：左、下、右、上
    let BOT-Y = 6.55             // 底部六个圆图标圆心高度
    let BOT-X = range(6).map(i => 2.35 + i * (21.65 - 2.35) / 5)  // 六个圆心 x
    let BUS-Y = 8.52             // 底部图标的引出母线高度

    // 三、几何小工具
    // 极坐标取点：圆心 c、半径 r、角度 a
    let pol(c, r, a) = (c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a))

    // 圆弧采样点：把角度区间按步长采样成多点折线
    let arc-pts(c, r, a0, a1, step: 2.5deg) = {
      let n = calc.max(2, calc.ceil(calc.abs(a1 - a0) / step))
      range(0, n + 1).map(i => pol(c, r, a0 + (a1 - a0) * i / n))
    }

    // 圆弧折线（可带箭头）：外圈弧段、扇区弧、图标内的圆环都由它生成
    let arc-line(c, r, a0, a1, stroke: st(LW-IN), mark: none, step: 2.5deg) = {
      let pts = arc-pts(c, r, a0, a1, step: step)
      if mark == none { line(..pts, stroke: stroke) } else { line(..pts, stroke: stroke, mark: mark) }
    }

    // 以 c 为原点的局部直角坐标：ang 为主轴方向，a 轴向距离，b 横向距离
    let loc(c, ang, a, b) = (
      c.at(0) + a * calc.cos(ang) - b * calc.sin(ang),
      c.at(1) + a * calc.sin(ang) + b * calc.cos(ang),
    )

    // 倾斜矩形四角：中心 c、方向 ang、长 len、宽 w
    let bar(c, ang, len, w) = (
      loc(c, ang, len / 2, w / 2), loc(c, ang, len / 2, -w / 2),
      loc(c, ang, -len / 2, -w / 2), loc(c, ang, -len / 2, w / 2),
    )

    // 旋转椭圆折线：中心 c、半轴 rx/ry、主轴角 rot（原子轨道用）
    let ellipse-path(c, rx, ry, rot: 0deg, n: 60) = range(n).map(i => {
      let t = 360deg * i / n
      loc(c, rot, rx * calc.cos(t), ry * calc.sin(t))
    })

    // 切向文字角度：折到 (-90°, 90°]，保证任何位置的直排标签都不倒置
    let tangent(a) = {
      let t = a - 90deg
      while t > 90deg { t -= 180deg }
      while t <= -90deg { t += 180deg }
      t
    }

    // 直排文字
    let txt(p, body, size: 7pt, weight: "regular", angle: 0deg) = content(
      p, anchor: "center", angle: angle, text(size: size, weight: weight, fill: INK, body),
    )

    // 弧段文字：逐字贴合圆弧（字宽为实测值），上半圈字顶朝外、下半圈字顶朝内，
    // 单字旋转夹在 ±90° 内，因此弧段标签既不会越出环带，也不会倒置。
    let arc-text(c, r, label, mid) = {
      let ws = band-w.at(label).map(w => w / UNIT)   // 每字宽度（画布单位）
      let total = ws.sum()
      let dir = if calc.sin(mid) >= 0 { -1 } else { 1 }   // 上半圈逆时针、下半圈顺时针阅读
      let half = total / 2 / r * 1rad
      for k in range(ws.len()) {
        let d = ws.slice(0, k).sum(default: 0) + ws.at(k) / 2
        let a = mid - dir * half + dir * d / r * 1rad
        let phi0 = if dir < 0 { a - 90deg } else { a + 90deg }
        let phi1 = phi0 - calc.round(phi0 / 360deg) * 360deg
        let phi = if phi1 > 90deg { 90deg } else if phi1 < -90deg { -90deg } else { phi1 }
        content(
          pol(c, r, a), anchor: "center", angle: phi,
          text(size: BAND-FS, weight: "bold", fill: INK, label.clusters().at(k)),
        )
      }
    }

    // 四、图标小工具
    // 齿轮轮廓：teeth 个齿（每齿 4 个采样点交替内外半径）+ 轴孔
    let gear(c, r, teeth: 8, tooth-h: 0.30, stroke: st(LW-FINE)) = {
      let pts = range(teeth * 4).map(i => {
        let a = 360deg * i / (teeth * 4)
        let outer = calc.rem(i, 4) < 2
        pol(c, if outer { r } else { r * (1 - tooth-h) }, a)
      })
      line(..pts, close: true, stroke: stroke)
      circle(c, radius: r * 0.42, stroke: stroke)
    }

    // 五、图标函数（照片 / 实心剪影 → 线稿）

    // 铅笔 + 直尺：Redesign（重新设计）
    let icon-sensing(c, s: 0.48) = {
      // 铅笔：细长笔杆 + 削尖笔头 + 笔箍，斜跨半个图标
      let pen-a = 62deg
      let pen-c = loc(c, pen-a, 0.05, 0.02)
      line(..bar(pen-c, pen-a, 1.86 * s, 0.30 * s), close: true, stroke: st(LW-IN))
      let tip = loc(pen-c, pen-a, -0.93 * s, 0)
      line(loc(pen-c, pen-a, -0.60 * s, 0.15 * s), tip, loc(pen-c, pen-a, -0.60 * s, -0.15 * s), stroke: st(LW-IN))
      line(loc(pen-c, pen-a, 0.60 * s, 0.15 * s), loc(pen-c, pen-a, 0.60 * s, -0.15 * s), stroke: st(LW-FINE))
      // 直尺：较短、偏右下，与铅笔交叉后两端仍露在外面，刻度画在上沿
      let ruler-c = loc(c, -18deg, 0.14, 0.16)
      let ruler-a = -18deg
      line(..bar(ruler-c, ruler-a, 1.22 * s, 0.32 * s), close: true, stroke: st(LW-IN))
      for i in range(4) {
        let t = -0.40 + i * 0.27
        line(loc(ruler-c, ruler-a, t * s, 0.16 * s), loc(ruler-c, ruler-a, t * s, 0.03 * s), stroke: st(LW-FINE))
      }
    }

    // 温度计：Perception（感知）
    let icon-thermometer(c, s: 0.48) = {
      let (cx, cy) = c
      // 球泡与玻璃管
      circle((cx, cy - 0.54 * s), radius: 0.29 * s, stroke: st(LW-IN))
      line(
        (cx - 0.14 * s, cy - 0.34 * s), (cx - 0.14 * s, cy + 0.86 * s),
        (cx + 0.14 * s, cy + 0.86 * s), (cx + 0.14 * s, cy - 0.34 * s),
        stroke: st(LW-IN),
      )
      // 水银柱
      line((cx, cy - 0.50 * s), (cx, cy + 0.44 * s), stroke: st(LW-MID))
      // 右侧刻度
      for i in range(4) {
        line(
          (cx + 0.14 * s, cy + (0.02 + i * 0.22) * s),
          (cx + 0.33 * s, cy + (0.02 + i * 0.22) * s),
          stroke: st(LW-FINE),
        )
      }
    }

    // 扳手：Maintenance（维护）
    let icon-wrench(c, s: 0.48) = {
      let a = 45deg
      // 手柄（短而粗）
      line(..bar(loc(c, a, -0.40 * s, 0), a, 0.90 * s, 0.26 * s), close: true, stroke: st(LW-IN))
      // 开口头：大圆头 + 宽开口 + 平口颚板（头部直径远大于手柄，避免看成钥匙）
      let h = loc(c, a, 0.15 * s, 0)
      let rr = 0.62 * s
      arc-line(h, rr, a + 55deg, a + 305deg, stroke: st(LW-IN), step: 4deg)
      for sgn in (-1, 1) {
        line(
          pol(h, rr, a + sgn * 55deg),
          pol(h, rr * 1.22, a + sgn * 55deg),
          pol(h, rr * 1.22, a + sgn * 38deg),
          stroke: st(LW-IN),
        )
      }
    }

    // 原子轨道：Connection（连接）
    let icon-atom(c, s: 0.48) = {
      for k in range(3) {
        line(..ellipse-path(c, 0.88 * s, 0.30 * s, rot: k * 60deg), close: true, stroke: st(LW-IN))
      }
      circle(c, radius: 0.10 * s, fill: INK, stroke: none)
    }

    // 柱状图 + 趋势线：Prognosis（预测）
    let icon-chart(c, s: 0.48) = {
      let (cx, cy) = c
      // 坐标轴
      line(
        (cx - 0.80 * s, cy + 0.72 * s), (cx - 0.80 * s, cy - 0.64 * s),
        (cx + 0.84 * s, cy - 0.64 * s),
        stroke: st(LW-IN),
      )
      // 三根递增的柱子
      for (i, h) in (0.40, 0.68, 0.96).enumerate() {
        let x = cx - 0.62 * s + i * 0.42 * s
        rect((x, cy - 0.64 * s), (x + 0.24 * s, cy - 0.64 * s + h * s), stroke: st(LW-FINE))
      }
      // 趋势折线与折点
      let pts = (
        (cx - 0.60 * s, cy - 0.02 * s), (cx - 0.26 * s, cy + 0.26 * s),
        (cx + 0.06 * s, cy + 0.12 * s), (cx + 0.40 * s, cy + 0.56 * s),
      )
      line(..pts, stroke: st(LW-IN))
      for p in pts { circle(p, radius: 0.055, fill: INK, stroke: none) }
    }

    // 循环箭头：Data Fusion（数据融合）
    let icon-loop(c, s: 0.48) = {
      let r = 0.72 * s
      arc-line(c, r, 200deg, 342deg, stroke: st(LW-IN), mark: (end: ">", fill: INK, scale: 0.7))
      arc-line(c, r, 20deg, 162deg, stroke: st(LW-IN), mark: (end: ">", fill: INK, scale: 0.7))
      circle(c, radius: 0.11 * s, fill: INK, stroke: none)
    }

    // 人头 + 齿轮：Self-Learning（自学习）
    // 源图为黑色侧脸剪影 + 脑内齿轮；此处改为“圆头像 + 齿轮 + 肩弧”，缩小后轮廓更清楚
    let icon-ai(c, s: 0.48) = {
      let (cx, cy) = c
      let h = (cx, cy + 0.16 * s)   // 头部圆心
      circle(h, radius: 0.56 * s, stroke: st(LW-IN))
      // 头内的齿轮
      gear(h, 0.32 * s, teeth: 7, tooth-h: 0.34)
      // 双肩弧：位于头部正下方，暗示人形
      arc-line((cx, cy + 0.70 * s), 1.42 * s, 232deg, 308deg, stroke: st(LW-IN), step: 5deg)
    }

    // 计算器：Computing（计算）
    let icon-calc(c, s: 0.48) = {
      let (cx, cy) = c
      rect(
        (cx - 0.54 * s, cy - 0.84 * s), (cx + 0.54 * s, cy + 0.84 * s),
        radius: 0.10 * s, stroke: st(LW-IN),
      )
      // 显示屏
      rect((cx - 0.38 * s, cy + 0.36 * s), (cx + 0.38 * s, cy + 0.68 * s), stroke: st(LW-FINE))
      // 3×3 按键
      for i in range(3) {
        for j in range(3) {
          circle(
            (cx - 0.30 * s + i * 0.30 * s, cy - 0.08 * s - j * 0.24 * s),
            radius: 0.055, fill: INK, stroke: none,
          )
        }
      }
    }

    // 笔记本电脑：Analyze System Characteristics（分析系统特征）
    let icon-laptop(c, s: 0.48) = {
      let (cx, cy) = c
      // 屏幕外框与内屏
      rect(
        (cx - 0.70 * s, cy - 0.02 * s), (cx + 0.70 * s, cy + 0.82 * s),
        radius: 0.07 * s, stroke: st(LW-IN),
      )
      rect((cx - 0.58 * s, cy + 0.10 * s), (cx + 0.58 * s, cy + 0.70 * s), stroke: st(LW-FINE))
      // 屏内三行“数据”
      for (i, w) in (0.44, 0.34, 0.24).enumerate() {
        let yy = cy + (0.56 - i * 0.15) * s
        line((cx - 0.46 * s, yy), (cx - 0.46 * s + w * s, yy), stroke: st(LW-FINE))
      }
      // 键盘底座（梯形）与触控板
      line(
        (cx - 0.70 * s, cy - 0.02 * s), (cx + 0.70 * s, cy - 0.02 * s),
        (cx + 0.90 * s, cy - 0.34 * s), (cx - 0.90 * s, cy - 0.34 * s), close: true,
        stroke: st(LW-IN),
      )
      line((cx - 0.16 * s, cy - 0.24 * s), (cx + 0.16 * s, cy - 0.24 * s), stroke: st(LW-FINE))
    }

    // 三维立方体：System 3D Visualization VR/AR
    let icon-cube(c, s: 0.48) = {
      let (cx, cy) = c
      let d = 0.42 * s   // 透视方向位移
      let front = ((-0.70, -0.62), (0.02, -0.62), (0.02, 0.10), (-0.70, 0.10))
      let f = front.map(p => (cx + p.at(0) * s, cy + p.at(1) * s))
      let b = f.map(p => (p.at(0) + d, p.at(1) + d))
      line(..f, close: true, stroke: st(LW-IN))
      line(..b, close: true, stroke: st(LW-FINE))
      for i in range(4) { line(f.at(i), b.at(i), stroke: st(LW-FINE)) }
    }

    // 文件夹 + 放大镜：System Data Integration（系统数据集成）
    let icon-data(c, s: 0.48) = {
      let (cx, cy) = c
      // 带标签页的文件夹
      line(
        (cx - 0.85 * s, cy + 0.22 * s), (cx - 0.85 * s, cy + 0.44 * s),
        (cx - 0.30 * s, cy + 0.44 * s), (cx - 0.18 * s, cy + 0.22 * s),
        (cx + 0.42 * s, cy + 0.22 * s), (cx + 0.42 * s, cy - 0.70 * s),
        (cx - 0.85 * s, cy - 0.70 * s), close: true,
        stroke: st(LW-IN),
      )
      // 放大镜：白色镜片压住文件夹，形成前后遮挡
      let g = (cx + 0.30 * s, cy - 0.12 * s)
      circle(g, radius: 0.34 * s, fill: white, stroke: st(LW-IN))
      line(
        (g.at(0) + 0.25 * s, g.at(1) - 0.25 * s), (g.at(0) + 0.60 * s, g.at(1) - 0.60 * s),
        stroke: st(LW-MID),
      )
      // 镜片高光
      line(
        (g.at(0) - 0.20 * s, g.at(1) + 0.14 * s), (g.at(0) - 0.10 * s, g.at(1) + 0.22 * s),
        stroke: st(LW-FINE),
      )
    }

    // 法槌：Intelligent Decision Making（智能决策）
    let icon-gavel(c, s: 0.48) = {
      let (cx, cy) = c
      // 槌头（斜置长方块 + 两道箍线）
      let head = (cx - 0.22 * s, cy + 0.46 * s)
      line(..bar(head, 12deg, 0.86 * s, 0.40 * s), close: true, stroke: st(LW-IN))
      for k in (-0.24, 0.24) {
        line(loc(head, 12deg, k * s, 0.20 * s), loc(head, 12deg, k * s, -0.20 * s), stroke: st(LW-FINE))
      }
      // 手柄（向右下伸出）
      line(..bar((cx + 0.18 * s, cy - 0.10 * s), -52deg, 1.02 * s, 0.16 * s), close: true, stroke: st(LW-IN))
      // 底座（双层敲击台）
      line((cx - 0.72 * s, cy - 0.64 * s), (cx + 0.72 * s, cy - 0.64 * s), stroke: st(LW-IN))
      line((cx - 0.55 * s, cy - 0.82 * s), (cx + 0.55 * s, cy - 0.82 * s), stroke: st(LW-IN))
      line((cx - 0.72 * s, cy - 0.64 * s), (cx - 0.72 * s, cy - 0.82 * s), stroke: st(LW-FINE))
      line((cx + 0.72 * s, cy - 0.64 * s), (cx + 0.72 * s, cy - 0.82 * s), stroke: st(LW-FINE))
    }

    // 靶心 + 箭：System Optimization Operation（系统优化运行）
    let icon-target(c, s: 0.48) = {
      for r in (0.86, 0.58, 0.30) { circle(c, radius: r * s, stroke: st(LW-IN)) }
      // 箭从左上射向靶心
      let tail = (c.at(0) - 0.96 * s, c.at(1) + 0.96 * s)
      let tip = (c.at(0) + 0.02 * s, c.at(1) - 0.02 * s)
      line(tail, tip, stroke: st(LW-IN), mark: (end: ">", fill: INK, scale: 0.6))
      // 尾羽
      line(tail, (tail.at(0) + 0.22 * s, tail.at(1) + 0.02 * s), stroke: st(LW-FINE))
      line(tail, (tail.at(0) - 0.02 * s, tail.at(1) - 0.22 * s), stroke: st(LW-FINE))
    }

    // 公文包 + 医疗十字：System Health Management（系统健康管理）
    let icon-health(c, s: 0.48) = {
      let (cx, cy) = c
      // 箱体与提手
      rect(
        (cx - 0.78 * s, cy - 0.52 * s), (cx + 0.78 * s, cy + 0.34 * s),
        radius: 0.10 * s, stroke: st(LW-IN),
      )
      line(
        (cx - 0.30 * s, cy + 0.34 * s), (cx - 0.30 * s, cy + 0.54 * s),
        (cx + 0.30 * s, cy + 0.54 * s), (cx + 0.30 * s, cy + 0.34 * s),
        stroke: st(LW-IN),
      )
      // 医疗十字
      line((cx, cy - 0.44 * s), (cx, cy + 0.24 * s), stroke: st(LW-OUT))
      line((cx - 0.34 * s, cy - 0.10 * s), (cx + 0.34 * s, cy - 0.10 * s), stroke: st(LW-OUT))
    }

    // 加工中心（机床）：两个圆心处的实体设备，源图是机床照片
    let icon-machine(c) = {
      let (cx, cy) = c
      let sw = 1.05   // 机身半宽
      let sh = 0.55   // 机身半高
      let wx = cx + 0.28   // 观察窗右边
      rect((cx - sw, cy - sh), (cx + sw, cy + sh), radius: 0.07, stroke: st(LW-OUT))
      // 顶部主轴电动机罩
      rect((cx - 0.62, cy + sh), (cx + 0.02, cy + sh + 0.11), stroke: st(LW-FINE))
      // 前观察窗
      rect((cx - sw + 0.10, cy - sh + 0.12), (wx, cy + sh - 0.08), stroke: st(LW-FINE))
      // 窗内：主轴箱 → 主轴 → 刀具（自上而下）
      rect((cx - 0.58, cy + 0.06), (cx - 0.24, cy + sh - 0.16), stroke: st(LW-FINE))
      line((cx - 0.41, cy + 0.06), (cx - 0.41, cy - 0.02), (cx - 0.47, cy - 0.10),
        (cx - 0.35, cy - 0.10), close: true, stroke: st(LW-FINE))
      // 窗内：工作台（含 T 形槽）与工件
      line((cx - 0.86, cy - 0.20), (cx - 0.02, cy - 0.20), stroke: st(LW-FINE))
      line((cx - 0.80, cy - 0.26), (cx - 0.08, cy - 0.26), stroke: st(LW-FINE))
      rect((cx - 0.52, cy - 0.20), (cx - 0.30, cy - 0.02), stroke: st(LW-FINE))
      // 右侧操作面板：显示屏 + 两排按键
      rect((cx + 0.38, cy - 0.34), (cx + sw - 0.10, cy + 0.20), stroke: st(LW-FINE))
      rect((cx + 0.46, cy + 0.02), (cx + sw - 0.18, cy + 0.14), stroke: st(LW-FINE))
      for i in range(3) {
        circle((cx + 0.48 + i * 0.16, cy - 0.10), radius: 0.04, fill: INK, stroke: none)
        circle((cx + 0.48 + i * 0.16, cy - 0.24), radius: 0.04, fill: INK, stroke: none)
      }
      // 底座与地脚
      line((cx - sw - 0.03, cy - sh - 0.13), (cx + sw + 0.03, cy - sh - 0.13), stroke: st(LW-MID))
      for dx in (-sw - 0.03, sw + 0.03, -sw + 0.14, sw - 0.14) {
        line((cx + dx, cy - sh - 0.13), (cx + dx, cy - sh), stroke: st(LW-FINE))
      }
    }

    // 六、圆弧粗箭头
    // 环形带 + 三角箭头：c 弧圆心、r 弧半径、a0 尾端角、a1 头端角（角减小即顺时针）
    let big-arrow(c, r, a0, a1) = {
      let hw = 0.24   // 箭头带半宽
      let hl = 0.62   // 箭头长度
      let hh = 0.42   // 箭头底半宽
      let sgn = if a1 > a0 { 1 } else { -1 }
      let a-head = a1 - sgn * (hl / r) * 1rad      // 箭头底部所在角
      let base = pol(c, r, a-head)
      let u = (-calc.sin(a1) * sgn, calc.cos(a1) * sgn)   // 头端切向单位矢量
      let tip = (base.at(0) + u.at(0) * hl, base.at(1) + u.at(1) * hl)
      line(
        ..arc-pts(c, r + hw, a0, a-head, step: 1.5deg),
        pol(c, r + hh, a-head), tip, pol(c, r - hh, a-head),
        ..arc-pts(c, r - hw, a0, a-head, step: 1.5deg).rev(),
        close: true, fill: ARROW, stroke: (paint: INK, thickness: LW-MID, cap: "round"),
      )
    }

    // 七、外框
    rect(
      (FRAME.at(0), FRAME.at(1)), (FRAME.at(2), FRAME.at(3)),
      radius: 0.55, stroke: (paint: INK, thickness: LW-MID, dash: "dashed"),
    )

    // 八、两个大圆
    // 圆环带：外圆（浅灰填充）+ 内圆 + 弧段分隔线 + 逐字贴弧的弧段标签
    let draw-ring(c, segs) = {
      circle(c, radius: R, fill: BAND, stroke: st(LW-OUT))
      circle(c, radius: RI, fill: white, stroke: st(LW-IN))
      for seg in segs {
        line(pol(c, RI, seg.from), pol(c, R, seg.from), stroke: st(LW-FINE))
        arc-text(c, (R + RI) / 2, seg.name, (seg.from + seg.to) / 2)
      }
    }

    // 扇区辐条：从内侧多边形边界引到环内圆
    let spoke(c, a, r-start) = line(pol(c, r-start, a), pol(c, RI, a), stroke: st(LW-IN))

    // 内侧正多边形（左：菱形 / 右：五边形）
    let poly-line(c, n, r, a0: 0deg) = {
      let pts = range(n).map(i => pol(c, r, a0 + 360deg * i / n))
      line(..pts, close: true, stroke: st(LW-IN))
    }

    // 左圆：Physical System
    // 外圈四段弧标签（顶部 / 左侧 / 左下 / 右下）
    draw-ring(LC, (
      (from: 35deg, to: 140deg, name: "Advanced Sensing"),
      (from: 140deg, to: 185deg, name: "Network"),
      (from: 185deg, to: 260deg, name: "High Speed Internet"),
      (from: 260deg, to: 395deg, name: "Internet of Things"),
    ))
    // 四扇区：分隔线在 0°/90°/180°/270°（源图为水平 + 垂直十字线），
    // 辐条从菱形四个顶点引出；扇区因此是四个象限。
    for a in (0deg, 90deg, 180deg, 270deg) { spoke(LC, a, R-SQ) }
    poly-line(LC, 4, R-SQ, a0: 0deg)
    // 扇区标签：沿两条对角线排布（Redesign 左上 / Perception 右上 /
    // Maintenance 左下 / Connection 右下）
    for (a, name) in (
      (135deg, [Redesign]), (45deg, [Perception]),
      (225deg, [Maintenance]), (315deg, [Connection]),
    ) {
      txt(pol(LC, R-LBL, a), name, size: 7.6pt, angle: tangent(a))
    }
    // 扇区图标：铅笔尺 / 温度计 / 扳手 / 原子
    icon-sensing(pol(LC, R-ICON, 135deg), s: 0.50)
    icon-thermometer(pol(LC, R-ICON, 45deg))
    icon-wrench(pol(LC, R-ICON, 225deg), s: 0.54)
    icon-atom(pol(LC, R-ICON, 315deg))
    // 圆心机床
    icon-machine(LC)

    // 右圆：Digital System
    // 外圈三段弧标签（顶部 / 左侧 / 右侧）
    draw-ring(DC, (
      (from: 40deg, to: 145deg, name: "Big Data"),
      (from: 145deg, to: 245deg, name: "Artificial Intelligence"),
      (from: 245deg, to: 400deg, name: "Cloud Computing"),
    ))
    // 五扇区（边界 18°/90°/162°/234°/306°），辐条从五边形顶点引出
    for a in (18deg, 90deg, 162deg, 234deg, 306deg) { spoke(DC, a, R-PENT) }
    poly-line(DC, 5, R-PENT, a0: 18deg)
    // 扇区标签（Prognosis 左上 / Data Fusion 右上 / Diagnosis 右下 /
    // Computing 下方 / Self-Learning 左）
    for (a, name) in (
      (126deg, [Prognosis]), (54deg, [Data Fusion]), (342deg, [Diagnosis]),
      (270deg, [Computing]), (198deg, [Self-Learning]),
    ) {
      txt(pol(DC, R-LBL, a), name, size: 7.4pt, angle: tangent(a))
    }
    // 扇区图标：柱状图 / 循环箭头 / 文件夹+放大镜 / 人头+齿轮 / 计算器
    icon-chart(pol(DC, R-ICON, 126deg))
    icon-loop(pol(DC, R-ICON, 54deg), s: 0.52)
    icon-data(pol(DC, R-ICON, 342deg))
    icon-ai(pol(DC, R-ICON, 198deg), s: 0.50)
    icon-calc(pol(DC, R-ICON, 270deg))
    // 圆心机床
    icon-machine(DC)

    // 九、两条大箭头与圆外文字
    // 顶部 Digital mapping：左 → 右（弧心在下方，箭头落在右圆上沿）
    big-arrow((MIDX, 8.87), 9.08, 110.2deg, 69.8deg)
    // 底部 Feedback driving：右 → 左（弧心在上方，箭头落在左圆下沿）
    big-arrow((MIDX, 19.33), 9.08, -69.8deg, -110.2deg)
    txt((MIDX, 18.62), [Digital mapping], size: 9pt, weight: "bold")
    txt((MIDX, 9.45), [Feedback driving], size: 9pt, weight: "bold")

    // 两个系统名（圆下方、外框内）
    txt((LC.at(0), 9.45), [Physical System], size: 9.5pt, weight: "bold")
    txt((DC.at(0), 9.45), [Digital System], size: 9.5pt, weight: "bold")

    // 十、下方六个能力图标
    // 引出线：外框中点 → 竖直短线 → 水平母线 → 六条下垂线
    line((MIDX, FRAME.at(1)), (MIDX, BUS-Y), stroke: st(LW-MID))
    line((BOT-X.first(), BUS-Y), (BOT-X.last(), BUS-Y), stroke: st(LW-MID))
    for x in BOT-X {
      line((x, BUS-Y), (x, BOT-Y + 0.92), stroke: st(LW-MID))
      circle((x, BOT-Y), radius: 0.92, fill: DISK, stroke: st(LW-MID))
    }

    // 六个图标（与源图顺序一致）
    icon-laptop((BOT-X.at(0), BOT-Y), s: 0.68)
    icon-cube((BOT-X.at(1), BOT-Y), s: 0.70)
    icon-data((BOT-X.at(2), BOT-Y), s: 0.68)
    icon-gavel((BOT-X.at(3), BOT-Y), s: 0.68)
    icon-target((BOT-X.at(4), BOT-Y), s: 0.68)
    icon-health((BOT-X.at(5), BOT-Y), s: 0.66)

    // 六个图标下方的多行说明文字（统一 north 对齐，首行齐平）
    let cap(x, body) = content(
      (x, BOT-Y - 1.14), anchor: "north",
      align(center, text(size: 7.2pt, fill: INK, body)),
    )
    cap(BOT-X.at(0), [Analyze \ System \ Characteristics])
    cap(BOT-X.at(1), [System 3D \ Visualization \ VR/AR])
    cap(BOT-X.at(2), [System Data \ Integration])
    cap(BOT-X.at(3), [Intelligent \ Decision Making])
    cap(BOT-X.at(4), [System \ Optimization \ Operation])
    cap(BOT-X.at(5), [System Health \ Management])
  })
}
