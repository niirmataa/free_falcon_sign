import OutputFormat020D
import OutputValues020D

set_option maxRecDepth 8192
namespace FT1536.S05.EncodedOutput020D
open WordRAM020 OutputChunks020D OutputFormat020D OutputValues020D
open Interleaved020D IndexReference020D FT1536.Relation FT1536.Run2.PolynomialReference
attribute [local irreducible] List.ofFn

theorem key_region (out : Fin outputSize → Bool) (c : Rq) (f : Fin 1536 → Nat)
    (pref : Prefix f 0 16 (by decide) 1536 out)
    (hf : ∀ j, f j=(coefficient c (term j)).val) :
    region out 0 24576 (by decide)=PairEncoding020.keyBits c := by
  apply paired_region out 0 16 (by decide) f (fun p => ((c p).1.val,(c p).2.val)) pref
  · intro p
    rw [hf,term_even]
    rfl
  · intro p
    rw [hf,term_odd]
    rfl

theorem reply_even (z : StandaloneRuntime019.CachedBox) (p : Fin 768) :
    replyValue z ⟨2*p.val,by have := p.isLt;omega⟩=(z.2[p.val]).1.val := by
  unfold replyValue
  rw [ite_eq_left (show (2*p.val)%2=0 by omega)]
  have hi : pairIndex ⟨2*p.val,by have := p.isLt;omega⟩=p := by
    apply Fin.ext
    change (2*p.val)/2=p.val
    omega
  exact congrArg (fun q : Fin 768 => (z.2.get q).1.val) hi

theorem reply_odd (z : StandaloneRuntime019.CachedBox) (p : Fin 768) :
    replyValue z ⟨2*p.val+1,by have := p.isLt;omega⟩=(z.2[p.val]).2.val := by
  unfold replyValue
  rw [ite_eq_right (show (2*p.val+1)%2≠0 by omega)]
  have hi : pairIndex ⟨2*p.val+1,by have := p.isLt;omega⟩=p := by
    apply Fin.ext
    change (2*p.val+1)/2=p.val
    omega
  exact congrArg (fun q : Fin 768 => (z.2.get q).2.val) hi

theorem reply_region (out : Fin outputSize → Bool) (z : StandaloneRuntime019.CachedBox)
    (pref : Prefix (replyValue z) 24577 17 (by decide) 1536 out) :
    region out 24577 26112 (by decide)=PairEncoding020.replyBits (fun p => z.2[p.val]) :=
  paired_region out 24577 17 (by decide) (replyValue z) (fun p => ((z.2[p.val]).1.val,(z.2[p.val]).2.val))
    pref (reply_even z) (reply_odd z)

/-- Full bit list, with an explicit presence bit; no field is discarded. -/
theorem encode_correct (out : Fin outputSize → Bool) (c : Rq) (z : StandaloneRuntime019.CachedBox)
    (f : Fin 1536 → Nat) (hk : Prefix f 0 16 (by decide) 1536 out)
    (hf : ∀ j, f j=(coefficient c (term j)).val)
    (hr : Prefix (replyValue z) 24577 17 (by decide) 1536 out)
    (ht : out ⟨24576,by decide⟩=true) :
    List.ofFn out=PairEncoding020.encode (c,some (fun p => z.2[p.val])) := by
  rw [split_output,key_region out c f hk hf,reply_region out z hr,ht]
  rfl

end FT1536.S05.EncodedOutput020D
