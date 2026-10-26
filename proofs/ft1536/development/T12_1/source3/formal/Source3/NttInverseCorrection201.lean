import Source3.NttInverseLoop201

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttInverseCorrection201
open C99ArrayReference (State)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open MkgmParams198 (Level)
open NttInverseSchedule201 (size)
open NttInverseCorrection192 (rWord setR r_slot r_run)

def numberWord (l : Level) : BitVec 32 := BitVec.ofNat 32 (size l)
def niWord (l : Level) (p p0i : BitVec 32) := ModpDivTotal178.word (rWord p) (numberWord l) p p0i (rWord p)
def setNi (l : Level) (s : State) (p p0i : BitVec 32) := ModularAtoms178.set (setR s p) "ni" (niWord l p p0i)

theorem ni_slot (l : Level) (s : State) (p p0i : BitVec 32) : Slot (setNi l s p p0i) "ni" (niWord l p p0i) :=
  ModularAtoms178.slot (setR s p) "ni" (niWord l p p0i)

theorem cast_n (l : Level) : C99IntegerReference.convert .uint32
    (KeygenNttLoopSupport.u64 (size l)).integer=.uint32 (numberWord l) := by
  fin_cases l <;> rfl

theorem ni_run (l : Level) (s : State) (p p0i : BitVec 32) (pc : Slot s "p" p) (ic : Slot s "p0i" p0i)
    (nCell : USlot s "n" (size l)) (declared : s.locals "ni".toList=some (.uint32,none)) :
    Exec NttInversePrograms192.niAssign (setR s p) ⟨setNi l s p p0i,.normal⟩ := by
  have declaredAfter : (setR s p).locals "ni".toList=some (.uint32,none) :=
    (ModularAtoms178.outside s "R" "ni" (rWord p) (by decide)).trans declared
  have pKeep : Slot (setR s p) "p" p :=
    (ModularAtoms178.outside s "R" "p" (rWord p) (by decide)).trans pc
  have iKeep : Slot (setR s p) "p0i" p0i :=
    (ModularAtoms178.outside s "R" "p0i" (rWord p) (by decide)).trans ic
  have nKeep : USlot (setR s p) "n" (size l) :=
    (ModularAtoms178.outside s "R" "n" (rWord p) (by decide)).trans nCell
  have rEval : C99ModularReference.Eval (setR s p)
      (NttInversePrograms192.scalar (NttInversePrograms192.var "R")) (.uint32 (rWord p)) :=
    .scalar _ _ (.variable _ _ _ (r_slot s p))
  have nEval : C99ModularReference.Eval (setR s p)
      (NttInversePrograms192.scalar (.cast .u32 (NttInversePrograms192.var "n"))) (.uint32 (numberWord l)) := by
    have value := (show C99ArrayReference.scalar (setR s p) (.cast .u32 (NttInversePrograms192.var "n"))
      (C99IntegerReference.convert .uint32 (KeygenNttLoopSupport.u64 (size l)).integer) from
        .cast .uint32 _ (KeygenNttLoopSupport.u64 (size l)) (.variable _ _ _ nKeep))
    rw [cast_n l] at value
    exact .scalar _ _ value
  have pEval : C99ModularReference.Eval (setR s p)
      (NttInversePrograms192.scalar (NttInversePrograms192.var "p")) (.uint32 p) :=
    .scalar _ _ (.variable _ _ _ pKeep)
  have iEval : C99ModularReference.Eval (setR s p)
      (NttInversePrograms192.scalar (NttInversePrograms192.var "p0i")) (.uint32 p0i) :=
    .scalar _ _ (.variable _ _ _ iKeep)
  exact .assign _ _ _ .uint32 none (.uint32 (niWord l p p0i)) declaredAfter
    (.call5 "modp_div".toList _ _ _ _ _ (.uint32 (rWord p)) (.uint32 (numberWord l)) (.uint32 p)
      (.uint32 p0i) (.uint32 (rWord p)) (.uint32 (niWord l p p0i)) rEval nEval pEval iEval rEval
      (.div _ _ (ModpDivTotal178.source_exists s (rWord p) (numberWord l) p p0i (rWord p))))

end FT1536.Source3.NttInverseCorrection201
