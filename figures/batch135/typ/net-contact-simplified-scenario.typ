#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 编译外观：左侧蓝色细绳网格(红色节点)凹面张开包住细长绿色目标盒，中部黑色右向箭头，右侧同形散点云与同款目标盒；来源 Mechanics of Space Debris Removal: A Review, Aerospace 2025, 12, 277, Fig.45. DOI 10.3390/aerospace12040277.
#canvas({
  import draw: *

  // 共享样式与向量助手
  let netstroke = (paint: rgb("#1e35c8"), thickness: 0.6pt)
  let nodefill = rgb("#e01b12")
  let add(p, q) = (p.at(0) + q.at(0), p.at(1) + q.at(1))
  let half(v) = (v.at(0) / 2, v.at(1) / 2)
  let node(p, r: 0.055) = circle(p, radius: r, fill: nodefill, stroke: none)

  // 绳网参数方程：u 横向 0→1，v 纵向 0→1（左端外鼓、右端收拢）
  let netpt(u, v) = {
    let t = 2 * v - 1
    let bulge = 1.15 - 0.6 * u
    let x = 1.35 + 2.05 * u - bulge * (1 - t * t)
    let halfh = 2.55 - 0.95 * u
    let mid = 3.1 - 0.25 * u - 0.3 * (1 - 4 * (u - 0.5) * (u - 0.5))
    (x, mid + halfh * t)
  }

  // 左图：横向绳线（加密采样成光滑曲线）
  let NU = 8
  let NV = 8
  for i in range(NV + 1) {
    for k in range(NU * 4) {
      line(netpt(k / (NU * 4), i / NV), netpt((k + 1) / (NU * 4), i / NV), stroke: netstroke)
    }
  }
  // 左图：纵向绳线
  for j in range(NU + 1) {
    for k in range(NV * 4) {
      line(netpt(j / NU, k / (NV * 4)), netpt(j / NU, (k + 1) / (NV * 4)), stroke: netstroke)
    }
  }
  // 左图：网格节点
  for i in range(NV + 1) {
    for j in range(NU + 1) {
      node(netpt(j / NU, i / NV))
    }
  }
  // 左图：松散绳头（牵引线）
  for (u, v, q) in (
    (0, 1, (1.48, 6.25)),
    (1, 1, (3.95, 4.92)),
    (1, 0, (3.90, 0.62)),
    (0.75, 0.5, (3.35, 4.38)),
  ) {
    line(netpt(u, v), q, stroke: netstroke)
    node(q)
  }

  // 细长绿色目标盒：以三个轴向量定形状（OB 为前下左角）
  let OB = (2.25, 2.95)
  let LB = (1.35, -0.10)   // 长轴：向右略下
  let HB = (0.00, 0.62)    // 高度轴
  let KB = (-0.30, 0.22)   // 深度轴：向左后上
  let es = (paint: rgb("#0b7d0b"), thickness: 1pt)
  let mkbox(dx) = {
    let sh(p) = (p.at(0) + dx, p.at(1))
    let A = sh(OB)                                   // 前下左
    let B = sh(add(OB, LB))                          // 前下右
    let C = sh(add(add(OB, LB), HB))                 // 前上右
    let D = sh(add(OB, HB))                          // 前上左
    let E = sh(add(add(OB, HB), KB))                 // 后上左
    let F = sh(add(add(add(OB, LB), HB), KB))        // 后上右
    let H = sh(add(OB, KB))                          // 后下左
    // 左端面（最暗）、顶面（最亮）、正面（中等）
    line(A, D, E, H, close: true, fill: rgb("#12a80f"), stroke: es)
    line(D, C, F, E, close: true, fill: rgb("#3ce62c"), stroke: es)
    line(A, B, C, D, close: true, fill: rgb("#22d81e"), stroke: es)
  }
  let boxcenter(dx) = {
    let c = add(add(OB, add(half(LB), half(HB))), half(KB))
    (c.at(0) + dx, c.at(1))
  }
  mkbox(0)

  // 中部：黑色右向箭头
  line((5.20, 3.05), (6.72, 3.05),
    stroke: (paint: black, thickness: 4pt),
    mark: (end: "stealth", fill: black, scale: 2.6))

  // 右图：抖动的散点云（表驱动抖动 + 抽样）
  let jit = ((0.11, 0.07), (-0.09, 0.12), (0.05, -0.13), (-0.14, -0.05),
    (0.13, -0.02), (-0.04, -0.10), (0.08, 0.14), (-0.12, 0.06),
    (0.02, 0.09), (-0.07, -0.14), (0.15, 0.02), (-0.10, 0.11),
    (0.06, -0.06), (-0.02, -0.04), (0.09, 0.10), (-0.13, -0.12))
  for i in range(11) {
    for j in range(11) {
      if calc.rem(i * 5 + j * 11, 7) != 0 {
        let p = netpt(j / 10, i / 10)
        let o = jit.at(calc.rem(i * 7 + j * 5, 16))
        node((p.at(0) + 8.1 + o.at(0), p.at(1) + o.at(1)), r: 0.065)
      }
    }
  }
  // 右图：同款目标盒与盒面残留节点
  mkbox(7.9)
  node(boxcenter(7.9), r: 0.065)
})
