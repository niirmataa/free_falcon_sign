import Source3.ZintSignedExpr209

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintSignedWhole209
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32)
open ZintModSignedWord194 (zName dlenName dName pName p0iName r2Name rxName)
open ZintReduceLoop209 (Fixed)
open KeygenZintCall (Exec)

def positiveWord (W : Nat → BitVec 32) (n : Nat) (p pi r2 rx : BitVec 32) :=
  KeygenModpAddSub.result .sub (ZintReduceWhole209.resultWord W n p pi r2)
    (ZintModSignedWord194.signWord rx (W (n-1))) p
 def resultWord (W : Nat → BitVec 32) (n : Nat) (p pi r2 rx : BitVec 32) := if n=0 then 0 else positiveWord W n p pi r2 rx
 def declared (s : State) := C99DeclarationStatements.effect .u32 [zName] s
 def unsigned (s : State) (W : Nat → BitVec 32) (n : Nat) (p pi r2 : BitVec 32) :=
  set32 (declared s) "z" (ZintReduceWhole209.resultWord W n p pi r2)
 def after (s : State) (W : Nat → BitVec 32) (n : Nat) (p pi r2 rx : BitVec 32) := set32 (unsigned s W n p pi r2) "z" (positiveWord W n p pi r2 rx)

theorem declared_locals (s : State) (name : Name) (different : name≠zName) : (declared s).locals name=s.locals name :=
  ZintSubWord194.effect_one_other .u32 zName name s different

theorem declared_fixed (s : State) (pd : ArrayPointer) (n : Nat) (W : Nat → BitVec 32) (p pi r2 : BitVec 32)
    (fixed : Fixed s pd n W p pi r2) : Fixed (declared s) pd n W p pi r2 :=
  ⟨fixed.nBound,fixed.dBinding,(declared_locals s dlenName (by decide)).trans fixed.lenCell,
    (declared_locals s pName (by decide)).trans fixed.pCell,(declared_locals s p0iName (by decide)).trans fixed.iCell,
    (declared_locals s r2Name (by decide)).trans fixed.rCell,fixed.capacity,fixed.data⟩

theorem source (s : State) (pd : ArrayPointer) (n : Nat) (W : Nat → BitVec 32) (p pi r2 rx : BitVec 32)
    (fixed : Fixed s pd n W p pi r2) (rxCell : Slot s "Rx" rx) :
    ∃ out : C99ProcedureReference.Result, Exec (KeygenZintCall.calleeBody .modSigned) s out ∧
      C99ProcedureReference.ReturnValue (some .uint32) out.flow (some (.uint32 (resultWord W n p pi r2 rx))) ∧
      out.state.heap=s.heap ∧ out.state.arrays=s.arrays ∧
      (∀ name : Name, name≠zName → out.state.locals name=s.locals name) := by
  have decl : Exec MakeFgAddPrimeShape194.msDeclZ s ⟨declared s,.normal⟩ := by
    rw [ZintModSignedWord194.ms_decl_shape]
    exact .word _ _ _ (ZintSubWord194.declare_run .u32 [zName] s)
  have ready:=declared_fixed s pd n W p pi r2 fixed
  have zeroTest:=ZintSignedExpr209.zero_eval (declared s) n fixed.nBound ready.lenCell
  by_cases isZero : n=0
  · subst n
    have test : KeygenWordExpr.Eval (declared s) ZintModSignedWord194.zeroGuard (.int32 1) := by
      simpa [C99ScalarReference.boolean] using zeroTest
    have yes : Exec ZintModSignedWord194.zeroYes (declared s) ⟨declared s,.returned (some (.int32 0))⟩ :=
      .scope _ _ _ _ _ (.seqExit _ _ _ _ (.word _ _ _ (.ret _ _ _ (WordAtoms205.literal _ 0))) (by intro h; cases h))
    have branch : Exec MakeFgAddPrimeShape194.msZeroBranch (declared s) ⟨declared s,.returned (some (.int32 0))⟩ := by
      rw [ZintModSignedWord194.ms_zero_shape]
      exact .branchTrue _ _ _ _ _ (.int32 1) test (by decide) yes
    have whole : Exec (KeygenZintCall.calleeBody .modSigned) s ⟨declared s,.returned (some (.int32 0))⟩ := by
      change Exec MakeFgAddPrimeShape194.msBody s _
      rw [MakeFgAddPrimeShape194.ms_split1,MakeFgAddPrimeShape194.ms_split2]
      exact .seqNormal _ _ _ _ _ decl (.seqExit _ _ _ _ branch (by intro h; cases h))
    exact ⟨⟨declared s,.returned (some (.int32 0))⟩,whole,.value .uint32 (.int32 0),rfl,rfl,declared_locals s⟩
  · have positive : 0 < n := by omega
    have test : KeygenWordExpr.Eval (declared s) ZintModSignedWord194.zeroGuard (.int32 0) := by
      simpa [C99ScalarReference.boolean,isZero] using zeroTest
    have branch : Exec MakeFgAddPrimeShape194.msZeroBranch (declared s) ⟨declared s,.normal⟩ := by
      rw [ZintModSignedWord194.ms_zero_shape]
      exact .branchFalse _ _ _ _ _ (.int32 0) test (by decide) (.word _ _ _ (ZintSubWord194.skip_run _))
    have leaf : Exec MakeFgAddPrimeShape194.msReduceCall (declared s) ⟨unsigned s W n p pi r2,.normal⟩ := by
      rw [ZintModSignedWord194.ms_leaf_shape]
      exact ZintReduceCall209.source "d" "dlen" "z" (declared s) pd n W p pi r2 none
        ready.dBinding ready.lenCell ready.pCell ready.iCell ready.rCell
        (ZintSubWord194.effect_one_cell .u32 zName s) fixed.nBound fixed.capacity fixed.data
    have zU : Slot (unsigned s W n p pi r2) "z" (ZintReduceWhole209.resultWord W n p pi r2) := CrtState205.cell32 _ _ _
    have pU : Slot (unsigned s W n p pi r2) "p" p :=
      (CrtState205.keep32 (declared s) "z" "p" (ZintReduceWhole209.resultWord W n p pi r2) (by decide)).trans ready.pCell
    have rxU : Slot (unsigned s W n p pi r2) "Rx" rx :=
      (CrtState205.keep32 (declared s) "z" "Rx" (ZintReduceWhole209.resultWord W n p pi r2) (by decide)).trans
        ((declared_locals s rxName (by decide)).trans rxCell)
    have lenU : Cell (unsigned s W n p pi r2) dlenName n :=
      (CrtState205.keep32 (declared s) "z" "dlen" (ZintReduceWhole209.resultWord W n p pi r2) (by decide)).trans ready.lenCell
    have eval:=ZintSignedExpr209.sub_eval (unsigned s W n p pi r2) pd n (ZintReduceWhole209.resultWord W n p pi r2)
      (W (n-1)) p rx fixed.nBound positive ready.dBinding lenU fixed.capacity (fixed.data (n-1) (by omega)) zU pU rxU
    have sub : Exec MakeFgAddPrimeShape194.msSubAssign (unsigned s W n p pi r2) ⟨after s W n p pi r2 rx,.normal⟩ := by
      rw [ZintModSignedWord194.ms_sub_shape]
      exact .word _ _ _ (WordAtoms205.assign32 _ "z" _ _ _ zU eval)
    have ret : Exec MakeFgAddPrimeShape194.msRetZ (after s W n p pi r2 rx)
        ⟨after s W n p pi r2 rx,.returned (some (.uint32 (positiveWord W n p pi r2 rx)))⟩ := by
      rw [ZintModSignedWord194.ms_ret_shape]
      exact .word _ _ _ (.ret _ _ _ (CrtState205.expr32 _ "z" _ (CrtState205.cell32 _ _ _)))
    have whole : Exec (KeygenZintCall.calleeBody .modSigned) s
        ⟨after s W n p pi r2 rx,.returned (some (.uint32 (positiveWord W n p pi r2 rx)))⟩ := by
      change Exec MakeFgAddPrimeShape194.msBody s _
      rw [MakeFgAddPrimeShape194.ms_split1,MakeFgAddPrimeShape194.ms_split2,MakeFgAddPrimeShape194.ms_split3,
        MakeFgAddPrimeShape194.ms_split4,MakeFgAddPrimeShape194.ms_split5]
      exact .seqNormal _ _ _ _ _ decl (.seqNormal _ _ _ _ _ branch (.seqNormal _ _ _ _ _ leaf
        (.seqNormal _ _ _ _ _ sub (.seqExit _ _ _ _ ret (by intro h; cases h)))))
    have returned : C99ProcedureReference.ReturnValue (some .uint32)
        (.returned (some (.uint32 (positiveWord W n p pi r2 rx)))) (some (.uint32 (resultWord W n p pi r2 rx))) := by
      have raw:=C99ProcedureReference.ReturnValue.value .uint32 (.uint32 (positiveWord W n p pi r2 rx))
      rw [KeygenDecodeWordOps.self32] at raw
      simpa only [resultWord,ite_eq_right isZero] using raw
    refine ⟨_,whole,returned,rfl,rfl,?_⟩
    intro name different
    exact (SelectedStepAddPrime195.locals_keep (unsigned s W n p pi r2) zName .uint32 (.uint32 (positiveWord W n p pi r2 rx)) name different).trans
      ((SelectedStepAddPrime195.locals_keep (declared s) zName .uint32 (.uint32 (ZintReduceWhole209.resultWord W n p pi r2)) name different).trans
        (declared_locals s name different))

end FT1536.Source3.ZintSignedWhole209
