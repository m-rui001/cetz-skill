#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 编译外观：白底黑线稿卫星居中，左端蓝色三角羽流、右侧 40% 半透明蓝锥罩住灰色碎片，
// Arial 标签分列四周；来源：Mechanics of Space Debris Removal: A Review.
// Aerospace 2025, 12, 277, Figure 15. DOI 10.3390/aerospace12040277.

#canvas({
  import draw: *

  // 参考图像素 → 厘米；本体局部坐标系 (u, w) 带 0.364 斜切
  let k = 0.012
  let sh = 0.364
  let A(x, y) = (x * k, -y * k)
  let S(u, w) = A(191 + u + sh * w, 200 + w)
  let ln = 0.75pt + black
  let blue = rgb(0, 0, 255, 40%)
  let shell = rgb(0, 0, 0, 40%)
  let twoline(a, b) = {
    set par(leading: 0.35em)
    align(center)[#a \ #b]
  }

  // 离子束锥：先铺半透明蓝，后续图形压在其上
  line(A(522, 241), A(770, 140), A(843, 341), close: true, fill: blue, stroke: none)

  // 碎片帆板：与本体同斜切的四边形，40% 黑压住束流
  line(
    A(672, 156), A(734, 156), A(794, 321), A(733, 321),
    close: true, fill: shell, stroke: 0.5pt + rgb(70, 70, 70),
  )
  // 帆板下方灰色梯形支座
  line(
    A(750, 321), A(776, 321), A(798, 347), A(748, 347),
    close: true, fill: rgb(153, 153, 153), stroke: 0.5pt + rgb(70, 70, 70),
  )

  // 左端羽流三角，顶点落在喷管左腰
  line(A(164, 241), A(25, 204), A(52, 279), close: true, fill: blue, stroke: none)

  // 卫星本体：顶底边水平、左右腰斜切的矩形
  line(S(0, 0), S(219, 0), S(219, 84), S(0, 84), close: true, stroke: ln)
  // 左端小梯形喷管，上下顶点贴本体左腰
  line(S(0, 9), A(161, 230), A(168, 252), S(0, 78), close: true, stroke: ln)

  // 太阳翼助手：s = -1 向上、s = +1 向下，同一斜切系内镜像生长
  let wing(s) = {
    let base = 163.5
    let w0 = if s < 0 { 0 } else { 84 }
    let p(d, a) = S(base + a, w0 + s * d)
    // 颈：连接机身与帆板
    line(p(0, -19), p(0, 19), p(24, 19), p(24, -19), close: true, stroke: ln)
    // 帆板外框
    line(p(24, -37.5), p(24, 37.5), p(175, 37.5), p(175, -37.5), close: true, stroke: ln)
    // 2×2 分格：横缝 + 纵缝
    line(p(99.5, -37.5), p(99.5, 37.5), stroke: ln)
    line(p(24, 0), p(175, 0), stroke: ln)
  }
  for s in (-1, 1) { wing(s) }

  // 右端小矩形（推力器接口），左腰贴本体右腰
  line(S(219, 21), S(237, 21), S(237, 62), S(219, 62), close: true, stroke: ln)
  // 主推力器大锥：上折线自接口上角上行至锥顶、再斜下汇于锥底尖；下边自接口下角直达同一尖端
  line(S(237, 21), A(463, 168), A(515, 314), stroke: ln)
  line(S(237, 62), A(515, 314), stroke: ln)
  // 锥内小三角，尖端指向束流起点
  line(A(489, 229), A(522, 241), A(497, 256), close: true, stroke: ln)

  // 标签
  content(A(539, 70), [Ion beam shepherd])
  content(A(167, 353), twoline("Secondary", "thruster"))
  content(A(539, 353), twoline("Primary", "thruster"))
  content(A(772, 374), [Debris])
  // 沿束流方向倾斜的标签
  content(A(626, 263), [Ion beam], angle: -14deg)
})
