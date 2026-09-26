"""Correct the native circuit helpers owned by Codex; no source-corpus writes."""
from pathlib import Path
root=Path(__file__).resolve().parents[2]
p=root/'work/batch49/draw.py'
t=p.read_text(encoding='utf-8')
t=t.replace('wire(((x,y + 3),(x,y + 18)))','wire(((x,y + 1.25),(x,y + 18)))')
t=t.replace('wire(((x - 22,y),(x - 3,y)))','wire(((x - 22,y),(x - 1.25,y)))')
p.write_text(t,encoding='utf-8')
p=root/'work/batch47/typ/pdf030-converter-isolation-structures.typ'
t=p.read_text(encoding='utf-8')
t=t.replace('wire(((x - 17,y),(x - 3,y)))','wire(((x - 17,y),(x - (if curved {1.5} else {3}),y)))')
t=t.replace('wire(((x,y + 3),(x,y + 17)))','wire(((x,y + (if curved {1.5} else {3})),(x,y + 17)))')
p.write_text(t,encoding='utf-8')
print('Corrected batch47/49 helper junctions; batch50 inherits corrected batch49 header.')
