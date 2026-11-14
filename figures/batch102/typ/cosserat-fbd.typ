// 编译效果：灰色平行四边形平面；粗灰弧杆自下端 c 弯至上端 s，杆外细偏移弧发出
//   8 支径向分布力箭头 f(σ) 指向杆；标签 l(σ)、σ（带切向小箭头）、c、s；
//   下端直箭头 n(c) 与逆时针矩弧 m(c)，上端直箭头 n(s) 与顺时针矩弧 m(s)；
//   c、s 至平面右下角的两条点状闭合线。
// 来源：Actuators 2024, 13(2), 52, Fig. 17（Cosserat 杆自由体图）。
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 12pt)
#show math.equation: set text(weight: "bold")
#import "@preview/cetz:0.4.2": canvas, draw

// 杆圆心 / 半径 / 偏移距、起止角（度）
#let C = (8.8, 2.2)
#let R = 6.4
#let D = 1.15
#let A0 = 184
#let A1 = 108

// 平面左右 x、顶 y、斜降、高
#let LX = 2.4
#let RX = 7.95
#let TY = 9.5
#let SL = 1.3
#let H = 7.7

// 共享 helper：极坐标点
#let polar(r, a) = (
  C.at(0) + r * calc.cos(a * 1deg),
  C.at(1) + r * calc.sin(a * 1deg),
)

// 共享 helper：圆心锚定弧（CeTZ arc 默认锚在起点，故先算起点）
#let arc-at(c, r, a0, a1, stroke: 1pt, mark: none) = draw.arc(
  (c.at(0) + r * calc.cos(a0 * 1deg), c.at(1) + r * calc.sin(a0 * 1deg)),
  radius: r, start: a0 * 1deg, stop: a1 * 1deg,
  stroke: stroke, mark: mark,
)

// 共享 helper：力直箭头
#let force-arrow(a, b) = draw.line(
  a, b, stroke: 1.2pt, mark: (end: "stealth", fill: black),
)

// 共享 helper：矩弧箭头
#let moment-curl(c, r, a0, a1) = arc-at(
  c, r, a0, a1, stroke: 1.2pt, mark: (end: "stealth", fill: black),
)

// 共享 helper：文字标签
#let label(at, body, anchor: "center") = draw.content(at, body, anchor: anchor)

#canvas(length: 1cm, {
  import draw: *
  // 灰色平行四边形平面（左右边竖直、上下边斜降）
  let BL = (LX, TY - H)
  let BR = (RX, TY - H - SL)
  line(
    (LX, TY), (RX, TY - SL), BR, BL,
    close: true, fill: luma(225), stroke: 0.8pt + luma(205),
  )
  // 点状闭合线：杆两端 c、s 连至平面右下角
  let c = polar(R, A0)
  let s = polar(R, A1)
  line(c, BR, stroke: (dash: "dotted", thickness: 1pt))
  line(s, BR, stroke: (dash: "dotted", thickness: 1pt))
  // 偏移细弧与粗杆弧
  arc-at(C, R + D, A0 + 3, A1 - 4, stroke: 1pt + luma(90))
  arc-at(C, R, A0, A1, stroke: 3.5pt + luma(100))
  // 分布力箭头扇：8 支自偏移弧径向指向杆
  for i in range(8) {
    let t = A0 + (A1 - A0) * i / 7
    force-arrow(polar(R + D, t), polar(R + 0.05, t))
  }
  // σ 切向小箭头与标签
  force-arrow(polar(R, 162), polar(R, 156))
  label(polar(R - 0.7, 158), $sigma$)
  // 分布载荷标签 l(σ)、f(σ)
  label((2.3, 7.7), $l(sigma)$)
  label((1.1, 5.8), $f(sigma)$)
  // 端点标签 c、s
  label((c.at(0) - 0.5, c.at(1) - 0.35), $c$)
  label((s.at(0) - 0.35, s.at(1) - 0.65), $s$)
  // 下端内力 n(c) 竖直向下
  force-arrow(
    (c.at(0), c.at(1) - 0.15), (c.at(0), c.at(1) - 1.35),
  )
  label((c.at(0) + 0.55, c.at(1) - 1.15), $n(c)$, anchor: "west")
  // 下端矩 m(c) 逆时针弧
  moment-curl((c.at(0), c.at(1) - 0.2), 0.9, 195, 345)
  label((c.at(0) + 0.65, c.at(1) + 0.45), $m(c)$, anchor: "west")
  // 上端内力 n(s) 右上
  force-arrow(s, (s.at(0) + 1.1, s.at(1) + 0.3))
  label((s.at(0) + 1.3, s.at(1) + 0.4), $n(s)$, anchor: "west")
  // 上端矩 m(s) 顺时针弧
  moment-curl((s.at(0) + 0.15, s.at(1) + 0.05), 0.85, 70, -60)
  label((s.at(0) + 0.95, s.at(1) - 0.75), $m(s)$, anchor: "west")
})
