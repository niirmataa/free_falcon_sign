#!/usr/bin/env python3
"""Standard package replay (FT_FAMILY_SCALING_CORRECTIONS_RUN_003).

Usage:
    python3 scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA256

  ABSENT_DEST             a directory that must NOT exist yet; it is created
                          here and holds the replay MIRROR plus regenerated
                          outputs (fresh HOME/TMPDIR/cache under it);
  EXTERNAL_OUTPUTS_SHA256 sha256 of this package's OUTPUTS.sha256, pinned
                          OUTSIDE the package by the reviewer (no hash cycle).

Behaviour (TASK S01 section 5, REPLAY.md):
  1. full manifest validation BEFORE creating DEST;
  2. DEST must be absent (asserted);
  3. MIRROR at DEST/proofs/ft1536/work/pkg/ (+ DEST/Extra/c sources) keeps
     the historical five-level source path of check_fft3_error.py;
  4. fresh project cache under DEST; every step network-off (unshare -rn);
  5. deterministic steps regenerate the pre-registered byte list of
     SEMANTIC_FILES.json; every entry is byte-compared against the manifest
     (matches[{path,sha256}], mismatches=[] expected);
  6. PDF rebuilt SEPARATELY (semantic only);
  7. child record REPLAY_RESULT.json written into DEST.

Exit 0 on FRESH_REPLAY_PASS.
"""
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys

PKG = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MIRROR_REL = os.path.join("proofs", "ft1536", "work", "pkg")
SAGE = "/home/footfalcon/.local/bin/sage"
MINIFORGE_PY = "/home/footfalcon/miniforge3/envs/sage/bin/python"
LEAN = ("/home/footfalcon/.elan/toolchains/"
        "leanprover--lean4---v4.34.0/bin/lean")

# Deterministic steps: (argv-template, label, stdout_capture_rel_or_None,
# required).  {py}=python3, {sage}=sage (preparser), {mpy}=miniforge sage
# python for the historical pinned .py runners (their own documented mode),
# {lean}=lean.  "required" = the step produces files of the pre-registered
# byte list or the input-validation control; FRESH_REPLAY_PASS requires all
# required steps to exit 0 and mismatches == [].  Non-required steps are the
# heavy SEMANTIC reproductions (judged by proof/receipts/reproduction_receipt
# .json and pdf_semantic; always run, always recorded).
STEPS = [
    ("{sage} scripts/lemma_chi_tail.sage", "lemma_chi_tail",
     "results/check_chi_tail.log", True),
    ("{py} scripts/check_geometry.py", "check_geometry",
     "results/check_geometry.log", True),
    ("{py} scripts/check_layout.py", "check_layout",
     "results/check_layout.log", True),
    ("{py} scripts/check_bounds_table.py", "check_bounds_table",
     "results/check_bounds_table.log", True),
    ("{py} scripts/gen_layout_table.py", "gen_layout_table", None, True),
    ("{py} scripts/gen_layout_table.py --check PARAMETRIC_TASK_LAYOUT.md",
     "layout_table_check", None, True),
    ("{sage} scripts/lemma_controls.sage", "lemma_controls",
     "results/check_controls.log", True),
    ("{py} scripts/test_r4_routing.py", "test_r4_routing",
     "results/check_r4_routing.log", True),
    ("{mpy} scripts/check_fft3_error.py", "check_fft3_error_historical",
     "results/check_fft3_error.log", False),
    ("{sage} scripts/sage_exact.sage", "sage_exact_historical",
     "results/sage_exact.log", False),
    ("{py} scripts/verify_inputs.py", "verify_inputs",
     "proof/checks/00_verify_inputs.log", True),
    ("{lean} -j1 -M2048 -o .build/lean/FTA2.olean lean/FTA2.lean",
     "lean_FTA2", "results/lean_FTA2.log", True),
    ("{lean} -j1 -M2048 -o .build/lean/FTLayout.olean lean/FTLayout.lean",
     "lean_FTLayout", "results/lean_FTLayout.log", True),
    ("{lean} -j1 -M2048 -o .build/lean/FTRoots.olean lean/FTRoots.lean",
     "lean_FTRoots", "results/lean_FTRoots.log", True),
    ("{lean} -j1 -M2048 -o .build/lean/FTBounds.olean lean/FTBounds.lean",
     "lean_FTBounds", "results/lean_FTBounds.log", True),
    ("{lean} -j1 -M2048 proof/checkers/AxiomAudit.lean", "lean_AxiomAudit",
     "results/lean_AxiomAudit.log", True),
]


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def parse_sumfile(path):
    out = {}
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.rstrip("\n")
            if not line.strip():
                continue
            m = re.match(r"^([0-9a-f]{64}) [ *](.+)$", line)
            if not m:
                raise SystemExit("manifest parse error: " + line)
            out[m.group(2)] = m.group(1)
    return out


def walk_regular(root):
    reg = []
    for dirpath, _dirnames, filenames in os.walk(root):
        for fn in filenames:
            p = os.path.join(dirpath, fn)
            if os.path.isfile(p) and not os.path.islink(p):
                reg.append(os.path.relpath(p, root).replace(os.sep, "/"))
    return sorted(reg)


def run_step(cmdline, cwd, env, capture_rel):
    argv = cmdline.split()
    wrapped = ["unshare", "-rn", "--"] + argv
    sandbox = "network-off:unshare -rn"
    try:
        proc = subprocess.run(wrapped, cwd=cwd, env=env,
                              capture_output=True, text=True, timeout=5400)
    except FileNotFoundError:
        proc = subprocess.run(argv, cwd=cwd, env=env,
                              capture_output=True, text=True, timeout=5400)
        sandbox = "fallback:no-unshare"
    if capture_rel:
        target = os.path.join(cwd, capture_rel)
        os.makedirs(os.path.dirname(target), exist_ok=True)
        with open(target, "w", encoding="utf-8") as f:
            f.write(proc.stdout)
            f.write(proc.stderr)   # combined, matching `> f 2>&1`
    return proc.returncode, sandbox


def main(argv):
    if len(argv) != 3:
        print(__doc__)
        return 2
    dest, ext_sha = argv[1], argv[2].lower()

    # ---- 1. full manifest validation BEFORE creating DEST
    man = os.path.join(PKG, "OUTPUTS.sha256")
    if not os.path.isfile(man):
        print("FAIL: package has no OUTPUTS.sha256 (run after freeze)")
        return 2
    man_sha = sha256_file(man)
    ok = man_sha == ext_sha
    print(("PASS" if ok else "FAIL") + " external pin of OUTPUTS.sha256 :: "
          + man_sha)
    if not ok:
        return 1
    members = parse_sumfile(man)
    problems = []
    for rel, want in members.items():
        p = os.path.join(PKG, rel)
        if not os.path.isfile(p) or os.path.islink(p):
            problems.append(rel + ": missing")
        elif sha256_file(p) != want:
            problems.append(rel + ": hash")
    expected = set(members)
    actual = set(walk_regular(PKG)) - {"OUTPUTS.sha256"}
    actual -= set(x for x in actual
                  if x.startswith(("inputs/", "home/", "tmp/", ".build/",
                                   "postfreeze/")))
    if expected != actual:
        problems.append("set mismatch: missing=%s extra=%s"
                        % (sorted(expected - actual)[:5],
                           sorted(actual - expected)[:5]))
    print(("PASS" if not problems else "FAIL") + " manifest validation :: "
          + ("%d members" % len(members) if not problems else str(problems)))
    if problems:
        return 1

    # ---- 2. DEST must be absent
    if os.path.exists(dest):
        print("FAIL: DEST exists (ABSENT_DEST required):", dest)
        return 1

    # ---- 3/4. mirror + fresh cache
    os.makedirs(dest)
    mirror = os.path.join(dest, MIRROR_REL)
    shutil.copytree(PKG, mirror,
                    ignore=shutil.ignore_patterns(
                        "home", "tmp", ".build", "artifacts"))
    os.makedirs(os.path.join(mirror, ".build", "lean"), exist_ok=True)
    repo_c = os.path.normpath(os.path.join(
        PKG, "..", "..", "..", "..", "Extra", "c"))
    os.makedirs(os.path.join(dest, "Extra", "c"), exist_ok=True)
    for fn in sorted(os.listdir(repo_c)):
        s = os.path.join(repo_c, fn)
        if os.path.isfile(s):
            shutil.copy2(s, os.path.join(dest, "Extra", "c", fn))
    for sub in ("home", "tmp"):
        os.makedirs(os.path.join(dest, sub), exist_ok=True)
    env = dict(os.environ)
    env.update({
        "HOME": os.path.join(dest, "home"),
        "TMPDIR": os.path.join(dest, "tmp"),
        "TMP": os.path.join(dest, "tmp"),
        "TEMP": os.path.join(dest, "tmp"),
        "DOT_SAGE": os.path.join(dest, "home", ".sage"),
        "FT1536_PKG_ROOT": mirror,
        "LEAN_PATH": os.path.join(mirror, ".build", "lean"),
    })

    # ---- 5. deterministic steps + hash matches against the manifest
    # Anti-stale guard: remove every to-be-regenerated target in the mirror
    # BEFORE running the steps, so a crashed producer leaves the file MISSING
    # (never a vacuous match against the copied original).
    with open(os.path.join(mirror, "SEMANTIC_FILES.json"),
              encoding="utf-8") as f:
        spec = json.load(f)
    for rel in spec["byte_deterministic"]:
        p = os.path.join(mirror, rel)
        if os.path.isfile(p):
            os.remove(p)

    step_log = []
    for template, label, capture_rel, required in STEPS:
        cmdline = (template.replace("{py}", sys.executable)
                   .replace("{sage}", SAGE)
                   .replace("{mpy}", MINIFORGE_PY)
                   .replace("{lean}", LEAN))
        rc, sandbox = run_step(cmdline, mirror, env, capture_rel)
        step_log.append({"step": label, "cmd": cmdline, "exit": rc,
                         "sandbox": sandbox, "required": required})
        print("step", label, "exit", rc, sandbox,
              "" if required else "(semantic)")

    with open(os.path.join(mirror, "SEMANTIC_FILES.json"),
              encoding="utf-8") as f:
        spec = json.load(f)
    matches, mismatches = [], []
    for rel in spec["byte_deterministic"]:
        p = os.path.join(mirror, rel)
        got = sha256_file(p) if os.path.isfile(p) else None
        want = members.get(rel)
        if got is not None and got == want:
            matches.append({"path": rel, "sha256": got})
        else:
            mismatches.append({"path": rel, "expected": want, "got": got})
    # ---- 6. PDF rebuild separately (semantic)
    pdf = subprocess.run(
        ["sh", "-c",
         "cd paper && pdflatex -interaction=nonstopmode main.tex >/dev/null "
         "&& bibtex main >/dev/null 2>&1; pdflatex -interaction=nonstopmode "
         "main.tex >/dev/null; pdflatex -interaction=nonstopmode main.tex"],
        cwd=mirror, env=env, capture_output=True, text=True, timeout=1800)
    rebuilt = os.path.join(mirror, "paper", "main.pdf")

    def pdf_text(path):
        try:
            return subprocess.run(["pdftotext", path, "-"],
                                  capture_output=True,
                                  text=True).stdout
        except FileNotFoundError:
            return None

    new_txt = pdf_text(rebuilt) if os.path.isfile(rebuilt) else None
    ref_txt = pdf_text(os.path.join(PKG, "paper", "main.pdf"))
    pdf_pages = new_txt.count("\f") + 1 if new_txt is not None else None
    pdf_semantic = {
        "rebuilt": os.path.isfile(rebuilt),
        "build_exit": pdf.returncode,
        "pages_pdftotext_method": pdf_pages,
        "text_sha256_rebuilt": (hashlib.sha256(new_txt.encode()).hexdigest()
                                if new_txt is not None else None),
        "text_sha256_package_pdf": (hashlib.sha256(ref_txt.encode()).hexdigest()
                                    if ref_txt is not None else None),
        "text_equal_to_package_pdf": (new_txt == ref_txt
                                     and new_txt is not None),
        "byte_identical_required": False,
    }

    # ---- 7. child record
    required_failures = [s["step"] for s in step_log
                         if s["required"] and s["exit"] != 0]
    semantic_failures = [{"step": s["step"], "exit": s["exit"]}
                         for s in step_log
                         if not s["required"] and s["exit"] != 0]
    passed = not mismatches and not required_failures
    record = {
        "schema": "FT_FAMILY_REPLAY_RESULT_V3",
        "result": "FRESH_REPLAY_PASS" if passed else "REPLAY_MISMATCH",
        "matches": matches,
        "mismatches": mismatches,
        "required_step_failures": required_failures,
        "semantic_step_failures": semantic_failures,
        "steps": step_log,
        "pdf_semantic": pdf_semantic,
        "scope": "regeneration of the pre-registered byte list of "
                 "SEMANTIC_FILES.json inside a fresh MIRROR with network-off "
                 "(unshare -rn) and fresh cache; FRESH_REPLAY_PASS = "
                 "mismatches==[] and all required steps exit 0 (required = "
                 "producers of the byte list + input validation); the heavy "
                 "historical semantic reproductions and the PDF rebuild are "
                 "recorded and judged separately (reproduction_receipt.json, "
                 "pdf_semantic); no estimator, no keys, no Sign, no dudect",
        "manifest_sha256": man_sha,
    }
    with open(os.path.join(dest, "REPLAY_RESULT.json"), "w",
              encoding="utf-8") as f:
        json.dump(record, f, indent=1, sort_keys=True)
        f.write("\n")
    print(record["result"], "| matches:", len(matches),
          "| mismatches:", len(mismatches))
    return 0 if passed else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
