import Source3.BezoutInitMoreCopies217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Original v1[0] &= ~(uint32_t)1 source store and exact word image. -/
namespace FT1536.Source3.BezoutInitLowBit217
open C99ArrayReference (State)
open C99MemoryReference (Load32 Allocated)
open KeygenZintCall (Exec Stmt)
open StepCopyBody190 (elem)
open BezoutPointerSetup217 (v1)
open ZintNormWalkFlat208 (Data)
open Word32Memory176 (Separate)
open BezoutGuardOps217 (andWord)

def num (n : Nat) : CLogic.Expr := .literal .i32 n
def rhs : KeygenWordExpr.Expr := .bin .band (.load32 "v1".toList (num 0))
  (.bitNot (.cast .uint32 (.scalar (num 1))))
def store : Stmt := .word (.store "v1".toList (num 0) rhs)
def tail : Stmt := match BezoutInitMoreCopies217.tail with | .seq _ rest => rest | _ => KeygenZintCall.skip
def after (s : State) (w : BitVec 32) : State := {s with heap:=Word32Memory176.write s.heap v1 (andWord w 0xfffffffe)}
def image (W : Nat → BitVec 32) (i : Nat) := if i=0 then andWord (W 0) 0xfffffffe else W i

theorem shape : BezoutInitMoreCopies217.tail=.seq store tail := by decide

theorem source (s : State) (n : Nat) (W : Nat → BitVec 32) (positive : 0<n)
    (binding : s.arrays "v1".toList=some v1) (allocated : Allocated s.heap v1)
    (writable : s.heap.writable v1.block=true) (data : Data s v1 n W) :
    Exec store s ⟨after s (W 0),.normal⟩ ∧ Data (after s (W 0)) v1 n (image W) := by
  have at0 : elem v1 0=v1 := by rfl
  have read : Load32 s.heap v1 (W 0) := by simpa only [at0] using data 0 positive
  have ptr := NttInverseFinalPass192.zero_i32 s "v1".toList v1 binding (by decide)
  have notOne : C99IntegerReference.ComplementExec (.uint32 1) (.uint32 0xfffffffe) := .step (.uint32 1)
  have value : KeygenWordExpr.Eval s rhs (.uint32 (andWord (W 0) 0xfffffffe)) :=
    .bin .band _ _ _ _ _ (.load32 _ _ _ _ ptr read)
      (.bitNot _ _ _ (.cast .uint32 _ (.int32 1) (.scalar _ _ (.literal .int32 1))) notOne)
      (BezoutGuardOps217.band _ _)
  have write := Word32Memory176.source s.heap v1 (andWord (W 0) 0xfffffffe) allocated rfl writable
  have wordEq : BitVec.ofInt 32 (C99IntegerReference.Value.uint32 (andWord (W 0) 0xfffffffe)).integer=andWord (W 0) 0xfffffffe := by
    simp [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat]
  have run : Exec store s ⟨after s (W 0),.normal⟩ := .word _ _ _ (.store _ _ _ _ _ _ _ ptr value (by simpa only [wordEq] using write))
  refine ⟨run,?_⟩
  intro i bound
  by_cases h : i=0
  · subst i
    simpa only [image,ite_true,at0,after] using Word32Memory176.here s.heap v1 (andWord (W 0) 0xfffffffe) allocated rfl writable
  · have apart : Separate v1 (elem v1 i) := by
      right; left
      change 0+4*1675+4≤0+4*(1675+i)
      omega
    simpa only [image,h,ite_false,after] using Word32Memory176.outside s.heap v1 (elem v1 i) (andWord (W 0) 0xfffffffe) (W i) apart (data i bound)

theorem keep_data (s : State) (w : BitVec 32) (root : C99MemoryReference.ArrayPointer) (n : Nat) (W : Nat → BitVec 32)
    (data : Data s root n W) (apart : ∀ i<n, Separate v1 (elem root i)) : Data (after s w) root n W := by
  intro i bound
  exact Word32Memory176.outside s.heap v1 (elem root i) (andWord w 0xfffffffe) (W i) (apart i bound) (data i bound)

end FT1536.Source3.BezoutInitLowBit217
