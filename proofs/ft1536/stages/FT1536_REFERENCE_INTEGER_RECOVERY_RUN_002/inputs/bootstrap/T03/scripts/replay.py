#!/usr/bin/env python3
"""FT1536_REFERENCE_INTEGER_RECOVERY_RUN_001 -- standard fresh replay.

usage: python3 -B scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA

Protocol (TASK 9):
  1. verify the FULL OUTPUTS manifest (and the external OUTPUTS.sha256 hash)
     BEFORE creating DEST;
  2. DEST = new absent path under W/tmp, no symlinks/escapes;
  3. fresh project copy + fresh cache/build/Lean under DEST (inputs/source RO
     copies; no reuse of old W caches);
  4. recompute every planned semantic file from scratch (scripts, Lean, C
     slices with ASan/UBSan, independent oracle) and compare hashes per
     SEMANTIC_FILES.json (fixed before replay; each match really recomputed);
  5. write DEST/fresh_replay.json (FRESH_REPLAY_PASS, matches[{path,sha256}],
     mismatches=[], explicit domain/scope) and child DEST/REPLAY_RESULT.json.

Self-contained: does not read COMMANDS.log (works on a restored archive with an
empty COMMANDS.log).
"""
import hashlib, json, os, shutil, subprocess, sys

W = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
LEAN = "/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean"
SAGE = "/home/footfalcon/.local/bin/sage"   # pinned launcher (principle doc)

def sha(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for c in iter(lambda: f.read(1 << 20), b""):
            h.update(c)
    return h.hexdigest()

def fail(msg):
    print("REPLAY_FAIL: " + msg)
    sys.exit(2)

def main():
    if len(sys.argv) != 3:
        fail("usage: replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA")
    dest = os.path.abspath(sys.argv[1])
    ext = sys.argv[2].strip()
    tmp_root = os.path.join(W, "tmp")
    if not (dest + os.sep).startswith(tmp_root + os.sep):
        fail("DEST must be under W/tmp")
    if os.path.lexists(dest):
        fail("DEST must be absent")
    for part in dest.split(os.sep):
        p = os.path.join("/", *dest.split(os.sep)[:dest.split(os.sep).index(part) + 1]) \
            if False else None
    # no symlink components inside W path to DEST
    cur = tmp_root
    rel = os.path.relpath(dest, tmp_root)
    for comp in rel.split(os.sep):
        cur = os.path.join(cur, comp)
        if os.path.islink(cur):
            fail("symlink component: " + cur)

    # steps 1: external anchor + full manifest BEFORE any DEST creation
    outs = os.path.join(W, "OUTPUTS.sha256")
    if not os.path.isfile(outs):
        fail("OUTPUTS.sha256 missing")
    got = sha(outs)
    if got != ext:
        fail("external OUTPUTS.sha256 hash mismatch: %s != %s" % (got, ext))
    members = {}
    for ln in open(outs):
        ln = ln.rstrip("\n")
        if not ln:
            continue
        h, rel_p = ln[:64], ln[66:]
        if rel_p.startswith("/") or ".." in rel_p.split(os.sep):
            fail("unsafe member path " + rel_p)
        members[rel_p] = h
    for rel_p, h in sorted(members.items()):
        p = os.path.join(W, rel_p)
        if not os.path.isfile(p) or os.path.islink(p):
            fail("member missing/non-regular: " + rel_p)
        if sha(p) != h:
            fail("member hash mismatch: " + rel_p)
    print("manifest verified: %d members, external sha ok" % len(members))

    # steps 2-3: fresh project under DEST
    env = dict(os.environ)
    env.update(HOME=os.path.join(dest, "home"), TMPDIR=os.path.join(dest, "tmp"),
               TMP=os.path.join(dest, "tmp"), TEMP=os.path.join(dest, "tmp"))
    os.makedirs(os.path.join(dest, "home"))
    os.makedirs(os.path.join(dest, "tmp"))
    os.makedirs(os.path.join(dest, "logs"))
    proj = os.path.join(dest, "project")
    for d in ("scripts", "formal"):
        shutil.copytree(os.path.join(W, d), os.path.join(proj, d))
    os.makedirs(os.path.join(proj, "checks"))
    shutil.copytree(os.path.join(W, "checks", "c_slice"),
                    os.path.join(proj, "checks", "c_slice"),
                    ignore=shutil.ignore_patterns("harness_rint", "harness_rint_asan",
                                                  "harness_rint_ubsan", "*.txt",
                                                  "oracle_result.json", "build.log"))
    shutil.copytree(os.path.join(W, "checks", "sage"),
                    os.path.join(proj, "checks", "sage"))
    shutil.copytree(os.path.join(W, "inputs"), os.path.join(proj, "inputs"))
    os.makedirs(os.path.join(proj, "logs"))

    def run(cmd, logname, cwd):
        with open(os.path.join(dest, "logs", logname), "w") as fh:
            r = subprocess.run(cmd, cwd=cwd, env=env, stdout=fh,
                               stderr=subprocess.STDOUT, text=True)
        if r.returncode != 0:
            fail("step failed (%s), see logs/%s" % (" ".join(cmd), logname))

    py = [sys.executable, "-B"]
    sage_receipt = {"launcher": SAGE, "mode": "sage lemma.sage (preparser on)",
                    "runs": []}
    run(py + ["scripts/extract_constants.py"], "r02_constants.log", proj)
    for sfile, log in (("checks/sage/exact_ring_checks.sage", "r04_ring.log"),
                       ("checks/sage/skeleton_cancellation.sage", "r03_skeleton.log"),
                       ("checks/sage/gap_composition.sage", "r05_gap.log")):
        run([SAGE, sfile], log, proj)
        sage_receipt["runs"].append({
            "argv": [SAGE, sfile], "exit_code": 0, "log": log,
            "sage_sha256": sha(os.path.join(proj, sfile))})
    with open(os.path.join(dest, "logs", "r01_sage_version.log"), "w") as fh:
        subprocess.run([SAGE, "--version"], cwd=proj, env=env, stdout=fh,
                       stderr=subprocess.STDOUT, text=True, check=True)
    sage_receipt["version"] = open(os.path.join(dest, "logs",
                                               "r01_sage_version.log")).read().strip()
    run([LEAN, "-j1", "-M2048", "--root=formal", "formal/SkeletonCancel.lean"],
        "r06_lean_skeleton.log", proj)
    with open(os.path.join(proj, "logs", "06_lean_skeleton.log"), "w") as fh:
        subprocess.run([LEAN, "-j1", "-M2048", "--root=formal",
                        "formal/SkeletonCancel.lean"], cwd=proj, env=env,
                       stdout=fh, stderr=subprocess.STDOUT, text=True, check=True)
    with open(os.path.join(proj, "logs", "07_lean_rintgap.log"), "w") as fh:
        subprocess.run([LEAN, "-j1", "-M2048", "--root=formal", "formal/RintGap.lean"],
                       cwd=proj, env=env, stdout=fh, stderr=subprocess.STDOUT,
                       text=True, check=True)
    cs = os.path.join(proj, "checks", "c_slice")
    run(["make"], "r08_build.log", cs)
    for name, out in (("harness_rint", "out_normal.txt"),
                      ("harness_rint_asan", "out_asan.txt"),
                      ("harness_rint_ubsan", "out_ubsan.txt")):
        with open(os.path.join(cs, out), "w") as fh:
            subprocess.run([os.path.join(".", name)], cwd=cs, env=env, stdout=fh,
                           stderr=subprocess.PIPE, text=True, check=True)
    run([SAGE, "checks/sage/rint_oracle.sage"], "r13_oracle.log", proj)
    sage_receipt["runs"].append({
        "argv": [SAGE, "checks/sage/rint_oracle.sage"], "exit_code": 0,
        "log": "r13_oracle.log",
        "sage_sha256": sha(os.path.join(proj, "checks/sage/rint_oracle.sage"))})
    with open(os.path.join(dest, "SAGE_RUNS.json"), "w") as fh:
        json.dump(sage_receipt, fh, indent=1, sort_keys=True)

    # steps 4: semantic comparison (each match really recomputed)
    plan = json.load(open(os.path.join(W, "SEMANTIC_FILES.json")))["files"]
    matches, mismatches = [], []
    for rel_p in plan:
        a, b = os.path.join(W, rel_p), os.path.join(proj, rel_p)
        ha, hb = (sha(a) if os.path.isfile(a) else None), (sha(b) if os.path.isfile(b) else None)
        if ha is not None and ha == hb:
            matches.append({"path": rel_p, "sha256": ha})
        else:
            mismatches.append({"path": rel_p, "original": ha, "replay": hb})

    passed = not mismatches and len(matches) == len(plan)
    fresh = {
        "schema": "ft1536.reference_integer_recovery.fresh_replay/1",
        "result": "FRESH_REPLAY_PASS" if passed else "FRESH_REPLAY_MISMATCH",
        "external_outputs_sha256": ext,
        "semantic_plan": "SEMANTIC_FILES.json (%d files)" % len(plan),
        "matches": matches,
        "mismatches": mismatches,
        "domain_scope": ("deterministic recomputed evidence for the one-root "
                         "reference/integer-recovery package: exact ring and "
                         "skeleton controls, gap ledger, Lean logs, fpr_rint "
                         "source slices (normal/ASan/UBSan) and independent "
                         "Fraction/QQ oracle; narrative artifacts sealed via "
                         "OUTPUTS.sha256"),
    }
    with open(os.path.join(dest, "fresh_replay.json"), "w") as fh:
        json.dump(fresh, fh, indent=1, sort_keys=True)
    child = {
        "schema": "ft1536.reference_integer_recovery.replay_result/1",
        "result": fresh["result"],
        "matched": len(matches), "expected": len(plan),
        "mismatches": mismatches, "dest": dest,
    }
    with open(os.path.join(dest, "REPLAY_RESULT.json"), "w") as fh:
        json.dump(child, fh, indent=1, sort_keys=True)
    print(json.dumps({"result": fresh["result"], "matched": len(matches),
                      "expected": len(plan)}, indent=1))
    sys.exit(0 if passed else 1)

if __name__ == "__main__":
    main()
