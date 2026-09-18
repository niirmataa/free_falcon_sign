"""Emit literal public vectors; Lean recomputes, rather than assumes, Q."""
import hashlib
import json
from pathlib import Path

W=Path.cwd(); wp=W/"artifacts/witness.json"; w=json.loads(wp.read_text())
assert len(w["h"])==len(w["c"])==len(w["z1"])==1536
parts=["import Std\nset_option maxRecDepth 100000\nset_option maxHeartbeats 0\n"]
for name,key in [("publicH","h"),("challenge","c"),("extractedFirst","z1")]:
    parts.append("def "+name+" : Array Int := #["+", ".join(map(str,w[key]))+"]\n")
parts.append("""
def second : Array Int := (Array.replicate 1536 (0 : Int)).set! 0 (-20000)
def machineFirst : Array Int := Array.replicate 1536 (0 : Int)
def center18433 (x : Int) : Int := (x + 9216) % 18433 - 9216
def energy (v : Array Int) : Int :=
  (List.range 768).foldl (fun acc i =>
    acc + v[i]! * v[i]! + v[i]! * v[i+768]! + v[i+768]! * v[i+768]!) 0

theorem vector_sizes : publicH.size = 1536 ∧ challenge.size = 1536 ∧
    extractedFirst.size = 1536 ∧ second.size = 1536 ∧ machineFirst.size = 1536 := by decide

theorem public_residues : publicH.all (fun x => decide (0 ≤ x ∧ x < 18433)) = true := by decide
theorem challenge_residues : challenge.all (fun x => decide (0 ≤ x ∧ x < 18433)) = true := by decide

-- Since the second polynomial is the constant -20000, its product with h
-- is coefficientwise -20000*h in any quotient by the declared monic Phi.
theorem center_coordinates : (List.range 1536).all (fun i =>
    decide (extractedFirst[i]! = center18433 (challenge[i]! + 20000 * publicH[i]!))) = true := by decide

theorem congruence_coordinates : (List.range 1536).all (fun i =>
    decide ((extractedFirst[i]! - 20000 * publicH[i]! - challenge[i]!) % 18433 = 0)) = true := by decide

theorem effective_challenge : (List.range 1536).all (fun i =>
    decide (challenge[i]! = (8670 * publicH[i]!) % 18433)) = true := by decide

theorem machine_norm : energy machineFirst + energy second = 400000000 := by decide
theorem extractor_norm : energy extractedFirst + energy second = 43058711057 := by decide

theorem machine_pair_short : energy machineFirst + energy second < 2093922385 := by
  rw [machine_norm]
  decide

theorem extractor_pair_not_short : ¬ energy extractedFirst + energy second < 2093922385 := by
  rw [extractor_norm]
  decide

theorem extractor_excess : energy extractedFirst + energy second - 2093922385 = 40964788672 := by
  rw [extractor_norm]
  decide

theorem pre_ntt_word : ((-20000 : Int) + 18433) % 65536 = 63969 := by decide
theorem distinct_residues : (-20000 : Int) % 18433 = 16866 ∧ (63969 : Int) % 18433 = 8670 := by decide

-- This models the *unsigned counter*, not a run of a 512 MiB payload.
theorem long_unary_counter_wrap : ((2 : Nat)^32) % (2^32) = 0 := by decide
theorem long_unary_accept_boundary : (((2 : Nat)^32 + 255) % (2^32)) ≤ 255 := by decide
theorem long_unary_reject_boundary : ¬ (((2 : Nat)^32 + 256) % (2^32)) ≤ 255 := by decide

#print axioms vector_sizes
#print axioms public_residues
#print axioms challenge_residues
#print axioms center_coordinates
#print axioms congruence_coordinates
#print axioms effective_challenge
#print axioms machine_norm
#print axioms extractor_norm
#print axioms machine_pair_short
#print axioms extractor_pair_not_short
#print axioms extractor_excess
#print axioms pre_ntt_word
#print axioms distinct_residues
#print axioms long_unary_counter_wrap
#print axioms long_unary_accept_boundary
#print axioms long_unary_reject_boundary
""")
source="\n".join(parts)
target=W/"formal/Witness.lean"
with target.open("x") as f:f.write(source)
binding=dict(witness_sha256=hashlib.sha256(wp.read_bytes()).hexdigest(),
             lean_sha256=hashlib.sha256(target.read_bytes()).hexdigest(),
             literal_vectors={name:hashlib.sha256(json.dumps(w[key],separators=(",",":")).encode()).hexdigest()
                             for name,key in [("publicH","h"),("challenge","c"),("extractedFirst","z1")]},
             scope="literal vector arithmetic, centering, congruences, norm inequalities, unsigned counter; no C semantics axiom",
             toolchain="Lean 4.34.0 / Std; no mathlib")
with (W/"artifacts/lean_binding.json").open("x") as f:json.dump(binding,f,indent=2);f.write("\n")
print(json.dumps(binding,indent=2))
