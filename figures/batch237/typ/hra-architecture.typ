#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 编译结果：30×8.75cm 横排框图。左侧绿框内三台并联执行器汇入浅蓝菱形力矩限制器，
// 经蓝色软体单元框（黄色椭圆）进入红色先进特性框（粉/绿椭圆），实线箭头标
// Robustness / Efficiency 汇入右侧输出轴，底部虚线标 Enhanced Output。
// 来源：Actuators 2025, 14, 177, Figure 2 (HRA architecture). DOI 10.3390/act14040177

#canvas({
  import draw: *

  // 画布底色（撑满 30×8.75cm 画幅）
  rect((0, 0), (30, 8.75), fill: white, stroke: none)

  // 配色
  let cGrn = rgb(46, 140, 71)
  let cBlu = rgb(59, 94, 209)
  let cRed = rgb(212, 41, 41)
  let cGray = rgb(89, 89, 89)

  // 多行居中文字
  let ml(c, lines, size: 10pt) = {
    let n = lines.len()
    for (i, l) in lines.enumerate() {
      content((c.at(0), c.at(1) + (n - 1) * 0.21 - i * 0.42), text(size: size, l))
    }
  }

  // 圆角框 + 居中多行文字
  let rbox(c, w, h, lines, stroke: cGray, fill: white, size: 10pt) = {
    rect((c.at(0) - w / 2, c.at(1) - h / 2), (rel: (w, h)), radius: 0.35, stroke: stroke, fill: fill)
    ml(c, lines, size: size)
  }

  // 椭圆 + 居中多行文字
  let ell(c, rx, ry, lines, stroke: cGray, fill: white, size: 10pt) = {
    circle(c, radius: (rx, ry), stroke: stroke, fill: fill)
    ml(c, lines, size: size)
  }

  // 实线箭头
  let ar(a, b) = line(a, b, stroke: (thickness: 0.7pt), mark: (end: "stealth"))

  // 地标坐标
  let dia = (6.90, 3.38)
  let soft = (14.55, 4.30)
  let mbd = (21.72, 6.62)
  let mag = (21.72, 4.30)
  let out = (28.30, 4.15)

  // 两组功能分区外框
  rect((0.60, 0.55), (10.40, 6.15), radius: 0.35, stroke: cGrn, fill: none)
  rect((18.65, 3.30), (24.80, 8.10), radius: 0.35, stroke: cRed, fill: none)

  // 增强输出虚线（先画，被菱形与输出轴压住两端）
  bezier((8.55, 2.82), (27.05, 3.70), (14.50, 1.95), (21.50, 2.10), stroke: (thickness: 0.7pt, dash: "dashed"))

  // 左组：并联执行器
  rbox((1.95, 4.86), 2.30, 0.86, ("Actuator A1",), stroke: cGray, size: 9pt)
  rbox((1.95, 3.03), 2.30, 0.86, ("Actuator A2",), stroke: cGray, size: 9pt)
  rbox((1.95, 1.21), 2.30, 0.86, ("Actuator An",), stroke: cGray, size: 9pt)

  // 力矩限制菱形
  let (dl, dt, dr, db) = ((dia.at(0) - 2.92, dia.at(1)), (dia.at(0), dia.at(1) + 1.00), (dia.at(0) + 2.92, dia.at(1)), (dia.at(0), dia.at(1) - 1.00))
  line(..(dl, dt, dr, db), close: true, fill: rgb(184, 217, 230), stroke: rgb(89, 153, 184))
  ml(dia, ("Torque Limiters", "(Load Distribution)"), size: 10pt)

  // 软体单元框与椭圆
  rect((12.05, 3.32), (17.05, 5.85), radius: 0.35, stroke: cBlu, fill: none)
  ell(soft, 1.78, 0.65, ("Soft Robotics", "(Shock Absorption)"), stroke: rgb(158, 148, 64), fill: rgb(252, 250, 219), size: 9pt)

  // 先进特性框内两个椭圆
  ell(mbd, 2.75, 0.80, ("MBD-ILAR", "(Bio-inspired Robustness)"), stroke: rgb(184, 76, 76), fill: rgb(247, 199, 199), size: 9.5pt)
  ell(mag, 2.30, 0.62, ("Magnetic Control", "(Precision Efficiency)"), stroke: cGrn, fill: rgb(158, 214, 158), size: 9.5pt)

  // 输出轴
  rbox(out, 2.50, 1.15, ("Output Shaft", "(End Effector)"), stroke: cGray, size: 9pt)

  // 执行器 → 菱形
  ar((3.10, 4.86), (5.15, 3.78))
  ar((3.10, 3.03), (4.02, 3.38))
  ar((3.10, 1.21), (5.15, 2.98))

  // 菱形 → 软体单元
  ar((9.82, 3.38), (12.05, 4.30))

  // 软体单元 → 先进特性两椭圆
  ar((17.05, 4.80), (19.05, 6.38))
  ar((17.05, 4.30), (19.42, 4.30))

  // 两椭圆 → 输出轴
  ar((24.40, 6.44), (27.05, 4.40))
  ar((24.02, 4.30), (27.05, 4.22))

  // 分区标题
  content((5.50, 5.75), text(size: 10pt, "Parallel Actuators (A1–An)"))
  content((14.55, 5.55), text(size: 9.5pt, "Soft Elements Integration"))
  content((21.72, 7.78), text(size: 10pt, "Advanced Features"))

  // 连线文字标注
  ml((10.95, 4.72), ("Series", "Integration"), size: 9pt)
  content((25.92, 5.90), text(size: 9pt, "Robustness"))
  content((25.80, 4.64), text(size: 9pt, "Efficiency"))
  ml((17.85, 2.95), ("Enhanced", "Output"), size: 9pt)
})
