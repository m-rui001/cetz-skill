#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：左右两栏线稿。左栏两枚圆形介电膜（断电 / 通电），断电态标注顶/底电极与刚性框，
// 通电态圆心射出六支灰箭头表示径向膨胀；下方为膜剖面（上排红 + 下排黑 −）。
// 右栏两片三层压电层合板（断电 / 通电），通电板顶面满布红 +，标 Maxwell Stress 与 V 回路，
// 左右灰色大箭头示面内扩张，下方为两幅剖面与 z 向厚度标注。
// 来源：Actuators 2025, 14, 258, Figure 1（p4），DOI 10.3390/act14060258。

#canvas({
  import draw: *
  // 配色：中蓝电极、浅蓝介电膜、深青刚性框、灰箭头
  let blue = rgb("#77b2cc")
  let pale = rgb("#dceaf7")
  let ink = rgb("#104862")
  let gray = rgb("#b1bcc7")

  // 助手：灰色粗块箭头、黑色细引线、红加号、黑减号
  let garr(a, b, w: 5pt) = line(a, b, stroke: (paint: gray, thickness: w),
    mark: (end: "stealth", fill: gray, scale: 2.1))
  let lead(a, b) = line(a, b, stroke: (paint: black, thickness: 0.6pt),
    mark: (end: "stealth", fill: black, scale: 1.0))
  let plus(p) = {
    line((p.at(0) - 0.09, p.at(1)), (p.at(0) + 0.09, p.at(1)), stroke: (paint: red, thickness: 1.1pt))
    line((p.at(0), p.at(1) - 0.09), (p.at(0), p.at(1) + 0.09), stroke: (paint: red, thickness: 1.1pt))
  }
  let minus(p) = line((p.at(0) - 0.11, p.at(1)), (p.at(0) + 0.11, p.at(1)),
    stroke: (paint: black, thickness: 1.4pt))
  let lab(body) = text(size: 7.5pt, body)

  // ── 左栏：圆形介电膜执行器 ──
  // 单元：刚性框圆环 + 顶电极引线 + 底电极虚线 + 中心电极点；on 时加径向箭头
  let cell(c, on: false) = {
    circle(c, radius: 0.95, fill: pale, stroke: (paint: ink, thickness: 2.4pt))
    // 先画径向膨胀箭头，电极线与中心点后画压住
    if on {
      for a in (45, 90, 135, 225, 270, 315) {
        let v = (calc.cos(a * 1deg), calc.sin(a * 1deg))
        line((c.at(0) + 0.26 * v.at(0), c.at(1) + 0.26 * v.at(1)),
          (c.at(0) + 0.74 * v.at(0), c.at(1) + 0.74 * v.at(1)),
          stroke: (paint: gray, thickness: 2.2pt), mark: (end: "stealth", fill: gray, scale: 0.55))
      }
    }
    line((c.at(0) - 0.95, c.at(1)), c, stroke: (paint: black, thickness: 2.2pt))
    line(c, (c.at(0) + 0.95, c.at(1)), stroke: (paint: black, thickness: 1.1pt, dash: "dashed"))
    circle(c, radius: 0.19, fill: rgb("#7f7f7f"), stroke: (paint: black, thickness: 0.6pt))
  }
  cell((3.9, 3.28))
  cell((8.1, 3.28), on: true)
  content((3.9, 5.15), text(size: 8.5pt, weight: "bold")[Voltage Off], anchor: "center")
  content((8.1, 5.15), text(size: 8.5pt, weight: "bold")[Voltage #text(fill: red)[On]], anchor: "center")

  // 左栏标注：膜/刚性框/顶电极/底电极/膨胀圈
  content((1.5, 4.55), lab[Polymer film#linebreak()stretched on a#linebreak()rigid frame], anchor: "center")
  lead((2.50, 4.32), (3.13, 3.92))
  content((2.35, 3.28), lab[Top electrode], anchor: "east")
  lead((2.42, 3.28), (2.88, 3.28))
  content((1.35, 1.95), lab[Rigid#linebreak()frame], anchor: "center")
  lead((1.90, 2.20), (3.10, 2.62))
  content((5.45, 3.78), lab[Bottom#linebreak()electrode], anchor: "west")
  lead((5.50, 3.56), (4.78, 3.34))
  content((9.30, 2.72), lab[Expanding#linebreak()circle], anchor: "west")

  // 左栏剖面：介电膜夹于两电极，上表面红 +、下表面黑 −
  rect((2.55, 0.35), (9.35, 0.82), fill: pale, stroke: (paint: ink, thickness: 0.4pt))
  rect((2.75, 0.82), (9.15, 0.95), fill: blue, stroke: (paint: ink, thickness: 0.5pt))
  rect((2.75, 0.22), (9.15, 0.35), fill: blue, stroke: (paint: ink, thickness: 0.5pt))
  for i in range(13) {
    plus((3.10 + i * 0.47, 1.10))
    minus((3.10 + i * 0.47, 0.08))
  }

  // ── 右栏：三层层合板（电极 / 介电膜 / 电极）──
  // 助手：正面三层叠置 + 右侧面 + 顶面，dx/dy 为透视偏移
  let slab(x, y0, w, H, dx, dy) = {
    let e = 0.13
    let rows = ((y0, e, blue), (y0 + e, H - 2 * e, pale), (y0 + H - e, e, blue))
    for (yb, h, c) in rows {
      rect((x, yb), (x + w, yb + h), fill: c, stroke: (paint: ink, thickness: 0.45pt))
      line((x + w, yb), (x + w + dx, yb + dy), (x + w + dx, yb + h + dy), (x + w, yb + h),
        close: true, fill: c.darken(14%), stroke: (paint: ink, thickness: 0.45pt))
    }
    line((x, y0 + H), (x + w, y0 + H), (x + w + dx, y0 + H + dy), (x + dx, y0 + H + dy),
      close: true, fill: blue, stroke: (paint: ink, thickness: 0.45pt))
  }
  slab(12.7, 1.85, 2.2, 1.05, 0.58, 0.58)
  slab(16.7, 1.85, 2.9, 0.95, 0.58, 0.58)
  content((13.8, 4.62), text(size: 8.5pt, weight: "bold")[Voltage off], anchor: "center")
  content((18.15, 4.62), text(size: 8.5pt, weight: "bold")[Voltage on], anchor: "center")

  // 右栏标注：柔顺电极 / 介电膜 / 麦克斯韦应力
  content((12.05, 3.10), lab[Compliant#linebreak()Electrode], anchor: "east")
  lead((12.12, 3.00), (12.72, 2.97))
  circle((12.78, 2.96), radius: 0.045, fill: black, stroke: none)
  content((11.95, 2.35), lab[Polymer film], anchor: "east")
  lead((12.02, 2.35), (12.66, 2.35))
  circle((12.72, 2.35), radius: 0.045, fill: black, stroke: none)
  content((16.35, 3.92), text(size: 6.5pt, weight: "bold")[Maxwell Stress], anchor: "west")

  // 通电板顶面两排正电荷（先画点，再压箭头以外的线）
  for i in range(7) {
    plus((17.02 + i * 0.40, 2.95))
    plus((17.30 + i * 0.40, 3.18))
  }

  // 应力上提箭头、面内左右扩张箭头、向下压缩箭头
  garr((18.15, 3.30), (18.95, 4.24), w: 3.6pt)
  garr((16.60, 2.42), (15.55, 2.42))
  garr((20.22, 2.42), (21.12, 2.42))
  line((16.95, 1.72), (19.60, 1.72), stroke: (paint: black, thickness: 1.2pt, dash: "dashed"))
  garr((18.55, 1.62), (17.70, 1.14))

  // V 形外接回路：顶电极引出、绕右侧、回到底电极
  line((20.18, 3.38), (20.18, 3.72), (21.20, 3.72), (21.20, 1.92), (20.18, 1.92),
    stroke: (paint: black, thickness: 0.9pt))
  content((20.66, 3.90), lab[$V$], anchor: "center")

  // ── 右栏剖面：断电原厚 / 通电变薄变宽 ──
  content((11.00, 0.60), text(size: 7pt, weight: "bold")[Cross section], anchor: "west")
  rect((12.7, 0.25), (14.9, 0.38), fill: blue, stroke: (paint: ink, thickness: 0.4pt))
  rect((12.7, 0.38), (14.9, 0.83), fill: pale, stroke: (paint: ink, thickness: 0.4pt))
  rect((12.7, 0.83), (14.9, 0.96), fill: blue, stroke: (paint: ink, thickness: 0.4pt))
  rect((16.5, 0.28), (19.8, 0.39), fill: blue, stroke: (paint: ink, thickness: 0.4pt))
  rect((16.5, 0.39), (19.8, 0.78), fill: pale, stroke: (paint: ink, thickness: 0.4pt))
  rect((16.5, 0.78), (19.8, 0.89), fill: blue, stroke: (paint: ink, thickness: 0.4pt))
  for i in range(7) {
    plus((17.05 + i * 0.42, 1.03))
    minus((17.05 + i * 0.42, 0.15))
  }
  // z 向厚度双箭头
  content((16.02, 0.58), lab[$z$], anchor: "east")
  line((16.22, 0.28), (16.22, 0.89), stroke: (paint: black, thickness: 0.7pt),
    mark: (start: "stealth", end: "stealth", fill: black, scale: 0.8))
})
