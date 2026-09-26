# batch54 — Fig.9 完整七组电荷泵与开关电容电路

来源：Forouzesh 等，*Step-Up DC–DC Converters: A Comprehensive Review of Voltage-Boosting Techniques, Topologies, and Applications*，IEEE TPEL 2017，DOI 10.1109/TPEL.2017.2652318。PDF11，裁切范围与只读来源路径见 SOURCE.json。

| 源图与范围 | 原生自包含源码 | 编译 | 最终实际目视结论 | 视觉重试 |
|---|---|---|---|---:|
| Fig.9 完整 (a)–(g) | typ/pdf036-charge-pump-circuits.typ | 300 ppi | 通过 | 2 |

1/1 完整图通过，七个面板不重复算七张。无放弃。

保留 Basic Charge Pump、Basic Switched Capacitor、Doubler、Series-Parallel、Ladder、Dickson、Makowski or Fibonacci 全部面板，所有电容、开关及 I/II 相位、接地符号、空心端口、非连接跨线、黄色级联高亮和灰色输入端口。

## 修改与证据

- 开关分为水平和垂直，按本图源符号定位活动杆；(b) 单独画四个固定触点与双位置选择杆，避免画成普通单向开关。
- 第一稿实际比对发现 (c)/(g) 短支路尾线越过横向回接点，(c)/(d) 少量接地前留有一像素距离；修正垂直开关的可选绝对尾线终点，消除多余线和接地空隙。
- (b) 的非连接弧在竖向导线上，(f) 的非连接弧在横向导线上；均逐图按原图定位。没有把交点加为节点。
- 初稿与修正后的完整 cmp_pdf036-charge-pump-circuits.png 都实际查看，修正稿才记通过。字体按用户口径允许差异，元件和连接关系完整。
- 源图 src/、300 ppi PNG png/、最终比较 cmp_、SOURCE.json 已齐。可编辑生成器 draw.py 与 prepare.py 留存，最终 .typ 无外部图像/其他批次依赖。

下步继续 PDF11 Fig.10 完整五组开关电容 DC–DC 电路，从 pdf037 起。数据图继续按用户要求排除。

## 曲极板连接补正（2026-09-26 14:19，Codex / batch55 回查）

此前下引线端点与 Bézier 曲极板中点之间有细小空隙，现按实际中点补齐；已重新 300 ppi 编译、重建比较并实际查看，保持通过。通过图数不增加。

当前累计视觉重试：pdf036-charge-pump-circuits = 2。本章更新后的 SOURCE.json 和当前比较图为最终证据，早期收口叙述的次数属于历史。
