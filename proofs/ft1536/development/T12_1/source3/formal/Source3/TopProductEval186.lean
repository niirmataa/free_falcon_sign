import Source3.TopProductProgram186

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.TopProductEval186
open C99ArrayReference (State Pointer)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99ModularReference (Eval)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)

structure Words where
  first : BitVec 32
  second : BitVec 32
  third : BitVec 32

def pair (x : Words) (p p0i : BitVec 32) := KeygenModpWord.montgomery x.second x.third p p0i
def triple (x : Words) (p p0i : BitVec 32) := KeygenModpWord.montgomery x.first (pair x p p0i) p p0i
def output (x : Words) (p p0i r3 : BitVec 32) := KeygenModpWord.montgomery r3 (triple x p p0i) p p0i

theorem address (s : State) (name : String) (base : ArrayPointer) (i : Nat) (e : CLogic.Expr)
    (bound : i<2^64) (binding : s.arrays name.toList=some base)
    (value : C99ArrayReference.scalar s e (u64 i)) (allocated : Allocated s.heap (element base i)) :
    Pointer s name.toList e (element base i) := by
  refine .add _ _ base _ (u64 i) binding value ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer i bound]; omega
  · rw [KeygenNttLoopSupport.u64_toNat i bound]
    exact .within base i (Nat.le_of_lt allocated.2.2.1)

theorem source (s : State) (src : String) (base : ArrayPointer) (u : Nat) (x : Words) (p p0i r3 : BitVec 32)
    (bound : u+2<1536) (binding : s.arrays src.toList=some base) (uc : USlot s "u" u)
    (pc : Slot s "p" p) (ic : Slot s "p0i" p0i) (rc : Slot s "R3" r3)
    (r0 : Load32 s.heap (element base u) x.first) (r1 : Load32 s.heap (element base (u+1)) x.second)
    (r2 : Load32 s.heap (element base (u+2)) x.third) :
    Eval s (TopProductProgram186.product src) (.uint32 (output x p p0i r3)) := by
  have first : Eval s (TopProductProgram186.read src (TopProductProgram186.var "u")) (.uint32 x.first) :=
    .load32 _ _ (element base u) x.first (address s src base u _ (by omega) binding (.variable _ _ _ uc)
      (NttReadFacts182.allocated _ _ _ r0)) r0
  have second : Eval s (TopProductProgram186.read src (TopProductProgram186.next 1)) (.uint32 x.second) :=
    .load32 _ _ (element base (u+1)) x.second
      (address s src base (u+1) _ (by omega) binding
        (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ uc) (.literal .int32 1) (C99NatWord141.add_one u (by omega)))
        (NttReadFacts182.allocated _ _ _ r1)) r1
  have third : Eval s (TopProductProgram186.read src (TopProductProgram186.next 2)) (.uint32 x.third) :=
    .load32 _ _ (element base (u+2)) x.third
      (address s src base (u+2) _ (by omega) binding
        (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ uc) (.literal .int32 2) (PublicGenerateIndex159.add_two u (by omega)))
        (NttReadFacts182.allocated _ _ _ r2)) r2
  exact ModularAtoms178.mont s _ _ r3 (triple x p p0i) p p0i (ModularAtoms178.cell s "R3" r3 rc)
    (ModularAtoms178.mont s _ _ x.first (pair x p p0i) p p0i first
      (ModularAtoms178.mont s _ _ x.second x.third p p0i second third pc ic) pc ic) pc ic

end FT1536.Source3.TopProductEval186
