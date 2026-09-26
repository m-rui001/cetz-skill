# batch29 结果

图源：E:/pdf 旧库，Pirandola 等《Advances in Quantum Cryptography》accepted version。
PDF：`E:/pdf/pdfonly-stem/pdfcorpus/out/pdfs/epr/4f/4f53c97362c66632bad047e1440e69ed41896204.pdf`。
详细页码与裁剪框见 `SOURCE.json`；页码为 PDF 的 1-based 页序。

| 图 | 原图 | PDF 页 | 结果 | 视觉重试 | 判定理由 |
|---|---|---|---|---|---|
| pdf004-interferometer | Fig.1 | 12 | 通过 | 1 | 两条相位控制光路、两个粗分束器、两面带背纹反射镜、PSA/PSB 与两只探测器完整。四个方向箭头均沿原光路，端点到镜面或探测器边界；修正箭头尺寸、镜背纹方向及标签大小。 |
| pdf005-ping-pong | Fig.2 | 22 | 通过 | 2 | Bell 态、Alice EM 的实线回路、Bob 两路 EM 输入、两只 CM 探测器的点线支路与双方分界虚线均正确；四个黑点的连接关系一致。先修复折线路径误填黑，再匹配点线密度和箭头尺寸。 |
| pdf006-locc-simulation | Fig.13 | 75 | 通过 | 2 | 保留红色直接信道和输入/输出线、绿色 σ 资源支路、蓝色 LOCC 区域、两只浅色圆角 LO 块及向上的 CC 虚线；ρ、σ、𝓣、ℰ、ℰ(ρ)、a/a′/b′/b 标签齐全。修复曲线误填色，并把 b′ 移回绿色支路末端旁。 |

三份 `.typ` 均已用 Typst 0.15.1 + CeTZ 0.4.2 编译；最终 PNG 为 240 ppi。
本批没有源码编译错误；终稿曾遇到一次 Windows PNG 文件占用，改为编译到 `.new.png` 后 `os.replace`，三份最终文件均成功生成。

## 视觉验收

最终 `cmp_pdf004-interferometer.png`、`cmp_pdf005-ping-pong.png`、`cmp_pdf006-locc-simulation.png` 已逐张打开，上原图、下 CeTZ。对比只统一宽度，不改变纵横比。

通过依据是拓扑、虚实线、箭头、标签与比例达到原图观感。手工采样的镜背纹、贝塞尔弧和字体局部形状有轻微差别，不影响图的含义与结构。

## 本批经验

见 `../EXPERIENCE.md` 的 batch29 追加条目：箭头填充与路径填充必须分开、CM 点线与双方虚线使用不同 dash 周期、镜背纹按原图方向、Windows PNG 临时文件替换。

## 下一步

- 下一图号从 `pdf007` 起，开批前先核对 `community.md` 及实际目录；batch30–31 已由 EPUB 进程占用。
- 同篇 Fig.12（PDF 74 页）、Fig.14（77 页）、Fig.20（98 页）可先渲染筛选，尚未作通过/放弃判定。
- 其余旧 PDF 使用 `../pdf-candidates/index.jsonl` 选页；EPUB/mathbook 由另一进程继续推进，整体任务保持原范围。
