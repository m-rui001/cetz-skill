#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 画面：左侧为四角带配重块的弯曲网面（6×6 网格），网面上一处青色小椭圆引出线指向右侧放大图；
// 放大图内两段品红缆索单元、节点 i/j、位置矢量 r、r_i、r_j、r_ix、r_jx 及 o-XYZ 坐标系；右上为初始构型标尺与 l0。
// 来源：Aerospace 2025, 12, 277, Figure 43（Shan/Guo/Gill, ANCF 网面柔性建模）. DOI 10.3390/aerospace12040277

#set text(size: 9pt)

#canvas({
  import draw: *

  // 配色与线宽
  let cnet = rgb("#c026d3")
  let ccyan = rgb("#49c3da")
  let ccyan-l = rgb("#9fe0ee")
  let thin = 0.7pt

  // 网面四角与整体鼓起量
  let tl = (0.45, 7.28)
  let tr = (3.84, 5.94)
  let bl = (0.45, 1.79)
  let br = (3.90, 0.64)
  let bulge = (-0.30, 0.12)

  // 双线性插值 + 鼓包：网面参数点
  let pnet(u, v) = {
    let w = ((1 - u) * (1 - v), u * (1 - v), (1 - u) * v, u * v)
    let cs = (tl, tr, bl, br)
    let x = 0.0
    let y = 0.0
    for k in range(4) {
      x += w.at(k) * cs.at(k).at(0)
      y += w.at(k) * cs.at(k).at(1)
    }
    let g = calc.sin(calc.pi * u) * calc.sin(calc.pi * v)
    // 网线轻微起伏，模拟松弛网面
    let wx = 0.055 * calc.sin(3 * calc.pi * v) * calc.sin(calc.pi * u)
    let wy = 0.055 * calc.sin(3 * calc.pi * u) * calc.sin(calc.pi * v)
    (x + bulge.at(0) * g + wx, y + bulge.at(1) * g + wy)
  }

  // 可旋转椭圆的采样点
  let ell(c, rx, ry, ang: 0deg, n: 72) = {
    let (cx, cy) = c
    let ca = calc.cos(ang)
    let sa = calc.sin(ang)
    let pts = ()
    for k in range(n) {
      let t = 2 * calc.pi * k / n
      let px = rx * calc.cos(t)
      let py = ry * calc.sin(t)
      pts.push((cx + px * ca - py * sa, cy + px * sa + py * ca))
    }
    pts
  }

  // 网面：6×6 网格线
  let n = 6
  for k in range(n + 1) {
    let u = k / n
    line(..range(25).map(i => pnet(u, i / 24)), stroke: (paint: cnet, thickness: thin))
    line(..range(25).map(i => pnet(i / 24, u)), stroke: (paint: cnet, thickness: thin))
  }

  // 四角配重块：淡青晕圈 + 实心点
  for c in (tl, tr, bl, br) {
    circle(c, radius: 0.17, fill: ccyan-l.transparentize(45%), stroke: none)
    circle(c, radius: 0.085, fill: ccyan, stroke: none)
  }

  // 网面上被放大的小区域
  line(..ell((2.56, 4.25), 0.62, 0.23, ang: -10deg), close: true, stroke: (paint: ccyan, thickness: 1pt))

  // 引出线与标签
  line((3.18, 4.12), (6.42, 3.72), stroke: (paint: black, thickness: 0.6pt))
  content((4.98, 4.14), [Cable element], anchor: "south")

  // 放大视图外框
  line(..ell((7.87, 3.00), 1.79, 1.15, ang: 8deg), close: true, stroke: (paint: ccyan, thickness: 1.2pt))

  // 两段缆索单元
  bezier((8.06, 4.24), (8.16, 3.55), (7.60, 2.70), (7.70, 1.76), stroke: (paint: cnet, thickness: 0.9pt))
  bezier((9.20, 4.16), (9.24, 3.50), (8.70, 2.55), (8.98, 1.76), stroke: (paint: cnet, thickness: 0.9pt))

  // 节点 i、j
  let ni = (7.83, 3.51)
  let nj = (8.96, 3.13)
  for p in (ni, nj) {
    circle(p, radius: 0.10, fill: white, stroke: (paint: cnet, thickness: 0.9pt))
  }
  content((7.54, 3.35), [Node $i$], anchor: "east")
  content((9.85, 3.42), [Node $j$], anchor: "west")

  // 变形构型坐标系
  let o = (7.30, 0.96)
  let arrow = (end: "stealth", fill: black, scale: 0.5)
  line(o, (7.36, 2.10), mark: arrow, stroke: thin)
  line(o, (8.40, 1.30), mark: arrow, stroke: thin)
  line(o, (6.56, 1.36), mark: arrow, stroke: thin)
  content((6.98, 1.62), [Z], anchor: "east")
  content((8.52, 1.38), [X], anchor: "west")
  content((6.42, 1.16), [Y], anchor: "east")
  content((7.26, 0.82), [$o$], anchor: "north-east")

  // 位置矢量 r、r_i、r_j
  line(o, ni, mark: arrow, stroke: thin)
  line(o, nj, mark: arrow, stroke: thin)
  line(o, (8.30, 2.86), mark: arrow, stroke: thin)
  content((7.35, 2.55), [$r_i$], anchor: "east")
  content((8.52, 1.72), [$r_j$], anchor: "west")
  content((8.22, 2.58), [$bold(r)$], anchor: "west")

  // 节点处局部矢量 r_ix、r_jx
  line(ni, (8.08, 4.12), mark: (end: "stealth", fill: black, scale: 0.45), stroke: 0.6pt)
  content((8.16, 3.94), [$r_(i x)$], anchor: "west")
  line(nj, (9.50, 2.98), mark: (end: "stealth", fill: black, scale: 0.45), stroke: 0.6pt)
  content((9.80, 2.92), [$r_(j x)$], anchor: "west")

  // 初始构型标尺 0–x，长度 l0
  line((6.53, 6.38), (8.92, 6.38), mark: (end: "stealth", fill: black, scale: 0.55), stroke: thin)
  line((6.53, 6.26), (6.53, 6.50), stroke: thin)
  content((6.42, 6.20), [0], anchor: "north-east")
  content((8.18, 6.50), [$x$], anchor: "south")
  content((9.00, 6.30), [$l_0$], anchor: "west")
  content((7.72, 5.84), [Original configuration], anchor: "north")

  // 网面下方的抛体标注
  content((2.32, 0.70), [Bullet], anchor: "east")
  line((2.40, 0.66), (3.78, 0.53), stroke: 0.6pt)
  content((7.85, 0.40), [Deformed configuration], anchor: "north")
})
