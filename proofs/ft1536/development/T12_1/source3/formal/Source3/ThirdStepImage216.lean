import Source3.ThirdStepFull216

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ThirdStepImage216
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open StepCopyBody190 (elem addr)
open ThirdStepLayout215 (fd gd)
open ThirdStepBody216 (FirstImages ExtraImages firstRow merged)
open ThirdStepFull216 (caller fInput gInput)
open ThirdStepCrtExtra216 (Words)
open ThirdStepGenerator215 (rxVal)
open CrtPrimePrefix214 (pVal iVal rVal)
open ThirdStepExtra215 (v3 v4 v5)
open ThirdStepExtraPair215 (sWords)
open ZintNormWalkFlat208 (Data)

def row (k : Nat) : Nat×Nat×Nat := if k<3 then firstRow k else if k=3 then v3 else if k=4 then v4 else v5
 noncomputable def family (W R : Nat → BitVec 32) (g3 g4 g5 : Fin 128 → BitVec 32) (k : Nat) : Nat → BitVec 32 :=
  if k<3 then ThirdStepLoop215.colF W k else
    if k=3 then sWords R g3 (pVal v3) (iVal v3) (rVal v3) (rxVal v3) else
    if k=4 then sWords R g4 (pVal v4) (iVal v4) (rVal v4) (rxVal v4) else
      sWords R g5 (pVal v5) (iVal v5) (rVal v5) (rxVal v5)
 noncomputable def word (W R : Nat → BitVec 32) (g3 g4 g5 : Fin 128 → BitVec 32) (k j : Nat) :=
  StepProductBody191.value (family W R g3 g4 g5 k (2*j)) (family W R g3 g4 g5 k (2*j+1))
    (rVal (row k)) (pVal (row k)) (iVal (row k))
 noncomputable def flat (W R : Nat → BitVec 32) (g3 g4 g5 : Fin 128 → BitVec 32) (i : Nat) :=
  word W R g3 g4 g5 (i%6) (i/6)

theorem pointer (root : ArrayPointer) (i : Nat) : elem root i=addr root (i%6) (i/6) 6 := by
  have div:=Nat.mod_add_div i 6
  exact congrArg (fun k : Nat => (⟨root.block,root.base,root.count,root.elementBytes,k⟩ : ArrayPointer))
    (show root.index+i=root.index+i%6+i/6*6 by omega)

theorem gather (s : State) (root : ArrayPointer) (W R : Nat → BitVec 32) (g3 g4 g5 : Fin 128 → BitVec 32)
    (reads : ∀ k, k<6 → ∀ j, j<64 → Load32 s.heap (addr root k j 6) (word W R g3 g4 g5 k j)) :
    Data s root 384 (flat W R g3 g4 g5) := by
  intro i bound
  have kb : i%6<6 := Nat.mod_lt i (by decide)
  have jb : i/6<64 := by omega
  change Load32 s.heap (elem root i) (word W R g3 g4 g5 (i%6) (i/6))
  rw [pointer]
  exact reads (i%6) kb (i/6) jb

theorem f_column (s : State) (F G RF RG : Nat → BitVec 32) (g3 g4 g5 : Fin 128 → BitVec 32)
    (first : FirstImages s F G) (extra : ExtraImages s RF RG g3 g4 g5)
    (k j : Nat) (kb : k<6) (jb : j<64) : Load32 s.heap (addr fd k j 6) (word F RF g3 g4 g5 k j) := by
  have choices : k=0 ∨ k=1 ∨ k=2 ∨ k=3 ∨ k=4 ∨ k=5 := by omega
  rcases choices with a | a | a | a | a | a <;> subst k
  · exact first.f 0 (by decide) ⟨j,jb⟩ jb
  · exact first.f 1 (by decide) ⟨j,jb⟩ jb
  · exact first.f 2 (by decide) ⟨j,jb⟩ jb
  · exact extra.f3 ⟨j,jb⟩ jb
  · exact extra.f4 ⟨j,jb⟩ jb
  · exact extra.f5 ⟨j,jb⟩ jb

theorem g_column (s : State) (F G RF RG : Nat → BitVec 32) (g3 g4 g5 : Fin 128 → BitVec 32)
    (first : FirstImages s F G) (extra : ExtraImages s RF RG g3 g4 g5)
    (k j : Nat) (kb : k<6) (jb : j<64) : Load32 s.heap (addr gd k j 6) (word G RG g3 g4 g5 k j) := by
  have choices : k=0 ∨ k=1 ∨ k=2 ∨ k=3 ∨ k=4 ∨ k=5 := by omega
  rcases choices with a | a | a | a | a | a <;> subst k
  · exact first.g 0 (by decide) ⟨j,jb⟩ jb
  · exact first.g 1 (by decide) ⟨j,jb⟩ jb
  · exact first.g 2 (by decide) ⟨j,jb⟩ jb
  · exact extra.g3 ⟨j,jb⟩ jb
  · exact extra.g4 ⟨j,jb⟩ jb
  · exact extra.g5 ⟨j,jb⟩ jb

theorem source : ∃ (callee second out : State) (oldWords : Fin 512 → BitVec 32)
    (iv0 iv1 gv2 : Fin 256 → BitVec 32) (i0 i1 i2 g3 g4 g5 : Fin 128 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨second,.normal⟩ ∧
    C99ArrayReference.Bind (caller callee second) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (ThirdStepEntry215.entry (caller callee second)) ∧
    Exec (KeygenMakeFgSource.code .step) (ThirdStepEntry215.entry (caller callee second)) ⟨out,.normal⟩ ∧
    Data out fd 384 (flat (fInput oldWords iv0 iv1 gv2) (Words (merged (fInput oldWords iv0 iv1 gv2) i0 i1 i2)) g3 g4 g5) ∧
    Data out gd 384 (flat (gInput oldWords iv0 iv1 gv2) (Words (merged (gInput oldWords iv0 iv1 gv2) i0 i1 i2)) g3 g4 g5) := by
  obtain ⟨callee,second,out,oldWords,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,run1,run2,binding,run3,_,first,extra,_,_⟩:=ThirdStepFull216.source
  refine ⟨callee,second,out,oldWords,iv0,iv1,gv2,i0,i1,i2,g3,g4,g5,run1,run2,binding,run3,?_,?_⟩
  · exact gather out fd _ _ g3 g4 g5 (fun k kb j jb => f_column out _ _ _ _ g3 g4 g5 first extra k j kb jb)
  · exact gather out gd _ _ g3 g4 g5 (fun k kb j jb => g_column out _ _ _ _ g3 g4 g5 first extra k j kb jb)

end FT1536.Source3.ThirdStepImage216
