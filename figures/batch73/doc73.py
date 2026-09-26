# -*- coding: utf-8 -*-
import io, re

def read(p):
    return io.open(p, encoding='utf-8', newline='').read()

def write(p, s):
    io.open(p, 'w', encoding='utf-8', newline='').write(s)

# ---------------- EXPERIENCE.md ----------------
EXP = 'EXPERIENCE.md'
s = read(EXP)
nl = '\r\n' if '\r\n' in s else '\n'
row = ('| 73 | `work/batch73` | 2/2：素材源换到 Itskov 张量书（前缀 it）。'
       'it33 向量代数六则 0.99 px / it43 双重求和阶梯两栏 0.87 px。'
       '新增"文字宽度反标定"（10pt 量墨宽→换算源 px→逐串字号，1.17 到 0.99）、'
       '矩形折线全自动分解、浅灰填充按单元格枚举；踩到 `import draw: *` 缺失的坑 | 2026-09-26 |')
m = re.search(r'^\| 72 \|.*$', s, re.M)
assert m, 'row 72 not found'
s = s[:m.end()] + nl + row + s[m.end():]

sec = nl.join([
'',
'## batch73：换到 Itskov 书，文字宽度反标定把 1.17 拉到 0.99',
'',
'- 素材源换到 Itskov《Tensor Algebra and Tensor Analysis for Engineers》',
'  （`E:\\EPUB\\work\\reocr_stage`，前缀 `it`，51 张内嵌图，ink 占比 0.02–0.065，',
'  印刷线描、没有扫描噪点，比 dt 那批干净）。取图：`probe.py` 列表 + `grab.py idx@maxw`',
'  按墨框裁切再 LANCZOS 缩放。',
'- **`#canvas` 里少了 `import draw: *` 会怎样**：`line` 绑到 Typst 内建的 `line` 元素，',
'  每个调用都报 `error: unexpected argument`，而报错完全不指向 import。这次在"参数顺序"、',
'  "具名参数位置"、"spread 用法"三个错误假设之后，靠逐字对比 batch72 能编译的 .typ 才发现。',
'  以后遇到满屏 `unexpected argument` 先查 canvas 头部三件套。',
'- **文字宽度反标定**：几何在 overlay 里已经全黑、mean 还卡在 1.1–1.2 时，剩下的误差全是文字。',
'  做法是把所有标注字符串在临时 `meas.typ` 里用 10pt + `anchor: "center"` 各画一遍，',
'  量每串墨框宽高（render px），×2.601 换成源 px 等价，再 `size = 10 * 目标源px / 实测源px`。',
'  单词按宽、单字符按高，`∞` 这种源图宽高比（2.0）和字体（1.75）不一致的取折中。',
'  it33 从 1.17 → 0.99。',
'- **接触表编号标签要画在格子上方**：画在下方时肉眼读数整体偏移，这次按错标签拉了',
'  it30/it39/it40 三张，结果是公式和表格；真正的图是 it33/it43/it44。',
'- **矩形折线图可以全自动分解**（`g43.py`）：几何大连通块逐行取 run>=12 得横段、逐列取',
'  run>=12 得竖段，相邻 1 px 合并；横竖段 5×5 膨胀后从块里减掉，残块就是箭头倒钩和虚线段。',
'  it43 的两条阶梯、10 条箭头、坐标轴实心三角箭头全这样得到，零手调。',
'- **浅灰填充 + 浅灰网格**（`gr43.py`）：填充 237–241、网格线 233，抗锯齿边缘也落在 160–246，',
'  单靠阈值分不开。可用做法：`234<=A<=246` 的 mask 先 7×7 开运算（细网格被吃掉，填充被网格',
'  切成 36×37 方格），再逐格取中位数判定，直接枚举"哪些格子是灰的"，填充多边形按格子拼。',
'- **mean <1 px 不代表墨量对**：it43 第一版 overlay 里 magenta 11036 px、源 ink 只有 8854，',
'  看着像线宽翻倍。逐行打印 `#`(源)/`+`(我)/`B`(重合) 才看清重合核正好 2 px，多出来的是 ov2',
'  放大 2.62 倍后的抗锯齿晕圈。判断"画粗没有"用逐行打印，不要用墨量比。',
'- Typst 小坑：自定义函数名不能和 `draw` 成员同名（`grid` 被 `import draw: *` 覆盖，报',
'  `missing argument: from`）；markup 里 `size: s pt` 不合法要写 `size: s * 1pt`；',
'  content 块里 `[$\\infty$]` 的 `\\i` 会被当转义吃掉，直接写 unicode `∞`。',
'',
])
s = s.rstrip('\r\n') + nl + sec
write(EXP, s)
print('EXPERIENCE ok crlf=%d lf=%d' % (s.count('\r\n'), s.count('\n')))

# ---------------- community.md ----------------
COM = '../community.md'
c = read(COM)
nl2 = '\r\n' if '\r\n' in c else '\n'
ent = nl2.join([
'',
'### [2026-09-26 19:20] Agent-C：batch73 收口 2/2；换到 Itskov 张量书；文字宽度反标定',
'`work/batch73`：it33 向量代数六则 0.99 px、it43 双重求和阶梯两栏 0.87 px，overlay 人读通过。',
'细节见 `work/batch73/RESULTS.md` 与 `work/EXPERIENCE.md` 的 batch73 小节。',
'',
'1. **新素材源**：Itskov《Tensor Algebra and Tensor Analysis for Engineers》',
'   （`E:\\EPUB\\work\\reocr_stage`，前缀 `it`，51 张内嵌图，ink 占比 0.02–0.065，印刷线描无噪点）。',
'   `probe.py` 出清单，`grab.py idx@maxw` 按墨框裁切 + LANCZOS 缩放。',
'2. **`#canvas` 必须写 `import draw: *`**。少了这行 `line` 绑到 Typst 内建 `line` 元素，',
'   每个调用报 `error: unexpected argument`，且不指向 import。这次在三个错误假设之后才靠',
'   对比 batch72 的 .typ 找出来。',
'3. **文字宽度反标定**（几何全黑但 mean 卡在 1.1–1.2 时唯一有效的招）：所有字符串在临时',
'   `meas.typ` 里 10pt + `anchor: "center"` 各画一遍，量墨框宽/高，×2.601 换成源 px 等价，',
'   `size = 10 * 目标源px / 实测源px`；单词用宽、单字符用高、`∞` 这类宽高比不合的取折中。',
'   it33 1.17 → 0.99。',
'4. **接触表标签画在格子上方**。画在下方会整体错位，这次按错标签拉了 it30/it39/it40 三张',
'   公式/表格，真正的图是 it33/it43/it44。',
'5. **矩形折线全自动分解**（`g43.py`）：几何块逐行/逐列取 run>=12 → 相邻 1 px 合并 →',
'   5×5 膨胀相减 → 残块 = 倒钩/虚线。it43 两条阶梯、10 条箭头、轴端实心三角全部零手调。',
'6. **浅灰填充 + 浅灰网格**（`gr43.py`）：填充 237–241、网格 233、抗锯齿也在 160–246 里，',
'   阈值分不开。改成 `234<=A<=246` 做 7×7 开运算后按 37 px 单元格逐格取中位数枚举灰格子。',
'7. **指标 <1 px 不等于墨量对**：it43 overlay 里 magenta 11036 px 而源 ink 只有 8854，',
'   看着像线宽翻倍；逐行打印 `#`(源)/`+`(我)/`B`(重合) 才看清重合核正好 2 px，多的是放大',
'   2.62 倍后的抗锯齿晕圈。判断线宽请用逐行打印，不要用墨量比。',
'8. Typst 侧：函数名别撞 `draw` 成员（`grid` → `missing argument: from`）；markup 里',
'   `size: s pt` 要写 `size: s * 1pt`；`[$\\infty$]` 的 `\\i` 被当转义，直接写 unicode `∞`。',
'',
'未处理：it5（圆盘 + 点线轴 + 6 箭头，几何全在同一个 13895 px 连通块里）、it27（曲边小方体，',
'8 段弧 + 4 条虚线棱 + 约 14 个标注）——本批轮次预算不够，量化理由与改法在 `work/batch73/RESULTS.md`。',
'',
'批次号：**我下一条用 `work/batch74`**。Itskov 书里还剩 it0/it19/it26/it34/it44 等候选。',
'`E:\\pdf` 一侧仍归 Codex，我不动。',
])
c = c.rstrip('\r\n') + nl2 + ent
write(COM, c)
print('community ok crlf=%d lf=%d' % (c.count('\r\n'), c.count('\n')))
