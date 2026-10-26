import Source3.SecondStepStatics204

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepPrimeOne204
open C99ArrayReference (State Name bindValue)
open C99MemoryReference (Load32)
open KeygenMakeFgSource (Exec)
open KeygenFullData127 (primes)
open SelectedStepAddPrime195 (p1 p0i1 r21 primes1)
open SecondStepOuter204 (Outer)
open SecondStepBasic203 (Basic)
open SelectedStepAddPrime195 (locals_keep)

def declared (s : State) := StepPrimeDeclarations188.after s
def withP (s : State) := bindValue (declared s) "p".toList .uint32 (.uint32 p1)
def withI (s : State) := bindValue (withP s) "p0i".toList .uint32 (.uint32 p0i1)
def after (s : State) := bindValue (withI s) "R2".toList .uint32 (.uint32 r21)

theorem declared_heap (s : State) : (declared s).heap=s.heap := rfl
theorem heap (s : State) : (after s).heap=s.heap := rfl

theorem declared_arrays (s : State) (name : Name) (different : name≠"x".toList) :
    (declared s).arrays name=s.arrays name := by
  change (if name="x".toList then none else s.arrays name)=s.arrays name
  simp only [different,ite_false]

theorem arrays (s : State) (name : Name) (different : name≠"x".toList) : (after s).arrays name=s.arrays name :=
  declared_arrays s name different

theorem not_private (name : Name) (absent : name∉StepPrimeShape188.localNames) (word : String)
    (member : word.toList∈StepPrimeShape188.localNames) : name≠word.toList := by
  intro same
  apply absent
  rw [same]
  exact member

theorem declared_locals (s : State) (name : Name) (absent : name∉StepPrimeShape188.localNames) :
    (declared s).locals name=s.locals name := by
  have subset : ["p".toList,"p0i".toList,"R2".toList] ⊆ StepPrimeShape188.localNames := by decide
  have first := SelectedStepAddPrime195.effect_locals .u32 ["p".toList,"p0i".toList,"R2".toList] s name
    (fun member => absent (subset member))
  have second := SelectedStepAddPrime195.effect_locals .u64 ["v".toList] (StepPrimeDeclarations188.withWords s) name
    (by simpa only [List.mem_singleton] using not_private name absent "v" (by decide))
  exact second.trans first

theorem locals (s : State) (name : Name) (absent : name∉StepPrimeShape188.localNames) :
    (after s).locals name=s.locals name :=
  (locals_keep (withI s) "R2".toList .uint32 (.uint32 r21) name (not_private name absent "R2" (by decide))).trans
    ((locals_keep (withP s) "p0i".toList .uint32 (.uint32 p0i1) name (not_private name absent "p0i" (by decide))).trans
      ((locals_keep (declared s) "p".toList .uint32 (.uint32 p1) name (not_private name absent "p" (by decide))).trans
        (declared_locals s name absent)))

theorem p_cell (s : State) : KeygenModpR2Exec.Slot (after s) "p" p1 :=
  (locals_keep (withI s) "R2".toList .uint32 (.uint32 r21) "p".toList (by decide)).trans
    ((locals_keep (withP s) "p0i".toList .uint32 (.uint32 p0i1) "p".toList (by decide)).trans
      (ModularAtoms178.slot (declared s) "p" p1))
theorem i_cell (s : State) : KeygenModpR2Exec.Slot (after s) "p0i" p0i1 :=
  (locals_keep (withI s) "R2".toList .uint32 (.uint32 r21) "p0i".toList (by decide)).trans
    (ModularAtoms178.slot (withP s) "p0i" p0i1)
theorem r2_cell (s : State) : KeygenModpR2Exec.Slot (after s) "R2" r21 := ModularAtoms178.slot (withI s) "R2" r21

theorem v_declared (s : State) : (after s).locals "v".toList=some (.uint64,none) :=
  (locals_keep (withI s) "R2".toList .uint32 (.uint32 r21) "v".toList (by decide)).trans
    ((locals_keep (withP s) "p0i".toList .uint32 (.uint32 p0i1) "v".toList (by decide)).trans
      ((locals_keep (declared s) "p".toList .uint32 (.uint32 p1) "v".toList (by decide)).trans rfl))

theorem p_read (s : State) (h : Outer s 1) (object : KeygenStaticTables.PrimeObject s.heap primes .ternary) :
    KeygenLevelCalls.PrimeRead (declared s) "primes".toList (FirstStepEntry187.var "u") .p (.uint32 p1) :=
  .read primes1 p1
    (.add _ _ primes primes1 (.uint64 1) ((declared_arrays s "primes".toList (by decide)).trans h.primesBinding)
      (.variable _ _ _ ((declared_locals s "u".toList (by decide)).trans h.uCell)) (by decide)
      (.within primes 1 (by decide))) SelectedStepAddPrime195.primes1_width SelectedStepAddPrime195.primes1_extent
    (by rw [SelectedStepAddPrime195.fieldPointer_one,declared_heap]; exact SelectedStepAddPrime195.object_word s object)

theorem p_source (s : State) (h : Outer s 1) (object : KeygenStaticTables.PrimeObject s.heap primes .ternary) :
    Exec StepPrimeShape188.pSet (declared s) ⟨withP s,.normal⟩ :=
  .level _ _ _ (.prime _ _ _ _ _ .uint32 none (.uint32 p1) rfl (p_read s h object))

theorem i_source (s : State) : Exec StepPrimeShape188.iSet (withP s) ⟨withI s,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (ModularAtoms178.assign (withP s) "p0i" none _ p0i1 rfl
    (.call1 _ _ _ _ (ModularAtoms178.cell (withP s) "p" p1 (ModularAtoms178.slot (declared s) "p" p1))
      (.inverse _ _ (KeygenNinv31.source_exists p1)))))

theorem r_source (s : State) : Exec StepPrimeShape188.rSet (withI s) ⟨after s,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (ModularAtoms178.assign (withI s) "R2" none _ r21 rfl
    (.call2 _ _ _ _ _ _ (ModularAtoms178.cell (withI s) "p" p1
      ((locals_keep (withP s) "p0i".toList .uint32 (.uint32 p0i1) "p".toList (by decide)).trans
        (ModularAtoms178.slot (declared s) "p" p1)))
      (ModularAtoms178.cell (withI s) "p0i" p0i1 (ModularAtoms178.slot (withP s) "p0i" p0i1))
      (.r2 _ _ (KeygenModpR2Exec.source_exists (withI s) p1 p0i1)))))

theorem append_source (s : State) (h : Outer s 1) (object : KeygenStaticTables.PrimeObject s.heap primes .ternary)
    (tail : KeygenMakeFgSource.Stmt) (out : C99ProcedureReference.Result) (rest : Exec tail (after s) out) :
    Exec (MakeFgSequence187.append StepPrimeShape188.prefixSteps tail) s out :=
  MakeFgSequence187.source StepPrimeShape188.declarations s (declared s) (StepPrimeDeclarations188.source s)
    (.seq StepPrimeShape188.pSet (.seq StepPrimeShape188.iSet (.seq StepPrimeShape188.rSet tail))) out
    (.seqNormal _ _ _ (withP s) _ (p_source s h object)
      (.seqNormal _ _ _ (withI s) _ (i_source s) (.seqNormal _ _ _ (after s) _ (r_source s) rest)))

theorem source (s : State) (h : Outer s 1) (object : KeygenStaticTables.PrimeObject s.heap primes .ternary) :
    Exec (MakeFgSequence187.append StepPrimeShape188.prefixSteps KeygenMakeFgSource.skip) s ⟨after s,.normal⟩ :=
  append_source s h object _ _ (SelectedStepAddPrime195.skip_run _)

theorem basic (s : State) (h : Outer s 1) : Basic (after s) 1 p1 p0i1 r21 := by
  refine ⟨(locals _ _ (by decide)).trans h.nCell,(locals _ _ (by decide)).trans h.hnCell,
    (locals _ _ (by decide)).trans h.slenCell,(locals _ _ (by decide)).trans h.tlenCell,
    (locals _ _ (by decide)).trans h.uCell,p_cell s,i_cell s,r2_cell s,
    (locals _ _ (by decide)).trans h.lognCell,(locals _ _ (by decide)).trans h.terCell,
    (locals _ _ (by decide)).trans h.inCell,(locals _ _ (by decide)).trans h.outCell,
    (arrays _ _ (by decide)).trans h.fdBinding,(arrays _ _ (by decide)).trans h.gdBinding,
    (arrays _ _ (by decide)).trans h.fsBinding,(arrays _ _ (by decide)).trans h.gsBinding,
    (arrays _ _ (by decide)).trans h.gmBinding,(arrays _ _ (by decide)).trans h.igmBinding,
    (arrays _ _ (by decide)).trans h.t1Binding,(arrays _ _ (by decide)).trans h.primesBinding,?_,?_⟩
  · rw [heap]; exact h.writable
  · intro index bound; rw [heap]; exact h.allocated index bound

end FT1536.Source3.SecondStepPrimeOne204
