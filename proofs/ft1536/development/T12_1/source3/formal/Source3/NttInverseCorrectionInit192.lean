import Source3.NttInverseCorrectionSource192

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generalized corrective scaling composition over an arbitrary prior u
   cell. The accepted NttInverseCorrectionSource192 freezes the u
   declaration at `some (.uint64,none)`, but the degree-1 final pass
   leaves u = 256 at the correction entry; this module mirrors its
   init_run/source with the uInit assignment at an arbitrary old value,
   in particular at `some (u64 256)`. Same executed words, same exports,
   no numerical property. -/
namespace FT1536.Source3.NttInverseCorrectionInit192
open C99ArrayReference (State Name Pointer bindPointer bindValue)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open C99IntegerReference (Value)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open C99NatWord141 (word)
open NttInverseCorrection192 (rWord niWord setR setNi)
open NttInverseCorrectionLoop192 (walk scale Image Fixed)
open NttInverseCorrectionSource192 (started walk_zero u_zero started_u started_r1 started_arrays
  started_locals setNi_outside)

theorem init_run (s : State) (a : ArrayPointer) (stride : Nat) (old : Option Value)
    (uDeclared : s.locals "u".toList=some (.uint64,old))
    (aBinding : s.arrays "a".toList=some a) (capacity : a.index≤a.count) :
    Exec NttInversePrograms192.cInit s ⟨started s a stride,.normal⟩ := by
  have assignRun : C99ModularReference.Exec NttInversePrograms192.uInit s
      ⟨bindValue s "u".toList .uint64 (.int32 0),.normal⟩ :=
    .assign _ _ _ .uint64 old (.int32 0) uDeclared (.scalar _ _ (.literal .int32 0))
  set mid : State := bindValue s "u".toList .uint64 (.int32 0) with midEq
  have midDef : mid = bindValue s "u".toList .uint64 (.uint64 (word 0)) := rfl
  have aAfter : mid.arrays "a".toList=some a := by
    rw [midEq]
    exact aBinding
  have address : Pointer mid "a".toList NttInversePrograms192.zero a :=
    StepCopyBody190.zero_pointer mid "a".toList a aAfter capacity
  have bindRun : C99ArrayReference.Exec FftLeafPrograms.program
      (.bindPtr "r1".toList "a".toList NttInversePrograms192.zero) mid
      (bindPointer mid "r1".toList a) :=
    .bindPtr _ _ _ _ _ address
  have second : C99ModularReference.Exec NttInversePrograms192.r1Init mid
      ⟨bindPointer mid "r1".toList a,.normal⟩ :=
    .base _ _ _ bindRun
  have final : bindPointer mid "r1".toList a=started s a stride := by
    simp only [started,midEq]
    rw [walk_zero]
  rw [← final]
  exact .seqNormal _ _ s mid ⟨bindPointer mid "r1".toList a,.normal⟩ assignRun second

theorem source (s : State) (a : ArrayPointer) (stride : Nat) (p p0i : BitVec 32)
    (fv : Nat → BitVec 32) (old : Option Value)
    (rDeclared : s.locals "R".toList=some (.uint32,none))
    (niDeclared : s.locals "ni".toList=some (.uint32,none))
    (uDeclared : s.locals "u".toList=some (.uint64,old))
    (pc : Slot s "p" p) (ic : Slot s "p0i" p0i) (nCell : USlot s "n" 512)
    (aBinding : s.arrays "a".toList=some a) (capacity : a.index≤a.count)
    (fixed : Fixed (started (setNi s p p0i) a stride) a stride 512 p p0i (niWord p p0i) fv)
    (image : Image (started (setNi s p p0i) a stride) a stride 512 p p0i (niWord p p0i) fv 0) :
    ∃ after, Exec NttInversePrograms192.correction s ⟨after,.normal⟩ ∧
      Fixed after a stride 512 p p0i (niWord p p0i) fv ∧
      Image after a stride 512 p p0i (niWord p p0i) fv 512 ∧
      Cell after "u".toList 512 ∧
      after.arrays "r1".toList=some (walk a 512 stride) := by
  have rRun : Exec NttInversePrograms192.rAssign s ⟨setR s p,.normal⟩ :=
    NttInverseCorrection192.r_run s p pc rDeclared
  have niRun : Exec NttInversePrograms192.niAssign (setR s p) ⟨setNi s p p0i,.normal⟩ :=
    NttInverseCorrection192.ni_run s p p0i pc ic nCell niDeclared
  have uAfter : (setNi s p p0i).locals "u".toList=some (.uint64,old) :=
    (setNi_outside s p p0i "u" (by decide) (by decide)).trans uDeclared
  have aAfter : (setNi s p p0i).arrays "a".toList=some a := aBinding
  have initRun : Exec NttInversePrograms192.cInit (setNi s p p0i)
      ⟨started (setNi s p p0i) a stride,.normal⟩ :=
    init_run (setNi s p p0i) a stride old uAfter aAfter capacity
  obtain ⟨after,loopRun,loopFixed,loopCell,loopX,loopImage,_,_⟩ :=
    NttInverseCorrectionLoop192.remaining 512 0 (started (setNi s p p0i) a stride) a stride 512
      p p0i (niWord p p0i) fv fixed (started_u _ _ _) (started_r1 _ _ _) image (by omega)
  have cLoopRun : Exec NttInversePrograms192.cLoop (setNi s p p0i) ⟨after,.normal⟩ :=
    .seqNormal _ _ (setNi s p p0i) (started (setNi s p p0i) a stride) ⟨after,.normal⟩
      initRun loopRun
  refine ⟨after,?_,loopFixed,loopImage,loopCell,loopX⟩
  exact .seqNormal _ _ s (setR s p) _ rRun
    (.seqNormal _ _ (setR s p) (setNi s p p0i) _ niRun
      (.seqNormal _ _ (setNi s p p0i) after _ cLoopRun (.base _ _ _ (.skip _))))

end FT1536.Source3.NttInverseCorrectionInit192
