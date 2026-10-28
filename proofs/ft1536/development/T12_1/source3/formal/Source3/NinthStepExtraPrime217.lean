import Source3.NinthStepProduct217

set_option maxRecDepth 262144
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The generic additional-prime row prefix of the d=2 part-2 loop body
   (MakeFgAddPrimeShape194.prefixSteps at any loop index u whose
   PRIMES3 row is v): the p/p0i/R2/Rx declarations and the v/x binds,
   the block table read p = primes[u].p, the executed-word calls
   p0i = modp_ninv31(p), R2 = modp_R2(p, p0i) and the new Rx =
   modp_Rx(slen = 166, p, p0i, R2) of this section. All words stay
   executed words of the actual source bodies; no table or arithmetic
   law is claimed. -/
namespace FT1536.Source3.NinthStepExtraPrime217
open C99ArrayReference (State Name)
open C99LoopScalar141 (Cell)
open KeygenModpR2Exec (Slot)
open CrtState205 (set32)
open KeygenStaticTables (values)
open NinthStepGenerator217 (Basic Outer rxVal)
open CrtPrimePrefix214 (pVal sVal iVal rVal)
open KeygenMakeFgSource (Exec)

def withX (s : State) := SelectedStepAddPrime195.withX s
def withP (s : State) (v : Nat×Nat×Nat) := set32 (withX s) "p" (pVal v)
def withI (s : State) (v : Nat×Nat×Nat) := set32 (withP s v) "p0i" (iVal v)
def withR (s : State) (v : Nat×Nat×Nat) := set32 (withI s v) "R2" (rVal v)
def after (s : State) (v : Nat×Nat×Nat) := set32 (withR s v) "Rx" (rxVal v)

theorem declared_locals (s : State) (name : Name) (absent : name∉MakeFgAddPrimeShape194.localNames) :
    (withX s).locals name=s.locals name := by
  have noWords : name∉["p".toList,"p0i".toList,"R2".toList,"Rx".toList] := fun member =>
    absent (List.mem_append_left ["v".toList] member)
  have nv : name≠"v".toList := by
    intro eq; apply absent; rw [eq]; decide
  exact (ZintSubWord194.effect_one_other .u64 "v".toList name (SelectedStepAddPrime195.withWords s) nv).trans
    (SelectedStepAddPrime195.effect_locals .u32 ["p".toList,"p0i".toList,"R2".toList,"Rx".toList] s name noWords)

theorem arrays (s : State) (name : Name) (nx : name≠"x".toList) : (after s v).arrays name=s.arrays name :=
  SelectedStepAddPrime195.clear_arrays (SelectedStepAddPrime195.withV s) "x".toList name nx

theorem locals (s : State) (v : Nat×Nat×Nat) (name : Name) (absent : name∉MakeFgAddPrimeShape194.localNames) :
    (after s v).locals name=s.locals name := by
  have ne (word : String) (member : word.toList∈MakeFgAddPrimeShape194.localNames) : name≠word.toList := by
    intro eq; apply absent; rw [eq]; exact member
  exact (SelectedStepAddPrime195.locals_keep (withR s v) "Rx".toList .uint32 (.uint32 (rxVal v)) name (ne "Rx" (by decide))).trans
    ((SelectedStepAddPrime195.locals_keep (withI s v) "R2".toList .uint32 (.uint32 (rVal v)) name (ne "R2" (by decide))).trans
      ((SelectedStepAddPrime195.locals_keep (withP s v) "p0i".toList .uint32 (.uint32 (iVal v)) name (ne "p0i" (by decide))).trans
        ((SelectedStepAddPrime195.locals_keep (withX s) "p".toList .uint32 (.uint32 (pVal v)) name (ne "p" (by decide))).trans
          (declared_locals s name absent))))

theorem p_cell (s : State) (v : Nat×Nat×Nat) : Slot (after s v) "p" (pVal v) :=
  (CrtState205.keep32 (withR s v) "Rx" "p" (rxVal v) (by decide)).trans
    ((CrtState205.keep32 (withI s v) "R2" "p" (rVal v) (by decide)).trans
      ((CrtState205.keep32 (withP s v) "p0i" "p" (iVal v) (by decide)).trans (CrtState205.cell32 _ _ _)))

theorem i_cell (s : State) (v : Nat×Nat×Nat) : Slot (after s v) "p0i" (iVal v) :=
  (CrtState205.keep32 (withR s v) "Rx" "p0i" (rxVal v) (by decide)).trans
    ((CrtState205.keep32 (withI s v) "R2" "p0i" (rVal v) (by decide)).trans (CrtState205.cell32 _ _ _))

theorem r_cell (s : State) (v : Nat×Nat×Nat) : Slot (after s v) "R2" (rVal v) :=
  (CrtState205.keep32 (withR s v) "Rx" "R2" (rxVal v) (by decide)).trans (CrtState205.cell32 _ _ _)

theorem rx_cell (s : State) (v : Nat×Nat×Nat) : Slot (after s v) "Rx" (rxVal v) := CrtState205.cell32 _ _ _

theorem u_cell (s : State) (u : Nat) (v : Nat×Nat×Nat) (input : CrtPrimePrefix214.Input s u v) :
    Cell (withX s) "u".toList u :=
  (declared_locals s "u".toList (by decide)).trans input.uCell

/- The seven-statement prefix executed at loop index u and row v. -/
theorem source (s : State) (u : Nat) (v : Nat×Nat×Nat) (h : Outer s u)
    (input : CrtPrimePrefix214.Input s u v)
    (tail : KeygenMakeFgSource.Stmt) (out : C99ProcedureReference.Result)
    (rest : Exec tail (after s v) out) :
    Exec (MakeFgSequence187.append MakeFgAddPrimeShape194.prefixSteps tail) s out := by
  have uD : Cell (withX s) "u".toList u := u_cell s u v input
  have pRead : KeygenLevelCalls.PrimeRead (withX s) "primes".toList (.var "u".toList) .p
      (.uint32 (pVal v)) :=
    CrtPrimePrefix214.primeRead s u v input .p (withX s)
      (SelectedStepAddPrime195.withX_primes s input.primesBinding) uD rfl
  have pRun : Exec MakeFgAddPrimeShape194.pSet (withX s) ⟨withP s v,.normal⟩ :=
    .level _ _ _ (.prime _ _ _ _ _ .uint32 none (.uint32 (pVal v)) rfl pRead)
  have iRun : Exec MakeFgAddPrimeShape194.iSet (withP s v) ⟨withI s v,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (ModularAtoms178.assign _ "p0i" none _ (iVal v) rfl
      (.call1 _ _ _ _ (ModularAtoms178.cell _ "p" (pVal v) (CrtState205.cell32 _ _ _))
        (.inverse _ _ (KeygenNinv31.source_exists (pVal v))))))
  have pI : Slot (withI s v) "p" (pVal v) :=
    (CrtState205.keep32 (withP s v) "p0i" "p" (iVal v) (by decide)).trans (CrtState205.cell32 _ _ _)
  have rRun : Exec MakeFgAddPrimeShape194.rSet (withI s v) ⟨withR s v,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (ModularAtoms178.assign _ "R2" none _ (rVal v) rfl
      (.call2 _ _ _ _ _ _ (ModularAtoms178.cell _ "p" (pVal v) pI)
        (ModularAtoms178.cell _ "p0i" (iVal v) (CrtState205.cell32 _ _ _))
        (.r2 _ _ (KeygenModpR2Exec.source_exists (withI s v) (pVal v) (iVal v))))))
  have slenR : Cell (withR s v) "slen".toList 166 :=
    (CrtState205.keep32 (withI s v) "R2" "slen" (rVal v) (by decide)).trans
      ((CrtState205.keep32 (withP s v) "p0i" "slen" (iVal v) (by decide)).trans
        ((CrtState205.keep32 (withX s) "p" "slen" (pVal v) (by decide)).trans
          ((declared_locals s "slen".toList (by decide)).trans h.slenCell)))
  have pR : Slot (withR s v) "p" (pVal v) :=
    (CrtState205.keep32 (withI s v) "R2" "p" (rVal v) (by decide)).trans pI
  have iR : Slot (withR s v) "p0i" (iVal v) :=
    (CrtState205.keep32 (withI s v) "R2" "p0i" (rVal v) (by decide)).trans (CrtState205.cell32 _ _ _)
  have rxRun : Exec MakeFgAddPrimeShape194.rxSet (withR s v) ⟨after s v,.normal⟩ :=
    RxSection210.source (withR s v) 166 (pVal v) (iVal v) (rVal v) none (by decide) (by decide)
      slenR pR iR (CrtState205.cell32 _ _ _) rfl
  exact MakeFgSequence187.source [MakeFgAddPrimeShape194.declP,MakeFgAddPrimeShape194.declV,MakeFgAddPrimeShape194.declX]
    s (withX s) (SelectedStepAddPrime195.decls_run s) _ out
    (.seqNormal _ _ _ _ _ pRun (.seqNormal _ _ _ _ _ iRun (.seqNormal _ _ _ _ _ rRun (.seqNormal _ _ _ _ _ rxRun rest))))

theorem basic (s : State) (u : Nat) (v : Nat×Nat×Nat) (h : Outer s u) :
    Basic (after s v) u (pVal v) (iVal v) (rVal v) := by
  refine ⟨(locals _ _ _ (by decide)).trans h.nCell,(locals _ _ _ (by decide)).trans h.hnCell,
    (locals _ _ _ (by decide)).trans h.slenCell,(locals _ _ _ (by decide)).trans h.tlenCell,
    (locals _ _ _ (by decide)).trans h.uCell,p_cell s v,i_cell s v,r_cell s v,
    (locals _ _ _ (by decide)).trans h.lognCell,(locals _ _ _ (by decide)).trans h.terCell,
    (locals _ _ _ (by decide)).trans h.inCell,(locals _ _ _ (by decide)).trans h.outCell,
    (arrays _ _ (by decide)).trans h.fdBinding,(arrays _ _ (by decide)).trans h.gdBinding,
    (arrays _ _ (by decide)).trans h.fsBinding,(arrays _ _ (by decide)).trans h.gsBinding,
    (arrays _ _ (by decide)).trans h.gmBinding,(arrays _ _ (by decide)).trans h.igmBinding,
    (arrays _ _ (by decide)).trans h.t1Binding,(arrays _ _ (by decide)).trans h.primesBinding,h.writable,h.allocated⟩

end FT1536.Source3.NinthStepExtraPrime217
