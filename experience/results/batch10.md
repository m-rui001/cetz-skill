# Batch 10 结果（2026-09-26）

来源：`E:\EPUB\out\mathbook\A Students Guide to Vectors and Tensors by Daniel Fleisch (z-lib.org).epub`
（解包 `OEBPS/images`，共 76 张；透明底 PNG 需先合成白底）。

| # | 原图 | typ | 编译 | 结论 |
|---|---|---|---|---|
| fig29-radials | src/fig29-radials.png（径向箭头场 (a) 发散 /(b) 汇聚）| typ/fig29-radials.typ | png/fig29-radials.png | 通过（首次；8 条射线用 `for i in range(8)` 循环生成，箭头画在射线中段而非末端，方向靠内外两点顺序翻转）|
| fig30-coords | src/fig30-coords.png（基向量与坐标 (1,3)/(4,0)/(7,2)）| typ/fig30-coords.typ | png/fig30-coords.png | 通过（第 2 次：$(7,2)$ 与箭头尖重叠→右移）|
| fig31-projection | src/fig31-projection.png（点积投影 (a)(b)+三行说明文字）| typ/fig31-projection.typ | png/fig31-projection.png | 通过（第 2 次重排：首版 (b) 面板置于 (a) 上方、花括号 bezier 控制点过低画成大弧；改为左右并排、控制点贴弦后与原图一致）|
| fig32-parallelogram | src/fig32-parallelogram.png（$C_x = A_x + B_x$ 分量图，B_x 为负）| typ/fig32-parallelogram.typ | png/fig32-parallelogram.png | 通过（首次；手写体引线箭头用短 bezier + `mark:(end:">")`）|

结果：4/4 通过。累计 31 通过 / 1 放弃。

## 选图阶段淘汰记录（本批）
- 索引 0/2/10/41/42/59：多面板 + 旋转坐标系 + 大量下标标签，密度超门槛。
- 索引 44/45/46/53：照片/灰度渲染（配送卡车插画、实拍挥杆照片、三维曲面灰度图），非线描，直接排除。
- 索引 12/19/20/25/28：带长段说明文字与流线填充，重绘等价于排版而非画图，排除。

## 经验（本批新增）
- EPUB 内 PNG 多为 RGBA 透明底：`(a.mean()<0.5)` 一类的墨量统计会全为 0，
  必须先 `alpha_composite` 到白底再判据；否则筛不出候选。
- 76 张图一次拼成带红字索引的接触表，一次 Read 完成全库选型，比逐张看省 20 倍上下文。
- Typst 数值运算没有 `**` 幂运算符，写 `*` 连乘（本批编译报错一次）。
- 花括号/引线这类"装饰性手绘线"用 bezier 时，控制点要贴近弦（偏移 ≤0.3 单位），
  偏移过大会画成大回环弧，视觉上完全走样。
