import Source3.CrtRoundShape205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtCoefficient205
open C99ArrayReference (State Name Pointer restoreScope)
open C99MemoryReference (ArrayPointer Load32)
open KeygenModpR2Exec (Slot)
open CrtState205 (Slot64 set32)
open CrtRoundShape205
open KeygenZintCall (Exec)

def quotient (a p pi r2 : BitVec 32) := ZintModSignedWord194.unsignedWord a p pi r2
 def correctionWord (a b p pi r2 s : BitVec 32) :=
  KeygenModpWord.montgomery s (KeygenModpAddSub.result .sub b (quotient a p pi r2) p) p pi
 def declared (s : State) := C99DeclarationStatements.effect .u32 coeffNames s
 def withXp (s : State) (b : BitVec 32) := set32 (declared s) "xp" b
 def withXq (s : State) (a b p pi r2 : BitVec 32) := set32 (withXp s b) "xq" (quotient a p pi r2)
 def beforeWrite (s : State) (a b p pi r2 c : BitVec 32) :=
  set32 (withXq s a b p pi r2) "xr" (correctionWord a b p pi r2 c)
 def finalHeap (s : State) (x : ArrayPointer) (a b t p pi r2 c : BitVec 32) :=
  ZintAddMulWord205.finalHeap s x a t (correctionWord a b p pi r2 c)
 def innerOut (s : State) (x : ArrayPointer) (a b t p pi r2 c : BitVec 32) :=
  {beforeWrite s a b p pi r2 c with heap:=finalHeap s x a b t p pi r2 c}
 def after (s : State) (x : ArrayPointer) (a b t p pi r2 c : BitVec 32) :=
  restoreScope s (innerOut s x a b t p pi r2 c) coeffNames []

theorem declared_outside (s : State) (name : Name) (absent : name∉coeffNames) :
    (declared s).locals name=s.locals name :=
  SelectedStepAddPrime195.effect_locals .u32 coeffNames s name absent

theorem before_outside (s : State) (a b p pi r2 c : BitVec 32) (name : Name) (absent : name∉coeffNames) :
    (beforeWrite s a b p pi r2 c).locals name=s.locals name := by
  have hx : name≠"xp".toList := fun same => absent (same ▸ (by decide))
  have hq : name≠"xq".toList := fun same => absent (same ▸ (by decide))
  have hr : name≠"xr".toList := fun same => absent (same ▸ (by decide))
  exact (SelectedStepAddPrime195.locals_keep _ _ _ _ name hr).trans
    ((SelectedStepAddPrime195.locals_keep _ _ _ _ name hq).trans
      ((SelectedStepAddPrime195.locals_keep _ _ _ _ name hx).trans (declared_outside s name absent)))

theorem restored_locals (s : State) (x : ArrayPointer) (a b t p pi r2 c : BitVec 32) :
    (after s x a b t p pi r2 c).locals=s.locals := by
  funext name
  by_cases member : name∈coeffNames
  · simp only [after,restoreScope,C99ScalarReference.restore,List.contains_iff_mem,member,ite_true]
  · rw [show (after s x a b t p pi r2 c).locals name=(innerOut s x a b t p pi r2 c).locals name from
      WordControl205.restored _ _ coeffNames name member]
    exact before_outside s a b p pi r2 c name member

theorem source (s : State) (x tmp : ArrayPointer) (a b t p pi r2 c : BitVec 32)
    (xb : s.arrays "x".toList=some x) (tb : s.arrays "tmp".toList=some tmp)
    (u : Slot64 s "u" 1) (pp : Slot s "p" p) (ip : Slot s "p0i" pi)
    (rp : Slot s "R2" r2) (sp : Slot s "s" c)
    (ra : Load32 s.heap x a) (rb : Load32 s.heap (ZintAddMulWord205.next x) b)
    (rt : Load32 s.heap tmp t) (cap : x.index+1 < x.count)
    (writable : s.heap.writable x.block=true) :
    Exec coeff s ⟨after s x a b t p pi r2 c,.normal⟩ := by
  have dc : ∀ name∈coeffNames, (declared s).locals name=some (.uint32,none) := by
    intro name member
    simp [coeffNames] at member
    rcases member with h|h|h <;> subst name <;> rfl
  have uD : Slot64 (declared s) "u" 1 := (declared_outside s "u".toList (by decide)).trans u
  have tailBound : x.index+1 ≤ x.count := by omega
  have decl : Exec (declare .u32 coeffNames) s ⟨declared s,.normal⟩ :=
    .word _ _ _ (ZintSubWord194.declare_run .u32 coeffNames s)
  have readXp : Exec setXp (declared s) ⟨withXp s b,.normal⟩ :=
    .word _ _ _ (WordAtoms205.assign32 _ "xp" none _ b (dc _ (by decide))
      (.load32 _ _ (ZintAddMulWord205.next x) b
        (.add _ _ x _ (.uint64 1) xb (.variable _ _ _ uD) (by decide) (.within x 1 tailBound)) rb))
  have uP : Slot64 (withXp s b) "u" 1 := (CrtState205.keep32 (declared s) "xp" "u" b (by decide)).trans uD
  have pP : Slot (withXp s b) "p" p := (CrtState205.keep32 (declared s) "xp" "p" b (by decide)).trans
    ((declared_outside s "p".toList (by decide)).trans pp)
  have iP : Slot (withXp s b) "p0i" pi := (CrtState205.keep32 (declared s) "xp" "p0i" b (by decide)).trans
    ((declared_outside s "p0i".toList (by decide)).trans ip)
  have rP : Slot (withXp s b) "R2" r2 := (CrtState205.keep32 (declared s) "xp" "R2" b (by decide)).trans
    ((declared_outside s "R2".toList (by decide)).trans rp)
  have qD : (withXp s b).locals "xq".toList=some (.uint32,none) :=
    (CrtState205.keep32 (declared s) "xp" "xq" b (by decide)).trans (dc _ (by decide))
  have reduce : Exec reduceCall (withXp s b) ⟨withXq s a b p pi r2,.normal⟩ :=
    CrtReduceCall205.source _ x a p pi r2 xb uP pP iP rP qD ra
  have qQ : Slot (withXq s a b p pi r2) "xq" (quotient a p pi r2) := CrtState205.cell32 _ _ _
  have bQ : Slot (withXq s a b p pi r2) "xp" b :=
    (CrtState205.keep32 (withXp s b) "xq" "xp" (quotient a p pi r2) (by decide)).trans (CrtState205.cell32 _ _ _)
  have pQ : Slot (withXq s a b p pi r2) "p" p :=
    (CrtState205.keep32 (withXp s b) "xq" "p" (quotient a p pi r2) (by decide)).trans pP
  have iQ : Slot (withXq s a b p pi r2) "p0i" pi :=
    (CrtState205.keep32 (withXp s b) "xq" "p0i" (quotient a p pi r2) (by decide)).trans iP
  have sQ : Slot (withXq s a b p pi r2) "s" c :=
    (CrtState205.keep32 (withXp s b) "xq" "s" (quotient a p pi r2) (by decide)).trans
      ((CrtState205.keep32 (declared s) "xp" "s" b (by decide)).trans
        ((declared_outside s "s".toList (by decide)).trans sp))
  have rD : (withXq s a b p pi r2).locals "xr".toList=some (.uint32,none) :=
    (CrtState205.keep32 (withXp s b) "xq" "xr" (quotient a p pi r2) (by decide)).trans
      ((CrtState205.keep32 (declared s) "xp" "xr" b (by decide)).trans (dc _ (by decide)))
  have ce : KeygenWordExpr.Eval (withXq s a b p pi r2) correction (.uint32 (correctionWord a b p pi r2 c)) :=
    .call4 _ _ _ _ _ _ _ _ _ _ (CrtState205.expr32 _ "s" c sQ)
      (.call3 _ _ _ _ _ _ _ _ (CrtState205.expr32 _ "xp" b bQ) (CrtState205.expr32 _ "xq" _ qQ)
        (CrtState205.expr32 _ "p" p pQ) (.sub _ _ (KeygenModpAddSub.source_exists .sub b (quotient a p pi r2) p)))
      (CrtState205.expr32 _ "p" p pQ) (CrtState205.expr32 _ "p0i" pi iQ)
      (.montgomery _ _ (KeygenModpWord.source_exists c (KeygenModpAddSub.result .sub b (quotient a p pi r2) p) p pi))
  have setR : Exec setXr (withXq s a b p pi r2) ⟨beforeWrite s a b p pi r2 c,.normal⟩ :=
    .word _ _ _ (WordAtoms205.assign32 _ "xr" none _ _ rD ce)
  have uR : Slot64 (beforeWrite s a b p pi r2 c) "u" 1 :=
    (before_outside s a b p pi r2 c "u".toList (by decide)).trans u
  have add : Exec addCall (beforeWrite s a b p pi r2 c) ⟨innerOut s x a b t p pi r2 c,.normal⟩ :=
    CrtAddMulCall205.source _ x tmp a t (correctionWord a b p pi r2 c) xb tb uR
      (CrtState205.cell32 _ _ _) ra rt cap writable
  have tail : Exec skip (innerOut s x a b t p pi r2 c) ⟨innerOut s x a b t p pi r2 c,.normal⟩ :=
    .word _ _ _ (ZintSubWord194.skip_run _)
  have inner : Exec coeffBody s ⟨innerOut s x a b t p pi r2 c,.normal⟩ :=
    .seqNormal _ _ _ _ _ decl (.seqNormal _ _ _ _ _ readXp (.seqNormal _ _ _ _ _ reduce
      (.seqNormal _ _ _ _ _ setR (.seqNormal _ _ _ _ _ add tail))))
  exact .scope _ _ _ _ _ inner

end FT1536.Source3.CrtCoefficient205
