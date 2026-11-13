#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：电动飞机 PMSM 驱动与容错控制框图。上排转速外环 n_r,ref→J1→PI→i_qc,ref→J2→PI 得 u_q；
// 第二排 i_dc,ref→J3→PI 得 u_d，二者经 dq/αβ 得 u_β,u_α 入 SVPWM 六边形→Inverter→三条相线→PMSM。
// 下半部：电压/电流检测模块、Clark 变换、αβ/abc 变换、故障诊断单元 FDU、K_i 单刀双掷开关（1 测dq/2 LSTM）、
// LSTM 与 30/π 转速换算，i_d/i_q 反馈引至 J3/J2，n 反馈引至 J1，θ 反馈回 dq/αβ。
// 来源：Aerospace 2025, 12, 697, Figure 1 "Block diagram of the electric aircraft motor control system". DOI 10.3390/aerospace12080697

#canvas({
  import draw: *
  let ink = black
  let blue = rgb("#a9c6e8")
  let green = rgb("#a9dfb5")
  let orange = rgb("#f2a97c")
  let red = rgb("#d0342c")
  // 盒：中心、半宽、半高、文字、字号、填充
  let box(c, w, h, s, size: 6.4pt, fill: white) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      radius: 0.03, fill: fill, stroke: 0.7pt + ink)
    content(c, text(size: size)[#s], anchor: "center", frame: none)
  }
  let t(pos, s, size: 6.6pt, anchor: "center", fill: ink) = content(
    pos, text(size: size, fill: fill)[#s], anchor: anchor, frame: none)
  let arr(a, b) = line(a, b, stroke: 0.7pt + ink, mark: (end: "stealth", scale: 0.55))
  let line2(a, b) = line(a, b, stroke: 0.7pt + ink)
  let poly(..pts) = line(..pts, stroke: 0.7pt + ink)
  let polyarr(..pts) = line(..pts, stroke: 0.7pt + ink, mark: (end: "stealth", scale: 0.55))
  let junc(p) = circle(p, radius: 0.035, fill: ink, stroke: none)
  // 求和点
  let sum(p) = circle(p, radius: 0.075, fill: white, stroke: 0.7pt + ink)
  // 变换方块：方框＋左下到右上对角线，左上/右下两行文字
  let tri(c, w, h, tl, br) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      fill: white, stroke: 0.7pt + ink)
    line((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h), stroke: 0.7pt + ink)
    t((c.at(0) - w + 0.06, c.at(1) + h - 0.04), tl, size: 6.6pt, anchor: "north-west")
    t((c.at(0) + w - 0.06, c.at(1) - h + 0.04), br, size: 6.4pt, anchor: "south-east")
  }

  // ── 转速外环与 q 轴电流内环（上排）
  sum((1.35, 9.55))
  t((0.28, 9.55), [$n_(r,"ref")$], size: 6.8pt, anchor: "west")
  arr((0.72, 9.55), (1.26, 9.55))
  t((1.08, 9.72), [+], size: 8pt)
  t((1.08, 9.38), [−], size: 8pt)
  arr((1.43, 9.55), (2.43, 9.55))
  box((2.75, 9.55), 0.31, 0.15, [PI], size: 7pt, fill: blue)
  t((3.62, 9.73), [$i_("qc,ref")$], size: 6.6pt)
  arr((3.07, 9.55), (4.26, 9.55))
  sum((4.35, 9.55))
  t((4.13, 9.72), [+], size: 8pt)
  t((4.13, 9.38), [−], size: 8pt)
  arr((4.43, 9.55), (5.03, 9.55))
  box((5.35, 9.55), 0.31, 0.15, [PI], size: 7pt, fill: blue)
  t((6.28, 9.73), [$u_q$], size: 6.8pt)
  arr((5.67, 9.55), (6.94, 9.55))

  // ── d 轴电流环（第二排）
  t((0.80, 8.52), [$i_("dc,ref")$], size: 6.6pt, anchor: "west")
  arr((0.82, 8.35), (2.46, 8.35))
  sum((2.55, 8.35))
  t((2.32, 8.51), [+], size: 8pt)
  t((2.34, 8.18), [−], size: 8pt)
  arr((2.63, 8.35), (3.38, 8.35))
  box((3.70, 8.35), 0.31, 0.15, [PI], size: 7pt, fill: blue)
  t((4.98, 8.52), [$u_d$], size: 6.8pt)
  polyarr((4.02, 8.35), (6.62, 8.35), (6.62, 9.02), (6.94, 9.02))

  // ── dq/αβ 变换与 SVPWM、Inverter、PMSM
  tri((7.30, 9.375), 0.33, 0.575, [dq], [αβ])
  arr((7.64, 9.60), (9.50, 9.60))
  arr((7.64, 9.10), (9.50, 9.10))
  t((8.55, 9.77), [$u_beta$], size: 6.8pt)
  t((8.55, 8.94), [$u_alpha$], size: 6.8pt)
  line((10.35, 10.25), (11.17, 9.78), (11.17, 8.83), (10.35, 8.35),
    (9.53, 8.83), (9.53, 9.78), (10.35, 10.25),
    fill: orange, stroke: 0.8pt + ink)
  t((10.35, 9.30), [SVPWM], size: 7.2pt)
  arr((10.35, 8.35), (10.35, 7.87))
  box((10.35, 7.55), 0.525, 0.30, [Inverter], size: 7pt)
  // 三条相线（进入 PMSM 前绘制，末端被实心圆覆盖处留箭头）
  arr((9.90, 7.23), (9.90, 3.99))
  arr((10.35, 7.23), (10.35, 4.18))
  arr((10.80, 7.23), (10.80, 3.99))
  circle((10.35, 3.55), radius: 0.62, fill: red, stroke: 0.8pt + red)
  t((10.35, 3.55), [PMSM], size: 7pt, fill: white)

  // ── 电压/电流检测、Clark、αβ/abc、故障诊断与 K_i 开关
  box((8.57, 7.10), 0.62, 0.62, [Voltage \ Sensing \ Module], size: 5.6pt)
  box((8.57, 4.70), 0.62, 0.62, [Current \ Sensing \ Module], size: 5.6pt)
  // 检测抽头母线（三相线上打点后汇入模块）
  line2((10.80, 7.10), (9.04, 7.10))
  junc((10.35, 7.10))
  junc((9.90, 7.10))
  arr((9.04, 7.10), (9.02, 7.10))
  line2((10.80, 4.70), (9.04, 4.70))
  junc((10.35, 4.70))
  junc((9.90, 4.70))
  arr((9.04, 4.70), (9.02, 4.70))
  box((5.55, 7.10), 0.60, 0.33, [Clark \ Transform], size: 5.4pt)
  box((5.55, 4.70), 0.62, 0.36, [Failure \ Diagnosis \ Unit], size: 5.4pt, fill: green)
  tri((7.05, 4.70), 0.35, 0.30, [αβ], [abc])
  // 电压模块 → Clark（u_a/u_b/u_c）
  arr((8.05, 7.28), (6.18, 7.28))
  arr((8.05, 7.10), (6.18, 7.10))
  arr((8.05, 6.92), (6.18, 6.92))
  rect((6.36, 7.30), (6.68, 7.46), fill: white, stroke: none)
  t((6.52, 7.37), [$u_a$], size: 5.4pt)
  rect((6.36, 7.12), (6.68, 7.28), fill: white, stroke: none)
  t((6.52, 7.19), [$u_b$], size: 5.4pt)
  rect((6.36, 6.94), (6.68, 7.10), fill: white, stroke: none)
  t((6.52, 7.01), [$u_c$], size: 5.4pt)
  // Clark → FDU（u_β/u_α）
  arr((5.35, 6.79), (5.35, 5.05))
  arr((5.75, 6.79), (5.75, 5.05))
  t((5.24, 6.50), [$u_beta$], size: 6.2pt, anchor: "east")
  t((5.88, 6.50), [$u_alpha$], size: 6.2pt, anchor: "west")
  // 电流模块 → αβ/abc（i_a/i_b），αβ/abc → FDU（i_α/i_β）
  arr((8.07, 4.86), (7.42, 4.86))
  arr((8.07, 4.56), (7.42, 4.56))
  rect((7.36, 4.88), (7.68, 5.10), fill: white, stroke: none)
  t((7.52, 4.98), [$i_a$], size: 6.2pt)
  rect((7.36, 4.26), (7.68, 4.48), fill: white, stroke: none)
  t((7.52, 4.38), [$i_b$], size: 6.2pt)
  arr((6.68, 4.86), (6.19, 4.86))
  arr((6.68, 4.56), (6.19, 4.56))
  t((6.38, 4.98), [$i_alpha$], size: 6.2pt)
  t((6.38, 4.38), [$i_beta$], size: 6.2pt)

  // ── 电流反馈：dq/αβ 测量块 → 两条竖直母线 → J3/J2
  tri((2.70, 5.35), 0.35, 0.30, [dq], [αβ])
  line2((2.35, 5.55), (1.55, 5.55))
  junc((1.55, 5.55))
  line2((2.35, 5.15), (2.05, 5.15))
  junc((2.05, 5.15))
  t((1.80, 5.68), [$i_d$], size: 6.4pt)
  t((1.80, 5.28), [$i_q$], size: 6.4pt)
  // i_d 母线：上至 J3，下至 LSTM 输入
  poly((1.55, 5.55), (1.55, 8.05), (2.55, 8.05), (2.55, 8.27))
  poly((1.55, 5.55), (1.55, 2.72), (2.42, 2.72))
  // i_q 母线：上至 J2，下至 LSTM 输入
  poly((2.05, 5.15), (2.05, 9.15), (4.35, 9.15), (4.35, 9.47))
  poly((2.05, 5.15), (2.05, 2.95), (2.42, 2.95))
  t((2.20, 2.62), [$i_d$], size: 6.2pt)
  t((2.20, 3.06), [$i_q$], size: 6.2pt)

  // ── LSTM 与 K_i 单刀双掷开关
  box((2.80, 2.85), 0.375, 0.22, [LSTM], size: 6.8pt, fill: green)
  line2((3.18, 2.85), (4.38, 2.85))
  line2((4.38, 2.85), (4.38, 4.33))
  // 开关公共端 ← FDU 的 K_i；触点 1 接 dq/αβ 输入线，触点 2 接 LSTM 输出
  line2((4.93, 4.70), (4.665, 4.70))
  circle((4.62, 4.70), radius: 0.045, fill: white, stroke: 0.7pt + ink)
  line2((4.62, 4.70), (4.40, 5.01))
  circle((4.38, 5.05), radius: 0.035, fill: white, stroke: 0.7pt + ink)
  circle((4.38, 4.35), radius: 0.035, fill: white, stroke: 0.7pt + ink)
  line2((2.35, 5.35), (4.38, 5.35))
  line2((4.38, 5.35), (4.38, 5.08))
  rect((4.80, 4.68), (5.10, 4.90), fill: white, stroke: none)
  t((4.95, 4.79), [$K_i$], size: 6.6pt)
  t((4.28, 5.13), [1], size: 6.4pt, anchor: "east")
  t((4.28, 4.27), [2], size: 6.4pt, anchor: "east")

  // ── 转速与角度反馈
  polyarr((9.73, 3.72), (7.70, 3.72), (7.70, 8.15), (7.30, 8.15), (7.30, 8.77))
  rect((7.82, 4.08), (8.16, 4.36), fill: white, stroke: none)
  t((7.86, 4.22), [$theta$], size: 6.8pt, anchor: "west")
  polyarr((10.35, 2.93), (10.35, 1.35), (8.02, 1.35))
  t((9.92, 1.50), [$omega$], size: 6.8pt)
  box((7.70, 1.35), 0.31, 0.21, [$30/pi$], size: 7pt)
  polyarr((7.39, 1.35), (1.35, 1.35), (1.35, 9.47))
  t((5.42, 1.50), [$n$], size: 6.8pt)
})
