# Batch 11 结果（2026-09-26）

来源：`E:\EPUB\out\mathbook\A Students Guide to Vectors and Tensors by Daniel Fleisch (z-lib.org).epub`
（按 zipfile 索引直接取图，无需整包解出；索引 17/49/62/65）。

| # | 原图 | typ | 编译 | 结论 |
|---|---|---|---|---|
| fig33-addition | src/fig33-addition.png（向量加法 (a) 分置 /(b) 平移三角形法）| typ/fig33-addition.typ | png/fig33-addition.png | 通过（第 2 次：首版坐标轴画在 y=−0.45 而向量起于 (0,0)，原点错位；改为轴过 (0,0) 并把 A+B 与 C 标签上下错开）|
| fig34-components | src/fig34-components.png（逆变分量 A¹e₁ / A²e₂ 投影）| typ/fig34-components.typ | png/fig34-components.png | 通过（第 2 次：(b) 面板 ẽ₂/(4,0)/A 标签压在 A 箭杆上（A 线 y=0.3x 正好穿过标签），统一下移到轴下方）|
| fig35-cube | src/fig35-cube.png（立方体与单位矢 î ĵ k̂）| typ/fig35-cube.typ | png/fig35-cube.png | 通过（首次；顶点由 `V(i,j,k)` 函数按三条斜投影基向量线性组合生成，三面用 `line(...,close:true,fill:luma(140/180/215))` 分灰度）|
| fig36-fieldlines | src/fig36-fieldlines.png（涡旋/剪切/点源三类场线图 (a)(b)(c)）| typ/fig36-fieldlines.typ | png/fig36-fieldlines.png | 通过（首次；切向小箭头封装成 `ah(p,a)` helper，(b) 用 for 循环生成 7 条速度剖面箭头）|

结果：4/4 通过。累计 35 通过 / 1 放弃。

## 本批经验
- 标签坐标必须代入所在直线方程验算（A 线 y=0.3x 与标签 y=0.3 撞车），
  不能只看大致方位；这是本批两次重试的共同原因。
- 斜投影立方体：把三个基向量写成元组，顶点用 `V(i,j,k)` 现算，
  比手抄 8 个坐标可靠，改比例只需动 3 个数。
- 重复的"切向小箭头"用 `(p, a) => line(...)` 局部函数封装，代码量减半。
