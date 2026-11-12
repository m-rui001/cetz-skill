#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 编译效果：I-COUPS 多模式推进管路图。左侧四档压力梯（7 – 8 MPa、0.30 MPa、30 kPa、~1 kPa），档间虚线分隔、空心双线箭头；
// 中央主链自上而下：高压气瓶圆、带柄阀、三通（左 Pressure sensor、右 Drain valve）、机械调压器（蝴蝶结+三角旗）、高压截止阀、
// 三通右接 Pressure sensor、调节阀、左下传感器经虚线 Feedback control（旋转标签）反馈、Drain valve、低压气瓶、Flow restrictor（矩形+双弧）、离子推力器阀与喷管；
// 右侧歧管分两组冷气支路，各 2 截止阀→4 推力器阀→4 喷管，底标 CT1 CT2 CT6 CT7 与 CT3 CT4 CT5 CT8；离子与冷气支路间竖直虚线分隔。
// 来源：Propulsion Technologies for CubeSats: Review, Aerospace 2024, 11(7), 502, Figure 36. DOI 10.3390/aerospace11070502
// 地标坐标：主链/压力梯/虚线隔线 x，主链与右支路 y，冷气组表（x 偏移+CT 名）与歧管端点
#let (mx, lx, sx) = (0, -2.6, 3.6)
#let (y-tank, y-v1, y-tee1, y-sep1, y-reg, y-cut, y-tee2, y-sep2) = (11.25, 9.75, 9.0, 8.45, 8.05, 7.15, 6.65, 6.45)
#let (y-regv, y-tee3, y-ltank, y-tee4, y-res, y-ionv, y-noz) = (5.95, 5.0, 4.35, 3.75, 2.95, 1.95, 1.2)
#let (y-man, y-cut2, y-man2, y-cgv, y-cnoz, y-ct) = (5.6, 4.3, 3.45, 2.75, 1.9, 0.45)
#let (dx, gx) = (0.95, (4.3, 10.9))
#let groups = ((x: gx.at(0), cts: ("CT1", "CT2", "CT6", "CT7")), (x: gx.at(1), cts: ("CT3", "CT4", "CT5", "CT8")))
#let (man-x0, man-x1) = (gx.at(0) + dx, gx.at(1) + 2 * dx)

// 共享 helper：右/左侧标签
#let lab-r(at, t) = draw.content(at, t, anchor: "west", padding: 0.3)
#let lab-l(at, t) = draw.content(at, t, anchor: "east", padding: 0.25)
// 共享 helper：蝴蝶结阀（两三角形尖对尖，白底遮管）
#let valve(at) = {
  let (x, y) = at
  draw.line((x - 0.28, y + 0.35), (x + 0.28, y + 0.35), (x, y), close: true, fill: white)
  draw.line((x - 0.28, y - 0.35), (x + 0.28, y - 0.35), (x, y), close: true, fill: white)
}
// 共享 helper：T 柄阀（柄朝上或朝右）
#let drain(at, side) = {
  let (x, y) = at
  valve(at)
  if side == "top" { draw.line((x, y + 0.35), (x, y + 0.5), (x - 0.2, y + 0.5), (x + 0.2, y + 0.5)) }
  else { draw.line((x + 0.28, y), (x + 0.55, y), (x + 0.55, y - 0.18), (x + 0.55, y + 0.18)) }
}
// 共享 helper：传感器小圆 / 气瓶大圆（居中文字）
#let sensor(at) = draw.circle(at, radius: 0.18, fill: white)
#let tank(at, r, t) = { draw.circle(at, radius: r, fill: white); draw.content(at, t) }
// 共享 helper：喷管（小矩形+下扩梯形）
#let nozzle(x, yt) = {
  draw.rect((x - 0.22, yt - 0.5), (x + 0.22, yt), fill: white)
  draw.line((x - 0.22, yt - 0.5), (x + 0.22, yt - 0.5), (x + 0.42, yt - 1.1), (x - 0.42, yt - 1.1), close: true, fill: white)
}
// 共享 helper：流量限制器（矩形+相向双弧）
#let restrictor(at) = {
  let (x, y) = at
  draw.rect((x - 0.28, y - 0.4), (x + 0.28, y + 0.4), fill: white)
  draw.arc((x - 0.42 + 0.42 * calc.cos(-65deg), y + 0.42 * calc.sin(-65deg)), radius: 0.42, start: -65deg, stop: 65deg)
  draw.arc((x + 0.42 + 0.42 * calc.cos(115deg), y + 0.42 * calc.sin(115deg)), radius: 0.42, start: 115deg, stop: 245deg)
}
// 共享 helper：机械调压器（蝴蝶结+右三角旗）
#let regulator(at) = {
  let (x, y) = at
  valve(at)
  draw.line((x + 0.05, y + 0.3), (x + 0.5, y + 0.3), (x + 0.5, y - 0.4), close: true, fill: white)
}
// 共享 helper：空心双线箭头（ya 尾、yb 尖）
#let harrow(x, ya, yb) = {
  let s = if yb > ya { 1 } else { -1 }
  let yh = yb - s * 0.3
  draw.line((x - 0.05, ya), (x - 0.05, yh), (x - 0.16, yh), (x, yb), (x + 0.16, yh), (x + 0.05, yh), (x + 0.05, ya), close: true, fill: white)
}

#canvas({
  import draw: *
  // 左压力梯：三条虚线分隔、八支空心箭头、四档压力标签
  for (y, x1) in ((y-sep1, sx), (y-sep2, sx), (2.55, -1.0)) { line((lx - 0.8, y), (x1, y), stroke: (dash: "dashed")) }
  for (ya, yb) in ((10.45, 12.0), (9.8, 8.5), (7.6, 8.4), (7.0, 6.5), (4.6, 6.4), (3.9, 2.6), (1.8, 2.5), (1.2, 0.55)) { harrow(lx, ya, yb) }
  for (y, t) in ((10.1, [7 – 8 MPa]), (7.35, [0.30 MPa]), (4.35, [30 kPa]), (1.5, [\~1 kPa])) { content((lx, y), t) }
  // 主管与高压段：气瓶、带柄阀、三通左传感器右排放阀、调压器、截止阀
  line((mx, y-tank - 1.0), (mx, y-noz))
  tank((mx, y-tank), 1.0, [High\ pressure\ gas tank])
  drain((mx, y-v1), "right")
  line((-0.75, y-tee1), (1.1, y-tee1))
  sensor((-0.75, y-tee1))
  lab-l((-0.75, y-tee1), [Pressure\ sensor])
  drain((1.1, y-tee1), "top")
  lab-r((1.1, y-tee1), [Drain valve])
  regulator((mx, y-reg))
  lab-r((0.5, y-reg), [Mechanical pressure regulator])
  valve((mx, y-cut))
  lab-r((0.28, y-cut), [High-pressure cutoff valve\ (latching valve)])
  // 中段：三通右接压力传感器；调节阀、排放阀、低压气瓶及其左传感器
  line((mx, y-tee2), (5.95, y-tee2))
  sensor((5.95, y-tee2))
  lab-r((5.95, y-tee2), [Pressure sensor])
  valve((mx, y-regv))
  lab-r((0.28, y-regv), [Regulation valve\ (solenoid valve)])
  line((mx, y-tee3), (1.1, y-tee3))
  drain((1.1, y-tee3), "top")
  lab-r((1.1, y-tee3), [Drain valve])
  circle((mx, y-ltank), radius: 0.45, fill: white)
  lab-r((0.45, y-ltank - 0.15), [Low pressure\ gas tank])
  line((mx, y-tee4), (-0.75, y-tee4))
  sensor((-0.75, y-tee4))
  lab-l((-0.75, y-tee4 - 0.45), [Pressure\ sensor])
  // 虚线反馈：下传感器→调节阀，旋转 Feedback control 标签
  line((-0.75, y-tee4 + 0.18), (-0.75, y-regv), (-0.3, y-regv), stroke: (dash: "dashed"), mark: (end: ">", stroke: 1pt))
  content((-1.45, 5.0), [Feedback\ control], angle: 90deg)
  // 末段：限制器、离子推力器阀、喷管；离子/冷气竖直虚线隔线
  restrictor((mx, y-res))
  lab-r((0.28, y-res), [Flow restrictor])
  valve((mx, y-ionv))
  lab-r((0.28, y-ionv), [Ion thruster valve\ (solenoid valve)])
  nozzle(mx, y-noz)
  lab-r((0.42, 0.65), [Ion thruster])
  line((sx, y-sep2), (sx, 0.0), stroke: (dash: "dashed"))
  // 右歧管：传感器管段下折接水平歧管
  line((man-x0, y-tee2), (man-x0, y-man), (man-x1, y-man))
  // 冷气双组循环：2 截止阀→四路歧管→4 推力器阀→喷管+CT 标签
  for g in groups {
    let xs = range(4).map(i => g.x + i * dx)
    for cx in (xs.at(1), xs.at(2)) {
      line((cx, y-man), (cx, y-cut2 + 0.35))
      valve((cx, y-cut2))
      line((cx, y-cut2 - 0.35), (cx, y-man2))
    }
    line((xs.at(0), y-man2), (xs.at(3), y-man2))
    for (i, cx) in xs.enumerate() {
      line((cx, y-man2), (cx, y-cgv + 0.35))
      valve((cx, y-cgv))
      line((cx, y-cgv - 0.35), (cx, y-cnoz))
      nozzle(cx, y-cnoz)
      content((cx, y-ct), [#g.cts.at(i)])
    }
  }
  // 冷气三档共用标签（两组之间）
  content((9.1, y-cut2), [Cold-gas cutoff valves\ (solenoid valves)])
  content((9.1, y-cgv), [Cold-gas\ thruster valves\ (solenoid valves)])
  content((9.1, 1.4), [Cold-gas thrusters])
})
