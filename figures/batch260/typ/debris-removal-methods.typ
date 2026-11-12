#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：太空碎片清除方法分类树。根节点 Debris Removal Methods（桃色圆角框、棕边）下分三支：
// Contact Removal Methods（下接 Drag Augmentation Methods / Electrodynamic Tether / Connection Methods）、
// Self-Eating Satellite、Contactless Removal Methods（下接 Gravity Tractor / Electrostatic Tractor /
// Lased Based / Ion Beam Shepherd）。Drag Augmentation 再分 Sail/foam/fibre based，Connection 分
// Stiff/Flexible Connection。绿→蓝→紫三级配色，逐字保留全部标签。
// 来源：Aerospace 2025, 12, 277, Figure 11 "Methods of capturing space debris" DOI 10.3390/aerospace12040277

#canvas({
  import draw: *
  let green = rgb("#2f6b33")
  let blue = rgb("#2c5f8b")
  let purple = rgb("#7b2f6e")
  let gfill = rgb("#d9ecd2")
  let bfill = rgb("#dbe9f6")
  let pfill = rgb("#eed3ea")
  let rfill = rgb("#f6d7c4")
  let brown = rgb("#8b5a3c")
  // 圆角节点：中心、宽高、文字、填充、边框色、字号
  let nb(cx, cy, w, h, s, fill, col, size: 8.6pt) = {
    rect((cx - w / 2, cy - h / 2), (cx + w / 2, cy + h / 2), radius: 0.12,
      fill: fill, stroke: 1.1pt + col)
    content((cx, cy), text(size: size, s))
  }

  // 连线先画，节点后画盖住接头
  // 根到三个一级分支
  line((8.40, 8.28), (8.40, 7.95), (4.40, 7.95), (4.40, 7.66), stroke: 1.4pt + green)
  line((4.40, 7.95), (12.75, 7.95), (12.75, 7.66), stroke: 1.4pt + green)
  line((8.40, 7.95), (8.40, 7.66), stroke: 1.4pt + green)
  // Contact Removal 到三个二级分支
  line((4.40, 7.04), (4.40, 6.78), (2.75, 6.78), (2.75, 6.43), stroke: 1.4pt + blue)
  line((2.75, 6.78), (9.65, 6.78), (9.65, 6.43), stroke: 1.4pt + blue)
  line((6.25, 6.78), (6.25, 6.43), stroke: 1.4pt + blue)
  // Drag Augmentation 的竖向主脊与三个末级
  line((1.45, 5.77), (1.45, 3.15), stroke: 1.1pt + purple)
  for y in (4.95, 4.05, 3.15) {
    line((1.45, y), (1.80, y), stroke: 1.1pt + purple)
  }
  // Connection Methods：左支进 Stiff 右缘，主干进 Flexible 顶缘
  line((9.30, 5.77), (9.30, 5.28), (7.75, 5.28), (7.75, 4.85), (7.70, 4.85),
    stroke: 1.1pt + purple)
  line((9.30, 5.28), (9.30, 5.07), stroke: 1.1pt + purple)
  // Contactless：右侧竖向主脊与四条横向支线
  line((13.90, 7.04), (13.90, 6.70), (15.10, 6.70), (15.10, 2.85),
    stroke: 1.1pt + purple)
  for y in (5.25, 4.45, 3.65, 2.85) {
    line((15.10, y), (14.80, y), stroke: 1.1pt + purple)
  }

  // 根节点与一级分支（绿）
  nb(8.40, 8.55, 4.50, 0.58, [*Debris Removal Methods*], rfill, brown, size: 8.8pt)
  nb(4.40, 7.35, 3.60, 0.62, [Contact Removal\ Methods], gfill, green, size: 8.0pt)
  nb(8.40, 7.35, 2.50, 0.62, [Self-Eating\ Satellite], gfill, green, size: 8.0pt)
  nb(12.75, 7.35, 3.95, 0.62, [Contactless Removal\ Methods], gfill, green, size: 8.0pt)

  // 二级分支（蓝）
  nb(2.75, 6.10, 3.30, 0.66, [Drag Augmentation\ Methods], bfill, blue, size: 8.0pt)
  nb(6.25, 6.10, 3.00, 0.66, [Electrodynamic\ Tether], bfill, blue, size: 8.0pt)
  nb(9.65, 6.10, 3.00, 0.66, [Connection\ Methods], bfill, blue, size: 8.0pt)

  // 末级：拖曳增阻、连接方式、无接触四法（紫）
  nb(2.65, 4.95, 1.70, 0.44, [Sail based], pfill, purple, size: 7.8pt)
  nb(2.65, 4.05, 1.70, 0.44, [Foam based], pfill, purple, size: 7.8pt)
  nb(2.65, 3.15, 1.70, 0.44, [Fibre based], pfill, purple, size: 7.8pt)
  nb(6.55, 4.85, 2.30, 0.44, [Stiff Connection], pfill, purple, size: 7.6pt)
  nb(9.60, 4.85, 2.60, 0.44, [Flexible Connection], pfill, purple, size: 7.6pt)
  nb(13.20, 5.25, 3.20, 0.44, [Gravity Tractor], pfill, purple, size: 7.6pt)
  nb(13.20, 4.45, 3.20, 0.44, [Electrostatic Tractor], pfill, purple, size: 7.2pt)
  nb(13.20, 3.65, 3.20, 0.44, [Lased Based], pfill, purple, size: 7.6pt)
  nb(13.20, 2.85, 3.20, 0.44, [Ion Beam Shepherd], pfill, purple, size: 7.6pt)
})
