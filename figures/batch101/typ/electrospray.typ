// 编译效果：左灰底圆角矩形 "Propellant Storage"（两行），右缘骑墙小圆 V；
//   中右浅灰大矩形 chamber（细蓝描边）；V 向右水平灰色渐尖发射针，管内黑虚线
//   右箭头 + "Sprayed Propellant"；针尖右 "Ions/droplets" 骑在浅灰扩张喷雾锥上，
//   锥伸出右壁；壁外黑虚线右箭头 + 两行 "Electrostatically / Accelerated Ions"；
//   chamber 内右部上下镜像各两组竖直窄栅极：Extractor（虚线）/ Accelerator
//   （点划线），标签竖排旋转 90°；右下斜置蓝灰粗棒 Neutralizer + 文字；
//   左上 "Flow Control"、中上 "Emitter" 斜指箭头分别指 V 与针身上表面。
// 来源：Propulsion Technologies for CubeSats: Review. Aerospace 2024, 11(7), 502.
//   DOI 10.3390/aerospace11070502, Figure 20 (electrospray / FEEP schematic).
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 11pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 语义常量：chamber 四壁、轴线 yC、针尖/针半高、栅极中心 x/间距/宽/离轴间隙
#let CX0 = 0
#let CX1 = 10
#let CYT = 3
#let CYB = -3
#let YC = 0
#let NX = 7.3
#let NH = 0.28
#let GX = 7.9
#let GD = 1.1
#let GW = 0.6
#let GG = 0.8

// 共享 helper：圆角矩形 + 居中两行标签
#let rounded-box(a, b, label) = {
  draw.rect(a, b, radius: 0.5, fill: luma(200), stroke: 1pt)
  draw.content(((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2), label)
}
// 共享 helper：骑墙阀门小圆 + 字母
#let valve-circle(at, r, label) = {
  draw.circle(at, radius: r, fill: white, stroke: 1pt)
  draw.content(at, label)
}
// 共享 helper：竖直窄栅极，kind 决定虚线/点划线描边；标签竖排（content angle 90°，自下而上）
#let grid-electrode(x, y0, y1, kind, label) = {
  let dash = if kind == "dashed" { "dashed" } else { "dash-dotted" }
  draw.rect((x - GW / 2, y0), (x + GW / 2, y1), stroke: (dash: dash, thickness: 1pt))
  draw.content((x, (y0 + y1) / 2), label, angle: 90deg)
}
// 共享 helper：文字标签 + 斜指箭头（箭头自标签下方指向 target）
#let point-label(at, target, label) = {
  draw.content(at, label, anchor: "south")
  draw.line((at.at(0), at.at(1) - 0.4), target, stroke: 1pt, mark: (end: "triangle"))
}
// 共享 helper：浅灰喷雾锥（顶点 tip，右底 x1、半高 half）
#let spray-cone(tip, x1, half) = {
  draw.line(tip, (x1, YC + half), (x1, YC - half), close: true, fill: luma(200), stroke: none)
}
// 共享 helper：黑虚线右箭头 + 箭头右侧标签（多行时垂直居中骑轴）
#let dashed-arrow(a, b, label) = {
  // 箭头单独实线+黑填，避免继承虚线描边导致空心碎头
  draw.line(a, b, stroke: (dash: "dashed", thickness: 1.5pt),
    mark: (end: "triangle", length: 0.3, width: 0.22, stroke: 1pt, fill: black))
  draw.content((b.at(0) + 0.15, b.at(1)), label, anchor: "west")
}

#canvas(length: 1cm, {
  import draw: *
  // chamber 浅灰底（先画底，锥叠其上，最后补蓝描边使壁线压在锥上）
  rect((CX0, CYB), (CX1, CYT), fill: luma(235), stroke: none)
  // 喷雾锥：针尖向右扩张、伸出右壁
  spray-cone((NX, YC), CX1 + 0.3, 0.55)
  rect((CX0, CYB), (CX1, CYT), fill: none, stroke: 1pt + rgb("#3a5a8c"))
  // 推进剂贮箱 + 骑在左壁上的阀门 V
  rounded-box((-3.1, -1.65), (0, 1.65), [Propellant\ Storage])
  valve-circle((CX0, YC), 0.35, [V])
  // 渐尖发射针：闭合五点（左上下、右肩上下、右尖）填灰
  line((0.3, NH), (NX - 0.45, NH), (NX, YC), (NX - 0.45, -NH), (0.3, -NH),
    close: true, fill: luma(200), stroke: 1pt + luma(110))
  // 管内黑虚线箭头 + 骑管文字
  dashed-arrow((0.7, YC), (2.5, YC), [Sprayed Propellant])
  // 针尖右文字（骑在锥上）
  content((NX + 0.15, YC), [Ions/droplets], anchor: "west")
  // 右壁外虚线箭头 + 两行标签
  dashed-arrow((CX1, YC), (CX1 + 1.6, YC), [Electrostatically\ Accelerated Ions])
  // 上下镜像栅极：单循环 over (+1,-1)，Extractor 虚线 / Accelerator 点划线
  for s in (1, -1) {
    let ya = YC + s * GG
    let yb = if s == 1 { CYT } else { CYB }
    grid-electrode(GX, ya, yb, "dashed", [Extractor])
    grid-electrode(GX + GD, ya, yb, "dashdot", [Accelerator])
  }
  // 右下斜置蓝灰粗棒 Neutralizer + 文字
  line((9.4, -2.3), (10.0, -1.7), stroke: 5pt + rgb("#5a708c"))
  content((9.45, -1.5), [Neutralizer], anchor: "south-west")
  // 指针标签：Flow Control 指 V，Emitter 指针身上表面
  point-label((1.7, 2.0), (0.1, 0.4), [Flow Control])
  point-label((4.2, 1.5), (3.6, NH + 0.05), [Emitter])
})
