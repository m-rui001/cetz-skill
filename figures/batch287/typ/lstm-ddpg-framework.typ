#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：LSTM 增强 DDPG 的总体框架。左侧为被控环境（履带车），虚线 Agent 框内包含经验回放池、
// Actor/Critic 及其目标网络、损失函数、策略梯度与 LSTM 循环网络面板；箭头标注观测 o、动作 a、
// 奖励 r、价值 Q 与网络参数 θ 的更新通路。按原图 Figure 1 复刻，标签逐字保留。
// 来源：Robotics 2025, 14, 74, Figure 1. DOI 10.3390/robotics14060074

#canvas({
  import draw: *
  let ink = black
  let gray = rgb("#9a9a9a")
  let thin = (paint: ink, thickness: 0.8pt)
  let dashthin = (paint: ink, thickness: 0.8pt, dash: "dashed")
  let boxstroke = 1.0pt + ink
  let tan = rgb("#e7c9a3")
  let grn = rgb("#a9d3a6")
  let lblue = rgb("#8fb3dc")
  let panel = rgb("#fbfbfd")
  let ar = (end: "stealth", fill: ink, scale: 0.7)
  let ar2 = (start: "stealth", end: "stealth", fill: ink, scale: 0.6)

  // ---------- Agent 外框与环境 ----------
  rect((2.95, 0.55), (13.50, 8.00), radius: 0.10, fill: panel, stroke: (paint: ink, thickness: 1.0pt, dash: "dashed"))
  content((3.22, 0.80), [Agent], size: 10pt, anchor: "west")
  rect((0.30, 2.90), (2.55, 5.80), radius: 0.18, fill: white, stroke: boxstroke)
  content((1.42, 3.15), [Environment], size: 8pt)
  // 履带车图标（俯视示意）
  rect((1.08, 4.28), (1.26, 5.08), radius: 0.04, fill: rgb("#3a3a3a"), stroke: none)
  rect((1.60, 4.28), (1.78, 5.08), radius: 0.04, fill: rgb("#3a3a3a"), stroke: none)
  rect((1.30, 4.36), (1.56, 5.00), radius: 0.05, fill: rgb("#e6be5c"), stroke: 0.6pt + ink)
  rect((1.37, 4.58), (1.49, 4.80), radius: 0.03, fill: rgb("#333333"), stroke: none)

  // ---------- 四个网络框 ----------
  let nbox(x1, y1, x2, y2, title, tsize) = {
    rect((x1, y1), (x2, y2), radius: 0.08, fill: white, stroke: boxstroke)
    content(((x1 + x2) / 2, y1 + 0.23), title, size: tsize)
  }
  nbox(5.05, 5.95, 8.15, 7.45, [Actor Network], 8.5pt)
  nbox(9.95, 5.95, 12.55, 7.45, [Critic Network], 8.5pt)
  nbox(5.05, 2.05, 8.15, 3.45, [#text(size: 8pt)[Target Actor Network]], 6.2pt)
  nbox(9.95, 2.05, 12.55, 3.45, [#text(size: 7pt)[Target Critic Network]], 6.2pt)

  // 网络缩略图：输入节点 + （LSTM 条 / 中间节点）+ 输出节点
  let net(cx, cy, lstm: true) = {
    rect((cx - 0.52, cy - 0.36), (cx + 0.52, cy + 0.36), radius: 0.08,
      fill: none, stroke: (paint: gray, thickness: 0.5pt, dash: "dashed"))
    let lx = cx - 0.38
    let rx = cx + 0.38
    for k in (-0.18, 0, 0.18) {
      circle((lx, cy + k), radius: 0.045, fill: tan, stroke: 0.4pt + gray)
      circle((rx, cy + k), radius: 0.045, fill: grn, stroke: 0.4pt + gray)
    }
    if lstm {
      rect((cx - 0.10, cy - 0.24), (cx + 0.10, cy + 0.24), radius: 0.05, fill: lblue, stroke: 0.4pt + gray)
      for k in (-0.15, -0.05, 0.05, 0.15) {
        circle((cx, cy + k), radius: 0.032, fill: white, stroke: none)
      }
      for k in (-0.18, 0, 0.18) {
        line((lx + 0.05, cy + k), (cx - 0.11, cy + k), stroke: 0.3pt + gray)
        line((cx + 0.11, cy + k), (rx - 0.05, cy + k), stroke: 0.3pt + gray)
      }
    } else {
      for k in (-0.12, 0, 0.12) {
        circle((cx, cy + k), radius: 0.042, fill: lblue, stroke: 0.4pt + gray)
      }
      for k in (-0.18, 0, 0.18) {
        line((lx + 0.05, cy + k), (cx - 0.04, cy + k), stroke: 0.3pt + gray)
        line((cx + 0.04, cy + k), (rx - 0.05, cy + k), stroke: 0.3pt + gray)
      }
    }
  }
  net(6.60, 6.80, lstm: true)
  net(11.25, 6.80, lstm: true)
  net(6.60, 2.86, lstm: true)
  net(11.25, 2.86, lstm: false)

  // ---------- 经验回放池（圆柱） ----------
  rect((3.50, 3.30), (4.85, 4.45), radius: 0.02, fill: rgb("#eef3f8"), stroke: 0.9pt + ink)
  let ell(cx, cy) = {
    let pts = ()
    for i in range(24) {
      let a = i / 24 * 2 * calc.pi
      pts.push((cx + 0.675 * calc.cos(a), cy + 0.15 * calc.sin(a)))
    }
    line(..pts, close: true, fill: rgb("#eef3f8"), stroke: 0.9pt + ink)
  }
  ell(4.175, 4.45)
  content((4.175, 3.94), [Replay], size: 9pt)
  content((4.175, 3.66), [buffer], size: 9pt)

  // ---------- 策略梯度与损失 ----------
  rect((5.05, 4.45), (7.55, 5.28), radius: 0.06, fill: white, stroke: 0.9pt + ink)
  content((5.14, 5.03), [#text(size: 8pt)[Policy]], size: 6.5pt, anchor: "west")
  content((5.14, 4.66), [Gradient], size: 6.5pt, anchor: "west")
  content((7.05, 4.78), [$nabla_(theta^mu) J$], size: 7.5pt)
  rect((11.55, 4.45), (13.25, 5.30), radius: 0.06, fill: white, stroke: 0.9pt + ink)
  content((12.25, 5.10), [Loss], size: 7pt)
  content((11.72, 4.72), [Function], size: 7pt, anchor: "west")
  content((13.02, 5.10), [$L$], size: 8pt)

  // ---------- LSTM 面板 ----------
  rect((8.30, 0.45), (12.45, 1.95), radius: 0.08, fill: panel,
    stroke: (paint: ink, thickness: 0.9pt, dash: "dashed"))
  let cell(cx, cy) = {
    rect((cx - 0.14, cy - 0.17), (cx + 0.14, cy + 0.17), radius: 0.04, fill: white, stroke: 0.5pt + ink)
    circle((cx, cy - 0.03), radius: 0.035, fill: white, stroke: 0.4pt + ink)
    circle((cx, cy - 0.12), radius: 0.035, fill: white, stroke: 0.4pt + ink)
  }
  cell(9.80, 1.38)
  cell(10.80, 1.38)
  cell(11.80, 1.38)
  line((9.94, 1.38), (10.63, 1.38), stroke: (paint: ink, thickness: 0.8pt), mark: ar)
  line((10.94, 1.38), (11.63, 1.38), stroke: (paint: ink, thickness: 0.8pt), mark: ar)
  content((9.53, 1.38), [$o_(t-T-1)$], size: 6.5pt, anchor: "east")
  content((10.80, 1.74), [$o_(t-1)$], size: 6.5pt)
  content((11.80, 1.74), [$o_t$], size: 6.5pt)
  content((10.40, 0.98), [#text(size: 8pt)[Recurrent Neural Network]], size: 5.8pt)
  content((10.40, 0.70), [LSTM], size: 5.8pt)

  // ---------- 参数更新虚线双向箭头 ----------
  line((7.85, 3.45), (7.85, 5.95), stroke: dashthin, mark: ar2)
  line((10.25, 3.45), (10.25, 5.95), stroke: dashthin, mark: ar2)
  content((7.60, 5.77), [Update], size: 7pt, anchor: "east")
  content((7.60, 5.44), [$theta^mu quad theta^(mu')$], size: 7pt, anchor: "east")
  content((9.98, 5.77), [Update], size: 7pt, anchor: "east")
  content((9.98, 5.44), [$theta^(Q') quad theta^Q$], size: 7pt, anchor: "east")

  // ---------- 数据流 ----------
  // 环境观测 o_t 与上一动作 a_t 送入 Actor
  line((1.15, 5.80), (1.15, 7.15), stroke: thin)
  line((1.15, 7.15), (5.05, 7.15), stroke: thin, mark: ar)
  content((4.55, 7.38), [$o_t$], size: 8.5pt)
  line((1.45, 5.80), (1.45, 6.80), stroke: thin)
  line((1.45, 6.80), (5.05, 6.80), stroke: thin, mark: ar)
  content((4.55, 7.03), [$a_t$], size: 8.5pt)
  // Actor 输出动作 a_t 回到环境
  line((5.05, 6.42), (2.05, 6.42), stroke: thin)
  line((2.05, 6.42), (2.05, 5.80), stroke: thin, mark: ar)
  content((2.42, 6.28), [$a_t$], size: 8.5pt, anchor: "north")
  // 回放池采样 o_i 送入 Actor
  line((4.18, 4.60), (4.18, 6.05), stroke: thin)
  line((4.18, 6.05), (5.05, 6.05), stroke: thin, mark: ar)
  content((4.55, 6.28), [$o_i$], size: 8.5pt)
  // 环境经验入池
  line((2.55, 3.25), (3.10, 3.25), stroke: thin)
  line((3.10, 3.25), (3.10, 3.85), stroke: thin)
  line((3.10, 3.85), (3.50, 3.85), stroke: thin, mark: ar)
  content((3.15, 3.02), [#text(size: 8pt)[$(r_t, o_(t+1))$]], size: 7.5pt, anchor: "north-west")
  // Actor → Critic（动作 a）
  line((8.15, 6.95), (9.95, 6.95), stroke: thin, mark: ar)
  content((9.05, 7.20), [$a$], size: 8.5pt)

  // 回放池奖励 r_i → 损失函数（两处跨线打桥）
  let hopr = 0.10
  line((4.85, 4.10), (7.75, 4.10), stroke: thin)
  arc((7.85, 4.10), start: 0deg, stop: 180deg, radius: hopr, stroke: thin, mode: "OPEN")
  line((7.95, 4.10), (10.15, 4.10), stroke: thin)
  arc((10.25, 4.10), start: 0deg, stop: 180deg, radius: hopr, stroke: thin, mode: "OPEN")
  line((10.35, 4.10), (12.05, 4.10), stroke: thin)
  line((12.05, 4.10), (12.05, 4.45), stroke: thin, mark: ar)
  content((5.22, 4.30), [$r_i$], size: 8pt, anchor: "west")

  // 损失 → 策略梯度（跨两处更新箭头打桥）
  line((11.55, 4.90), (10.35, 4.90), stroke: thin)
  arc((10.25, 4.90), start: 0deg, stop: 180deg, radius: hopr, stroke: thin, mode: "OPEN")
  line((10.15, 4.90), (7.95, 4.90), stroke: thin)
  arc((7.85, 4.90), start: 0deg, stop: 180deg, radius: hopr, stroke: thin, mode: "OPEN")
  line((7.75, 4.90), (7.55, 4.90), stroke: thin, mark: ar)
  // 策略梯度 → Actor
  line((5.60, 5.28), (5.60, 5.95), stroke: thin, mark: ar)

  // Critic 的 Q 值 → 损失函数
  line((11.25, 5.95), (11.25, 5.50), stroke: thin)
  line((11.25, 5.50), (12.30, 5.50), stroke: thin)
  line((12.30, 5.50), (12.30, 5.30), stroke: thin, mark: ar)
  content((12.10, 5.72), [$Q(o_i, a)$], size: 7.5pt)
  // 目标网络 → 目标 Critic
  line((8.15, 3.15), (9.95, 3.15), stroke: thin, mark: ar)
  content((9.05, 3.32), [$a'_(i+1)$], size: 7.5pt)
  line((8.15, 2.80), (9.95, 2.80), stroke: thin, mark: ar)
  content((9.05, 2.62), [$o_(i+1)$], size: 7.5pt)
  // 目标 Critic 的 Q' → 损失函数
  line((12.55, 3.15), (13.15, 3.15), stroke: thin)
  line((13.15, 3.15), (13.15, 4.45), stroke: thin, mark: ar)
  content((12.90, 3.84), [$Q'(o_(i+1), a'_(i+1))$], size: 7pt, anchor: "east")
})
