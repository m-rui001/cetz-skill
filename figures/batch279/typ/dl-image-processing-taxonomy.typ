#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：深度学习图像处理综述总览树。根部深青 Deep Learning and Image Processing 经顶部横母线分六列：
// Evolution Deep Learning in Image Processing、Deep Learning Techniques、Advanced Deep Learning Models、
// Evaluation Metrics、Applications、Challenges and Future Directions。橙底标题下以左侧干线挂接青色条目框，
// 逐字保留 40 条子题（含 Self-Supervised、Pixel Accuracy FID PSNR SSIM NCC、Efficient model architectures
// NAS pruning quantization distillation neuromorphic and quantum computing 等）。
// 来源：Sensors 2025, 25, 531, Figure 1 "An overview of surveyed key topics in image processing with DL". DOI 10.3390/s25020531

#canvas({
  import draw: *
  let ink = black
  let teal = rgb("#1e8fa0")
  let dteal = rgb("#176d7a")
  let orange = rgb("#e08a2e")
  let l2(a, b) = line(a, b, stroke: 0.7pt + ink)
  let nodebox(c, w, h, s, size: 5.0pt, fill: teal) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      radius: 0.035, fill: fill, stroke: 0.5pt + fill)
    content(c, text(size: size, fill: white)[#s], anchor: "center", frame: none)
  }
  // 各列标题（中心 x、半宽、标题、子条目列表：文字与行数）
  let cols = (
    (1.60, 1.10, [Evolution \ Deep Learning in \ Image Processing],
      (([Architectural \ Innovations], 2), ([Task-Specific \ Architectures], 2),
       ([Transformers and \ Self-Attention], 2), ([Generative Models], 1))),
    (4.10, 1.10, [Deep Learning \ Techniques],
      (([Transfer Learning], 1), ([Data Augmentation], 1), ([Regularization \ Techniques], 2),
       ([Adversarial Training], 1), ([Self-Supervised and \ Unsupervised Learning \ Models], 3),
       ([Domain Generalization \ and Adaptation], 2), ([Meta-Learning], 1),
       ([Prompt Learning], 1), ([Model Compression \ and Optimization], 2))),
    (6.60, 1.10, [Advanced Deep \ Learning \ Models],
      (([Deep Residual Networks \ and Beyond], 2), ([Attention Mechanisms \ and Transformers], 2),
       ([Generative Models and \ Adversarial Networks], 2), ([Hybrid and Multi-Modal \ Models], 2))),
    (9.15, 1.10, [Evaluation Metrics],
      (([IoU], 1), ([Accuracy, Precision, \ Recall, F1-score AUC], 2),
       ([Average Precision \ mean Average \ Precision], 3),
       ([MCC, Cohen's \ Kappa, Balanced \ Accuracy], 3), ([Dice, Jaccard Index], 1),
       ([Pixel Accuracy, \ FID, PSNR, SSIM, NCC], 2), ([Log Loss], 1))),
    (11.70, 1.10, [Applications],
      (([Medical Imaging], 1), ([Autonomous \ Systems], 2),
       ([Remote Sensing and \ Environmental \ Monitoring], 3),
       ([Security and \ Surveillance], 2), ([Art and Cultural \ Heritage], 2),
       ([Ethical and Social \ Considerations], 2), ([Interdisciplinary \ Collaboration], 2))),
    (14.70, 1.45, [Challenges and \ Future Directions],
      (([Data scarcity], 1), ([Computational complexity \ of DL models], 2),
       ([Interpretability], 1), ([Generalization and \ robustness], 2),
       ([Ethical implications, \ including bias and pri- \ vacy concerns in AI], 3),
       ([Self supervised learning \ and data scarcity], 2),
       ([Efficient model architectures, \ NAS, pruning, quantization, \ distillation, neuromorphic \ and quantum computing], 4),
       ([XAI methods & DL], 1), ([Quantum computing and \ edge computing with DL], 2))),
  )

  // 根部与顶部横母线
  nodebox((8.35, 8.92), 1.35, 0.40, [Deep Learning \ and \ Image Processing], size: 6.6pt, fill: dteal)
  l2((8.35, 8.52), (8.35, 8.35))
  l2((1.60, 8.35), (14.70, 8.35))

  // 六列：标题、顶部引线、左干线、条目与横支
  for c in cols {
    let cx = c.at(0)
    let w = c.at(1)
    l2((cx, 8.35), (cx, 7.85))
    nodebox((cx, 7.49), w, 0.36, c.at(2), size: 5.6pt, fill: orange)
    let tx = cx - w - 0.12
    l2((cx - w + 0.05, 7.10), (tx, 7.10))
    let y = 7.00
    let last = y
    for it in c.at(3) {
      let h = 0.10 + 0.21 * it.at(1)
      let cy = y - h / 2
      nodebox((cx, cy), w, h / 2, it.at(0), size: 5.0pt)
      l2((tx, cy), (cx - w, cy))
      last = cy
      y = y - h - 0.08
    }
    l2((tx, 7.10), (tx, last))
  }
})
