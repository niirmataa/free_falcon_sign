import Source3.PublicTripleBody165
import Source3.PublicTailPrefix164

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicTripleLoop165
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open KeygenPublicExec (Exec)
open KeygenPublicWord (Eval)
open KeygenPublicTableAtoms (var literal)
open KeygenNttLoopSupport (USlot u64)
open PublicRoundContext163 (Arrays)
open PublicU32Locals165 (Has)
open PublicTailShape159 (tripleGuard tripleInc tripleLoop)

structure Fixed (s : State) (a gm : ArrayPointer) : Prop where
  arrays : Arrays s a gm
  cubic : s.arrays "gm_cubic".toList=some gm
  length : USlot s "n" 1536
  factor : Has s "w"

theorem context (s : State) (a gm : ArrayPointer) (k : Nat) (inside : k < 512)
    (fixed : Fixed s a gm) (uSlot : USlot s "u" (3*k)) (vSlot : USlot s "v" (512+k)) :
    PublicTripleBody165.Context s a gm (3*k) (512+k) :=
  ⟨by omega,by omega,fixed.arrays.capacity,fixed.arrays.tableCapacity,
    fixed.arrays.binding,fixed.cubic,uSlot,vSlot,fixed.factor,
    fun j hj => fixed.arrays.written (3*k+j) (by omega),
    fixed.arrays.tableWritten (512+k) (by omega),fixed.arrays.width,fixed.arrays.writable,
    fun j hj => fixed.arrays.allocated (3*k+j) (by omega)⟩

theorem fixed_after (s after : State) (a gm : ArrayPointer)
    (fixed : Fixed s a gm) (frame : PublicTripleBody165.Frame s after) : Fixed after a gm := by
  refine ⟨PublicTailPrefix164.initialized_arrays s after a gm fixed.arrays frame.arrays frame.memory,?_,?_,?_⟩
  · rw [frame.arrays]; exact fixed.cubic
  · exact (congrFun frame.locals _).trans fixed.length
  · obtain ⟨w,slot⟩ := fixed.factor
    exact ⟨w,(congrFun frame.locals _).trans slot⟩

def next (s : State) (k : Nat) : State :=
  bindValue (bindValue s "u".toList .uint64 (u64 (3*(k+1))))
    "v".toList .uint64 (u64 (512+(k+1)))

theorem fixed_next (s : State) (a gm : ArrayPointer) (k : Nat) (fixed : Fixed s a gm) :
    Fixed (next s k) a gm :=
  ⟨PublicTailPrefix164.initialized_arrays s _ a gm fixed.arrays rfl (PublicInitializedFrame164.refl s.heap),
    fixed.cubic,fixed.length,fixed.factor⟩

theorem increment (s : State) (k : Nat) (inside : k < 512)
    (uSlot : USlot s "u" (3*k)) (vSlot : USlot s "v" (512+k)) :
    Exec KeygenPublicSource.program [] tripleInc s ⟨next s k,.normal⟩ ∧
      USlot (next s k) "u" (3*(k+1)) ∧ USlot (next s k) "v" (512+(k+1)) := by
  let middle := bindValue s "u".toList .uint64 (u64 (3*(k+1)))
  have uEval : Eval [] s (.bin .add (var "u") (literal 3)) (u64 (3*(k+1))) := by
    have raw : Eval [] s (.bin .add (var "u") (literal 3)) (u64 (3*k+3)) :=
      .bin .add _ _ _ _ _ (.scalar _ _ (PublicGenerateIndex159.var_u64 s "u" (3*k) uSlot))
        (PublicGenerateHead159.eval_lit s 3) (PublicTripleIndex165.add_literal (3*k) 3 (by omega) (by decide))
    simpa only [Nat.mul_add,Nat.mul_one] using raw
  have first : Exec KeygenPublicSource.program []
      (.assign "u".toList (.bin .add (var "u") (literal 3))) s ⟨middle,.normal⟩ :=
    .assign _ _ _ .uint64 (some (u64 (3*k))) (u64 (3*(k+1))) uSlot uEval
  have midV := PublicGenerateRow159.keep_u64 s "v" "u" .uint64 (u64 (3*(k+1))) (512+k) (by decide) vSlot
  have vOp : C99IntegerReference.ArithmeticExec .plus (u64 (512+k)) (.int32 1) (u64 (512+(k+1))) := by
    simpa only [Nat.add_assoc,C99NatWord141.word,KeygenNttLoopSupport.u64] using
      C99NatWord141.add_one (512+k) (by omega)
  have second : Exec KeygenPublicSource.program []
      (.scalar (.update "v".toList .add (.literal .i32 1))) middle ⟨next s k,.normal⟩ :=
    .scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 (512+k))) (u64 (512+(k+1))) midV
      (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ midV) (.literal .int32 1) vOp))
  exact ⟨.seqNormal _ _ s middle ⟨next s k,.normal⟩ first second,
    PublicGenerateRow159.keep_u64 middle "u" "v" .uint64 _ _ (by decide)
      (PublicGenerateRow159.u64_slot_after s "u" (3*(k+1)) (by omega)),
    PublicGenerateRow159.u64_slot_after middle "v" (512+(k+1)) (by omega)⟩

theorem guard (s : State) (a gm : ArrayPointer) (k : Nat) (bound : k ≤ 512)
    (fixed : Fixed s a gm) (uSlot : USlot s "u" (3*k)) :
    Eval [] s tripleGuard (C99ScalarReference.boolean (decide (k < 512))) := by
  have raw : Eval [] s tripleGuard (C99ScalarReference.boolean (decide (3*k < 1536))) :=
    .cmp .lt _ _ _ _ _ (.scalar _ _ (PublicGenerateIndex159.var_u64 s "u" (3*k) uSlot))
      (.scalar _ _ (PublicGenerateIndex159.var_u64 s "n" 1536 fixed.length))
      (C99NatWord141.less (3*k) 1536 (by omega) (by decide))
  have same : 3*k < 1536 ↔ k < 512 := by omega
  simpa only [same] using raw

theorem remaining (count k : Nat) (s : State) (a gm : ArrayPointer)
    (fixed : Fixed s a gm) (uSlot : USlot s "u" (3*k)) (vSlot : USlot s "v" (512+k))
    (finish : k+count=512) :
    ∃ after, Exec KeygenPublicSource.program [] tripleLoop s ⟨after,.normal⟩ ∧
      Fixed after a gm ∧ USlot after "u" 1536 ∧ USlot after "v" 1024 := by
  induction count generalizing k s with
  | zero =>
      have equal : k=512 := by omega
      subst k
      exact ⟨s,.loopFalse _ _ _ _ _ (guard s a gm 512 (by decide) fixed uSlot) (by decide),fixed,uSlot,vSlot⟩
  | succ count ih =>
      have inside : k < 512 := by omega
      obtain ⟨middle,bodyRun,bodyFrame⟩ := PublicTripleBody165.source s a gm (3*k) (512+k)
        (context s a gm k inside fixed uSlot vSlot)
      have midFixed := fixed_after s middle a gm fixed bodyFrame
      have midU : USlot middle "u" (3*k) := (congrFun bodyFrame.locals _).trans uSlot
      have midV : USlot middle "v" (512+k) := (congrFun bodyFrame.locals _).trans vSlot
      obtain ⟨step,nextU,nextV⟩ := increment middle k inside midU midV
      obtain ⟨after,rest,lastFixed,lastU,lastV⟩ :=
        ih (k+1) (next middle k) (fixed_next middle a gm k midFixed) nextU nextV (by omega)
      have yes : Eval [] s tripleGuard (C99ScalarReference.boolean true) := by
        simpa only [inside,decide_true] using guard s a gm k (by omega) fixed uSlot
      exact ⟨after,.loopNormal _ _ _ s middle (next middle k) ⟨after,.normal⟩
        (C99ScalarReference.boolean true) yes (by decide) bodyRun step rest,lastFixed,lastU,lastV⟩

theorem source (s : State) (a gm : ArrayPointer) (fixed : Fixed s a gm)
    (uSlot : USlot s "u" 0) (vSlot : USlot s "v" 512) :
    ∃ after, Exec KeygenPublicSource.program [] tripleLoop s ⟨after,.normal⟩ ∧
      Fixed after a gm ∧ USlot after "u" 1536 ∧ USlot after "v" 1024 :=
  remaining 512 0 s a gm fixed uSlot vSlot (by decide)

end FT1536.Source3.PublicTripleLoop165
