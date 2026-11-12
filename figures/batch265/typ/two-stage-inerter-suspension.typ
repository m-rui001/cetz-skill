#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：两级惯容器（ISD）悬架机械网络线稿。上端子经并联弹簧 k1 与阻尼 c1 构成第一级，汇于中节点后
// 再经并联弹簧 k2、惯容器 b、阻尼 c2 构成第二级，终接下端子；右侧蓝字 the first stage / the second stage
// 以蓝箭头标出两级。逐字保留 k1、c1、k2、b、c2 与 the first/second stage；原图右侧硬件照片略去。
// 来源：Actuators 2025, 14, 485, Figure 5 "The inerter suspension proposed by Li". DOI 10.3390/act14100485

#canvas({
  import draw: *
  let ink = black
  let blue = rgb("#2b4fbf")
  let t(pos, s, size: 8pt, anchor: "center", fill: ink) = content(
    pos, text(size: size, fill: fill)[#s], anchor: anchor, frame: none)
  let l2(a, b) = line(a, b, stroke: 0.9pt + ink)
  let aa(a, b) = line(a, b, stroke: 0.9pt + ink, mark: (end: "stealth", scale: 0.5))
  let arrb(a, b) = line(a, b, stroke: 1pt + blue, mark: (end: "stealth", scale: 0.55, fill: blue))
  let node(p) = circle(p, radius: 0.065, fill: white, stroke: 0.9pt + ink)
  // 竖直弹簧：上下引线＋四折锯齿
  let spring(x, y1, y2) = {
    let amp = 0.20
    let ya = y1 - 0.20
    let yb = y2 + 0.20
    let dy = ya - yb
    l2((x, y1), (x, ya))
    line((x, ya), (x + amp, ya - dy * 0.125), (x - amp, ya - dy * 0.375),
      (x + amp, ya - dy * 0.625), (x - amp, ya - dy * 0.875), (x, yb),
      stroke: 0.9pt + ink)
    l2((x, yb), (x, y2))
  }
  // 竖直阻尼器：上杆＋活塞＋油缸，缸底接下端
  let damper(x, y1, y2) = {
    let ym = (y1 + y2) / 2
    l2((x, y1), (x, ym + 0.10))
    line((x - 0.18, ym + 0.13), (x - 0.18, ym - 0.13), (x + 0.18, ym - 0.13),
      (x + 0.18, ym + 0.13), stroke: 0.9pt + ink)
    l2((x - 0.08, ym + 0.10), (x + 0.08, ym + 0.10))
    l2((x, ym - 0.13), (x, y2))
  }

  // 端子与两级并联横梁
  node((2.20, 9.55))
  l2((2.20, 9.49), (2.20, 9.30))
  l2((0.90, 9.30), (3.50, 9.30))
  l2((0.90, 7.60), (3.50, 7.60))
  node((2.20, 7.60))
  l2((0.90, 5.55), (3.50, 5.55))
  l2((2.20, 5.55), (2.20, 5.20))
  node((2.20, 5.20))
  // 第一级：k1 与 c1
  spring(0.90, 9.30, 7.60)
  damper(3.50, 9.30, 7.60)
  // 第二级：k2、b、c2
  spring(0.90, 7.60, 5.55)
  damper(3.50, 7.60, 5.55)
  l2((2.20, 7.60), (2.20, 7.40))
  rect((1.98, 7.27), (2.42, 6.55), fill: white, stroke: 0.9pt + ink)
  t((2.20, 6.91), [$b$], size: 8.4pt)
  l2((2.20, 6.55), (2.20, 5.55))
  // 参数标注
  t((0.48, 8.45), [$k_1$], size: 9pt)
  t((3.18, 8.38), [$c_1$], size: 9pt)
  t((0.48, 6.58), [$k_2$], size: 9pt)
  t((3.18, 6.36), [$c_2$], size: 9pt)
  // 两级说明与蓝色指示箭头
  t((4.85, 8.62), [the first stage], size: 8pt, anchor: "west")
  arrb((4.78, 8.52), (3.74, 8.52))
  t((4.85, 6.52), [the second stage], size: 8pt, anchor: "west")
  arrb((4.78, 6.42), (3.74, 6.42))
})
