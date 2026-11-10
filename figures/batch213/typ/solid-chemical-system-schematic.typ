#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw

// 固体化学推进系统组成示意图（重绘自 Aerospace 2024, 11(7), 502, Fig.13；DOI 10.3390/aerospace11070502）
// 编译外观：灰色储箱/燃烧室平涂、深蓝描边壳体、黑色流道与细箭头，干净线稿风格
#canvas({
  import draw: *

  // 配色与地标坐标
  let gy = rgb("#d9d9d9")            // 部件灰
  let nb = rgb("#3d5a78")            // 燃烧室/点火器描边
  let lw = 1.2pt                     // 轮廓线宽
  let yl = 3.62                      // 主流道高度
  let cx0 = 10.5                     // 燃烧室左沿
  let cx1 = 18.75                    // 燃烧室右沿
  let cy0 = 2.46                     // 燃烧室下沿
  let cy1 = 5.30                     // 燃烧室上沿
  let cyc = 3.88                     // 燃烧室/喷管轴线
  let tx = 20.05                     // 喷管喉部横坐标
  let ex = 22.55                     // 喷管出口横坐标
  let tTop = 4.30                    // 喉部上沿
  let tBot = 3.46                    // 喉部下沿（关于轴线对称）
  let eTop = 5.10                    // 出口上沿
  let eBot = 2.66                    // 出口下沿（关于轴线对称）
  let ly = 6.30                      // 顶部标注基线

  // 三次贝塞尔采样助手：返回折线点列
  let bez-pts(p0, p1, p2, p3, n: 24) = {
    let pts = ()
    for i in range(n + 1) {
      let t = i / n
      let u = 1 - t
      pts.push((
        u * u * u * p0.at(0) + 3 * u * u * t * p1.at(0)
          + 3 * u * t * t * p2.at(0) + t * t * t * p3.at(0),
        u * u * u * p0.at(1) + 3 * u * u * t * p1.at(1)
          + 3 * u * t * t * p2.at(1) + t * t * t * p3.at(1),
      ))
    }
    pts
  }

  // 氧化剂储箱
  rect((0.5, 1.75), (5.25, 6.0), radius: 0.5, fill: gy,
       stroke: (paint: black, thickness: 1.5pt))
  content((2.875, 3.875), [Oxidizer\ Tank], align: center)

  // 燃烧室壳体
  rect((cx0, cy0), (cx1, cy1), radius: 0.35, fill: gy,
       stroke: (paint: nb, thickness: 1.4pt))

  // 主输送管路（储箱 → 阀门 → 喷射器 → 点火器）
  line((5.25, yl), (10.0, yl), stroke: (paint: black, thickness: lw))

  // 阀门 V 与喷射器 I
  circle((6.75, yl), radius: 0.55, fill: white,
         stroke: (paint: black, thickness: 1.1pt))
  content((6.75, yl), [V])
  circle((9.4, yl), radius: 0.5, fill: white,
         stroke: (paint: black, thickness: 1.0pt))
  content((9.4, yl), [I])

  // 点火源小舱（叠放于燃烧室左端）
  rect((9.95, 2.90), (10.92, 4.86), radius: 0.2, fill: white,
       stroke: (paint: nb, thickness: 1.1pt))

  // 供给系统括号与标签
  line((5.75, 3.05), (5.75, 2.75), (9.75, 2.75), (9.75, 3.05),
       stroke: (thickness: 0.8pt))
  content((8.15, 2.42), [Feed System], align: center)

  // 顶部文字标注
  content((6.50, ly), [Flow\ Control], align: center)
  content((9.15, ly), [Injector], align: center)
  content((11.85, ly), [Ignition\ Source], align: center)
  content((17.30, ly), [Solid Propellant], align: center)
  content((21.30, ly), [Nozzle], align: center)

  // 各部件指引箭头
  line((5.85, 5.90), (6.35, 4.32), stroke: (thickness: 0.8pt), mark: (end: "stealth"))
  line((8.95, 5.90), (9.32, 4.28), stroke: (thickness: 0.8pt), mark: (end: "stealth"))
  line((11.50, 5.88), (11.02, 4.92), stroke: (thickness: 0.8pt), mark: (end: "stealth"))
  line((16.30, 5.92), (11.70, 5.02), stroke: (thickness: 0.8pt), mark: (end: "stealth"))
  line((17.65, 5.92), (18.35, 2.78), stroke: (thickness: 0.8pt), mark: (end: "stealth"))

  // 燃烧产物文字与室内虚线流动
  content((13.90, 4.52), [Burn'd Propellant], align: center)
  line((11.35, 3.90), (15.60, 3.90), stroke: (thickness: 1.1pt, dash: "dashed"),
       mark: (end: "stealth"))

  // 喷管上壁：收敛段（室角 → 喉部）
  line(..bez-pts((cx1, cy1 + 0.02), (19.30, 5.20), (19.62, 4.78), (tx, tTop)),
       stroke: (paint: black, thickness: lw))
  // 喷管上壁：扩张段（喉部 → 出口），末端保持上扬直线趋势
  line(..bez-pts((tx, tTop), (tx + 0.75, tTop + 0.06),
                 (ex - 1.00, eTop - 0.18), (ex, eTop)),
       stroke: (paint: black, thickness: lw))

  // 喷管下壁：与上壁关于轴线镜像
  line(..bez-pts((cx1, cy0 - 0.02), (19.30, 2.56), (19.62, 2.98), (tx, tBot)),
       stroke: (paint: black, thickness: lw))
  line(..bez-pts((tx, tBot), (tx + 0.75, tBot - 0.06),
                 (ex - 1.00, eBot + 0.18), (ex, eBot)),
       stroke: (paint: black, thickness: lw))

  // 喷管宽度标注括号（横线在上、两端下折）
  line((ex - 0.35, 5.52), (ex - 0.35, 5.74), (ex + 0.35, 5.74), (ex + 0.35, 5.52),
       stroke: (thickness: 0.7pt))

  // 燃气排出（穿过喷管，虚线箭头 + 双行标签）
  line((tx, cyc), (26.90, cyc), stroke: (thickness: 1.1pt, dash: "dashed"),
       mark: (end: "stealth"))
  content((25.00, 4.34), [Gaseous Propellant], align: center)
  content((25.40, 3.38), [Exhaust], align: center)
})
