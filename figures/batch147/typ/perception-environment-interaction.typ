#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 四足机器人感知-环境交互流程线稿：机器人→RGB-D/LiDAR→前背景分割融合场景→定位导航/物体分类/障碍识别
// 来源：Quadruped Robots review, Robotics 2025, 14, 57, Figure 8. DOI 10.3390/robotics14050057.
#canvas({
  import draw: *
  // 四足机器人多传感融合与感知流程示意图（重绘自 Robotics 2025, 14, 57, Fig.8）
  // 原图为照片/渲染拼贴，此处转为干净线稿平涂示意；坐标系 y 向上

  let ink = rgb("#1d1d1d")
  let mk = (paint: ink, thickness: 0.9pt)
  let thin = (paint: ink, thickness: 0.55pt)
  let arr = (paint: ink, thickness: 1.1pt)
  let pale = rgb("#cfe0f4")

  // 弯曲箭头助手（三次贝塞尔＋实心箭头）
  let arrow(a, c1, c2, b) = bezier(a, c1, c2, b, stroke: arr, mark: (end: "stealth", fill: ink, scale: 1.1))

  // ===== 左侧：四足机器人 =====
  // 机身与头颈
  line((1.9, 6.1), (4.1, 6.3), (4.4, 5.7), (2.1, 5.3), close: true,
       fill: rgb("#f2c53d").transparentize(25%), stroke: mk)
  line((4.1, 6.3), (4.6, 6.7), (5.1, 6.5), (5.1, 6.0), (4.4, 5.7), close: true,
       fill: rgb("#f2c53d").transparentize(25%), stroke: mk)
  // 耳与尾
  line((4.6, 6.7), (4.75, 7.0), (4.9, 6.65), stroke: mk)
  line((1.9, 6.1), (1.55, 6.5), stroke: mk)
  // 四条折线腿
  for (x0, x1, x2) in ((2.35, 2.1, 2.45), (2.7, 2.45, 2.8), (3.9, 3.8, 4.1), (4.25, 4.15, 4.45)) {
    line((x0, 5.45), (x1, 4.9), (x2, 4.2), stroke: mk)
  }
  content((3.2, 6.9), [*Quadruped Robot*])

  // ===== 中上：RGB-D 灰度深度图 =====
  rect((8.9, 9.1), (12.9, 12.1), fill: rgb("#cfcfcf"), stroke: none)
  rect((8.9, 10.6), (11.0, 12.1), fill: rgb("#6e6e6e"), stroke: none)
  rect((10.6, 10.1), (12.6, 11.9), fill: rgb("#a8a8a8"), stroke: none)
  rect((9.2, 9.2), (10.4, 10.6), fill: rgb("#8d8d8d"), stroke: none)
  circle((11.9, 11.1), radius: 0.7, fill: rgb("#bdbdbd"), stroke: none)
  content((10.9, 12.45), [*RGB - D*])

  // ===== 中部：LiDAR 彩色点云 =====
  rect((8.9, 5.6), (12.9, 8.6), fill: rgb("#101b3a"), stroke: none)
  for (x0, y0, x1, y1, c) in (
    (9.00, 7.70, 10.00, 8.40, "#2e7d32"), (9.90, 7.90, 10.80, 8.50, "#4caf50"),
    (11.00, 7.60, 12.00, 8.40, "#f9a825"), (8.95, 7.00, 9.75, 7.70, "#66bb6a"),
    (9.70, 6.70, 10.80, 7.60, "#ef6c00"), (10.80, 6.70, 11.80, 7.50, "#9e9d24"),
    (11.90, 6.70, 12.75, 7.60, "#1e88e5"), (9.00, 6.05, 10.20, 6.90, "#2e7d32"),
    (10.30, 6.00, 11.30, 6.80, "#c62828"), (11.40, 6.00, 12.30, 6.70, "#43a047"),
    (12.30, 6.00, 12.80, 6.80, "#1565c0"), (9.35, 8.03, 9.75, 8.38, "#fdd835"),
  ) {
    rect((x0, y0), (x1, y1), fill: rgb(c), stroke: none)
  }
  content((10.9, 8.78), [*LiDAR*])
  // 省略号表示其余传感器
  content((10.9, 5.2), [*...*])

  // ===== 定位与导航：折页地图 + 红色图钉 =====
  content((10.9, 2.95), [*Localisation & Navigation*])
  line((8.7, 1.1), (10.9, 0.5), (12.9, 1.1), (12.9, 2.4), (10.9, 1.8), (8.7, 2.5), close: true,
       fill: rgb("#e9e1c9"), stroke: (paint: rgb("#b9ae8c"), thickness: 0.7pt))
  line((9.0, 1.5), (10.2, 1.15), (11.3, 1.7), (12.6, 1.5),
       stroke: (paint: rgb("#8ab6e8"), thickness: 1.4pt))
  line((10.0, 2.4), (10.4, 1.4), (10.6, 0.65),
       stroke: (paint: rgb("#8ab6e8"), thickness: 1.4pt))
  line((9.2, 0.9), (10.4, 1.4), (11.5, 1.1), (12.3, 1.6),
       stroke: (paint: rgb("#2e9e4f"), thickness: 1.2pt))
  // 图钉
  line((10.68, 1.9), (10.9, 1.22), (11.12, 1.9), fill: rgb("#d63b2f"), stroke: none)
  circle((10.9, 2.1), radius: 0.28, fill: rgb("#d63b2f"), stroke: none)
  circle((10.9, 2.1), radius: 0.11, fill: white, stroke: none)

  // ===== 右上：多传感数据融合街景缩略图 =====
  rect((17.0, 6.8), (27.0, 12.45), fill: rgb("#10203a"), stroke: none)
  content((22.0, 12.68), [*Front-Background Segmentation*])
  // 透视网格（向上收束）
  for i in range(1, 7) {
    line((17.4 + i * 1.35, 12.45), (16.4 + i * 1.75, 6.8),
         stroke: (paint: rgb("#2f6d9e"), thickness: 0.35pt))
  }
  for i in range(1, 4) {
    line((17.0, 11.2 - i * 1.15), (27.0, 11.2 - i * 1.15),
         stroke: (paint: rgb("#2f6d9e"), thickness: 0.35pt))
  }
  // 青色识别框
  for (x0, y0, x1, y1) in (
    (17.6, 10.7, 19.0, 11.6), (21.0, 10.9, 22.6, 11.9), (25.0, 10.6, 26.3, 11.5),
    (19.4, 7.5, 20.6, 8.3), (24.2, 10.2, 25.3, 11.0),
  ) {
    rect((x0, y0), (x1, y1), fill: rgb("#4fc3f7").transparentize(82%),
         stroke: (paint: rgb("#4fc3f7"), thickness: 0.6pt))
  }
  // 车辆（车身＋两轮）
  for (x, y, s) in ((20.0, 9.8, 1.0), (22.4, 9.1, 1.15), (25.0, 10.0, 0.95),
                    (19.0, 8.4, 1.2), (23.6, 8.0, 1.25)) {
    rect((x - 0.28 * s, y - 0.12 * s), (x + 0.28 * s, y + 0.14 * s),
         fill: rgb("#dfe9f4").transparentize(15%), stroke: none)
    circle((x - 0.17 * s, y - 0.15 * s), radius: 0.06 * s, fill: rgb("#0b1524"), stroke: none)
    circle((x + 0.17 * s, y - 0.15 * s), radius: 0.06 * s, fill: rgb("#0b1524"), stroke: none)
  }
  // 行人
  for (x, y, s) in (
    (18.4, 9.4, 1.0), (21.2, 8.6, 1.1), (24.8, 8.5, 1.0), (26.2, 7.7, 1.2),
    (17.9, 7.8, 1.1), (22.0, 7.5, 1.2), (25.6, 7.4, 1.0), (20.5, 10.4, 0.9), (23.2, 10.2, 0.95),
  ) {
    circle((x, y + 0.14 * s), radius: 0.05 * s, fill: pale, stroke: none)
    line((x, y + 0.08 * s), (x, y - 0.12 * s), stroke: (paint: pale, thickness: 0.8pt * s))
    line((x, y - 0.12 * s), (x - 0.05 * s, y - 0.26 * s), stroke: (paint: pale, thickness: 0.7pt * s))
    line((x, y - 0.12 * s), (x + 0.05 * s, y - 0.26 * s), stroke: (paint: pale, thickness: 0.7pt * s))
  }

  // ===== 图标绘制助手 =====
  let glyph(x, y, k) = {
    if k == "bomb" {
      circle((x, y - 0.06), radius: 0.15, fill: ink, stroke: none)
      line((x + 0.1, y + 0.1), (x + 0.2, y + 0.24), stroke: mk)
    } else if k == "balloon" {
      circle((x, y + 0.04), radius: 0.14, stroke: mk)
      line((x, y - 0.1), (x - 0.05, y - 0.26), stroke: mk)
    } else if k == "umbrella" {
      line((x - 0.22, y - 0.02), (x, y + 0.18), (x + 0.22, y - 0.02), stroke: mk)
      line((x - 0.22, y - 0.02), (x + 0.22, y - 0.02), stroke: mk)
      line((x, y + 0.18), (x, y - 0.22), stroke: mk)
      line((x, y - 0.22), (x - 0.1, y - 0.22), stroke: mk)
    } else if k == "ladder" {
      line((x - 0.14, y - 0.22), (x - 0.14, y + 0.22), stroke: mk)
      line((x + 0.14, y - 0.22), (x + 0.14, y + 0.22), stroke: mk)
      for i in (-0.11, 0, 0.11) {
        line((x - 0.14, y + i), (x + 0.14, y + i), stroke: thin)
      }
    } else if k == "dots" {
      for i in range(3) {
        for j in range(3) {
          circle((x - 0.16 + i * 0.16, y - 0.16 + j * 0.16), radius: 0.035, fill: ink, stroke: none)
        }
      }
    } else if k == "table" {
      rect((x - 0.2, y - 0.2), (x + 0.2, y + 0.2), stroke: mk)
      line((x - 0.2, y), (x + 0.2, y), stroke: thin)
      line((x, y), (x, y + 0.2), stroke: thin)
    } else if k == "chip" {
      rect((x - 0.15, y - 0.15), (x + 0.15, y + 0.15), stroke: mk)
      for i in (-0.08, 0.08) {
        line((x - 0.24, y + i), (x - 0.15, y + i), stroke: thin)
        line((x + 0.15, y + i), (x + 0.24, y + i), stroke: thin)
      }
    } else if k == "camera" {
      rect((x - 0.22, y - 0.12), (x + 0.22, y + 0.16), stroke: mk)
      circle((x, y + 0.02), radius: 0.09, stroke: mk)
    } else if k == "book" {
      rect((x - 0.2, y - 0.16), (x + 0.2, y + 0.16), stroke: mk)
      line((x - 0.02, y - 0.16), (x - 0.02, y + 0.16), stroke: thin)
    } else if k == "bars" {
      for (dx, h) in ((-0.15, 0.2), (0, 0.32), (0.15, 0.26)) {
        rect((x + dx - 0.05, y - 0.2), (x + dx + 0.05, y - 0.2 + h), fill: ink, stroke: none)
      }
    } else if k == "gear" {
      circle((x, y), radius: 0.14, stroke: mk)
      circle((x, y), radius: 0.05, stroke: mk)
      for a in range(6) {
        let t = a * 60deg
        line((x + 0.14 * calc.cos(t), y + 0.14 * calc.sin(t)),
             (x + 0.23 * calc.cos(t), y + 0.23 * calc.sin(t)), stroke: mk)
      }
    } else if k == "target" {
      circle((x, y), radius: 0.2, stroke: mk)
      circle((x, y), radius: 0.1, stroke: mk)
      circle((x, y), radius: 0.03, fill: ink, stroke: none)
    } else if k == "arrow" {
      line((x - 0.2, y - 0.15), (x + 0.18, y + 0.15), stroke: mk)
      line((x + 0.18, y + 0.15), (x + 0.04, y + 0.14), stroke: mk)
      line((x + 0.18, y + 0.15), (x + 0.17, y + 0.01), stroke: mk)
    } else if k == "wave" {
      line((x - 0.22, y + 0.05), (x - 0.1, y - 0.14), (x + 0.02, y + 0.14),
           (x + 0.14, y - 0.12), (x + 0.22, y + 0.04), stroke: mk)
    } else if k == "triangle" {
      line((x - 0.2, y - 0.18), (x, y + 0.2), (x + 0.2, y - 0.18), close: true, stroke: mk)
    }
  }

  // ===== 目标分类：两行图标卡片 =====
  content((18.2, 2.9), [*Object Classification*])
  let cls = (
    (15.85, 2.3, "bomb"), (17.0, 2.3, "balloon"), (18.15, 2.3, "umbrella"),
    (19.3, 2.3, "table"), (20.45, 2.3, "dots"),
    (15.85, 1.35, "book"), (17.0, 1.35, "chip"), (18.15, 1.35, "camera"),
    (19.3, 1.35, "ladder"), (20.45, 1.35, "table"),
  )
  for (x, y, k) in cls {
    rect((x - 0.5, y - 0.38), (x + 0.5, y + 0.38), fill: rgb("#f4f5f7"),
         stroke: (paint: rgb("#cfd3d9"), thickness: 0.5pt))
    glyph(x, y, k)
  }

  // ===== 障碍识别：四列图标卡片 =====
  content((25.3, 4.0), [*Obstacle Recognition*])
  let obs = (
    (23.5, 3.4, "bars"), (24.65, 3.4, "gear"), (25.8, 3.4, "table"), (26.95, 3.4, "chip"),
    (23.5, 2.5, "target"), (24.65, 2.5, "arrow"), (25.8, 2.5, "triangle"), (26.95, 2.5, "wave"),
    (23.5, 1.6, "dots"), (24.65, 1.6, "bomb"), (25.8, 1.6, "umbrella"), (26.95, 1.6, "camera"),
  )
  for (x, y, k) in obs {
    rect((x - 0.5, y - 0.38), (x + 0.5, y + 0.38), fill: rgb("#f4f5f7"),
         stroke: (paint: rgb("#cfd3d9"), thickness: 0.5pt))
    glyph(x, y, k)
  }

  // ===== 数据流箭头 =====
  // 机器人 → 传感器组
  arrow((5.6, 6.1), (6.8, 6.4), (7.8, 7.9), (8.7, 8.2))
  // 传感器组 → 多传感融合
  arrow((13.0, 8.8), (14.2, 8.7), (15.4, 10.8), (16.8, 10.7))
  // 传感器组 → 定位与导航
  arrow((13.0, 8.0), (13.6, 6.4), (13.0, 4.4), (12.5, 3.4))
  // 融合 → 目标分类
  arrow((19.3, 6.6), (18.8, 5.6), (18.4, 4.8), (18.2, 3.8))
  // 融合 → 障碍识别
  arrow((23.6, 6.6), (24.6, 5.8), (25.2, 5.5), (25.4, 4.7))
})
