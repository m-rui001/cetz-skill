from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from PIL import Image, ImageDraw

root=Path(__file__).resolve().parents[2]
batch=Path(__file__).parent
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
experience=root/'work/EXPERIENCE.md'
if '## batch44：完整复合图与 PDF 标注层' not in experience.read_text(encoding='utf-8'):
    with experience.open('a',encoding='utf-8') as stream:
        stream.write('\n\n## batch44：完整复合图与 PDF 标注层\n\n'
                     '- 两幅完整组合版 2/2 通过，复用 7 个已通过 CeTZ 面板，不重复计入新转绘数量。原图放置坐标、面板墨迹范围、宽高与字母位置形成布局依据。\n'
                     '- 图像的 PDF 放置矩阵可能改变横纵比例：本篇 Fig.10a 的图片在页面中压缩了纵向；原生单面板按内嵌原图比对，完整组合版按页面放置尺寸还原。\n'
                     '- 组合输出保持矢量：各面板函数复制到一份 .typ，用 measure 和 scale 缩放全部内容（含描边/文字），不嵌入生成 PNG。\n'
                     '- scale(x:,y:) 接受 ratio，两个长度相除得到 float，须乘 100%。\n'
                     '- 内嵌图片不总是最终页面：Fig.4d 的页面用新的文本/箭头盖掉并补充图片标签。只核对内嵌原图会漏掉这些内容；完整 PDF 比对后补齐新标注与原生箭头路径。\n'
                     '- draw.hide 同样遮蔽 Typst hide。在导入 draw:* 前 alias（hidden-text = hide），才能隐藏标签文字且保留测量范围；与 rotate 的遮蔽规则一致。\n'
                     '- 同分钟抢号仍可能同时通过日志/目录检查。本轮由 Codex 让出 batch42，只逐个移动明确属于自己的 12 个文件至 batch44，外国前缀文件保持原样；日志写明处理结果。\n')
log=root/'community.md'
if 'Codex（batch44 收口）' not in log.read_text(encoding='utf-8'):
    with log.open('a',encoding='utf-8') as stream:
        stream.write(f'\n\n### [{stamp}] Codex（batch44 收口）\n'
                     '- 原 batch42 的 PDF 组合任务已协调移至 batch44；pdf021 Fig.4 与 pdf022 Fig.10 完整组合版 2/2 通过，视觉重试 2/0，原生自包含 CeTZ 源码/300 ppi PNG/原图/逐图比对/SOURCE.json/RESULTS.md 已齐。\n'
                     '- 组合版使用 PDF 面板位置和尺寸，补齐 Fig.4d 最终页面的外加标注、耦合器箭头和脉冲符号；保留完整支路。预览 work/PDF-PREVIEW-6.png。\n'
                     '- 复用 7 块已转绘面板，不重复计为新转绘内容。按同篇 20 个图号：13 整图通过、Fig.8 白底局部通过且照片排除、5 数据曲线按主人要求排除、Fig.6 示意部分仍待处理。下一新图号 pdf023。\n'
                     '- 总体目标未完成，无阻塞；本轮为具体进展。下一步继续 Fig.6 芯片/光路示意。\n')
tiles=[]
for name in ['pdf021-dv-qkd-complete','pdf022-cv-qkd-complete']:
    img=Image.open(batch/f'png/{name}.png').convert('RGB')
    box=img.convert('L').point(lambda v:255 if v<245 else 0).getbbox()
    if box:img=img.crop(box)
    img.thumbnail((1000,1100))
    tile=Image.new('RGB',(1040,img.height+70),'white')
    ImageDraw.Draw(tile).text((20,12),name,fill='#444444')
    tile.paste(img,((1040-img.width)//2,45))
    tiles.append(tile)
sheet=Image.new('RGB',(1040,sum(t.height for t in tiles)+20),'#eeeeee')
y=0
for tile in tiles:
    sheet.paste(tile,(0,y));y+=tile.height+20
sheet.save(root/'work/PDF-PREVIEW-6.png')
print('Recorded batch44 and preview.')
