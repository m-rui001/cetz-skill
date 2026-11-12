#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：AF-TAD 异常检测算法工作流蛇形流程。上排自左向右：Data Preprocessing and Window Partitioning→
// Feature Encoding→Conditional Encoding of Flight Information→Global Trend Fusion→Transformer Encoder；
// 右端折向下排，自右向左：Multiscale Time Window Compression→Transformer Decoder→Dynamic Threshold
// Adjustment→Scaling Anomaly Scores→Anomalous interval detected。蓝底为处理步骤，白底为首尾与编解码器。
// 逐字保留九步标签。
// 来源：Aerospace 2025, 12, 1066, Figure 3 "Algorithmic workflow of the proposed Transformer-based anomaly detection model". DOI 10.3390/aerospace12121066

#canvas({
  import draw: *
  let ink = black
  let blue = rgb("#cfe0f7")
  let bblue = rgb("#6f8fc0")
  let t(pos, s, size: 5.4pt) = content(
    pos, text(size: size)[#s], anchor: "center", frame: none)
  let boxb(c, s, fill: white, stroke: ink) = {
    rect((c.at(0) - 1.25, c.at(1) - 0.52), (c.at(0) + 1.25, c.at(1) + 0.52),
      radius: 0.08, fill: fill, stroke: 0.8pt + stroke)
    t(c, s)
  }
  let arr(a, b) = line(a, b, stroke: 0.8pt + ink, mark: (end: "stealth", scale: 0.5))
  let top = 3.15
  let bot = 1.15
  let xs = (1.50, 4.30, 7.10, 9.90, 12.70)

  // 上排：预处理 → 特征编码 → 条件编码 → 趋势融合 → Transformer 编码器
  boxb((xs.at(0), top), [Data Preprocessing \ and Window \ Partitioning])
  boxb((xs.at(1), top), [Feature Encoding], fill: blue, stroke: bblue)
  boxb((xs.at(2), top), [Conditional \ Encoding of \ Flight Information], fill: blue, stroke: bblue)
  boxb((xs.at(3), top), [Global Trend \ Fusion], fill: blue, stroke: bblue)
  boxb((xs.at(4), top), [Transformer \ Encoder])
  for i in range(4) {
    arr((xs.at(i) + 1.25, top), (xs.at(i + 1) - 1.25, top))
  }

  // 右端折下
  arr((xs.at(4), top - 0.52), (xs.at(4), bot + 0.52))

  // 下排：多尺度时窗压缩 → Transformer 解码器 → 动态阈值 → 分数缩放 → 检出异常区间
  boxb((xs.at(4), bot), [Multiscale \ Time Window \ Compression], fill: blue, stroke: bblue)
  boxb((xs.at(3), bot), [Transformer \ Decoder])
  boxb((xs.at(2), bot), [Dynamic \ Threshold Adjustment], fill: blue, stroke: bblue)
  boxb((xs.at(1), bot), [Scaling Anomaly \ Scores], fill: blue, stroke: bblue)
  boxb((xs.at(0), bot), [Anomalous \ interval detected])
  for i in range(4) {
    arr((xs.at(4 - i) - 1.25, bot), (xs.at(3 - i) + 1.25, bot))
  }
})
