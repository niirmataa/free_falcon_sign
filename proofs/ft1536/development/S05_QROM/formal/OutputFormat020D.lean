import OutputChunks020D
import PairEncoding020
import Mathlib.Data.List.OfFn

set_option maxRecDepth 8192
namespace FT1536.S05.OutputFormat020D
open WordRAM020 OutputChunks020D FT1536.Run2.BitArithmetic

theorem encode_ofFn (a width : Nat) : List.ofFn (bitAt a width)=encodeNat a width := by
  apply List.ext_getElem
  · rw [List.length_ofFn,encodeNat_length]
  · intro j hj hj'
    rw [List.getElem_ofFn]
    rfl

def region (out : Fin outputSize → Bool) (start len : Nat) (hb : start+len≤outputSize) : List Bool :=
  List.ofFn (fun j : Fin len => out ⟨start+j.val,by omega⟩)

/-- Reassemble interleaved words into the original768 paired cells. -/
theorem paired_region (out : Fin outputSize → Bool) (start width : Nat)
    (hb : start+1536*width≤outputSize) (f : Fin 1536 → Nat) (pairs : Fin 768 → Nat × Nat)
    (pref : Prefix f start width hb 1536 out)
    (even : ∀ p : Fin 768, f ⟨2*p.val,by have := p.isLt;omega⟩=(pairs p).1)
    (odd : ∀ p : Fin 768, f ⟨2*p.val+1,by have := p.isLt;omega⟩=(pairs p).2) :
    region out start (768*(width+width)) (by omega)=
      (List.ofFn (fun p => encodeNat (pairs p).1 width++encodeNat (pairs p).2 width)).flatten := by
  unfold region
  rw [List.ofFn_mul]
  apply congrArg List.flatten
  apply congrArg List.ofFn
  funext p
  rw [List.ofFn_add]
  apply congrArg₂ List.append
  · calc
      _ = List.ofFn (bitAt (pairs p).1 width) := by
        apply congrArg List.ofFn
        funext j
        have h := pref (⟨2*p.val,by have := p.isLt;omega⟩:Fin 1536) (by have := p.isLt;omega) j
        rw [even p] at h
        have hi : (⟨start+(p.val*(width+width)+j.val),by have hh := (address start width ⟨2*p.val,by have := p.isLt;omega⟩ j hb).isLt;change start+width*(2*p.val)+j.val<outputSize at hh;nlinarith⟩:Fin outputSize)=
            address start width ⟨2*p.val,by have := p.isLt;omega⟩ j hb := by
          apply Fin.ext
          change start+(p.val*(width+width)+j.val)=start+width*(2*p.val)+j.val
          ring
        change out ⟨start+(p.val*(width+width)+j.val),_⟩=bitAt (pairs p).1 width j
        rw [hi]
        exact h
      _ = _ := encode_ofFn _ _
  · calc
      _ = List.ofFn (bitAt (pairs p).2 width) := by
        apply congrArg List.ofFn
        funext j
        have h := pref (⟨2*p.val+1,by have := p.isLt;omega⟩:Fin 1536) (by have := p.isLt;omega) j
        rw [odd p] at h
        have hi : (⟨start+(p.val*(width+width)+(width+j.val)),by have hh := (address start width ⟨2*p.val+1,by have := p.isLt;omega⟩ j hb).isLt;change start+width*(2*p.val+1)+j.val<outputSize at hh;nlinarith⟩:Fin outputSize)=
            address start width ⟨2*p.val+1,by have := p.isLt;omega⟩ j hb := by
          apply Fin.ext
          change start+(p.val*(width+width)+(width+j.val))=start+width*(2*p.val+1)+j.val
          ring
        change out ⟨start+(p.val*(width+width)+(width+j.val)),_⟩=bitAt (pairs p).2 width j
        rw [hi]
        exact h
      _ = _ := encode_ofFn _ _

theorem split_fn (a b : Nat) (out : Fin (a+(1+b)) → Bool) :
    List.ofFn out=(List.ofFn (fun j : Fin a => out ⟨j.val,by omega⟩)) ++
      out ⟨a,by omega⟩ :: List.ofFn (fun j : Fin b => out ⟨a+1+j.val,by omega⟩) := by
  rw [List.ofFn_add]
  apply congrArg₂ List.append
  · rfl
  · have single (f : Fin 1 → Bool) : List.ofFn f=[f 0] := by rw [List.ofFn_succ,List.ofFn_zero]
    rw [List.ofFn_add,single,List.singleton_append]
    apply congrArg (List.cons (out ⟨a,by omega⟩))
    apply congrArg List.ofFn
    funext j
    apply congrArg out
    apply Fin.ext
    change a+(1+j.val)=a+1+j.val
    omega

attribute [local irreducible] List.ofFn

theorem split_output (out : Fin outputSize → Bool) :
    List.ofFn out=region out 0 24576 (by decide) ++
      out ⟨24576,by decide⟩ :: region out 24577 26112 (by decide) := by
  refine (split_fn 24576 26112 out).trans ?_
  apply congrArg₂ List.append
  · unfold region
    apply congrArg List.ofFn
    funext j
    apply congrArg out
    apply Fin.ext
    exact (Nat.zero_add j.val).symm
  · apply congrArg₂ List.cons
    · rfl
    · unfold region
      apply congrArg List.ofFn
      funext j
      rfl

end FT1536.S05.OutputFormat020D
