# batch43 结果

来源：`[Guillemin, Pollack] Differential Topology (1974)`，EPUB
`E:/EPUB/work/reocr_stage/[Guillemin,Pollack]Differential_Topology(1974)/render/*.epub`
线描筛选条件：500≤w≤1400、330≤h≤900、墨迹占比 0.004–0.16。命中 34 张，本批取 zip 序号 47 / 50 / 14。

| 编号 | zip idx | 内容 | 渲染次数 | overlay mean dist | 结论 |
|---|---|---|---|---|---|
| dt47-preimage | 47 | 正则值原像分解图：X 带自交闭曲线、Y 矩形、圆 Y、g 弧、R¹ 轴、三个实心点 | 2 | 0.94 px | 通过 |
| dt50-s1 | 50 | S¹ 与四条嵌套闭曲线 f₀/f_{1/3}/f_{2/3}/f₁ + f 箭头 | 3 | 0.73 px | 通过 |
| dt14-torus | 14 | 方块→圆柱→环面粘接流程，含 G 长弧箭头 | 3 | 0.46 px | 通过 |

3/3 通过，无放弃。

## 验收口径

结构、线条、箭头、连接关系、版面比例、符号正确性；字体不要求与原书一致。
量化指标用 `work/ov.py`：源图墨迹设为青色、渲染墨迹设为品红，搜索最优平移后计算「渲染墨迹到最近源图墨迹的平均距离」。
本批三图分别为 0.94 / 0.73 / 0.46 px，均 <1 px。同时校验长宽比：源图与渲染相差 <1%。

## 本批新增做法

- `ov.py`：把主观「看着像」变成可比较的数值，重编译后可直接看是否退化。
- `trace.py`：白区连通标记 + 裂缝跟随边界追踪 + Douglas–Peucker 简化，输出 Typst 点列字面量。
  关键技巧：追踪前把白区按半个笔宽膨胀（`binary_dilation`, `iterations=3`），得到的轮廓就是笔画中心线，
  dt50 的 mean dist 由 1.6 px 降到 0.73 px。
- 参数化椭圆弧 `ell(cx,cy,rx,ry,t0,t1)` 直接给整椭圆、半椭圆（虚线隐藏半边）与任意开口弧，
  圆角矩形由四段四分之一弧拼接（`rr`）。比手工算角点可靠。
- 手绘感轮廓（环面左侧那个"蛋形"洞）用椭圆拟合会在左端偏差十几像素，改成实测点列 `crm` 后吻合。

## 记下的坑

- Typst 里 `math` 被 `import draw: *` 遮蔽，`math.cos` 报「expected function, found content」；用 `calc.cos` / `calc.sin`。
- CeTZ 的 `stroke` 字典只接受 `paint/thickness/cap/join/dash/miter-limit`，虚线疏密写 `dash: (array: (2.4pt, 2.2pt))`，没有 `length` 键。
- `draw.rect` 需要位置参数 `a`，不支持只给 `center/width/height`；圆角矩形自己拼。
- Typst 无 `%` 与 `mod`，环形索引自己写 while 回绕（见 `wrap`）。
- 数学里写分数下标用 `frac(2,3)`，`2 over 3` 会报 unknown variable。
- 箭头 `mark:(end: hd)` 里 hd 的 `length` 是整条箭头长度；照抄源图三角形尺寸会偏大，本批从 7.1pt 收到 5.4pt。

## 累计

`.typ` 文件 119，尝试 111，通过 110，放弃 1。
