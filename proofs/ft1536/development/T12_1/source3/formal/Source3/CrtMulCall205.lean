import Source3.CrtReduceCall205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtMulCall205
open C99ArrayReference (State Arg Pointer Bind bindPointer)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open KeygenModpR2Exec (Slot)
open CrtState205 (Slot64 set32 set64)
open KeygenZintCall (Exec)

def args : List Arg := [.pointer "tmp".toList C99ProcedureParser.zero,
  .scalar (.var "u".toList),.scalar (.var "p".toList)]
 def entry (s : State) (q : ArrayPointer) (p : BitVec 32) :=
  bindPointer (set64 (set32 (CrtAddMulCall205.fresh s) "x" p) "mlen" 1) "m".toList q
 def finalHeap (s : State) (q : ArrayPointer) (a p : BitVec 32) :=
  Word32Memory176.write (Word32Memory176.write s.heap q (ZintMulWord205.low a p))
    (ZintAddMulWord205.next q) (ZintMulWord205.carry a p)

theorem binding (s : State) (q : ArrayPointer) (p : BitVec 32)
    (tmp : s.arrays "tmp".toList=some q) (u : Slot64 s "u" 1) (pp : Slot s "p" p)
    (cap : q.index+0 ≤ q.count) :
    Bind s (KeygenZintCall.params (.leaf .mul)) args (entry s q p) := by
  have zero:=C99ScalarReference.Eval.literal (calls:=FprPrefixCalls.calls) (env:=s.locals) .uint64 0
  have ptr : Pointer s "tmp".toList C99ProcedureParser.zero q :=
    .add _ _ q q (.uint64 0) tmp zero (by decide) (.within q 0 cap)
  refine .pointer _ _ _ _ _ _ _ ptr ?_
  refine .scalar .uint64 "mlen".toList (.var "u".toList) _ _ _ (.uint64 1) (.variable _ _ _ u) ?_
  exact .scalar .uint32 "x".toList (.var "p".toList) _ _ _ (.uint32 p) (.variable _ _ _ pp) .nil

theorem source (s : State) (q : ArrayPointer) (a p : BitVec 32)
    (tmp : s.arrays "tmp".toList=some q) (u : Slot64 s "u" 1) (pp : Slot s "p" p)
    (read : Load32 s.heap q a) (cap : q.index+1 < q.count) (writable : s.heap.writable q.block=true) :
    Exec (.call (.leaf .mul) args (.store "tmp".toList (.var "u".toList))) s
      ⟨{s with heap:=finalHeap s q a p},.normal⟩ := by
  have qb : q.index+0 ≤ q.count := by omega
  have tailBound : q.index+1 ≤ q.count := by omega
  have bindingM : (entry s q p).arrays "m".toList=some q := by simp only [entry,bindPointer,ite_true]
  have xslot : Slot (entry s q p) "x" p := by
    change Slot (set64 (set32 (CrtAddMulCall205.fresh s) "x" p) "mlen" 1) "x" p
    exact (CrtState205.keep64 (set32 (CrtAddMulCall205.fresh s) "x" p) "mlen" "x" 1 (by decide)).trans (CrtState205.cell32 _ _ _)
  have mlen : Slot64 (entry s q p) "mlen" 1 := by
    change Slot64 (set64 (set32 (CrtAddMulCall205.fresh s) "x" p) "mlen" 1) "mlen" 1
    exact CrtState205.cell64 _ _ _
  obtain ⟨out,run,flow,heap⟩:=ZintMulWord205.source (entry s q p) q a p bindingM xslot mlen read writable
  obtain ⟨alloc,width⟩ : Allocated s.heap q ∧ q.elementBytes=4 := by
    cases read with | load _ h w _ => exact ⟨h,w⟩
  have tailAlloc : Allocated s.heap (ZintAddMulWord205.next q) := ⟨alloc.1,alloc.2.1,cap,alloc.2.2.2⟩
  refine .call s (.leaf .mul) args (.store "tmp".toList (.var "u".toList)) (entry s q p) out
    (some (.uint32 (ZintMulWord205.carry a p))) _ (binding s q p tmp u pp qb) (.word _ _ _ run) ?_ ?_
  · rw [flow]
    have rv:=C99ProcedureReference.ReturnValue.value .uint32 (.uint32 (ZintMulWord205.carry a p))
    rw [KeygenDecodeWordOps.self32] at rv
    exact rv
  · rw [heap]
    refine .store _ _ _ _ (ZintAddMulWord205.next q) (.uint32 (ZintMulWord205.carry a p)) ?_ ?_
    · exact .add _ _ q _ (.uint64 1) tmp (.variable _ _ _ u) (by decide) (.within q 1 tailBound)
    · change C99MemoryReference.Store32 (Word32Memory176.write s.heap q (ZintMulWord205.low a p))
        (ZintAddMulWord205.next q) (BitVec.ofInt 32 ((ZintMulWord205.carry a p).toNat : Int)) _
      rw [ZintSubWord194.ofInt_word]
      exact Word32Memory176.source _ _ _ tailAlloc width writable

end FT1536.Source3.CrtMulCall205
