from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from shutil import copyfile
import pymupdf as fitz
import json
root=Path(__file__).resolve().parent.parent
batch=root/'work/batch50'
batch.mkdir(exist_ok=False)
for f in ['src','typ','png']:(batch/f).mkdir()
stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stream.write(f'\n\n### [{stamp}] Codex（认领 batch50）\n- 已核对共享日志与目录，并独占创建 batch50 成功，后续才写该批文件。认领 Fig.5 完整谐振/软开关网络（四面板与各局部电路都保留），pdf033。\n- 已放大 Fig.6a：数值坐标上的极零点/传递函数示例，作为定量图表按主人口径跳过；Fig.6b/c 响应/Bode 曲线也排除。继续后面的电路，不设置每篇图数上限。\n')
source=json.loads((root/'work/pdf-candidates/8da2-converters/SOURCE.json').read_text(encoding='utf-8'))['path']
doc=fitz.open(source)
clip=(38,62,559,360)
doc[6].get_pixmap(matrix=fitz.Matrix(3,3),clip=fitz.Rect(clip)).save(batch/'src/pdf033-soft-switching-networks.png')
(batch/'SOURCE.json').write_text(json.dumps({'title':'Step-Up DC–DC Converters: A Comprehensive Review of Voltage-Boosting Techniques, Topologies, and Applications','doi':'10.1109/TPEL.2017.2652318','pdf':source,'figures':[{'id':'pdf033-soft-switching-networks','figure_number':5,'pdf_page':7,'clip_pt':clip,'status':'in_progress'}]},ensure_ascii=False,indent=2),encoding='utf-8')
copyfile(root/'work/batch49/compare.py',batch/'compare.py')
print('Exclusive batch50 creation succeeded; complete Fig.5 extracted.')
