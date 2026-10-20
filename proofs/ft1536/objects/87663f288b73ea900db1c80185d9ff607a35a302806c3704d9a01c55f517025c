import Run2.WordEncoding
import Run2.TargetLaw
import Mathlib.Logic.Equiv.Fin.Basic

namespace FT1536.Run2.NonceBits
open BitArithmetic

def byteEquiv : (Fin 8 → Bool) ≃ Byte :=
  (Equiv.vectorEquivFin Bool 8).symm.trans (wordEquiv 8)

/- The wire permutation splits 320 bits into forty disjoint blocks of eight.
No rejection sampler, modular bias, padding loss or extra entropy is used. -/
def nonceEquiv : (Fin 320 → Bool) ≃ Nonce :=
  ((Equiv.piCongrLeft (fun _ : Fin 320 => Bool)
    (finProdFinEquiv : Fin 40 × Fin 8 ≃ Fin 320)).symm.trans
      (Equiv.curry (Fin 40) (Fin 8) Bool)).trans
    ((Equiv.piCongrRight (fun _ : Fin 40 => byteEquiv)).trans
      (Equiv.vectorEquivFin Byte 40).symm)

theorem nonce_roundtrip (t : Fin 320 → Bool) : nonceEquiv.symm (nonceEquiv t)=t :=
  nonceEquiv.symm_apply_apply t

theorem nonce_uniform : (Law.uniform : Law (Fin 320 → Bool)).map nonceEquiv=
    (Law.uniform : Law Nonce) := uniform_equiv nonceEquiv

theorem nonce_draw_binding :
    Dist.Same ((Dist.draw (Law.uniform : Law (Fin 320 → Bool))).map nonceEquiv)
      (Dist.draw (Law.uniform : Law Nonce)) := by
  intro f
  have hh:=draw_pushforward (Law.uniform : Law (Fin 320 → Bool)) nonceEquiv Dist.pure f
  rw [nonce_uniform] at hh
  simp only [Dist.expect_bind,Dist.expect_pure] at hh
  exact hh.symm

end FT1536.Run2.NonceBits
