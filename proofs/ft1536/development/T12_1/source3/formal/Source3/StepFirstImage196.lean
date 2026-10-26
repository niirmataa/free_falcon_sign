import Source3.StepFirstColumns196

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.StepFirstImage196
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open SelectedStepLayout187 (fd gd)
open StepCopyBody190 (elem addr)
open StepProductBody191 (value)

def interleave (even odd : Nat → BitVec 32) (j : Nat) : BitVec 32 :=
  if j%2=0 then even (j/2) else odd (j/2)

def products (W : Nat → BitVec 32) (p p0i r2 : BitVec 32) (v : Nat) : BitVec 32 :=
  value (W (2*v)) (W (2*v+1)) r2 p p0i

theorem columns_image {s : State} {a : ArrayPointer} {P0 I0 R0 P1 I1 R1 : BitVec 32}
    {W0 W1 : Nat → BitVec 32}
    (even : StepProductFixed191.Image s a 0 2 256 P0 I0 R0 W0 256)
    (odd : StepProductFixed191.Image s a 1 2 256 P1 I1 R1 W1 256) :
    StepNttImage195.Image s a (interleave (products W0 P0 I0 R0) (products W1 P1 I1 R1)) := by
  intro j bound
  have indexBound : j/2<256 := by omega
  by_cases parity : j%2=0
  · have address : elem a j=addr a 0 (j/2) 2 := by
      change {a with index:=a.index+j}={a with index:=a.index+0+(j/2)*2}
      apply congrArg (fun k : Nat => (⟨a.block,a.base,a.count,a.elementBytes,k⟩ : ArrayPointer))
      omega
    have read := even ⟨j/2,indexBound⟩ indexBound
    change Load32 s.heap (elem a j) _
    rw [address]
    simpa only [interleave,parity,ite_true,products] using read
  · have address : elem a j=addr a 1 (j/2) 2 := by
      change {a with index:=a.index+j}={a with index:=a.index+1+(j/2)*2}
      apply congrArg (fun k : Nat => (⟨a.block,a.base,a.count,a.elementBytes,k⟩ : ArrayPointer))
      omega
    have read := odd ⟨j/2,indexBound⟩ indexBound
    change Load32 s.heap (elem a j) _
    rw [address]
    simpa only [interleave,parity,ite_false,products] using read

noncomputable def fdWords (gvs : Fin 512 → BitVec 32) : Nat → BitVec 32 :=
  interleave
    (products SelectedStepProduct191.fvs SelectedTopInit178.p SelectedTopInit178.p0i SelectedTopInit178.r2)
    (products (StepAddBody195.resultWords StepAddConcrete195.inputF gvs)
      SelectedStepAddPrime195.p1 SelectedStepAddPrime195.p0i1 SelectedStepAddPrime195.r21)
noncomputable def gdWords (gvs : Fin 512 → BitVec 32) : Nat → BitVec 32 :=
  interleave
    (products SelectedStepChainKeep194.gvs SelectedTopInit178.p SelectedTopInit178.p0i SelectedTopInit178.r2)
    (products (StepAddBody195.resultWords StepAddConcrete195.inputG gvs)
      SelectedStepAddPrime195.p1 SelectedStepAddPrime195.p0i1 SelectedStepAddPrime195.r21)

/-- The entire first make_fg_step body, with both complete output arrays. -/
theorem source : ∃ (out : State) (gvs : Fin 512 → BitVec 32),
    KeygenMakeFgSource.Exec (KeygenMakeFgSource.code .step) FirstStepEntry187.entry ⟨out,.normal⟩ ∧
    StepNttImage195.Image out fd (fdWords gvs) ∧ StepNttImage195.Image out gd (gdWords gvs) := by
  obtain ⟨after2,after3,out,gvs,part2,part3,part4,fd0,gd0,fd1,gd1⟩ := StepFirstColumns196.source
  have rest : KeygenMakeFgSource.Exec SelectedStepPrefix187.remaining SelectedStepMove187.after
      ⟨out,.normal⟩ :=
    .seqNormal _ _ _ after2 _ part2 (.seqNormal _ _ after2 after3 _ part3
      (.seqNormal _ _ after3 out _ part4 (SelectedStepAddPrime195.skip_run out)))
  exact ⟨out,gvs,SelectedStepPrefix187.continue_step _ rest,columns_image fd0 fd1,columns_image gd0 gd1⟩

end FT1536.Source3.StepFirstImage196
