#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 9pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 三子图线稿：a 接近路径与捕获瞬间，b 自旋消旋与接近方向，c 柔性刷消旋与对接环法向
// 来源：Aerospace 2025, 12, 277, Figure 26（CAD 渲染转干净线稿平涂）. DOI 10.3390/aerospace12040277.
#canvas({
  import draw: *

  // —— 共享配色 ——
  let panel = rgb("#1c3fb0")
  let pedge = rgb("#14287a")
  let bodyc = rgb("#dad4ea")
  let bedge = rgb("#8f8aa8")
  let targ = rgb("#b9ac25")
  let tedge = rgb("#7d6f0d")
  let twine = rgb("#2f7d32")
  let red = rgb("#d81f1f")
  let dblue = rgb("#26427b")

  // 助手：服务星（本体 + 左右太阳翼）
  let craft(at, rot, plen: 1.9, pw: 0.5, bw: 0.8, bh: 0.8) = group({
    translate(at)
    rotate(rot)
    rect((-bw/2 - plen, -pw/2), (-bw/2, pw/2), fill: panel, stroke: pedge, radius: 0.03)
    rect((bw/2, -pw/2), (bw/2 + plen, pw/2), fill: panel, stroke: pedge, radius: 0.03)
    rect((-bw/2, -bh/2), (bw/2, bh/2), fill: bodyc, stroke: bedge, radius: 0.05)
    rect((-bw*0.3, -bh*0.1), (bw*0.3, bh*0.35), fill: rgb("#c7bfdc"), stroke: none)
  })

  // 助手：失效卫星（橄榄色本体 + 太阳翼，可选对接环）
  let target(at, rot, plen-l: 2.5, plen-r: 2.5, pw: 0.55, bw: 1.0, bh: 0.95, ring: false) = group({
    translate(at)
    rotate(rot)
    rect((-bw/2 - plen-l, -pw/2), (-bw/2, pw/2), fill: panel, stroke: pedge, radius: 0.03)
    rect((bw/2, -pw/2), (bw/2 + plen-r, pw/2), fill: panel, stroke: pedge, radius: 0.03)
    rect((-bw/2, -bh/2), (bw/2, bh/2), fill: targ, stroke: tedge, radius: 0.05)
    if ring {
      circle((0, 0), radius: 0.36, fill: rgb("#a9c322"), stroke: (paint: rgb("#2f6b1f"), thickness: 0.9pt, dash: "dashed"))
      circle((0, 0), radius: 0.13, fill: rgb("#d8c93a"), stroke: rgb("#7d6f0d"))
    }
  })

  // 助手：椭圆弧折线（角度制起止，可虚线、可末端箭头）
  let arcline(c, rx, ry, a0, a1, col, dash: none, arrow: true, thick: 1.1pt) = {
    let n = 30
    let pts = range(0, n + 1).map(i => {
      let a = a0 + (a1 - a0) * i / n
      (c.at(0) + rx * calc.cos(a), c.at(1) + ry * calc.sin(a))
    })
    line(..pts, stroke: (paint: col, thickness: thick, dash: dash),
      mark: if arrow { (end: "stealth", fill: col) } else { none })
  }

  // 助手：红色绕竖轴旋转箭头
  let spin(c, rx: 0.82, ry: 0.3) = arcline(c, rx, ry, 200deg, 520deg, red)

  // 子图 a：接近路径 + 捕获
  craft((3.2, 11.5), 20deg, plen: 1.7)
  // 绿色捕获臂与爪
  line((3.45, 11.15), (4.35, 10.65), stroke: (paint: twine, thickness: 1.2pt))
  line((4.35, 10.65), (4.12, 10.12), stroke: (paint: twine, thickness: 1.1pt))
  line((4.35, 10.65), (4.64, 10.25), stroke: (paint: twine, thickness: 1.1pt))
  // 倾斜失效卫星与旋转箭头
  target((6.35, 9.4), -25deg)
  spin((6.5, 10.15))
  content((7.8, 10.3), $omega$, fill: red)
  content((5.9, 12.85), align(left)[Capturing\ (2m)])
  line((5.6, 12.6), (4.55, 11.35), stroke: (paint: rgb("#555555"), thickness: 0.6pt))
  content((7.7, 7.75), align(center)[Failed\ Spacecraft])
  // 虚线弧表示接近路径（自平台向上弯向捕获点）
  bezier((3.9, 3.6), (0.6, 4.2), (0.2, 8.4), (1.9, 10.7),
    stroke: (paint: black, thickness: 1pt, dash: "dashed"), mark: (end: "stealth", fill: black))
  content((2.7, 6.6), align(center)[Approach Path\ (60m)])
  // 下方服务平台
  craft((3.7, 2.4), 15deg, plen: 1.6)
  line((3.45, 2.75), (2.8, 3.3), stroke: (paint: twine, thickness: 1.2pt))
  line((2.8, 3.3), (2.63, 3.08), stroke: (paint: twine, thickness: 1.1pt))
  line((2.8, 3.3), (2.87, 3.53), stroke: (paint: twine, thickness: 1.1pt))
  content((5.4, 1.4), align(center)[Service\ Platform])
  content((3.7, 0.35), text(size: 10pt)[a])

  // 子图 b：自旋消旋 + 接近方向
  craft((12.7, 11.9), 15deg, plen: 2.0)
  // 绿色系绳与小弯钩
  line((12.56, 11.45), (12.48, 10.45), stroke: (paint: twine, thickness: 1.1pt))
  line((12.88, 11.45), (12.82, 10.45), stroke: (paint: twine, thickness: 1.1pt))
  line((12.48, 10.45), (12.36, 10.05), (12.5, 9.82), (12.72, 9.92), (12.82, 10.2), (12.82, 10.45),
    stroke: (paint: twine, thickness: 1.1pt))
  // 绕系绳的虚线自旋指示
  arcline((12.65, 10.0), 0.62, 0.26, 150deg, 390deg, black, dash: "dashed", thick: 0.8pt)
  content((13.85, 10.35), align(left)[Spin up])
  // 接近方向（蓝色虚线箭头）
  content((10.35, 8.3), align(center)[Approach\ Direction])
  line((11.6, 8.6), (11.6, 6.95),
    stroke: (paint: dblue, thickness: 1.0pt, dash: "dashed"), mark: (end: "stealth", fill: dblue))
  // 目标（宽太阳翼）
  target((12.7, 6.1), 0deg, plen-l: 3.0, plen-r: 3.0, pw: 0.28)
  // H 轴双箭头与旋转箭头
  line((12.7, 6.7), (12.7, 8.45), stroke: (paint: red, thickness: 1.1pt),
    mark: (start: "stealth", end: "stealth"))
  content((12.95, 8.5), align(left)[H-axis])
  spin((12.7, 6.9), rx: 0.9)
  content((14.0, 6.95), $omega$, fill: red)
  // 本体向下的红色虚线（姿态作用方向）
  line((12.7, 5.6), (11.95, 4.5), stroke: (paint: red, thickness: 0.8pt, dash: "dashed"))
  line((12.7, 5.6), (13.45, 4.5), stroke: (paint: red, thickness: 0.8pt, dash: "dashed"))
  content((12.7, 0.35), text(size: 10pt)[b])

  // 子图 c：柔性刷消旋 + 对接环法向
  craft((18.2, 11.7), 15deg, plen: 1.8)
  // 黑色柔性刷（三条弯曲刷毛）
  bezier((17.9, 11.25), (17.7, 10.7), (18.15, 10.45), (17.95, 9.9),
    stroke: (paint: black, thickness: 2.6pt))
  bezier((18.15, 11.2), (17.95, 10.65), (18.4, 10.4), (18.2, 9.85),
    stroke: (paint: black, thickness: 2.6pt))
  bezier((18.4, 11.15), (18.2, 10.6), (18.65, 10.35), (18.45, 9.8),
    stroke: (paint: black, thickness: 2.6pt))
  // 左侧标签避开太阳翼与刷毛
  content((16.6, 9.85), align(center)[Flexible\ Brush])
  content((19.3, 8.35), align(center)[De-tumbling])
  // 虚线弧表示消旋机动路径（箭头指向目标）
  bezier((19.6, 9.6), (22.4, 9.3), (22.8, 7.0), (21.5, 6.2),
    stroke: (paint: black, thickness: 1pt, dash: "dashed"), mark: (end: "stealth", fill: black))
  // 大太阳翼目标与对接环
  target((20.6, 4.6), 0deg, plen-l: 2.9, plen-r: 2.9, pw: 0.6, bw: 1.15, bh: 1.1, ring: true)
  spin((20.6, 5.85), rx: 0.72)
  content((21.55, 6.15), $omega$, fill: red)
  content((17.2, 3.1), align(center)[Normal Direction of\ Docking Ring])
  line((19.1, 3.5), (20.15, 4.25),
    stroke: (paint: red, thickness: 0.8pt, dash: "dashed"), mark: (end: "stealth", fill: red))
  content((20.6, 0.35), text(size: 10pt)[c])
})
