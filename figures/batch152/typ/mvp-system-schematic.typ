#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// MVP 推进系统示意图（Figure 8）：机械进料框 + 丝盘筒 + 粗箭头 + 绕行管路 + 挤出机/过热器/喷管串联；CAD 渲染转为干净线稿平涂。
// 来源：Propulsion Technologies for CubeSats: Review, Aerospace 2024, 11(7), 502, Figure 8. DOI 10.3390/aerospace11070502.
#canvas({
  import draw: *

  // —— 配色 ——
  let cEdge = rgb("#3A6FB5")
  let cFill = rgb("#A6BCE4")
  let cArrow = rgb("#6FA8DC")
  let cPipe = rgb("#5B8FD6")
  let cGray = rgb("#B4B4B4")
  let cExtra = rgb("#8C9FD6")
  let cSuper = rgb("#E0655D")
  let cNoz = rgb("#D9302A")

  // —— 椭圆离散点助手（逐点折线，避免形状 API 差异） ——
  let ell-pts(cx, cy, rx, ry, a0: 0, a1: 2 * calc.pi, n: 40) = {
    range(n + 1).map(i => {
      let a = a0 + (a1 - a0) * i / n
      (cx + rx * calc.cos(a), cy + ry * calc.sin(a))
    })
  }

  // 1) 丝盘筒体剪影填充：左半圆 + 右端面右半
  line(
    ..ell-pts(9.0, 5.15, 0.62, 1.4, a0: calc.pi / 2, a1: 3 * calc.pi / 2),
    ..ell-pts(12.6, 5.15, 0.62, 1.4, a0: -calc.pi / 2, a1: calc.pi / 2),
    fill: cFill, stroke: none, close: true,
  )

  // 2) 筒体轮廓：上下母线 + 左半弧 + 右端面椭圆
  line((9.0, 6.55), (12.6, 6.55), stroke: cEdge)
  line((9.0, 3.75), (12.6, 3.75), stroke: cEdge)
  line(..ell-pts(9.0, 5.15, 0.62, 1.4, a0: calc.pi / 2, a1: 3 * calc.pi / 2), stroke: cEdge)
  line(..ell-pts(12.6, 5.15, 0.62, 1.4), fill: cFill, stroke: cEdge, close: true)
  content((10.8, 5.15), align(center, text(size: 8.5pt, weight: "bold", fill: white)[Wound \ Monofilament]))

  // 3) 左侧粗管路：自进料框绕行至底部挤出机
  line((5.6, 5.0), (4.15, 5.0), (4.15, 1.7), (5.5, 1.7),
    stroke: (paint: cPipe, thickness: 0.4cm, cap: "round", join: "round"))

  // 4) 筒体指向进料框的粗箭头（单块箭形，箭头朝左指向进料框）
  line((8.62, 4.95), (8.18, 4.95), (8.18, 4.62), (7.82, 5.15), (8.18, 5.68), (8.18, 5.35), (8.62, 5.35),
    fill: cArrow, stroke: none, close: true)

  // 5) 机械进料框（白底盖住管路端头）
  rect((5.2, 3.5), (7.8, 6.8), fill: white, stroke: (paint: rgb("#2E75B6"), thickness: 1.4pt))

  // 6) 两只进料轮：灰圆 + 蓝色顺时针弧形箭头
  for cy in (5.95, 4.6) {
    line(..ell-pts(6.5, cy, 0.56, 0.56), fill: cGray,
      stroke: (paint: rgb("#9A9A9A"), thickness: 0.7pt), close: true)
    line(..ell-pts(6.5, cy, 0.33, 0.33, a0: 2.6, a1: -0.7, n: 20),
      stroke: (paint: rgb("#2E75B6"), thickness: 1.8pt, cap: "round"),
      mark: (end: "stealth"))
  }
  content((6.5, 3.78), align(center, text(size: 8pt, weight: "bold", fill: black)[Mechanical Feed]))

  // 7) 温度控制挤出机（蓝紫块带箭头尖）
  line((5.55, 1.2), (8.6, 1.2), (9.15, 1.7), (8.6, 2.2), (5.55, 2.2), (5.55, 1.2),
    fill: cExtra, stroke: none, close: true)
  content((7.0, 1.7), align(center, text(size: 7.5pt, weight: "bold", fill: white)[Temperature \ Controlled Extruder]))

  // 8) 过热器与喷管（红色块 + 喷管锥）
  line((9.25, 1.2), (11.55, 1.2), (11.55, 2.2), (9.25, 2.2), (9.25, 1.2),
    fill: cSuper, stroke: none, close: true)
  line((11.65, 1.2), (14.1, 1.7), (11.65, 2.2), (11.65, 1.2),
    fill: cNoz, stroke: none, close: true)
  content((10.4, 1.7), align(center, text(size: 7.5pt, weight: "bold", fill: white)[Superheater]))
  content((12.55, 1.7), align(center, text(size: 7.5pt, weight: "bold", fill: white)[Nozzle]))
})
