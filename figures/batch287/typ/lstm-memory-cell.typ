#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：LSTM 记忆单元结构图。上方单元状态线 c_{t-1}→C_t 依次经过遗忘门乘算与输入门加算；
// 下方隐状态线 h_{t-1}→h_t 被三个 σ 门控支路取用，z_t 从底部并入输入；输入门内 tanh 生成
// 候选状态 $\tilde C_t$，输出门与 tanh(C_t) 相乘得到 h_t。标签按原图逐个保留。
// 来源：Robotics 2025, 14, 74, Figure 2 "Graphical representation of an LSTM memory cell".
// DOI 10.3390/robotics14060074

#canvas({
  import draw: *
  let ink = black
  let gray = rgb("#8f8f8f")
  let green = rgb("#cfe3bc")
  let sand = rgb("#fbe7b5")
  let pink = rgb("#f7d9e8")
  let lav = rgb("#b9c7e4")
  let hcol = rgb("#f2c9e0")
  let zcol = rgb("#a9d08e")
  let ar = (end: "stealth", fill: ink, scale: 0.8)
  let lw = 1.1pt + ink

  // 外框与三条门控色带
  rect((1.55, 0.45), (11.90, 4.80), radius: 0.18, fill: rgb("#f2f2f2"), stroke: 1.0pt + ink)
  let band(x1, x2, title) = {
    rect((x1, 0.95), (x2, 4.55), radius: 0.02, fill: green, stroke: 0.6pt + gray)
    content(((x1 + x2) / 2, 4.32), title, size: 9.5pt)
  }
  band(2.30, 4.45, [forget gate])
  band(5.20, 7.50, [Input gate])
  band(8.30, 10.60, [Output gate])
  content((6.72, 0.70), [LSTM memory cell], size: 10pt)

  // 上下两条主线
  line((1.50, 3.85), (11.95, 3.85), stroke: lw, mark: ar)
  line((1.50, 1.35), (11.95, 1.35), stroke: lw, mark: ar)

  // 状态/输入端子
  let term(x1, y1, w, h, fillc, body, fs: 9.5pt) = {
    rect((x1, y1), (x1 + w, y1 + h), radius: 0.02, fill: fillc, stroke: 0.7pt + ink)
    content((x1 + w / 2, y1 + h / 2), body, size: fs)
  }
  term(0.50, 3.60, 1.00, 0.50, lav, [$c_(t-1)$])
  term(11.95, 3.60, 1.00, 0.50, lav, [$C_t$])
  term(0.50, 1.10, 1.00, 0.50, hcol, [$h_(t-1)$])
  term(11.95, 1.10, 1.05, 0.50, hcol, [$h_t$])
  term(2.95, 0.10, 0.50, 0.35, zcol, [$z_t$], fs: 9pt)

  // 门控支路：σ 盒与汇入点
  let sig(x, y, fs: 10pt) = {
    rect((x - 0.25, y), (x + 0.25, y + 0.35), radius: 0.02, fill: pink, stroke: 0.6pt + gray)
    content((x, y + 0.175), [$sigma$], size: fs)
  }
  let tanhbox(x, y) = {
    rect((x - 0.38, y), (x + 0.38, y + 0.52), radius: 0.02, fill: pink, stroke: 0.6pt + gray)
    content((x, y + 0.26), [tanh], size: 6pt)
  }
  let op(x, y, kind) = {
    circle((x, y), radius: 0.30, fill: sand, stroke: 1.0pt + ink)
    if kind == "times" {
      line((x - 0.13, y - 0.13), (x + 0.13, y + 0.13), stroke: 0.9pt + ink)
      line((x - 0.13, y + 0.13), (x + 0.13, y - 0.13), stroke: 0.9pt + ink)
    } else {
      line((x - 0.15, y), (x + 0.15, y), stroke: 0.9pt + ink)
      line((x, y - 0.15), (x, y + 0.15), stroke: 0.9pt + ink)
    }
  }

  // 遗忘门：σ 从 h 线取输入，向上乘入状态线
  sig(3.45, 1.75)
  line((3.45, 1.35), (3.45, 1.75), stroke: lw)
  line((3.45, 2.10), (3.45, 3.55), stroke: lw, mark: ar)
  content((3.62, 2.80), [$f_t$], size: 9pt, anchor: "west")
  // 输入门：σ 折线入乘算，tanh 生成候选状态
  sig(6.20, 1.75)
  line((6.20, 1.35), (6.20, 1.75), stroke: lw)
  line((6.20, 2.10), (6.20, 2.60), stroke: lw)
  line((6.20, 2.60), (6.55, 2.60), stroke: lw, mark: ar)
  content((5.90, 2.42), [$i_t$], size: 9pt, anchor: "east")
  tanhbox(6.85, 1.62)
  line((6.85, 2.14), (6.85, 2.30), stroke: lw, mark: ar)
  content((6.44, 2.88), [$tilde(C)_t$], size: 7pt, anchor: "east")
  line((6.85, 2.90), (6.85, 3.55), stroke: lw, mark: ar)
  // 输出门：σ 折线入乘算，C_t 经 tanh 后与门控相乘
  sig(9.20, 1.75)
  line((9.20, 1.35), (9.20, 1.75), stroke: lw)
  line((9.20, 2.10), (9.20, 2.45), stroke: lw)
  line((9.20, 2.45), (9.55, 2.45), stroke: lw, mark: ar)
  content((9.02, 2.28), [$o_t$], size: 9pt, anchor: "east")
  tanhbox(9.85, 2.90)
  line((9.85, 3.85), (9.85, 3.42), stroke: lw, mark: ar)
  line((9.85, 2.90), (9.85, 2.75), stroke: lw, mark: ar)
  line((9.85, 2.15), (9.85, 1.35), stroke: lw)

  // 状态线上的两个算符
  op(3.45, 3.85, "times")
  op(6.85, 3.85, "plus")
  op(6.85, 2.60, "times")
  op(9.85, 2.45, "times")

  // z_t 并入底部输入线
  line((3.20, 0.45), (3.20, 1.35), stroke: lw)
  circle((3.20, 1.35), radius: 0.045, fill: ink, stroke: none)
})
