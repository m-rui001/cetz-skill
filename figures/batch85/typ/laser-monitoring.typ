// ============================================================
// 激光增材制造的同轴熔池监测光路图（coaxial melt-pool monitoring）
//
// 源图：Process monitoring and machine learning for defect detection in
//       laser-based metal additive manufacturing
//       (Journal of Intelligent Manufacturing, 2024) Fig. 2
//       "Coaxial monitoring of the melt pool utilising visible light"
//
// 版面：(a) 左半部为同轴监测光路工程图；(b) 右下角为熔池可见光图像示意
//       （源图 (b) 是灰度照片，这里改为浅灰光晕圆 + 十字准线 + 边框的线稿插图）
//
// 光路（按光线传播方向）：
//   laser ──↓──> 二向色镜（反射激光波长）──←──> 扫描振镜 ──↓──> 扫描透镜 ──↓──> 熔池/工件
//   熔池可见光 ──↑──> 扫描透镜 ──↑──> 扫描振镜 ──→──> 二向色镜（透射观测波长）
//             ──→──> 半透半反镜 ──↑──> 光阑/滤光片 ──↑──> camera
//                              └──→──> diode
//
// 几何约定：所有 45° 镜面均为 "/" 朝向（左下→右上）。按真实反射关系，
//   "/" 镜把 ↓ 光束折向 ←、把 ← 光束折向 ↓、把 ↑ 光束折向 →、把 → 光束折向 ↑。
// 激光与可见光共轴反向传播，共路段各偏光轴 GAP，避免实线与虚线完全重叠。
// ============================================================
#set page(width: auto, height: auto, margin: 6pt)
#import "@preview/cetz:0.4.2": canvas, draw
#set text(font: ("Segoe UI", "Arial"), size: 8pt)

#canvas({
  import draw: *

  // ==================== 配色与线宽 ====================
  let INK = rgb("#1b1b1b")       // 元件轮廓与激光光束（实线）
  let VIS = rgb("#5f666b")       // 熔池可见光（虚线）
  let HINT = rgb("#8b9195")      // 剖面线、引线、镜架细节
  let RETICLE = rgb("#9b9b9b")   // (b) 十字准线

  let LW = 0.70pt                // 元件主轮廓
  let LW-THIN = 0.65pt           // 元件次级轮廓（镜面副线、壳体）
  let LW-HINT = 0.60pt           // 提示线

  let pen(t: LW, c: INK) = (paint: c, thickness: t, cap: "round")

  // ==================== 版面常量（光轴位置） ====================
  let AXIS-X = 3.20       // 振镜—扫描透镜—熔池 的竖直光轴
  let DICH-X = 8.40       // 二向色镜中心的 x
  let SPLIT-X = 12.40     // 半透半反镜中心的 x
  let AXIS-Y = 6.60       // 水平主光轴（两面 45° 镜中心的连线）
  let GAP = 0.17          // 共轴段：两束光各自偏离光轴的距离
  let SURF-Y = 0.45       // 工件上表面高度
  let LENS-Y = 2.80       // 扫描透镜光心高度
  let MIRROR-LEN = 2.00   // 45° 镜面长度
  let LASER-YB = 9.60     // 激光器出光面
  let LASER-YT = 11.50    // 激光器顶面
  let CAM-YB = 9.90       // 相机进光面
  let CAM-YT = 11.80      // 相机顶面
  let APERT-Y = 8.70      // 光阑/滤光片高度
  let DIODE-X = 13.80     // 二极管左端面
  let DIODE-W = 1.85
  let DIODE-H = 1.40

  // ==================== 通用助手 ====================

  // 45° 镜面端点：中心 (cx, cy)、长度 len，沿 "/" 方向（左下 → 右上）
  let mirror-pts(cx, cy, len: MIRROR-LEN) = {
    let h = len / 2 / calc.sqrt(2)
    ((cx - h, cy - h), (cx + h, cy + h))
  }

  // 光线：points 为折点数组；kind 取 "laser"（实线，激光）或 "visible"（虚线，可见光）。
  // arrows 为 (段序号, 段内相对位置) 数组，缺省时每段中点放箭头；
  // 箭头单独成短段绘制，因此可以精确避开折点上的光学元件。
  let beam(points, kind, arrows: ()) = {
    let spec = if kind == "laser" {
      (paint: INK, thickness: 0.75pt, cap: "round")
    } else {
      (paint: VIS, thickness: 0.72pt, cap: "round", dash: (2.4pt, 1.7pt))
    }
    line(..points, stroke: spec)
    let arrow-list = if arrows.len() == 0 {
      range(0, points.len() - 1).map(i => (i, 0.5))
    } else {
      arrows
    }
    for (seg, pos) in arrow-list {
      let a = points.at(seg)
      let b = points.at(seg + 1)
      let lerp(t) = (
        a.at(0) + (b.at(0) - a.at(0)) * t,
        a.at(1) + (b.at(1) - a.at(1)) * t,
      )
      line(lerp(pos - 0.06), lerp(pos + 0.06), stroke: spec,
        mark: (end: ">", fill: spec.paint, scale: 0.72))
    }
  }

  // 标签：统一字号
  let lbl(pos, body, anchor: "center", size: 7.6pt) = content(
    pos, anchor: anchor, text(size: size, body),
  )

  // ==================== 光学元件（每件一个命名函数） ====================

  // 激光器：矩形机身，向下出光（源图 "laser" 方框）
  let laser(cx, yb, yt, w: 2.20) = {
    rect((cx - w / 2, yb), (cx + w / 2, yt), fill: white, stroke: pen())
    content((cx, (yb + yt) / 2), text(size: 8.4pt, [laser]))
  }

  // 扫描振镜：45° 反射镜 + 振镜壳体；壳体右侧与底面留出光线进出窗口
  let galvo-mirror(cx, cy, len: MIRROR-LEN, port: 0.30) = {
    let (p0, p1) = mirror-pts(cx, cy, len: len)
    let x0 = cx - 1.45      // 壳体左壁
    let x1 = cx + 1.45      // 壳体右壁
    let y0 = cy - 1.60      // 壳体底
    let y1 = cy + 1.60      // 壳体顶
    // 左壁、顶壁
    line((x0, y0), (x0, y1), (x1, y1), stroke: pen(t: LW-THIN))
    // 右壁：在水平光束高度留出窗口
    line((x1, y1), (x1, cy + 0.36), stroke: pen(t: LW-THIN))
    line((x1, y0), (x1, cy - 0.36), stroke: pen(t: LW-THIN))
    // 底壁：在竖直光束两侧留出出光窗口
    line((x0, y0), (cx - port, y0), stroke: pen(t: LW-THIN))
    line((cx + port, y0), (x1, y0), stroke: pen(t: LW-THIN))
    line(p0, p1, stroke: pen())
    circle((cx - 0.05, cy - 0.05), radius: 0.055, fill: INK, stroke: none)
  }

  // 扫描透镜：双凸透镜轮廓（源图透镜符号），竖直通光
  let scan-lens(cx, cy, hh: 0.82, b: 0.62) = {
    bezier((cx, cy - hh), (cx, cy + hh), (cx - b, cy - hh * 0.52), (cx - b, cy + hh * 0.52),
      stroke: pen())
    bezier((cx, cy + hh), (cx, cy - hh), (cx + b, cy + hh * 0.52), (cx + b, cy - hh * 0.52),
      stroke: pen())
  }

  // 二向色镜：45° 镀膜平板（双线示板厚），反射激光波长、透射观测波长
  let dichroic(cx, cy, len: MIRROR-LEN) = {
    let (p0, p1) = mirror-pts(cx, cy, len: len)
    let d = 0.13 / calc.sqrt(2)
    let q0 = (p0.at(0) + d, p0.at(1) - d)
    let q1 = (p1.at(0) + d, p1.at(1) - d)
    line(p0, p1, stroke: pen())
    line(q0, q1, stroke: pen(t: LW-THIN))
    line(p0, q0, stroke: pen(t: LW-THIN))
    line(p1, q1, stroke: pen(t: LW-THIN))
  }

  // 半透半反镜：45° 镜面，下半实线 + 上半虚线，示意"半透半反"
  let beam-splitter(cx, cy, len: MIRROR-LEN) = {
    let (p0, p1) = mirror-pts(cx, cy, len: len)
    let mid = ((p0.at(0) + p1.at(0)) / 2, (p0.at(1) + p1.at(1)) / 2)
    line(p0, mid, stroke: pen())
    line(mid, p1, stroke: (paint: INK, thickness: LW, cap: "round", dash: (1.8pt, 1.4pt)))
  }

  // 相机：矩形机身（源图 "camera" 方框），光从下方进入
  let camera(cx, yb, yt, w: 2.40) = {
    rect((cx - w / 2, yb), (cx + w / 2, yt), fill: white, stroke: pen())
    content((cx, (yb + yt) / 2), text(size: 8.4pt, [camera]))
  }

  // 二极管探测器：矩形机身（源图 "diode" 方框），光从左侧进入
  let diode(x0, cy, w: DIODE-W, h: DIODE-H) = {
    rect((x0, cy - h / 2), (x0 + w, cy + h / 2), fill: white, stroke: pen())
    content((x0 + w / 2, cy), text(size: 8.4pt, [diode]))
  }

  // 光阑 / 滤光片：垂直于光轴的挡片，中央开孔让熔池可见光通过
  let aperture-filter(cx, cy, w: 0.66) = {
    line((cx - w, cy), (cx - 0.13, cy), stroke: pen())
    line((cx + 0.13, cy), (cx + w, cy), stroke: pen())
    line((cx - w, cy + 0.15), (cx - w, cy - 0.15), stroke: pen(t: LW-HINT, c: HINT))
    line((cx + w, cy + 0.15), (cx + w, cy - 0.15), stroke: pen(t: LW-HINT, c: HINT))
  }

  // 熔池 / 工件：基板剖面（下缘剖面线）+ 熔池凹坑（两层深度线）+ 熔池飞溅射线
  let workpiece(cx, top, half-w: 1.55, thick: 0.42) = {
    let bot = top - thick
    rect((cx - half-w, bot), (cx + half-w, top), fill: white, stroke: pen())
    for k in range(0, 7) {
      let x = cx - half-w + 0.24 + k * 0.42
      line((x, bot), (x - 0.18, bot - 0.22), stroke: pen(t: LW-HINT, c: HINT))
    }
    // 熔池：向下凹的浅坑（熔池外轮廓）与更深的窄坑（熔池内轮廓）
    bezier((cx - 0.48, top), (cx + 0.48, top), (cx - 0.24, top - 0.21), (cx + 0.24, top - 0.21),
      stroke: pen())
    bezier((cx - 0.27, top), (cx + 0.27, top), (cx - 0.13, top - 0.34), (cx + 0.13, top - 0.34),
      stroke: pen(t: LW-THIN, c: HINT))
    // 熔池飞溅 / 辉光短射线（避开光束通道，向左右两侧散开）
    for a in (150deg, 175deg, 5deg, 30deg) {
      let r0 = 0.54
      let r1 = 0.80
      line(
        (cx + r0 * calc.cos(a), top + 0.06 + r0 * calc.sin(a)),
        (cx + r1 * calc.cos(a), top + 0.06 + r1 * calc.sin(a)),
        stroke: pen(t: LW-HINT, c: HINT),
      )
    }
  }

  // (b) 熔池可见光图像：浅灰光晕圆 + 十字准线 + 边框的示意插图（源图为灰度照片）
  let melt-pool-view(cx, cy, half: 1.95) = {
    rect((cx - half, cy - half), (cx + half, cy + half), fill: white, stroke: pen())
    // 光晕：五层同心浅灰圆，模拟熔池亮斑向外的灰度衰减
    for (k, tone) in (
      (0.94, "#f8f8f8"),
      (0.76, "#f1f1f1"),
      (0.58, "#e8e8e8"),
      (0.40, "#dedede"),
      (0.24, "#d1d1d1"),
    ) {
      circle((cx, cy), radius: half * k, fill: rgb(tone), stroke: none)
    }
    // 十字准线 + 四角刻线
    let reticle = (paint: RETICLE, thickness: LW-HINT, cap: "round", dash: (2.0pt, 1.5pt))
    line((cx - half, cy), (cx + half, cy), stroke: reticle)
    line((cx, cy - half), (cx, cy + half), stroke: reticle)
    for (sx, sy) in ((-1, -1), (1, -1), (-1, 1), (1, 1)) {
      line(
        (cx + sx * half, cy + sy * half * 0.70),
        (cx + sx * half * 0.72, cy + sy * half * 0.70),
        stroke: pen(t: LW-HINT, c: HINT),
      )
    }
    lbl((cx, cy - half - 0.30), [melt pool (visible light)], size: 7.8pt)
  }

  // ==================== 元件布置 ====================

  // 工件：基板 + 熔池（源图底部熔池，激光落点）
  workpiece(AXIS-X, SURF-Y)
  lbl((AXIS-X, SURF-Y - 1.15), [melt pool], size: 7.8pt)

  // 扫描透镜：把激光聚焦到熔池，同时收集熔池发出的可见光
  scan-lens(AXIS-X, LENS-Y)
  lbl((3.82, LENS-Y), [scan lens], anchor: "west", size: 7.8pt)

  // 扫描振镜：45° 反射镜，把激光折向下方、把回光折向右侧
  galvo-mirror(AXIS-X, AXIS-Y)
  lbl((AXIS-X, AXIS-Y + 1.86), [scanner mirror], size: 7.8pt)

  // 二向色镜：反射激光波长、透射观测波长（标签用引线指向镜面下缘）
  dichroic(DICH-X, AXIS-Y)
  line((7.72, 4.78), (7.70, 5.80), stroke: pen(t: LW-HINT, c: HINT))
  lbl((7.75, AXIS-Y - 1.98), [mirror for laser wavelength])
  lbl((7.75, AXIS-Y - 2.26), [transmitting observation wavelength])

  // 半透半反镜：部分可见光折向相机，其余透射到二极管（标签用引线指向镜面下缘）
  beam-splitter(SPLIT-X, AXIS-Y)
  line((11.95, 5.44), (11.72, 5.86), stroke: pen(t: LW-HINT, c: HINT))
  lbl((11.95, AXIS-Y - 1.26), [semi-transparent])
  lbl((11.95, AXIS-Y - 1.54), [mirror])

  // 激光器：产生加工激光，垂直向下
  laser(DICH-X + GAP, LASER-YB, LASER-YT)

  // 相机：采集熔池可见光图像，垂直向上接收
  camera(SPLIT-X - GAP, CAM-YB, CAM-YT)

  // 二极管：可见光探测器，接收半透半反镜的透射光
  diode(DIODE-X, AXIS-Y - GAP)

  // 光阑 / 滤光片：滤除激光波长等杂光，只让观测波长进相机
  aperture-filter(SPLIT-X - GAP, APERT-Y)
  lbl((SPLIT-X - GAP + 0.82, APERT-Y), [aperture / filter], anchor: "west", size: 7.2pt)

  // ==================== 光路 ====================

  // 激光光束（实线）：laser ↓ 二向色镜 ← 扫描振镜 ↓ 扫描透镜 ↓ 熔池
  beam(
    (
      (DICH-X + GAP, LASER-YB),
      (DICH-X + GAP, AXIS-Y + GAP),
      (AXIS-X + GAP, AXIS-Y + GAP),
      (AXIS-X + GAP, SURF-Y),
    ),
    "laser",
    arrows: ((0, 0.62), (1, 0.52), (2, 0.30)),
  )

  // 可见光光路（虚线）：熔池 ↑ 扫描透镜 ↑ 扫描振镜 → 二向色镜（透射）→ 半透半反镜 ↑ 相机
  beam(
    (
      (AXIS-X - GAP, SURF-Y),
      (AXIS-X - GAP, AXIS-Y - GAP),
      (SPLIT-X - GAP, AXIS-Y - GAP),
      (SPLIT-X - GAP, CAM-YB),
    ),
    "visible",
    arrows: ((0, 0.20), (1, 0.36), (2, 0.33)),
  )

  // 可见光支路（虚线）：半透半反镜透射 → 二极管
  beam(
    ((SPLIT-X - GAP, AXIS-Y - GAP), (DIODE-X, AXIS-Y - GAP)),
    "visible",
    arrows: ((0, 0.45),),
  )

  // ==================== 图例与面板编号 ====================
  line((5.05, 9.00), (5.85, 9.00), stroke: (paint: INK, thickness: 0.75pt, cap: "round"))
  lbl((5.95, 9.00), [laser beam], anchor: "west", size: 7.2pt)
  line((5.05, 8.55), (5.85, 8.55),
    stroke: (paint: VIS, thickness: 0.72pt, cap: "round", dash: (2.4pt, 1.7pt)))
  lbl((5.95, 8.55), [visible light], anchor: "west", size: 7.2pt)

  content((0.55, 11.95), anchor: "west", text(size: 9.0pt, [(a)]))
  content((11.38, 4.30), anchor: "east", text(size: 9.0pt, [(b)]))

  // (b) 熔池可见光图像示意插图
  melt-pool-view(13.50, 2.35, half: 1.95)
})
