import Source3.ZintReduceCall209

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ZintSignedExpr209
open C99ArrayReference (State Pointer)
open C99MemoryReference (ArrayPointer Load32)
open C99IntegerReference (Value)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open C99NatWord141 (word)
open StepCopyBody190 (elem)
open ZintModSignedWord194 (dName dlenName)

theorem zero_eval (s : State) (n : Nat) (nb : n < 2^64) (len : Cell s dlenName n) :
    KeygenWordExpr.Eval s ZintModSignedWord194.zeroGuard (C99ScalarReference.boolean (decide (n=0))) := by
  have raw:=C99IntegerReference.CompareExec.step .eq (.uint64 (word n)) (.int32 0) .uint64 rfl
    (.uint64 (word n)) (.uint64 0) (CrtWordOps205.self64 _).symm rfl
  change C99IntegerReference.CompareExec .eq (.uint64 (word n)) (.int32 0)
    (C99ScalarReference.boolean (decide ((Value.uint64 (word n)).integer=(0 : Int)))) at raw
  rw [C99NatWord141.integer n nb] at raw
  have same : ((n : Int)=0)↔n=0 := by omega
  have operation : C99IntegerReference.CompareExec .eq (.uint64 (word n)) (.int32 0)
      (C99ScalarReference.boolean (decide (n=0))) := by simpa only [same] using raw
  exact .cmp _ _ _ _ _ _ (.scalar _ _ (C99LoopScalar141.read s dlenName n len)) (WordAtoms205.literal _ 0) operation

theorem high_pointer (s : State) (pd : ArrayPointer) (n : Nat) (nb : n < 2^64) (positive : 0 < n)
    (db : s.arrays dName=some pd) (len : Cell s dlenName n) (cap : pd.index+n ≤ pd.count) :
    Pointer s dName (.bin .sub (.var dlenName) (.literal .i32 1)) (elem pd (n-1)) := by
  have operation:=PublicGenerateIndex159.sub_one n positive nb
  rw [show C99IntegerReference.convert .int32 1=(.int32 1) by decide] at operation
  have index : C99ArrayReference.scalar s (.bin .sub (.var dlenName) (.literal .i32 1)) (.uint64 (word (n-1))) :=
    .arithmetic .minus _ _ _ _ _ (C99LoopScalar141.read s dlenName n len) (.literal .int32 1) operation
  refine .add _ _ pd _ (.uint64 (word (n-1))) db index ?_ ?_
  · rw [C99NatWord141.integer (n-1) (by omega)]; omega
  · rw [C99NatWord141.integer (n-1) (by omega)]
    exact .within pd (n-1) (by omega)

theorem sub_eval (s : State) (pd : ArrayPointer) (n : Nat) (unsigned top p rx : BitVec 32)
    (nb : n < 2^64) (positive : 0 < n) (db : s.arrays dName=some pd) (len : Cell s dlenName n)
    (cap : pd.index+n ≤ pd.count) (read : Load32 s.heap (elem pd (n-1)) top)
    (zc : Slot s "z" unsigned) (pc : Slot s "p" p) (rc : Slot s "Rx" rx) :
    KeygenWordExpr.Eval s ZintModSignedWord194.subExpr
      (.uint32 (KeygenModpAddSub.result .sub unsigned (ZintModSignedWord194.signWord rx top) p)) := by
  have ptr:=high_pointer s pd n nb positive db len cap
  have shift : KeygenWordExpr.Eval s (.bin .shr (.load32 dName (.bin .sub (.var dlenName) (.literal .i32 1)))
      (.scalar (.literal .i32 30))) (.uint32 (top >>> 30)) :=
    .bin .shr _ _ _ _ _ (.load32 _ _ _ top ptr read) (WordAtoms205.literal _ 30) (KeygenDecodeWordOps.right32 top 30 (by decide))
  have negative : KeygenWordExpr.Eval s (.neg (.bin .shr (.load32 dName (.bin .sub (.var dlenName) (.literal .i32 1)))
      (.scalar (.literal .i32 30)))) (.uint32 (-(top >>> 30))) := .neg _ _ _ shift (KeygenDecodeWordOps.neg32 _)
  have masked : KeygenWordExpr.Eval s (.bin .band (.scalar (.var "Rx".toList))
      (.neg (.bin .shr (.load32 dName (.bin .sub (.var dlenName) (.literal .i32 1))) (.scalar (.literal .i32 30)))))
      (.uint32 (ZintModSignedWord194.signWord rx top)) :=
    .bin .band _ _ _ _ _ (CrtState205.expr32 _ "Rx" rx rc) negative (KeygenDecodeWordOps.and32 _ _)
  exact .call3 _ _ _ _ _ _ _ _ (CrtState205.expr32 _ "z" unsigned zc) masked (CrtState205.expr32 _ "p" p pc)
    (.sub _ _ (KeygenModpAddSub.source_exists .sub unsigned (ZintModSignedWord194.signWord rx top) p))

end FT1536.Source3.ZintSignedExpr209
