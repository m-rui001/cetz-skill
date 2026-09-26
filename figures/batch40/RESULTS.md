# batch40：两块大型斜向光路

来源：《Advances in Quantum Cryptography》，完整内嵌图与页码见 `SOURCE.json`。使用原图坐标定位节点，绘图全部为 CeTZ 原生线、曲线、椭圆、多边形和文字；无嵌入图片。

| 文件 | 来源 | 视觉重试 | 判定及依据 |
|---|---|---:|---|
| pdf019-dv-qkd-benches | Fig.4(a)，PDF 35 页，xref 954 | 1 | 通过：双斜基底、DU/LD、两个 BS/PBS 干涉臂、PM/IM/FS/PC/VA/OPM、信道卷筒和完整光纤位置接近原图。重试将小光纤环改为椭圆、FS 改为圆角器件，调整卷筒扇区。 |
| pdf020-transmitted-lo-cv-qkd | Fig.10(a)，PDF 58 页，xref 1601 | 1 | 通过：两块斜向台面、10 个柱形器件、4 个 PIN、两端 FM、调制器/DPC、红/绿/黑三类光路、LO 虚线段、反馈/时钟/零差探测支路及原图图例均保留。重试分开多行标签并修正图例锚点，避免覆盖线条。 |

本批 **2/2 通过，0 放弃**。两张均实际编译为 300 ppi PNG，并查看最后的 `cmp_*.png`。独立源码在 `typ/`，原图在 `src/`，成品在 `png/`。初稿均直接编译成功。

记录差异：器件表面明暗采用有限灰色层带近似，与原图的连续明暗有差异；字体按主人要求无需一致。验收优先器件外形、数量、位置、完整支路、箭头及整体比例，标签清楚且无重叠。

Fig.4 与 Fig.10 的所有单独面板现已转绘，但尚未生成与原复合图排列一致的完整组合版，后续合成。Fig.6 的可转绘示意部分仍未完成。

复现：`python ../pdf-candidates/build.py . pdf019-dv-qkd-benches pdf020-transmitted-lo-cv-qkd`，随后 `python compare.py`。
