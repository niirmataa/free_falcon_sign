import Source3.CrtAddMulCall213

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtMulCall213
open C99ArrayReference (State Arg Pointer Bind bindPointer)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32 set64)
open C99LoopScalar141 (Cell)
open StepCopyBody190 (elem)
open Word32Memory176 (Separate)
open ZintNormWalkFlat208 (Data)
open KeygenZintCall (Exec)

def args : List Arg := CrtMulCall205.args
 def entry (s : State) (q : ArrayPointer) (n : Nat) (p : BitVec 32) :=
  bindPointer (set64 (set32 (CrtAddMulCall205.fresh s) "x" p) "mlen" (C99NatWord141.word n)) "m".toList q
 def words (W : Nat → BitVec 32) (p : BitVec 32) (n i : Nat) :=
  if i<n then ZintMulFixed213.outputWord W p i else ZintMulFixed213.carryWord W p n

theorem cells (s : State) (q : ArrayPointer) (n : Nat) (p : BitVec 32) :
    (entry s q n p).arrays "m".toList=some q ∧ Cell (entry s q n p) "mlen".toList n ∧ Slot (entry s q n p) "x" p := by
  refine ⟨rfl,?_,?_⟩
  · change Cell (set64 (set32 (CrtAddMulCall205.fresh s) "x" p) "mlen" (C99NatWord141.word n)) "mlen".toList n
    exact CrtState205.cell64 _ _ _
  · exact (CrtState205.keep64 (set32 (CrtAddMulCall205.fresh s) "x" p) "mlen" "x" (C99NatWord141.word n) (by decide)).trans (CrtState205.cell32 _ _ _)

theorem binding (s : State) (q : ArrayPointer) (n : Nat) (p : BitVec 32)
    (tmp : s.arrays "tmp".toList=some q) (u : Cell s "u".toList n) (pp : Slot s "p" p)
    (cap : q.index ≤ q.count) : Bind s (KeygenZintCall.params (.leaf .mul)) args (entry s q n p) := by
  have ptr : Pointer s "tmp".toList C99ProcedureParser.zero q :=
    .add _ _ q q (.uint64 0) tmp (.literal .uint64 0) (by decide) (.within q 0 (by omega))
  exact .pointer _ _ _ _ _ _ _ ptr
    (.scalar .uint64 "mlen".toList (.var "u".toList) _ _ _ (.uint64 (C99NatWord141.word n)) (.variable _ _ _ u)
      (.scalar .uint32 "x".toList (.var "p".toList) _ _ _ (.uint32 p) (.variable _ _ _ pp) .nil))

theorem source (s : State) (q : ArrayPointer) (n : Nat) (W : Nat → BitVec 32) (p : BitVec 32)
    (tmp : s.arrays "tmp".toList=some q) (u : Cell s "u".toList n) (pp : Slot s "p" p) (nb : n < 2^64)
    (cap : q.index+n < q.count) (width : q.elementBytes=4) (allocated : Allocated s.heap (elem q n))
    (writable : s.heap.writable q.block=true) (data : ∀ i, i<n → Load32 s.heap (elem q i) (W i)) :
    ∃ out, Exec (.call (.leaf .mul) args (.store "tmp".toList (.var "u".toList))) s ⟨out,.normal⟩ ∧
      Data out q (n+1) (words W p n) ∧ out.locals=s.locals ∧ out.arrays=s.arrays ∧
      (∀ cell old, (∀ i, i ≤ n → Separate (elem q i) cell) → Load32 s.heap cell old → Load32 out.heap cell old) := by
  have holds:=cells s q n p
  have fixed : ZintMulFixed213.Fixed (entry s q n p) q n p := ⟨nb,width,by omega,writable,holds.1,holds.2.1,holds.2.2⟩
  obtain ⟨result,run,flow,image,_,_,keep⟩:=ZintMulWhole213.source (entry s q n p) q n W p fixed data
  have stable:=KeygenMemoryStability.word _ _ _ run
  have size : result.state.heap.size=s.heap.size := stable.size
  have write : result.state.heap.writable=s.heap.writable := stable.writable
  have tailAlloc : Allocated result.state.heap (elem q n) := by simpa only [Allocated,size] using allocated
  have tailWritable : result.state.heap.writable q.block=true := by rw [write]; exact writable
  let received : State := {s with heap:=result.state.heap}
  let out : State := {s with heap:=Word32Memory176.write result.state.heap (elem q n) (ZintMulFixed213.carryWord W p n)}
  have call : Exec (.call (.leaf .mul) args (.store "tmp".toList (.var "u".toList))) s ⟨out,.normal⟩ := by
    refine .call s (.leaf .mul) args (.store "tmp".toList (.var "u".toList)) (entry s q n p) result
      (some (.uint32 (ZintMulFixed213.carryWord W p n))) out (binding s q n p tmp u pp (by omega)) (.word _ _ _ run) ?_ ?_
    · rw [flow]
      have rv:=C99ProcedureReference.ReturnValue.value .uint32 (.uint32 (ZintMulFixed213.carryWord W p n))
      rw [KeygenDecodeWordOps.self32] at rv
      exact rv
    · refine .store _ _ received _ (elem q n) (.uint32 (ZintMulFixed213.carryWord W p n)) ?_ ?_
      · refine .add _ _ q _ (.uint64 (C99NatWord141.word n)) tmp (.variable _ _ _ u) ?_ ?_
        · rw [C99NatWord141.integer n nb]; omega
        · rw [C99NatWord141.integer n nb]; exact .within q n (by omega)
      · change C99MemoryReference.Store32 result.state.heap (elem q n) (BitVec.ofInt 32 ((ZintMulFixed213.carryWord W p n).toNat : Int)) _
        rw [ZintSubWord194.ofInt_word]
        exact Word32Memory176.source _ _ _ tailAlloc width tailWritable
  refine ⟨out,call,?_,rfl,rfl,?_⟩
  · intro i bound
    by_cases low : i<n
    · simp only [words,low,ite_true]
      exact Word32Memory176.outside result.state.heap (elem q n) (elem q i) _ _
        (StepCopyFixed203.elem_separate q width n i (by omega)) (image i low)
    · have eq : i=n := by omega
      subst i
      simp only [words,Nat.lt_irrefl,ite_false]
      exact Word32Memory176.here result.state.heap (elem q n) _ tailAlloc width tailWritable
  · intro cell old apart read
    exact Word32Memory176.outside result.state.heap (elem q n) cell _ old (apart n (Nat.le_refl n))
      (keep cell old (fun i bound => apart i (by omega)) read)

end FT1536.Source3.CrtMulCall213
