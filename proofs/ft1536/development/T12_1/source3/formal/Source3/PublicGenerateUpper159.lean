import Source3.PublicGenerateRow159

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact parsed shapes of the mq_mkgm3 upper and square suffix loops
   (falcon-vrfy.c fragment 863 22): the k rebind, the 256-iteration upper
   loop with its two loads and pair stores, the 255-iteration descending
   square loop and the final three statements. Value-free; the shape
   theorem is kernel-checked against the pinned parser. -/
namespace FT1536.Source3.PublicGenerateUpper159
open C99ArrayReference (State Name bindValue)
open C99MemoryReference (ArrayPointer)
open C99IntegerReference (Value Ty)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicWord (Eval Address)
open KeygenPublicTableAtoms (Slot)
open KeygenNttLoopSupport (USlot u64)
open KeygenSmallOutput (element)
open PublicGenerateTable159 (Tables Written WrittenRange written_here written_preserved
  written_new written_after tables_write store_source separate_elements separate_cross
  separate_cross_right)
open PublicGenerateIndex159
open PublicGenerateRow159 (rowValue mont_var keep_slot keep_u64 u32_slot_after u64_slot_after
  restoreScope_empty scope_empty chain_step)

def kSet : Stmt := .assign "k".toList
  (.bin .sub (KeygenPublicTableAtoms.var "logn") (KeygenPublicTableAtoms.literal 2))
def u2Init : Stmt := .assign "u".toList
  (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1)) (KeygenPublicTableAtoms.var "k"))
def upperGuard : KeygenWordExpr.Expr := .cmp .lt (KeygenPublicTableAtoms.var "u")
  (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1))
    (.bin .add (KeygenPublicTableAtoms.var "k") (KeygenPublicTableAtoms.literal 1)))
def upperBody : Stmt := .scope ["y".toList,"z".toList] [] (KeygenPublicExec.chain [
  .scalar (.declare .u32 ["y".toList,"z".toList]),
  .assign "y".toList (.load16 "gm".toList
    (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))),
  .assign "z".toList (.load16 "igm".toList
    (CLogic.Expr.bin .shl (CLogic.Expr.var "u".toList) (CLogic.Expr.literal .i32 1))),
  .store "gm".toList (CLogic.Expr.var "u".toList) true
    (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y")
      (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "y") (KeygenPublicTableAtoms.var "y"))),
  .store "igm".toList (CLogic.Expr.var "u".toList) true
    (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z")
      (KeygenPublicTableAtoms.mont (KeygenPublicTableAtoms.var "z") (KeygenPublicTableAtoms.var "z")))])
def upperInc : Stmt := .scalar (.update "u".toList .add (CLogic.Expr.literal .i32 1))
def upperLoop : Stmt := .loop upperGuard upperBody upperInc
def u3Init : Stmt := .assign "u".toList (.bin .sub
  (.bin .shl (.cast .uint64 (KeygenPublicTableAtoms.literal 1)) (KeygenPublicTableAtoms.var "k"))
  (KeygenPublicTableAtoms.literal 1))
def squareGuard : KeygenWordExpr.Expr := .cmp .gt (KeygenPublicTableAtoms.var "u")
  (KeygenPublicTableAtoms.literal 0)
def squareBody : Stmt := .scope ["v".toList] [] (KeygenPublicExec.chain [
  .scalar (.declare .u64 ["v".toList]),
  .assign "v".toList (.bin .shl (KeygenPublicTableAtoms.var "u")
    (KeygenPublicTableAtoms.literal 1)),
  .store "gm".toList (CLogic.Expr.var "u".toList) true
    (KeygenPublicTableAtoms.mont (.load16 "gm".toList (CLogic.Expr.var "v".toList))
      (.load16 "gm".toList (CLogic.Expr.var "v".toList))),
  .store "igm".toList (CLogic.Expr.var "u".toList) true
    (KeygenPublicTableAtoms.mont (.load16 "igm".toList (CLogic.Expr.var "v".toList))
      (.load16 "igm".toList (CLogic.Expr.var "v".toList)))])
def squareInc : Stmt := .scalar (.update "u".toList .sub (CLogic.Expr.literal .i32 1))
def squareLoop : Stmt := .loop squareGuard squareBody squareInc
def finalTail : Stmt :=
  .seq (.store "gm".toList (CLogic.Expr.literal .i32 0) false
      (.load16 "gm".toList (CLogic.Expr.literal .i32 1)))
  (.seq (.assign "w".toList (.load16 "gm".toList (CLogic.Expr.literal .i32 1)))
  (.seq (.store "igm".toList (CLogic.Expr.literal .i32 0) true
    (KeygenPublicTableAtoms.divide (KeygenPublicTableAtoms.literal 4564)
      (.call3 (KeygenPublicScalar.name .sub)
        (.call3 (KeygenPublicScalar.name .add)
          (KeygenPublicTableAtoms.var "w") (KeygenPublicTableAtoms.var "w")
          (KeygenPublicTableAtoms.literal 18433))
        (KeygenPublicTableAtoms.literal 10237)
        (KeygenPublicTableAtoms.literal 18433))))
  .skip))

theorem afterRows_shape : KeygenPublicTableRows.afterRows =
    .seq kSet (.seq (.seq u2Init upperLoop) (.seq (.seq u3Init squareLoop) finalTail)) :=
  by decide

theorem tables_frame (s s' : State) (gm igm : ArrayPointer) (t : Tables s gm igm)
    (arrays : s'.arrays=s.arrays) (size : s'.heap.size=s.heap.size)
    (writable : s'.heap.writable=s.heap.writable) : Tables s' gm igm := by
  refine ⟨?_,?_,t.gmWidth,t.igmWidth,t.gmCapacity,t.igmCapacity,?_,?_,?_,?_,t.separate⟩
  · rw [arrays]
    exact t.gmBinding
  · rw [arrays]
    exact t.igmBinding
  · intro i hi
    have old := t.gmAllocated i hi
    simp only [C99MemoryReference.Allocated] at old ⊢
    rw [size]
    exact old
  · intro i hi
    have old := t.igmAllocated i hi
    simp only [C99MemoryReference.Allocated] at old ⊢
    rw [size]
    exact old
  · rw [writable]
    exact t.gmWritable
  · rw [writable]
    exact t.igmWritable

/- Upper loop: 256 iterations writing gm[u]/igm[u] from their doubled
   reads, with the coverage invariant over [256,512) and the top range. -/
structure UpperInv (s : State) (gm igm : ArrayPointer) (c : Nat) : Prop where
  tables : Tables s gm igm
  lognSlot : Slot s "logn" 10
  kSlot : Slot s "k" (BitVec.ofNat 32 8)
  counter : USlot s "u" c
  covered : ∀ j, 256 ≤ j → j < c → Written s.heap (element gm j) ∧ Written s.heap (element igm j)
  coveredTop : ∀ j, 512 ≤ j → j < 1024 → Written s.heap (element gm j) ∧ Written s.heap (element igm j)

def CoverUp (s : State) (gm igm : ArrayPointer) (c : Nat) : Prop :=
  ∀ j, 256 ≤ j → j < c+1 → Written s.heap (element gm j) ∧ Written s.heap (element igm j)

theorem keep_slot (s : State) (name other : String) (ty : Ty) (v : Value) (w : BitVec 32)
    (different : name≠other) (slot : Slot s name w) :
    Slot (bindValue s other.toList ty v) name w :=
  KeygenPublicTableAtoms.slot_preserved s name other w ty v different slot

theorem u32_slot_after (s : State) (name : String) (w : BitVec 32) :
    Slot (bindValue s name.toList .uint32 (.uint32 w)) name w :=
  KeygenPublicTableAtoms.slot_after s name w

theorem u64_slot_after (s : State) (name : String) (m : Nat) (bound : m<2^64) :
    USlot (bindValue s name.toList .uint64 (u64 m)) name m := by
  have converted : C99IntegerReference.convert .uint64 (u64 m).integer=u64 m :=
    KeygenNttLoopSupport.convert_u64_self m bound
  simp [KeygenNttLoopSupport.USlot,C99ArrayReference.bindValue,C99ScalarReference.set,converted]

theorem update_exec (s : State) (name : String) (c : Nat) (bound : c+1<2^64)
    (slot : USlot s name c) :
    Exec KeygenPublicSource.program [] (.scalar (.update name.toList .add (CLogic.Expr.literal .i32 1)))
      s ⟨bindValue s name.toList .uint64 (u64 (c+1)),.normal⟩ :=
  .scalar _ _ _ (C99ScalarReference.Exec.assign s.locals name.toList _
    .uint64 (some (u64 c)) (u64 (c+1)) slot
    (.arithmetic .plus _ _ _ _ _ (C99ScalarReference.Eval.variable name.toList .uint64 (u64 c) slot)
      (C99ScalarReference.Eval.literal .int32 1) (C99NatWord141.add_one c (Nat.lt_of_succ_lt bound))))

theorem update_down_exec (s : State) (name : String) (c : Nat) (pos : 1 ≤ c) (bound : c<2^64)
    (slot : USlot s name c) :
    Exec KeygenPublicSource.program [] (.scalar (.update name.toList .sub (CLogic.Expr.literal .i32 1)))
      s ⟨bindValue s name.toList .uint64 (u64 (c-1)),.normal⟩ := by
  have op := PublicGenerateIndex159.sub_one c pos bound
  refine .scalar _ _ _ (C99ScalarReference.Exec.assign s.locals name.toList _
    .uint64 (some (u64 c)) (u64 (c-1)) slot
    (.arithmetic .minus _ _ _ _ _ (C99ScalarReference.Eval.variable name.toList .uint64 (u64 c) slot)
      (C99ScalarReference.Eval.literal .int32 1) ?_))
  exact op

end FT1536.Source3.PublicGenerateUpper159
