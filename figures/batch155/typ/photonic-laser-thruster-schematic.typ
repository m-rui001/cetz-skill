#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 光子激光推进系统示意图重绘：深空底色+星点，火星/旋涡星系/地球弧面为背景，
// 中央红色激光锥、粉色增益介质、双 HR 镜、发射平台与常规推进器喷管
// 来源：Propulsion Technologies for CubeSats: Review, Aerospace 2024, 11(7), 502, Fig.33. DOI 10.3390/aerospace11070502.
#canvas({
  import draw: *

  // 深空背景与伪随机星点
  rect((0, 0), (17, 12), fill: rgb("#0a0e1a"), stroke: none)
  for i in range(0, 17) {
    for j in range(0, 12) {
      let h = calc.rem(i * 7 + j * 11, 13) / 13
      let x = i + 0.15 + h * 0.7
      let y = j + 0.2 + calc.rem(i * 5 + j * 3, 7) / 7 * 0.6
      let r = 0.008 + calc.rem(i * 3 + j * 7, 5) / 5 * 0.016
      circle((x, y), radius: r, fill: white, stroke: none)
    }
  }

  // 倾斜椭圆折线生成器（星系/圆弧共用）
  let ell(cx, cy, a, b, ang) = {
    let pts = ()
    for k in range(0, 28) {
      let t = k * 12.857deg
      let px = a * calc.cos(t)
      let py = b * calc.sin(t)
      pts.push((cx + px * calc.cos(ang) - py * calc.sin(ang), cy + px * calc.sin(ang) + py * calc.cos(ang)))
    }
    pts
  }

  // 火星与表面暗斑
  circle((3.2, 9.9), radius: 1.3, fill: rgb("#c47a48"), stroke: none)
  circle((3.5, 10.2), radius: 0.42, fill: rgb("#a95f33"), stroke: none)
  circle((2.9, 9.6), radius: 0.3, fill: rgb("#a95f33"), stroke: none)
  circle((3.3, 9.25), radius: 0.24, fill: rgb("#9c552c"), stroke: none)

  // 右侧旋涡星系（半透明叠层＋核心）与左下环状小星系
  line(..ell(13.3, 9.0, 2.3, 0.72, 30deg), close: true, fill: rgb(210, 200, 190, 28%), stroke: none)
  line(..ell(13.3, 9.0, 1.35, 0.4, 30deg), close: true, fill: rgb(240, 230, 215, 55%), stroke: none)
  circle((13.3, 9.0), radius: 0.15, fill: rgb(255, 245, 225), stroke: none)
  line(..ell(4.2, 2.5, 0.9, 0.75, 15deg), close: true, fill: rgb(120, 100, 170, 45%), stroke: none)
  line(..ell(4.2, 2.5, 0.55, 0.42, 15deg), close: true, fill: rgb(190, 160, 220, 60%), stroke: none)
  circle((4.2, 2.5), radius: 0.14, fill: rgb(255, 240, 220), stroke: none)

  // 右下地球弧面：只取画框内的一段弧并沿画框边闭合
  let ec = (15.9, -0.6)
  let er = 5.6
  let arcpts = ()
  for k in range(0, 25) {
    let a = 78.7deg + k * 3.96deg
    arcpts.push((ec.at(0) + er * calc.cos(a), ec.at(1) + er * calc.sin(a)))
  }
  line(..arcpts, (17, 0), close: true, fill: rgb("#2f6aa8"), stroke: none)

  // 地球表面云团色块
  circle((12.6, 1.1), radius: 0.55, fill: rgb("#cfe2f2"), stroke: none)
  circle((14.7, 2.1), radius: 0.62, fill: rgb("#cfe2f2"), stroke: none)
  circle((13.4, 3.1), radius: 0.42, fill: rgb("#cfe2f2"), stroke: none)
  circle((16.3, 3.7), radius: 0.5, fill: rgb("#cfe2f2"), stroke: none)
  circle((11.3, 0.6), radius: 0.38, fill: rgb("#cfe2f2"), stroke: none)

  // 红色激光锥：增益介质端面→对向 HR 镜
  line((9.85, 6.0), (10.15, 7.5), (6.55, 9.35), (6.85, 9.0), close: true, fill: rgb("#e5202a"), stroke: none)

  // 增益介质：粉色主体＋底部蓝色镜段，标注 G
  line((9.85, 6.0), (10.15, 7.5), (10.56, 7.42), (10.26, 5.92), close: true,
    fill: rgb("#e0679c"), stroke: (paint: rgb("#8c2f57"), thickness: 0.5pt))
  line((9.85, 6.0), (10.15, 6.32), (10.56, 6.24), (10.26, 5.92), close: true, fill: rgb("#4aa8d8"), stroke: none)
  content((10.2, 6.85), text(size: 7pt, fill: white)[G])

  // 上下两面 HR 反射镜
  line((6.42, 9.01), (6.78, 9.49), stroke: (paint: rgb("#9fb3c8"), thickness: 4pt))
  line((9.55, 5.45), (9.85, 5.85), stroke: (paint: rgb("#9fb3c8"), thickness: 4pt))

  // 灰色发射平台
  line((11.15, 5.0), (12.85, 4.4), (13.3, 5.85), (11.6, 6.45), close: true,
    fill: rgb("#9a9a9a"), stroke: (paint: rgb("#5f6a72"), thickness: 0.6pt))
  content((12.2, 5.42), text(size: 7.5pt, fill: rgb("#1b1b1b"))[Launch \ Platform])

  // 常规推进器喷管喇叭口
  line((14.78, 4.78), (14.34, 4.12), (13.69, 4.85), (13.85, 5.09), close: true,
    fill: rgb("#c8ccd0"), stroke: (paint: rgb("#6b737a"), thickness: 0.6pt))

  // 指向火星的绿色出射箭头
  line((6.25, 9.55), (4.85, 9.9), stroke: (paint: rgb("#35d07f"), thickness: 1.8pt), mark: (end: "stealth"))

  // 各部件标签与白色引线
  content((7.05, 10.05), text(size: 8pt, fill: white)[HR \ Mirror])
  line((6.98, 9.72), (6.76, 9.5), stroke: (paint: white, thickness: 0.7pt), mark: (end: "stealth"))

  content((7.2, 6.4), text(size: 8pt, fill: white)[Trapped \ Photons])
  line((7.85, 6.75), (8.15, 7.45), stroke: (paint: white, thickness: 0.7pt), mark: (end: "stealth"))

  content((10.75, 8.75), text(size: 8pt, fill: white)[Gain \ Medium])
  line((11.15, 8.4), (10.55, 7.6), stroke: (paint: white, thickness: 0.7pt))

  content((8.35, 4.7), text(size: 8pt, fill: white)[HR \ Mirror])
  line((8.85, 5.0), (9.55, 5.5), stroke: (paint: white, thickness: 0.7pt), mark: (end: "stealth"))

  content((15.25, 5.95), text(size: 8pt, fill: white)[Conventional \ thruster])
  line((14.95, 5.4), (14.6, 4.95), stroke: (paint: white, thickness: 0.7pt), mark: (end: "stealth"))
})
