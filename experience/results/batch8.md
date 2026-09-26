# Batch 8 结果（2026-09-26）

来源：`E:\mathbook\Introduction to the Geometry of Complex Numbers by Roland Deaux, Howard Eves (z-lib.org).pdf`。
注意：本书 PDF 页码与印刷页码相差 1（PDF p25 = 印刷 p26）。本批取印刷页 26/76/91。

| # | 原图 | typ | 编译 | 结论 |
|---|---|---|---|---|
| fig24-translate | src/fig24-translate.png（Fig.7 平移 z'=z+a）| typ/fig24-translate.typ | png/fig24-translate.png | 通过（首次；Z'=Z+A 解析求出，虚线 OA/OZ + 实线 ZZ'）|
| fig25-ellipse | src/fig25-ellipse.png（Fig.31 椭圆向量和）| typ/fig25-ellipse.typ | png/fig25-ellipse.png | 通过（第 2 次补 x 轴标签；两枚 ωt/−ωt 虚线角弧用 atan2 反解起始角）|
| fig26-ray | src/fig26-ray.png（Fig.38 射线 z=a₀+a₁T）| typ/fig26-ray.typ | png/fig26-ray.png | 通过（首次；反向虚线延长段用方向向量外推）|

结果：3/3 通过。累计 25 通过 / 1 放弃。

## 选图阶段淘汰记录（本批）
- PDF p1：彩色封面（球面+橙色曲线），非线描图，直接排除。
- 印刷 p40 Fig.19/20/25：三圆正交轨线 + 极点极线构造，元素密度超门槛。
- 印刷 p42/43/45 Fig.21/22/23：双圆+共线点+大量下标标签，排除。
- 印刷 p67 Fig.26/27、p69 Fig.28/29：多圆多箭头 a₁₃/a₂₄ 类，排除。
- 印刷 p78 Fig.32、p85 Fig.36/37：虚线大圆+多条切线+瞬时中心，排除。

## 经验
- 角度弧的起始角可由 `calc.atan2(y, x)` 反解，不必手算度数，标签位置仍手动调。
- 扫描页连通域定位对小图（<10% 页高）会失效，退回"半页缩略图目测 + 比例裁剪"两轮迭代即可命中。
