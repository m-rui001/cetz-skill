"""Compile every figure and write MANIFEST.csv.

Usage: python tools/compile_all.py [--jobs 4]
"""
import os, sys, csv, json, hashlib, subprocess, argparse, tempfile
from concurrent.futures import ThreadPoolExecutor

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def compile_one(rel):
    src = os.path.join(ROOT, rel)
    out = os.path.join(tempfile.gettempdir(), "figure-as-code-build", rel.replace("/", "_") + ".pdf")
    os.makedirs(os.path.dirname(out), exist_ok=True)
    p = subprocess.run(["typst", "compile", "--root", ROOT, src, out], capture_output=True)
    err = p.stderr.decode("utf-8", "replace")
    warnings = [l for l in err.splitlines() if l.strip().startswith("warning:")]
    b = open(src, "rb").read()
    batch = rel.split("/")[1] if "/" in rel else ""
    return {
        "path": rel, "batch": batch, "sha1": hashlib.sha1(b).hexdigest(), "bytes": len(b),
        "compile": int(p.returncode == 0), "warnings": len(warnings),
        "warning_sample": " | ".join(warnings[:2])[:200],
    }

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--jobs", type=int, default=4)
    args = ap.parse_args()
    files = sorted(
        os.path.relpath(os.path.join(r, f), ROOT).replace(os.sep, "/")
        for r, _, fs in os.walk(os.path.join(ROOT, "figures")) for f in fs if f.endswith(".typ")
    )
    with ThreadPoolExecutor(max_workers=args.jobs) as ex:
        rows = list(ex.map(compile_one, files))
    with open(os.path.join(ROOT, "MANIFEST.csv"), "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)
    ok = sum(r["compile"] for r in rows)
    print(json.dumps({"figures": len(rows), "compiled": ok, "failed": len(rows) - ok,
                      "warnings": sum(r["warnings"] for r in rows)}, ensure_ascii=False))
    return 0 if ok == len(rows) else 1

if __name__ == "__main__":
    sys.exit(main())
