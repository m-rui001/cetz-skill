# batch55 — Fig.10 完整开关电容 DC–DC 电路

来源：Forouzesh 等，*Step-Up DC–DC Converters: A Comprehensive Review of Voltage-Boosting Techniques, Topologies, and Applications*，DOI 10.1109/TPEL.2017.2652318，PDF11。只读 PDF 与裁切范围见 SOURCE.json。

| 源图与范围 | 自包含原生源码 | 编译 | 最终实际目视结论 | 视觉重试 |
|---|---|---|---|---:|
| Fig.10 完整 (a)–(e)，包括开关等效框 | typ/pdf037-switched-capacitor-converters.typ | 300 ppi | 通过 | 1 |

1/1 新整图通过，无放弃。五个面板不重复算五张。初稿和成功编译后的修正稿比较图均实际查看。中间一次 `up` 参数编译错误没有新渲染，随后查看到的旧图不当成修正稿证据；增加带方向参数的局部 diode helper 后编译成功，再生成并查看最终比较。

## 保留与修改

- (a)/(b)/(e) 二极管—电容级联、(c)/(d) 模块电容、灰色寄生电感、全部开关及原标签、三处非连接跨线、开关—MOSFET 等效小框、奇/偶倍数红蓝阶梯色块和输出虚线均保留。
- (c)/(d) 原图上重复出现 S1a/S1p/S1b 标签，按源图保留，没有凭推测改成 S2。
- 第一稿 (a) 两只二极管误用了默认向上方向，实际比较后反转为向下；(b) 下排电容按放大原图下移 7 个源坐标像素。
- 曲极板电容引线按 Bézier 中点相接，水平和垂直分别定义；最终源码不读入原图、SVG 或其他文件。源图 src/、PNG png/、cmp_、SOURCE.json 和可编辑生成器均齐。
- 预览 work/PDF-PREVIEW-13.png；下一步 PDF12 Fig.11 完整倍增单元，pdf038 起。

## 同类符号回查

这次定位曲极板中点后，回查此前同类 CeTZ helper：batch47/pdf030、batch49/pdf031/pdf032、batch50/pdf033、batch53/pdf034、batch54/pdf036 共六张已通过图补齐了极板与引线之间的细小空隙。均重新编译 300 ppi、重建比较并实际查看，保持通过。各图额外计一次视觉补正，总视觉重试依次为 3/3/3/3/2/2；SOURCE.json、RESULTS.md 和逐图清单同步。通过总数不增加。
