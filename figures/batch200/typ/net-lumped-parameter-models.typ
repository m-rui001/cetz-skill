#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 蓝底双面板：左侧正交缆索/集总参数网，右侧三角缆索网与四角质量点。
// 来源：Aerospace 2025, 12, 277 (debris) Figure 47，重绘为干净线稿平涂。

#canvas({
  import draw: *

  // 配色与线型
  let bg = rgb(35, 85, 155)
  let cable = rgb(215, 215, 215)
  let yellow = rgb(255, 245, 0)
  let magenta = rgb(235, 35, 220)
  let green = rgb(0, 195, 65)
  let red = rgb(230, 0, 0)
  let ink = rgb(8, 8, 8)
  let thin = (paint: ink, thickness: 0.55pt)
  let medium = (paint: ink, thickness: 1.4pt)

  // 两个蓝色面板与白字子图号
  rect((0, 0), (4.2, 4.2), fill: bg, stroke: none)
  rect((4.45, 0), (8.65, 4.2), fill: bg, stroke: none)
  content((0.95, 4.06), text(fill: white, size: 10pt, "(a)"), anchor: "north-west")
  content((4.59, 4.06), text(fill: white, size: 10pt, "(b)"), anchor: "north-west")

  // (a) 正交缆索网 / 集总参数网
  let ax0 = 0.85
  let ax1 = 3.35
  let ay0 = 0.65
  let ay1 = 3.50
  let nx = 7
  let ny = 7
  let d = 0.38

  // 四角灰色斜拉缆索及其坐标轴标记
  let corner_data = (
    (ax0, ay1, ax0 - d, ay1 + d),
    (ax1, ay1, ax1 + d, ay1 + d),
    (ax0, ay0, ax0 - d, ay0 - d),
    (ax1, ay0, ax1 + d, ay0 - d),
  )
  for c in corner_data {
    let x = c.at(0)
    let y = c.at(1)
    let ox = c.at(2)
    let oy = c.at(3)
    line((x, y), (ox, oy), stroke: (paint: cable, thickness: 2.0pt))
    line((ox - 0.13, oy), (ox + 0.17, oy), stroke: (paint: red, thickness: 1.2pt))
    line((ox, oy - 0.13), (ox, oy + 0.17), stroke: (paint: green, thickness: 1.2pt))
  }

  // 黄色竖向缆索与品红横向缆索
  for i in range(nx) {
    let x = ax0 + i * (ax1 - ax0) / (nx - 1)
    line((x, ay0), (x, ay1), stroke: (paint: yellow, thickness: 1.3pt))
  }
  for j in range(ny) {
    let y = ay0 + j * (ay1 - ay0) / (ny - 1)
    line((ax0, y), (ax1, y), stroke: (paint: magenta, thickness: 1.1pt))
  }

  // 交叉节点与四角连接节点
  for i in range(nx) {
    for j in range(ny) {
      let x = ax0 + i * (ax1 - ax0) / (nx - 1)
      let y = ay0 + j * (ay1 - ay0) / (ny - 1)
      circle((x, y), radius: 0.026, fill: rgb(255, 255, 190), stroke: none)
    }
  }
  for c in corner_data {
    circle((c.at(0), c.at(1)), radius: 0.033, fill: rgb(245, 245, 245), stroke: none)
  }

  // (b) 三角缆索网 / 绳网模型
  let bx0 = 5.45
  let bx1 = 7.85
  let by0 = 0.78
  let by1 = 3.42
  let ncx = 7
  let ncy = 7

  // 生成行列表节点坐标
  let nodes = ()
  for j in range(ncy) {
    let y = by0 + j * (by1 - by0) / (ncy - 1)
    let row = ()
    for i in range(ncx) {
      let x = bx0 + i * (bx1 - bx0) / (ncx - 1)
      row.push((x, y))
    }
    nodes.push(row)
  }

  // 细黑三角网：水平边与交叉斜边
  for j in range(ncy) {
    for i in range(ncx - 1) {
      line(nodes.at(j).at(i), nodes.at(j).at(i + 1), stroke: thin)
    }
  }
  for j in range(ncy - 1) {
    for i in range(ncx) {
      if i > 0 {
        line(nodes.at(j).at(i), nodes.at(j + 1).at(i - 1), stroke: thin)
      }
      if i < ncx - 1 {
        line(nodes.at(j).at(i), nodes.at(j + 1).at(i + 1), stroke: thin)
      }
    }
  }

  // 四角黄色质量点及其粗黑连接缆索
  let mass_tl = (5.05, 3.78)
  let mass_tr = (8.25, 3.78)
  let mass_bl = (5.05, 0.42)
  let mass_br = (8.25, 0.42)

  line(mass_tl, nodes.at(0).at(0), stroke: medium)
  line(mass_tl, nodes.at(0).at(1), stroke: medium)
  line(mass_tr, nodes.at(0).at(ncx - 1), stroke: medium)
  line(mass_tr, nodes.at(0).at(ncx - 2), stroke: medium)
  line(mass_bl, nodes.at(ncy - 1).at(0), stroke: medium)
  line(mass_bl, nodes.at(ncy - 1).at(1), stroke: medium)
  line(mass_br, nodes.at(ncy - 1).at(ncx - 1), stroke: medium)
  line(mass_br, nodes.at(ncy - 1).at(ncx - 2), stroke: medium)

  // 网内小黄节点
  for j in range(ncy) {
    for i in range(ncx) {
      circle(nodes.at(j).at(i), radius: 0.035, fill: yellow, stroke: none)
    }
  }

  // 四角大质量点
  for m in (mass_tl, mass_tr, mass_bl, mass_br) {
    circle(m, radius: 0.085, fill: yellow, stroke: none)
  }
})
