# 质量报告 · Figure as Code

## 规模

- 图文件：**361** 个 `.typ`，分布在 **239** 个 batch；另有 2 个图元测试在 `assets/tests/`，不进入语料清单。
- 依赖：Typst 0.15.1、CeTZ 0.4.2；每图自包含，无外部图片资源。

## 编译门槛

```bash
python tools/compile_all.py --jobs 4
```

当前结果（2026-11-14）：

```
{"figures": 361, "compiled": 361, "failed": 0, "warnings": 36}
```

- 361/361 编译成功，0 失败。
- 36 条 warning 为字体提示，集中在 3 个文件：
  - `figures/batch221/typ/adhesive-capture-mechanism.typ`：`liberation serif` 不存在。
  - `figures/batch63/typ/gt017-triangulation.typ`、`gt022-threegraphs.typ`：正文数学 `$...$` 的当前字体不是数学字体，渲染可能偏差。
- 这些 warning 不阻断编译；为保证版面视觉未被脚本改动，暂不改字体，保留在 `MANIFEST.csv` 的 `warnings` / `warning_sample` 字段。

## 清单

`MANIFEST.csv` 每行一图：`path, batch, sha1, bytes, compile, warnings, warning_sample`。由 `tools/compile_all.py` 生成，可重跑。

## 已知边界

- 编译成功不等于视觉正确：文字重叠、箭头穿越、留白仍需按 README 的人工视觉复核流程检查。
- 原论文插图版权归各作者；本仓库只对重绘源码主张 MIT。

## Typst 源码风格

在 `style-typst` 分支完成（标准 `tools/TYPST_STYLE.md`，量具 `tools/style_audit.py`）。
361 个文件：装饰横幅 496→0，>120 字符行 421→361（每图保留一条 `#figure(...)` 调用），
裸 LaTeX 30→28（剩余全在 `//` 注释），`$\hat(e)_r$` 等 2 处改为 Typst 语义符号。
逐项读数与剩余项判定见 [STYLE_AUDIT.md](STYLE_AUDIT.md)。编译门槛不变：361/361，0 失败。
