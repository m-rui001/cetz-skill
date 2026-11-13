#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 复刻 Aerospace 2025,12,277 Fig.42：V-bar 沿轨接近几何示意
// 干净线稿：轨道弧 + 追踪器/目标/地球 + H/V/R-Bar 轴 + r_i, r_P, r_i^e 距离矢量 + 碎片云
#canvas({
  import draw: *
  let cy = rgb("#12bdd2")
  let bl = rgb("#1a1ae0")
  let rd = rgb("#e01a1a")
  let gn = rgb("#6cc46c")
  let thin = (paint: black, thickness: 0.35pt)
  let th = 0.55pt

  // ---- 关键地标 ----
  let O = (21.0, 1.7)      // 地球中心
  let P = (6.9, 8.3)       // 追踪器参考点 P
  let S = (6.0, 7.2)       // 追踪器本体
  let T = (15.9, 10.2)     // 目标卫星本体
  let Ep = (20.26, 2.05)   // 地球表面 r_P 落点
  let Es = (20.36, 2.21)   // 地球表面 r_i^e 起点
  let Ce = (13.4, 9.2)     // 碎片云近端（r_i 终点）

  // ---- 绕 o 旋转 p ----
  let rotp(ang, o, p) = {
    let dx = p.at(0) - o.at(0)
    let dy = p.at(1) - o.at(1)
    (o.at(0) + dx * calc.cos(ang) - dy * calc.sin(ang),
     o.at(1) + dx * calc.sin(ang) + dy * calc.cos(ang))
  }

  // ---- Catmull-Rom 平滑折线 ----
  let catmull(ks, sub: 6) = {
    let n = ks.len()
    let out = ()
    for i in range(n - 1) {
      let p0 = ks.at(calc.max(i - 1, 0))
      let p1 = ks.at(i)
      let p2 = ks.at(i + 1)
      let p3 = ks.at(calc.min(i + 2, n - 1))
      for j in range(sub) {
        let t = j / sub
        let c(k) = 0.5 * (2 * p1.at(k) + (p2.at(k) - p0.at(k)) * t
          + (2 * p0.at(k) - 5 * p1.at(k) + 4 * p2.at(k) - p3.at(k)) * t * t
          + (3 * p1.at(k) - p0.at(k) - 3 * p2.at(k) + p3.at(k)) * t * t * t)
        out.push((c(0), c(1)))
      }
    }
    out.push(ks.at(n - 1))
    out
  }

  // ---- 轨道弧线：左下经追踪器抬升至右上 Orbit ----
  line(..catmull(((0.4, 0.5), (1.3, 3.6), (3.2, 6.1), (6.2, 7.25), (9.6, 8.1),
    (13.5, 8.9), (17.8, 9.6), (22.0, 10.3), (26.2, 10.75))),
    stroke: (paint: black, thickness: th))

  // ---- 地球本体与光泽 ----
  circle(O, radius: 0.82, fill: gn, stroke: (paint: rgb("#3f8a3f"), thickness: 0.5pt))
  circle((O.at(0) - 0.20, O.at(1) + 0.22), radius: 0.50, fill: rgb(255, 255, 255, 45%), stroke: none)

  // ---- 地球本地坐标轴 X / Y / Z ----
  line(O, (21.0, 4.0), mark: (end: "stealth"), stroke: (paint: black, thickness: th))
  line(O, (23.3, 1.7), mark: (end: "stealth"), stroke: (paint: black, thickness: th))
  line(O, (19.45, 0.62), mark: (end: "stealth"), stroke: (paint: black, thickness: th))

  // ---- 卫星：矩形本体 + 两侧栅格太阳能板 ----
  let sat(c, ang: 0deg) = {
    let q(p) = rotp(ang, c, (c.at(0) + p.at(0), c.at(1) + p.at(1)))
    line(q((-0.55, -0.23)), q((0.55, -0.23)), q((0.55, 0.23)), q((-0.55, 0.23)),
      close: true, fill: white, stroke: (paint: black, thickness: 0.55pt))
    line(q((-0.55, -0.01)), q((0.55, -0.01)), stroke: thin)
    for (x0, y0, x1, y1) in ((-1.85, -0.30, -0.62, 0.06), (0.62, -0.41, 1.85, -0.05)) {
      line(q((x0, y0)), q((x1, y0)), q((x1, y1)), q((x0, y1)), close: true, fill: white, stroke: thin)
      for i in (1, 2, 3, 4) {
        let x = x0 + (x1 - x0) * i / 5
        line(q((x, y0)), q((x, y1)), stroke: thin)
      }
      line(q((x0, (y0 + y1) / 2)), q((x1, (y0 + y1) / 2)), stroke: thin)
    }
  }
  sat(S, ang: 14deg)   // 追踪器
  sat(T, ang: 16deg)   // 目标

  // ---- 碎片云：锥形收束的伪随机散点（近端窄、远端宽） ----
  let rnd(i, k) = calc.fract(calc.sin(1rad * (i * 12.9898 + k * 78.233)) * 43758.5453)
  for i in range(60) {
    let t = rnd(i, 1)
    let u = rnd(i, 2)
    let v = rnd(i, 3)
    let cx = 14.15 - 1.75 * t
    let cyy = 7.0 + 5.6 * t
    let w = 0.30 + 0.95 * t
    circle((cx + (u - 0.5) * w, cyy + (v - 0.5) * w * 1.3),
      radius: 0.055, fill: rd, stroke: none)
  }

  // ---- 碎片云：短折线勾勒相对轨迹 ----
  let scribbles = (
    ((14.25, 7.3), (14.55, 7.9), (13.95, 8.4), (14.25, 9.0)),
    ((13.6, 7.9), (14.0, 8.6), (13.4, 9.2), (13.8, 9.8)),
    ((13.0, 8.8), (13.5, 9.5), (12.9, 10.1), (13.4, 10.7)),
    ((12.7, 10.2), (13.2, 10.8), (12.6, 11.4), (13.0, 12.0)),
    ((13.9, 9.9), (13.4, 10.6), (13.9, 11.3), (13.2, 11.9)),
    ((12.4, 11.4), (12.9, 12.0), (12.4, 12.6), (12.9, 13.0)),
  )
  for s in scribbles {
    line(s.at(0), s.at(1), s.at(2), s.at(3), stroke: (paint: rd, thickness: 0.5pt))
  }

  // ---- 青色矢量：r_i、r_P、r_i^e ----
  line(P, Ce, stroke: (paint: cy, thickness: th), mark: (end: "stealth"))
  line(P, Ep, stroke: (paint: cy, thickness: th))
  line(Es, (14.0, 7.2), stroke: (paint: cy, thickness: th), mark: (end: "stealth"))

  // ---- P 点指向目标区的黑色矢量与蓝色相对运动曲线 ----
  line(P, (10.7, 9.0), stroke: (paint: black, thickness: th), mark: (end: "stealth"))
  bezier(P, (8.3, 9.6), (10.4, 9.9), (11.7, 9.4), stroke: (paint: bl, thickness: 0.45pt))

  // ---- P 点处 H / V / R-Bar 坐标轴 ----
  line(P, (7.05, 10.2), stroke: (paint: black, thickness: th), mark: (end: "stealth"))
  line(P, (8.35, 9.4), stroke: (paint: bl, thickness: th), mark: (end: "stealth"))
  line(P, (8.8, 7.45), stroke: (paint: black, thickness: th), mark: (end: "stealth"))

  // ---- 文字标注 ----
  content((2.25, 6.85), [Chaser Satellite])
  content((17.0, 9.05), [Target])
  content((23.2, 11.35), [Orbit])
  content((6.55, 8.62), [P])
  content((5.85, 10.28), text(fill: bl)[H-Bar])
  content((8.02, 10.12), text(fill: bl)[V-Bar])
  content((9.0, 7.0), text(fill: bl)[R-Bar])
  content((10.3, 8.6), $r_i$)
  content((12.7, 4.9), $r_P$)
  content((15.9, 6.3), $r_i^e$)
  content((21.1, 4.28), text(fill: rd)[Z])
  content((23.68, 1.6), text(fill: rd)[Y])
  content((19.05, 0.38), text(fill: rd)[X])
  content((21.32, 1.3), [O])
  content((21.65, 0.35), [Earth])
})
