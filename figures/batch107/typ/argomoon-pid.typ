#set page(width: auto, height: auto, margin: 6pt)
#set text(font: ("Arial", "Segoe UI"), size: 10pt)
#import "@preview/cetz:0.4.2": canvas, draw
// 编译效果：ArgoMoon 混合推进 P&ID。左侧黄色 2-Phase R-134a 储罐（内 P/T 椭圆、底部加热锯齿、
// 外接 T 椭圆）依次经 10 微米过滤器、双锯齿调节器、两黄 NCV、加注口三通接 Regulated 罐
// （上下各两阀+漏斗推力器支路）；右侧绿色支路经隔离 NCV、ADN 隔膜罐、冗余双 NCV、第二加注
// 三通与末端 NCV 接 100 mN 喷嘴；八块鼠尾草圆角横幅以楔形三角指向各自目标。
// 来源：Propulsion Technologies for CubeSats: Review. Aerospace 2024, 11(7), 502, Figure 37. DOI 10.3390/aerospace11070502.
#context canvas(length: 1cm, {
  import draw: *
  // 颜色与线型
  let (gray, dark) = (rgb("#808080"), rgb("#595959"))
  let (yellow, green, sage) = (rgb("#ffff00"), rgb("#00b050"), rgb("#b5c99a"))
  let outline = (paint: gray, thickness: 1.2pt)
  let pipe = (paint: gray, thickness: 1.4pt)
  let bold(c, size: 10pt) = text(weight: "bold", fill: dark, size: size, c)
  // 主链高度与各站 x 地标
  let Y = 0
  let (xs, xf, xr, x1, x2, xt1) = (0, 1.7, 2.7, 3.65, 4.45, 4.95)
  let (xt, xi, xa, x3, x4, xt2, x5, xn) = (6.75, 8.5, 10.3, 12.0, 12.8, 13.5, 14.35, 14.95)
  // 锯齿线：加热器与调节器波纹管共用
  let zig(x, y, w) = {
    let pts = ()
    for i in range(7) { pts.push((x - w / 2 + w * i / 6, y + (if calc.odd(i) { .18 } else { 0 }))) }
    line(..pts, stroke: outline)
  }
  // 白色传感器椭圆
  let oval(c, body) = {
    circle(c, radius: (.34, .26), fill: white, stroke: outline)
    content(c, bold(body))
  }
  // 储罐：色圆 + 内 P/T 椭圆 + 加热锯齿 + 下方括线外接 T 椭圆
  let tank(x, r, col, body, sensors) = {
    circle((x, Y), radius: r, fill: col, stroke: outline)
    for (i, s) in sensors.enumerate() {
      oval((x + (i - (sensors.len() - 1) / 2) * .75, Y + r * .62), s)
    }
    content((x, Y - .05), bold(par(leading: .3em, body)))
    zig(x, Y - r * .78, .95)
    for s in (-1, 1) { line((x + s * .5, Y - r + .25), (x + s * .5, Y - r - .3), stroke: outline) }
    oval((x, Y - r - .35), [T])
  }
  // NCV 阀：色圆 + X 交叉
  let valve(x, y, col) = {
    circle((x, y), radius: .3, fill: col, stroke: outline)
    line((x - .21, y - .21), (x + .21, y + .21), stroke: outline)
    line((x - .21, y + .21), (x + .21, y - .21), stroke: outline)
  }
  // 加注口：T 形横杠两端下钩
  let tee(x) = {
    line((x, Y), (x, Y + .9), (x - .4, Y + .9), (x - .4, Y + .65), stroke: outline)
    line((x, Y + .9), (x + .4, Y + .9), (x + .4, Y + .65), stroke: outline)
  }
  // 过滤器：黄矩形 + 竖直栅线
  let filter(x) = {
    rect((x - .35, Y - .22), (x + .35, Y + .22), fill: yellow, stroke: outline)
    for i in range(6) { line((x - .25 + i * .1, Y - .16), (x - .25 + i * .1, Y + .16), stroke: outline) }
  }
  // 调节器：双锯齿 + 两侧括弧 + 顶/底传感器椭圆
  let reg(x) = {
    zig(x, Y + .25, .8)
    zig(x, Y - .45, .8)
    for s in (-1, 1) {
      line((x + s * .5, Y + .2), (x + s * .5, Y + .55), stroke: outline)
      line((x + s * .5, Y - .2), (x + s * .5, Y - .55), stroke: outline)
    }
    arc((x - .35, Y + .7), start: 90deg, stop: 180deg, radius: .15, stroke: outline)
    arc((x + .5, Y + .55), start: 0deg, stop: 90deg, radius: .15, stroke: outline)
    arc((x - .5, Y - .55), start: 180deg, stop: 270deg, radius: .15, stroke: outline)
    arc((x + .35, Y - .7), start: 270deg, stop: 360deg, radius: .15, stroke: outline)
    oval((x, Y + .95), [⊥])
    oval((x, Y - .95), [T])
  }
  // 推力器支路：引线 + 阀 + 漏斗三角，s=±1 控制朝上/朝下
  let thruster(x, s) = {
    line((x, Y + s * 1.25), (x, Y + s * 1.5), stroke: outline)
    valve(x, Y + s * 1.8, yellow)
    line((x - .25, Y + s * 2.6), (x + .25, Y + s * 2.6), (x, Y + s * 2.1), close: true, fill: yellow, stroke: outline)
  }
  // 横幅：圆角矩形尺寸由文本度量，楔形三角由横幅/目标坐标推导
  let banner(body, c, targets) = {
    let txt = text(weight: "bold", size: 8pt, fill: dark, par(leading: .3em, body))
    let sz = measure(txt)
    let hw = sz.width / 1cm / 2 + .2
    let hh = sz.height / 1cm / 2 + .15
    for t in targets {
      let d = (t.at(0) - c.at(0), t.at(1) - c.at(1))
      let k = calc.max(calc.abs(d.at(0)) / hw, calc.abs(d.at(1)) / hh)
      let b = (c.at(0) + d.at(0) / k, c.at(1) + d.at(1) / k)
      line((b.at(0) + .3, b.at(1)), (b.at(0) - .3, b.at(1)), t, close: true, fill: sage, stroke: none)
    }
    rect((c.at(0) - hw, c.at(1) - hh), (c.at(0) + hw, c.at(1) + hh), radius: .12, fill: sage, stroke: none)
    content(c, txt)
  }
  // 横幅表 (文本, 横幅中心, 目标点列)：循环画楔形与圆角横幅，先画以便组件/标签压在其上
  let banners = (
    ([R134A FILL PORT W/CAP], (xt1, 3.65), ((xt1, .95),)),
    ([LMP-103S ISOLATION VALVE], (8.9, 3.0), ((xi, .32),)),
    ([DIAPHRAGM TANK], (10.4, 2.2), ((xa, 1.25),)),
    ([LMP-103S FILL PORT W/CAP], (13.8, 3.6), ((xt2, .95),)),
    ([10 MICRON FILTER], (1.6, -2.1), ((xf, -.22),)),
    ([25 MN COLD GAS THRUSTERS, #linebreak() (4) PLACES], (6.75, -3.9), ((xt - .7, -2.6), (xt + .7, -2.6))),
    ([REDUNDANT LMP-103S #linebreak() ISOLATION VALVE], (12.4, -2.5), ((x3, -.32), (x4, -.32))),
    ([100 MN ADN THRUSTER], (14.6, -3.5), ((xn + .25, -.1),)),
  )
  for b in banners { banner(..b) }
  // 主链站表 (x, 类型, 颜色, 半宽, 标签)：单循环画组件与连接管
  let stations = (
    (xs, "tank", yellow, 1.1, ([2-Phase #linebreak() R-134a], ("P", "T"))),
    (xf, "filter", yellow, .35, none),
    (xr, "reg", gray, .5, none),
    (x1, "ncv", yellow, .3, [NCV]),
    (x2, "ncv", yellow, .3, [NCV]),
    (xt1, "tee", gray, 0, none),
    (xt, "tank", yellow, 1.25, ([Regulated #linebreak() R-134a], ("P",))),
    (xi, "ncv", green, .3, [NCV]),
    (xa, "tank", green, 1.25, ([ADN #linebreak() Storage], ())),
    (x3, "ncv", green, .3, [NCV]),
    (x4, "ncv", green, .3, [NCV]),
    (xt2, "tee", gray, 0, none),
    (x5, "ncv", green, .3, [NCV]),
    (xn, "nozzle", green, .25, none),
  )
  let prev = none
  for st in stations {
    let (x, kind, col, r, lab) = st
    if prev != none { line((prev.at(0) + prev.at(1), Y), (x - r, Y), stroke: pipe) }
    if kind == "tank" { tank(x, r, col, lab.at(0), lab.at(1)) }
    if kind == "filter" { filter(x) }
    if kind == "reg" { reg(x) }
    if kind == "ncv" { valve(x, Y, col); content((x, Y - .62), bold(lab, size: 9pt)) }
    if kind == "tee" { tee(x) }
    if kind == "nozzle" { line((x - r, Y), (x + r, Y + .25), (x + r, Y - .25), close: true, fill: col, stroke: outline) }
    prev = (x, r)
  }
  // Regulated 罐四推力器支路：两上两下
  for (dx, s) in ((-.7, 1), (.7, 1), (-.7, -1), (.7, -1)) { thruster(xt + dx, s) }
})
