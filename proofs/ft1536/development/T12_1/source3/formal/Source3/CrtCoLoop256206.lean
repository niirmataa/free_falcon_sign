import Source3.CrtCoLoop206

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtCoLoop256206
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open CrtRoundReady206 (Input)
open CrtWalkIncrement206 (cell)
open CrtWalkFixed206 (Pending high lowWord highWord)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open CrtPrimePrefix206 (s1)
open StepCopyBody190 (addr elem)

def lowWords (W : Nat → BitVec 32) (t : BitVec 32) (j : Nat) := lowWord (W (2*j)) (W (2*j+1)) t p1 p0i1 r21 s1
 def highWords (W : Nat → BitVec 32) (t : BitVec 32) (j : Nat) := highWord (W (2*j)) (W (2*j+1)) t p1 p0i1 r21 s1
 def imageWords (W : Nat → BitVec 32) (t : BitVec 32) := StepFirstImage196.interleave (lowWords W t) (highWords W t)

 theorem low_address (root : ArrayPointer) (j : Nat) : cell root j=addr root 0 j 2 := by
  exact congrArg (fun i : Nat => (⟨root.block,root.base,root.count,root.elementBytes,i⟩ : ArrayPointer))
    (show root.index+2*j=root.index+0+j*2 by omega)

 theorem high_address (root : ArrayPointer) (j : Nat) : high root j=addr root 1 j 2 := by
  rw [CrtWalkFixed206.high_eq]
  exact congrArg (fun i : Nat => (⟨root.block,root.base,root.count,root.elementBytes,i⟩ : ArrayPointer))
    (show root.index+(2*j+1)=root.index+1+j*2 by omega)

theorem source (s : State) (root tmp : ArrayPointer) (W : Nat → BitVec 32) (t : BitVec 32)
    (input : Input s root tmp 256 t) (len : Cell s "xlen".toList 2) (data : StepNttImage195.Image s root W) :
    ∃ out, KeygenZintCall.Exec ZintRebuildCrt194.coLoop s ⟨out,.normal⟩ ∧
      StepNttImage195.Image out root (imageWords W t) ∧
      Load32 out.heap tmp (ZintMulWord205.low t p1) ∧
      Load32 out.heap (ZintAddMulWord205.next tmp) (ZintMulWord205.carry t p1) ∧ Cell out "u".toList 2 ∧
      out.arrays "x".toList=some (cell root 256) ∧
      (∀ name : Name, name≠"u".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i : Fin 256, Separate (cell root i.val) q ∧ Separate (high root i.val) q) →
        Separate tmp q → Separate (ZintAddMulWord205.next tmp) q →
        Load32 s.heap q old → Load32 out.heap q old) := by
  let av : Fin 256 → BitVec 32 := fun i => W (2*i.val)
  let bv : Fin 256 → BitVec 32 := fun i => W (2*i.val+1)
  have pending : Pending s root av bv 0 := by
    intro i _
    have bound:=i.isLt
    refine ⟨data (2*i.val) (by omega),?_⟩
    rw [CrtWalkFixed206.high_eq]
    exact data (2*i.val+1) (by omega)
  obtain ⟨out,run,written,lo,hi,u,x,locals,arrays,keep⟩:=CrtCoLoop206.source s root tmp av bv t input len pending
  refine ⟨out,run,?_,lo,hi,u,x,locals,arrays,keep⟩
  apply SecondStepInterleave204.columns
  · intro j bound
    have read:=(written ⟨j,bound⟩ bound).1
    rw [low_address] at read
    exact read
  · intro j bound
    have read:=(written ⟨j,bound⟩ bound).2
    rw [high_address] at read
    exact read

end FT1536.Source3.CrtCoLoop256206
