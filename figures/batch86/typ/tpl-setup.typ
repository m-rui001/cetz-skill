// TPL（双光子聚合）3D 打印系统光路 + 体素阈值示意图
// 源图：Two-Photon Polymerization Lithography for Optics and Photonics
//       (Advanced Functional Materials, 2023)  Fig. 2
//       "A typical setup of TPL 3D printing fabrication system"
//
// 左 (a) 光路：
//   Laser → Attenuator → Expander → Shutter → Scanning galvanometer
//   → Mirror → Dichroic → Objective lens → 基板 / Piezostage
//   LED → Mirror → 样品（透射照明）；成像：Dichroic → Lens → CCD
// 右 (b) 剖面示意：Substrate / Uncured resist / Cured resist（椭球体素）
//   + 激光会聚光锥 + 右侧 Intensity–Absorption 阈值曲线
//
// 线型约定：激发光 = 红色实线；照明光 / 成像光 = 黄绿色虚线；
//           结构线 = 0.6–0.8pt 黑色线稿，透镜 / 分光片允许浅灰填充。
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Segoe UI", "Times New Roman"), size: 6.8pt)

#canvas(length: 0.5cm, {
  import draw: *

  // 配色与线型
  let INK = rgb("#1b1b1b") // 结构线墨色
  let LENSF = rgb("#e8e8e8") // 透镜 / 棱镜浅灰填充
  let EXC = rgb("#b8352a") // 激发光：红
  let ILL = rgb("#7c8b1e") // 照明 / 成像光：黄绿
  let AUX = rgb("#5fa8d3") // 蓝色指示箭头
  let TEAL = rgb("#2f8fa8") // (b) 外框虚线
  let SPEC = rgb("#8592a5") // 分光膜线
  let BEAMF = rgb("#d08a86") // 光锥内部剖面线

  let THIN = (paint: INK, thickness: 0.6pt)
  let MAIN = (paint: INK, thickness: 0.7pt)
  let BOLD = (paint: INK, thickness: 0.8pt)
  let DASH = (paint: INK, thickness: 0.6pt, dash: (2.4pt, 1.6pt))

  // 标签：统一字号，可指定锚点与旋转角
  let lbl(pos, body, anchor: "center", size: 6.8pt, fill: INK, angle: 0deg) = content(
    pos,
    anchor: anchor,
    angle: angle,
    text(size: size, fill: fill, body),
  )

  // 光路助手：points 为一条折线的全部拐点；dashed: true 时画照明 / 成像光
  let beam(points, dashed: false, color: EXC, thickness: 0.75pt) = {
    if dashed {
      line(..points, stroke: (paint: ILL, thickness: thickness, dash: (2.2pt, 1.4pt)))
    } else {
      line(..points, stroke: (paint: color, thickness: thickness))
    }
  }

  // 斜置薄片：以中心、倾角、长度、厚度画平行四边形（镜片 / 二向色镜 / 滤片）
  let plate(cx, cy, ang: 0deg, len: 1.5, th: 0.12, fill: LENSF) = {
    let ux = calc.cos(ang) * len / 2
    let uy = calc.sin(ang) * len / 2
    let nx = -calc.sin(ang) * th / 2
    let ny = calc.cos(ang) * th / 2
    line(
      (cx - ux - nx, cy - uy - ny),
      (cx + ux - nx, cy + uy - ny),
      (cx + ux + nx, cy + uy + ny),
      (cx - ux + nx, cy - uy + ny),
      close: true,
      stroke: MAIN,
      fill: fill,
    )
  }

  // 双凸透镜：闭合光顺曲线 + 浅灰填充
  let lens(cx, cy, h: 0.45, t: 0.20) = catmull(
    (cx, cy - h),
    (cx + t, cy - h * 0.55),
    (cx + t, cy + h * 0.55),
    (cx, cy + h),
    (cx - t, cy + h * 0.55),
    (cx - t, cy - h * 0.55),
    close: true,
    stroke: MAIN,
    fill: LENSF,
  )

  // 三维薄板：前面矩形 + 顶面 / 右面平行四边形（基板、压电台、树脂块）
  let slab3d(x, y, w, h, d, fill: white) = {
    rect((x, y), (x + w, y + h), stroke: MAIN, fill: fill)
    line((x, y + h), (x + d, y + h + d), (x + w + d, y + h + d), (x + w, y + h), stroke: MAIN)
    line((x + w, y), (x + w + d, y + d), (x + w + d, y + h + d), stroke: MAIN)
  }

  // (a) 布局常量
  let AY = 9.15 // 激光—扩束段光轴高度
  let COL = 15.20 // 竖直光轴：Dichroic / Objective / Lens / CCD
  let DI = (COL, 9.35) // 二向色镜中心
  let MI = (12.90, 12.30) // 上反射镜中心
  let GV = (12.90, 7.35) // 扫描振镜反射点
  let SH = (10.30, 8.55) // 快门中心
  let MI2 = (16.40, 2.35) // 下反射镜中心
  let SAMP = 5.48 // 基板表面高度（压电台顶面）
  let OBJ_TOP = 7.80 // 物镜顶面
  let CCD_BOT = 11.90 // CCD 机身底面
  let IMG_LENS = 11.15 // 成像透镜中心高度

  // (a) 光学元件

  // 激光器：飞秒激光头（外壳 + 出光接口）
  let laser(x, y, w: 3.60, h: 1.60) = {
    let d = 0.30
    rect((x, y), (x + w, y + h), stroke: MAIN, fill: white)
    line((x, y + h), (x + d, y + h + d), (x + w + d, y + h + d), (x + w, y + h), stroke: MAIN)
    line((x + w, y), (x + w + d, y + d), (x + w + d, y + h + d), stroke: MAIN)
    // 前面板分隔线
    line((x + 0.30, y + 0.34), (x + 1.65, y + 0.34), stroke: THIN)
    line((x + 0.30, y + 0.54), (x + 1.10, y + 0.54), stroke: THIN)
    // 出光接口
    rect((x + w, y + h / 2 - 0.10), (x + w + 0.42, y + h / 2 + 0.10), stroke: MAIN, fill: LENSF)
    circle((x + w + 0.30, y + h / 2), radius: 0.045, fill: EXC, stroke: none)
  }

  // 衰减片：可调中性密度滤光轮 + 支杆
  let attenuator(cx, cy) = {
    rect((cx - 0.42, cy - 0.40), (cx + 0.42, cy + 0.40), stroke: MAIN, fill: white)
    plate(cx, cy, ang: 62deg, len: 0.72, th: 0.09) // 滤光片
    line((cx, cy - 0.40), (cx, cy - 0.76), stroke: THIN) // 支杆
    line((cx - 0.28, cy - 0.76), (cx + 0.28, cy - 0.76), stroke: THIN) // 底座
  }

  // 扩束镜：小双凸透镜 + 发散光锥 + 大双凸透镜
  let beam-expander(x0, cy) = {
    let x1 = x0 + 2.05
    // 发散光锥
    line((x0 + 0.10, cy - 0.15), (x1 - 0.04, cy - 0.56), stroke: (paint: EXC, thickness: 0.6pt))
    line((x0 + 0.10, cy + 0.15), (x1 - 0.04, cy + 0.56), stroke: (paint: EXC, thickness: 0.6pt))
    // 入端小透镜、出端大透镜
    lens(x0 + 0.05, cy, h: 0.25, t: 0.11)
    lens(x1, cy, h: 0.58, t: 0.16)
    // 镜架
    line((x0 + 0.05, cy - 0.27), (x0 + 0.05, cy - 0.62), stroke: THIN)
    line((x0 - 0.16, cy - 0.62), (x1 + 0.16, cy - 0.62), stroke: THIN)
  }

  // 快门：转盘叶片（朝光束方向留通光缺口）+ 支架
  let shutter(cx, cy) = {
    let r = 0.34
    arc(
      (cx + r * calc.cos(38deg), cy + r * calc.sin(38deg)),
      start: 38deg,
      stop: 322deg,
      radius: r,
      stroke: MAIN,
      fill: white,
    )
    line((cx, cy), (cx + r * calc.cos(38deg), cy + r * calc.sin(38deg)), stroke: MAIN)
    line((cx, cy), (cx + r * calc.cos(322deg), cy + r * calc.sin(322deg)), stroke: MAIN)
    circle((cx, cy), radius: 0.045, fill: INK, stroke: none) // 转轴
    // 支架
    line((cx, cy - r), (cx, cy - r - 0.22), stroke: THIN)
    line(
      (cx - 0.32, cy - r - 0.62),
      (cx + 0.32, cy - r - 0.62),
      (cx + 0.15, cy - r - 0.26),
      (cx - 0.15, cy - r - 0.26),
      close: true,
      stroke: THIN,
      fill: white,
    )
  }

  // 反射镜：斜置薄片 + 正面镜面加粗线
  let mirror(cx, cy, ang: 22.5deg, len: 1.60) = {
    plate(cx, cy, ang: ang, len: len, th: 0.13)
    let ux = calc.cos(ang)
    let uy = calc.sin(ang)
    line(
      (cx - ux * len / 2 + uy * 0.075, cy - uy * len / 2 - ux * 0.075),
      (cx + ux * len / 2 + uy * 0.075, cy + uy * len / 2 - ux * 0.075),
      stroke: BOLD,
    )
  }

  // 扫描振镜：方形外壳 + 一片扫描镜 + 两端转轴 + 驱动电机
  let galvo(cx, cy, s: 1.70) = {
    rect((cx - s / 2, cy - s / 2), (cx + s / 2, cy + s / 2), stroke: MAIN, fill: white)
    plate(cx, cy, ang: 52deg, len: s * 0.94, th: 0.09)
    circle((cx + s * 0.17, cy + s * 0.41), radius: 0.06, stroke: THIN, fill: white)
    circle((cx - s * 0.17, cy - s * 0.41), radius: 0.06, stroke: THIN, fill: white)
    rect((cx + s / 2, cy + s / 2 - 0.34), (cx + s / 2 + 0.30, cy + s / 2), stroke: THIN, fill: white)
  }

  // 二向色镜：斜置分光片（浅灰）+ 分光膜细线
  let dichroic(cx, cy, ang: 19deg, len: 2.20) = {
    plate(cx, cy, ang: ang, len: len, th: 0.12, fill: LENSF)
    let ux = calc.cos(ang)
    let uy = calc.sin(ang)
    for i in range(6) {
      let t = (i / 5 - 0.5) * len * 0.84
      line(
        (cx + ux * t + uy * 0.045, cy + uy * t - ux * 0.045),
        (cx + ux * t + uy * 0.125, cy + uy * t - ux * 0.125),
        stroke: (paint: SPEC, thickness: 0.6pt),
      )
    }
  }

  // 物镜：镜筒 + 刻度环 + 收缩锥 + 前端透镜
  let objective(cx, ytop) = {
    let w = 0.46
    let yb = ytop - 1.50
    let yt = yb - 0.44
    line((cx - w, ytop), (cx - w, yb), (cx + w, yb), (cx + w, ytop), stroke: MAIN)
    line((cx - w, ytop), (cx + w, ytop), stroke: MAIN)
    for i in range(4) {
      line((cx - w, ytop - 0.28 - i * 0.14), (cx + w, ytop - 0.28 - i * 0.14), stroke: THIN)
    }
    // 收缩锥
    line((cx - w, yb), (cx - 0.17, yt), (cx + 0.17, yt), (cx + w, yb), stroke: MAIN)
    // 前端透镜
    line((cx - 0.17, yt), (cx - 0.13, yt - 0.13), (cx + 0.13, yt - 0.13), (cx + 0.17, yt), stroke: MAIN)
  }

  // 压电台 / 基板：底座 + 压电陶瓷（含电极）+ 基板 + 虚线选区
  let piezo-stage(cx, cy, w: 2.60) = {
    let hw = w / 2
    let d = 0.22
    // 底座
    slab3d(cx - hw - 0.10, cy - 0.60, w + 0.20, 0.30, d)
    // 压电陶瓷（多层电极）
    rect((cx - hw + 0.10, cy - 0.30), (cx + hw - 0.10, cy + 0.18), stroke: MAIN, fill: white)
    for i in range(4) {
      line((cx - hw + 0.10, cy - 0.20 + i * 0.095), (cx + hw - 0.10, cy - 0.20 + i * 0.095), stroke: THIN)
    }
    // 基板
    slab3d(cx - hw, cy + 0.18, w, 0.26, d)
    // 虚线选区
    rect((cx - hw - 0.34, cy - 0.80), (cx + hw + 0.52, cy + 0.66), stroke: DASH)
  }

  // CCD 相机：机身 + 镜头接口 + 散热槽
  let ccd(cx, ybot) = {
    let w = 1.45
    let h = 1.00
    let d = 0.24
    rect((cx - w / 2, ybot), (cx + w / 2, ybot + h), stroke: MAIN, fill: white)
    line((cx - w / 2, ybot + h), (cx - w / 2 + d, ybot + h + d),
      (cx + w / 2 + d, ybot + h + d), (cx + w / 2, ybot + h), stroke: MAIN)
    line((cx + w / 2, ybot), (cx + w / 2 + d, ybot + d), (cx + w / 2 + d, ybot + h + d), stroke: MAIN)
    // 镜头接口
    rect((cx - 0.24, ybot - 0.24), (cx + 0.24, ybot), stroke: MAIN, fill: white)
    // 散热槽
    for i in range(3) {
      line((cx - 0.36 + i * 0.36, ybot + 0.22), (cx - 0.36 + i * 0.36, ybot + 0.70), stroke: THIN)
    }
  }

  // LED 光源：灯箱 + 出光口（透射照明）
  let led(x, y, w: 2.00, h: 1.15) = {
    let d = 0.26
    rect((x, y), (x + w, y + h), stroke: MAIN, fill: white)
    line((x, y + h), (x + d, y + h + d), (x + w + d, y + h + d), (x + w, y + h), stroke: MAIN)
    line((x + w, y), (x + w + d, y + d), (x + w + d, y + h + d), stroke: MAIN)
    // 出光口
    rect((x - 0.38, y + h / 2 - 0.13), (x, y + h / 2 + 0.13), stroke: MAIN, fill: white)
    circle((x - 0.24, y + h / 2), radius: 0.07, stroke: THIN, fill: LENSF)
  }

  // (b) 体素剖面与阈值曲线
  // 体素剖面 + 阈值曲线：(b) 整块面板（基板 / 未固化树脂 / 光锥 / 体素 / 曲线）
  let voxel-plot() = {
    // 外框：浅蓝虚线圆角框
    rect((22.30, 1.90), (36.75, 11.50), radius: 0.45, stroke: (paint: TEAL, thickness: 0.7pt, dash: (3pt, 2pt)))

    // 样品剖面：基板 + 未固化树脂块
    let bx = 26.00
    let by = 3.75
    let bw = 4.20
    let bh = 4.55
    let bd = 0.90
    // 基板（块体下方薄板）
    slab3d(bx, by - 0.44, bw, 0.44, bd, fill: white)
    // 未固化树脂块（前面 + 顶面 + 右面）
    rect((bx, by), (bx + bw, by + bh), stroke: MAIN, fill: none)
    line((bx, by + bh), (bx + bd, by + bh + bd), (bx + bw + bd, by + bh + bd), (bx + bw, by + bh), stroke: MAIN)
    line((bx + bw, by), (bx + bw + bd, by + bd), (bx + bw + bd, by + bh + bd), stroke: MAIN)

    // 激光会聚光锥（上方收敛、下方发散）
    let ax = 28.10
    let ay = 6.60
    let ry1 = 9.62 // 上端入射光阑高度
    let ry2 = 3.40 // 下端出射高度
    line((26.80, ry1), (ax, ay), (29.40, ry1), stroke: MAIN)
    line((27.10, ry2), (ax, ay), (29.10, ry2), stroke: MAIN)
    line((27.10, ry2), (29.10, ry2), stroke: THIN)
    // 光锥横向剖面线（表示会聚 / 发散的光束）
    for i in range(3) {
      let t = (i + 1) / 4
      let yu = ry1 + (ay - ry1) * t
      let hu = (29.40 - 26.80) / 2 * (1 - t)
      line((ax - hu, yu), (ax + hu, yu), stroke: (paint: BEAMF, thickness: 0.6pt))
      let yd = ay + (ry2 - ay) * t
      let hd = (29.10 - 27.10) / 2 * t
      line((ax - hd, yd), (ax + hd, yd), stroke: (paint: BEAMF, thickness: 0.6pt))
    }

    // 已固化椭球体素（连成打印线条，末端即焦点体素）
    let vox = ((26.75, 7.75), (27.15, 7.45), (27.50, 7.15), (27.80, 6.90), (28.00, 6.72))
    for p in vox {
      circle(p, radius: (0.31, 0.22), stroke: MAIN, fill: white)
    }
    // 焦点处体素（局部光斑）
    circle((ax, ay), radius: (0.18, 0.13), stroke: MAIN, fill: white)
    circle((ax, ay), radius: 0.055, fill: EXC, stroke: none)

    // 阈值曲线坐标系
    let ox = 32.00
    let oy = 3.55
    line((ox, oy), (ox, 9.55), stroke: MAIN, mark: (end: ">", fill: INK))
    line((ox, oy), (36.50, oy), stroke: MAIN, mark: (end: ">", fill: INK))
    // 阈值曲线：随位置迅速回落并长时间拖尾
    catmull(
      (ox + 0.05, 9.00),
      (ox + 0.25, 7.50),
      (ox + 0.55, 7.00),
      (ox + 1.00, 6.80),
      (ox + 1.70, 6.65),
      (ox + 2.20, 6.60),
      (ox + 2.90, 6.57),
      (36.20, 6.55),
      stroke: (paint: EXC, thickness: 0.7pt),
    )
    // 局部光斑强度分布（高斯峰，峰顶与阈值曲线相切于阈值位置）
    catmull(
      (ox + 0.05, 4.35),
      (ox + 1.00, 4.38),
      (ox + 1.70, 4.55),
      (ox + 2.15, 5.10),
      (ox + 2.55, 5.95),
      (ox + 2.90, 6.60),
      (ox + 3.25, 5.95),
      (ox + 3.65, 5.10),
      (ox + 4.10, 4.55),
      (36.20, 4.38),
      stroke: (paint: EXC, thickness: 0.7pt),
    )
    // 阈值位置（竖直虚线）与阈值强度（水平虚线，自焦点引出）
    line((ox + 2.90, 8.55), (ox + 2.90, oy + 0.18), stroke: DASH)
    line((ax + 0.20, ay), (ox + 2.90, ay), stroke: DASH)

    // (b) 标签
    lbl((28.10, 10.15), [Laser])
    lbl((22.55, 9.55), [Uncured resist], anchor: "west")
    line((25.95, 9.50), (26.55, 8.95), stroke: THIN) // 引线
    lbl((22.55, 3.95), [Substrate], anchor: "west")
    line((24.85, 3.92), (26.35, 3.62), stroke: THIN)
    lbl((22.55, 6.55), [Cured resist], anchor: "west")
    line((25.65, 6.55), (26.70, 7.55), stroke: THIN)
    lbl((33.35, 5.45), [Focal spot], size: 6.6pt)
    line((34.58, 5.72), (34.85, 6.42), stroke: THIN, mark: (end: ">", fill: INK))
    lbl((36.60, 8.95), [Threshold], anchor: "east")
    lbl((34.30, 3.20), [Absorption])
    lbl((31.72, 8.20), [Intensity], angle: 90deg)
  }

  // 绘制

  // (a) 光学元件
  laser(0.80, 8.35)
  attenuator(5.90, AY)
  beam-expander(6.95, AY)
  shutter(10.30, 8.55)
  galvo(12.90, 7.35)
  mirror(12.90, 12.30, ang: 19deg)
  dichroic(COL, 9.35, ang: 19deg)
  objective(COL, OBJ_TOP)
  piezo-stage(COL, 5.04)
  ccd(COL, CCD_BOT)
  led(19.00, 3.60)
  lens(COL, IMG_LENS, h: 0.50, t: 0.20)

  // (a) 光路
  // 激发光（红线实线）：激光器 → 衰减片 → 扩束镜；扩束镜 → 快门 → 振镜 → 反射镜 → 二向色镜 → 样品
  beam(((4.82, AY), (7.00, AY)))
  beam(((8.96, AY), SH, GV, MI, DI, (COL, SAMP)))
  // 照明光（黄绿虚线）：LED → 下反射镜 → 样品下表面
  beam(((18.62, 4.18), MI2, (16.40, 5.22)), dashed: true)
  // 成像光（黄绿虚线）：二向色镜 → 成像透镜 → CCD
  beam((DI, (COL, CCD_BOT - 0.26)), dashed: true)

  // 下反射镜（把 LED 照明光折向上方的样品背面）
  mirror(MI2.at(0), MI2.at(1), ang: -25deg, len: 1.50)

  // 蓝色指示箭头：Objective lens 标签指向物镜
  bezier(
    (16.85, 7.35),
    (15.75, 7.15),
    (16.35, 7.45),
    (16.00, 7.25),
    stroke: (paint: AUX, thickness: 0.8pt),
    mark: (end: ">", fill: AUX),
  )

  // (a) 标签
  lbl((2.75, 10.55), [Laser])
  lbl((6.55, 10.05), [Attenuator])
  lbl((7.55, 8.05), [Expander])
  lbl((9.55, 7.30), [Shutter])
  lbl((12.35, 13.05), [Mirror])
  lbl((12.00, 6.10), [Scanning galvanometer], size: 6.6pt)
  lbl((16.60, 9.55), [Dichroic], anchor: "west")
  lbl((16.90, 7.35), [Objective lens], anchor: "west")
  lbl((16.10, IMG_LENS), [Lens], anchor: "west")
  lbl((COL, 13.55), [CCD])
  lbl((13.35, 3.55), [Piezostage], anchor: "east")
  lbl((15.55, 2.18), [Mirror], anchor: "east")
  lbl((20.00, 5.50), [LED])

  // (b)
  voxel-plot()

  // 面板编号
  lbl((0.55, 13.30), [a], size: 9.5pt)
  lbl((21.85, 11.90), [b], size: 9.5pt)
})
