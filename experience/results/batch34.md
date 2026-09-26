# batch34 结果（Fourier 书 idx 4 / 7 / 16）

来源：`E:\EPUB` / `E:\mathbook` 的 James《Fourier Transforms》，图片编号沿用 `ft` 前缀。
本批原计划在 batch33，因与 Codex 的批次号冲突，整体迁到 `work/batch34`，`work/batch33` 保留对方的 pdf007–009。

| 图 | 源 | 结果 | 编译次数 | 说明 |
| --- | --- | --- | --- | --- |
| ft04-spiral | idx 4 | 通过 | 3 | 衰减螺线 + 四条相量，`k=2.2` 缩放，分段半径函数贴合实测 r(θ) |
| ft07-ghosts | idx 7 | 通过 | 3 | 一阶/二阶鬼线谱，断裂坐标轴，两条引出线分别指向 m²/4 与 m⁴/16 谱线 |
| ft16-strip | idx 16 | 通过 | 3 | 斜二测坐标下的窄带（两端撕开），偏移量 a 沿 x 方向标注 |

累计：batch1–34 共 102 个 `.typ`，尝试 94 / 通过 93 / 放弃 1。

## 本批踩到的坑

1. **`curve()` 不存在**：`curve(..pts, stroke: t)` 报 `expected content, found array`。折线一律
   `line(path: true, ..pts, stroke: t)`。
2. **Typst 数组没有 `.add`**：`pts.add(p)` 报 `type array has no method add`；`push` 才是就地追加，
   且不需要回写变量。
3. **原点不能靠目测**：ft16 第一版把坐标原点猜在 (535,392)，实际三线交点在 (580,397)，导致窄带
   穿过 y 轴。改用 numpy 做 Hough 抽线段，再解 x/y 轴交点定原点，一次到位。
4. **线宽要按输出像素反推**：CeTZ 1 单位 = 1 cm，Typst PNG 导出 ≈144 ppi（78.7 px/单位）。
   书上的 hairline 只有 1–2 px，用 `1.0pt` 会明显粗于原图；ft16 最终 0.5pt、ft04 1.15pt、ft07 1.1pt。
5. **`overline` 与 `slash`**：`$m^2 / 4$` 会变成堆叠分式，必须 `$m^2 slash 4$`；
   带上划线的 ν 用 `$overline(nu)$`。
