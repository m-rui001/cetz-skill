# batch57 — 电压倍增单元与整流器放置结构

来源：Forouzesh 等，*Step-Up DC–DC Converters: A Comprehensive Review of Voltage-Boosting Techniques, Topologies, and Applications*，IEEE TPEL 2017，DOI 10.1109/TPEL.2017.2652318。来源 PDF 只读，页码/裁切范围见 SOURCE.json。

| 原图与范围 | 自包含原生 CeTZ | 编译 | 最终实际目视结论 | 视觉重试 |
|---|---|---|---|---:|
| PDF12 Fig.11 完整 (a)–(g) | typ/pdf038-voltage-multiplier-cells.typ | 300 ppi | 通过 | 1 |
| PDF13 Fig.12 完整 (a)/(b) | typ/pdf039-voltage-multiplier-placement.typ | 300 ppi | 通过 | 1 |

2/2 完整图通过，无放弃。每幅初稿与成功编译后的最终修正比较图均实际查看。Fig.11 七面板和 Fig.12 两面板没有重复计为九张图。所有产物为原生线、Bézier、色块和文字，最终 .typ 不读取任何外部图片、SVG 或其他批次文件。

## 实际修改

- Fig.11 保留主结构、全部六种倍增单元、器件/端口/节点、非连接跨线、灰色 Lr、独立辅助开关。水平电容分别保留弯板左/右朝向。第一稿部分标签挤到曲极板，调整字号与左右定位；(g) C 标签由错误左侧改到原图右侧；(b)/(e) 二极管与左引线相隔一个坐标单位，补齐接线。
- Fig.12 保留脉冲 DC/AC 输入小符号、紫色背景、单绕组带磁芯/极性点、隔离变压器及两组 VMR 框。修正变压器由错误五圈到原图四圈，分别设置上下引线余量；调整文字比例。
- 输入正弦/方波仅是类型小符号，不是数值数据图，按概念示意保留；数据曲线的排除规则保持。
- src/ 原图、png/ 300 ppi 编译、cmp_ 最终实际比較、SOURCE.json、编辑生成器 draw.py/placement.py 齐全，预览 work/PDF-PREVIEW-14.png。

下一步 PDF14 Fig.13 完整半波倍增整流器，pdf040 起。继续完整逐图处理，不设置单篇图数上限。
