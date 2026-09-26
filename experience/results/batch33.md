# batch33：量子密码协议与光路

来源：Pirandola 等《Advances in Quantum Cryptography》，PDF 路径、页码与裁切范围见 `SOURCE.json`。源 PDF 只读；所有产物写入本批目录。

| 文件 | 原图 | 视觉重试 | 判定及依据 |
|---|---|---:|---|
| pdf007-adaptive-protocol | Fig.12，PDF 74 页 | 1 | 通过：四个 LOCC 区块、双寄存器、两条红色信道阶梯、状态与省略号的位置接近原图，连接关系正确。 |
| pdf008-protocol-stretching | Fig.14，PDF 77 页 | 1 | 通过：三面板的寄存器、LOCC/LO 区块、CC 虚线与绿色资源态路径均保留，括号与状态标注对应正确。 |
| pdf009-coherent-comparison | Fig.20，PDF 98 页 | 1 | 通过：四分束器、上下反射镜、交叉光路、虚线区域及四个输出位置接近原图，交叉处没有误加连接点，输出式正负号正确。 |

合计 **3/3 通过，0 放弃**。独立 CeTZ 0.4.2 源码位于 `typ/`，原图在 `src/`，300 ppi 编译图在 `png/`，逐图对比为 `cmp_*.png`。每张均实际编译并查看原图/渲染对比；初次编译修正一次变量减法周围缺少空格导致的解析错误。视觉重试主要调整标注尺寸与位置。

用户验收补充：字体无需完全相同，图形应尽量接近。故以结构、线条、箭头、连接、布局、比例和符号正确为主要标准，字体要求清楚且不遮挡。

复现：在本批目录运行 `python ../pdf-candidates/build.py . pdf007-adaptive-protocol pdf008-protocol-stretching pdf009-coherent-comparison`，随后 `python compare.py`。
