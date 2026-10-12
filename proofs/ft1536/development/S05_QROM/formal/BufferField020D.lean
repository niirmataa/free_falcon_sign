import BufferUpdate020D
import Residue020D

namespace FT1536.S05.BufferField020D
open WordRAM020 PairProgram020 ReadSemantics020A BufferUpdate020D Residue020D
attribute [local irreducible] exec loopState

abbrev Coeffs := Fin 1536 → F
def Holds (s : State) (v : Coeffs) : Prop := ∀ r, s.ram (slot r)=fw (v r)
def addAt (v : Coeffs) (k : Fin 1536) (c : F) : Coeffs := Function.update v k (v k+c)
def Frame (s t : State) : Prop := t.out=s.out ∧ t.fault=s.fault ∧
  ∀ j : Fin ramSize, j.val<3072 → t.ram j=s.ram j

theorem frame_refl (s : State) : Frame s s := ⟨rfl,rfl,fun _ _ => rfl⟩
theorem frame_trans {s t u : State} (a : Frame s t) (b : Frame t u) : Frame s u :=
  ⟨b.1.trans a.1,b.2.1.trans a.2.1,fun j hj => (b.2.2 j hj).trans (a.2.2 j hj)⟩

theorem slot_injective : Function.Injective slot := by
  intro a b h
  apply Fin.ext
  have he := congrArg Fin.val h
  change 3072+a.val=3072+b.val at he
  omega

theorem result_holds (s : State) (v : Coeffs) (k : Fin 1536) (d : Int) (hs : Holds s v) :
    Holds (result s k (v k).val d) (addAt v k (d:F)) := by
  intro r
  by_cases hr : r=k
  · subst r
    rw [result_same,add_modular_word]
    simp [addAt]
  · rw [result_other _ _ _ _ _ (fun he => hr (slot_injective he))]
    simp [addAt,Function.update,hr,hs r]

theorem result_frame (s : State) (k : Fin 1536) (x d : Int) : Frame s (result s k x d) := by
  refine ⟨rfl,rfl,?_⟩
  intro j hj
  apply result_other
  intro he
  have hh := congrArg Fin.val he
  change j.val=3072+k.val at hh
  omega

/-- Filled operation-level canonical buffer update; d may be negative. -/
theorem update_holds (i : Input) (s : State) (v : Coeffs) (k : Fin 1536) (d : Int)
    (idx delta : Expr) (hs : Holds s v) (hd : -18433≤d ∧ d≤18433)
    (hi : eval s idx=word (k.val:Int)) (he : eval s delta=word d)
    (h26 : (26:Reg)∉reads delta) (h27 : (27:Reg)∉reads delta) :
    let t := exec i (update idx delta) s
    Holds t (addAt v k (d:F)) ∧ Frame s t ∧
      ∀ rr : Reg, rr≠26 → rr≠27 → t.reg rr=s.reg rr := by
  have run := update_correct i s k (v k).val d idx delta (field_bounds (v k)) hd hi he h26 h27 (hs k)
  dsimp only
  rw [run]
  exact ⟨result_holds s v k d hs,result_frame s k (v k).val d,
    fun rr hr26 hr27 => result_reg s k (v k).val d rr hr26 hr27⟩

theorem addAt_at (v : Coeffs) (k r : Fin 1536) (c : F) :
    addAt v k c r=v r+if k=r then c else 0 := by
  by_cases h : k=r
  · subst r;simp [addAt]
  · simp [addAt,Function.update,Ne.symm h,h]

end FT1536.S05.BufferField020D
