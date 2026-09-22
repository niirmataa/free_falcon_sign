#!/usr/bin/env python3
"""R4 (S01) acceptance tests for the repaired estimator-campaign interface.

Semantic controls (NOT label-presence checks):

  T1  default state: without a premises record the guarded runner writes
      NOT_RUN_MODEL_UNRESOLVED and the mock backend is never even IMPORTED
      (import-time marker of the mock must not appear);
  T2  false SIS->P2 routing (the historical defect) is REJECTED by the
      validator before any backend call (INVALID_MODEL_SIS_FOR_P2), even with
      --allow-backend;
  T3  SIS sneaked in via the estimator symbol (model_kind ISIS_COSET but
      symbol SIS.estimate) is rejected as well;
  T4  a fully resolved premises record reaches the single call site; exactly
      the mapped cells are called and none of them is SIS-family;
  T5  missing mapping_sha blocks the backend;
  T6  static detector: the historical runner copy carries the SIS->P2 defect
      pattern (it is the mutation witness) while the new runner is clean;
  T7  mutation control: injecting a SIS.estimate call into a P2 context of the
      new runner is detected;
  T8  no-op/idempotence: two default runs produce byte-identical records.

The mock `estimator` module records every call and flags its own import.  No
real estimator, network or campaign is involved: these tests prove guard
behaviour only and are NOT measurements (all cost cells stay NOT_RUN).

Output: results/r4_tests.json (deterministic bytes).
"""
import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
RUNNER = os.path.join(HERE, "estimator_campaign", "run_campaign.sage")
HISTORICAL = os.path.join(HERE, "historical", "INVALID_FOR_P2_run_campaign.sage")
OUT = os.path.join(HERE, "..", "results")
os.makedirs(OUT, exist_ok=True)

SHA64 = "0" * 64
SHA40 = "a" * 40

MOCK_ESTIMATOR = '''
import json, os
_LOG = os.environ.get("R4_MOCK_LOG")
with open(os.environ["R4_MOCK_IMPORT_MARKER"], "w") as f:
    f.write("imported")
class _Recorder:
    def __init__(self, name):
        self._name = name
    def estimate(self, params):
        rec = {"call": self._name + ".estimate", "problem": params.get("problem"),
               "N": params.get("N")}
        if _LOG:
            with open(_LOG, "a") as f:
                f.write(json.dumps(rec, sort_keys=True) + "\\n")
        return "MOCK_OK_" + str(params.get("problem"))
NTRU = _Recorder("NTRU")
ISIS = _Recorder("ISIS")
SIS = _Recorder("SIS")
'''


def make_premises(p2_kind="ISIS_COSET", p2_symbol="ISIS.estimate",
                  p1_symbol="NTRU.estimate", drop_sha_for=None,
                  estimator_commit=SHA40, closed=None):
    mapping = {}
    for N in (768, 1536, 3072):
        mapping["P1:%d" % N] = {"model_kind": "NTRU_PRIMAL",
                                "estimator_symbol": p1_symbol,
                                "mapping_sha": SHA64}
        mapping["P2:%d" % N] = {"model_kind": p2_kind,
                                "estimator_symbol": p2_symbol,
                                "mapping_sha": SHA64}
    if drop_sha_for:
        mapping[drop_sha_for].pop("mapping_sha", None)
    return {
        "estimator_commit": estimator_commit,
        "modeling_points_closed": closed if closed is not None else
            ["circulant_vs_phi3n", "p2_coset_threshold_semantics"],
        "model_mapping": mapping,
    }


SIS_CALL_RE = re.compile(r"\b(SIS\.estimate|SISParameters)\s*\(")


def detect_sis_to_p2(source_text):
    """Static detector: SIS-family CALL syntax in a P2 context window.
    Returns findings [{line, text}].  (Mentions of SIS inside guard logic do
    not match: the regex requires call syntax.)"""
    lines = source_text.splitlines()
    findings = []
    for idx, line in enumerate(lines):
        if SIS_CALL_RE.search(line):
            window = "\n".join(lines[max(0, idx - 12):idx + 13])
            if "P2" in window:
                findings.append({"line": idx + 1, "text": line.strip()})
    return findings


def run_runner(args, tmp, with_mock=True):
    mock_dir = os.path.join(tmp, "mock")
    os.makedirs(mock_dir, exist_ok=True)
    marker = os.path.join(tmp, "import_marker")
    log = os.path.join(tmp, "calls.jsonl")
    env = dict(os.environ)
    if with_mock:
        with open(os.path.join(mock_dir, "estimator.py"), "w") as f:
            f.write(MOCK_ESTIMATOR)
        env["PYTHONPATH"] = mock_dir
        env["R4_MOCK_IMPORT_MARKER"] = marker
        env["R4_MOCK_LOG"] = log
    if os.path.exists(marker):
        os.remove(marker)
    if os.path.exists(log):
        os.remove(log)
    proc = subprocess.run([sys.executable, RUNNER] + args,
                          capture_output=True, text=True, env=env)
    calls = []
    if os.path.exists(log):
        with open(log) as f:
            calls = [json.loads(x) for x in f if x.strip()]
    imported = os.path.exists(marker)
    return proc.returncode, calls, imported


def read_campaign(out_dir):
    with open(os.path.join(out_dir, "campaign.json"), encoding="utf-8") as f:
        return json.load(f)


def read_bytes(path):
    with open(path, "rb") as f:
        return f.read()


cases = []


def case(name, ok, details):
    cases.append({"name": name, "ok": bool(ok), "details": details})
    print(("PASS " if ok else "FAIL ") + name + " :: " + str(details))


with tempfile.TemporaryDirectory(dir=os.environ.get("TMPDIR")) as tmp:
    # ---- T1: default state, backend never imported
    o1 = os.path.join(tmp, "out1")
    code, calls, imported = run_runner([o1], tmp)
    c1 = read_campaign(o1)
    t1 = (code == 3 and c1["status"] == "NOT_RUN_MODEL_UNRESOLVED"
          and not imported and calls == [])
    case("T1_default_no_backend", t1,
         "exit=%d status=%s imported=%s calls=%d" %
         (code, c1["status"], imported, len(calls)))

    # ---- T8: no-op idempotence (byte-identical default records)
    o2 = os.path.join(tmp, "out2")
    code2, calls2, imported2 = run_runner([o2], tmp)
    t8 = (read_bytes(os.path.join(o1, "campaign.json"))
          == read_bytes(os.path.join(o2, "campaign.json")))
    case("T8_noop_idempotent", t8, "byte-identical default records")

    # ---- T2: false SIS->P2 routing rejected before any backend call
    p2path = os.path.join(tmp, "premises_sis.json")
    with open(p2path, "w") as f:
        json.dump(make_premises(p2_kind="SIS", p2_symbol="SIS.estimate"), f,
                  sort_keys=True)
    o3 = os.path.join(tmp, "out3")
    code, calls, imported = run_runner([o3, "--premises", p2path,
                                        "--allow-backend"], tmp)
    c3 = read_campaign(o3)
    reasons = " | ".join(c3["validation"]["reasons"])
    t2 = (code == 4 and c3["status"] == "VALIDATION_REJECTED"
          and "INVALID_MODEL_SIS_FOR_P2" in reasons
          and not imported and calls == [])
    case("T2_sis_to_p2_rejected_no_backend", t2,
         "exit=%d imported=%s calls=%d reason_present=%s" %
         (code, imported, len(calls),
          "INVALID_MODEL_SIS_FOR_P2" in reasons))

    # ---- T3: SIS sneaked via symbol
    p3path = os.path.join(tmp, "premises_alias.json")
    with open(p3path, "w") as f:
        json.dump(make_premises(p2_kind="ISIS_COSET",
                                p2_symbol="SIS.estimate"), f, sort_keys=True)
    o4 = os.path.join(tmp, "out4")
    code, calls, imported = run_runner([o4, "--premises", p3path,
                                        "--allow-backend"], tmp)
    c4 = read_campaign(o4)
    reasons4 = " | ".join(c4["validation"]["reasons"])
    t3 = (code == 4 and "INVALID_MODEL_SIS_FOR_P2" in reasons4
          and not imported and calls == [])
    case("T3_symbol_alias_sis_rejected", t3,
         "exit=%d imported=%s reason_present=%s" %
         (code, imported, "INVALID_MODEL_SIS_FOR_P2" in reasons4))

    # ---- T5: missing mapping_sha blocks
    p5path = os.path.join(tmp, "premises_nosha.json")
    with open(p5path, "w") as f:
        json.dump(make_premises(drop_sha_for="P2:1536"), f, sort_keys=True)
    o5 = os.path.join(tmp, "out5")
    code, calls, imported = run_runner([o5, "--premises", p5path,
                                        "--allow-backend"], tmp)
    c5 = read_campaign(o5)
    reasons5 = " | ".join(c5["validation"]["reasons"])
    t5 = (code == 4 and "mapping_sha missing" in reasons5
          and not imported and calls == [])
    case("T5_missing_sha_blocks_backend", t5,
         "exit=%d imported=%s reason_present=%s" %
         (code, imported, "mapping_sha missing" in reasons5))

    # ---- T4: fully resolved premises: only mapped cells reach the backend
    p4path = os.path.join(tmp, "premises_ok.json")
    with open(p4path, "w") as f:
        json.dump(make_premises(), f, sort_keys=True)
    o6 = os.path.join(tmp, "out6")
    code, calls, imported = run_runner([o6, "--premises", p4path,
                                        "--allow-backend"], tmp)
    c6 = read_campaign(o6)
    call_names = sorted(x["call"] for x in calls)
    t4 = (code == 0 and c6["status"] == "RUN_RECORD" and imported
          and len(calls) == 6 and all(n != "SIS.estimate" for n in call_names)
          and len(c6["backend_calls"]) == 6)
    case("T4_resolved_calls_mapped_only", t4,
         "exit=%d calls=%d audit=%d any_sis=%s" %
         (code, len(calls), len(c6["backend_calls"]),
          any(n == "SIS.estimate" for n in call_names)))

# ---- T6/T7: static detector (call syntax in P2 window)
with open(RUNNER, encoding="utf-8") as f:
    new_src = f.read()
with open(HISTORICAL, encoding="utf-8") as f:
    hist_src = f.read()

hist_findings = detect_sis_to_p2(hist_src)
new_findings = detect_sis_to_p2(new_src)
case("T6_historical_defect_detected", len(hist_findings) >= 1
     and len(new_findings) == 0,
     "historical=%d new=%d" % (len(hist_findings), len(new_findings)))

mutated = new_src + ('\nr2 = SIS.estimate(p2)   # mutation: "problem": "P2"\n')
mut_findings = detect_sis_to_p2(mutated)
case("T7_mutation_sis_call_detected", len(mut_findings) >= 1,
     "mutation findings=%d" % len(mut_findings))

all_ok = all(c["ok"] for c in cases)
rep = {
    "claim_id": "C-R4",
    "evidence_class": "KERNEL_FREE_SEMANTIC_CONTROL",
    "cases": cases,
    "all_ok": all_ok,
    "historical_defect_findings": hist_findings,
    "new_runner_findings": new_findings,
    "mutation_findings": mut_findings,
    "scope": "guard behaviour with instrumented mock backend only; "
             "no real estimator, no measurement; all cost cells stay NOT_RUN",
}
with open(os.path.join(OUT, "r4_tests.json"), "w", encoding="utf-8") as f:
    json.dump(rep, f, indent=1, sort_keys=True)
    f.write("\n")

print("SUMMARY:", "0 checks failed" if all_ok
      else "%d cases failed" % sum(1 for c in cases if not c["ok"]))
sys.exit(0 if all_ok else 1)
