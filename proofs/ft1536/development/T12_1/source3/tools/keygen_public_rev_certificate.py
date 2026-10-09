#!/usr/bin/env python3
"""Generate bounded kernel certificates, not arithmetic results or proof oracles."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main():
    text = '''import Source3.KeygenPublicRev
import Source3.KeygenMkgm3IndexCert

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete kernel check of all public table-generator indices. The source
   execution theorem is separate and universal over uint32 words. -/
namespace FT1536.Source3.KeygenPublicRevCert
def Correct (i : Nat) : Prop :=
  (KeygenPublicRev.reversed 10 (BitVec.ofNat 32 i) 0).toNat=KeygenRev10.bitrev10 i ∧
    KeygenRev10.bitrev10 i<1024
instance (i : Nat) : Decidable (Correct i) := by unfold Correct; infer_instance
'''
    for block in range(64):
        text += f'theorem chunk{block:02d} : ∀ j : Fin 16, Correct ({16*block}+j.val) := by decide\n'
    text += '''theorem all_indices (i : Nat) (hi : i<1024) : Correct i := by
  have chunks : ∀ b : Fin 64, ∀ j : Fin 16, Correct (16*b.val+j.val) := by
    intro b
    fin_cases b
'''
    for block in range(64):
        text += f'    · exact chunk{block:02d}\n'
    text += '''  have hb : i/16<64 := by omega
  have hj : i%16<16 := Nat.mod_lt i (by decide)
  have certificate := chunks ⟨i/16,hb⟩ ⟨i%16,hj⟩
  have index : 16*(i/16)+i%16=i := by omega
  simpa only [index] using certificate
theorem source_bitrev (x : BitVec 32) (v : C99IntegerReference.Value) (hx : x.toNat<1024)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .rev) [.uint32 x] v) :
    v=.uint32 (BitVec.ofNat 32 (KeygenRev10.bitrev10 x.toNat)) ∧
      KeygenRev10.bitrev10 x.toNat<1024 := by
  have certificate := all_indices x.toNat hx
  have equal := KeygenPublicRev.source_result x v source
  refine ⟨equal.trans ?_,certificate.2⟩
  congr 1
  apply BitVec.eq_of_toNat_eq
  have word : BitVec.ofNat 32 x.toNat=x := by simp
  have returnNat : (KeygenPublicRev.reversed 10 x 0).toNat=KeygenRev10.bitrev10 x.toNat := by
    have result := certificate.1
    rw [word] at result
    exact result
  rw [returnNat,BitVec.toNat_ofNat,Nat.mod_eq_of_lt (by have bound := certificate.2; omega)]
theorem source_last_index (u : Nat) (hu : u<512) (v : C99IntegerReference.Value)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .rev)
      [.uint32 (BitVec.ofNat 32 (2*u))] v) :
    v=.uint32 (BitVec.ofNat 32 (KeygenMkgm3Indices.reverse9 u)) ∧
      KeygenMkgm3Indices.reverse9 u<512 := by
  have exactInput : (BitVec.ofNat 32 (2*u)).toNat=2*u := Nat.mod_eq_of_lt (by omega)
  have result := (source_bitrev _ v (by rw [exactInput]; omega) source).1
  rw [exactInput] at result
  exact ⟨result,((KeygenMkgm3IndexCert.all_indices u (by omega)).1 hu).1⟩
end FT1536.Source3.KeygenPublicRevCert
'''
    (ROOT / 'formal/Source3/KeygenPublicRevCert.lean').write_text(text)


if __name__ == '__main__':
    main()
