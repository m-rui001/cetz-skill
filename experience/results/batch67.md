# batch67 — 电压提升单元及有源开关电感位置

来源：Forouzesh 等，Step-Up DC–DC Converters，DOI 10.1109/TPEL.2017.2652318，PDF15。来源只读，完整裁切见 SOURCE.json。

| 图与范围 | 独立原生 CeTZ | 编译 | 最终实际目视结论 | 视觉重试 |
|---|---|---|---|---:|
| Fig.15 总结构及四种单元 | typ/pdf042-voltage-lift-cells.typ | 300 ppi | 通过 | 2 |
| Fig.16 完整有源开关电感框图 | typ/pdf043-active-switched-inductor-placement.typ | 300 ppi | 通过 | 2 |

2/2 完整图通过，无放弃。Fig.15 保留上方总结构、Basic SL、Elementary-Lift、Self-Lift、Double Self-Lift 四种单元，以及全部元件、节点、开关、灰色漏感、端口和原图重复的 (a) 编号。Fig.16 保留 A/B/A′/B′ 四端口、输入电源、输出二极管、电容和负载。

初稿、第一次修正和最终稿均在成功编译后实际查看原图/渲染比较。Fig.15 第一轮修正二极管引线 1–4 个源坐标单位的缺口，并缩短灰色 Lr 的节距、补足尾导线；第二轮调整 S0 标签，保持开关斜线后的空白。两图输出侧 C_o/R_o 标签局部减小字号，Fig.16 第二轮进一步处理电容与电阻间的窄标签空间。

原图 src、源码 typ、300 ppi PNG、cmp、生成器、元数据齐全；最终 typ 不读取任何图像/SVG，不依赖其他批次。字体按用户要求允许差异。预览 work/PDF-PREVIEW-17.png。下一步 PDF16 Fig.17/18，pdf044 起。
