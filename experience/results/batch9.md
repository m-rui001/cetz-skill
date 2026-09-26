# Batch 9 结果（2026-09-26）

来源：Deaux《Introduction to the Geometry of Complex Numbers》（PDF 页码 = 印刷页码 − 1）。
本批取印刷页 146（Fig.46）与 159（Fig.52）。

| # | 原图 | typ | 编译 | 结论 |
|---|---|---|---|---|
| fig27-similitude | src/fig27-similitude.png（Fig.46 两对应射线 d, d₁ 与角）| typ/fig27-similitude.typ | png/fig27-similitude.png | 通过（首次；射线方向用 atan 反解角度后由 L 外推端点，角弧 `arc` 起始角同法）|
| fig28-involution | src/fig28-involution.png（Fig.52 Möbius 对合圆图）| typ/fig28-involution.typ | png/fig28-involution.png | 通过（第 2 次：原图中过 F、Z' 的割线与过 L 的竖线在圆下方相交，首版把割线截短未相交→延长至 (-.2,-3.05) 复现交点）|

结果：2/2 通过。累计 27 通过 / 1 放弃。

## 选图阶段淘汰记录（本批）
- 印刷 137 Fig.44：双圆 + P/Z₁/Z₂/Z'₁/Z'₂/d/d' 十余元素，排除。
- 印刷 146 Fig.45：与 Fig.46 同型但含 L/M/M'/Z/Z' 双射线对，取更简的 Fig.46。
- 印刷 150 Fig.47、153 Fig.48/49：圆 + 双轴 d₀d'₀ + 多虚线，排除。
- 印刷 159 Fig.52 之外的 Fig.51/53（印刷 162）：三角形 + 多共轭点，排除。
- 印刷 98 Fig.39、100 Fig.40：抛物线/双曲线 + 刻度数字网格（1–6 的标定刻度），
  属"曲线 + 密集刻度"类，超出线描示意范围，排除。

## 经验
- 扫描书中"两直线在图外相交"的构造，端点要一并延长到交点之外，
  否则拓扑相似但明显失真（fig28 首败原因）。
- 同一页有多幅同型图时，选元素更少的那幅，不要硬转复杂的那幅。
