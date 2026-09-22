"""Runtime binding of campaign scripts to the Extra/c source build.

load_build(W) re-reads Extra/c at run time and REQUIRES:
  * the 17-file manifest verifies byte-for-byte;
  * every recorded binding's verbatim line is still present at its file;
  * the recorded file SHA-256 matches the current file.
It returns the parsed build constants (q, B, sigma, caps). Any drift fails
the consuming script instead of silently proceeding.
"""
import hashlib
import json
import os


class BuildBindingError(RuntimeError):
    pass


def _sha256(path):
    with open(path, "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def load_build(W):
    W = os.path.abspath(W)
    repo = os.path.abspath(os.path.join(W, "..", "..", "..", ".."))
    src = os.path.join(repo, "Extra", "c")
    inputs = json.load(open(os.path.join(
        W, "inputs", "family", "build_inputs.json")))

    if not inputs["manifest_all_verified"]:
        raise BuildBindingError("extraction-time manifest check failed")

    # 1. re-verify the manifest NOW
    for entry in inputs["manifest_entries"]:
        p = os.path.join(src, entry["file"])
        if not os.path.isfile(p) or _sha256(p) != entry["sha256"]:
            raise BuildBindingError("manifest drift: %s" % entry["file"])

    # 2. re-verify every binding (verbatim line + file hash)
    for bid, b in inputs["bindings"].items():
        if "error" in b:
            raise BuildBindingError("missing binding: %s" % bid)
        p = os.path.join(repo, b["file"])
        if _sha256(p) != b["file_sha256"]:
            raise BuildBindingError("source file drift: %s" % b["file"])
        text = open(p, encoding="utf-8", errors="replace").read()
        if b["verbatim"] not in text:
            raise BuildBindingError("verbatim line gone: %s (%s)"
                                    % (bid, b["file"]))

    q = inputs["bindings"]["q_guard"]["value"]
    if not (q == inputs["bindings"]["q_relation_literal"]["value"] == 18433):
        raise BuildBindingError("q binding inconsistent")
    return {
        "q": q,
        "B": inputs["bindings"]["norm_bound2"]["value"],
        "sigma_sign": inputs["bindings"]["signing_sigma"]["value"],
        "sign_max_attempts": inputs["bindings"]["sign_max_attempts"]["value"],
        "keygen_max_attempts":
            inputs["bindings"]["keygen_max_attempts"]["value"],
        "manifest_sha256_head":
            inputs["manifest_entries"][0]["sha256"][:16],
    }
