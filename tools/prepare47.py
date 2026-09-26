from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from shutil import copyfile
import pymupdf as fitz
import json
root=Path(__file__).resolve().parent.parent
batch=root/'work/batch47'
batch.mkdir(exist_ok=False)
for f in ['src','typ','png']:(batch/f).mkdir()
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'\n\n### [{stamp}] Codex（认领 batch47）\n- 已核对日志和目录，batch47 空闲；认领升压变换器综述 Fig.1 完整分类树及 Fig.2 完整四组结构（框图与电路均保留），pdf029/030。\n- 本篇 34 图号清单已建立；不限定每篇图数，其他电路逐项继续。\n')
source=json.loads((root/'work/pdf-candidates/8da2-converters/SOURCE.json').read_text(encoding='utf-8'))['path']
doc=fitz.open(source)
items=[('pdf029-converter-classification',3,1,(117,65,482,145)),('pdf030-converter-isolation-structures',4,2,(40,64,558,238))]
figures=[]
for name,page,fig,clip in items:
    doc[page-1].get_pixmap(matrix=fitz.Matrix(3,3),clip=fitz.Rect(clip)).save(batch/f'src/{name}.png')
    figures.append({'id':name,'figure_number':fig,'pdf_page':page,'clip_pt':clip,'status':'in_progress'})
(batch/'SOURCE.json').write_text(json.dumps({'title':'Step-Up DC–DC Converters: A Comprehensive Review of Voltage-Boosting Techniques, Topologies, and Applications','doi':'10.1109/TPEL.2017.2652318','pdf':source,'figures':figures},ensure_ascii=False,indent=2),encoding='utf-8')
copyfile(root/'work/batch46/compare.py',batch/'compare.py')
print('Claimed batch47 and extracted two complete figures.')
