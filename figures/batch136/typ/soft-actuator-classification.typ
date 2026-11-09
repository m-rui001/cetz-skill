#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 软体执行器分类树（干净线稿平涂）：深灰根框 + 五个彩色大类框 + 白字子类框 + 黑色正交连线
// 来源：Actuators 2024, 13, 524, Figure 1. DOI 10.3390/act13120524.
#canvas({
  import draw: *

  // 多行白字逐行定位（左对齐），行距由字号换算为 cm
  let mtext(x, ymid, s, sz) = {
    let ls = s.split("\n")
    let n = ls.len()
    let lh = sz.pt() * 0.05
    for (i, l) in ls.enumerate() {
      content(
        (x, ymid + ((n - 1) / 2 - i) * lh),
        anchor: "west",
        text(size: sz, fill: white, l),
      )
    }
  }

  // 色块 + 白字标签
  let node(cx, top, w, h, col, s, sz: 6.5pt) = {
    rect((cx - w / 2, top), (cx + w / 2, top - h), fill: col, stroke: none)
    mtext(cx - w / 2 + 0.12, top - h / 2, s, sz)
  }

  // 地标：五列中心、子类行顶边、框高
  let xs = (-6.0, -3.0, 0, 3.0, 6.0)
  let rowTop = (-3.1, -4.3, -5.5)
  let H = 1.0
  let railY = -1.1
  let catTop = -1.4

  // 表驱动：类别颜色、标签、子类标签（逐字取自原图）
  let cats = (
    (
      col: rgb("#3d8b3d"),
      name: "2.1. Electrically\nResponsive\nActuators",
      subs: (
        "2.1.1. Dielectric\nElastomer\nActuators",
        "2.1.2. Piezoelectric-\nBased Soft\nActuators",
        "2.1.3. HASEL\nActuators",
      ),
    ),
    (
      col: rgb("#7d2f8e"),
      name: "2.2. Magnetically\nResponsive\nActuators",
      subs: (),
    ),
    (
      col: rgb("#e42a25"),
      name: "2.3. Thermally\nResponsive\nActuators",
      subs: (
        "2.3.1. Shape\nMemory Alloys",
        "2.3.2. Shape\nMemory Polymers",
        "2.3.3. Liquid\nCrystal Elastomers",
      ),
    ),
    (
      col: rgb("#4a90d9"),
      name: "2.4.\nPhotoresponsive\nActuators",
      subs: (
        "2.4.1. Visible Light-\nDriven Actuators",
        "2.4.2. Near-Infrared\nLight Driven\nActuators",
      ),
    ),
    (
      col: rgb("#c55a11"),
      name: "2.5. Pressure-\nDriven Actuators",
      subs: (
        "2.5.1. Pneumatic\nActuators",
        "2.5.2. Hydraulic\nActuators",
      ),
    ),
  )

  // 根框到五大类的横向脊线与竖向支线
  line((0, -0.8), (0, railY))
  line((xs.first(), railY), (xs.last(), railY))
  for x in xs {
    line((x, railY), (x, catTop))
  }

  // 各类到其子类的竖向主干（沿子框左边缘下行，直达末个子框中心）
  for (i, c) in cats.enumerate() {
    if c.subs.len() > 0 {
      let x = xs.at(i)
      let yEnd = rowTop.at(c.subs.len() - 1) - H / 2
      line((x - 1.05, -2.4), (x - 1.05, yEnd))
    }
  }

  // 顶部根框
  node(0, 0, 2.3, 0.8, rgb("#3f3f3f"), "Soft Robotic\nActuators", sz: 8.5pt)

  // 五大类框与子类框
  for (i, c) in cats.enumerate() {
    let x = xs.at(i)
    node(x, catTop, 2.8, H, c.col, c.name, sz: 7pt)
    for (j, s) in c.subs.enumerate() {
      node(x + 0.2, rowTop.at(j), 2.5, H, c.col, s)
    }
  }
})
