import Source3.EighthStepExtraIteration217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.EighthStepExtraLoop217
open C99ArrayReference (State)
open C99IntegerReference (Value)
open KeygenMakeFgSource (Exec)
open EighthStepLayout217 (fs gs)
open EighthStepGenerator217 (Outer)
open EighthStepCrtFirst217 (FirstProducts)
open EighthStepExtraLoopBase217 (scopedState counter guard init_source)
open EighthStepExtraInvariant217 (Active)
open EighthStepInvariant217 (putTables)
open ZintNormWalkFlat208 (Data)
open KeygenFullData127 (primes rev)

theorem remaining (count u : Nat) (s : State) (F G RF RG : Nat → BitVec 32)
    (tables : Nat → Fin 4 → BitVec 32) (active : Active s F G RF RG tables u)
    (lower : 82 ≤ u) (finish : u+count=166) :
    ∃ (out : State) (finalTables : Nat → Fin 4 → BitVec 32),
      Exec MakeFgAddPrimeShape194.aLoop s ⟨out,.normal⟩ ∧ Active out F G RF RG finalTables 166 := by
  induction count generalizing u s tables with
  | zero =>
    have eq : u=166 := by omega
    subst u
    have test : C99ArrayReference.scalar s (.cmp .lt MakeFgAddPrimeShape194.varU MakeFgAddPrimeShape194.varTlen) (.int32 0) := by
      simpa [C99ScalarReference.boolean] using guard s 166 active.outer (by decide)
    rw [MakeFgAddPrimeShape194.loop_shape]
    exact ⟨s,tables,.loopFalse _ _ _ _ (.int32 0) test (by decide),active⟩
  | succ count ih =>
    have slot : u<166 := by omega
    obtain ⟨mid,gvs,body,increment,nextActive⟩:=EighthStepExtraIteration217.source s F G RF RG tables u active lower slot
    obtain ⟨out,finalTables,rest,finalActive⟩:=ih (u+1) (counter s mid (u+1))
      (putTables tables u gvs) nextActive (by omega) (by omega)
    refine ⟨out,finalTables,?_,finalActive⟩
    rw [MakeFgAddPrimeShape194.loop_shape] at rest ⊢
    refine .loopNormal _ _ _ s (scopedState s mid) (counter s mid (u+1)) ⟨out,.normal⟩
      (C99ScalarReference.boolean (decide (u<166))) ?_ ?_ body increment rest
    · exact guard s u active.outer (by omega)
    · simp [slot,C99ScalarReference.boolean,Value.integer]

theorem source (s : State) (F G RF RG : Nat → BitVec 32) (outer : Outer s 82)
    (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (revB : s.tables "REV10".toList=some rev) (revS : KeygenMkgm3RevMemory.SourceTable s.heap rev)
    (fdata : Data s fs 328 RF) (gdata : Data s gs 328 RG) (first : FirstProducts s F G) :
    ∃ (out : State) (tables : Nat → Fin 4 → BitVec 32),
      Exec MakeFgAddPrimeShape194.part4 s ⟨out,.normal⟩ ∧ Active out F G RF RG tables 166 := by
  let initialTables : Nat → Fin 4 → BitVec 32 := fun _ _ => 0
  have start : Active s F G RF RG initialTables 82 := ⟨outer,object,revB,revS,fdata,gdata,first,
    fun k lower earlier => by omega⟩
  obtain ⟨out,tables,loopRun,finalActive⟩:=remaining 84 82 s F G RF RG initialTables start (by decide) (by decide)
  have part : Exec MakeFgAddPrimeShape194.part4 s ⟨out,.normal⟩ := by
    rw [MakeFgAddPrimeShape194.part4_split,MakeFgAddPrimeShape194.aFor_split,MakeFgAddPrimeShape194.aTail_skip]
    exact .seqNormal _ _ _ out _ (.seqNormal _ _ _ s _ (init_source s outer) loopRun) (SelectedStepAddPrime195.skip_run out)
  exact ⟨out,tables,part,finalActive⟩

end FT1536.Source3.EighthStepExtraLoop217
