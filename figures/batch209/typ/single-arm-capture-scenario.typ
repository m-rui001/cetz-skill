#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 编译外观：米黄底面板上的四步“机械臂捕获目标”示意图——橄榄绿目标方块、黄色本体+蓝翼追踪器、黑色机械臂、青色旋转箭头
// 来源：Aerospace 2025, 12, 277 (debris) Figure 24，CAD 渲染转为干净线稿平涂
#canvas({
  import draw: *

  // 配色
  let cream = rgb("#fbfbcd")
  let olive = rgb("#6c7a2d")
  let yellow = rgb("#f2c31a")
  let blue = rgb("#2e7fd0")
  let teal = rgb("#178f8f")
  let red = rgb("#e06666")

  // 整幅米黄底色
  rect((0, 0), (12, 15.3), fill: cream, stroke: none)

  // 局部坐标旋转
  let rotp(p, a) = (
    p.at(0) * calc.cos(a) - p.at(1) * calc.sin(a),
    p.at(0) * calc.sin(a) + p.at(1) * calc.cos(a),
  )
  // 中心 c、倾角 a 的局部矩形四角坐标序列
  let quad(c, a, x0, x1, y0, y1) = (
    ((x0, y0), (x1, y0), (x1, y1), (x0, y1)).map(p => {
      let q = rotp(p, a)
      (c.at(0) + q.at(0), c.at(1) + q.at(1))
    })
  )
  // 平涂旋转矩形
  let patch(c, a, x0, x1, y0, y1, fill) = line(
    ..quad(c, a, x0, x1, y0, y1), close: true, fill: fill, stroke: none,
  )
  // 目标方块（橄榄绿）
  let target(c, a, s: 1.15) = patch(c, a, -s / 2, s / 2, -s / 2, s / 2, olive)
  // 追踪器：黄色本体 + 右侧蓝色太阳翼
  let chaser(c, a) = group({
    patch(c, a, -0.31, 0.31, -0.31, 0.31, yellow)
    patch(c, a, 0.31, 1.21, -0.15, 0.15, blue)
  })
  // 黑色机械臂折线
  let arm(pts) = line(
    ..pts, stroke: (paint: black, thickness: 1.6pt, cap: "round", join: "round"),
  )
  // 带箭头的青色旋转弧
  let spin(c, r, a0, a1, col: teal) = {
    let n = 16
    let pts = range(n + 1).map(i => {
      let a = a0 + (a1 - a0) * (i / n)
      (c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a))
    })
    line(
      ..pts,
      stroke: (paint: col, thickness: 1.3pt, cap: "round"),
      mark: (end: "stealth", fill: col, scale: 0.5),
    )
  }
  // 细黑线（运动/接近指示线）
  let thin(p, q) = line(p, q, stroke: (paint: black, thickness: 0.9pt))

  // 四行说明文字（逐字照抄）
  let rows = (
    (14.15, "(1) Observation of target motion"),
    (10.85, "(2) Rotation braking by robot arm"),
    (7.80, "(3) Capture by robot arm"),
    (4.55, "(4) De-rotation of target & chaser"),
  )
  for (y, t) in rows {
    content((0.35, y), t, anchor: "west")
  }

  // (1) 观察：目标自由自旋，机械臂保持距离
  target((7.55, 12.55), 20deg)
  spin((6.58, 12.50), 0.42, 250deg, 120deg)
  spin((8.55, 12.60), 0.42, 70deg, -60deg)
  arm(((9.05, 12.80), (9.40, 13.15), (9.90, 12.75)))
  chaser((10.15, 12.50), 0deg)

  // (2) 制动：机械臂伸向目标，末端带接近指示线
  target((7.35, 9.45), 15deg, s: 1.18)
  thin((8.15, 9.52), (8.92, 9.72))
  thin((8.10, 9.74), (8.92, 9.76))
  thin((8.15, 9.96), (8.92, 9.82))
  arm(((9.62, 9.60), (9.22, 10.05), (8.90, 9.78)))
  chaser((9.95, 9.35), 0deg)

  // (3) 捕获：机械臂末端与目标贴合
  target((7.35, 6.35), 8deg)
  arm(((7.95, 6.52), (8.60, 7.00), (9.42, 6.55)))
  chaser((9.78, 6.20), 0deg)
  spin((6.48, 6.30), 0.40, 250deg, 120deg)
  spin((10.98, 6.15), 0.45, 70deg, -60deg)

  // (4) 消旋：目标与追踪器一同受控，追踪器喷气
  target((7.20, 2.95), 8deg)
  arm(((7.82, 3.05), (8.50, 3.45), (9.28, 2.50)))
  chaser((9.55, 2.10), -22deg)
  spin((6.30, 2.85), 0.40, 250deg, 120deg)
  spin((10.62, 2.25), 0.45, 75deg, -50deg)

  // 红色推力箭头（指向追踪器底部）
  line((8.62, 1.00), (9.00, 1.75),
    stroke: (paint: red, thickness: 1.2pt, cap: "round"),
    mark: (end: "stealth", fill: red, scale: 0.55))
  line((9.05, 0.85), (9.42, 1.60),
    stroke: (paint: red, thickness: 1.2pt, cap: "round"),
    mark: (end: "stealth", fill: red, scale: 0.55))
})
