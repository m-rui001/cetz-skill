#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 三阶段 HASEL 执行器工作原理：扁平囊袋(加电压V1)→液体向两端聚集(应力/液压，V2)→两端鼓胀成环(V3)，
// 蓝线为电极、上排红"+"下排蓝"−"，绿箭头为麦克斯韦应力、红箭头为液压。来源：Actuators 2024, 13, 524, Fig.2。DOI 10.3390/act13120524。
#canvas({
  import draw: *

  // 配色
  let orange = rgb("#F2A03D")
  let blue = rgb("#2BA6DC")
  let green = rgb("#11964B")
  let red = rgb("#E23B2E")
  let ink = rgb("#1A1A1A")

  // 圆角部件：中心、宽、高、圆角半径
  let part(c, w, h, r) = (c: c, w: w, h: h, r: r)

  // 三明治式囊体：外蓝边、白隔隙、内橙液体（同色多层叠加，接缝不可见）
  let blob(parts, grow, fill) = {
    for p in parts {
      let (x, y) = p.c
      rect((x - p.w / 2 - grow, y - p.h / 2 - grow),
           (x + p.w / 2 + grow, y + p.h / 2 + grow),
           radius: p.r + grow, fill: fill, stroke: none)
    }
  }

  // 接地符号：竖杆 + 三级横线
  let gnd(x) = {
    line((x, 3.0), (x, 2.84), stroke: ink + 0.9pt)
    line((x - 0.25, 2.84), (x + 0.25, 2.84), stroke: ink + 0.9pt)
    line((x - 0.16, 2.76), (x + 0.16, 2.76), stroke: ink + 0.9pt)
    line((x - 0.07, 2.68), (x + 0.07, 2.68), stroke: ink + 0.9pt)
  }

  // 右端高压端子：引线 + 竖杆 + 圆点 + 标号
  let term(x, label) = {
    line((x, 3.0), (x + 0.38, 3.0), stroke: ink + 0.9pt)
    line((x + 0.38, 3.0), (x + 0.38, 3.28), stroke: ink + 0.9pt)
    circle((x + 0.38, 3.35), radius: 0.05, fill: ink, stroke: none)
    content((x + 0.47, 3.33), text(size: 9.5pt, weight: "bold", fill: ink)[#label], anchor: "west")
  }

  // 电荷符号
  let charges(ys, xs, sym, col) = {
    for x in xs {
      content((x, ys), text(size: 11pt, weight: "bold", fill: col)[#sym])
    }
  }

  // 红：液压向外的辐射箭头
  let radial(c, len, angles) = {
    for a in angles {
      let d = (calc.cos(a * 1deg), calc.sin(a * 1deg))
      line(c, (c.at(0) + d.at(0) * len, c.at(1) + d.at(1) * len),
        stroke: red + 0.9pt, mark: (end: "stealth", fill: red, scale: 0.55))
    }
  }

  // 绿：竖直应力箭头
  let press(xs, y0, y1) = {
    for x in xs {
      line((x, y0), (x, y1), stroke: green + 0.9pt,
        mark: (end: "stealth", fill: green, scale: 0.55))
    }
  }

  // 标题
  content((8.2, 6.45), text(size: 12.5pt, weight: "bold", fill: ink)[Working principle of HASEL])
  content((8.2, 6.05), text(size: 12.5pt, weight: "bold", fill: ink)[actuators])

  // ---- 阶段一：扁平囊袋，电场建立，液体被挤压 ----
  let s1 = (part((2.9, 3.0), 4.3, 0.95, 0.32),)
  blob(s1, 0.13, blue)
  blob(s1, 0.06, white)
  blob(s1, 0.0, orange)
  // 上电极（实线）与下电极（虚线）
  line((1.15, 3.63), (4.55, 3.63), stroke: blue + 2.4pt)
  line((1.5, 2.33), (4.5, 2.33), stroke: (paint: blue, thickness: 2.6pt, dash: "densely-dashed"))
  charges(3.85, (1.5, 2.0, 2.5, 3.0, 3.5, 4.0), "+", red)
  charges(2.06, (1.75, 2.25, 2.75, 3.25, 3.75), "−", blue)
  // 左侧接地、右侧 V1
  line((0.75, 3.0), (0.35, 3.0), stroke: ink + 0.9pt)
  gnd(0.35)
  term(5.05, "V1")
  // 内部麦克斯韦应力：弯曲箭头 + 直箭头
  for x in (1.3, 1.85, 2.4) {
    bezier((x, 3.26), (x - 0.34, 3.10), (x - 0.34, 2.86), (x, 2.74),
      stroke: green + 0.9pt, mark: (end: "stealth", fill: green, scale: 0.55))
  }
  press((3.0, 3.45, 3.9), 3.26, 2.74)
  // 标注
  content((0.72, 1.68), text(size: 9pt, weight: "bold", fill: ink)[Self-healing\ dielectric liquid], anchor: "west")
  line((1.6, 1.96), (1.9, 2.52), stroke: ink + 0.7pt)
  content((4.5, 1.68), text(size: 9pt, weight: "bold", fill: ink)[Elastomeric\ shell])
  line((4.5, 1.96), (4.5, 2.45), stroke: ink + 0.7pt)
  content((3.45, 4.32), text(size: 9pt, weight: "bold", fill: ink)[Electrode])
  line((3.95, 4.18), (4.4, 3.74), stroke: ink + 0.7pt)

  // ---- 阶段二：液体向两端聚集，中段收缩 ----
  let s2 = (part((7.0, 3.0), 1.55, 1.3, 0.5), part((9.7, 3.0), 1.55, 1.3, 0.5), part((8.35, 3.0), 2.7, 0.6, 0.08))
  line((7.0, 2.5), (9.7, 2.5), stroke: (paint: blue, thickness: 2.6pt, dash: "densely-dashed"))
  blob(s2, 0.13, blue)
  blob(s2, 0.06, white)
  blob(s2, 0.0, orange)
  line((6.2, 3.8), (7.0, 3.82), (7.85, 3.43), (8.85, 3.43), (9.7, 3.82), (10.5, 3.8),
    stroke: blue + 2.4pt, curve: "spline")
  charges(3.62, (7.35, 7.75, 8.15, 8.55, 8.95), "+", red)
  line((6.22, 3.0), (5.85, 3.0), stroke: ink + 0.9pt)
  gnd(5.85)
  term(10.48, "V2")
  radial((7.0, 3.0), 0.42, (30, 90, 150, 210, 270, 330))
  radial((9.7, 3.0), 0.42, (30, 90, 150, 210, 270, 330))
  press((7.35, 7.75, 8.15, 8.55, 8.95), 3.18, 2.86)
  // 标注
  content((7.85, 1.58), text(size: 9pt, weight: "bold", fill: ink)[Maxwell stress])
  line((7.95, 1.76), (8.2, 2.88), stroke: ink + 0.7pt)
  content((10.05, 1.95), text(size: 9pt, weight: "bold", fill: ink)[Hydraulic pressure])
  line((9.95, 2.12), (9.6, 2.66), stroke: ink + 0.7pt)

  // ---- 阶段三：完全鼓胀，两端成环，中段拉伸变细 ----
  let s3 = (part((12.25, 3.0), 1.25, 1.25, 0.45), part((15.05, 3.0), 1.25, 1.25, 0.45), part((13.65, 3.0), 2.3, 0.5, 0.06))
  line((12.6, 2.55), (14.7, 2.55), stroke: (paint: blue, thickness: 2.6pt, dash: "densely-dashed"))
  blob(s3, 0.13, blue)
  blob(s3, 0.06, white)
  blob(s3, 0.0, orange)
  line((11.65, 3.78), (12.3, 3.8), (13.1, 3.38), (14.2, 3.38), (15.0, 3.8), (15.65, 3.78),
    stroke: blue + 2.4pt, curve: "spline")
  charges(3.56, (12.95, 13.3, 13.65, 14.0, 14.35), "+", red)
  line((11.62, 3.0), (11.35, 3.0), stroke: ink + 0.9pt)
  gnd(11.35)
  term(15.68, "V3")
  radial((12.25, 3.0), 0.38, (30, 90, 150, 210, 270, 330))
  radial((15.05, 3.0), 0.38, (30, 90, 150, 210, 270, 330))
  press((12.9, 13.25, 13.6, 13.95, 14.3), 3.12, 2.84)
})
