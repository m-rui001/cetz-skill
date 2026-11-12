#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：具身智能基础模型三层分类图。Level 1 为 Application Domains，Level 2 按 Domestic Assistance /
// Healthcare / Service Automation 三个应用域各列 Perception / Reasoning / Action 三栏模型清单，
// Level 3 为跨域共享能力（Perception / Reasoning / Action）汇总；底部为 LLM/VLM/MLLM/VLA 四色图例。
// 每个模型条目单独成盒，按模态着色；域→栏→清单用竖向箭头连接。
// 来源：Robotics 2026, 15, 55, Figure 6 "Three-level framework mapping foundation models to perception, reasoning, and action"。DOI 10.3390/robotics15030055

#canvas({
  import draw: *
  let ink = black
  let blue = rgb("#a8d0f0")
  let peach = rgb("#f6c9a8")
  let green = rgb("#a9dfb5")
  let pink = rgb("#f4b6cc")
  let grey = rgb("#7a7a7a")
  // 模态→填充色
  let fc(kind) = if kind == "LLM" { blue } else if kind == "VLM" { peach } else if kind == "MLLM" { green } else { pink }
  // 条目盒：中心、半宽、半高、文字、模态
  let item(c, w, h, s, kind) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      fill: fc(kind), stroke: 0.45pt + ink)
    content(c, text(size: 4.6pt)[#s], anchor: "center", frame: none)
  }
  // 标题盒
  let head(c, w, h, s, fill, size: 6pt, fg: ink) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      fill: fill, stroke: 0.5pt + ink)
    content(c, text(size: size, fill: fg)[#s], anchor: "center", frame: none)
  }
  let t(pos, s, size: 6pt, anchor: "center") = content(
    pos, text(size: size)[#s], anchor: anchor, frame: none)
  let arr(a, b) = line(a, b, stroke: 0.5pt + ink, mark: (end: "stealth", scale: 0.45))
  let line2(a, b) = line(a, b, stroke: 0.5pt + ink)

  // Level 1：应用域总栏
  t((0.55, 10.45), [Level 1], size: 7pt, anchor: "west")
  head((9.30, 10.45), 3.10, 0.26, [Application Domains], green, size: 7pt, fg: white)
  // Level 2：三个应用域
  t((0.55, 9.55), [Level 2], size: 7pt, anchor: "west")
  let domains = ((3.20, [Domestic Assistance], rgb("#e07b3c")),
                 (9.30, [Healthcare], rgb("#7a4bc8")),
                 (15.40, [Service Automation], rgb("#c0392b")))
  for (x, s, col) in domains {
    head((x, 9.55), 1.65, 0.24, s, col, size: 6.4pt, fg: white)
  }
  // 总栏到三个应用域
  line2((9.30, 10.19), (9.30, 10.00))
  line2((3.20, 10.00), (15.40, 10.00))
  for x in (3.20, 9.30, 15.40) { arr((x, 10.00), (x, 9.79)) }

  // 每个应用域的三个能力栏
  let subs = ("Perception", "Reasoning", "Action")
  for (dx, _, _) in domains {
    for (i, s) in subs.enumerate() {
      let x = dx - 2.00 + 2.00 * i
      head((x, 8.60), 0.95, 0.22, s, rgb("#d9d9d9"), size: 5.6pt)
    }
    // 应用域到三栏的分支
    line2((dx - 2.00, 9.05), (dx + 2.00, 9.05))
    line2((dx, 9.31), (dx, 9.05))
    for xx in (dx - 2.00, dx, dx + 2.00) { arr((xx, 9.05), (xx, 8.82)) }
  }

  // 三个应用域的具体模型清单（按模态着色）
  let lists = (
    (1.20, (("CLIP-Fields", "VLM"), ("OWL-ViT", "VLM"), ("BLIP-2", "VLM"), ("SAM", "VLM"))),
    (3.20, (("GPT-4", "LLM"), ("LLaMA3.1-8B", "LLM"), ("CodeLLaMA-7B", "LLM"),
            ("GPT-3.5", "LLM"), ("GPT-4V", "LLM"), ("CogNax (GPT-4V)", "LLM"))),
    (5.20, (("Octo", "VLA"), ("RT-2", "VLA"), ("SAFE", "VLA"), ("PARTNR", "VLA"), ("TidyBot", "VLA"))),
    (7.30, (("OpenScene", "VLM"), ("SC-CLIP", "VLM"), ("YOLO", "VLM"), ("GPT-4V", "LLM"))),
    (9.30, (("Codex", "LLM"), ("GPT-3", "LLM"), ("GPT-3.5-turbo-1106", "LLM"), ("GPT-4", "LLM"),
            ("GPT-4o", "LLM"), ("AutoRT", "LLM"))),
    (11.30, (("ProgPrompt", "LLM"), ("MoMa-LLM", "LLM"), ("LLM-Grounder", "VLM"),
             ("OLViS-Nav", "VLM"), ("AutoDri", "LLM"), ("ULTRA", "VLM"), ("SayPlan", "VLM"), ("PALM-E", "VLA"))),
    (13.40, (("Detic-CLIP", "VLM"), ("VING", "VLM"), ("PG-Instruct BLIP", "VLM"), ("CLIP", "VLM"))),
    (15.40, (("GPT-3", "LLM"), ("GPT-3.5", "LLM"), ("LLaMA", "LLM"), ("LLM Search", "LLM"),
             ("HAM-Nav", "LLM"), ("Paligemma-3B", "LLM"), ("π0.5", "MLLM"))),
    (17.40, (("π0", "VLA"), ("Hi-Robot", "VLA"), ("PhysObjects", "VLM"), ("LM-Nav", "VLA"))),
  )
  for (x, items) in lists {
    for (i, it) in items.enumerate() {
      let y = 8.18 - 0.33 * i
      item((x, y), 0.92, 0.15, it.at(0), it.at(1))
      if i == 0 { line2((x, 8.38), (x, 8.33)) }
    }
  }

  // Level 3：跨域共享能力
  rect((0.35, 1.00), (18.25, 5.05), fill: none, stroke: 0.7pt + rgb("#c0392b"))
  t((0.55, 4.85), [Level 3], size: 7pt, anchor: "west")
  head((9.30, 4.62), 5.60, 0.26, [Shared Model Capabilities Across Domains], rgb("#4a6fa5"), size: 7pt, fg: white)
  let shared = ((5.20, [Perception]), (9.30, [Reasoning]), (13.40, [Action]))
  for (x, s) in shared {
    head((x, 3.95), 0.85, 0.22, s, rgb("#9db8dc"), size: 5.8pt)
    arr((x, 4.26), (x, 4.17))
  }
  line2((5.20, 4.26), (13.40, 4.26))
  line2((9.30, 4.36), (9.30, 4.26))

  let sharedLists = (
    (5.20, (("CLIP", "VLM"), ("BLIP-2", "VLM"), ("OWL-ViT", "VLM"), ("OpenScene", "VLM"),
            ("SAM", "VLM"), ("SC-CLIP", "VLM"))),
    (9.30, (("GPT-3.5 / GPT-3", "LLM"), ("LLaMA2/3", "LLM"), ("Codex / CodeLLaMA", "LLM"),
            ("DistilBERT / BERT", "LLM"), ("GPT-4/4o", "LLM"), ("Paligemma-3B", "LLM"), ("TidyBot", "VLM"))),
    (13.40, (("SayCan", "VLA"), ("RT-2", "VLA"), ("Octo", "VLA"), ("PALM-E", "VLA"),
             ("SAFE", "VLA"), ("Voyager", "MLLM"))),
  )
  for (x, items) in sharedLists {
    for (i, it) in items.enumerate() {
      let y = 3.60 - 0.33 * i
      item((x, y), 0.92, 0.15, it.at(0), it.at(1))
      if i == 0 { line2((x, 3.73), (x, 3.65)) }
    }
  }

  // 底部图例
  let legend = (("Large Language Model (LLM)", blue), ("Vision-Language Model (VLM)", peach),
                ("Multimodal Large Language Model (MLLM)", green), ("Vision-Language-Action Model (VLA)", pink))
  let lx = 1.20
  for (s, col) in legend {
    rect((lx, 0.45), (lx + 0.28, 0.63), fill: col, stroke: 0.5pt + ink)
    t((lx + 0.36, 0.54), s, size: 5.2pt, anchor: "west")
    lx = lx + 4.35
  }
})
