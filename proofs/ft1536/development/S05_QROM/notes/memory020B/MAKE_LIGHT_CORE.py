#!/usr/bin/env python3
"""Diagnostic import-only rewrite; every byte after the imports stays intact.
Does not replace the pinned020 model or rebuild its dependency closure.
"""
from pathlib import Path
import hashlib,json
S=Path(__file__).resolve().parents[2]
src=S/'formal/WordRAM020.lean'
pins=dict(line.split('  ',1)[::-1] for line in (S/'notes/PAIR_MACHINE_020_OUTPUTS.sha256').read_text().splitlines())
assert hashlib.sha256(src.read_bytes()).hexdigest()==pins['formal/WordRAM020.lean']
old=src.read_text();needle='import Mathlib.Tactic\n';assert old.count(needle)==1
new=old.replace(needle,'import Mathlib.Tactic.Linarith\nimport Mathlib.Tactic.NormNum\nimport Lean.Elab.Tactic.Omega\n')
assert old[old.index('/-!'):]==new[new.index('/-!'):]
out=S/'.build/pair_machine_020/cap_light_001/memory_001/light_core_input'
out.mkdir(exist_ok=False);(out/'WordRAMLight020B.lean').write_text(new)
(out/'GENERATION.json').write_text(json.dumps({'original_source':str(src),'original_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),
 'generated_sha256':hashlib.sha256(new.encode()).hexdigest(),'body_unchanged':True,'scope':'imports-only diagnostic; no replacement of original020'},indent=2)+'\n')
print(out/'WordRAMLight020B.lean')
