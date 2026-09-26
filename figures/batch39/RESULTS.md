# batch39：卫星地面面板、软件收发系统与 COW 光路

来源：《Advances in Quantum Cryptography》。精确 PDF 路径、页码、面板及内嵌图片编号见 `SOURCE.json`；源 PDF 只读。

| 文件 | 来源 | 视觉重试 | 判定与依据 |
|---|---|---:|---|
| pdf016-satellite-ground-optics | Fig.8 右侧白底面板，PDF 42 页 | 0 | 通过：两个分束器、双向绿色光路、分析器/测距端、四个量子脉冲、两个 SLR 脉冲及 100 ms/10 ns 间隔的位置与方向接近原图。 |
| pdf017-software-defined-qkd | Fig.10(c)，PDF 58 页 | 1 | 通过：双 DAC/DSP 发射端、VOA 与监测支路、信号/LO 接收前端、双混频器、0/90 块及双 ADC/DSP 保留原图连接与排列。 |
| pdf018-cow-experiment | Fig.4(d)，PDF 35 页 | 1 | 通过：器件的立体外形、激光/调制/衰减链、量子信道、90:10 与 50:50 耦合器、两反射镜和两个 SPD 端口按原图保留；光纤曲线与比例接近。器件表面明暗较原图简化，已记录为差异。 |

本批 **3/3 通过，0 放弃**。每张实际编译为 300 ppi PNG，并已查看最终原图/渲染对比。CeTZ 独立源码在 `typ/`，原图在 `src/`，产物在 `png/`，对比为 `cmp_*.png`。全部首稿编译成功。

视觉修正：软件图的微型控制符号与末端箭头位置；COW 图的标注尺寸与行距，避免多行文字超出器件面。字体遵循用户要求，不追求完全一致；光路与器件位置优先。

Fig.8 左侧照片/地图在筛查中排除，这里只复刻右侧白底光路/概念时序。概念脉冲时序属于示意图，保留；数据曲线保持排除。

这批不代表所有复合图完成。仍有 Fig.4(a)、Fig.10(a) 和 Fig.6 的可转绘部分待处理。

复现：`python ../pdf-candidates/build.py . pdf016-satellite-ground-optics pdf017-software-defined-qkd pdf018-cow-experiment`，随后 `python compare.py`。
