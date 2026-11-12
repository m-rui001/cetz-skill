#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 编译效果：2×2 四联 cable-driven continuum robot 受力分析图。(a) 平行 cable 直梁；
// (b) S 形弯梁；(c) 收敛斜 cable + 灰虚线参考；(d) 双段梁带中间盘。
// 每幅含斜纹固支墙、粗黑 backbone、细黑 cable、端盘圆点、红色力箭头与力矩卷曲、红色下标标签。
// 来源：Unlocking the Potential of Cable-Driven Continuum Robots: A Comprehensive Review and
// Future Directions. Actuators 2024, 13(2), 52. DOI 10.3390/act13020052, Figure 12.
#let RED = rgb("#D40000")
#let INK = black
#let GRAY = rgb("#909090")
#let FS = 10.5pt

#canvas({
  import draw: *

  // 通用文字标签（黑/红、 bold、可带下标撇号）
  let tag(p, body, anchor: "center", color: INK, size: FS) = {
    content(p, text(fill: color, size: size, weight: "bold", body), anchor: anchor)
  }

  // 固支墙：竖线 + 循环斜纹
  let wall(x, h) = {
    line((x, -h), (x, h), stroke: (paint: INK, thickness: 1.1pt))
    let n = calc.floor(2 * h / 0.36)
    for i in range(0, n + 1) {
      let y = -h + i * 0.36
      line((x, y), (x - 0.3, y - 0.3), stroke: (paint: INK, thickness: 0.9pt))
    }
  }

  // 端盘：竖线 + 上下两端实心点
  let disk(x, ytop, ybot) = {
    line((x, ybot), (x, ytop), stroke: (paint: INK, thickness: 1.1pt))
    circle((x, ytop), radius: (0.05, 0.11), fill: INK, stroke: none)
    circle((x, ybot), radius: (0.05, 0.11), fill: INK, stroke: none)
  }

  // cable：细黑线
  let cable(a, b) = line(a, b, stroke: (paint: INK, thickness: 0.8pt))

  // 力：红箭头（实心三角头）+ 红标签
  let force(a, b, label, lp, anchor: "center") = {
    line(a, b, stroke: (paint: RED, thickness: 1.3pt), mark: (end: ">", fill: RED, scale: 0.8))
    if label != none { tag(lp, label, anchor: anchor, color: RED) }
  }

  // 力矩：红开口弧 + 切向箭头 + 中心点 + 红标签；dir=+1 逆时针 / -1 顺时针，gap 为开口方位
  let moment(at, r, dir, label, lp, anchor: "center", gap: 270deg) = {
    let w = 45deg
    let a0 = if dir > 0 { gap + w } else { gap - w }
    let a1 = if dir > 0 { gap - w + 360deg } else { gap + w - 360deg }
    let p(a) = (at.at(0) + r * calc.cos(a), at.at(1) + r * calc.sin(a))
    arc(p(a0), radius: r, start: a0, stop: a1,
      stroke: (paint: RED, thickness: 1.3pt), mark: (end: ">", fill: RED, scale: 0.8))
    circle(at, radius: 0.05, fill: RED, stroke: none)
    tag(lp, label, anchor: anchor, color: RED)
  }

  // backbone：粗黑直梁或 S 弯（bezier）+ 两端三角 flare
  let backbone-path(a, b, c1: none, c2: none) = {
    if c1 == none {
      line(a, b, stroke: (paint: INK, thickness: 3.6pt))
    } else {
      bezier(a, b, c1, c2, stroke: (paint: INK, thickness: 3.6pt))
    }
    line((a.at(0), a.at(1) + 0.16), (a.at(0), a.at(1) - 0.16), (a.at(0) + 0.34, a.at(1)),
      close: true, fill: INK, stroke: none)
    line((b.at(0), b.at(1) + 0.16), (b.at(0), b.at(1) - 0.16), (b.at(0) - 0.34, b.at(1)),
      close: true, fill: INK, stroke: none)
  }

  // ==========================================================================
  // (a) 平行 cable：水平直梁，上下水平 cable
  // ==========================================================================
  scope({
    translate((0, 0))
    let L = 4.4; let hw = 1.9; let hd = 1.1
    wall(0, hw)
    disk(L, hd, -hd)
    cable((0, hd), (L, hd)); cable((0, -hd), (L, -hd))
    backbone-path((0, 0), (L, 0))
    force((0, 0), (0, 0.85), [F#sub[1]], (0.26, 0.6), anchor: "west")
    force((0, 0), (0.85, 0), [F#sub[3]], (0.62, -0.26), anchor: "north")
    force((L, hd), (L - 0.85, hd), [F#sub[2]], (L - 0.6, hd + 0.26), anchor: "south")
    force((3.3, 0), (3.3, -0.8), [G], (3.5, -0.6), anchor: "west")
    moment((1.7, 0), 0.26, -1, [M#sub[1]], (2.02, -0.4), anchor: "north-west")
    moment((2.2, 0.6), 0.26, 1, [M#sub[2]], (2.52, 0.55), anchor: "west")
    tag((1.52, 0.34), [A]); tag((2.02, 0.94), [B])
    tag((L / 2, -2.55), [(a)], size: 11pt)
  })

  // ==========================================================================
  // (b) S 形弯梁：上下斜 cable，右端外侧无标签向下长箭头
  // ==========================================================================
  scope({
    translate((6.4, 0))
    let L = 3.8; let hw = 1.8
    wall(0, hw)
    disk(L, 0.0, -2.0)
    cable((0, 0.95), (L, 0.0)); cable((0, -1.0), (L, -2.0))
    backbone-path((0, 0), (L, -1.05), c1: (1.4, 0.1), c2: (2.4, -1.2))
    force((L + 0.25, -0.45), (L + 0.25, -1.7), none, (0, 0))
    moment((1.5, -0.65), 0.26, -1, [M#sub[1]], (1.1, -0.65), anchor: "east")
    moment((2.3, -0.33), 0.26, 1, [M#sub[2]], (2.62, -0.4), anchor: "west", gap: 45deg)
    tag((L / 2, -2.55), [(b)], size: 11pt)
  })

  // ==========================================================================
  // (c) 收敛斜 cable：灰虚线参考，右端力分解 F2/F21/F22，双重力 G1/G2
  // ==========================================================================
  scope({
    translate((0, -5.4))
    let L = 4.4; let hw = 1.9; let hd = 1.15
    wall(0, hw)
    disk(L, hd, -hd)
    cable((0, 1.7), (L, 0.72)); cable((0, -1.65), (L, -0.8))
    backbone-path((0, 0), (L, 0))
    line((0, 0.65), (3.4, 0.65), stroke: (paint: GRAY, thickness: 0.7pt, dash: "dashed"))
    line((3.3, 0.65), (3.3, 0), stroke: (paint: GRAY, thickness: 0.7pt, dash: "dashed"))
    line((3.5, 0.8), (L, 0.8), stroke: (paint: GRAY, thickness: 0.7pt, dash: "dotted"))
    force((0, 0), (0, 0.75), [F#sub[1]], (0.26, 0.55), anchor: "west")
    force((0, 0), (0.85, 0), [F#sub[3]], (0.62, -0.26), anchor: "north")
    force((L, 0.72), (L, 1.15), [F#sub[21]], (L + 0.26, 1.05), anchor: "west")
    force((L, 0.72), (L - 0.85, 0.82), [F#sub[2]], (L - 0.6, 1.05), anchor: "south")
    force((L - 0.1, 0.62), (L - 0.75, 0.62), [F#sub[22]], (L - 0.95, 0.62), anchor: "east")
    force((3.3, 0), (3.3, -0.45), [G#sub[1]], (3.5, -0.3), anchor: "west")
    force((3.3, -0.45), (3.3, -0.9), [G#sub[2]], (3.5, -0.75), anchor: "west")
    moment((1.7, 0), 0.26, -1, [M#sub[1]#super[′]], (2.02, -0.4), anchor: "north-west")
    moment((2.2, 0.4), 0.26, 1, [M#sub[2]#super[′]], (1.95, 0.75), anchor: "south-east")
    moment((3.8, 0.35), 0.26, 1, [M#sub[3]#super[′]], (4.32, 0.15), anchor: "east")
    tag((L / 2, -2.55), [(c)], size: 11pt)
  })

  // ==========================================================================
  // (d) 双段梁：中间盘 + 右端盘，两段斜 cable，中盘 F11/F12，右端 F2/F21/F22
  // ==========================================================================
  scope({
    translate((6.4, -5.4))
    let L = 4.4; let hw = 1.9; let hd = 1.15; let mid = 2.2; let mh = 0.55
    wall(0, hw)
    disk(mid, mh, -mh)
    disk(L, hd, -hd)
    cable((0, 1.05), (mid, mh)); cable((mid, mh), (L, hd))
    cable((0, -1.1), (mid, -mh)); cable((mid, -mh), (L, -hd))
    backbone-path((0, 0), (L, 0))
    force((mid, 0), (mid, mh), [F#sub[11]], (mid - 0.26, 0.35), anchor: "east")
    force((mid, mh), (mid, 0.95), [F#sub[12]], (mid - 0.26, 0.9), anchor: "east")
    force((mid, 0), (mid + 0.8, 0), [F#sub[3]], (mid + 0.4, -0.26), anchor: "north")
    force((L, hd), (L - 0.8, 1.0), [F#sub[22]], (L - 0.6, 1.35), anchor: "south")
    force((L, 0.95), (L - 0.65, 0.95), [F#sub[2]], (L - 0.5, 0.6), anchor: "south")
    force((L, hd), (L, 0.65), [F#sub[21]], (L + 0.26, 0.85), anchor: "west")
    force((3.75, 0), (3.75, -0.65), [G], (3.95, -0.5), anchor: "west")
    moment((3.0, 0), 0.26, -1, [M#sub[1]#super[′′]], (3.2, -0.4), anchor: "north-west")
    moment((3.3, 0.55), 0.26, 1, [M#sub[2]#super[′′]], (3.0, 0.85), anchor: "south-east")
    moment((3.85, 0.25), 0.26, 1, [M#sub[3]#super[′′]], (4.32, 0.12), anchor: "east")
    tag((L / 2, -2.55), [(d)], size: 11pt)
  })
})
