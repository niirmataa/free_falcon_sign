import Source3.FourthStepFull216

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FourthStepImage216
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open StepCopyBody190 (elem addr)
open FourthStepLayout216 (fd gd)
open FourthStepEntry216 (caller fWords gWords)
open FourthStepFull216 (afterF afterG)
open FourthStepLoopBase216 (primeRow col)
open FourthStepExtraLoopBase216 (extraRow)
open FourthStepExtraInvariant216 (Active)
open FourthStepExtraPair216 (sWords)
open FourthStepGenerator216 (rxVal)
open CrtPrimePrefix214 (pVal iVal rVal)
open ZintNormWalkFlat208 (Data)

def row (k : Nat) : Nat×Nat×Nat := if k<6 then primeRow k else extraRow k
 noncomputable def family (W R : Nat → BitVec 32) (tables : Nat → Fin 64 → BitVec 32) (k : Nat) : Nat → BitVec 32 :=
  if k<6 then col W k else sWords R (tables k) (pVal (extraRow k)) (iVal (extraRow k)) (rVal (extraRow k)) (rxVal (extraRow k))
 noncomputable def word (W R : Nat → BitVec 32) (tables : Nat → Fin 64 → BitVec 32) (k j : Nat) :=
  StepProductBody191.value (family W R tables k (2*j)) (family W R tables k (2*j+1))
    (rVal (row k)) (pVal (row k)) (iVal (row k))
 noncomputable def flat (W R : Nat → BitVec 32) (tables : Nat → Fin 64 → BitVec 32) (i : Nat) :=
  word W R tables (i%12) (i/12)

theorem pointer (root : ArrayPointer) (i : Nat) : elem root i=addr root (i%12) (i/12) 12 := by
  have div:=Nat.mod_add_div i 12
  exact congrArg (fun k : Nat => (⟨root.block,root.base,root.count,root.elementBytes,k⟩ : ArrayPointer))
    (show root.index+i=root.index+i%12+i/12*12 by omega)

theorem f_column (s : State) (F G RF RG : Nat → BitVec 32) (tables : Nat → Fin 64 → BitVec 32)
    (active : Active s F G RF RG tables 12) (k j : Nat) (kb : k<12) (jb : j<32) :
    Load32 s.heap (addr fd k j 12) (word F RF tables k j) := by
  by_cases first : k<6
  · simpa only [word,family,row,first,ite_true] using active.first.f k first ⟨j,jb⟩ jb
  · have lower : 6 ≤ k := by omega
    simpa only [word,family,row,first,ite_false] using (active.written k lower kb kb).f ⟨j,jb⟩ jb

theorem g_column (s : State) (F G RF RG : Nat → BitVec 32) (tables : Nat → Fin 64 → BitVec 32)
    (active : Active s F G RF RG tables 12) (k j : Nat) (kb : k<12) (jb : j<32) :
    Load32 s.heap (addr gd k j 12) (word G RG tables k j) := by
  by_cases first : k<6
  · simpa only [word,family,row,first,ite_true] using active.first.g k first ⟨j,jb⟩ jb
  · have lower : 6 ≤ k := by omega
    simpa only [word,family,row,first,ite_false] using (active.written k lower kb kb).g ⟨j,jb⟩ jb

theorem gather (s : State) (root : ArrayPointer) (W R : Nat → BitVec 32) (tables : Nat → Fin 64 → BitVec 32)
    (reads : ∀ k j, k<12 → j<32 → Load32 s.heap (addr root k j 12) (word W R tables k j)) :
    Data s root 384 (flat W R tables) := by
  intro i bound
  have kb : i%12<12 := Nat.mod_lt i (by decide)
  have jb : i/12<32 := by omega
  change Load32 s.heap (elem root i) (word W R tables (i%12) (i/12))
  rw [pointer]
  exact reads (i%12) (i/12) kb jb

theorem source : ∃ (callee second third out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (firstTables extraTables : Nat → Fin 64 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (FourthStepEntry216.entry (caller callee second third)) ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (caller callee second third)) ⟨out,.normal⟩ ∧
    Data out fd 384 (flat (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5)
      (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables) extraTables) ∧
    Data out gd 384 (flat (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5)
      (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 firstTables) extraTables) := by
  obtain ⟨callee,second,third,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,firstTables,extraTables,
    run1,run2,run3,binding,run4,active⟩:=FourthStepFull216.source
  refine ⟨callee,second,third,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,firstTables,extraTables,run1,run2,run3,binding,run4,?_,?_⟩
  · exact gather out fd _ _ extraTables (f_column out _ _ _ _ extraTables active)
  · exact gather out gd _ _ extraTables (g_column out _ _ _ _ extraTables active)

end FT1536.Source3.FourthStepImage216
