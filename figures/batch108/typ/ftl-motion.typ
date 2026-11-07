// 编译效果：(a) 五条红色粗蛇形中心线叠排，红菱形关节编号 1-4 逐行沿同一路径前移，
//   行左端青色插入箭头（首行无），过首行关节 4 的黑色竖直点线导引，右上斜体 Follow the leader，
//   右侧 Shape following 与左下 Insertion 各带红色指引箭头；(b) 三幅线稿快照：顶部法兰+圆柱安装座、
//   下悬多段连续体（左弯右直、逐幅变长），段界垫片小斜矩形、四条平行骨架线、段号 1..4 与尖端细腱线。
// 来源：Unlocking the Potential of Cable-Driven Continuum Robots: A Comprehensive Review and
//   Future Directions. Actuators 2024, 13(2), 52, Figure 18. DOI 10.3390/act13020052.
#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 语义常量：主路径关节点（水平段+下弯 S 段）、行距、插入箭尾长、安装座底高
#let M = (
  (0, 0), (0.7, 0), (1.4, 0), (2.1, 0),
  (2.75, -0.35), (3.05, -0.95), (3.35, -1.5), (4.0, -1.85),
)
#let X4 = M.at(3).at(0)
#let ROWDY = 1.15
#let TAIL = 0.6
#let MBOT = -0.95
#let RED = rgb("#ff0000")
#let CYAN = rgb("#00b0f0")

// 小工具：向量加/数乘、多行文字、段方向（向下）与右法向
#let vadd(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
#let vmul(a, s) = (a.at(0) * s, a.at(1) * s)
#let ml(..ls) = ls.pos().map(text).join(linebreak())
#let dirn(a) = (calc.sin(a), -calc.cos(a))
#let norm(a) = (calc.cos(a), calc.sin(a))

// 共享 helper：蛇形行 = 粗红 hobby 线 + 红菱形关节 + 左上方粗体编号
#let snake-row(start, joints) = {
  draw.hobby(start, ..joints, stroke: 3pt + RED)
  for (j, p) in joints.enumerate() {
    let d = 0.1
    draw.line((p.at(0) - d, p.at(1)), (p.at(0), p.at(1) + d),
      (p.at(0) + d, p.at(1)), (p.at(0), p.at(1) - d),
      close: true, stroke: none, fill: RED)
    draw.content(vadd(p, (-0.25, 0.3)), text(weight: "bold", str(j + 1)))
  }
}
// 共享 helper：青色插入箭头 / 红色指引箭头
#let insertion(p) = draw.line(vadd(p, (-TAIL, 0)), p, stroke: 2pt + CYAN, mark: (end: "stealth"))
#let leader(a, b) = draw.line(a, b, stroke: 1.3pt + RED, mark: (end: "stealth"))
// 共享 helper：安装座 = 顶法兰宽矩形 + 下方圆柱矩形
#let mount(cx) = {
  draw.rect((cx - 0.65, 0.12), (cx + 0.65, 0.3), stroke: 0.9pt + luma(70), fill: luma(245))
  draw.rect((cx - 0.4, MBOT), (cx + 0.4, 0.12), stroke: 0.9pt + luma(70), fill: luma(245))
}
// 共享 helper：段界垫片 = 按段角计算四角的小矩形
#let disk(p, a) = {
  let d = vmul(dirn(a), 0.055)
  let n = vmul(norm(a), 0.2)
  draw.line(vadd(vadd(p, n), d), vadd(vadd(p, n), vmul(d, -1)),
    vadd(vadd(p, vmul(n, -1)), vmul(d, -1)), vadd(vadd(p, vmul(n, -1)), d),
    close: true, stroke: 0.7pt + luma(60), fill: luma(235))
}
// 共享 helper：快照 = 骨架线束 + 垫片 + 段号 + 尖端拖曳腱线
#let snapshot(cx, angles, len) = {
  let pts = ((cx, MBOT),)
  let ns = ()
  for a in angles {
    pts.push(vadd(pts.last(), vmul(dirn(a), len)))
    ns.push(norm(a))
  }
  let bn = (ns.at(0),)
  for i in range(1, ns.len()) {
    let s = vadd(ns.at(i - 1), ns.at(i))
    bn.push(vmul(s, 1 / calc.sqrt(s.at(0) * s.at(0) + s.at(1) * s.at(1))))
  }
  bn.push(ns.last())
  for off in (-0.14, -0.05, 0.05, 0.14) {
    draw.hobby(..pts.enumerate().map(((i, p)) => vadd(p, vmul(bn.at(i), off))),
      stroke: 0.6pt + luma(90))
  }
  for i in range(1, pts.len()) { disk(pts.at(i), angles.at(i - 1)) }
  for i in range(angles.len()) {
    let mid = vmul(vadd(pts.at(i), pts.at(i + 1)), 0.5)
    draw.content(vadd(mid, vmul(ns.at(i), 0.5)), text(weight: "bold", str(angles.len() - i)))
  }
  let tip = pts.last()
  let td = dirn(angles.last())
  let tn = norm(angles.last())
  for off in (-0.1, 0.1) {
    draw.line(vadd(tip, vmul(tn, off)), vadd(vadd(tip, vmul(td, 0.9)), vmul(tn, off * 2)),
      stroke: 0.5pt + luma(120))
  }
}

#canvas(length: 1cm, {
  import draw: *
  // (a) 行表：主路径 M 上的关节索引窗，逐行下移 ROWDY 形成 follow-the-leader 叠排
  let rows = ((0, 1, 2, 3), (1, 2, 3, 4), (2, 3, 4, 5), (3, 4, 5, 6), (4, 5, 6, 7))
  for (r, win) in rows.enumerate() {
    let dy = (0, -r * ROWDY)
    let joints = win.map(i => vadd(M.at(i), dy))
    let start = if r == 0 { vadd(joints.at(0), (-TAIL, 0)) } else { vadd(M.at(r - 1), dy) }
    snake-row(start, joints)
    if r > 0 { insertion(start) }
  }
  // (a) 过首行关节 4 的黑色竖直点线导引
  line((X4, 0.4), (X4, -4 * ROWDY - 1.7), stroke: (paint: black, thickness: 0.9pt, dash: "dotted"))
  // (a) 文字标签与红色指引箭头：斜体标题、双行 Shape following、Insertion
  content((X4 + 0.55, 0), emph[Follow the leader], anchor: "west")
  content((4.15, -1.6), ml("Shape", "following"))
  leader((3.85, -2.05), (3.18, -3.12))
  content((-1.15, -3.5), [Insertion], anchor: "west")
  leader((-0.85, -3.3), (-0.45, -1.32))
  content((1.5, -7.0), strong[(a)])
  // (b) 快照表：(中心 x, 各段弯角, 段长)，左→右段数递增且渐直
  let snaps = (
    (6.6, (20deg, 50deg), 1.15),
    (9.6, (8deg, 18deg, 35deg), 1.2),
    (12.6, (2deg, 6deg, 12deg, 25deg), 1.2),
  )
  for s in snaps {
    mount(s.at(0))
    snapshot(..s)
  }
  content((9.6, -7.0), strong[(b)])
})