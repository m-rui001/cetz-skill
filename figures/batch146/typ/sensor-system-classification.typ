#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 编译外观：白底扁平线稿的传感器分类框图，两级粗体标题下共 9 个传感器图标
// 来源：Quadruped Robots review, Robotics 2025, 14, 57, Figure 7（照片拼图转矢量线稿）. DOI 10.3390/robotics14050057.

#canvas({
  import draw: *

  // 统一配色：墨线、金属灰、深色外壳、电路板蓝/黄
  let ink = rgb("#1b1e23")
  let metal = rgb("#c8ccd2")
  let dark = rgb("#252a32")
  let lite = rgb("#eceef1")
  let pcbB = rgb("#2f6fae")
  let pcbY = rgb("#e6c14a")
  let yel = rgb("#f0c53c")
  let wht = white

  // 增量式旋转编码器：金属机身 + 端面 + 转轴
  let ico-enc = o => {
    let (dx, dy) = o
    let P(x, y) = (dx + x, dy + y)
    draw.rect(P(-1.45, -0.75), P(0.30, 0.75), fill: metal, stroke: ink)
    draw.line(P(-1.45, 0.32), P(0.30, 0.32), stroke: ink)
    draw.line(P(-1.45, -0.30), P(0.30, -0.30), stroke: ink)
    draw.circle(P(0.30, 0), radius: 0.75, fill: metal, stroke: ink)
    draw.circle(P(0.30, 0), radius: 0.42, fill: wht, stroke: ink)
    draw.line(P(0.30, -0.15), P(1.20, -0.15), P(1.20, 0.15), P(0.30, 0.15),
      close: true, fill: metal, stroke: ink)
  }

  // 力矩传感器：深色圆盘 + 中心孔 + 螺栓孔阵 + 侧向线缆
  let ico-ft = o => {
    let (dx, dy) = o
    let P(x, y) = (dx + x, dy + y)
    draw.circle(P(0, 0), radius: 1.0, fill: dark, stroke: ink)
    draw.circle(P(0, 0), radius: 0.32, fill: wht, stroke: ink)
    for k in range(6) {
      let a = 30deg + k * 60deg
      draw.circle(P(0.66 * calc.cos(a), 0.66 * calc.sin(a)), radius: 0.14,
        fill: wht, stroke: ink)
    }
    draw.line(P(0.80, -0.50), P(1.20, -0.72), P(1.35, -0.50), stroke: ink)
  }

  // 惯性测量单元：方形外壳 + 白色箭头/二维码标记 + 底部接口窗
  let ico-imu = o => {
    let (dx, dy) = o
    let P(x, y) = (dx + x, dy + y)
    draw.rect(P(-1.05, -0.95), P(1.05, 0.70), fill: dark, stroke: ink)
    draw.rect(P(-1.05, -0.95), P(1.05, -0.62), fill: metal, stroke: ink)
    draw.line(P(-0.78, 0.38), P(-0.28, 0.38), stroke: wht, mark: (end: "stealth", fill: wht))
    draw.line(P(-0.78, 0.10), P(-0.28, 0.10), stroke: wht, mark: (end: "stealth", fill: wht))
    draw.rect(P(0.32, -0.10), P(0.86, 0.48), fill: wht, stroke: none)
    draw.rect(P(0.40, 0.30), P(0.52, 0.42), fill: dark, stroke: none)
    draw.rect(P(0.62, 0.30), P(0.74, 0.42), fill: dark, stroke: none)
    draw.rect(P(0.40, 0.02), P(0.60, 0.14), fill: dark, stroke: none)
  }

  // 激光雷达：深色激光头 + 金属基座 + 底环 + 出线
  let ico-lidar = o => {
    let (dx, dy) = o
    let P(x, y) = (dx + x, dy + y)
    draw.rect(P(-0.62, 0.10), P(0.62, 1.05), fill: dark, stroke: ink)
    draw.circle(P(0, 0.72), radius: 0.16, fill: metal, stroke: ink)
    draw.rect(P(-0.72, -0.85), P(0.72, 0.10), fill: metal, stroke: ink)
    draw.rect(P(-0.78, -1.15), P(0.78, -0.85), fill: lite, stroke: ink)
    draw.line(P(0.72, 0.45), P(1.10, 0.80), stroke: ink)
  }

  // 相机：黄色电路板 + 镜头座 + 元件与排针
  let ico-cam = o => {
    let (dx, dy) = o
    let P(x, y) = (dx + x, dy + y)
    draw.rect(P(-0.95, -1.25), P(0.95, 1.05), fill: pcbY, stroke: ink)
    draw.circle(P(0, 0.30), radius: 0.50, fill: dark, stroke: ink)
    draw.circle(P(0, 0.30), radius: 0.26, fill: lite, stroke: ink)
    draw.circle(P(0, 0.30), radius: 0.11, fill: dark, stroke: none)
    draw.rect(P(0.42, -0.92), P(0.80, -0.55), fill: dark, stroke: ink)
    draw.rect(P(-0.80, -1.05), P(-0.42, -0.68), fill: wht, stroke: ink)
    draw.line(P(-0.95, -1.25), P(0.95, -1.25), stroke: ink)
  }

  // 触觉传感器：机械手（手掌 + 四指 + 拇指 + 腕座）
  let ico-hand = o => {
    let (dx, dy) = o
    let P(x, y) = (dx + x, dy + y)
    draw.rect(P(-0.50, -0.90), P(0.50, 0.25), fill: dark, stroke: ink)
    for x in (-0.36, -0.12, 0.12, 0.36) {
      draw.rect(P(x - 0.10, 0.25), P(x + 0.10, 1.15), fill: dark, stroke: ink)
      draw.line(P(x - 0.10, 0.70), P(x + 0.10, 0.70), stroke: metal)
    }
    draw.line(P(-0.50, 0.05), P(-1.00, -0.25), P(-1.05, -0.60),
      P(-0.75, -0.65), P(-0.50, -0.45), close: true, fill: dark, stroke: ink)
    draw.rect(P(-0.28, -1.25), P(0.28, -0.90), fill: metal, stroke: ink)
  }

  // 超声波传感器：蓝色板 + 双换能器 + 芯片 + 排针
  let ico-sonar = o => {
    let (dx, dy) = o
    let P(x, y) = (dx + x, dy + y)
    draw.rect(P(-1.15, -0.60), P(1.15, 0.60), fill: pcbB, stroke: ink)
    for x in (-0.62, 0.62) {
      draw.circle(P(x, 0.05), radius: 0.38, fill: metal, stroke: ink)
      draw.circle(P(x, 0.05), radius: 0.24, fill: dark, stroke: none)
    }
    draw.rect(P(-0.24, -0.55), P(0.24, -0.25), fill: dark, stroke: ink)
    for x in (-0.30, -0.10, 0.10, 0.30) {
      draw.line(P(x, -0.60), P(x, -0.88), stroke: ink)
    }
  }

  // GPS：黄色八边形天线 + 深色环带 + 底部接口
  let ico-gps = o => {
    let (dx, dy) = o
    let P(x, y) = (dx + x, dy + y)
    let pts = ((-1.05, 0.30), (-0.70, 0.80), (0.70, 0.80), (1.05, 0.30),
      (1.05, -0.30), (0.70, -0.80), (-0.70, -0.80), (-1.05, -0.30))
    draw.line(..pts.map(q => P(q.at(0), q.at(1))), close: true, fill: yel, stroke: ink)
    draw.line(P(-1.05, 0.05), P(1.05, 0.05), P(1.05, -0.30), P(-1.05, -0.30),
      close: true, fill: dark, stroke: ink)
    draw.line(P(-0.55, 0.55), P(0.55, 0.55), stroke: ink)
    draw.rect(P(-0.22, -0.95), P(0.22, -0.80), fill: dark, stroke: ink)
  }

  // 红外传感器：蓝板 + 透明发射管 + 黑色接收头 + 蓝色电位器
  let ico-ir = o => {
    let (dx, dy) = o
    let P(x, y) = (dx + x, dy + y)
    draw.rect(P(-1.35, -0.50), P(1.35, 0.35), fill: pcbB, stroke: ink)
    draw.circle(P(-0.90, 0.72), radius: 0.28, fill: lite, stroke: ink)
    draw.line(P(-1.02, 0.50), P(-1.02, 0.30), stroke: ink)
    draw.line(P(-0.78, 0.50), P(-0.78, 0.30), stroke: ink)
    draw.rect(P(-0.28, 0.25), P(0.12, 0.95), fill: dark, stroke: ink)
    draw.circle(P(0.95, -0.02), radius: 0.30, fill: rgb("#4a90cf"), stroke: ink)
    draw.line(P(0.79, -0.02), P(1.11, -0.02), stroke: ink)
    draw.rect(P(-0.55, -0.32), P(0.15, -0.02), fill: dark, stroke: ink)
  }

  // 三列基准与各行高度
  let cx = (3.6, 10.6, 17.6)
  let y-ttl1 = 0
  let y-lab1 = -1.40
  let y-ico1 = -3.75
  let y-ttl2 = -6.50
  let y-lab2 = -7.85
  let y-ico2 = -10.15
  let y-lab3 = -12.95
  let y-ico3 = -15.25

  // 两级分类标题
  draw.content((cx.at(1), y-ttl1), text(size: 12pt, weight: "bold", "Internal Sensors"), anchor: "center")
  draw.content((cx.at(1), y-ttl2), text(size: 12pt, weight: "bold", "External Sensors"), anchor: "center")

  // 八个部件标签（表驱动）
  let labels = (
    (0, y-lab1, "Incremental Rotary Encoders"),
    (1, y-lab1, "Force-Torque Sensors"),
    (2, y-lab1, "Inertial Measurement Units"),
    (0, y-lab2, "LiDAR"),
    (1, y-lab2, "Cameras"),
    (2, y-lab2, "Tactile Sensors"),
    (0, y-lab3, "Ultrasonic Sensors"),
    (1, y-lab3, "GPS"),
    (2, y-lab3, "Infrared Sensors"),
  )
  for (c, y, t) in labels {
    draw.content((cx.at(c), y), text(size: 10pt, weight: "bold", t), anchor: "center")
  }

  // 八个图标（表驱动）
  let icons = (
    (0, y-ico1, ico-enc), (1, y-ico1, ico-ft), (2, y-ico1, ico-imu),
    (0, y-ico2, ico-lidar), (1, y-ico2, ico-cam), (2, y-ico2, ico-hand),
    (0, y-ico3, ico-sonar), (1, y-ico3, ico-gps), (2, y-ico3, ico-ir),
  )
  for (c, y, f) in icons { f((cx.at(c), y)) }
})
