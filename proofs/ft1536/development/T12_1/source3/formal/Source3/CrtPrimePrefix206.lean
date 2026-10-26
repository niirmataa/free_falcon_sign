import Source3.CrtWalkLoop206

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtPrimePrefix206
open C99ArrayReference (State Name)
open C99MemoryReference (Load32)
open KeygenFullData127 (primes)
open SelectedStepAddPrime195 (p1 p0i1 r21 primes1)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32 Slot64)
open CrtRoundShape205 (declare cell)
open KeygenZintCall (Stmt Exec)

def s1 : BitVec 32 := 238827065
 def words : List Name := ["p".toList,"p0i".toList,"s".toList,"R2".toList]
 def declared (s : State) := C99DeclarationStatements.effect .u64 ["v".toList]
  (C99DeclarationStatements.effect .u32 words s)
 def withP (s : State) := set32 (declared s) "p" p1
 def withS (s : State) := set32 (withP s) "s" s1
 def withI (s : State) := set32 (withS s) "p0i" p0i1
 def after (s : State) := set32 (withI s) "R2" r21

 def prepend (tail : Stmt) : Stmt := .seq (declare .u32 words) (.seq (declare .u64 ["v".toList])
  (.seq (.prime "p".toList "primes".toList (.var "u".toList) .p)
  (.seq (.prime "s".toList "primes".toList (.var "u".toList) .s)
  (.seq (.word (.assign "p0i".toList (.call1 "modp_ninv31".toList (cell "p"))))
  (.seq (.word (.assign "R2".toList (.call2 "modp_R2".toList (cell "p") (cell "p0i")))) tail)))))

theorem inner_shape : CrtRoundShape205.inner=prepend
    (.seq (.seq CrtRoundShape205.walkInit CrtRoundShape205.walk)
      (.seq CrtRoundShape205.mulCall CrtRoundShape205.skip)) := rfl

theorem declared_outside (s : State) (name : Name) (absent : name∉CrtRoundShape205.localNames) :
    (declared s).locals name=s.locals name := by
  have nv : name≠"v".toList := fun eq => absent (eq ▸ (by decide))
  have nw : name∉words := fun member => absent (by
    change name∈words++["v".toList]
    exact List.mem_append_left _ member)
  exact (ZintSubWord194.effect_one_other .u64 "v".toList name _ nv).trans
    (SelectedStepAddPrime195.effect_locals .u32 words s name nw)

theorem outside (s : State) (name : Name) (absent : name∉CrtRoundShape205.localNames) :
    (after s).locals name=s.locals name := by
  have np : name≠"p".toList := fun eq => absent (eq ▸ (by decide))
  have ns : name≠"s".toList := fun eq => absent (eq ▸ (by decide))
  have ni : name≠"p0i".toList := fun eq => absent (eq ▸ (by decide))
  have nr : name≠"R2".toList := fun eq => absent (eq ▸ (by decide))
  exact (SelectedStepAddPrime195.locals_keep (withI s) "R2".toList .uint32 (.uint32 r21) name nr).trans
    ((SelectedStepAddPrime195.locals_keep (withS s) "p0i".toList .uint32 (.uint32 p0i1) name ni).trans
      ((SelectedStepAddPrime195.locals_keep (withP s) "s".toList .uint32 (.uint32 s1) name ns).trans
        ((SelectedStepAddPrime195.locals_keep (declared s) "p".toList .uint32 (.uint32 p1) name np).trans
          (declared_outside s name absent))))

theorem pCell (s : State) : Slot (after s) "p" p1 :=
  (CrtState205.keep32 (withI s) "R2" "p" r21 (by decide)).trans
    ((CrtState205.keep32 (withS s) "p0i" "p" p0i1 (by decide)).trans
      ((CrtState205.keep32 (withP s) "s" "p" s1 (by decide)).trans (CrtState205.cell32 _ _ _)))

theorem sCell (s : State) : Slot (after s) "s" s1 :=
  (CrtState205.keep32 (withI s) "R2" "s" r21 (by decide)).trans
    ((CrtState205.keep32 (withS s) "p0i" "s" p0i1 (by decide)).trans (CrtState205.cell32 _ _ _))

theorem iCell (s : State) : Slot (after s) "p0i" p0i1 :=
  (CrtState205.keep32 (withI s) "R2" "p0i" r21 (by decide)).trans (CrtState205.cell32 _ _ _)

theorem rCell (s : State) : Slot (after s) "R2" r21 := CrtState205.cell32 _ _ _

theorem vDeclared (s : State) : (after s).locals "v".toList=some (.uint64,none) := by
  have chain : (after s).locals "v".toList=(declared s).locals "v".toList := by
    simp only [after,withI,withS,withP,set32,ModularAtoms178.set,C99ArrayReference.bindValue,C99ScalarReference.set]
    rfl
  exact chain.trans (ZintSubWord194.effect_one_cell .u64 "v".toList _)

theorem source (s : State) (u : Slot64 s "u" 1) (binding : s.arrays "primes".toList=some primes)
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (tail : Stmt) (out : C99ProcedureReference.Result) (rest : Exec tail (after s) out) :
    Exec (prepend tail) s out := by
  have declaredU : Slot64 (declared s) "u" 1 := (declared_outside s "u".toList (by decide)).trans u
  have pRead : KeygenLevelCalls.PrimeRead (declared s) "primes".toList (.var "u".toList) .p (.uint32 p1) :=
    .read primes1 p1 (.add _ _ primes primes1 (.uint64 1) binding (.variable _ _ _ declaredU)
      (by decide) (.within primes 1 (by decide))) SelectedStepAddPrime195.primes1_width SelectedStepAddPrime195.primes1_extent
      (by rw [SelectedStepAddPrime195.fieldPointer_one]; exact SelectedStepAddPrime195.object_word s object)
  have pRun : Exec (.prime "p".toList "primes".toList (.var "u".toList) .p) (declared s) ⟨withP s,.normal⟩ :=
    .prime _ _ _ _ _ .uint32 none (.uint32 p1) rfl pRead
  have withPU : Slot64 (withP s) "u" 1 := (CrtState205.keep32 (declared s) "p" "u" p1 (by decide)).trans declaredU
  have sRead : KeygenLevelCalls.PrimeRead (withP s) "primes".toList (.var "u".toList) .s (.uint32 s1) :=
    .read primes1 s1 (.add _ _ primes primes1 (.uint64 1) binding (.variable _ _ _ withPU)
      (by decide) (.within primes 1 (by decide))) SelectedStepAddPrime195.primes1_width SelectedStepAddPrime195.primes1_extent
      (object.2.2.2.2.2.2 1 (2147346433,1119654270,238827065) SelectedStepAddPrime195.row1_value .s)
  have sRun : Exec (.prime "s".toList "primes".toList (.var "u".toList) .s) (withP s) ⟨withS s,.normal⟩ :=
    .prime _ _ _ _ _ .uint32 none (.uint32 s1) rfl sRead
  have pS : Slot (withS s) "p" p1 := (CrtState205.keep32 (withP s) "s" "p" s1 (by decide)).trans (CrtState205.cell32 _ _ _)
  have iRun : Exec (.word (.assign "p0i".toList (.call1 "modp_ninv31".toList (cell "p")))) (withS s) ⟨withI s,.normal⟩ :=
    .word _ _ _ (WordAtoms205.assign32 _ "p0i" none _ p0i1 rfl
      (.call1 _ _ _ _ (CrtState205.expr32 _ "p" p1 pS) (.inverse _ _ (KeygenNinv31.source_exists p1))))
  have pI : Slot (withI s) "p" p1 := (CrtState205.keep32 (withS s) "p0i" "p" p0i1 (by decide)).trans pS
  have iI : Slot (withI s) "p0i" p0i1 := CrtState205.cell32 _ _ _
  have rRun : Exec (.word (.assign "R2".toList (.call2 "modp_R2".toList (cell "p") (cell "p0i")))) (withI s) ⟨after s,.normal⟩ :=
    .word _ _ _ (WordAtoms205.assign32 _ "R2" none _ r21 rfl
      (.call2 _ _ _ _ _ _ (CrtState205.expr32 _ "p" p1 pI) (CrtState205.expr32 _ "p0i" p0i1 iI)
        (.r2 _ _ (KeygenModpR2Exec.source_exists (withI s) p1 p0i1))))
  exact .seqNormal _ _ _ _ _ (.word _ _ _ (ZintSubWord194.declare_run .u32 words s))
    (.seqNormal _ _ _ _ _ (.word _ _ _ (ZintSubWord194.declare_run .u64 ["v".toList] _))
      (.seqNormal _ _ _ _ _ pRun (.seqNormal _ _ _ _ _ sRun (.seqNormal _ _ _ _ _ iRun (.seqNormal _ _ _ _ _ rRun rest)))))

end FT1536.Source3.CrtPrimePrefix206
