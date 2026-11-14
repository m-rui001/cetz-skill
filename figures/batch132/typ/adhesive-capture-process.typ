#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 粘附捕获机构四步操作流程（干净线稿平涂重绘）
// (a) 接近并锁定 (b) 接触后释放 (c) 弹性臂展开旋转 (d) 柔性粘附带贴合目标
// 来源：Mechanics of Space Debris Removal: A Review, Aerospace 2025, 12, 277, Figure 31. DOI 10.3390/aerospace12040277.
#canvas({
  import draw: *
  let gray = rgb(160, 160, 160)
  let lgray = rgb(206, 206, 206)
  let mgray = rgb(110, 110, 110)
  let faint = rgb(238, 238, 238)
  let green = rgb(0, 195, 0)
  let mag = rgb(235, 0, 235)
  let brown = rgb(152, 66, 50)

  // 锯齿形弹簧：螺旋压缩/拉伸弹簧的线稿化
  let spr(cx, y0, y1, w, n) = {
    let pts = ()
    for i in range(2 * n + 1) {
      let y = y0 + (y1 - y0) * i / (2 * n)
      pts.push((cx + (if calc.rem(i, 2) == 0 { -w / 2 } else { w / 2 }), y))
    }
    line(..pts, stroke: brown + 0.55pt)
  }
  // 面板：外框、右上编号、灰色目标板
  let panel(px, py, tag) = {
    rect((px, py), (px + 8.4, py + 9.6), stroke: 0.6pt + luma(150))
    content((px + 8.02, py + 9.25), tag, anchor: "center")
    rect((px + 0.55, py + 8.15), (px + 7.85, py + 9.1), fill: lgray, stroke: 0.5pt + rgb(228, 236, 245))
    content((px + 4.2, py + 8.63), [Target], anchor: "center")
  }
  // 两行居中标签
  let cap(pos, body) = content(pos, block(width: 2.2cm, align(center, body)), anchor: "center")
  // 绿色粘附盘
  let pad(px, py, cx,
    y) = rect((px + cx - 0.46, py + y), (px + cx + 0.46, py + y + 0.2), fill: green, stroke: green, radius: 0.06)
  // 锁紧/释放截面详图：三绿齿 + 两侧品红销，tilt 控制销张开角
  let sect(px, py, bx, by, tilt) = {
    rect((px + bx - 0.8, py + by), (px + bx + 0.8, py + by + 0.12), fill: green, stroke: green)
    for t in (-0.4, 0, 0.4) {
      let h = if t == 0 { 0.6 } else { 0.36 }
      rect((px + bx + t - 0.06, py + by + 0.12), (px + bx + t + 0.06, py + by + 0.12 + h), fill: green, stroke: green)
    }
    for s in (-1, 1) {
      line((px + bx + s * 0.62, py + by + 0.14), (px + bx + s * (0.62 + tilt), py + by + 0.62), stroke: mag + 2pt)
    }
  }

  // (a) 接近目标：压缩弹簧储能，锁紧态
  {
    let px = 0.4
    let py = 10.6
    let cx = 3.5
    let P(x, y) = (px + x, py + y)
    panel(px, py, "(a)")
    pad(px, py, cx, 7.9)
    rect(P(cx - 0.09, 7.24), P(cx + 0.09, 7.92), fill: green, stroke: green)
    spr(px + cx, py + 6.98, py + 7.24, 0.34, 4)
    rect(P(cx - 0.46, 6.84), P(cx + 0.46, 6.97), fill: faint, stroke: mgray + 0.5pt)
    line(P(cx, 5.28), P(cx, 7.4), stroke: gray + 1pt)
    for s in (-1, 1) {
      rect(P(cx + s * 0.4 - 0.045, 5.28), P(cx + s * 0.4 + 0.045, 6.84), fill: gray, stroke: none)
      spr(px + cx + s * 0.4, py + 5.38, py + 6.78, 0.24, 11)
    }
    rect(P(cx - 0.5, 4.28), P(cx + 0.5, 5.28), stroke: mgray + 0.5pt, dash: "dashed")
    rect(P(cx - 0.33, 4.42), P(cx + 0.33, 4.54), fill: green, stroke: green)
    for t in (-0.2, 0, 0.2) {
      let h = if t == 0 { 4.98 } else { 4.84 }
      rect(P(cx + t - 0.045, 4.54), P(cx + t + 0.045, h), fill: green, stroke: green)
    }
    for s in (-1, 1) {
      rect(P(cx + s * 0.42 - 0.05, 4.58), P(cx + s * 0.42 + 0.05, 4.94), fill: mag, stroke: mag)
    }
    rect(P(cx - 0.27, 2.4), P(cx + 0.27, 4.32), fill: gray, stroke: mgray + 0.5pt)
    rect(P(cx - 0.13, 2.46), P(cx + 0.13, 4.4), fill: mag, stroke: mag)
    line(P(cx - 2.05, 3.45), P(cx - 2.05, 4.25), stroke: 0.7pt, mark: (end: "stealth"))
    content(P(cx - 2.35, 3.2), [*v*], anchor: "center")
    // 引线：压缩弹簧（上方小簧）与粘附板
    cap(P(1.1, 7.5), [Compression \ spring])
    line(P(1.85, 7.42), P(cx + 0.02, 7.12), stroke: 0.5pt)
    cap(P(5.95, 7.4), [Adhesive \ plate])
    line(P(5.6, 7.45), P(cx + 0.4, 7.92), stroke: 0.5pt)
    cap(P(1.0, 5.9), [Tension \ spring])
    line(P(1.75, 5.95), P(cx - 0.62, 6.02), stroke: 0.5pt)
    line(P(cx + 0.55, 4.72), P(5.42, 4.95), stroke: 0.5pt)
    sect(px, py, 6.3, 4.5, 0)
    cap(P(6.3, 3.5), [Locked state \ (section view)])
  }

  // (b) 接触目标：拉伸弹簧伸长，锁紧销张开（释放态）
  {
    let px = 9.7
    let py = 10.6
    let cx = 3.5
    let P(x, y) = (px + x, py + y)
    panel(px, py, "(b)")
    pad(px, py, cx, 7.95)
    rect(P(cx - 0.11, 7.28), P(cx + 0.11, 7.97), fill: green, stroke: green)
    rect(P(cx - 0.46, 7.14), P(cx + 0.46, 7.27), fill: faint, stroke: mgray + 0.5pt)
    line(P(cx, 4.9), P(cx, 7.2), stroke: gray + 1pt)
    for s in (-1, 1) {
      rect(P(cx + s * 0.4 - 0.045, 5.5), P(cx + s * 0.4 + 0.045, 7.14), fill: gray, stroke: none)
      spr(px + cx + s * 0.4, py + 5.6, py + 7.08, 0.24, 7)
    }
    rect(P(cx - 0.5, 3.86), P(cx + 0.5, 4.9), stroke: mgray + 0.5pt, dash: "dashed")
    rect(P(cx - 0.33, 4.0), P(cx + 0.33, 4.12), fill: green, stroke: green)
    for t in (-0.2, 0, 0.2) {
      let h = if t == 0 { 4.56 } else { 4.42 }
      rect(P(cx + t - 0.045, 4.12), P(cx + t + 0.045, h), fill: green, stroke: green)
    }
    for s in (-1, 1) {
      rect(P(cx + s * 0.46 - 0.05, 4.16), P(cx + s * 0.46 + 0.05, 4.52), fill: mag, stroke: mag)
    }
    rect(P(cx - 0.27, 2.4), P(cx + 0.27, 3.94), fill: gray, stroke: mgray + 0.5pt)
    line(P(cx, 2.45), P(cx, 3.9), stroke: mgray + 0.5pt)
    line(P(cx + 0.55, 4.35), P(5.42, 4.3), stroke: 0.5pt)
    sect(px, py, 6.3, 3.85, 0.3)
    cap(P(6.3, 2.85), [Release state \ (section view)])
  }

  // (c) 弹性臂展开并向目标旋转
  {
    let px = 0.4
    let py = 0.4
    let cx = 4.2
    let P(x, y) = (px + x, py + y)
    panel(px, py, "(c)")
    pad(px, py, cx, 7.95)
    rect(P(cx - 0.08, 5.3), P(cx + 0.08, 7.97), fill: gray, stroke: none)
    rect(P(cx - 0.15, 4.4), P(cx + 0.15, 5.35), fill: mag, stroke: none)
    rect(P(cx - 0.3, 2.4), P(cx + 0.3, 4.45), fill: gray, stroke: mgray + 0.5pt)
    line(P(cx - 0.36, 4.36), P(cx + 0.36, 4.36), stroke: green + 2pt)
    for s in (-1, 1) {
      line(P(cx + s * 0.3, 4.36), P(cx + s * 0.46, 4.66), stroke: green + 1.5pt)
      line(P(cx, 7.15), P(cx + s * 1.75, 6.12), stroke: brown + 3pt)
      line(P(cx, 5.85), P(cx + s * 2.6, 5.62), stroke: 0.5pt)
      line(
        P(cx + s * 1.75, 6.12), P(cx + s * 2.5, 5.78),
        P(cx + s * 3.15, 5.28), P(cx + s * 3.72, 4.52),
        stroke: mag + 2pt,
      )
      line(P(cx + s * 2.25, 6.15), P(cx + s * 2.6, 5.98), stroke: 0.5pt, mark: (end: "stealth"))
    }
    content(P(cx + 2.95, 6.12), [$omega$], anchor: "center")
  }

  // (d) 柔性臂展平贴合目标底面
  {
    let px = 9.7
    let py = 0.4
    let cx = 4.2
    let P(x, y) = (px + x, py + y)
    panel(px, py, "(d)")
    pad(px, py, cx, 7.95)
    rect(P(cx - 0.09, 5.4), P(cx + 0.09, 7.97), fill: gray, stroke: none)
    rect(P(cx - 0.22, 5.35), P(cx + 0.22, 6.5), fill: gray, stroke: mgray + 0.5pt)
    rect(P(cx - 0.13, 4.85), P(cx + 0.13, 5.4), fill: mag, stroke: none)
    rect(P(cx - 0.3, 2.6), P(cx + 0.3, 4.9), fill: gray, stroke: mgray + 0.5pt)
    line(P(cx - 0.34, 4.86), P(cx + 0.34, 4.86), stroke: green + 2pt)
    for s in (-1, 1) {
      line(P(cx, 7.55), P(cx + s * 2.35, 7.85), stroke: faint + 3pt)
      line(P(cx + s * 0.15, 6.45), P(cx + s * 2.35, 7.82), stroke: gray + 0.9pt)
      line(P(cx, 7.62), P(cx + s * 1.5, 7.7), stroke: brown + 2.5pt)
      line(P(cx + s * 2.3, 7.84), P(cx + s * 3.85, 7.97), stroke: mag + 2pt)
      line(P(cx + s * 3.85, 7.97), P(cx + s * 4.1, 8.12), stroke: mag + 2pt)
    }
  }
})
