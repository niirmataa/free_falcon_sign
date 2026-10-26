import Source3.SecondStepFull212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepImage212
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open KeygenMakeFgSource (Exec)
open StepCopyBody190 (elem addr)
open ZintNormWalkFlat208 (Data)
open SecondStepLayout197 (fd gd)
open SelectedTopInit178 (p p0i r2)
open SelectedStepAddPrime195 (p1 p0i1 r21)
open SecondExtraPrime212 (p2 i2 r22)

def interleave (a b c : Nat → BitVec 32) (i : Nat) :=
  if i%3=0 then a (i/3) else if i%3=1 then b (i/3) else c (i/3)
 def product (p pi r2 : BitVec 32) (fv : Nat → BitVec 32) (j : Nat) :=
  StepProductBody191.value (fv (2*j)) (fv (2*j+1)) r2 p pi
 noncomputable def fWords (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 gvs2 : Fin 256 → BitVec 32) :=
  interleave (product p p0i r2 (SecondStepFirstColumn203.inputWord oldWords))
    (product p1 p0i1 r21 (SecondStepLoop204.oddF oldWords))
    (product p2 i2 r22 (SecondStepFull212.extraF oldWords ivs0 ivs1 gvs2))
 noncomputable def gWords (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 gvs2 : Fin 256 → BitVec 32) :=
  interleave (product p p0i r2 (SecondStepFirstBody203.gInputWord oldWords))
    (product p1 p0i1 r21 (SecondStepLoop204.oddG oldWords))
    (product p2 i2 r22 (SecondStepFull212.extraG oldWords ivs0 ivs1 gvs2))

theorem pointer (root : ArrayPointer) (i u : Nat) (eq : i%3=u) : elem root i=addr root u (i/3) 3 := by
  have div:=Nat.mod_add_div i 3
  exact congrArg (fun k : Nat => (⟨root.block,root.base,root.count,root.elementBytes,k⟩ : ArrayPointer))
    (show root.index+i=root.index+u+i/3*3 by omega)

theorem gather (s : State) (root : ArrayPointer) (a b c : Nat → BitVec 32)
    (da : ∀ j, j<128 → Load32 s.heap (addr root 0 j 3) (a j))
    (db : ∀ j, j<128 → Load32 s.heap (addr root 1 j 3) (b j))
    (dc : ∀ j, j<128 → Load32 s.heap (addr root 2 j 3) (c j)) :
    Data s root 384 (interleave a b c) := by
  intro i bound
  have jb : i/3<128 := by omega
  by_cases zero : i%3=0
  · simp only [interleave,zero,ite_true]
    rw [pointer root i 0 zero]
    exact da (i/3) jb
  · by_cases one : i%3=1
    · simp only [interleave,one,ite_true]
      rw [pointer root i 1 one]
      exact db (i/3) jb
    · have two : i%3=2 := by have mb:=Nat.mod_lt i (by decide : 0<3); omega
      simp only [interleave,zero,one,ite_false]
      rw [pointer root i 2 two]
      exact dc (i/3) jb

theorem source : ∃ (callee out : State) (oldWords : Fin 512 → BitVec 32) (ivs0 ivs1 gvs2 : Fin 256 → BitVec 32),
    Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨callee,.normal⟩ ∧
    C99ArrayReference.Bind (SecondStepLengths197.caller callee) (KeygenMakeFgSource.params .step) FirstStepEntry187.arguments
      (SecondStepStatics204.entry callee) ∧
    Exec (KeygenMakeFgSource.code .step) (SecondStepStatics204.entry callee) ⟨out,.normal⟩ ∧ SecondStepOuter204.Outer out 3 ∧
    Data out fd 384 (fWords oldWords ivs0 ivs1 gvs2) ∧ Data out gd 384 (gWords oldWords ivs0 ivs1 gvs2) := by
  obtain ⟨callee,out,oldWords,ivs0,ivs1,gvs2,first,binding,run,outer,fd0,fd1,fd2,gd0,gd1,gd2⟩:=SecondStepFull212.source
  refine ⟨callee,out,oldWords,ivs0,ivs1,gvs2,first,binding,run,outer,?_,?_⟩
  · exact gather out fd _ _ _ (fun j b => fd0 ⟨j,b⟩ b) (fun j b => fd1 ⟨j,b⟩ b) (fun j b => fd2 ⟨j,b⟩ b)
  · exact gather out gd _ _ _ (fun j b => gd0 ⟨j,b⟩ b) (fun j b => gd1 ⟨j,b⟩ b) (fun j b => gd2 ⟨j,b⟩ b)

end FT1536.Source3.SecondStepImage212
