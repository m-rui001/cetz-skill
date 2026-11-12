#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 成品：AF-TAD 三路 Transformer 特征编码架构。Overload/Fuel/RPM 三路数据各自加 PE+CE 后进入
// Transformer encoder（Multi-Head Attention→Add and normalize→FFN→Add and normalize）；
// Fuel 路输出分出上下母线，作为两侧编码器的 As Q 查询；三路输出中两侧经 softmax→× 加权，
// 与 Fuel 路输出、Trend information 汇入求和点，再经 Time Window Compression→Transformer decoder
// →Reconstructed data。逐字保留 As K,V、As Q、softmax、trend 等标签。
// 来源：Aerospace 2025, 12, 1066, Figure 2 "The architecture of the proposed Transformer-based feature encoding model". DOI 10.3390/aerospace12121066

#canvas({
  import draw: *
  let ink = black
  let gray = rgb("#9a9a9a")
  let bgray = rgb("#f2f2f2")
  let blue = rgb("#cfe0f7")
  let bblue = rgb("#6f8fc0")
  let pink = rgb("#f2b8b8")
  let purple = rgb("#dcc9ea")
  // 盒：中心、半宽、半高、文字、字号、填充、描边、圆角
  let box(c, w, h, s, size: 5.6pt, fill: white, stroke: ink, radius: 0.04) = {
    rect((c.at(0) - w, c.at(1) - h), (c.at(0) + w, c.at(1) + h),
      radius: radius, fill: fill, stroke: 0.7pt + stroke)
    content(c, text(size: size)[#s], anchor: "center", frame: none)
  }
  let t(pos, s, size: 5.6pt, anchor: "center") = content(
    pos, text(size: size)[#s], anchor: anchor, frame: none)
  let arr(a, b) = line(a, b, stroke: 0.7pt + ink, mark: (end: "stealth", scale: 0.45))
  let line2(a, b) = line(a, b, stroke: 0.7pt + ink)
  let polyarr(..pts) = line(..pts, stroke: 0.7pt + ink, mark: (end: "stealth", scale: 0.45))
  let junc(p) = circle(p, radius: 0.035, fill: ink, stroke: none)
  // 编码器内部四个模块：中心 x、文字、半宽、字号
  let cells = (
    (5.03, [Multi- \ Head \ Attention], 0.45, 4.8pt),
    (6.113, [Add \ and \ normalize], 0.45, 4.8pt),
    (6.886, [FFN], 0.14, 5.2pt),
    (7.659, [Add \ and \ normalize], 0.45, 4.8pt),
  )
  // 单路 Transformer encoder：浅灰圆角框＋标题＋四个蓝模块与连线
  let encoder(cy) = {
    box((6.35, cy), 1.98, 0.88, [], fill: bgray, stroke: gray, radius: 0.16)
    t((6.35, cy + 0.60), [Transformer \ encoder], size: 6.2pt)
    for (i, c) in cells.enumerate() {
      box((c.at(0), cy - 0.10), c.at(2), 0.34, c.at(1), size: c.at(3),
        fill: blue, stroke: bblue, radius: 0.08)
      if i < 3 {
        let x1 = c.at(0) + c.at(2) + 0.01
        let x2 = cells.at(i + 1).at(0) - cells.at(i + 1).at(2) - 0.01
        line2((x1, cy - 0.10), (x2, cy - 0.10))
      }
    }
  }
  // 三路数据流：数据盒 →（可插特征工程）→ 加 PE+CE 的求和点 → 编码器
  let stream(cy, name, wname, hasfe) = {
    box((0.85, cy), wname, 0.21, name, size: 5.4pt, fill: pink)
    if hasfe {
      box((2.06, cy), 0.42, 0.23, [Feature \ engineering], size: 4.8pt)
      arr((0.85 + wname, cy), (1.62, cy))
      arr((2.48, cy), (2.74, cy))
    } else {
      arr((0.85 + wname, cy), (2.74, cy))
    }
    circle((2.90, cy), radius: 0.13, fill: white, stroke: 0.7pt + ink)
    t((2.90, cy), [+], size: 9pt)
    circle((2.90, cy + 1.00), radius: 0.30, fill: white, stroke: 0.7pt + ink)
    t((2.90, cy + 1.00), [PE+CE], size: 5.4pt)
    arr((2.90, cy + 0.70), (2.90, cy + 0.15))
    arr((3.04, cy), (4.34, cy))
    t((3.66, cy + 0.16), [As K,V], size: 5.4pt)
  }
  stream(5.55, [Overload data], 0.72, false)
  stream(3.55, [Fuel data], 0.62, true)
  stream(1.55, [RPM data], 0.55, false)
  encoder(5.55)
  encoder(3.55)
  encoder(1.55)

  // ── Fuel 路输出分出上下母线，作为两侧编码器的 As Q
  junc((9.65, 3.55))
  polyarr((9.65, 3.55), (9.65, 6.62), (4.00, 6.62), (4.00, 5.15), (4.34, 5.15))
  polyarr((9.65, 3.55), (9.65, 0.55), (4.00, 0.55), (4.00, 1.15), (4.34, 1.15))
  t((3.72, 5.30), [As Q], size: 5.4pt)
  t((3.72, 1.30), [As Q], size: 5.4pt)

  // ── 两侧输出：softmax → × 加权；中线 Fuel 输出直达求和点
  arr((8.33, 3.55), (9.94, 3.55))
  arr((8.33, 5.55), (9.00, 5.55))
  junc((8.62, 5.55))
  polyarr((8.62, 5.55), (8.62, 6.14), (10.10, 6.14), (10.10, 5.73))
  arr((8.33, 1.55), (9.00, 1.55))
  junc((8.62, 1.55))
  polyarr((8.62, 1.55), (8.62, 1.06), (10.10, 1.06), (10.10, 1.37))
  circle((9.28, 5.55), radius: 0.28, fill: bgray, stroke: gray)
  t((9.28, 5.55), [softmax], size: 5.0pt)
  circle((9.28, 1.55), radius: 0.28, fill: bgray, stroke: gray)
  t((9.28, 1.55), [softmax], size: 5.0pt)
  arr((9.56, 5.55), (9.92, 5.55))
  arr((9.56, 1.55), (9.92, 1.55))
  circle((10.10, 5.55), radius: 0.18, fill: white, stroke: 0.7pt + ink)
  t((10.10, 5.55), [×], size: 9pt)
  circle((10.10, 1.55), radius: 0.18, fill: white, stroke: 0.7pt + ink)
  t((10.10, 1.55), [×], size: 9pt)

  // ── 求和点：加权结果、Fuel 输出、Trend information → 时窗压缩 → 解码器 → 重构数据
  circle((10.10, 3.55), radius: 0.16, fill: white, stroke: 0.7pt + ink)
  t((10.10, 3.55), [+], size: 9pt)
  arr((10.10, 5.39), (10.10, 3.73))
  arr((10.10, 1.71), (10.10, 3.37))
  box((11.00, 4.55), 0.80, 0.19, [Trend information], size: 5.2pt, fill: pink)
  polyarr((11.00, 4.36), (11.00, 3.92), (10.26, 3.92), (10.24, 3.66))
  arr((10.26, 3.55), (10.54, 3.55))
  box((11.30, 3.55), 0.72, 0.22, [Time Window \ Compression], size: 5.4pt, fill: purple)
  arr((12.02, 3.55), (12.23, 3.55))
  box((12.95, 3.55), 0.70, 0.24, [Transformer \ decoder], size: 5.4pt)
  arr((13.65, 3.55), (13.73, 3.55))
  box((14.55, 3.55), 0.80, 0.22, [Reconstructed \ data], size: 5.4pt, fill: pink)
})
