import Source3.ZintMulLoop213

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintMulWhole213
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open CrtState205 (set32 set64)
open StepCopyBody190 (elem)
open Word32Memory176 (Separate)
open ZintMulFixed213 (Fixed Pending Written carryWord)
open ZintMulWord205 (s1 s2 s3 s4)
open KeygenWordExec (Exec)

theorem source (s : State) (pa : ArrayPointer) (n : Nat) (av : Nat → BitVec 32) (b : BitVec 32)
    (fixed : Fixed s pa n b) (initial : ∀ i, i < n → Load32 s.heap (elem pa i) (av i)) :
    ∃ out : C99ProcedureReference.Result, Exec (KeygenZintLeaves.code .mul) s out ∧
      out.flow=.returned (some (.uint32 (carryWord av b n))) ∧ Written out.state pa av b n ∧
      (∀ name : Name, name≠ZintMulWord205.u → name≠ZintMulWord205.cc → out.state.locals name=s.locals name) ∧
      out.state.arrays=s.arrays ∧
      (∀ q old, (∀ i, i < n → Separate (elem pa i) q) → Load32 s.heap q old → Load32 out.state.heap q old) := by
  have h1 : Exec ZintMulWord205.declU s ⟨s1 s,.normal⟩ := ZintSubWord194.declare_run .u64 [ZintMulWord205.u] s
  have h2 : Exec ZintMulWord205.declCC (s1 s) ⟨s2 s,.normal⟩ := ZintSubWord194.declare_run .u32 [ZintMulWord205.cc] (s1 s)
  have h3 : Exec ZintMulWord205.cc0 (s2 s) ⟨s3 s,.normal⟩ :=
    .assign _ _ _ .uint32 none (.int32 0) (ZintSubWord194.effect_one_cell .u32 ZintMulWord205.cc (s1 s)) (WordAtoms205.literal _ 0)
  have ud : (s3 s).locals ZintMulWord205.u=some (.uint64,none) := by
    change (set32 (s2 s) "cc" 0).locals "u".toList=_
    rw [CrtState205.keep32 _ "cc" "u" 0 (by decide)]
    unfold s2
    rw [ZintSubWord194.effect_one_other .u32 "cc".toList "u".toList (s1 s) (by decide)]
    exact ZintSubWord194.effect_one_cell .u64 "u".toList s
  have h4 : Exec ZintMulWord205.u0 (s3 s) ⟨s4 s,.normal⟩ :=
    .assign _ _ _ .uint64 none (.int32 0) ud (WordAtoms205.literal _ 0)
  have startFixed : Fixed (s4 s) pa n b := by
    refine ⟨fixed.nBound,fixed.width,fixed.capacity,fixed.writable,fixed.binding,?_,?_⟩
    · exact (ZintAddMulWord205.before4 s ZintMulWord205.mlen (by decide) (by decide)).trans fixed.lenCell
    · exact (ZintAddMulWord205.before4 s "x".toList (by decide) (by decide)).trans fixed.xCell
  have uStart : Cell (s4 s) ZintMulWord205.u 0 := ZintMulWord205.u4 s
  have ccStart : Slot (s4 s) "cc" (carryWord av b 0) :=
    (CrtState205.keep64 (s3 s) "u" "cc" 0 (by decide)).trans (CrtState205.cell32 _ _ _)
  obtain ⟨out,loopRun,_,_,ccFinal,written,locals,arrays,keep⟩:=
    ZintMulLoop213.remaining n 0 (s4 s) pa n av b startFixed uStart ccStart
      (fun i _ bound => initial i bound) (fun i h => by omega) (by omega)
  have ret : Exec ZintMulWord205.ret out ⟨out,.returned (some (.uint32 (carryWord av b n)))⟩ :=
    .ret _ _ _ (CrtState205.expr32 out "cc" (carryWord av b n) ccFinal)
  have tail : Exec ZintMulWord205.tail out ⟨out,.returned (some (.uint32 (carryWord av b n)))⟩ :=
    .seqExit _ _ _ _ ret (by intro h; cases h)
  have full : Exec ZintMulWord205.body s ⟨out,.returned (some (.uint32 (carryWord av b n)))⟩ :=
    .seqNormal _ _ _ _ _ h1 (.seqNormal _ _ _ _ _ h2 (.seqNormal _ _ _ _ _ h3
      (.seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ h4 loopRun) tail)))
  refine ⟨⟨out,.returned (some (.uint32 (carryWord av b n)))⟩,?_,rfl,written,?_,arrays,keep⟩
  · rw [ZintMulWord205.shape]
    exact full
  · intro name nu nc
    exact (locals name nu nc).trans (ZintAddMulWord205.before4 s name nu nc)

end FT1536.Source3.ZintMulWhole213
