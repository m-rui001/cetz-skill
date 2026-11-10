#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 复刻 Actuators 2024, 13(2), 52 Fig.19（DOI 10.3390/act13020052）：连续体机器人运动策略四联图
// 干净线稿平涂：(a) Circumnutation 弹簧/背脊示意、(b) 三种背脊形态、(c) Coiling 三阶段、(d) 旋转核心与未卷曲背脊
#canvas({
  import draw: *

  // 共享助手：折线近似椭圆（CeTZ 0.4.2 无 ellipse）
  let ell(c, rx, ry, n: 48) = {
    let (cx, cy) = c
    range(n).map(i => {
      let a = i / n * 360deg
      (cx + rx * calc.cos(a), cy + ry * calc.sin(a))
    })
  }
  // 共享助手：圆弧采样点
  let arcpts(c, r, a0, a1, n: 36) = {
    let (cx, cy) = c
    range(n + 1).map(i => {
      let a = (a0 + (a1 - a0) * i / n) * 1deg
      (cx + r * calc.cos(a), cy + r * calc.sin(a))
    })
  }
  // 共享助手：平滑螺旋（半径线性收缩）
  let spiral(c, r0, r1, a0, a1, n: 72) = {
    let (cx, cy) = c
    range(n + 1).map(i => {
      let t = i / n
      let a = (a0 + (a1 - a0) * t) * 1deg
      let r = r0 + (r1 - r0) * t
      (cx + r * calc.cos(a), cy + r * calc.sin(a))
    })
  }

  let red = rgb("#e3261f")
  let cyan = rgb("#2fb4e6")
  let strand = rgb("#9b5b8b")
  let tan = rgb("#b5a17d")
  let ink = rgb("#222222")

  // 面板 (a)：Circumnutation 的两种支撑示意
  draw.content((3.9, 13.65), text(size: 9pt, style: "italic")[Circumnutation])
  draw.content((2.1, 7.62), text(size: 8.5pt)[Load relief])
  draw.content((5.3, 7.62), text(size: 8.5pt)[Structural support])

  // 左：螺旋弹簧 + 载荷释放箭头
  draw.line((2.15, 8.0), (2.15, 9.35), stroke: (paint: red, thickness: 1.6pt))
  for (yy, rx) in ((9.4, 0.72), (10.0, 0.92), (10.6, 1.12), (11.2, 1.32)) {
    draw.line(..ell((2.15, yy), rx, 0.25), close: true, stroke: (paint: red, thickness: 1.6pt))
  }
  draw.line((1.35, 12.0), (0.65, 12.0), stroke: (paint: cyan, thickness: 1.2pt), mark: (end: "stealth"))
  draw.line((1.85, 7.8), (1.85, 8.5), stroke: (paint: cyan, thickness: 1.2pt), mark: (end: "stealth"))

  // 右：波浪背脊 + 绕圆盘一周的盘绕（螺旋线，末端内收）
  let cen = (5.55, 11.45)
  draw.line((5.05, 8.0), (5.15, 8.8), (4.95, 9.7), (5.2, 10.5), (5.05, 11.0),
    (4.75, 11.15),
    stroke: (paint: red, thickness: 1.7pt))
  draw.circle(cen, radius: 0.52, fill: rgb("#efefef"),
    stroke: (paint: ink, thickness: 1.1pt))
  draw.line(..spiral(cen, 0.95, 0.72, 200, 540), stroke: (paint: red, thickness: 1.7pt))
  // 圆环外侧的旋转指示弧箭头
  draw.line(..arcpts(cen, 1.18, 55, -25), stroke: (paint: cyan, thickness: 1.2pt),
    mark: (end: "stealth"))
  draw.line((5.15, 7.9), (5.15, 8.55), stroke: (paint: cyan, thickness: 1.2pt),
    mark: (end: "stealth"))
  draw.content((3.9, 7.2), text(size: 10pt)[(a)])

  // 面板 (b)：三个连续体背脊状态（照片转线稿）
  for i in range(3) {
    let x0 = 8.6 + i * 3.4
    draw.rect((x0, 8.1), (x0 + 3.2, 13.9), fill: rgb("#eeeeee"),
      stroke: (paint: rgb("#dddddd"), thickness: 0.5pt))
  }

  // 底部夹具、红点与引线
  for cx in (10.2, 13.4, 16.6) {
    draw.rect((cx - 0.35, 8.55), (cx + 0.25, 8.8), fill: rgb("#bcbcbc"),
      stroke: (paint: rgb("#777777"), thickness: 0.5pt))
    draw.circle((cx - 0.15, 8.72), radius: 0.05, fill: red, stroke: none)
    draw.line((cx - 0.25, 8.55), (cx - 0.4, 8.15),
      stroke: (paint: rgb("#c08080"), thickness: 0.6pt))
  }

  // 三种背脊形态：直伸、盘绕、卷曲尾摆
  draw.line((10.3, 8.8), (10.15, 9.7), (10.05, 10.6), (10.25, 11.5),
    (10.2, 12.4), (10.12, 13.0), stroke: (paint: strand, thickness: 1.1pt))
  draw.line((13.4, 8.8), (13.3, 9.5), (13.1, 10.3), (12.9, 11.1), (12.85, 11.5),
    stroke: (paint: strand, thickness: 1.1pt))
  draw.circle((13.02, 11.68), radius: 0.17, stroke: (paint: strand, thickness: 1pt))
  draw.line((12.9, 11.82), (12.82, 12.2), (12.78, 12.55),
    stroke: (paint: strand, thickness: 1pt))
  draw.line((16.6, 8.8), (16.5, 9.6), (16.32, 10.3), (16.18, 10.85),
    stroke: (paint: strand, thickness: 1.1pt))
  draw.circle((16.06, 10.95), radius: 0.18, stroke: (paint: strand, thickness: 1pt))
  draw.line((15.9, 10.85), (15.78, 10.55), (15.72, 10.2),
    stroke: (paint: strand, thickness: 1pt))

  // 每幅子图的竖直比例尺（1/5/10 cm）
  for i in range(3) {
    let sx = 8.6 + i * 3.4 + 2.55
    draw.line((sx, 9.4), (sx, 12.0), stroke: (paint: ink, thickness: 0.5pt))
    draw.line((sx - 0.1, 9.4), (sx + 0.1, 9.4), stroke: (paint: ink, thickness: 0.5pt))
    draw.line((sx - 0.1, 12.0), (sx + 0.1, 12.0), stroke: (paint: ink, thickness: 0.5pt))
    draw.line((sx - 0.08, 10.7), (sx + 0.08, 10.7), stroke: (paint: ink, thickness: 0.5pt))
    draw.content((sx + 0.28, 11.7), text(size: 4.5pt)[1 cm])
    draw.content((sx + 0.28, 10.45), text(size: 4.5pt)[5 cm])
    draw.content((sx + 0.3, 9.25), text(size: 4.5pt)[10 cm])
  }

  // 标签与红色指示箭头
  draw.content((10.1, 13.6), text(size: 8pt)[Straight backbone])
  draw.line((10.1, 13.35), (9.95, 12.6), stroke: (paint: red, thickness: 1pt),
    mark: (end: "stealth"))
  draw.content((13.9, 13.6), text(size: 8.5pt)[Circumnutation])
  draw.line((13.2, 13.35), (13.02, 11.92), stroke: (paint: red, thickness: 1pt),
    mark: (end: "stealth"))
  draw.line((15.95, 13.3), (15.7, 11.25), stroke: (paint: red, thickness: 1pt),
    mark: (end: "stealth"))
  draw.content((13.6, 7.2), text(size: 10pt)[(b)])

  // 面板 (c)：Coiling 三阶段圆盘示意
  draw.content((5.7, 6.25), text(size: 9pt, style: "italic")[Coiling])
  for yy in (5.25, 3.85, 2.45) {
    draw.circle((1.8, yy), radius: 0.7, fill: rgb("#e6e6e6"),
      stroke: (paint: ink, thickness: 0.8pt))
  }

  // 上：背脊盘绕（外红环 + 内部旋向箭头）
  draw.circle((1.8, 5.25), radius: 0.78, stroke: (paint: red, thickness: 1.5pt))
  draw.circle((2.28, 5.42), radius: 0.05, fill: ink, stroke: none)
  draw.line(..arcpts((1.8, 5.25), 0.5, 205, 300), stroke: (paint: cyan, thickness: 1.2pt),
    mark: (end: "stealth"))

  // 中：尖端解绕（内左下青弧 + 向右伸出）
  draw.line(..arcpts((1.8, 3.85), 0.5, 195, 265), stroke: (paint: cyan, thickness: 1.2pt))
  draw.circle((2.4, 3.85), radius: 0.05, fill: ink, stroke: none)
  draw.line((2.45, 3.85), (3.3, 3.85), stroke: (paint: red, thickness: 1.3pt))
  draw.line((3.3, 3.85), (3.75, 3.85), stroke: (paint: cyan, thickness: 1.2pt),
    mark: (end: "stealth"))

  // 下：旋转核心（外红环 + 向左红箭头 + 右下青箭头）
  draw.circle((1.8, 2.45), radius: 0.78, stroke: (paint: red, thickness: 1.5pt))
  draw.line((2.9, 2.45), (2.3, 2.45), stroke: (paint: red, thickness: 1.3pt),
    mark: (end: "stealth"))
  draw.line((2.9, 2.05), (3.4, 2.05), stroke: (paint: cyan, thickness: 1.2pt),
    mark: (end: "stealth"))

  // 三阶段标签与指示箭头
  draw.content((5.4, 5.55), text(size: 8.5pt)[Coiled backbone])
  draw.line((4.55, 5.45), (2.9, 5.25), stroke: (paint: red, thickness: 1pt),
    mark: (end: "stealth"))
  draw.content((5.4, 4.05), text(size: 8.5pt)[Tip uncoiling])
  draw.line((4.55, 3.95), (3.5, 3.85), stroke: (paint: red, thickness: 1pt),
    mark: (end: "stealth"))
  draw.content((5.4, 2.55), text(size: 8.5pt)[Rotating core])
  draw.line((4.55, 2.45), (2.75, 2.45), stroke: (paint: red, thickness: 1pt),
    mark: (end: "stealth"))
  draw.content((3.8, 0.35), text(size: 10pt)[(c)])

  // 面板 (d)：旋转核心滚筒（左）与未卷曲背脊近景（右）
  draw.rect((8.6, 0.8), (14.6, 6.3), fill: rgb("#e8e8e8"), stroke: none)
  draw.rect((9.5, 1.8), (13.7, 2.35), fill: rgb("#c4c4c4"),
    stroke: (paint: rgb("#777777"), thickness: 0.6pt))
  draw.line(..ell((11.6, 1.8), 2.1, 0.42), close: true, fill: rgb("#a8a8a8"),
    stroke: (paint: rgb("#777777"), thickness: 0.6pt))
  draw.rect((9.7, 2.35), (13.5, 5.15), fill: rgb("#fbfbfb"),
    stroke: (paint: rgb("#999999"), thickness: 0.6pt))
  draw.line(..ell((11.6, 5.15), 1.9, 0.45), close: true, fill: rgb("#f4f4f4"),
    stroke: (paint: rgb("#999999"), thickness: 0.6pt))
  draw.line(..ell((11.6, 5.2), 1.5, 0.35), close: true, fill: rgb("#333333"),
    stroke: (paint: ink, thickness: 0.6pt))

  // 滚筒外壁缠绕的背脊环
  for yy in (3.6, 3.35, 3.1, 2.85, 2.6) {
    draw.line(..ell((11.6, yy), 2.0, 0.2), close: true,
      stroke: (paint: tan, thickness: 2.2pt))
  }
  // 黑色旋转核心前沿缺口
  draw.rect((11.6, 5.0), (11.84, 5.26), fill: rgb("#111111"), stroke: none)
  draw.content((11.7, 5.9), text(size: 8pt)[Rotating core])
  draw.line((11.7, 5.72), (11.7, 5.3), stroke: (paint: red, thickness: 1pt),
    mark: (end: "stealth"))
  draw.content((11.7, 4.15), text(size: 8pt)[Coiled backbone])
  draw.line((11.7, 3.98), (11.7, 3.62), stroke: (paint: red, thickness: 1pt),
    mark: (end: "stealth"))

  // 右侧：未卷曲背脊与驱动模块近景
  draw.rect((15.0, 0.8), (19.0, 6.3), fill: rgb("#d0d0d0"),
    stroke: (paint: rgb("#aaaaaa"), thickness: 0.6pt))
  draw.line((16.0, 1.0), (16.3, 1.6), (16.6, 2.2), (16.9, 2.9),
    (17.2, 3.6), (17.5, 4.3), (17.8, 4.9),
    stroke: (paint: tan, thickness: 3pt))
  for (ax, ay) in ((16.25, 1.45), (16.55, 2.05), (16.85, 2.7),
      (17.15, 3.35), (17.45, 4.0), (17.72, 4.6)) {
    draw.line((ax, ay), (ax + 0.12, ay - 0.08),
      stroke: (paint: rgb("#8b7a5e"), thickness: 0.5pt))
  }
  draw.line((15.25, 5.65), (15.6, 5.15), (15.9, 4.7), (15.8, 4.35),
    stroke: (paint: tan, thickness: 2.5pt))
  draw.rect((17.55, 4.55), (17.95, 4.95), fill: rgb("#a0a0a0"),
    stroke: (paint: ink, thickness: 0.5pt))
  draw.rect((15.1, 5.55), (15.45, 5.85), fill: rgb("#a0a0a0"),
    stroke: (paint: ink, thickness: 0.5pt))
  draw.content((17.5, 5.35), text(size: 8pt)[Uncoiled backbone])
  draw.line((17.4, 5.15), (16.9, 4.0), stroke: (paint: red, thickness: 1pt),
    mark: (end: "stealth"))
  draw.content((13.8, 0.35), text(size: 10pt)[(d)])
})
