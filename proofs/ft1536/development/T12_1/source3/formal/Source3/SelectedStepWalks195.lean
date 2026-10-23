import Source3.StepWalkLoop195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The two named additional-prime marches of the make_fg_step loop body:
   walkFs and walkGs (MakeFgAddPrimeShape194.walkF "fs"/"gs"), each the
   512-step zint_mod_small_signed march over its source words at stride
   slen = 1 with the executed word stored to t1[v]. Each march is exactly
   512 ZintModSignedWord194.ms_call instances at the pinned walk shape
   MakeFgAddPrimeShape194.modArgs — one per marched word — composed with
   the t1[v] stores by StepWalkLoop195.walk_run. The exports are stated
   over an abstract caller state satisfying the march hypotheses (the
   section words p/p0i/R2/Rx, slen = 1, n = 512, the fs/gs and t1
   bindings, the executed source loads and the t1 frame); their discharge
   at the u = 1 loop-body state belongs to the section-export step, with
   the body_entry/continue chain of SelectedStepAddPrime195 and
   SelectedStepGenerate195. Values stay executed words: no transform
   property, table law, root law or positivity claim. -/
namespace FT1536.Source3.SelectedStepWalks195
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99LoopScalar141 (Cell)
open KeygenMakeFgSource (Exec)
open StepCopyBody190 (addr)
open StepWalkFixed195 (Fixed PrefixImage)

/- The fs march: 512 ms_call instances, t1[i] = modSignedWord (fv i)
   pw p0w r2w rxw, exit cells v = 512 and x = addr fs 0 512 1. -/
theorem walkFs_run (s : State) (fs t1 : ArrayPointer) (fv : Fin 512 → BitVec 32)
    (pw p0w r2w rxw : BitVec 32)
    (fixed : Fixed s "fs".toList fs t1 512 fv pw p0w r2w rxw)
    (vDeclared : ∃ old, s.locals "v".toList=some (.uint64,old)) :
    ∃ after, Exec MakeFgAddPrimeShape194.walkFs s ⟨after,.normal⟩ ∧
      Fixed after "fs".toList fs t1 512 fv pw p0w r2w rxw ∧
      PrefixImage after t1 fv pw p0w r2w rxw 512 ∧
      Cell after "v".toList 512 ∧
      after.arrays "x".toList=some (addr fs 0 512 1) ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) := by
  rw [MakeFgAddPrimeShape194.walkFs_shape]
  exact StepWalkLoop195.walk_run s "fs".toList fs t1 512 fv pw p0w r2w rxw fixed vDeclared

/- The gs march: the same 512-instance walk at the gs source. -/
theorem walkGs_run (s : State) (gs t1 : ArrayPointer) (fv : Fin 512 → BitVec 32)
    (pw p0w r2w rxw : BitVec 32)
    (fixed : Fixed s "gs".toList gs t1 512 fv pw p0w r2w rxw)
    (vDeclared : ∃ old, s.locals "v".toList=some (.uint64,old)) :
    ∃ after, Exec MakeFgAddPrimeShape194.walkGs s ⟨after,.normal⟩ ∧
      Fixed after "gs".toList gs t1 512 fv pw p0w r2w rxw ∧
      PrefixImage after t1 fv pw p0w r2w rxw 512 ∧
      Cell after "v".toList 512 ∧
      after.arrays "x".toList=some (addr gs 0 512 1) ∧
      (∀ name : Name, name≠"v".toList → after.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → after.arrays name=s.arrays name) := by
  rw [MakeFgAddPrimeShape194.walkGs_shape]
  exact StepWalkLoop195.walk_run s "gs".toList gs t1 512 fv pw p0w r2w rxw fixed vDeclared

/- The loop-body continuations: r1 = walkFs ; r2 and r4 = walkGs ; r5. -/
theorem walkFs_continue (s mid : State) (out : Result)
    (walk : Exec MakeFgAddPrimeShape194.walkFs s ⟨mid,.normal⟩)
    (rest : Exec MakeFgAddPrimeShape194.r2 mid out) :
    Exec MakeFgAddPrimeShape194.r1 s out := by
  rw [MakeFgAddPrimeShape194.r1_split]
  exact .seqNormal _ _ s mid out walk rest

theorem walkGs_continue (s mid : State) (out : Result)
    (walk : Exec MakeFgAddPrimeShape194.walkGs s ⟨mid,.normal⟩)
    (rest : Exec MakeFgAddPrimeShape194.r5 mid out) :
    Exec MakeFgAddPrimeShape194.r4 s out := by
  rw [MakeFgAddPrimeShape194.r4_split]
  exact .seqNormal _ _ s mid out walk rest

end FT1536.Source3.SelectedStepWalks195
