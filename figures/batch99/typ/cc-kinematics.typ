// 编译效果：(a) 上排三空间映射——三个黑描边圆 q / κ,φ,ℓ / x，圆上下为空间名
//   多行文字，圆间上弧箭头 f_specific、f_independent，下弧反向箭头带上标 -1；
//   (b) 下排左：x-z 轴 + 常曲率弧带（同心双弧+中线+径向封口），圆心 (r,0)、
//   双向箭头半径 r、角 θ、端点公式标签；右：两灰平面间浅灰 bezier 弯管，
//   弧长 ℓ 弧箭头、半径 r=1/κ 双向箭头、基部粗 x/z 箭头与水平面内 φ 弧箭头。
// 来源：Unlocking the Potential of Cable-Driven Continuum Robots: A Comprehensive
//   Review and Future Directions. Actuators 2024, 13(2), 52. DOI 10.3390/act13020052, Fig. 14.
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 11pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 语义常量：(a) 圆半径/圆间距/弧凸高；(b) 左圆心半径 r、弯曲角 θ、弧带半宽、整体下移
#let R = 0.85
#let DX = 4.6
#let H = 2.3
#let CR = 2.5
#let TH = 76deg
#let A0 = 180deg
#let A1 = 180deg - TH
#let BW = 0.28
#let BY = -8.6

// 小工具：极坐标点、向量加、多行文字
#let pt(c, r, a) = (c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a))
#let vadd(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
#let ml(..ls) = ls.pos().map(text).join(linebreak())
// arc 锚点在起点而非圆心 → 自行换算起点
#let arc-at(c, r, a0, a1, ..st) = draw.arc(pt(c, r, a0), start: a0, stop: a1, radius: r, ..st)

// 共享 helper：空间圆（圆 + 内数学 + 上下多行标签）
#let space-circle(at, inner, above, below) = {
  draw.circle(at, radius: R, stroke: 1pt)
  draw.content(at, inner)
  draw.content((at.at(0), at.at(1) + R + 0.25), above, anchor: "south")
  draw.content((at.at(0), at.at(1) - R - 0.25), below, anchor: "north")
}
// 共享 helper：映射弧（dir=1 上凸/标签在上，dir=-1 下凸/标签在下，箭头指向 b）
#let map-arc(a, b, dir, label) = {
  let s = if b.at(0) > a.at(0) { 1 } else { -1 }
  let sa = if dir > 0 { 90deg - s * 45deg } else { 270deg + s * 45deg }
  let ea = if dir > 0 { 90deg + s * 45deg } else { 270deg - s * 45deg }
  let p0 = pt(a, R, sa)
  let p1 = pt(b, R, ea)
  let mx = (p0.at(0) + p1.at(0)) / 2
  draw.bezier(p0, p1, (mx - s * 0.6, dir * H), (mx + s * 0.6, dir * H),
    stroke: 1pt, mark: (end: "stealth"))
  draw.content((mx, dir * (H * 0.78 + 0.3)), label,
    anchor: if dir > 0 { "south" } else { "north" })
}
// 共享 helper：坐标轴箭头 + 轴名
#let axis-arrow(a, b, label, anchor: "west", thick: 0.8pt) = {
  draw.line(a, b, stroke: thick, mark: (end: "stealth"))
  draw.content(b, label, anchor: anchor)
}
// 共享 helper：弧带 = 同心双弧 + 细中线 + 两端径向封口
#let arc-band(c, r0, r1, a0, a1) = {
  arc-at(c, r0, a0, a1, stroke: 1.2pt)
  arc-at(c, r1, a0, a1, stroke: 1.2pt)
  arc-at(c, (r0 + r1) / 2, a0, a1, stroke: 0.5pt)
  draw.line(pt(c, r0, a0), pt(c, r1, a0), stroke: 1.2pt)
  draw.line(pt(c, r0, a1), pt(c, r1, a1), stroke: 1.2pt)
}
// 共享 helper：水平 + 竖直两灰平面（闭合四点填充）
#let plane-3d(horiz, vert) = {
  draw.line(..horiz, close: true, stroke: none, fill: luma(215))
  draw.line(..vert, close: true, stroke: none, fill: luma(235))
}

#canvas(length: 1cm, {
  import draw: *
  // (a) 三个空间圆：表驱动循环
  let circles = (
    ((0, 0), $q$, ml("Cable/", "rod/tube", "lengths"), ml("Actuator", "space")),
    ((DX, 0), $kappa, phi, ell$, ml("Arc", "params"), ml("Config.", "space")),
    ((2 * DX, 0), $x$, ml("Position", "Orientation"), ml("Task", "space")),
  )
  for c in circles { space-circle(..c) }
  // (a) 四条映射弧：表驱动循环（上排正向、下排反向带 -1）
  let maps = (
    ((0, 0), (DX, 0), 1, $f_"specific"$),
    ((DX, 0), (2 * DX, 0), 1, $f_"independent"$),
    ((DX, 0), (0, 0), -1, $f_"specific"^(-1)$),
    ((2 * DX, 0), (DX, 0), -1, $f_"independent"^(-1)$),
  )
  for m in maps { map-arc(..m) }
  content((DX, -4.0), strong[(a)])

  // (b) 整体下移一组
  group({
    translate((0, BY))
    // (b) 左：x-z 直角坐标
    axis-arrow((-1.3, 0), (4.2, 0), $x$)
    axis-arrow((0, -1.2), (0, 3.6), $z$, anchor: "south")
    // (b) 左：常曲率弧带，圆心/半径/起止角为常量
    let C = (CR, 0)
    arc-band(C, CR - BW, CR + BW, A0, A1)
    // (b) 左：圆心黑点 + (r,0)；端点黑点 + 公式坐标标签（公式直接算坐标）
    let P = (CR * (1 - calc.cos(TH)), CR * calc.sin(TH))
    circle(C, radius: 0.06, fill: black, stroke: none)
    circle(P, radius: 0.06, fill: black, stroke: none)
    content((CR, -0.25), $(r, 0)$, anchor: "north")
    content(vadd(P, (0.55, 0.25)), $(r(1 - cos theta), r sin theta)$, anchor: "south")
    // (b) 左：细半径线 + 偏置双向箭头尺寸线 + r 标签 + 端部延长细线
    let d = ((P.at(0) - CR) / CR, P.at(1) / CR)
    let off = (d.at(1) * 0.4, -d.at(0) * 0.4)
    line(C, P, stroke: 0.5pt)
    line(vadd(C, off), vadd(P, off), stroke: 0.7pt, mark: (start: "stealth", end: "stealth"))
    let mid = ((CR + P.at(0)) / 2, P.at(1) / 2)
    content(vadd(mid, (off.at(0) + 0.25, off.at(1))), $r$, anchor: "west")
    line(P, vadd(P, (d.at(0) * 0.5, d.at(1) * 0.5)), stroke: 0.5pt)
    // (b) 左：圆心处角弧 θ
    arc-at(C, 1.0, A0, A1, stroke: 0.7pt, mark: (end: "stealth"))
    content(pt(C, 1.4, 142deg), $theta$)

    // (b) 右：三维弯管子图
    group({
      translate((6.2, 0.3))
      // 两灰平面：水平 + 竖直
      plane-3d(
        ((-0.8, -1.7), (4.9, -1.7), (5.5, 0.5), (-0.2, 0.5)),
        ((0.8, -1.7), (3.3, -1.7), (3.6, 3.1), (1.1, 3.5)),
      )
      // 浅灰弯管：粗灰中心线 + 两侧轮廓 bezier + 管口椭圆
      bezier((1.5, -1.7), (3.6, 2.5), (1.5, 1.5), (1.9, 2.5), stroke: 5pt + luma(210))
      bezier((1.32, -1.7), (3.6, 2.68), (1.32, 1.5), (1.8, 2.68), stroke: 0.8pt + luma(120))
      bezier((1.68, -1.7), (3.6, 2.32), (1.68, 1.3), (2.0, 2.32), stroke: 0.8pt + luma(120))
      circle((3.6, 2.5), radius: (0.09, 0.18), fill: luma(240), stroke: 0.8pt + luma(120))
      // 管外侧弧长 ℓ 弧箭头（下到管口）
      bezier((1.0, -0.9), (3.7, 2.95), (1.0, 2.7), (1.7, 2.95),
        stroke: 1.2pt, mark: (start: "stealth", end: "stealth"))
      content((0.75, 2.2), $ell$)
      // 水平面内圆心到管中段：半径双向箭头 r = 1/κ
      line((4.4, -1.3), (1.8, 1.5), stroke: 1.2pt, mark: (start: "stealth", end: "stealth"))
      content((3.2, 0.9), $r = 1/kappa$, anchor: "west")
      // 基部粗箭头 z 向上、x 向左下
      axis-arrow((1.5, -0.3), (1.5, 1.1), $z$, thick: 2pt)
      axis-arrow((1.5, -0.3), (0.2, -0.8), $x$, anchor: "south-east", thick: 2pt)
      // 水平面内转角 φ 弧箭头
      arc-at((1.6, 0.6), 1.3, 235deg, 315deg, stroke: 1.2pt, mark: (end: "stealth"))
      content((2.3, -0.95), $phi$, anchor: "north")
    })
    content((5.2, -2.5), strong[(b)])
  })
})