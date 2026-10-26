import Source3.SecondStepCrtFull208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintReduceStep209
open C99ArrayReference (State Name restoreScope Pointer)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32 set64)
open C99NatWord141 (word)
open StepCopyBody190 (elem)
open ZintModSignedWord194 (xName uName wName pName p0iName r2Name dName)
open KeygenWordExec (Exec)

def corrected (a p : BitVec 32) := (a-p)+(p &&& (-((a-p) >>> 31)))
 def mont (acc p pi r2 : BitVec 32) := KeygenModpWord.montgomery acc r2 p pi
 def stepWord (acc a p pi r2 : BitVec 32) := KeygenModpAddSub.result .add (mont acc p pi r2) (corrected a p) p
 def lower (s : State) (i : Nat) := set64 s "u" (word i)
 def declared (s : State) (i : Nat) := C99DeclarationStatements.effect .u32 [wName] (lower s i)
 def withMont (s : State) (i : Nat) (acc p pi r2 : BitVec 32) := set32 (declared s i) "x" (mont acc p pi r2)
 def withSub (s : State) (i : Nat) (acc a p pi r2 : BitVec 32) := set32 (withMont s i acc p pi r2) "w" (a-p)
 def adjusted (s : State) (i : Nat) (acc a p pi r2 : BitVec 32) := set32 (withSub s i acc a p pi r2) "w" (corrected a p)
 def finished (s : State) (i : Nat) (acc a p pi r2 : BitVec 32) := set32 (adjusted s i acc a p pi r2) "x" (stepWord acc a p pi r2)
 def after (s : State) (i : Nat) (acc a p pi r2 : BitVec 32) := restoreScope (lower s i) (finished s i acc a p pi r2) [wName] []

theorem declared_outside (s : State) (i : Nat) (name : Name) (nu : name≠uName) (nw : name≠wName) :
    (declared s i).locals name=s.locals name :=
  (ZintSubWord194.effect_one_other .u32 wName name (lower s i) nw).trans
    (SelectedStepAddPrime195.locals_keep s uName .uint64 (.uint64 (word i)) name nu)

theorem lower_source (s : State) (i : Nat) (bound : i+1 < 2^64) (uc : Cell s uName (i+1)) :
    Exec ZintModSignedWord194.leafDecU s ⟨lower s i,.normal⟩ := by
  have raw:=ZintNormState207.decrement s i bound uc
  change KeygenZintCall.Exec (.word ZintModSignedWord194.leafDecU) s ⟨lower s i,.normal⟩ at raw
  cases raw with | word _ _ _ source => exact source

theorem locals (s : State) (i : Nat) (acc a p pi r2 : BitVec 32) (name : Name) (nu : name≠uName) (nx : name≠xName) :
    (after s i acc a p pi r2).locals name=s.locals name := by
  by_cases same : name=wName
  · subst name
    change (if [wName].contains wName then (lower s i).locals wName else (finished s i acc a p pi r2).locals wName)=s.locals wName
    rw [show [wName].contains wName=true by decide]
    exact SelectedStepAddPrime195.locals_keep s uName .uint64 (.uint64 (word i)) wName (by decide)
  · rw [show (after s i acc a p pi r2).locals name=(finished s i acc a p pi r2).locals name from
      WordControl205.restored _ _ [wName] name (by simpa only [List.mem_singleton] using same)]
    exact (SelectedStepAddPrime195.locals_keep (adjusted s i acc a p pi r2) xName .uint32 (.uint32 (stepWord acc a p pi r2)) name nx).trans
      ((SelectedStepAddPrime195.locals_keep (withSub s i acc a p pi r2) wName .uint32 (.uint32 (corrected a p)) name same).trans
        ((SelectedStepAddPrime195.locals_keep (withMont s i acc p pi r2) wName .uint32 (.uint32 (a-p)) name same).trans
          ((SelectedStepAddPrime195.locals_keep (declared s i) xName .uint32 (.uint32 (mont acc p pi r2)) name nx).trans
            (declared_outside s i name nu same))))

theorem xCell (s : State) (i : Nat) (acc a p pi r2 : BitVec 32) : Slot (after s i acc a p pi r2) "x" (stepWord acc a p pi r2) :=
  (WordControl205.restored (lower s i) (finished s i acc a p pi r2) [wName] "x".toList (by decide)).trans
    (CrtState205.cell32 _ _ _)

theorem uCell (s : State) (i : Nat) (acc a p pi r2 : BitVec 32) : Cell (after s i acc a p pi r2) uName i := by
  have upper : (finished s i acc a p pi r2).locals uName=(lower s i).locals uName := by
    simp only [finished,adjusted,withSub,withMont,set32,ModularAtoms178.set,C99ArrayReference.bindValue,C99ScalarReference.set]
    change (declared s i).locals uName=(lower s i).locals uName
    exact ZintSubWord194.effect_one_other .u32 wName uName (lower s i) (by decide)
  exact (WordControl205.restored (lower s i) (finished s i acc a p pi r2) [wName] uName (by decide)).trans
    (upper.trans (CrtState205.cell64 s "u" (word i)))

theorem source (s : State) (pd : ArrayPointer) (i : Nat) (acc a p pi r2 : BitVec 32)
    (bound : i+1 < 2^64) (uc : Cell s uName (i+1)) (db : s.arrays dName=some pd)
    (xc : Slot s "x" acc) (pc : Slot s "p" p) (ic : Slot s "p0i" pi) (rc : Slot s "R2" r2)
    (read : Load32 s.heap (elem pd i) a) :
    Exec ZintModSignedWord194.leafLoopBody s ⟨after s i acc a p pi r2,.normal⟩ := by
  have pdCell : Slot (declared s i) "p" p := (declared_outside s i pName (by decide) (by decide)).trans pc
  have idCell : Slot (declared s i) "p0i" pi := (declared_outside s i p0iName (by decide) (by decide)).trans ic
  have rdCell : Slot (declared s i) "R2" r2 := (declared_outside s i r2Name (by decide) (by decide)).trans rc
  have xdCell : Slot (declared s i) "x" acc := (declared_outside s i xName (by decide) (by decide)).trans xc
  have h1 : Exec ZintModSignedWord194.leafDeclW (lower s i) ⟨declared s i,.normal⟩ := ZintSubWord194.declare_run .u32 [wName] _
  have h2 : Exec ZintModSignedWord194.leafSetXMont (declared s i) ⟨withMont s i acc p pi r2,.normal⟩ :=
    WordAtoms205.assign32 _ "x" _ _ _ xdCell (ZintModSignedWord194.mont_eval _ acc p pi r2 xdCell pdCell idCell rdCell)
  have pM : Slot (withMont s i acc p pi r2) "p" p :=
    (CrtState205.keep32 (declared s i) "x" "p" (mont acc p pi r2) (by decide)).trans pdCell
  have uD : Cell (declared s i) uName i := (ZintSubWord194.effect_one_other .u32 wName uName (lower s i) (by decide)).trans
    (CrtState205.cell64 s "u" (word i))
  have uM : Cell (withMont s i acc p pi r2) uName i :=
    (CrtState205.keep32 (declared s i) "x" "u" (mont acc p pi r2) (by decide)).trans uD
  have cap : pd.index+i ≤ pd.count := by
    cases read with | load _ h _ _ => have b:=h.2.2.1; change pd.index+i < pd.count at b; omega
  have ptr : Pointer (withMont s i acc p pi r2) dName (.var uName) (elem pd i) := by
    refine .add _ _ pd _ (.uint64 (word i)) db (.variable _ _ _ uM) ?_ ?_
    · rw [C99NatWord141.integer i (by omega)]; omega
    · rw [C99NatWord141.integer i (by omega)]
      exact .within pd i cap
  have wd : (withMont s i acc p pi r2).locals wName=some (.uint32,none) :=
    (CrtState205.keep32 (declared s i) "x" "w" (mont acc p pi r2) (by decide)).trans (ZintSubWord194.effect_one_cell .u32 wName _)
  have h3 : Exec ZintModSignedWord194.leafSetWSub (withMont s i acc p pi r2) ⟨withSub s i acc a p pi r2,.normal⟩ :=
    WordAtoms205.assign32 _ "w" none _ (a-p) wd
      (.bin .sub _ _ _ _ _ (.load32 _ _ _ a ptr read) (CrtState205.expr32 _ "p" p pM) (KeygenDecodeWordOps.sub32 a p))
  have pS : Slot (withSub s i acc a p pi r2) "p" p :=
    (CrtState205.keep32 (withMont s i acc p pi r2) "w" "p" (a-p) (by decide)).trans pM
  have wS : Slot (withSub s i acc a p pi r2) "w" (a-p) := CrtState205.cell32 _ _ _
  have h4 : Exec ZintModSignedWord194.leafSetWAdd (withSub s i acc a p pi r2) ⟨adjusted s i acc a p pi r2,.normal⟩ :=
    WordAtoms205.assign32 _ "w" _ _ _ wS (ZintModSignedWord194.wadd_eval _ (a-p) p wS pS)
  have pA : Slot (adjusted s i acc a p pi r2) "p" p :=
    (CrtState205.keep32 (withSub s i acc a p pi r2) "w" "p" (corrected a p) (by decide)).trans pS
  have xA : Slot (adjusted s i acc a p pi r2) "x" (mont acc p pi r2) :=
    (CrtState205.keep32 (withSub s i acc a p pi r2) "w" "x" (corrected a p) (by decide)).trans
      ((CrtState205.keep32 (withMont s i acc p pi r2) "w" "x" (a-p) (by decide)).trans (CrtState205.cell32 _ _ _))
  have wA : Slot (adjusted s i acc a p pi r2) "w" (corrected a p) := CrtState205.cell32 _ _ _
  have h5 : Exec ZintModSignedWord194.leafSetXAdd (adjusted s i acc a p pi r2) ⟨finished s i acc a p pi r2,.normal⟩ :=
    WordAtoms205.assign32 _ "x" _ _ _ xA (ZintModSignedWord194.add_eval _ (mont acc p pi r2) (corrected a p) p xA wA pA)
  have hs : Exec ZintModSignedWord194.wskip (finished s i acc a p pi r2) ⟨finished s i acc a p pi r2,.normal⟩ := ZintSubWord194.skip_run _
  have inner : Exec (.seq ZintModSignedWord194.leafDeclW (.seq ZintModSignedWord194.leafSetXMont
      (.seq ZintModSignedWord194.leafSetWSub (.seq ZintModSignedWord194.leafSetWAdd (.seq ZintModSignedWord194.leafSetXAdd ZintModSignedWord194.wskip)))))
      (lower s i) ⟨finished s i acc a p pi r2,.normal⟩ :=
    .seqNormal _ _ _ _ _ h1 (.seqNormal _ _ _ _ _ h2 (.seqNormal _ _ _ _ _ h3 (.seqNormal _ _ _ _ _ h4 (.seqNormal _ _ _ _ _ h5 hs))))
  exact .seqNormal _ _ _ _ _ (lower_source s i bound uc) (.scope _ _ _ _ inner)

end FT1536.Source3.ZintReduceStep209
