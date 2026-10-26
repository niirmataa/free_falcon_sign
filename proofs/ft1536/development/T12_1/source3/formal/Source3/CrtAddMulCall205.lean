import Source3.CrtLeafImages205

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtAddMulCall205
open C99ArrayReference (State Arg Pointer bindPointer Bind)
open C99MemoryReference (ArrayPointer Load32)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32 set64 Slot64)
open KeygenZintCall (Exec)

def args : List Arg := [.pointer "x".toList C99ProcedureParser.zero,
  .pointer "tmp".toList C99ProcedureParser.zero,.scalar (.var "u".toList),.scalar (.var "xr".toList)]
 def fresh (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩
 def entry (s : State) (p q : ArrayPointer) (c : BitVec 32) : State :=
  bindPointer (bindPointer (set64 (set32 (fresh s) "s" c) "len" 1) "y".toList q) "x".toList p

theorem entry_cells (s : State) (p q : ArrayPointer) (c : BitVec 32) :
    (entry s p q c).arrays "x".toList=some p ∧ (entry s p q c).arrays "y".toList=some q ∧
    Slot64 (entry s p q c) "len" 1 ∧ Slot (entry s p q c) "s" c := by
  refine ⟨?_,?_,?_,?_⟩
  · simp only [entry,bindPointer,ite_true]
  · simp only [entry,bindPointer]; rfl
  · change Slot64 (set64 (set32 (fresh s) "s" c) "len" 1) "len" 1
    exact CrtState205.cell64 _ _ _
  · change Slot (set64 (set32 (fresh s) "s" c) "len" 1) "s" c
    exact (CrtState205.keep64 (set32 (fresh s) "s" c) "len" "s" 1 (by decide)).trans (CrtState205.cell32 _ _ _)

theorem binding (s : State) (p q : ArrayPointer) (c : BitVec 32)
    (px : s.arrays "x".toList=some p) (qy : s.arrays "tmp".toList=some q)
    (u : Slot64 s "u" 1) (xr : Slot s "xr" c)
    (pb : p.index+0 ≤ p.count) (qb : q.index+0 ≤ q.count) :
    Bind s (KeygenZintCall.params (.leaf .addMul)) args (entry s p q c) := by
  have zero := C99ScalarReference.Eval.literal (calls:=FprPrefixCalls.calls) (env:=s.locals) .uint64 0
  have pp : Pointer s "x".toList C99ProcedureParser.zero p := .add _ _ p p (.uint64 0) px zero (by decide) (.within p 0 pb)
  have qq : Pointer s "tmp".toList C99ProcedureParser.zero q := .add _ _ q q (.uint64 0) qy zero (by decide) (.within q 0 qb)
  refine .pointer _ _ _ _ _ _ _ pp (.pointer _ _ _ _ _ _ _ qq ?_)
  refine .scalar .uint64 "len".toList (.var "u".toList) _ _ _ (.uint64 1) (.variable _ _ _ u) ?_
  exact .scalar .uint32 "s".toList (.var "xr".toList) _ _ _ (.uint32 c) (.variable _ _ _ xr) (.nil)

theorem source (s : State) (p q : ArrayPointer) (a b c : BitVec 32)
    (px : s.arrays "x".toList=some p) (qy : s.arrays "tmp".toList=some q)
    (u : Slot64 s "u" 1) (xr : Slot s "xr" c)
    (readX0 : Load32 s.heap p a) (readY0 : Load32 s.heap q b)
    (cap : p.index+1 < p.count) (writable : s.heap.writable p.block=true) :
    Exec (.call (.leaf .addMul) args .discard) s
      ⟨{s with heap:=ZintAddMulWord205.finalHeap s p a b c},.normal⟩ := by
  have pc : p.index+0 ≤ p.count := by omega
  have qc : q.index+0 ≤ q.count := by cases readY0 with | load _ h _ _ => have b:=h.2.2.1; omega
  have cells:=entry_cells s p q c
  obtain ⟨out,run,flow,heap⟩:=ZintAddMulWord205.source (entry s p q c) p q a b c cells.1 cells.2.1 cells.2.2.1 cells.2.2.2 readX0 readY0 cap writable
  refine .call s (.leaf .addMul) args .discard (entry s p q c) out none _ (binding s p q c px qy u xr pc qc)
    (.word _ _ _ run) ?_ ?_
  · rw [flow]
    exact .voidEnd
  · rw [heap]
    exact .discard _ _

end FT1536.Source3.CrtAddMulCall205
