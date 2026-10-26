import Source3.ZintReduceWhole209

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintReduceCall209
open C99ArrayReference (State Name Arg Pointer Bind bindPointer)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32 set64)
open C99NatWord141 (word)
open StepCopyBody190 (elem)
open KeygenZintCall (Exec)

def args (dataName lenName : String) : List Arg := [.pointer dataName.toList C99ProcedureParser.zero,
  .scalar (.var lenName.toList),.scalar (.var "p".toList),.scalar (.var "p0i".toList),.scalar (.var "R2".toList)]
 def withR2 (s : State) (r2 : BitVec 32) := set32 (CrtAddMulCall205.fresh s) "R2" r2
 def withI (s : State) (pi r2 : BitVec 32) := set32 (withR2 s r2) "p0i" pi
 def withP (s : State) (p pi r2 : BitVec 32) := set32 (withI s pi r2) "p" p
 def withLen (s : State) (n : Nat) (p pi r2 : BitVec 32) := set64 (withP s p pi r2) "dlen" (word n)
 def entry (s : State) (pd : ArrayPointer) (n : Nat) (p pi r2 : BitVec 32) := bindPointer (withLen s n p pi r2) "d".toList pd

theorem fixed (s : State) (pd : ArrayPointer) (n : Nat) (W : Nat → BitVec 32) (p pi r2 : BitVec 32)
    (nb : n < 2^64) (cap : pd.index+n ≤ pd.count) (data : ∀ i, i < n → Load32 s.heap (elem pd i) (W i)) :
    ZintReduceLoop209.Fixed (entry s pd n p pi r2) pd n W p pi r2 := by
  refine ⟨nb,?_,?_,?_,?_,?_,cap,data⟩
  · simp only [ZintModSignedWord194.dName,entry,bindPointer,ite_true]
  · change Cell (withLen s n p pi r2) "dlen".toList n
    exact CrtState205.cell64 _ _ _
  · change Slot (withLen s n p pi r2) "p" p
    exact (CrtState205.keep64 (withP s p pi r2) "dlen" "p" (word n) (by decide)).trans (CrtState205.cell32 _ _ _)
  · change Slot (withLen s n p pi r2) "p0i" pi
    exact (CrtState205.keep64 (withP s p pi r2) "dlen" "p0i" (word n) (by decide)).trans
      ((CrtState205.keep32 (withI s pi r2) "p" "p0i" p (by decide)).trans (CrtState205.cell32 _ _ _))
  · change Slot (withLen s n p pi r2) "R2" r2
    exact (CrtState205.keep64 (withP s p pi r2) "dlen" "R2" (word n) (by decide)).trans
      ((CrtState205.keep32 (withI s pi r2) "p" "R2" p (by decide)).trans
        ((CrtState205.keep32 (withR2 s r2) "p0i" "R2" pi (by decide)).trans (CrtState205.cell32 _ _ _)))

theorem binding (dataName lenName : String) (s : State) (pd : ArrayPointer) (n : Nat) (p pi r2 : BitVec 32)
    (db : s.arrays dataName.toList=some pd) (lc : Cell s lenName.toList n)
    (pc : Slot s "p" p) (ic : Slot s "p0i" pi) (rc : Slot s "R2" r2) (cap : pd.index+0 ≤ pd.count) :
    Bind s (KeygenZintCall.params (.leaf .reduce)) (args dataName lenName) (entry s pd n p pi r2) := by
  have ptr : Pointer s dataName.toList C99ProcedureParser.zero pd :=
    .add _ _ pd pd (.uint64 0) db (.literal .uint64 0) (by decide) (.within pd 0 cap)
  refine .pointer _ _ _ _ _ _ _ ptr ?_
  refine .scalar .uint64 "dlen".toList (.var lenName.toList) _ _ _ (.uint64 (word n)) (.variable _ _ _ lc) ?_
  refine .scalar .uint32 "p".toList (.var "p".toList) _ _ _ (.uint32 p) (.variable _ _ _ pc) ?_
  refine .scalar .uint32 "p0i".toList (.var "p0i".toList) _ _ _ (.uint32 pi) (.variable _ _ _ ic) ?_
  exact .scalar .uint32 "R2".toList (.var "R2".toList) _ _ _ (.uint32 r2) (.variable _ _ _ rc) .nil

theorem source (dataName lenName destination : String) (s : State) (pd : ArrayPointer) (n : Nat) (W : Nat → BitVec 32)
    (p pi r2 : BitVec 32) (old : Option C99IntegerReference.Value)
    (db : s.arrays dataName.toList=some pd) (lc : Cell s lenName.toList n)
    (pc : Slot s "p" p) (ic : Slot s "p0i" pi) (rc : Slot s "R2" r2)
    (declared : s.locals destination.toList=some (.uint32,old)) (nb : n < 2^64) (cap : pd.index+n ≤ pd.count)
    (data : ∀ i, i < n → Load32 s.heap (elem pd i) (W i)) :
    Exec (.call (.leaf .reduce) (args dataName lenName) (.into destination.toList)) s
      ⟨set32 s destination (ZintReduceWhole209.resultWord W n p pi r2),.normal⟩ := by
  obtain ⟨out,run,flow,heap,_,_⟩:=ZintReduceWhole209.source (entry s pd n p pi r2) pd n W p pi r2 (fixed s pd n W p pi r2 nb cap data)
  refine .call s (.leaf .reduce) (args dataName lenName) (.into destination.toList) (entry s pd n p pi r2) out
    (some (.uint32 (ZintReduceWhole209.resultWord W n p pi r2))) _
    (binding dataName lenName s pd n p pi r2 db lc pc ic rc (by omega)) (.word _ _ _ run) ?_ ?_
  · rw [flow]
    have returned:=C99ProcedureReference.ReturnValue.value .uint32 (.uint32 (ZintReduceWhole209.resultWord W n p pi r2))
    rw [KeygenDecodeWordOps.self32] at returned
    exact returned
  · rw [heap]
    exact .into _ _ .uint32 old _ declared

end FT1536.Source3.ZintReduceCall209
