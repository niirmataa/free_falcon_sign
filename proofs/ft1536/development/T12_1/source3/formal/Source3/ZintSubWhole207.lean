import Source3.ZintSubLoop207

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintSubWhole207
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open CrtState205 (set32 set64)
open StepCopyBody190 (elem)
open Word32Memory176 (Separate)
open ZintSubFixed207 (Fixed Pending Written borrowWord)
open ZintMulWord205 (s1 s2 s3 s4)
open KeygenWordExec (Exec)

theorem source (s : State) (pa pb : ArrayPointer) (n : Nat) (av bv : Nat → BitVec 32)
    (fixed : Fixed s pa pb n bv) (initial : ∀ i, i < n → Load32 s.heap (elem pa i) (av i)) :
    ∃ out : C99ProcedureReference.Result, Exec (KeygenZintLeaves.code .sub) s out ∧
      out.flow=.returned (some (.uint32 (borrowWord av bv n))) ∧ Written out.state pa av bv n ∧
      (∀ name : Name, name≠ZintSubWord194.uName → name≠ZintSubWord194.ccName → out.state.locals name=s.locals name) ∧
      out.state.arrays=s.arrays ∧
      (∀ q old, (∀ i, i < n → Separate (elem pa i) q) → Load32 s.heap q old → Load32 out.state.heap q old) := by
  have h1 : Exec ZintSubWord194.declU s ⟨s1 s,.normal⟩ := ZintSubWord194.declare_run .u64 [ZintSubWord194.uName] s
  have h2 : Exec ZintSubWord194.declCC (s1 s) ⟨s2 s,.normal⟩ := ZintSubWord194.declare_run .u32 [ZintSubWord194.ccName] (s1 s)
  have h3 : Exec ZintSubWord194.setCC0 (s2 s) ⟨s3 s,.normal⟩ :=
    .assign _ _ _ .uint32 none (.int32 0) (ZintSubWord194.effect_one_cell .u32 ZintSubWord194.ccName (s1 s)) (WordAtoms205.literal _ 0)
  have ud : (s3 s).locals ZintSubWord194.uName=some (.uint64,none) := by
    change (set32 (s2 s) "cc" 0).locals "u".toList=_
    rw [CrtState205.keep32 _ "cc" "u" 0 (by decide)]
    unfold s2
    rw [ZintSubWord194.effect_one_other .u32 "cc".toList "u".toList (s1 s) (by decide)]
    exact ZintSubWord194.effect_one_cell .u64 "u".toList s
  have h4 : Exec ZintSubWord194.setU0 (s3 s) ⟨s4 s,.normal⟩ :=
    .assign _ _ _ .uint64 none (.int32 0) ud (WordAtoms205.literal _ 0)
  have startFixed : Fixed (s4 s) pa pb n bv := by
    refine ⟨fixed.nBound,fixed.width,fixed.capacity,fixed.writable,fixed.aBinding,fixed.bBinding,?_,fixed.bRead,fixed.apart⟩
    exact (ZintAddMulWord205.before4 s ZintSubWord194.lenName (by decide) (by decide)).trans fixed.lenCell
  have uStart : Cell (s4 s) ZintSubWord194.uName 0 := ZintMulWord205.u4 s
  have ccStart : Slot (s4 s) "cc" (borrowWord av bv 0) :=
    (CrtState205.keep64 (s3 s) "u" "cc" 0 (by decide)).trans (CrtState205.cell32 _ _ _)
  obtain ⟨out,loopRun,_,_,ccFinal,written,locals,arrays,keep⟩:=
    ZintSubLoop207.remaining n 0 (s4 s) pa pb n av bv startFixed uStart ccStart
      (fun i _ bound => initial i bound) (fun i h => by omega) (by omega)
  have ret : Exec ZintSubWord194.tailRet out ⟨out,.returned (some (.uint32 (borrowWord av bv n)))⟩ :=
    .ret _ _ _ (CrtState205.expr32 out "cc" (borrowWord av bv n) ccFinal)
  have tail : Exec ZintSubWord194.tail out ⟨out,.returned (some (.uint32 (borrowWord av bv n)))⟩ :=
    .seqExit _ _ _ _ ret (by intro h; cases h)
  have full : Exec ZintSubWord194.body s ⟨out,.returned (some (.uint32 (borrowWord av bv n)))⟩ :=
    .seqNormal _ _ _ _ _ h1 (.seqNormal _ _ _ _ _ h2 (.seqNormal _ _ _ _ _ h3
      (.seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ h4 loopRun) tail)))
  refine ⟨⟨out,.returned (some (.uint32 (borrowWord av bv n)))⟩,?_,rfl,written,?_,arrays,keep⟩
  · rw [ZintSubWord194.sub_shape]
    exact full
  · intro name nu nc
    exact (locals name nu nc).trans (ZintAddMulWord205.before4 s name nu nc)

end FT1536.Source3.ZintSubWhole207
