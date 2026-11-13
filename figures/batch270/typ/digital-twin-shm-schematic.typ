#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 蓝色结构监测面板与绿色数字孪生面板，双风机线稿、传感数据分支及右向分析流程。
// 来源：Sensors 2025, 25, 1424, Figure 16，Functional schematic of the concept of DT in SHM. DOI: 10.3390/s25051424
#canvas({
  import draw: *
  let blue = rgb("#3f58a5")
  let wire = rgb("#507fc2")
  let pale = rgb("#bfd9ed")
  let green = rgb("#e3f0d8")
  let yellow = rgb("#fff2cb")
  let midblue = rgb("#9ec3e3")
  let gray = rgb("#c8c8c8")
  let edge = (paint: blue, thickness: 1.6pt)
  let fine = (paint: wire, thickness: 0.8pt)
  let label(p, body, size: 11pt) = {
    content(p, text(size: size, weight: "bold", body), anchor: "center", frame: none)
  }
  let arrow(a, b) = {
    line(a, b, stroke: fine,
      mark: (end: "stealth", scale: 0.65, fill: wire))
  }
  let ring(p, r, body, fill-color: white, border: blue) = {
    circle(p, radius: r, fill: fill-color,
      stroke: (paint: border, thickness: 1.5pt))
    label(p, body)
  }
  let reality = (0.3, 0.9)
  let twin = (7.4, 11.6)
  let historic = (9.8, 7.4)
  let live = (9.8, 4.2)
  let analytics = (15.75, 5.75)
  let assessment = (24.0, 5.75)

  // 面板轮廓：现实孪生采用文档式波浪下缘。
  let bottom = ()
  for i in range(41) {
    let x = 11.9 - i * 11.6 / 40
    let y = 1.1 + 0.96 * calc.sin((x - 6.1) / 11.6 * 360deg)
    bottom.push((x, y))
  }
  line((0.3, 10.7), (11.9, 10.7), ..bottom, (0.3, 10.7),
    fill: pale, stroke: edge)
  rect(twin, (15.9, 16.95), fill: green, stroke: edge)
  rect((2.05, 11.85), (4.9, 13.75), fill: pale, stroke: edge)

  // 交互映射的共享支路与数字模型输出；连接先画，节点随后覆盖。
  line((4.9, 12.8), (6.05, 12.8), stroke: fine)
  line((6.05, 10.7), (6.05, 14.25), stroke: fine)
  arrow((6.05, 14.25), (7.4, 14.25))
  arrow((11.52, 14.25), (12.02, 14.25))
  line((13.75, 12.3), (13.75, 5.75), stroke: fine)

  // 风机扫描至两类传感数据，再合流至数据分析。
  line((6.4, 5.8), (7.7, 5.8), stroke: fine)
  line((7.7, 4.2), (7.7, 7.4), stroke: fine)
  line((7.7, 7.4), (8.4, 7.4), stroke: fine)
  line((7.7, 4.2), (8.4, 4.2), stroke: fine)
  line((11.2, 7.4), (11.55, 7.4), (11.55, 4.2),
    (11.2, 4.2), stroke: fine)
  arrow((11.55, 5.75), (14.35, 5.75))
  arrow((17.15, 5.75), (17.65, 5.75))
  arrow((22.0, 5.75), (22.5, 5.75))

  // 共享风机助手：平涂塔筒、机舱、三片带中脊的叶片及轮毂。
  let turbine(base, s, digital: false) = {
    let pt(x, y) = (base.at(0) + s*x, base.at(1) + s*y)
    let steel = if digital { rgb("#378ac0") } else { rgb("#e6edf0") }
    let blade = if digital { rgb("#efcb39") } else { rgb("#f5f3e7") }
    let outline = (paint: rgb("#526573"), thickness: 0.7pt)
    line(pt(-0.22, 0), pt(0.22, 0), pt(0.12, 3.15),
      pt(-0.12, 3.15), close: true, fill: steel, stroke: outline)
    line(pt(-0.25, 3.02), pt(0.6, 3.18), pt(0.6, 3.44),
      pt(0.02, 3.55), pt(-0.25, 3.35), close: true,
      fill: if digital { rgb("#d68179") } else { rgb("#d6e1e8") },
      stroke: outline)
    for angle in (55deg, 175deg, 295deg) {
      let rotor(x, y) = pt(
        x * calc.cos(angle) - y * calc.sin(angle),
        3.22 + x * calc.sin(angle) + y * calc.cos(angle),
      )
      line(rotor(0.1, -0.08), rotor(0.8, -0.18),
        rotor(1.95, 0), rotor(0.9, 0.14), rotor(0.1, 0.08),
        close: true, fill: blade, stroke: outline)
      line(rotor(0.22, 0), rotor(1.95, 0), stroke: outline)
    }
    circle(pt(0, 3.22), radius: 0.17*s,
      fill: steel, stroke: outline)
    line(pt(-0.48, 0), pt(0.48, 0), stroke: outline)
  }

  // 数字孪生标题、解析风机模型与更新模型椭圆。
  label((11.65, 16.45), [Digital Twin], size: 14pt)
  rect((7.7, 12.72), (11.52, 16.0), fill: white,
    stroke: (paint: gray, thickness: 0.4pt))
  turbine((9.58, 12.78), 0.59, digital: true)
  label((9.6, 12.12), [Analytic\ Model], size: 11pt)
  circle((13.75, 14.25), radius: (1.73, 1.95),
    fill: white, stroke: edge)
  label((13.75, 14.25), [Updating\ Digital Model])
  label((3.475, 12.8), [Interactive\ mapping])

  // 现实孪生标题及扫描风机：照片改为完整白底矢量线稿。
  label((6.1, 9.8), [Structural Health Monitoring\ (Reality Twin)], size: 13pt)
  rect((1.6, 2.8), (6.4, 8.8), fill: white,
    stroke: (paint: gray, thickness: 0.4pt))
  turbine((4.05, 3.02), 1.14)
  label((4.0, 2.45), [Scanning of real structure], size: 11pt)

  // 两类传感数据节点保留原图逐字标签与灰色边框。
  for (p, body) in (
    (historic, [Historical\ Sensor\ Data]),
    (live, [Real-time\ Sensor\ Data]),
  ) {
    ring(p, 1.4, body, border: gray)
  }

  // 数据分析、特征处理和状态评估，保持从左到右的流程。
  ring(analytics, 1.4, [Data\ Analytics], fill-color: midblue)
  rect((17.65, 3.85), (22.0, 7.65), fill: yellow, stroke: edge)
  label((19.825, 5.75), [
    Data Processing\
    Feature Extraction\
    Pattern Recognition\
    Anomaly Detection
  ], size: 11pt)
  ring(assessment, 1.5, [Condition\ Assessment], fill-color: midblue)
})
