#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// ============================================================
// 逆运动学迭代求解流程图（重绘）
// 编译后外观：绿色粗描边、白底、无阴影的纯线稿流程图。左列自上而下为
// "Initial angle θ"小框 → 误差说明大框（四行说明＋居中公式）→ 菱形收敛
// 判断 ‖T(θ)‖<ε → "Terminate algorithm, solution found"终止框；菱形右顶点
// 横箭头指向右中框"Calculate joint angle changes"，其上方箭头进入右上框
// "Update joint angle values"，右上框再以横箭头向左回到大框，构成闭环。
// 来源：Unlocking the Potential of Cable-Driven Continuum Robots: A Comprehensive
// Review and Future Directions. Actuators 2024, 13, 52, Figure 16.
// DOI 10.3390/act13020052.
// ============================================================
#canvas(length: 1cm, {
  import draw: *
  // 统一配色：绿色描边、白色填充
  let gc = rgb("#3f9e3f")
  let st = (paint: gc, thickness: 1.4pt)   // 框线
  let at = (paint: gc, thickness: 1.6pt)   // 箭头线

  // 节点表：c 中心 / w,h 尺寸 / tw 文字栏宽 / kind 形状 / body 内容
  let nodes = (
    a: (c: (5.30, -0.95), w: 3.70, h: 1.05, tw: 3.30, kind: "box", body: [
      Initial angle $theta$
    ]),
    b: (c: (5.30, -4.55), w: 9.75, h: 3.60, tw: 8.05, al: "l", kind: "box", body: [
      #set par(justify: true)
      #set text(hyphenate: false)
      Difference between the configuration calculated $T(theta^((i)))$ with the forward
      kinematics and the target configuration, called error ($arrow(e)^((i))$).
      #v(4pt)
      $ arrow(e)^((i)) = J((theta)^((i))) Delta theta^((i)) $
    ]),
    d: (c: (5.30, -9.55), w: 8.10, h: 3.90, tw: 5.20, kind: "diamond", body: [
      $norm(T(theta^((i)))) < epsilon$
    ]),
    e: (c: (5.30, -13.40), w: 7.55, h: 1.50, tw: 7.10, kind: "box", body: [
      Terminate algorithm,\ solution found
    ]),
    f: (c: (15.75, -9.45), w: 7.15, h: 2.35, tw: 6.75, kind: "box", body: [
      Calculate joint angle changes
      #v(4pt)
      $ arrow(e)^((i)) = J((theta)^((i))) Delta theta^((i)) $
    ]),
    g: (c: (15.75, -4.60), w: 7.25, h: 2.35, tw: 6.85, kind: "box", body: [
      Update joint angle values
      #v(4pt)
      $ theta = theta + J^(-1)((theta)^((i))) arrow(e)^((i)) . $
    ]),
  )

  // 地标：取节点 t/b/l/r 四边中点，供连线表派生端点
  let lm(n, s) = {
    let (x, y) = n.c
    if s == "t" { (x, y + n.h / 2) }
    else if s == "b" { (x, y - n.h / 2) }
    else if s == "l" { (x - n.w / 2, y) }
    else { (x + n.w / 2, y) }
  }
  // 矩形节点：两角点画框 + 文字块（al 控制左对齐/居中）
  let boxn(n) = {
    let (x, y) = n.c
    let al = if n.at("al", default: "c") == "l" { left } else { center }
    rect((x - n.w / 2, y - n.h / 2), (x + n.w / 2, y + n.h / 2), stroke: st, fill: white)
    content(n.c, block(width: n.tw * 1cm, align(al, n.body)))
  }
  // 菱形节点：四顶点闭合折线 + 居中文字
  let diamond(n) = {
    let (x, y) = n.c
    line((x - n.w / 2, y), (x, y + n.h / 2), (x + n.w / 2, y), (x, y - n.h / 2),
      close: true, stroke: st, fill: white)
    content(n.c, block(width: n.tw * 1cm, align(center, n.body)))
  }
  // 箭头：绿色实线，末端 stealth 实心三角
  let arw(p, q) = line(p, q, stroke: at, mark: (end: "stealth", fill: gc, scale: 1.0))

  // 按表绘制全部节点
  for (_, n) in nodes {
    if n.kind == "diamond" { diamond(n) } else { boxn(n) }
  }
  // 连线表：起点节点/边 → 终点节点/边（下行、右行、上行、左行闭环）
  let edges = (
    ("a", "b", "b", "t"),
    ("b", "b", "d", "t"),
    ("d", "b", "e", "t"),
    ("d", "r", "f", "l"),
    ("f", "t", "g", "b"),
    ("g", "l", "b", "r"),
  )
  for (p, ps, q, qs) in edges {
    arw(lm(nodes.at(p), ps), lm(nodes.at(q), qs))
  }
})
