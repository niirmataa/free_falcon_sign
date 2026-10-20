import Run2.FinishResources

namespace FT1536.Run2.ResourceReduction
open Games FT1536.Relation LocalMachineCode FT1536.BitCost
open MachineAccounting MeteredExecution FinishResources StateResources

/- A closed executable family, not an arbitrary output function paired
with an asserted price. The only variable code is the finite local A/S
syntax; all public procedures and all resource annotations are fixed by
MeteredExecution/FinishResources. No global cost or advantage premise is
stored in these local certificates. -/
structure Implementation (beta : Budget) where
  adversary : ClassicalAdversary beta
  sampler : Sampler
  adversaryCode : AdversaryCertificate beta adversary
  samplerCode : SamplerCertificate beta sampler

def static (beta : Budget) (I : Implementation beta) : ℕ :=
  staticBits beta (aCode beta I.adversary I.adversaryCode) (sCode beta I.sampler I.samplerCode)

/- Initial file loading pays sixteen operations per stored bit, including
both local literal codes, public arithmetic code, all QH+1 targets and h.
Coin generation has its own charged fair-bit port. -/
def initialCost (beta : Budget) (I : Implementation beta) : Cost :=
  plus ⟨16*static beta I+1,static beta I,static beta I⟩ (drawCost beta.coinBits)
def noneCost : Cost := transport [false]

def terminal (beta : Budget) (I : Implementation beta) (h : Rq) (cs : List Rq) :
    Option Finished → Option FileWitness × Cost
  | none => (none,held (static beta I) noneCost)
  | some f => (fileFinish h cs f,held (static beta I+stateBits f.state) (finalCost h cs f))

def terminalBound (beta : Budget) (I : Implementation beta) : Cost :=
  held (static beta I+SamplerMachine.stateCap beta) (plus noneCost (finalBound beta))

theorem terminal_correct (beta : Budget) (I : Implementation beta) (h : Rq) (cs : List Rq)
    (out : Option Finished) : (terminal beta I h cs out).1.map FileWitness.meaning=finishSim h cs out := by
  cases out with
  | none => rfl
  | some f => exact (fileFinish_correct h cs f).trans (BitFinish.finish_correct h cs (some f))

theorem terminal_bound (beta : Budget) (I : Implementation beta) (h : Rq)
    (cs : List.Vector Rq (beta.qh+1)) (out : Option Finished)
    (hv : PrefixResources.ValidFinished beta cs.val out) :
    (terminal beta I h cs.val out).2≤terminalBound beta I := by
  cases out with
  | none =>
    change _≤_ ∧ _≤_ ∧ _≤_
    dsimp only [terminal,terminalBound,held,plus]
    omega
  | some f =>
    rcases finalCost_bound beta h cs f hv with ⟨ht,hw,hL⟩
    have hs:=state_cap beta cs f.state (beta.qs+beta.qh) hv.1 hv.2.1 (by omega)
    change _≤_ ∧ _≤_ ∧ _≤_
    dsimp only [terminal,terminalBound,held,plus]
    omega

noncomputable def run (beta : Budget) (I : Implementation beta) (h : Rq)
    (cs : List.Vector Rq (beta.qh+1)) : Dist (Option FileWitness × Cost) :=
  (Dist.draw (Law.uniform : Law (Fin beta.coinBits → Bool))).bind fun coins =>
    (MeteredExecution.run beta I.adversary I.sampler I.adversaryCode I.samplerCode h cs.val coins
      (beta.qs+beta.qh+1) initial).map fun out =>
        let last:=terminal beta I h cs.val out.1
        (last.1,seq (initialCost beta I) (seq out.2 last.2))

def resourceBound (beta : Budget) (I : Implementation beta) : Cost :=
  seq (initialCost beta I)
    (seq (repeatBound (beta.qs+beta.qh+1) (turnBound beta I.adversary I.sampler I.adversaryCode I.samplerCode))
      (terminalBound beta I))

theorem run_resources (beta : Budget) (I : Implementation beta) (h : Rq)
    (cs : List.Vector Rq (beta.qh+1)) :
    Dist.All (run beta I h cs) (fun out => out.2≤resourceBound beta I) := by
  unfold run
  apply Dist.all_bind _ _ (fun _ => True)
  · intro u; trivial
  · intro coins _
    have hh:=PrefixResources.execution_bound beta I.adversary I.sampler I.adversaryCode I.samplerCode
      h cs coins (I.adversary.code h coins) initial 0 (beta.qs+beta.qh+1)
      (initial_shape beta.bytes) (initial_good cs.val) (by omega) (by omega) .initial
    intro u
    have hv:=hh u
    exact seq_mono (cost_refl _) (seq_mono hv.1 (terminal_bound beta I h cs _ hv.2))

theorem run_binding (beta : Budget) (I : Implementation beta) (h : Rq)
    (cs : List.Vector Rq (beta.qh+1)) :
    Dist.Same ((run beta I h cs).map (fun out => out.1.map FileWitness.meaning))
      ((Reduction.build beta I.adversary I.sampler).code h cs) := by
  intro F
  simp only [run,Reduction.build,Dist.expect_map,Dist.expect_bind]
  apply Dist.expect_congr
  intro coins
  simp only [terminal_correct]
  have he:=MeteredExecution.erasure beta I.adversary I.sampler I.adversaryCode I.samplerCode
    h cs.val coins (beta.qs+beta.qh+1) initial
  have hb:=MachineExecution.run_binding beta I.adversary I.sampler I.adversaryCode I.samplerCode
    h cs coins (I.adversary.code h coins) initial 0 (beta.qs+beta.qh+1)
    (initial_shape beta.bytes) (initial_good cs.val) (by omega) (by omega) .initial
  exact Dist.same_trans he hb (fun out => F (finishSim h cs.val out))

/- Worst-case maxima, over all public inputs and all execution tapes,
including zero-mass paths. Taking this maximum is a specification, never
a runtime enumeration of the challenge or key domain. -/
noncomputable def allRuns (beta : Budget) (I : Implementation beta) : Dist (Option FileWitness × Cost) :=
  (Dist.draw (Law.uniform : Law Rq)).bind fun h =>
    (Dist.draw (Law.uniform : Law (List.Vector Rq (beta.qh+1)))).bind fun cs => run beta I h cs

noncomputable def Resources (beta : Budget) (I : Implementation beta) : Cost :=
  let d:=allRuns beta I
  ⟨Finset.univ.sup (fun tape => (d.out tape).2.t),
    Finset.univ.sup (fun tape => (d.out tape).2.w),
    Finset.univ.sup (fun tape => (d.out tape).2.L)⟩

theorem resources_bound (beta : Budget) (I : Implementation beta) : Resources beta I≤resourceBound beta I := by
  have hh : Dist.All (allRuns beta I) (fun out => out.2≤resourceBound beta I) := by
    unfold allRuns
    apply Dist.all_bind _ _ (fun _ => True)
    · intro u; trivial
    · intro h _
      apply Dist.all_bind _ _ (fun _ => True)
      · intro u; trivial
      · intro cs _; exact run_resources beta I h cs
  refine ⟨Finset.sup_le ?_,Finset.sup_le ?_,Finset.sup_le ?_⟩
  · intro tape _; exact (hh tape).1
  · intro tape _; exact (hh tape).2.1
  · intro tape _; exact (hh tape).2.2

def Denotes (beta : Budget) (I : Implementation beta) (B : MTAdversary (beta.qh+1)) : Prop :=
  ∀ h cs,Dist.Same ((run beta I h cs).map (fun out => out.1.map FileWitness.meaning)) (B.code h cs)

/- MTAdversary is a semantic law, so it has no intrinsic running time.
ResourceRealization attaches an actual member of the fixed executable
family, its proved law binding and the maxima of its measured execution.
This is a CONCLUSION below, not a local certificate assumption. -/
def ResourceRealization (beta : Budget) (B : MTAdversary (beta.qh+1)) (cap : Cost) : Prop :=
  ∃ I : Implementation beta,Denotes beta I B ∧ Resources beta I≤cap

theorem concrete_resource_realization (beta : Budget) (I : Implementation beta) :
    ResourceRealization beta (Reduction.build beta I.adversary I.sampler) (resourceBound beta I) :=
  ⟨I,run_binding beta I,resources_bound beta I⟩

theorem exists_resource_bounded_concrete_reducer {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK×Rq)) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S)
    (e : ℝ) (law : LocalJointCertificate S e) :
    ∃ B : MTAdversary (beta.qh+1),B=Reduction.build beta A S ∧
      ResourceRealization beta B (resourceBound beta ⟨A,S,ac,sc⟩) ∧
      AdvEUF beta muKey A≤min 1 (StoppingLoss.epsColl beta+
        EventTransfer.phi ((1+e)^beta.qs-1) (AdvMT (beta.qh+1) (SigmaMath.muH muKey) B)) := by
  exact ⟨Reduction.build beta A S,rfl,concrete_resource_realization beta ⟨A,S,ac,sc⟩,
    concrete_euf_cma_to_mt_isis beta muKey A S e law⟩

theorem resource_hardness_substitution {SK : Type} [Fintype SK]
    (beta : Budget) (muKey : Law (SK×Rq)) (A : ClassicalAdversary beta) (S : Sampler)
    (ac : AdversaryCertificate beta A) (sc : SamplerCertificate beta S)
    (e epsilon : ℝ) (law : LocalJointCertificate S e) (hepsilon : epsilon≤1)
    (hardness : ∀ B : MTAdversary (beta.qh+1),
      ResourceRealization beta B (resourceBound beta ⟨A,S,ac,sc⟩) →
      AdvMT (beta.qh+1) (SigmaMath.muH muKey) B≤epsilon) :
    AdvEUF beta muKey A≤min 1 (StoppingLoss.epsColl beta+EventTransfer.phi ((1+e)^beta.qs-1) epsilon) :=
  concrete_hardness_substitution beta muKey A S e epsilon law hepsilon
    (hardness _ (concrete_resource_realization beta ⟨A,S,ac,sc⟩))

end FT1536.Run2.ResourceReduction

#print FT1536.Run2.ResourceReduction.Resources
#print FT1536.Run2.ResourceReduction.ResourceRealization
#print FT1536.Run2.ResourceReduction.exists_resource_bounded_concrete_reducer
#print FT1536.Run2.ResourceReduction.resource_hardness_substitution
#print axioms FT1536.Run2.ResourceReduction.resources_bound
#print axioms FT1536.Run2.ResourceReduction.run_binding
#print axioms FT1536.Run2.ResourceReduction.exists_resource_bounded_concrete_reducer
#print axioms FT1536.Run2.ResourceReduction.resource_hardness_substitution
