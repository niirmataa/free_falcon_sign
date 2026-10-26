import Source3.ZintSubCall207

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormPrepare207
open C99ArrayReference (State Name Pointer)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32)
open StepCopyBody190 (elem)
open C99NatWord141 (word)
open ZintNormWord194 (wName ccName uName pName xName)
open KeygenZintCall (Exec)

def threshold (p cc : BitVec 32) := (p >>> 1) ||| (cc <<< 30)
 def declared (s : State) := C99DeclarationStatements.effect .u32 [wName] s
 def withW (s : State) (p cc : BitVec 32) := set32 (declared s) "w" (threshold p cc)
 def after (s : State) (p cc : BitVec 32) := set32 (withW s p cc) "cc" (p &&& 1)

theorem outside (s : State) (p cc : BitVec 32) (name : Name) (nw : name≠wName) (nc : name≠ccName) :
    (after s p cc).locals name=s.locals name :=
  (SelectedStepAddPrime195.locals_keep (withW s p cc) ccName .uint32 (.uint32 (p &&& 1)) name nc).trans
    ((SelectedStepAddPrime195.locals_keep (declared s) wName .uint32 (.uint32 (threshold p cc)) name nw).trans
      (ZintSubWord194.effect_one_other .u32 wName name s nw))

theorem wCell (s : State) (p cc : BitVec 32) : Slot (after s p cc) "w" (threshold p cc) :=
  (CrtState205.keep32 (withW s p cc) "cc" "w" (p &&& 1) (by decide)).trans (CrtState205.cell32 _ _ _)

theorem ccCell (s : State) (p cc : BitVec 32) : Slot (after s p cc) "cc" (p &&& 1) := CrtState205.cell32 _ _ _

theorem append_source (s : State) (pp : ArrayPointer) (i : Nat) (p cc : BitVec 32)
    (binding : s.arrays pName=some pp) (uc : Cell s uName i) (bound : i < 2^64) (cc0 : Slot s "cc" cc)
    (read : Load32 s.heap (elem pp i) p) (out : C99ProcedureReference.Result)
    (rest : Exec (.seq ZintNormWord194.normBranch1 (.seq ZintNormWord194.normBranch2 ZintNormWord194.wskip)) (after s p cc) out) :
    Exec ZintNormWord194.normInner s out := by
  have cap : pp.index+i ≤ pp.count := by
    cases read with | load _ h _ _ => have b:=h.2.2.1; change pp.index+i < pp.count at b; omega
  have uD : Cell (declared s) uName i := (ZintSubWord194.effect_one_other .u32 wName uName s (by decide)).trans uc
  have ccD : Slot (declared s) "cc" cc := (ZintSubWord194.effect_one_other .u32 wName ccName s (by decide)).trans cc0
  have ptrD : Pointer (declared s) pName (.var uName) (elem pp i) := by
    refine .add _ _ pp _ (.uint64 (word i)) binding (.variable _ _ _ uD) ?_ ?_
    · rw [C99NatWord141.integer i bound]; omega
    · rw [C99NatWord141.integer i bound]
      exact .within pp i cap
  have evalW : KeygenWordExpr.Eval (declared s) ZintNormWord194.rhsW (.uint32 (threshold p cc)) :=
    .bin .bor _ _ _ _ _ (.bin .shr _ _ _ _ _ (.load32 _ _ _ p ptrD read) (WordAtoms205.literal _ 1)
      (KeygenDecodeWordOps.right32 p 1 (by decide)))
      (.bin .shl _ _ _ _ _ (CrtState205.expr32 _ "cc" cc ccD) (WordAtoms205.literal _ 30)
        (KeygenDecodeWordOps.left32 cc 30 (by decide))) (KeygenDecodeWordOps.or32 _ _)
  have h1 : Exec ZintNormWord194.normDeclW s ⟨declared s,.normal⟩ := ZintNormWord194.word_declare .u32 [wName] s
  have h2 : Exec ZintNormWord194.normSetW (declared s) ⟨withW s p cc,.normal⟩ :=
    .word _ _ _ (WordAtoms205.assign32 _ "w" none _ _ (ZintSubWord194.effect_one_cell .u32 wName s) evalW)
  have uW : Cell (withW s p cc) uName i := (CrtState205.keep32 (declared s) "w" "u" (threshold p cc) (by decide)).trans uD
  have ccW : Slot (withW s p cc) "cc" cc := (CrtState205.keep32 (declared s) "w" "cc" (threshold p cc) (by decide)).trans ccD
  have ptrW : Pointer (withW s p cc) pName (.var uName) (elem pp i) := by
    refine .add _ _ pp _ (.uint64 (word i)) binding (.variable _ _ _ uW) ?_ ?_
    · rw [C99NatWord141.integer i bound]; omega
    · rw [C99NatWord141.integer i bound]
      exact .within pp i cap
  have h3 : Exec ZintNormWord194.normSetCC (withW s p cc) ⟨after s p cc,.normal⟩ :=
    .word _ _ _ (WordAtoms205.assign32 _ "cc" _ _ _ ccW
      (.bin .band _ _ _ _ _ (.load32 _ _ _ p ptrW read) (WordAtoms205.literal _ 1) (ZintNormWord194.and_one p)))
  exact .seqNormal _ _ _ _ _ h1 (.seqNormal _ _ _ _ _ h2 (.seqNormal _ _ _ _ _ h3 rest))

theorem comparisons (s : State) (px : ArrayPointer) (i : Nat) (x p cc : BitVec 32)
    (binding : s.arrays xName=some px) (uc : Cell s uName i) (bound : i < 2^64)
    (read : Load32 s.heap (elem px i) x) :
    KeygenWordExpr.Eval (after s p cc) ZintNormWord194.test1
      (C99ScalarReference.boolean (decide (x.toNat < (threshold p cc).toNat))) ∧
    KeygenWordExpr.Eval (after s p cc) ZintNormWord194.test2
      (C99ScalarReference.boolean (decide ((threshold p cc).toNat < x.toNat))) := by
  have cap : px.index+i ≤ px.count := by
    cases read with | load _ h _ _ => have b:=h.2.2.1; change px.index+i < px.count at b; omega
  have uA : Cell (after s p cc) uName i := (outside s p cc uName (by decide) (by decide)).trans uc
  have ptr : Pointer (after s p cc) xName (.var uName) (elem px i) := by
    refine .add _ _ px _ (.uint64 (word i)) binding (.variable _ _ _ uA) ?_ ?_
    · rw [C99NatWord141.integer i bound]; omega
    · rw [C99NatWord141.integer i bound]
      exact .within px i cap
  have load : KeygenWordExpr.Eval (after s p cc) ZintNormWord194.loadX (.uint32 x) := .load32 _ _ _ x ptr read
  have w : KeygenWordExpr.Eval (after s p cc) (.scalar (.var wName)) (.uint32 (threshold p cc)) := CrtState205.expr32 _ "w" _ (wCell s p cc)
  exact ⟨.cmp _ _ _ _ _ _ load w (ZintNormWord194.lt_word x (threshold p cc)),
    .cmp _ _ _ _ _ _ load w (ZintNormWord194.gt_word x (threshold p cc))⟩

end FT1536.Source3.ZintNormPrepare207
