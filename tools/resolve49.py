from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from shutil import move,copyfile
import json
import pymupdf as fitz
root=Path(__file__).resolve().parent.parent
work=(root/'work').resolve()
old=(work/'batch48').resolve()
batch=(work/'batch49').resolve()
assert old.is_relative_to(work) and batch.is_relative_to(work)
batch.mkdir(exist_ok=False)
for name in ['typ','src','png']:(batch/name).mkdir()
own=['draw.py','typ/pdf031-directional-converters.typ','typ/pdf032-voltage-current-fed.typ','png/pdf031-directional-converters.png','png/pdf032-voltage-current-fed.png']
for name in own:
    src=(old/name).resolve();dst=(batch/name).resolve()
    assert src.is_relative_to(old) and dst.is_relative_to(batch)
    assert src.is_file() and not dst.exists()
    move(src,dst)
source=json.loads((work/'pdf-candidates/8da2-converters/SOURCE.json').read_text(encoding='utf-8'))['path']
doc=fitz.open(source)
items=[('pdf031-directional-converters',5,3,(40,63,295,613)),('pdf032-voltage-current-fed',6,4,(40,63,295,505))]
figures=[]
for name,page,fig,clip in items:
    doc[page-1].get_pixmap(matrix=fitz.Matrix(3,3),clip=fitz.Rect(clip)).save(batch/f'src/{name}.png')
    figures.append({'id':name,'figure_number':fig,'pdf_page':page,'clip_pt':clip,'status':'in_progress'})
(batch/'SOURCE.json').write_text(json.dumps({'title':'Step-Up DC–DC Converters: A Comprehensive Review of Voltage-Boosting Techniques, Topologies, and Applications','doi':'10.1109/TPEL.2017.2652318','pdf':source,'figures':figures},ensure_ascii=False,indent=2),encoding='utf-8')
copyfile(work/'batch47/compare.py',batch/'compare.py')
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'\n\n### [{stamp}] Codex（认领 batch49；避开 batch48）\n- 初次检查后，Agent-C 在 13:25 先认领并建立 batch48；我的原子 mkdir 已报占用，但随后的工具调用生成了 pdf031/pdf032 两份源码和 PNG。现改用此前空闲、独占创建的 batch49，只将这 4 个 pdf 文件及我生成的 draw.py 移入49，其他 dt/工具文件留在48。batch48 归 Agent-C。\n- batch49 处理综述完整 Fig.3 单向/双向四组电路和 Fig.4 电压/电流馈电结构，pdf031/032，继续实际视觉验收；Fig.4 图内 (d) 辅助变压器方案也保留，虽然图注只列前三项。\n- 后续原子 mkdir 失败必须先处理占用，停止所有该批依赖写入；避免检查与创建之间的并发抢号。\n')
print('Moved five specifically identified files to exclusively created batch49; reference images ready.')
