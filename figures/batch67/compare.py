"""Arrange the original crop above the CeTZ render at a common width."""
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).parent

def prepare(path, width=1000):
    image = Image.open(path).convert('RGB')
    ink = image.convert('L').point(lambda value: 255 if value < 245 else 0)
    box = ink.getbbox()
    if box:
        image = image.crop(box)
    image = image.resize((width, round(image.height * width / image.width)), Image.Resampling.LANCZOS)
    return image

for original in sorted((ROOT / 'src').glob('*.png')):
    rendered = ROOT / 'png' / original.name
    if not rendered.exists():
        continue
    top, bottom = prepare(original), prepare(rendered)
    sheet = Image.new('RGB', (1040, top.height + bottom.height + 104), 'white')
    draw = ImageDraw.Draw(sheet)
    draw.text((20, 8), 'Original', fill='red')
    sheet.paste(top, (20, 30))
    draw.text((20, top.height + 56), 'CeTZ', fill='blue')
    sheet.paste(bottom, (20, top.height + 78))
    sheet.save(ROOT / f'cmp_{original.name}')
