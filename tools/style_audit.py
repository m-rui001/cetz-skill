"""Deterministic Typst code-style audit. Numbers only; no rewriting."""
import os, re, sys, csv, glob, collections, argparse

SET_SHOW = re.compile(r"^\s*#(?:set|show)\b")
LABEL = re.compile(r"<([^>\s]+)>")
LET = re.compile(r"#let\s+([A-Za-z][\w-]*)")
BANNER = re.compile(r"//\s*[-=*#]{3,}")
RAW_TEX = re.compile(r"\\[A-Za-z]{2,}")
VH = re.compile(r"#(?:v|h)\(")
IMPORT = re.compile(r"^#import\s+\"([^\"]+)\"")


def audit(root, pats):
    files = []
    for p in pats:
        files += glob.glob(os.path.join(root, p), recursive=True)
    files = sorted(set(f for f in files if "_build" not in f.replace("\\", "/").split("/")))
    lets = collections.defaultdict(set)
    rows = []
    for f in files:
        raw = open(f, "rb").read()
        t = raw.decode("utf-8", "replace").replace("\r\n", "\n").replace("\r", "\n")
        lines = t.split("\n")
        code = [l for l in lines if not l.lstrip().startswith("//")]
        tabs = sum(1 for l in lines if "\t" in l)
        trail = sum(1 for l in lines if l.rstrip() != l)
        runs = 0
        run = 0
        for l in lines:
            if not l.strip():
                run += 1
                if run > 2:
                    runs += 1
            else:
                run = 0
        long_lines = sum(1 for l in code if len(l) > 120)
        maxlen = max((len(l) for l in code), default=0)
        sets = [(i + 1, l.strip()) for i, l in enumerate(lines) if SET_SHOW.match(l) and not l[:1].isspace()]
        midsets = [(i, l) for i, l in sets if i > 40]
        labels = LABEL.findall(t)
        bad_labels = [l for l in labels if not re.fullmatch(r"[a-z0-9]+(?:[-:.][a-z0-9]+)*", l)]
        lets_here = LET.findall(t)
        for n in lets_here:
            lets[n].add(os.path.relpath(f, root))
        comments = sum(1 for l in lines if l.lstrip().startswith("//"))
        banners = sum(1 for l in lines if BANNER.search(l))
        rows.append({
            "path": os.path.relpath(f, root).replace("\\", "/"),
            "lines": len(lines), "tabs": tabs, "trailing_ws": trail,
            "blank_runs": runs, "final_nl": 1 if t.endswith("\n") else 0,
            "long_gt120": long_lines, "max_len": maxlen,
            "set_show": len(sets), "midset": len(midsets),
            "comments": comments, "banners": banners,
            "raw_tex": len(RAW_TEX.findall(t)), "vh": len(VH.findall(t)),
            "labels": len(labels), "bad_labels": len(bad_labels),
            "lets": len(lets_here),
        })
    dup = {n: v for n, v in lets.items() if len(v) > 1}
    dup_in_file = []
    for f in files:
        t2 = open(f, encoding="utf-8", errors="replace").read()
        c = collections.Counter(LET.findall(t2))
        if any(v > 1 for v in c.values()):
            dup_in_file.append(os.path.relpath(f, root).replace("\\", "/"))
    return rows, dup, dup_in_file


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("repo")
    ap.add_argument("--glob", action="append", required=True)
    ap.add_argument("--out", default=None)
    a = ap.parse_args()
    rows, dup, dup_in_file = audit(os.path.abspath(a.repo), a.glob)
    out = a.out or os.path.join(r"D:\mxrlib\_audit", "style_" + os.path.basename(os.path.abspath(a.repo)) + ".csv")
    with open(out, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0]), lineterminator="\n")
        w.writeheader()
        w.writerows(rows)
    agg = {k: sum(r[k] for r in rows) for k in ("tabs", "trailing_ws", "blank_runs", "long_gt120",
                                                "midset", "banners", "raw_tex", "vh", "bad_labels")}
    print(os.path.basename(os.path.abspath(a.repo)), "files", len(rows), agg,
          "files_with_issues", sum(1 for r in rows if any(r[k] for k in ("tabs", "trailing_ws", "blank_runs", "long_gt120", "midset"))),
          "dup_lets_crossfile", len(dup), "dup_lets_in_file", len(dup_in_file))
    for n, v in list(dup.items())[:8]:
        print("  dup", n, len(v))
    print("->", out)


if __name__ == "__main__":
    main()
