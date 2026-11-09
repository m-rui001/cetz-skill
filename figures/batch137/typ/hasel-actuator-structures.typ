#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 复现 Actuators 2024, 13, 524, Fig. 3 干净线稿（DOI 10.3390/act13120524）：
// (A) Peano-HASEL 直线执行器：金色上下端板夹持透明亚克力立柱，中部黑色折纸电极堆叠；
// (B) 堆叠环形执行器：金色同心环柱体 + 中央黑腔 + 两侧黑色手风琴式引出脚。
#canvas({
  import draw: *

  // ---- 共享配色与助手 ----
  let gold = rgb(140, 128, 28)
  let golddk = rgb(87, 79, 13)
  let cream = rgb(245, 237, 189)
  let creamedge = rgb(209, 194, 115)
  let dk = rgb(23, 23, 23)
  let grey = rgb(140, 140, 140)
  let glass = rgb(219, 232, 240)
  let body = rgb(201, 189, 112)
  let bandc = rgb(107, 97, 33)
  let lerp = (a, b, t) => (a.at(0) + t * (b.at(0) - a.at(0)), a.at(1) + t * (b.at(1) - a.at(1)))
  // 半椭圆下半段折线（用于柱面弧线）
  let lowpts(c, r_x, r_y) = range(0, 33).map(i => {
    let a = calc.pi * (1 + i / 32)
    (c.at(0) + r_x * calc.cos(a), c.at(1) + r_y * calc.sin(a))
  })
  // 整椭圆折线（CeTZ 无 ellipse，用闭合折线代替）
  let ell(c, r_x, r_y, n: 64) = range(0, n).map(i => {
    let a = 2 * calc.pi * i / n
    (c.at(0) + r_x * calc.cos(a), c.at(1) + r_y * calc.sin(a))
  })

  // ================= 面板 (A) =================
  // 透明亚克力左右立柱
  for x in (0.62, 4.18) {
    rect((x, 2.30), (x + 0.28, 11.42), fill: glass.transparentize(60%), stroke: (paint: grey, thickness: 0.6pt))
  }
  // 顶部金色端板（下缘带切角）
  line((0.45, 12.85), (4.65, 12.85), (4.65, 12.05), (4.22, 11.42), (0.88, 11.42), (0.45, 12.05),
       close: true, fill: gold, stroke: (paint: golddk, thickness: 1pt))
  // 底部金色端板（梯形）
  line((0.52, 1.52), (4.58, 1.52), (4.78, 2.14), (0.32, 2.14),
       close: true, fill: gold, stroke: (paint: golddk, thickness: 1pt))
  // 端板螺栓孔：上板两侧大孔、中央三小孔，下板三孔
  for (x, r) in ((0.88, 0.13), (4.22, 0.13)) {
    circle((x, 12.15), radius: r, fill: white, stroke: (paint: golddk, thickness: 0.6pt))
  }
  for x in (1.92, 2.55, 3.18) {
    circle((x, 12.15), radius: 0.055, fill: white, stroke: (paint: golddk, thickness: 0.5pt))
  }
  for x in (1.45, 2.55, 3.65) {
    circle((x, 1.83), radius: 0.09, fill: white, stroke: (paint: golddk, thickness: 0.6pt))
  }

  // 折纸堆叠：层间折射线（先画，被电极条遮挡后仅在中缝露出）
  let y0 = 2.95
  let dy = 1.42
  for i in range(5) {
    let ya = y0 + i * dy + 0.60
    let yb2 = y0 + (i + 1) * dy + 0.05
    if calc.even(i) {
      line((3.90, ya), (1.18, yb2), stroke: (paint: rgb(60, 60, 60), thickness: 2.2pt))
    } else {
      line((1.18, ya), (3.90, yb2), stroke: (paint: rgb(60, 60, 60), thickness: 2.2pt))
    }
  }
  // 六层电极：米色介电层 + 黑色电极条（左右交替微偏）
  for i in range(6) {
    let y = y0 + i * dy
    let ox = if calc.even(i) { -0.06 } else { 0.06 }
    rect((0.98, y + 0.08), (4.10, y + 0.82), fill: cream, stroke: (paint: creamedge, thickness: 0.6pt))
    rect((1.10 + ox, y), (4.00 + ox, y + 0.58), fill: dk, stroke: none)
  }
  // 端板与堆叠之间的连接杆
  line((2.55, 11.42), (2.55, 10.58), stroke: (paint: dk, thickness: 2pt))
  line((2.55, 2.92), (2.55, 2.14), stroke: (paint: dk, thickness: 2pt))

  // ================= 面板 (B) =================
  let cx = 15.30
  let yt = 8.45
  let yb = 5.35
  let rx = 3.30
  let ry = 1.15

  // 柱体正面：矩形主体 + 下缘弧形底
  rect((cx - rx, yb), (cx + rx, yt), fill: body, stroke: none)
  line(..lowpts((cx, yb), rx, ry), close: true, fill: body, stroke: none)
  // 环形层叠带
  for k in range(1, 7) {
    let y = yb + k * (yt - yb) / 7
    line(..lowpts((cx, y), rx, ry), stroke: (paint: bandc, thickness: 0.9pt))
  }
  // 清膜白色包带
  line(..lowpts((cx, yb + 5.4 * (yt - yb) / 7), rx, ry),
       stroke: (paint: white.transparentize(20%), thickness: 3.2pt))
  // 柱体两侧轮廓与底缘
  line((cx - rx, yt), (cx - rx, yb), stroke: (paint: bandc, thickness: 1pt))
  line((cx + rx, yt), (cx + rx, yb), stroke: (paint: bandc, thickness: 1pt))
  line(..lowpts((cx, yb), rx, ry), stroke: (paint: bandc, thickness: 1pt))

  // 顶面同心环（由外向内，闭合折线模拟椭圆）
  let rings = (
    (1.00, rgb(237, 237, 235)), (0.91, rgb(204, 191, 92)),
    (0.84, rgb(230, 219, 140)), (0.76, rgb(184, 168, 71)),
    (0.68, rgb(230, 219, 140)), (0.59, rgb(178, 163, 66)),
    (0.49, rgb(222, 212, 128)), (0.40, dk),
  )
  for (rr, cc) in rings {
    line(..ell((cx, yt), rx * rr, ry * rr), close: true, fill: cc,
         stroke: (paint: rgb(115, 107, 51), thickness: 0.5pt))
  }

  // 两侧黑色手风琴式引出脚（s = -1 左，+1 右）
  let tab(s) = {
    let xi = cx + s * (rx - 0.30)
    let xo = cx + s * (rx + 1.00)
    let pT = (xi, 7.30)
    let pB = (xo, 6.85)
    let pC = (xo, 5.90)
    let pD = (xi, 5.55)
    // 手风琴折叠块
    line(pT, pB, pC, pD, close: true, fill: dk, stroke: none)
    // 折叠肋：自内上角向外缘扇形展开
    for t in (0.10, 0.28, 0.46, 0.64, 0.82) {
      line((xi, 7.02), lerp(pB, pC, t), stroke: (paint: rgb(155, 155, 155), thickness: 0.6pt))
    }
    // 折弯引出脚（黑色折带）
    line((xi, 6.10), (cx + s * (rx + 0.85), 5.05), (cx + s * (rx + 0.45), 4.32),
         stroke: (paint: dk, thickness: 5pt, cap: "round", join: "round"))
  }
  tab(-1)
  tab(1)

  // ================= 面板标号 =================
  content((0.42, 13.35), text(size: 15pt, weight: "bold", fill: black)[(A)], anchor: "west")
  content((10.90, 13.35), text(size: 15pt, weight: "bold", fill: black)[(B)], anchor: "west")
})
