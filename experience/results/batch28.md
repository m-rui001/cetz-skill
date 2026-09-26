# batch28 结果

图源：E:/pdf 旧库，Pirandola 等《Advances in Quantum Cryptography》accepted version。
PDF：`E:/pdf/pdfonly-stem/pdfcorpus/out/pdfs/epr/4f/4f53c97362c66632bad047e1440e69ed41896204.pdf`。
页码采用 PDF 的 1-based 页序；详细裁剪框见 `SOURCE.json`。

| 图 | 原图 | PDF 页 | 结果 | 视觉重试 | 判定理由 |
|---|---|---|---|---|---|
| pdf001-cv-qkd | Fig.9 | 57 | 通过 | 2 | Laser→AM→PM→MUX→光纤环→DEMUX 的连接完整；Ref 支路正确；两路在灰色分束器交叉后分别进入探测器，再接减法器。修正分束器位置并删除原图不可见的末端线；标签、环线切点、粗细层次一致。 |
| pdf002-repeater-chain | Fig.16 | 81 | 通过 | 2 | Alice a、r₁、rᵢ、rᵢ₊₁、r_N、b Bob 的顺序和三段信道正确；两处各四个省略点；ℰ₀/ℰᵢ/ℰ_N 均在相应信道下方。第二轮按 PDF 的 Arial / Calibri Bold / Cambria Math 区分字体，缩小下标和信道标签。 |
| pdf003-swap-test | Fig.19 | 96 | 通过 | 1 | 三条量子线、两只 H 门、上方控制点与下两条线上的交换叉、末端测量表均完整；控制线与两个叉共享同一 x，ket 标签的 ϕ 字形修正。几何比例和线宽达到原图观感。 |

编译：Typst 0.15.1 + CeTZ 0.4.2，Windows 字体目录，最终 PNG 为 240 ppi。
以上“视觉重试”只计成功编译后的目视返工；另修复 4 次编译错误：变量减法空格、rotate 名字遮蔽、ket 未定义、angle.r 不存在。

## 视觉验收

- `src/` 为从原 PDF 裁出的基准 PNG；`typ/` 为独立可编译的 CeTZ 源码；`png/` 为最终编译结果。
- `cmp_pdf001-cv-qkd.png`、`cmp_pdf002-repeater-chain.png`、`cmp_pdf003-swap-test.png` 已逐张打开比较；上原图，下 CeTZ。
- 比对时裁去白边、统一宽度，保留各自纵横比，不以拉伸图片掩盖比例差异。
- 字体和局部字形保留少量渲染差异；没有缺失标签、悬空端点或多余连接。

## 本批经验

见 `../EXPERIENCE.md` 的 batch28 追加条目。

## 下一步

- 同一论文 Fig.1 / Fig.2 / Fig.13 / Fig.14 先做视觉筛选。
- 949 篇旧 PDF 的候选页索引已保存到 `../pdf-candidates/index.jsonl`；候选数量不等于可转绘图数量，需接触表目视排除表格和公式页。
