import Source3.SixthStepFull217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SixthStepImage217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open StepCopyBody190 (elem addr)
open SixthStepLayout217 (fd gd)
open SixthStepEntry217 (caller fWords gWords)
open SixthStepFull217 (afterF afterG)
open SixthStepLoopBase217 (primeRow col)
open SixthStepExtraLoopBase217 (extraRow)
open SixthStepExtraInvariant217 (Active)
open SixthStepExtraPair217 (sWords)
open SixthStepGenerator217 (rxVal)
open CrtPrimePrefix214 (pVal iVal rVal)
open ZintNormWalkFlat208 (Data)

def row (k : Nat) : Nat×Nat×Nat := if k<22 then primeRow k else extraRow k
 noncomputable def family (W R : Nat → BitVec 32) (tables : Nat → Fin 16 → BitVec 32) (k : Nat) : Nat → BitVec 32 :=
  if k<22 then col W k else sWords R (tables k) (pVal (extraRow k)) (iVal (extraRow k)) (rVal (extraRow k)) (rxVal (extraRow k))
 noncomputable def word (W R : Nat → BitVec 32) (tables : Nat → Fin 16 → BitVec 32) (k j : Nat) :=
  StepProductBody191.value (family W R tables k (2*j)) (family W R tables k (2*j+1))
    (rVal (row k)) (pVal (row k)) (iVal (row k))
 noncomputable def flat (W R : Nat → BitVec 32) (tables : Nat → Fin 16 → BitVec 32) (i : Nat) :=
  word W R tables (i%42) (i/42)

theorem pointer (root : ArrayPointer) (i : Nat) : elem root i=addr root (i%42) (i/42) 42 := by
  have div:=Nat.mod_add_div i 42
  exact congrArg (fun k : Nat => (⟨root.block,root.base,root.count,root.elementBytes,k⟩ : ArrayPointer))
    (show root.index+i=root.index+i%42+i/42*42 by omega)

theorem f_column (s : State) (F G RF RG : Nat → BitVec 32) (tables : Nat → Fin 16 → BitVec 32)
    (active : Active s F G RF RG tables 42) (k j : Nat) (kb : k<42) (jb : j<8) :
    Load32 s.heap (addr fd k j 42) (word F RF tables k j) := by
  by_cases first : k<22
  · simpa only [word,family,row,first,ite_true] using active.first.f k first ⟨j,jb⟩ jb
  · have lower : 22 ≤ k := by omega
    simpa only [word,family,row,first,ite_false] using (active.written k lower kb kb).f ⟨j,jb⟩ jb

theorem g_column (s : State) (F G RF RG : Nat → BitVec 32) (tables : Nat → Fin 16 → BitVec 32)
    (active : Active s F G RF RG tables 42) (k j : Nat) (kb : k<42) (jb : j<8) :
    Load32 s.heap (addr gd k j 42) (word G RG tables k j) := by
  by_cases first : k<22
  · simpa only [word,family,row,first,ite_true] using active.first.g k first ⟨j,jb⟩ jb
  · have lower : 22 ≤ k := by omega
    simpa only [word,family,row,first,ite_false] using (active.written k lower kb kb).g ⟨j,jb⟩ jb

theorem gather (s : State) (root : ArrayPointer) (W R : Nat → BitVec 32) (tables : Nat → Fin 16 → BitVec 32)
    (reads : ∀ k j, k<42 → j<8 → Load32 s.heap (addr root k j 42) (word W R tables k j)) :
    Data s root 336 (flat W R tables) := by
  intro i bound
  have kb : i%42<42 := Nat.mod_lt i (by decide)
  have jb : i/42<8 := by omega
  change Load32 s.heap (elem root i) (word W R tables (i%42) (i/42))
  rw [pointer]
  exact reads (i%42) (i/42) kb jb

theorem source : ∃ (callee second third fourth fifth out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32)
    (firstTables extraTables : Nat → Fin 16 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third fourth fifth) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SixthStepEntry217.entry (caller callee second third fourth fifth)) ∧
    Exec (KeygenMakeFgSource.code .step) (SixthStepEntry217.entry (caller callee second third fourth fifth)) ⟨out,.normal⟩ ∧
    Data out fd 336 (flat (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5)
      (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables) extraTables) ∧
    Data out gd 336 (flat (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5)
      (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 firstTables) extraTables) := by
  obtain ⟨callee,second,third,fourth,fifth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,firstTables,extraTables,
    run1,run2,run3,run4,run5,binding,run6,active⟩:=SixthStepFull217.source
  refine ⟨callee,second,third,fourth,fifth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,firstTables,extraTables,run1,run2,run3,run4,run5,binding,run6,?_,?_⟩
  · exact gather out fd _ _ extraTables (f_column out _ _ _ _ extraTables active)
  · exact gather out gd _ _ extraTables (g_column out _ _ _ _ extraTables active)

end FT1536.Source3.SixthStepImage217
