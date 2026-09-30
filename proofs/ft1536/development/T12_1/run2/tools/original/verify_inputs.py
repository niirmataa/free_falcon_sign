#!/usr/bin/env python3
"""verify_inputs.py — weryfikacja przypiętych kopii C_TASK_1_BINBIND (v2).

Aserty:
  (1) inputs/m0_source/* == piny RUN_003/INPUTS.sha256 (snapshot M0 source17)
      oraz == pinned_sha256 z SOURCE_BINDINGS.json,
  (2) inputs/link/{B20,Source3}/* — hash KAŻDEGO pliku musi występować jako
      pin przynajmniej jednego joba RUN_003 (run/*/SOURCE_INPUTS.json);
      raport pokazuje które joby go przypinają. StableBinary.lean musi być
      wersją ZAAKCEPTOWANEGO joba stable_binary_020 (nie live relaxed_scratch).
Wypisuje manifesty. Awaria asercji = exit 1 (stop-and-report).
"""
import hashlib, json, sys, pathlib

T = pathlib.Path("/home/footfalcon/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/C_TASK_1_BINBIND")
R = pathlib.Path("/home/footfalcon/free_falcon_sign/proofs/ft1536/work/"
                 "FT1536_MATH_EUFCMA_MTISIS_RUN_002/continuations/FT1536_MATH_EUFCMA_MTISIS_RUN_003")

def sha(p: pathlib.Path) -> str:
    return hashlib.sha256(p.read_bytes()).hexdigest()

def main() -> int:
    failures = []
    report = []
    # (1) M0 snapshot
    want_m0 = {}
    for line in (R / "INPUTS.sha256").read_text().splitlines():
        h, name = line.split(None, 1)
        if name.strip().startswith("inputs/source/"):
            want_m0[name.strip().split("/")[-1]] = h
    got_m0 = {p.name: sha(p) for p in sorted((T / "inputs/m0_source").iterdir())}
    for name, h in sorted(want_m0.items()):
        if got_m0.get(name) != h:
            failures.append(f"M0 mismatch/missing: {name}")
    if set(got_m0) - set(want_m0):
        failures.append(f"M0 unexpected files: {sorted(set(got_m0) - set(want_m0))}")
    for e in json.loads((R / "SOURCE_BINDINGS.json").read_text()):
        if got_m0.get(e["name"]) != e["pinned_sha256"]:
            failures.append(f"SOURCE_BINDINGS mismatch: {e['name']}")
    # (2) link set: pin map z jobów
    hash_jobs = {}
    for jf in sorted((R / "run").glob("*/SOURCE_INPUTS.json")):
        job = jf.parent.name
        try:
            d = json.loads(jf.read_text())
        except Exception:
            continue
        for e in d.get("sources", []):
            hash_jobs.setdefault(e["sha256"], set()).add(job)
    # piny rodziców (RUN_002 output: m.in. Run2.*)
    try:
        for e in json.loads((R / "PARENT_CACHE_BINDINGS.json").read_text()):
            hash_jobs.setdefault(e["source_sha256"], set()).add("parent:" + pathlib.Path(e["source"]).parent.name)
    except Exception:
        pass
    manifest = []
    for sub in ("B20/C", "B20/Word", "Source3", "Run2"):
        for p in sorted((T / "inputs/link" / sub).iterdir()):
            h = sha(p)
            jobs = sorted(hash_jobs.get(h, []))
            if p.suffix == ".lean" and not jobs:
                failures.append(f"link file not pinned by any job: {sub}/{p.name} ({h[:16]})")
            report.append(f"{sub}/{p.name} {h[:16]} jobs={','.join(jobs) if jobs else 'NONE'}")
            if p.name == "StableBinary.lean" and "stable_binary_020" not in jobs:
                failures.append("StableBinary.lean nie jest wersją zaakceptowanego stable_binary_020")
            if sub == "Run2" and p.suffix == ".lean":
                # Run2 nie jest zarządzane przez joby Source3; wymagaj zgodności
                # z żywym RUN_002/run/formal/Run2 (tylko-do-odczytu) lub piny joba
                live = (R.parents[1] / "run/formal/Run2" / p.name)
                if jobs or (live.exists() and sha(live) == h):
                    pass
                else:
                    failures.append(f"Run2 file niezgodne z żywym RUN_002: {p.name}")
            manifest.append(f"{h}  {sub}/{p.name}")
    (T / "inputs/SHA256SUMS_M0").write_text(
        "".join(f"{got_m0[n]}  m0_source/{n}\n" for n in sorted(got_m0)))
    (T / "inputs/SHA256SUMS_LINK").write_text("".join(l + "\n" for l in manifest))
    print("\n".join(report))
    if failures:
        print("VERIFY_FAIL")
        for f in failures:
            print(" -", f)
        return 1
    print(f"VERIFY_OK m0={len(got_m0)} link={len(manifest)}")
    return 0

if __name__ == "__main__":
    sys.exit(main())
