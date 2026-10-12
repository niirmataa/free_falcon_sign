import OutputSlice020D
import Run2.WordEncoding

namespace FT1536.S05.OutputChunks020D
open WordRAM020 FT1536.Run2.BitArithmetic

def address (start width : Nat) (p : Fin 1536) (j : Fin width)
    (hb : start+1536*width≤outputSize) : Fin outputSize :=
  ⟨start+width*p.val+j.val,by
    have hp : p.val+1≤1536 := by omega
    have hh := Nat.mul_le_mul_left width hp
    have hj := j.isLt
    nlinarith⟩
def bitAt (a width : Nat) (j : Fin width) : Bool :=
  have hj : j.val<(encodeNat a width).length := by rw [encodeNat_length];exact j.isLt
  (encodeNat a width)[j.val]
def Prefix (f : Fin 1536 → Nat) (start width : Nat) (hb : start+1536*width≤outputSize)
    (k : Nat) (out : Fin outputSize → Bool) : Prop :=
  ∀ p : Fin 1536, p.val<k → ∀ j : Fin width,
    out (address start width p j hb)=bitAt (f p) width j
def Frame (start width : Nat) (a b : Fin outputSize → Bool) : Prop :=
  ∀ j : Fin outputSize, j.val<start ∨ start+1536*width≤j.val → b j=a j

theorem prefix_zero (f : Fin 1536 → Nat) (start width : Nat) (hb : start+1536*width≤outputSize)
    (out : Fin outputSize → Bool) : Prefix f start width hb 0 out := by intro p hp;omega
theorem frame_refl (start width : Nat) (a : Fin outputSize → Bool) : Frame start width a a := fun _ _ => rfl
theorem frame_trans (start width : Nat) {a b c : Fin outputSize → Bool}
    (h : Frame start width a b) (h' : Frame start width b c) : Frame start width a c :=
  fun j hj => (h' j hj).trans (h j hj)

theorem end_bound (start width : Nat) (p : Fin 1536) (hb : start+1536*width≤outputSize) :
    start+width*p.val+width≤outputSize := by
  have hp : p.val+1≤1536 := by omega
  have hh := Nat.mul_le_mul_left width hp
  nlinarith

theorem prefix_step (f : Fin 1536 → Nat) (start width : Nat) (hb : start+1536*width≤outputSize)
    (p : Fin 1536) (out : Fin outputSize → Bool) (old : Prefix f start width hb p.val out) :
    Prefix f start width hb (p.val+1)
      (OutputSlice020D.write out (start+width*p.val) (encodeNat (f p) width)) := by
  intro q hq j
  by_cases he : q=p
  · subst q
    exact OutputSlice020D.write_at out (start+width*p.val) (encodeNat (f p) width) j.val
      (by rw [encodeNat_length];exact j.isLt) (by rw [encodeNat_length];exact end_bound _ _ p hb)
  · have hv : q.val<p.val := by have hn : q.val≠p.val := fun h => he (Fin.ext h);omega
    have hm := Nat.mul_le_mul_left width (show q.val+1≤p.val by omega)
    have hj := j.isLt
    have before : (address start width q j hb).val<start+width*p.val := by
      change start+width*q.val+j.val<start+width*p.val
      nlinarith
    exact (OutputSlice020D.write_other _ _ _ _ (Or.inl before)).trans (old q hv j)

theorem write_frame (start width : Nat) (p : Fin 1536) (out : Fin outputSize → Bool) (a : Nat) :
    Frame start width out (OutputSlice020D.write out (start+width*p.val) (encodeNat a width)) := by
  intro j hj
  apply OutputSlice020D.write_other
  rw [encodeNat_length]
  rcases hj with hj|hj
  · left;omega
  · right
    have hm := Nat.mul_le_mul_left width (show p.val+1≤1536 by omega)
    nlinarith

end FT1536.S05.OutputChunks020D
