#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// ============================================================
// 微波电热推力器剖面示意图（重绘）
// 编译后外观：矩形外腔，顶部斜线阴影盖板，板中央嵌黑色收敛喷管喉部；
// 腔内竖线填充的内管，管顶灰色星芒状等离子体，其下空心弧形箭头表示
// 推进剂涡流（尾端右下、绕左侧回卷、箭头朝右）；管中部双水平线为分离板；
// 圆头天线杆自底部斜线阴影馈通穿入内管；右侧五条引出线依次标注
// Nozzle / Plasma / Propellant vortex / Separation plate / Antenna。
// 来源：Propulsion Technologies for CubeSats: Review. Aerospace 2024, 11(7), 502, Figure 18. DOI 10.3390/aerospace11070502.
// ============================================================
// ---- 命名地标（cm）----
#let cx = 4.0        // 中心轴 / 天线轴
#let wl = 0.0        // 外腔左壁
#let wr = 8.0        // 外腔右壁
#let pt-t = 7.6      // 顶板上缘
#let pt-b = 7.2      // 顶板下缘
#let tl = 2.0        // 内管左壁
#let tr = 6.0        // 内管右壁
#let tb = 1.45       // 内管底
#let sp-t = 4.5      // 分离板上横线
#let sp-b = 4.15     // 分离板下横线
#let fb = -2.1       // 底部馈通下端
#let lx = 9.0        // 标签列

#canvas(length: 1cm, {
  import draw: *
  let out = 0.9pt   // 轮廓线宽
  let thin = 0.35pt // 填充线宽

  // 斜45°阴影线：平行线族裁剪到矩形
  let hatch(x0, y0, x1, y1, s: 0.16) = {
    let w = x1 - x0
    let h = y1 - y0
    for i in range(calc.ceil((w + h) / s) + 1) {
      let d = -h + i * s
      let a = calc.max(0, -d)
      let b = calc.min(w - d, h)
      if a < b { line((x0 + d + a, y0 + a), (x0 + d + b, y0 + b), stroke: thin) }
    }
  }
  // 竖直填充线：内管剖面线
  let vfill(x0, x1, y0, y1, s: 0.16) = {
    for i in range(1, calc.floor((x1 - x0) / s)) {
      line((x0 + i * s, y0), (x0 + i * s, y1), stroke: thin)
    }
  }
  // 引出线 + 右侧标签
  let leader(target, ly, body) = {
    line(target, (lx - 0.15, ly), stroke: 0.7pt)
    content((lx, ly), anchor: "west", body)
  }

  // 外腔壁与顶板（顶板斜阴影）
  line((wl, 0), (wl, pt-b), stroke: out)
  line((wr, 0), (wr, pt-b), stroke: out)
  rect((wl, pt-b), (wr, pt-t), stroke: out)
  hatch(wl, pt-b, wr, pt-t)
  // 黑色收敛喷管喉部（沙漏形）嵌于顶板中央
  line((cx - 0.25, pt-t), (cx + 0.25, pt-t), (cx + 0.08, pt-b + 0.2),
       (cx + 0.15, pt-b - 0.1), (cx - 0.15, pt-b - 0.1), (cx - 0.08, pt-b + 0.2),
       close: true, fill: black, stroke: none)
  // 顶板下密封块：左实右空
  rect((1.25, pt-b - 0.18), (1.65, pt-b), fill: black, stroke: none)
  rect((6.35, pt-b - 0.18), (6.75, pt-b), fill: white, stroke: out)

  // 内管：竖线填充 + 三边轮廓
  vfill(tl, tr, tb, pt-b)
  line((tl, tb), (tl, pt-b), stroke: out)
  line((tr, tb), (tr, pt-b), stroke: out)
  line((tl, tb), (tr, tb), stroke: out)
  // 分离板：双水平线
  line((tl, sp-t), (tr, sp-t), stroke: out)
  line((tl, sp-b), (tr, sp-b), stroke: out)

  // 灰色星芒等离子体：交替半径角度环
  let pts = ()
  for i in range(60) {
    let a = i * 6deg
    let r = if calc.rem(i, 2) == 0 { 0.5 } else { 0.36 }
    pts.push((cx + r * calc.cos(a), 6.6 + r * calc.sin(a)))
  }
  line(..pts, close: true, fill: luma(110), stroke: none)

  // 推进剂涡流：空心弧带箭头（C形开口朝右，箭头右指）
  let (rx, ry, cy, th) = (1.5, 0.42, 5.55, 0.11)
  let pts = ()
  for i in range(25) { // 外缘：右下尾端绕左至右上
    let a = -60deg - i * 10deg
    pts.push((cx + (rx + th) * calc.cos(a), cy + (ry + th) * calc.sin(a)))
  }
  let ex = cx + rx * calc.cos(60deg)
  let ey = cy + ry * calc.sin(60deg)
  pts.push((ex + 0.04, ey + 0.3))
  pts.push((ex + 0.75, ey - 0.1))
  pts.push((ex - 0.04, ey - 0.3))
  for i in range(25) { // 内缘：回到尾端
    let a = -300deg + i * 10deg
    pts.push((cx + (rx - th) * calc.cos(a), cy + (ry - th) * calc.sin(a)))
  }
  line(..pts, close: true, fill: white, stroke: out)

  // 底部阶梯馈通外壳
  line((wl, 0), (2.5, 0), (2.5, -0.2), (3.1, -0.2), (3.1, fb),
       (4.9, fb), (4.9, -0.2), (5.5, -0.2), (5.5, 0), (wr, 0), stroke: out)
  // 馈通斜阴影：上宽下窄两段，带轮廓
  hatch(3.35, -0.65, 4.65, tb)
  rect((3.35, -0.65), (4.65, tb), stroke: out)
  hatch(3.6, fb, 4.4, -0.65)
  rect((3.6, fb), (4.4, -0.65), stroke: out)
  // 底面密封块：左实右空
  rect((2.8, 0), (3.2, 0.2), fill: black, stroke: none)
  rect((4.8, 0), (5.2, 0.2), fill: white, stroke: out)
  // 圆头天线杆：自馈通底部穿入内管
  let pts = ((cx - 0.21, fb), (cx - 0.21, 2.05))
  for i in range(1, 8) {
    let a = 180deg - i * 22.5deg
    pts.push((cx + 0.21 * calc.cos(a), 2.05 + 0.21 * calc.sin(a)))
  }
  pts.push((cx + 0.21, 2.05))
  pts.push((cx + 0.21, fb))
  line(..pts, fill: white, stroke: out)

  // 右侧引出线与标签（顺序同原文）
  leader((cx + 0.15, pt-t - 0.05), 6.4, [Nozzle])
  leader((cx, 6.6), 5.6, [Plasma])
  leader((5.0, 5.5), 4.3, [Propellant\ vortex])
  leader((5.2, sp-b), 2.75, [Separation\ plate])
  leader((cx, 1.6), 1.05, [Antenna])
})
