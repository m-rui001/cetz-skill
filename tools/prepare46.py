from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from shutil import copyfile
from PIL import Image
import json

root=Path(__file__).resolve().parent.parent
batch=root/'work/batch46'
batch.mkdir(exist_ok=False)
for folder in ['src','typ','png']:(batch/folder).mkdir()
with (root/'community.md').open('a',encoding='utf-8') as stream:
    stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y-%m-%d %H:%M')
    stream.write(f'\n\n### [{stamp}] Codex（认领 batch46）\n- 已核对日志及目录，batch43 属 Agent-C，batch45 芯片图已终止，batch46 空闲。\n- 认领 batch46，处理 Fig.6 中 Bob 平面分束探测光路、Alice 激光输入链、偏振球概念示意，编号 pdf026–028；地图背景和立体芯片明确排除，保留原始参考不修改。\n')
entries=[('pdf026-bob-polarization-optics',1113,(170,0,386,78),'(4) Bob flat optical overlay'),
         ('pdf027-alice-input-optics',1119,(0,26,168,75),'(4) Alice flat input chain; excludes PIC'),
         ('pdf028-polarization-sphere',1127,(464,123,569,215),'(2)d conceptual polarization modulation sphere')]
figs=[]
for name,xref,box,panel in entries:
    Image.open(root/f'work/batch45/screen/xref-{xref}.png').crop(box).save(batch/f'src/{name}.png')
    figs.append({'id':name,'xref':xref,'crop_px':box,'panel':panel})
(batch/'SOURCE.json').write_text(json.dumps({'title':'Advances in Quantum Cryptography','pdf':'E:/pdf/pdfonly-stem/pdfcorpus/out/pdfs/epr/4f/4f53c97362c66632bad047e1440e69ed41896204.pdf','pdf_page':40,'figure_number':6,'figures':figs,
 'excluded_visual_layers':['aerial photograph background in xref1113/1119','perspective PIC adjoining Alice input chain'],'comparison_scope':'compare optical overlay positions, topology and labels; aerial background excluded'},ensure_ascii=False,indent=2),encoding='utf-8')
copyfile(root/'work/batch45/compare.py',batch/'compare.py')
print('Claimed batch46 and isolated three schematic regions.')
