import Source3.ZintNormLoop207

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintNormWhole207
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open CrtState205 (set64)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open C99NatWord141 (word)
open ZintNormFixed207 (Fixed Image choice flow)
open ZintNormWord194 (t1 t2 t3 uName ccName lenName)
open KeygenZintCall (Exec)

def start (s : State) (n : Nat) := set64 (t3 s) "u" (word n)
 def wrapped (s : State) := set64 s "u" (0#64-1#64)

theorem before (s : State) (name : Name) (nu : name≠uName) (nc : name≠ccName) :
    (t3 s).locals name=s.locals name :=
  (SelectedStepAddPrime195.locals_keep (t2 s) ccName .uint32 (.int32 0) name nc).trans
    ((ZintSubWord194.effect_one_other .u64 uName name (t1 s) nu).trans
      (ZintSubWord194.effect_one_other .u32 ccName name s nc))

theorem initial_fixed (s : State) (px pp : ArrayPointer) (n : Nat) (xv pv : Nat → BitVec 32)
    (fixed : Fixed s px pp n xv pv) : Fixed (start s n) px pp n xv pv := by
  apply ZintNormFixed207.transport s (start s n) px pp n xv pv fixed rfl rfl
  exact (CrtState205.keep64 (t3 s) "u" "len" (word n) (by decide)).trans (before s lenName (by decide) (by decide))

theorem append_source (s : State) (n : Nat) (len : Cell s lenName n) (out : C99ProcedureReference.Result)
    (rest : Exec (.seq ZintNormWord194.normLoopDec ZintNormWord194.wskip) (start s n) out) :
    Exec (KeygenZintCall.calleeBody .normZero) s out := by
  have h1 : Exec ZintNormWord194.normDeclC s ⟨t1 s,.normal⟩ := ZintNormWord194.word_declare .u32 [ccName] s
  have h2 : Exec ZintNormWord194.normDeclU (t1 s) ⟨t2 s,.normal⟩ := ZintNormWord194.word_declare .u64 [uName] (t1 s)
  have h3 : Exec ZintNormWord194.normCC0 (t2 s) ⟨t3 s,.normal⟩ :=
    .word _ _ _ (.assign _ _ _ .uint32 none (.int32 0) rfl (WordAtoms205.literal _ 0))
  have len3 : Cell (t3 s) lenName n := (before s lenName (by decide) (by decide)).trans len
  have h4 : Exec ZintNormWord194.normSetU (t3 s) ⟨start s n,.normal⟩ :=
    .word _ _ _ (WordAtoms205.assign64 _ "u" none _ (word n) rfl (CrtState205.expr64 _ "len" (word n) len3))
  rw [ZintNormWord194.norm_shape]
  exact .seqNormal _ _ _ _ _ h1 (.seqNormal _ _ _ _ _ h2 (.seqNormal _ _ _ _ _ h3 (.seqNormal _ _ _ _ _ h4 rest)))

theorem source (s : State) (px pp : ArrayPointer) (n : Nat) (xv pv : Nat → BitVec 32)
    (fixed : Fixed s px pp n xv pv) :
    ∃ out : C99ProcedureReference.Result, Exec (KeygenZintCall.calleeBody .normZero) s out ∧
      C99ProcedureReference.ReturnValue none out.flow none ∧ Image out.state px n xv pv (choice xv pv 0 n) ∧
      (∀ q old, (∀ i, i < n → Separate (elem px i) q) → Load32 s.heap q old → Load32 out.state.heap q old) := by
  have uc : Cell (start s n) uName n := CrtState205.cell64 _ _ _
  have cc : Slot (start s n) "cc" 0 :=
    (CrtState205.keep64 (t3 s) "u" "cc" (word n) (by decide)).trans (ZintNormWord194.cc_at3 s)
  obtain ⟨⟨last,flag⟩,loopRun,flowOut,image,zero,keep⟩:=ZintNormLoop207.source n (start s n) px pp n xv pv 0
    (initial_fixed s px pp n xv pv fixed) (Nat.le_refl n) uc cc
  by_cases equal : choice xv pv 0 n=.eq
  · have normal : flag=.normal := by simpa only [flow,equal,ite_true] using flowOut
    subst flag
    have u0 : Cell last uName 0 := zero rfl
    have decrement : Exec ZintNormWord194.normTailDec last ⟨wrapped last,.normal⟩ :=
      ZintNormWord194.word_update last uName .sub (.literal .i32 1) .uint64 (.uint64 0) (.int32 1)
        (.uint64 (0#64-1#64)) u0 (.literal .int32 1) ZintNormWord194.dec_zero
    have loopDec : Exec ZintNormWord194.normLoopDec (start s n) ⟨wrapped last,.normal⟩ :=
      .seqNormal _ _ _ _ _ loopRun decrement
    have rest : Exec (.seq ZintNormWord194.normLoopDec ZintNormWord194.wskip) (start s n) ⟨wrapped last,.normal⟩ :=
      .seqNormal _ _ _ _ _ loopDec (ZintNormWord194.word_skip _)
    exact ⟨⟨wrapped last,.normal⟩,append_source s n fixed.lenCell _ rest,.voidEnd,image,keep⟩
  · have returned : flag=.returned none := by simpa only [flow,equal,ite_false] using flowOut
    subst flag
    have loopDec : Exec ZintNormWord194.normLoopDec (start s n) ⟨last,.returned none⟩ :=
      .seqExit _ _ _ _ loopRun (by intro h; cases h)
    have rest : Exec (.seq ZintNormWord194.normLoopDec ZintNormWord194.wskip) (start s n) ⟨last,.returned none⟩ :=
      .seqExit _ _ _ _ loopDec (by intro h; cases h)
    exact ⟨⟨last,.returned none⟩,append_source s n fixed.lenCell _ rest,.voidReturn,image,keep⟩

end FT1536.Source3.ZintNormWhole207
