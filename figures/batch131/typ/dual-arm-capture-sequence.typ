#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 双臂空间机器人"接近—消旋—捕获"三阶段序列线稿（仿 Aerospace 2025, 12, 277, Fig. 27；DOI 10.3390/aerospace12040277；CAD 渲染转干净线稿平涂）
// 坐标以点尺度整数书写，length 把单位缩到 0.03cm
#canvas(length: 0.03cm, {
  import draw: *

  // ---------- 复用助手 ----------
  // 平顶八边形顶点：c 中心，r 外接圆半径
  let octagon(c, r) = {
    let pts = ()
    for i in range(8) {
      let a = 22.5deg + i * 45deg
      pts.push((c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a)))
    }
    pts
  }

  // 八边形碎块（填充浅灰）
  let debris(c, r) = line(..octagon(c, r), close: true, fill: rgb("ebebeb"), stroke: 1pt)

  // 机械臂：p0 机体角 → p1 肩 → p2 肘 → p3 腕，末端两指沿 dir 张开
  let limb(p0, p1, p2, p3, dir) = {
    line(p0, p1, p2, p3, stroke: 1pt)
    for p in (p1, p2, p3) {
      circle(p, radius: 1.7, fill: white, stroke: 0.9pt)
    }
    for d in (-22deg, 22deg) {
      let a = dir + d
      line(p3, (p3.at(0) + 11 * calc.cos(a), p3.at(1) + 11 * calc.sin(a)), stroke: 1pt)
    }
  }

  // 旋转指示箭头：圆弧折线 + 末端箭头
  let rot-arrow(c, r, a0, a1) = {
    let pts = ()
    let n = 14
    for i in range(n + 1) {
      let a = a0 + (a1 - a0) * i / n
      pts.push((c.at(0) + r * calc.cos(a), c.at(1) + r * calc.sin(a)))
    }
    line(..pts, stroke: 0.9pt, mark: (end: "stealth", fill: black, scale: 0.7))
  }

  // 阶段间粗箭头
  let block-arrow(x, y, w, h) = {
    let sw = w * 0.55
    let t = h * 0.22
    line(
      (x, y - t), (x + sw, y - t), (x + sw, y - h / 2), (x + w, y),
      (x + sw, y + h / 2), (x + sw, y + t), (x, y + t),
      close: true, fill: rgb("eeeeee"), stroke: 1pt,
    )
  }

  // ---------- 阶段一：接近 ----------
  rect((68, 60), (112, 106), fill: rgb("ededed"), stroke: 1pt)
  limb((68, 106), (54, 98), (40, 114), (44, 130), 125deg)
  limb((112, 106), (126, 98), (140, 114), (136, 130), 55deg)
  debris((100, 174), 25)
  rot-arrow((100, 174), 38, 130deg, 50deg)
  // 追踪器上升箭头
  line((48, 74), (48, 96), stroke: 1pt, mark: (end: "stealth", fill: black, scale: 0.8))
  content((132, 196), [Target debris], anchor: "west")
  content((90, 42), [Chaser robot])

  // ---------- 阶段二：消旋 ----------
  rect((238, 60), (282, 106), fill: rgb("ededed"), stroke: 1pt)
  limb((238, 106), (224, 98), (210, 114), (214, 130), 125deg)
  limb((282, 106), (296, 98), (310, 116), (298, 132), 152deg)
  debris((268, 164), 25)
  rot-arrow((268, 164), 36, 150deg, 78deg)
  // 接触点红色火花（消旋力矩）
  for k in range(8) {
    let a = k * 45deg + 10deg
    line(
      (290 + 3.5 * calc.cos(a), 146 + 3.5 * calc.sin(a)),
      (290 + 9 * calc.cos(a), 146 + 9 * calc.sin(a)),
      stroke: 1.2pt + rgb("dd2222"),
    )
  }
  // 机体下方转动箭头
  rot-arrow((262, 82), 46, -12deg, -78deg)

  // ---------- 阶段三：捕获 ----------
  rect((408, 60), (452, 106), fill: rgb("ededed"), stroke: 1pt)
  limb((408, 106), (394, 98), (392, 124), (403, 140), 65deg)
  limb((452, 106), (466, 98), (468, 124), (457, 140), 115deg)
  debris((430, 160), 25)
  rot-arrow((430, 84), 46, -12deg, -78deg)

  // ---------- 阶段标签与流程箭头 ----------
  let caps = (
    (30, "Approaching phase"),
    (200, "Detumbling phase"),
    (370, "Capturing phase"),
  )
  for (x, s) in caps {
    rect((x, 6), (x + 120, 30), fill: white, stroke: 1pt)
    content((x + 60, 18), s)
  }
  block-arrow(155, 18, 40, 22)
  block-arrow(325, 18, 40, 22)
})
