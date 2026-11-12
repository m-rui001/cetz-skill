#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：连续体机器人混合控制策略框图。Target x_des 分两路：主路进 Learned inverse model → Trajectory
// optimization，命令线标注 Δq 后进入 Continuum robot；命令线在机器人前分出一路 Δq*（计算值）向下进入
// PID 右侧。Target 另一路下折进 PID 左上输入；机器人底部回馈 x_i、x_(i−1) 经底部折线进入 PID 左下输入。
// 全部标签逐字保留，纯黑白线稿。
// 来源：Actuators 2024, 13(2), 52, Figure 22 "Schematic diagram of the hybrid control strategy" DOI 10.3390/act13020052

#canvas({
  import draw: *
  let ink = black
  let bw = 1.2pt
  let block(x1, x2, y1, y2, s) = {
    rect((x1, y1), (x2, y2), stroke: bw + ink)
    content(((x1 + x2) / 2, (y1 + y2) / 2), text(size: 9.5pt, s))
  }
  let arr(a, b) = line(a, b, stroke: bw + ink, mark: (end: "stealth", scale: 0.55, fill: ink))
  let tx(p, s, size: 9pt, anchor: "center") = content(p, text(size: size, s), anchor: anchor, frame: none)

  // 三个前向方块：逆模型、轨迹优化、连续体机器人
  block(2.55, 6.15, 3.40, 4.55, [Learned inverse\ model])
  block(7.75, 11.35, 3.40, 4.55, [Trajectory\ optimization])
  block(12.95, 17.05, 3.40, 4.55, [Continuum\ robot])

  // 前向主链：目标输入 → 逆模型 → 轨迹优化 → 机器人
  arr((0.35, 3.98), (2.55, 3.98))
  tx((1.35, 4.32), [Target $x^("des")$])
  arr((6.15, 3.98), (7.75, 3.98))
  arr((11.35, 3.98), (12.95, 3.98))
  tx((12.12, 4.30), [$Delta q$])

  // Δq* 支路：命令线下折后左转进入 PID 右侧
  line((12.25, 3.98), (12.25, 2.15), (11.35, 2.15), stroke: bw + ink)
  tx((12.62, 2.72), [$Delta q^*$])

  // PID 方块与两路左侧输入：目标前馈、机器人状态回馈
  block(7.75, 11.35, 1.45, 2.60, [PID])
  line((1.75, 3.98), (1.75, 2.35), (7.75, 2.35), stroke: bw + ink,
    mark: (end: "stealth", scale: 0.55, fill: ink))
  line((15.00, 3.40), (15.00, 0.55), (7.55, 0.55), (7.55, 1.85), (7.75, 1.85),
    stroke: bw + ink, mark: (end: "stealth", scale: 0.55, fill: ink))
  tx((8.55, 0.88), [$x_i$, $x_(i-1)$], anchor: "west")
})
