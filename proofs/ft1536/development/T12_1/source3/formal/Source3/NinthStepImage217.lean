import Source3.NinthStepFull217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NinthStepImage217
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open StepCopyBody190 (elem addr)
open NinthStepLayout217 (fd gd)
open NinthStepEntry217 (caller fWords gWords)
open NinthStepFull217 (afterF afterG)
open NinthStepLoopBase217 (primeRow col)
open NinthStepExtraLoopBase217 (extraRow)
open NinthStepExtraInvariant217 (Active)
open NinthStepExtraPair217 (sWords)
open NinthStepGenerator217 (rxVal)
open CrtPrimePrefix214 (pVal iVal rVal)
open ZintNormWalkFlat208 (Data)

def row (k : Nat) : Nat×Nat×Nat := if k<166 then primeRow k else extraRow k
 noncomputable def family (W R : Nat → BitVec 32) (tables : Nat → Fin 2 → BitVec 32) (k : Nat) : Nat → BitVec 32 :=
  if k<166 then col W k else sWords R (tables k) (pVal (extraRow k)) (iVal (extraRow k)) (rVal (extraRow k)) (rxVal (extraRow k))
 noncomputable def word (W R : Nat → BitVec 32) (tables : Nat → Fin 2 → BitVec 32) (k j : Nat) :=
  StepProductBody191.value (family W R tables k (2*j)) (family W R tables k (2*j+1))
    (rVal (row k)) (pVal (row k)) (iVal (row k))
 noncomputable def flat (W R : Nat → BitVec 32) (tables : Nat → Fin 2 → BitVec 32) (i : Nat) :=
  word W R tables (i%335) (i/335)

theorem pointer (root : ArrayPointer) (i : Nat) : elem root i=addr root (i%335) (i/335) 335 := by
  have div:=Nat.mod_add_div i 335
  exact congrArg (fun k : Nat => (⟨root.block,root.base,root.count,root.elementBytes,k⟩ : ArrayPointer))
    (show root.index+i=root.index+i%335+i/335*335 by omega)

theorem f_column (s : State) (F G RF RG : Nat → BitVec 32) (tables : Nat → Fin 2 → BitVec 32)
    (active : Active s F G RF RG tables 335) (k j : Nat) (kb : k<335) (jb : j<1) :
    Load32 s.heap (addr fd k j 335) (word F RF tables k j) := by
  by_cases first : k<166
  · simpa only [word,family,row,first,ite_true] using active.first.f k first ⟨j,jb⟩ jb
  · have lower : 166 ≤ k := by omega
    simpa only [word,family,row,first,ite_false] using (active.written k lower kb kb).f ⟨j,jb⟩ jb

theorem g_column (s : State) (F G RF RG : Nat → BitVec 32) (tables : Nat → Fin 2 → BitVec 32)
    (active : Active s F G RF RG tables 335) (k j : Nat) (kb : k<335) (jb : j<1) :
    Load32 s.heap (addr gd k j 335) (word G RG tables k j) := by
  by_cases first : k<166
  · simpa only [word,family,row,first,ite_true] using active.first.g k first ⟨j,jb⟩ jb
  · have lower : 166 ≤ k := by omega
    simpa only [word,family,row,first,ite_false] using (active.written k lower kb kb).g ⟨j,jb⟩ jb

theorem gather (s : State) (root : ArrayPointer) (W R : Nat → BitVec 32) (tables : Nat → Fin 2 → BitVec 32)
    (reads : ∀ k j, k<335 → j<1 → Load32 s.heap (addr root k j 335) (word W R tables k j)) :
    Data s root 335 (flat W R tables) := by
  intro i bound
  have kb : i%335<335 := Nat.mod_lt i (by decide)
  have jb : i/335<1 := by omega
  change Load32 s.heap (elem root i) (word W R tables (i%335) (i/335))
  rw [pointer]
  exact reads (i%335) (i/335) kb jb

theorem source : ∃ (callee second third fourth fifth sixth seventh eighth out : State) (old : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32)
    (priorFirst priorExtra : Nat → Fin 64 → BitVec 32) (first5 extra5 : Nat → Fin 32 → BitVec 32) (first6 extra6 : Nat → Fin 16 → BitVec 32) (first7 extra7 : Nat → Fin 8 → BitVec 32) (first8 extra8 : Nat → Fin 4 → BitVec 32)
    (firstTables extraTables : Nat → Fin 2 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (ThirdStepFull216.caller callee second)) ⟨third,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FourthStepEntry216.entry (FourthStepEntry216.caller callee second third)) ⟨fourth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (FifthStepEntry217.entry (FifthStepEntry217.caller callee second third fourth)) ⟨fifth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SixthStepEntry217.entry (SixthStepEntry217.caller callee second third fourth fifth)) ⟨sixth,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SeventhStepEntry217.entry (SeventhStepEntry217.caller callee second third fourth fifth sixth)) ⟨seventh,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (EighthStepEntry217.entry (EighthStepEntry217.caller callee second third fourth fifth sixth seventh)) ⟨eighth,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second third fourth fifth sixth seventh eighth) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (NinthStepEntry217.entry (caller callee second third fourth fifth sixth seventh eighth)) ∧
    Exec (KeygenMakeFgSource.code .step) (NinthStepEntry217.entry (caller callee second third fourth fifth sixth seventh eighth)) ⟨out,.normal⟩ ∧
    Data out fd 335 (flat (fWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8)
      (afterF old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8 firstTables) extraTables) ∧
    Data out gd 335 (flat (gWords old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8)
      (afterG old iv0 iv1 gv2 i0 i1 i2 g3 g4 g5 priorFirst priorExtra first5 extra5 first6 extra6 first7 extra7 first8 extra8 firstTables) extraTables) := by
  obtain ⟨callee,second,third,fourth,fifth,sixth,seventh,eighth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,first8,extra8,firstTables,extraTables,
    run1,run2,run3,run4,run5,run6,run7,run8,binding,run9,active⟩:=NinthStepFull217.source
  refine ⟨callee,second,third,fourth,fifth,sixth,seventh,eighth,out,old,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,priorFirst,priorExtra,first5,extra5,first6,extra6,first7,extra7,first8,extra8,firstTables,extraTables,run1,run2,run3,run4,run5,run6,run7,run8,binding,run9,?_,?_⟩
  · exact gather out fd _ _ extraTables (f_column out _ _ _ _ extraTables active)
  · exact gather out gd _ _ extraTables (g_column out _ _ _ _ extraTables active)

end FT1536.Source3.NinthStepImage217
