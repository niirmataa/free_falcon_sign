import Source3.NttTripleFrame184

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttTripleControl184
open C99ArrayReference (State bindValue bindPointer)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot u64)
open NttFirstFixed182 (Fixed)

theorem add_three (u : Nat) (bound : u<2^64) :
    C99IntegerReference.ArithmeticExec .plus (u64 u) (.int32 3) (u64 (u+3)) := by
  have raw := C99IntegerReference.ArithmeticExec.step .plus (u64 u) (.int32 3) .uint64 rfl
    (u64 u) (u64 3) (C99CountedWords.convert_self _).symm rfl (by intro impossible; cases impossible)
  change C99IntegerReference.ArithmeticExec .plus (u64 u) (.int32 3)
    (C99IntegerReference.convert .uint64 ((u64 u).integer+(u64 3).integer)) at raw
  rw [KeygenNttLoopSupport.u64_integer u bound,KeygenNttLoopSupport.u64_integer 3 (by decide)] at raw
  have sum : (u:Int)+((3:Nat):Int)=((u+3:Nat):Int) := by omega
  rw [sum,KeygenNttLoopSupport.convert_u64_nat] at raw
  exact raw

def withU (s : State) (j : Nat) := bindValue s "u".toList .uint64 (u64 (3*j+3))
def withR (s : State) (j : Nat) := bindValue (withU s j) "r".toList .uint64 (u64 (512+j+1))
def after (s : State) (a : ArrayPointer) (j : Nat) := bindPointer (withR s j) "r1".toList (element a (3*j+3))

theorem source (s : State) (a : ArrayPointer) (j : Nat) (bound : j<512)
    (uc : USlot s "u" (3*j)) (rc : USlot s "r" (512+j)) (stride : USlot s "stride" 1)
    (binding : s.arrays "r1".toList=some (element a (3*j))) (capacity : a.index+1536≤a.count) :
    Exec KeygenNttForwardPrograms.tripleStep s ⟨after s a j,.normal⟩ := by
  have u : Exec (KeygenNttForwardPrograms.update "u" .add (KeygenNttForwardPrograms.num 3)) s ⟨withU s j,.normal⟩ :=
    .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 (3*j))) (u64 (3*j+3)) uc
      (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ uc) (.literal .int32 3) (add_three (3*j) (by omega)))))
  have base := C99LoopScalar141.increment (fun _ => none) (withU s j) "r".toList (512+j) (by omega) rc
  rw [FftLocalCells140.put_bind] at base
  have r : Exec (KeygenNttForwardPrograms.update "r" .add (KeygenNttForwardPrograms.num 1)) (withU s j) ⟨withR s j,.normal⟩ := by
    cases base with
    | base _ _ _ run => exact .base _ _ _ run
  have ptr : Exec (KeygenNttForwardPrograms.bind "r1" "r1" (.bin .mul (.literal .i32 3) (.var "stride".toList)))
      (withR s j) ⟨after s a j,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ (element a (3*j+3))
      (NttTripleAddress184.offset (withR s j) a (3*j) 3 _ binding
        (NttTripleAddress184.small_product (withR s j) stride 3 (by decide)) (by decide) (by omega)))
  exact .seqNormal _ _ s (withU s j) _ u (.seqNormal _ _ (withU s j) (withR s j) _ r ptr)

theorem fixed (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (j : Nat) (f : Fixed s a gm p p0i w) :
    Fixed (after s a j) a gm p p0i w :=
  ⟨f.pCell,f.iCell,f.wCell,f.nCell,f.hnCell,f.stride,f.aBinding,f.gmBinding,f.width,f.capacity,f.allocated,f.writable,f.initialized⟩

theorem u_cell (s : State) (a : ArrayPointer) (j : Nat) (bound : j<512) : USlot (after s a j) "u" (3*(j+1)) := by
  change USlot (withU s j) "u" (3*(j+1))
  rw [Nat.mul_add,Nat.mul_one]
  exact KeygenMkgm3RowInit.set64_slot s "u" (3*j+3) (by omega)

theorem r_cell (s : State) (a : ArrayPointer) (j : Nat) (bound : j<512) : USlot (after s a j) "r" (512+(j+1)) := by
  change USlot (withR s j) "r" (512+(j+1))
  rw [←Nat.add_assoc]
  exact KeygenMkgm3RowInit.set64_slot (withU s j) "r" (512+j+1) (by omega)

theorem pointer (s : State) (a : ArrayPointer) (j : Nat) :
    (after s a j).arrays "r1".toList=some (element a (3*(j+1))) := by
  change some (element a (3*j+3))=some (element a (3*(j+1)))
  rw [Nat.mul_add,Nat.mul_one]

end FT1536.Source3.NttTripleControl184
