import Source3.ZintAddMulWhole213

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtAddMulCall213
open C99ArrayReference (State Arg Pointer bindPointer Bind)
open C99MemoryReference (ArrayPointer Load32)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32 set64 Slot64)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (elem)
open Word32Memory176 (Separate)
open ZintNormWalkFlat208 (Data)
open KeygenZintCall (Exec)

def args : List Arg := [.pointer "x".toList C99ProcedureParser.zero,
  .pointer "tmp".toList C99ProcedureParser.zero,.scalar (.var "u".toList),.scalar (.var "xr".toList)]
 def fresh (s : State) : State := ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩
 def entry (s : State) (p q : ArrayPointer) (n : Nat) (c : BitVec 32) : State :=
  bindPointer (bindPointer (set64 (set32 (fresh s) "s" c) "len" (C99NatWord141.word n)) "y".toList q) "x".toList p

theorem entry_cells (s : State) (p q : ArrayPointer) (n : Nat) (c : BitVec 32) :
    (entry s p q n c).arrays "x".toList=some p ∧ (entry s p q n c).arrays "y".toList=some q ∧
    Cell (entry s p q n c) "len".toList n ∧ Slot (entry s p q n c) "s" c := by
  refine ⟨?_,?_,?_,?_⟩
  · simp only [entry,bindPointer,ite_true]
  · simp only [entry,bindPointer]; rfl
  · change Slot64 (set64 (set32 (fresh s) "s" c) "len" (C99NatWord141.word n)) "len" (C99NatWord141.word n)
    exact CrtState205.cell64 _ _ _
  · change Slot (set64 (set32 (fresh s) "s" c) "len" (C99NatWord141.word n)) "s" c
    exact (CrtState205.keep64 (set32 (fresh s) "s" c) "len" "s" (C99NatWord141.word n) (by decide)).trans (CrtState205.cell32 _ _ _)

theorem binding (s : State) (p q : ArrayPointer) (n : Nat) (c : BitVec 32)
    (px : s.arrays "x".toList=some p) (qy : s.arrays "tmp".toList=some q)
    (u : Cell s "u".toList n) (xr : Slot s "xr" c)
    (pb : p.index+0 ≤ p.count) (qb : q.index+0 ≤ q.count) :
    Bind s (KeygenZintCall.params (.leaf .addMul)) args (entry s p q n c) := by
  have zero := C99ScalarReference.Eval.literal (calls:=FprPrefixCalls.calls) (env:=s.locals) .uint64 0
  have pp : Pointer s "x".toList C99ProcedureParser.zero p := .add _ _ p p (.uint64 0) px zero (by decide) (.within p 0 pb)
  have qq : Pointer s "tmp".toList C99ProcedureParser.zero q := .add _ _ q q (.uint64 0) qy zero (by decide) (.within q 0 qb)
  refine .pointer _ _ _ _ _ _ _ pp (.pointer _ _ _ _ _ _ _ qq ?_)
  refine .scalar .uint64 "len".toList (.var "u".toList) _ _ _ (.uint64 (C99NatWord141.word n)) (.variable _ _ _ u) ?_
  exact .scalar .uint32 "s".toList (.var "xr".toList) _ _ _ (.uint32 c) (.variable _ _ _ xr) (.nil)

theorem source (s : State) (p q : ArrayPointer) (n : Nat) (av bv : Nat → BitVec 32) (c : BitVec 32)
    (px : s.arrays "x".toList=some p) (qy : s.arrays "tmp".toList=some q)
    (u : Cell s "u".toList n) (xr : Slot s "xr" c) (nb : n < 2^64)
    (cap : p.index+n < p.count) (qc : q.index ≤ q.count) (width : p.elementBytes=4)
    (tailAllocated : C99MemoryReference.Allocated s.heap (elem p n)) (writable : s.heap.writable p.block=true)
    (da : ∀ i, i<n → Load32 s.heap (elem p i) (av i)) (db : ∀ i, i<n → Load32 s.heap (elem q i) (bv i))
    (apart : ∀ i j, i<n → j<n → Separate (elem p i) (elem q j)) :
    ∃ out, Exec (.call (.leaf .addMul) args .discard) s ⟨out,.normal⟩ ∧
      Data out p (n+1) (ZintAddMulWhole213.words av bv c n) ∧ out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ cell old, (∀ i, i ≤ n → Separate (elem p i) cell) → Load32 s.heap cell old → Load32 out.heap cell old) := by
  have cells:=entry_cells s p q n c
  have fixed : ZintAddMulFixed213.Fixed (entry s p q n c) p q n bv c :=
    ⟨nb,width,cap,writable,cells.1,cells.2.1,cells.2.2.1,cells.2.2.2,tailAllocated,db,apart⟩
  obtain ⟨result,run,image,_,_,keep⟩:=ZintAddMulWhole213.source (entry s p q n c) p q n av bv c fixed da
  let out : State := {s with heap:=result.heap}
  have call : Exec (.call (.leaf .addMul) args .discard) s ⟨out,.normal⟩ :=
    .call s (.leaf .addMul) args .discard (entry s p q n c) ⟨result,.normal⟩ none out
      (binding s p q n c px qy u xr (by omega) (by omega)) (.word _ _ _ run) .voidEnd (.discard _ _)
  exact ⟨out,call,image,rfl,rfl,keep⟩

end FT1536.Source3.CrtAddMulCall213
