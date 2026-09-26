from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from shutil import copyfile
import pymupdf as fitz
import json
root=Path(__file__).resolve().parent.parent
batch=root/'work/batch48'
batch.mkdir(exist_ok=False)
for f in ['src','typ','png']:(batch/f).mkdir()
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'\n\n### [{stamp}] Codex（认领 batch48）\n- 已核对日志和目录，batch48 空闲，认领综述 Fig.3 单向/双向四组电路、Fig.4 电压/电流馈电完整结构，pdf031/032。\n- Fig.4 图内还有 (d) 辅助变压器方案，虽然图注只列前三项，也保留 (d)，不遗漏原图面板。\n')
source=json.loads((root/'work/pdf-candidates/8da2-converters/SOURCE.json').read_text(encoding='utf-8'))['path']
doc=fitz.open(source)
items=[('pdf031-directional-converters',5,3,(40,63,295,613)),('pdf032-voltage-current-fed',6,4,(40,63,295,505))]
figures=[]
for name,page,fig,clip in items:
    doc[page-1].get_pixmap(matrix=fitz.Matrix(3,3),clip=fitz.Rect(clip)).save(batch/f'src/{name}.png')
    figures.append({'id':name,'figure_number':fig,'pdf_page':page,'clip_pt':clip,'status':'in_progress'})
(batch/'SOURCE.json').write_text(json.dumps({'title':'Step-Up DC–DC Converters: A Comprehensive Review of Voltage-Boosting Techniques, Topologies, and Applications','doi':'10.1109/TPEL.2017.2652318','pdf':source,'figures':figures},ensure_ascii=False,indent=2),encoding='utf-8')
copyfile(root/'work/batch47/compare.py',batch/'compare.py')
print('Claimed batch48 and extracted complete Fig.3/4.')
