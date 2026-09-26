import os, pathlib, subprocess, sys

ROOT = pathlib.Path(r"D:\cetz-skill-release")
OUT = ROOT / "previews"
files = sorted((ROOT / "figures").glob("batch*/typ/*.typ"))
print("to render:", len(files), flush=True)
ok, bad = 0, []
for f in files:
    rel = f.relative_to(ROOT).with_suffix("")
    dst = OUT / (str(rel.parent.parent.name) + "__" + rel.name + ".png")
    dst.parent.mkdir(parents=True, exist_ok=True)
    r = subprocess.run(
        ["typst", "compile", "--root", str(ROOT), "--font-path", r"C:\Windows\Fonts",
         "--input", "sys.inputs.name=" + f.stem, str(f), str(dst)],
        capture_output=True, text=True)
    if r.returncode == 0 and dst.exists():
        ok += 1
    else:
        bad.append((str(f.relative_to(ROOT)), (r.stderr or "").strip().splitlines()[:1]))
        dst.unlink(missing_ok=True)
print("ok:", ok, "failed:", len(bad), flush=True)
for b in bad[:40]:
    print("  ", b[0], "|", b[1], flush=True)
