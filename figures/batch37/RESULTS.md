# batch37：三块实验系统面板

来源：《Advances in Quantum Cryptography》，页面及面板来源详见 `SOURCE.json`。这批按面板统计，不把部分面板计作整张复合图已完成。

| 文件 | 来源 | 视觉重试 | 判定与依据 |
|---|---|---:|---|
| pdf013-three-state-bb84 | Fig.4(b)，PDF 35 页 | 1 | 通过：Alice/Bob 虚线区域、干涉仪两臂、IM/DCF/VA/ULL、分束器、两输出 SNSPD 的位置与连接接近原图。 |
| pdf014-dps-system | Fig.4(c)，PDF 35 页内嵌图 xref 948 | 2 | 通过：PG 两驱动支路、同步线、IM/PM/VA、STF、环行器、FMI 与两个 SSPD/TDC 通道按原图保留，相位标注不遮器件。 |
| pdf015-local-lo-cv-qkd | Fig.10(b)，PDF 58 页 | 2 | 通过：两端独立激光器、调制链、SM 光纤、PC、延迟线、BS/PD 和零差探测器拓扑正确，三种脉冲时序的柱数、位置、高低顺序和标注接近原图。 |

本批 **3/3 通过，0 放弃**。独立 CeTZ 0.4.2 源码在 `typ/`，300 ppi 成品在 `png/`，原图在 `src/`，已实际查看每张最终 `cmp_*.png`。编译时修正一次 `range` 步长语法（`step:` 是命名参数）。

源图处理说明：Fig.4(c) 在 PDF 排版中被右侧 Fig.4(d) 的白底遮住最右端少量标签；比对采用 PDF 内嵌的完整 1500×697 原图，不补写猜测文字。Fig.4(b) 裁切移除左侧邻图的线条与面板字母，保留完整光路。

遵循用户要求：字体不必完全一致，保持清楚、符号正确即可；数据曲线图不复刻。Fig.10(b) 底部是概念脉冲时序示意，保留作为系统图的一部分。

原复合图仍有待处理面板：Fig.4(a)/(d)；Fig.10(a)/(c)。本批不支持整篇完成的结论。

复现：`python ../pdf-candidates/build.py . pdf013-three-state-bb84 pdf014-dps-system pdf015-local-lo-cv-qkd`，然后 `python compare.py`。
