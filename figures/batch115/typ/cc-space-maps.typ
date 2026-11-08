// 编译外观：双面板运动学映射图，黑色线稿 + 灰色填充。
// (a) 横排三圆 q / κ,φ,ℓ / x；上凸弧箭头左→中 f_specific、中→右 f_independent；
//   下凸弧箭头中→左 f_specific^{-1}、右→中 f_independent^{-1}；圆上下六组多行
//   文字块，(a) 居中于下方。
// (b) 左：x–z 轴，以 (r,0) 为圆心的三同心弧（外弧过原点），端点 (r(1−cosθ), r sinθ)，
//   径向线 r 与圆心角 θ 箭头；右：灰色四分之一弯管穿过竖直/水平两灰平面，管口椭圆，
//   外缘 ℓ 双箭头、r = 1/κ 引线、基部 x/z 轴与 φ 旋转弧箭头，(b) 居中于下方。
// 来源：Unlocking the Potential of Cable-Driven Continuum Robots: A Comprehensive Review and Future
//   Directions. Actuators 2024, 13(2), 52, Figure 14. DOI 10.3390/act13020052.
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1cm, {
  import draw: *
  // 共享工具：极坐标点 / 多行文字 / 圆心定位弧（arc 锚点在起点）/ 黑点
  let pt(c, r, a) = (c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a))
  let ml(..ls) = ls.pos().map(text).join(linebreak())
  let arc-at(c, r, a0, a1, ..st) = arc(pt(c, r, a0), start: a0, stop: a1, radius: r, ..st)
  let dot(p) = circle(p, radius: 0.06, fill: black, stroke: none)
  // (a) 映射弧箭头：按凸向取圆上端点，弦长反解圆心，标签置于弧顶
  let map-arc(a, b, dir, label) = {
    let s = if b.at(0) > a.at(0) { 1 } else { -1 }
    let p0 = pt(a, 0.7, if dir > 0 { 90deg - s * 45deg } else { 270deg + s * 45deg })
    let p1 = pt(b, 0.7, if dir > 0 { 90deg + s * 45deg } else { 270deg - s * 45deg })
    let dx = p1.at(0) - p0.at(0)
    let dy = p1.at(1) - p0.at(1)
    let len = calc.sqrt(dx * dx + dy * dy)
    let h = calc.sqrt(1.9 * 1.9 - len * len / 4)
    let c = ((p0.at(0) + p1.at(0)) / 2 + dir * s * h * dy / len,
             (p0.at(1) + p1.at(1)) / 2 - dir * s * h * dx / len)
    arc-at(c, 1.9, calc.atan2(p0.at(0) - c.at(0), p0.at(1) - c.at(1)),
           calc.atan2(p1.at(0) - c.at(0), p1.at(1) - c.at(1)), stroke: 0.9pt, mark: (end: "stealth"))
    let apex = pt(c, 1.9, if dir > 0 { 90deg } else { 270deg })
    content((apex.at(0), apex.at(1) + dir * 0.12), label,
            anchor: if dir > 0 { "south" } else { "north" })
  }
  // (a) 三圆节点 + 六文字块：表驱动
  let nodes = (
    ((0, 0), $q$, ml("Cable/", "rod/tube", "lengths"), ml("Actuator", "space")),
    ((3.4, 0), $kappa, phi, ell$, ml("Arc", "params"), ml("Config.", "space")),
    ((6.8, 0), $x$, ml("Position", "Orientation"), ml("Task", "space")),
  )
  for (at, body, above, below) in nodes {
    circle(at, radius: 0.7, stroke: 0.9pt)
    content(at, body)
    content((at.at(0), 0.95), above, anchor: "south")
    content((at.at(0), -0.95), below, anchor: "north")
  }
  // (a) 四条弧箭头：上排正向、下排反向带上标 -1
  let maps = (
    ((0, 0), (3.4, 0), 1, $f_"specific"$),
    ((3.4, 0), (6.8, 0), 1, $f_"independent"$),
    ((3.4, 0), (0, 0), -1, $f_"specific"^(-1)$),
    ((6.8, 0), (3.4, 0), -1, $f_"independent"^(-1)$),
  )
  for m in maps { map-arc(..m) }
  content((3.4, -2.2), strong[(a)])

  group({
    translate((0, -6.4))
    // (b) 左：x–z 轴；(r,0) 圆心三同心弧，外弧过原点
    let r = 2.3
    let th = 70deg
    let C = (r, 0)
    let T = (r * (1 - calc.cos(th)), r * calc.sin(th))
    line((-1.1, 0), (r + 1.1, 0), stroke: 0.8pt, mark: (end: "stealth"))
    content((r + 1.25, 0), $x$, anchor: "west")
    line((0, -0.8), (0, r + 0.8), stroke: 0.8pt, mark: (end: "stealth"))
    content((0, r + 0.95), $z$, anchor: "south")
    for dr in (0, 0.3, 0.6) { arc-at(C, r - dr, 180deg, 180deg - th, stroke: 0.9pt) }
    // (b) 左：圆心/端点黑点 + 坐标标签、径向线 r、圆心角 θ
    dot(C)
    dot(T)
    content((r, -0.25), $(r, 0)$, anchor: "north")
    content((T.at(0) + 0.1, T.at(1) + 0.2), $(r(1 - cos theta), r sin theta)$, anchor: "south-west")
    line(C, T, stroke: 0.7pt)
    content(((C.at(0) + T.at(0)) / 2 + 0.3, T.at(1) / 2), $r$, anchor: "west")
    arc-at(C, 0.9, 180deg, 180deg - th, stroke: 0.7pt, mark: (end: "stealth"))
    content(pt(C, 1.3, 180deg - th / 2), $theta$)

    group({
      translate((5.6, 0))
      // (b) 右：竖直在后 + 水平在基座的两灰平面
      line((-0.4, -0.4), (1.5, -0.4), (1.7, 2.9), (-0.2, 2.9),
           close: true, stroke: none, fill: luma(235))
      line((-1.6, -0.9), (2.2, -0.9), (2.8, -0.1), (-1.0, -0.1),
           close: true, stroke: none, fill: luma(215))
      // (b) 右：灰弯管 = 粗灰中心线 + 两侧细轮廓 + 管口椭圆
      line((0.3, -1.2), (0.3, 0.9), stroke: 9pt + luma(210))
      arc-at((1.2, 0.9), 0.9, 180deg, 90deg, stroke: 9pt + luma(210))
      line((1.2, 1.8), (2.3, 1.8), stroke: 9pt + luma(210))
      for o in (-0.16, 0.16) {
        line((0.3 + o, -1.2), (0.3 + o, 0.9), stroke: 0.7pt)
        arc-at((1.2, 0.9), 0.9 - o, 180deg, 90deg, stroke: 0.7pt)
        line((1.2, 1.8 - o), (2.3, 1.8 - o), stroke: 0.7pt)
      }
      circle((2.3, 1.8), radius: (0.07, 0.16), fill: luma(240), stroke: 0.7pt)
      // (b) 右：外缘弧长 ℓ 双箭头（三段路径，仅两端出箭头）
      line((-0.25, -0.7), (-0.25, 0.9), stroke: 0.9pt, mark: (start: "stealth"))
      arc-at((1.2, 0.9), 1.45, 180deg, 90deg, stroke: 0.9pt)
      line((1.2, 2.35), (2.5, 2.35), stroke: 0.9pt, mark: (end: "stealth"))
      content((-0.1, 1.9), $ell$, anchor: "east")
      // (b) 右：弯曲半径引线 r = 1/κ，两端黑点
      let P0 = pt((1.2, 0.9), 0.9, 135deg)
      let P1 = (2.6, -0.8)
      line(P0, P1, stroke: 0.9pt)
      dot(P0)
      dot(P1)
      content((1.35, 1.0), $r = 1/kappa$, anchor: "west")
      // (b) 右：基部 z 向上、x 向左下轴与 φ 旋转弧箭头
      line((0.3, -0.15), (0.3, 0.8), stroke: 1.6pt, mark: (end: "stealth"))
      content((0.5, 0.6), $z$, anchor: "west")
      line((0.3, -0.15), (-0.6, -0.5), stroke: 1.6pt, mark: (end: "stealth"))
      content((-0.75, -0.55), $x$, anchor: "east")
      arc-at((0.3, -0.55), 0.8, 210deg, 330deg, stroke: 0.9pt, mark: (end: "stealth"))
      content((0.85, -1.5), $phi$, anchor: "north")
    })
    content((4.0, -2.2), strong[(b)])
  })
})