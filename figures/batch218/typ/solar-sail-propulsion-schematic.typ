#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 太阳帆推进受力示意图：左下橙色太阳发出黄色 sunlight 束射向中心黑色帆面，反射光向右下；
// 蓝色轨道/净轨道曲线、绿色净推力矢量及其切向/法向分量平行四边形、35.5° 夹角。
// 来源：Aerospace 2024, 11(7), 502, Fig.31；DOI 10.3390/aerospace11070502
#canvas({
  import draw: *

  let O = (0, 0)
  let sun = rgb("#ff7f0e")
  let beam = rgb("#ffe000")
  let orb = rgb("#3b6fd4")
  let thrust = rgb("#33a02c")
  // 自帆心出发的矢量箭头
  let vec(to, col, w: 1pt) = line(O, to, mark: (end: "stealth", fill: col), stroke: (paint: col, thickness: w))

  // 太阳与入射 sunlight 束
  circle((-3.4, -3.4), radius: 0.3, fill: sun, stroke: 0.8pt)
  content((-4.2, -3.4), [Sun])
  line((-3.2, -3.2), O, stroke: (paint: beam, thickness: 3pt))
  content((-1.5, -2.5), [Sunlight])

  // 轨道与净轨道曲线（蓝色）
  bezier((-1.6, 1.7), (1.1, -2.7), (-0.6, 0.9), (0.7, -1.2), stroke: (paint: orb, thickness: 1pt))
  bezier((0.2, -0.2), (-2.6, 1.9), (-0.8, 0.9), (-1.8, 1.6),
    stroke: (paint: orb, thickness: 1pt), mark: (end: "stealth", fill: orb))
  content((-3.1, 2.1), [Net orbit])
  line((1.15, -2.9), (1.05, -2.0), mark: (end: "stealth", fill: orb), stroke: (paint: orb, thickness: 1pt))
  content((1.6, -2.4), [Orbit])
  content((1.0, -3.3), [Orbit velocity = $V_0$])

  // 帆面（倾斜粗黑条）与反射光
  line((-1.1, -0.23), (1.1, 0.23), stroke: (paint: black, thickness: 4pt))
  content((1.5, 0.4), [Sail])
  line(O, (1.7, -1.3), mark: (end: "stealth", fill: beam), stroke: (paint: beam, thickness: 4pt))
  content((3.1, -1.4), [Reflected sunlight])

  // 35.5° 夹角弧与标注
  bezier((-0.78, -0.32), (-0.42, -0.78), (-0.62, -0.52), (-0.56, -0.62), stroke: 0.8pt)
  content((-1.45, -0.9), [35.5°])

  // 净推力（绿色）及切向/法向分量＋平行四边形
  vec((-0.1, 1.9), thrust)
  line(O, (0.2, -1.6), stroke: (paint: thrust, thickness: 0.8pt))
  content((-0.1, 2.45), [Net force \ (Thrust)])
  let perp = (0.9, 1.3)
  let tang = (-1.2, 0.9)
  vec(perp, black, w: 0.8pt)
  vec(tang, black, w: 0.8pt)
  line(perp, (-0.1, 1.9), stroke: 0.6pt)
  line(tang, (-0.1, 1.9), stroke: 0.6pt)
  content((2.7, 1.6), [Force perpendicular to orbit])
  content((-2.7, 0.2), [Force tangential to orbit])
})
