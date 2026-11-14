#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 来源：Sensors 2024, 24, 7095, Figure 5. DOI 10.3390/s24217095.
// 编译后为左右两面板：(a) 左半为 CAD 穿戴助行架干净线稿（半透明顶盒、紫灰腰带环
// 米色腰盘、米色双腿右腿前迈、每腿两块青色 PVC 贴片带上下黄条、右腿红色箭头、
// 紫色膝带、米色脚与鞋底，左列标签细引线末端红点）；(b) 右半为正视＋侧视两个简化
// 线稿穿戴视图（衣摆、蓝腰带、黑 strap、大腿＋小腿灰贴片、深色膝带、运动鞋）。
#canvas({
  import draw: *

  // 调色板 -------------------------------------------------------------
  let beige = rgb("#cfc4b0")
  let sole-c = rgb("#a99f8c")
  let purp = rgb("#6b6880")
  let cyan = rgb("#2fd8dc")
  let yellow = rgb("#f4d818")
  let gray-p = rgb("#b9c6ce")
  let blue = rgb("#2f9fd0")

  // 命名地标（派生坐标） ------------------------------------------------
  let waist-c = (4.3, 6.5)
  let belt-c = (4.3, 6.2)
  let box-c = (5.3, 7.25)
  let lknee = (3.6, 2.85)
  let rknee = (5.2, 2.95)
  let lsole = (3.0, 0.6)
  let views = (9.3, 12.6)

  // 贴片：青色矩形＋上下黄条＋中心点
  let patch(cx, cy, w, h) = {
    rect((cx - w / 2, cy - h / 2), (cx + w / 2, cy + h / 2),
      fill: cyan, stroke: rgb("#18a8ac") + 0.6pt)
    rect((cx - w / 2 - 0.05, cy + h / 2), (cx + w / 2 + 0.05, cy + h / 2 + 0.09),
      fill: yellow, stroke: none)
    rect((cx - w / 2 - 0.05, cy - h / 2 - 0.09), (cx + w / 2 + 0.05, cy - h / 2),
      fill: yellow, stroke: none)
    circle((cx, cy), radius: 0.035, fill: black, stroke: none)
  }
  // 环带：矩形＋顶椭圆，模拟环绕
  let band(cx, cy, w, h, col) = {
    rect((cx - w / 2, cy - h / 2), (cx + w / 2, cy + h / 2),
      fill: col, stroke: rgb("#4a4760") + 0.6pt)
    circle((cx, cy + h / 2), radius: (w / 2, 0.12),
      fill: col, stroke: rgb("#4a4760") + 0.6pt)
  }
  // 引线：左列标签＋细线＋末端红点
  let leader(label, ly, tgt) = {
    content((0.05, ly), label, anchor: "west")
    line((2.1, ly), tgt, stroke: rgb("#c66") + 0.5pt)
    circle(tgt, radius: 0.05, fill: red, stroke: none)
  }
  // 运动鞋：白色鞋身＋圆头＋鞋底
  let shoe(sx) = {
    rect((sx - 0.18, 0.4), (sx + 0.18, 1.0), fill: white, stroke: rgb("#555") + 0.6pt)
    circle((sx, 0.4), radius: (0.18, 0.12), fill: white, stroke: rgb("#555") + 0.6pt)
    line((sx - 0.18, 0.28), (sx + 0.18, 0.28), stroke: rgb("#333") + 0.8pt)
  }
  // 穿戴视图：衣摆、蓝腰带、裤腿、黑 strap、灰贴片、膝带、鞋
  let worn-view(cx, hem, pant) = {
    line((cx - 0.8, 7.6), (cx + 0.8, 7.6), (cx + 0.7, 7.0), (cx - 0.7, 7.0),
      close: true, fill: hem, stroke: rgb("#333") + 0.6pt)
    rect((cx - 0.7, 6.6), (cx + 0.7, 7.0), fill: blue, stroke: rgb("#1b6f96") + 0.6pt)
    line((cx - 0.7, 6.6), (cx + 0.7, 6.6), (cx + 0.55, 3.8), (cx + 0.45, 1.0),
      (cx + 0.1, 1.0), (cx + 0.03, 3.6), (cx - 0.03, 3.6), (cx - 0.1, 1.0),
      (cx - 0.45, 1.0), (cx - 0.55, 3.8),
      close: true, fill: pant, stroke: rgb("#666") + 0.6pt)
    rect((cx - 0.34, 5.4), (cx - 0.22, 6.6), fill: black, stroke: none)
    rect((cx - 0.55, 4.6), (cx, 5.4), fill: gray-p, stroke: rgb("#7d8a93") + 0.6pt)
    rect((cx - 0.53, 4.25), (cx, 4.55), fill: rgb("#333"), stroke: none)
    rect((cx - 0.5, 3.3), (cx, 4.1), fill: gray-p, stroke: rgb("#7d8a93") + 0.6pt)
    shoe(cx - 0.28)
    shoe(cx + 0.28)
  }

  // (a) 半透明顶盒（电源与控制器） --------------------------------------
  rect((4.6, 6.8), (6.0, 7.7), fill: rgb("#eeeeee80"), stroke: rgb("#999") + 0.5pt)
  line((4.6, 7.7), (4.9, 7.9), (6.3, 7.9), (6.0, 7.7),
    close: true, fill: rgb("#f5f5f580"), stroke: rgb("#999") + 0.5pt)
  // (a) 紫灰腰带＋米色腰盘＋前 notch
  band(belt-c.at(0), belt-c.at(1), 3.0, 0.6, purp)
  circle(waist-c, radius: (1.35, 0.28), fill: beige, stroke: rgb("#8a8272") + 0.6pt)
  line((4.0, 6.2), (4.6, 6.2), (4.3, 5.9), close: true, fill: beige, stroke: none)
  // (a) 两条米色腿（右腿略前迈）
  line((3.2, 5.9), (4.0, 5.9), (3.95, 3.2), (3.9, 1.2), (3.3, 1.2), (3.3, 3.2),
    close: true, fill: beige, stroke: rgb("#8a8272") + 0.6pt)
  line((4.5, 5.9), (5.3, 5.9), (5.5, 3.2), (5.65, 1.6), (5.1, 1.6), (4.9, 3.2),
    close: true, fill: beige, stroke: rgb("#8a8272") + 0.6pt)
  // (a) 每腿两块 PVC 贴片（大腿＋膝上），表驱动
  for (cx, cy) in ((3.6, 4.8), (3.6, 3.7), (5.0, 4.7), (5.15, 3.6)) {
    patch(cx, cy, 0.7, 0.8)
  }
  // (a) 右腿贴片旁红色箭头：上向下、下向上
  line((4.55, 5.1), (4.55, 4.4), mark: (end: "stealth"), stroke: red + 1pt)
  line((4.7, 3.2), (4.7, 3.9), mark: (end: "stealth"), stroke: red + 1pt)
  // (a) 紫色膝带
  band(lknee.at(0), lknee.at(1), 0.85, 0.4, purp)
  band(rknee.at(0), rknee.at(1), 0.85, 0.4, purp)
  // (a) 米色脚与鞋底
  line((3.3, 1.2), (3.9, 1.2), (3.9, 0.7), (2.6, 0.7), (2.6, 0.9), (3.3, 1.0),
    close: true, fill: beige, stroke: rgb("#8a8272") + 0.6pt)
  rect((2.6, 0.5), (3.9, 0.7), fill: sole-c, stroke: rgb("#8a8272") + 0.6pt)
  line((5.1, 1.6), (5.65, 1.6), (5.7, 1.1), (6.3, 1.0), (6.3, 0.8), (5.1, 0.8),
    close: true, fill: beige, stroke: rgb("#8a8272") + 0.6pt)
  rect((5.1, 0.6), (6.3, 0.8), fill: sole-c, stroke: rgb("#8a8272") + 0.6pt)
  // (a) 左列标签引线（末端红点），逐字标签
  leader([Power and \ controller], 7.4, box-c)
  leader([Waist belt], 6.2, (3.0, 6.2))
  leader([PVC gel \ actuator], 4.8, (3.6, 4.8))
  leader([Knee belt], 2.85, lknee)
  leader([Insole force \ sensors], 0.8, lsole)
  content((4.3, -0.2), [(a)])

  // (b) 两个简化线稿穿戴视图（正视＋侧视），循环驱动
  for (cx, hem, pant) in (
    (views.at(0), rgb("#222"), rgb("#bfe3f5")),
    (views.at(1), blue, rgb("#d8d8d8")),
  ) {
    worn-view(cx, hem, pant)
  }
  content((10.95, -0.2), [(b)])
})
