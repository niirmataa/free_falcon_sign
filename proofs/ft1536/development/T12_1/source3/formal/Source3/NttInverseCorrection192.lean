import Source3.NttInversePrologue192
import Source3.ModpDivTotal178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Exact word assignments of the corrective scaling section of the
   accepted modp_iNTT3_ext corpus: R = modp_R(p) and
   ni = modp_div(R, (uint32_t)n, p, p0i, R). The values are only the
   executed pinned leaf/composite bodies (KeygenModpR, ModpDivTotal178);
   no inverse or divisibility property is assumed. -/
namespace FT1536.Source3.NttInverseCorrection192
open C99ArrayReference (State Name)
open C99ModularReference (Exec)
open C99IntegerReference (Value)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)

def rWord (p : BitVec 32) : BitVec 32 := KeygenModpR.word p
def niWord (p p0i : BitVec 32) : BitVec 32 :=
  ModpDivTotal178.word (KeygenModpR.word p) 512 p p0i (KeygenModpR.word p)

def setR (s : State) (p : BitVec 32) : State := ModularAtoms178.set s "R" (rWord p)
def setNi (s : State) (p p0i : BitVec 32) : State := ModularAtoms178.set (setR s p) "ni" (niWord p p0i)

theorem r_slot (s : State) (p : BitVec 32) : Slot (setR s p) "R" (rWord p) :=
  ModularAtoms178.slot s "R" (rWord p)

theorem ni_slot (s : State) (p p0i : BitVec 32) : Slot (setNi s p p0i) "ni" (niWord p p0i) :=
  ModularAtoms178.slot (setR s p) "ni" (niWord p p0i)

theorem r_run (s : State) (p : BitVec 32) (pc : Slot s "p" p)
    (declared : s.locals "R".toList=some (.uint32,none)) :
    Exec NttInversePrograms192.rAssign s ⟨setR s p,.normal⟩ :=
  .assign _ _ _ .uint32 none (.uint32 (rWord p)) declared
    (.call1 "modp_R".toList _ (.uint32 p) (.uint32 (rWord p))
      (ModularAtoms178.cell s "p" p pc) (.r _ _ (KeygenModpR.source_exists p)))

theorem ni_run (s : State) (p p0i : BitVec 32) (pc : Slot s "p" p) (ic : Slot s "p0i" p0i)
    (nCell : USlot s "n" 512) (declared : s.locals "ni".toList=some (.uint32,none)) :
    Exec NttInversePrograms192.niAssign (setR s p) ⟨setNi s p p0i,.normal⟩ := by
  have declaredAfter : (setR s p).locals "ni".toList=some (.uint32,none) :=
    (ModularAtoms178.outside s "R" "ni" (rWord p) (by decide)).trans declared
  have pKeep : Slot (setR s p) "p" p :=
    (ModularAtoms178.outside s "R" "p" (rWord p) (by decide)).trans pc
  have iKeep : Slot (setR s p) "p0i" p0i :=
    (ModularAtoms178.outside s "R" "p0i" (rWord p) (by decide)).trans ic
  have nKeep : USlot (setR s p) "n" 512 :=
    (ModularAtoms178.outside s "R" "n" (rWord p) (by decide)).trans nCell
  have rEval : C99ModularReference.Eval (setR s p)
      (NttInversePrograms192.scalar (NttInversePrograms192.var "R")) (.uint32 (rWord p)) :=
    .scalar _ _ (.variable _ _ _ (r_slot s p))
  have nEval : C99ModularReference.Eval (setR s p)
      (NttInversePrograms192.scalar (.cast .u32 (NttInversePrograms192.var "n"))) (.uint32 512) :=
    .scalar _ _ (.cast .uint32 _ (KeygenNttLoopSupport.u64 512)
      (.variable _ _ _ nKeep))
  have pEval : C99ModularReference.Eval (setR s p)
      (NttInversePrograms192.scalar (NttInversePrograms192.var "p")) (.uint32 p) :=
    .scalar _ _ (.variable _ _ _ pKeep)
  have iEval : C99ModularReference.Eval (setR s p)
      (NttInversePrograms192.scalar (NttInversePrograms192.var "p0i")) (.uint32 p0i) :=
    .scalar _ _ (.variable _ _ _ iKeep)
  exact .assign _ _ _ .uint32 none (.uint32 (niWord p p0i)) declaredAfter
    (.call5 "modp_div".toList _ _ _ _ _ (.uint32 (rWord p)) (.uint32 512) (.uint32 p)
      (.uint32 p0i) (.uint32 (rWord p)) (.uint32 (niWord p p0i)) rEval nEval pEval iEval rEval
      (.div _ _ (ModpDivTotal178.source_exists s (rWord p) 512 p p0i (rWord p))))

end FT1536.Source3.NttInverseCorrection192
