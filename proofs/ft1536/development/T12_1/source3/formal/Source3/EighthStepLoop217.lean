import Source3.EighthStepIteration217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.EighthStepLoop217
open C99ArrayReference (State)
open C99MemoryReference (Load32)
open C99IntegerReference (Value)
open KeygenMakeFgSource (Exec)
open StepCopyBody190 (elem addr)
open EighthStepLayout217 (fs gs)
open EighthStepGenerator217 (Outer)
open EighthStepLoopBase217 (init0 init_source bodyState counter guard col primeRow)
open EighthStepInvariant217 (Active RowImage putTables)
open EighthStepInner217 (tableWord)
open CrtPrimePrefix214 (pVal iVal)
open NttInverseWholeBridges201 (scaledWord)
open ZintNormWalkFlat208 (Data)
open KeygenFullData127 (primes rev)

def rowWords (W : Nat → BitVec 32) (tables : Nat → Fin 4 → BitVec 32) (i : Nat) :=
  scaledWord 1 (col W (i%82)) (tableWord (tables (i%82))) (pVal (primeRow (i%82))) (iVal (primeRow (i%82))) (i/82)

theorem remaining (count u : Nat) (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 4 → BitVec 32)
    (active : Active s F G tables u) (finish : u+count=82) :
    ∃ (out : State) (finalTables : Nat → Fin 4 → BitVec 32),
      Exec StepPrimeShape188.loop s ⟨out,.normal⟩ ∧ Active out F G finalTables 82 := by
  induction count generalizing u s tables with
  | zero =>
    have eq : u=82 := by omega
    subst u
    have test : C99ArrayReference.scalar s StepPrimeShape188.condition (.int32 0) := by
      simpa [C99ScalarReference.boolean] using guard s 82 active.outer (by decide)
    exact ⟨s,tables,.loopFalse _ _ _ _ (.int32 0) test (by decide),active⟩
  | succ count ih =>
    have slot : u<82 := by omega
    obtain ⟨mid,ivs,body,increment,nextActive⟩:=EighthStepIteration217.source s F G tables u active slot
    obtain ⟨out,finalTables,rest,finalActive⟩:=ih (u+1) (counter s mid (u+1))
      (putTables tables u ivs) nextActive (by omega)
    refine ⟨out,finalTables,?_,finalActive⟩
    refine .loopNormal _ _ _ s (bodyState s mid) (counter s mid (u+1)) ⟨out,.normal⟩
      (C99ScalarReference.boolean (decide (u<82))) ?_ ?_ body increment rest
    · exact guard s u active.outer (by omega)
    · simp [slot,C99ScalarReference.boolean,Value.integer]

theorem flatF (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 4 → BitVec 32)
    (active : Active s F G tables 82) : Data s fs 328 (rowWords F tables) := by
  intro i bound
  have kb : i%82<82 := Nat.mod_lt i (by decide)
  have jb : i/82<4 := by omega
  change Load32 s.heap (elem fs i) (scaledWord 1 (col F (i%82)) (tableWord (tables (i%82)))
    (pVal (primeRow (i%82))) (iVal (primeRow (i%82))) (i/82))
  rw [SeventhStepImage217.pointer]
  exact (active.written (i%82) kb kb).fs (i/82) jb

theorem flatG (s : State) (F G : Nat → BitVec 32) (tables : Nat → Fin 4 → BitVec 32)
    (active : Active s F G tables 82) : Data s gs 328 (rowWords G tables) := by
  intro i bound
  have kb : i%82<82 := Nat.mod_lt i (by decide)
  have jb : i/82<4 := by omega
  change Load32 s.heap (elem gs i) (scaledWord 1 (col G (i%82)) (tableWord (tables (i%82)))
    (pVal (primeRow (i%82))) (iVal (primeRow (i%82))) (i/82))
  rw [SeventhStepImage217.pointer]
  exact (active.written (i%82) kb kb).gs (i/82) jb

theorem source (s : State) (F G : Nat → BitVec 32)
    (uDeclared : s.locals "u".toList=some (.uint64,none)) (outer : Outer (init0 s) 0)
    (object : KeygenStaticTables.PrimeObject (init0 s).heap primes .ternary)
    (revB : (init0 s).tables "REV10".toList=some rev) (revS : KeygenMkgm3RevMemory.SourceTable (init0 s).heap rev)
    (fdata : Data (init0 s) fs 328 F) (gdata : Data (init0 s) gs 328 G) :
    ∃ (out : State) (tables : Nat → Fin 4 → BitVec 32),
      Exec (KeygenMakeFgSource.part .step 2) s ⟨out,.normal⟩ ∧ Active out F G tables 82 ∧
      Data out fs 328 (rowWords F tables) ∧ Data out gs 328 (rowWords G tables) := by
  let initialTables : Nat → Fin 4 → BitVec 32 := fun _ _ => 0
  have start : Active (init0 s) F G initialTables 0 := by
    refine ⟨outer,object,revB,revS,?_,?_,?_⟩
    · intro k _ kb j jb
      have eq : addr fs k j 82=elem fs (k+j*82) :=
        congrArg (fun n : Nat => (⟨fs.block,fs.base,fs.count,fs.elementBytes,n⟩ : C99MemoryReference.ArrayPointer))
          (show fs.index+k+j*82=fs.index+(k+j*82) by omega)
      rw [eq]
      exact fdata (k+j*82) (by omega)
    · intro k _ kb j jb
      have eq : addr gs k j 82=elem gs (k+j*82) :=
        congrArg (fun n : Nat => (⟨gs.block,gs.base,gs.count,gs.elementBytes,n⟩ : C99MemoryReference.ArrayPointer))
          (show gs.index+k+j*82=gs.index+(k+j*82) by omega)
      rw [eq]
      exact gdata (k+j*82) (by omega)
    · intro k impossible; omega
  obtain ⟨out,tables,loopRun,finalActive⟩:=remaining 82 0 (init0 s) F G initialTables start (by omega)
  have part : Exec (KeygenMakeFgSource.part .step 2) s ⟨out,.normal⟩ := by
    rw [StepPrimeShape188.loop_shape]
    exact .seqNormal _ _ _ out _ (.seqNormal _ _ _ (init0 s) _ (init_source s uDeclared) loopRun)
      (SelectedStepAddPrime195.skip_run out)
  exact ⟨out,tables,part,finalActive,flatF out F G tables finalActive,flatG out F G tables finalActive⟩

end FT1536.Source3.EighthStepLoop217
