# Batch 7 结果（2026-09-26）

来源：`E:\mathbook\Introduction to the Geometry of Complex Numbers by Roland Deaux, Howard Eves (z-lib.org).pdf`（扫描版，207 页）。
选取页面：p15（Fig.1）、p20（Fig.6）、p59（Fig.25）。

| # | 原图 | typ | 编译 | 结论 |
|---|---|---|---|---|
| fig21-polar | src/fig21-polar.png（p15 Fig.1 极坐标式）| typ/fig21-polar.typ | png/fig21-polar.png | 通过（第 2 次：$(x,y)$ 标签与点重叠→移至 (2.55,1.66)；θ 弧箭头未达 a 射线→stop 200deg→217deg）|
| fig22-inversion6 | src/fig22-inversion6.png（p20 Fig.6 反演）| typ/fig22-inversion6.typ | png/fig22-inversion6.png | 通过（修复 $Z_2$ 数学下标；直径线 P–O–Q 延长至 Z2）|
| fig23-centroid | src/fig23-centroid.png（p59 Fig.25 重心）| typ/fig23-centroid.typ | png/fig23-centroid.png | 通过（首次即过；G=(A+B+C)/3 解析计算，确认 G 在中线 A–A' 上）|

结果：3/3 通过。

## 备注
- fig21 的 θ 弧为逆向标注：原图中弧从实轴正向逆时针转到 a 射线，箭头落在射线上，用 `arc(点on弧, radius, start, stop, mark:(end:">"))` 复现。
- fig22 两个 θ 角弧半径不同（θ1 上、−θ2 下），用小圆弧不带箭头/带箭头区分，与原图一致。
- fig23 元素少、几何全部解析求出，属"零重试"典型；此类图适合作为批次保底。

## 本批失败/淘汰记录
- 无选图阶段淘汰（p15/20/59 均单图清晰）。
