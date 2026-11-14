// 四足机器人子系统框图（重绘 Figure 5）
//
// 编译后外观：
//   自上而下四层居中的框图。第 1 层紫色圆角框「High-Level Control / & Planning」；
//   第 2 层绿色框「Central Controller / / CPU」；第 3 层左黄「Actuation Subsystem」、
//   中橙「Sensing Subsystem」、右粉「Power Management」三框并列；
//   第 4 层红色框「Mechanical Structure / (Body + Four Legs)」。
//   相邻层之间以双向箭头相连：中轴三条竖直直线（High-Level↔Central、Central↔Sensing、
//   Sensing↔Mechanical）；四条 S 形曲线自中央框、机械框的边出发，向上/向下微鼓，
//   分别接到左右两侧子系统框的顶边与底边，箭头指向框边。
//   全部框为细黑描边圆角矩形，淡彩填充（紫、绿、黄、橙、粉、红），标签居中分行。
//
//   读法：最上方是任务级规划，中间是中央控制器；它汇总感知子系统的信息，向驱动
//   子系统下发指令，并由能源子系统供电，最终作用到机体与四条腿。相邻部件之间
//   都是双向交互（指令下发与状态回传），因此每条连线两端都带箭头。
//
// 坐标约定：画布 1 单位 = 1cm，原点取中轴与最上层框中心；y 向下递减，
//   四层中心等距排列（层距 3.7），左右两列相对中轴偏移 ±7.75。
//
// 字体：原图为衬线体，此处按仓库统一规范改用 Arial / Segoe UI，字号随框宽微调。
//
// 来源：Quadruped Robots: Bridging Mechanical Design, Control, and Applications.
//       Robotics 2025, 14, 57, Figure 5. DOI 10.3390/robotics14050057.

#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

#canvas(length: 1cm, {
  import draw: *

  // 版面基准：框尺寸、四层中心高度、左右列横向偏移
  // 层距 3.7 = 框高 2.2 + 连线 1.5；下文所有坐标都由这四个基准值推出
  let bw = 5.5                          // 框宽
  let bh = 2.2                          // 框高
  let tier = (0, -3.7, -7.4, -11.1)     // 四层中心 y
  let col = 7.75                        // 左右列中心相对中轴的横向偏移

  // 双向箭头统一样式：黑色细线 + 两端实心三角箭头
  let arrow = (
    stroke: 1pt + black,
    mark: (start: "<", end: ">", scale: 1.15, fill: black),
  )

  // 圆角框：给定中心点，换算成两角后画框，并在框内居中排布逐行标签
  let node(c, fill, lines) = {
    let (x, y) = c
    let (hw, hh) = (bw / 2, bh / 2)
    rect((x - hw, y - hh), (x + hw, y + hh),
         radius: 0.22, fill: rgb(fill), stroke: 0.7pt + black)
    content(c, align(center, lines.map(text).join(linebreak())), anchor: "center")
  }

  // S 形双向曲线：a 端落在中间列的框边（切向近水平），b 端落在外侧框
  // （切向近竖直）。中段高度取两端中点并向中间列一侧鼓出 0.45，形成平缓
  // 的平台；起端控制点拉到半跨处，末端控制点只留 8% 跨距，于是曲线先平
  // 后陡，与参考图「贴着中央框横走、再俯冲进外侧框」的走向一致。
  let curve(a, b) = {
    let (ax, ay) = a
    let (bx, by) = b
    let s = if bx > ax { 1 } else { -1 }        // 沿 x 的行进方向
    let dx = calc.abs(bx - ax)                  // 横向跨度
    let up = if ay > by { 1 } else { -1 }       // 鼓向中间列（上鼓 / 下鼓）
    let h = (ay + by) / 2 + 0.45 * up           // 中段平台高度
    bezier(
      a, b,
      (ax + s * 0.5 * dx, h),                   // 起端贴着框边平缓切出
      (bx - s * 0.08 * dx, h),                  // 末端近乎垂直插入框边
      ..arrow,
    )
  }

  // 六个子系统框：中心坐标、填充色、逐行标签
  let nodes = (
    // 第 1 层：任务级规划
    (c: (0, tier.at(0)), fill: "#bfbfff", lines: ("High-Level Control", "& Planning")),
    // 第 2 层：中央控制器
    (c: (0, tier.at(1)), fill: "#bfffbf", lines: ("Central Controller", "/ CPU")),
    // 第 3 层左：驱动
    (c: (-col, tier.at(2)), fill: "#fffacb", lines: ("Actuation Subsystem", "(Motors, Hydraulics, SEAs)")),
    // 第 3 层中：感知
    (c: (0, tier.at(2)), fill: "#ffdfbf", lines: ("Sensing Subsystem", "(Encoders, IMUs, F/T", "Cameras, LiDAR)")),
    // 第 3 层右：能源
    (c: (col, tier.at(2)), fill: "#efbfcf", lines: ("Power Management", "(Batteries, Fuel Cells)")),
    // 第 4 层：机体与四条腿
    (c: (0, tier.at(3)), fill: "#ffbfbf", lines: ("Mechanical Structure", "(Body + Four Legs)")),
  )

  // 逐框绘制：矩形与标签。框填充不透明，因此连线一律在其后绘制，
  // 这样箭头才能压在框边之上而不被填充遮住
  for n in nodes {
    node(n.c, n.fill, n.lines)
  }

  // 七条双向连接：中轴三条竖直直连，两侧四条 S 形曲线
  // 曲线端点落在框边偏内侧，避开中轴直连的箭头
  let links = (
    // 中轴：上层框底边 → 下层框顶边
    (kind: "line", a: (0, tier.at(0) - bh / 2), b: (0, tier.at(1) + bh / 2)),
    (kind: "line", a: (0, tier.at(1) - bh / 2), b: (0, tier.at(2) + bh / 2)),
    (kind: "line", a: (0, tier.at(2) - bh / 2), b: (0, tier.at(3) + bh / 2)),
    // 中央框底边 → 左右子系统顶边（向上鼓）
    (kind: "curve", a: (-2.1, tier.at(1) - bh / 2), b: (-col + 0.7, tier.at(2) + bh / 2)),
    (kind: "curve", a: (2.1, tier.at(1) - bh / 2), b: (col - 0.7, tier.at(2) + bh / 2)),
    // 机械框顶边 → 左右子系统底边（向下鼓）
    (kind: "curve", a: (-1.4, tier.at(3) + bh / 2), b: (-col + 1.4, tier.at(2) - bh / 2)),
    (kind: "curve", a: (1.4, tier.at(3) + bh / 2), b: (col - 1.4, tier.at(2) - bh / 2)),
  )

  // 按 kind 分派：直线或曲线，共用同一箭头样式
  for l in links {
    if l.kind == "line" {
      line(l.a, l.b, ..arrow)
    } else {
      curve(l.a, l.b)
    }
  }
})
