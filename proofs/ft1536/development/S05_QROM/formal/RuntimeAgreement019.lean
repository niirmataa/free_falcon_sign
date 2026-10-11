import StandaloneRuntime019
import LegacyPairWitness019

set_option maxRecDepth 8192
namespace FT1536.S05.RuntimeAgreement019
open FT1536.Relation
namespace R
abbrev T := StandaloneRuntime019.Tables
end R

def oldTables (t : R.T) : SamplerCode016.Tables := ⟨t.cdf,t.threshold⟩

theorem value_eq (n : ℕ) (tape : JointInterface019.Bits n) :
    StandaloneRuntime019.value n tape=BitTapes016.value n tape := by
  induction n with
  | zero => rfl
  | succ n ih => simp only [StandaloneRuntime019.value,BitTapes016.value,ih]

theorem word_eq (n : ℕ) (tape : JointInterface019.Bits n) :
    StandaloneRuntime019.word n tape=BitTapes016.word n tape := by
  apply Fin.ext
  exact value_eq n tape

theorem first_eq {Coin A : Type} (trial : Coin → Option A) (n : ℕ) (coins : Fin n → Coin) :
    StandaloneRuntime019.first trial n coins=CapExecution016.first trial n coins := by
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [StandaloneRuntime019.first,CapExecution016.first]
    cases trial (coins 0) <;> simp [ih]

theorem search_eq (cdf : ℕ → ℕ) (u fuel lo len : ℕ) :
    StandaloneRuntime019.search cdf u fuel lo len=BinarySearch018.search cdf u fuel lo len := by
  induction fuel generalizing lo len with
  | zero => rfl
  | succ fuel ih => simp only [StandaloneRuntime019.search,BinarySearch018.search,ih]

attribute [local irreducible] StandaloneRuntime019.search BinarySearch018.search StandaloneRuntime019.word BitTapes016.word

theorem coord_eq (t : R.T) (coins : JointInterface019.Bits 384) :
    StandaloneRuntime019.coord t coins=BinaryCDF018.coord (oldTables t) coins := by
  apply Fin.ext
  change min (StandaloneRuntime019.coordRun t coins).1 30720=min (BinaryCDF018.coordRun (oldTables t) coins).1 30720
  unfold StandaloneRuntime019.coordRun BinaryCDF018.coordRun
  rw [word_eq,search_eq]
  rfl

attribute [local irreducible] StandaloneRuntime019.coord BinaryCDF018.coord

theorem pairTrial_eq (t : R.T) :
    StandaloneRuntime019.pairTrial t=CachedSampler018.pairTrial (oldTables t) := by
  funext coins
  unfold StandaloneRuntime019.pairTrial CachedSampler018.pairTrial
  simp only [coord_eq,word_eq]
  rfl

attribute [local irreducible] StandaloneRuntime019.first CapExecution016.first

theorem pair_eq (t : R.T) (coins : StandaloneRuntime019.PairSeed) :
    StandaloneRuntime019.pair t coins=CachedSampler018.pair (oldTables t) coins := by
  unfold StandaloneRuntime019.pair CachedSampler018.pair
  rw [first_eq,pairTrial_eq]
  rfl

theorem vector_eq (t : R.T) (coins : StandaloneRuntime019.VectorSeed) :
    StandaloneRuntime019.vector t coins=CachedSampler018.vector (oldTables t) coins := by
  simp only [StandaloneRuntime019.vector,CachedSampler018.vector,pair_eq]

theorem normTrial_eq (t : R.T) :
    StandaloneRuntime019.normTrial t=CachedSampler018.normTrial (oldTables t) := by
  funext coins
  simp only [StandaloneRuntime019.normTrial,CachedSampler018.normTrial,vector_eq]
  rfl

theorem cubeCoord_eq (coins : JointInterface019.Bits 10) :
    StandaloneRuntime019.cubeCoord coins=SamplerCode016.cubeCoord coins := by
  apply Fin.ext
  change (StandaloneRuntime019.word 10 coins).val+65023=(BitTapes016.word 10 coins).val+65023
  rw [word_eq]

theorem cube_eq (coins : StandaloneRuntime019.CubeSeed) :
    StandaloneRuntime019.cube coins=CachedSampler018.cube coins := by
  simp only [StandaloneRuntime019.cube,CachedSampler018.cube,CachedSampler018.save,SamplerCode016.cube,cubeCoord_eq]

theorem selected_eq (t : R.T) (coins : StandaloneRuntime019.Seed) :
    StandaloneRuntime019.selected t coins=CachedSampler018.selected (oldTables t) coins := by
  unfold StandaloneRuntime019.selected CachedSampler018.selected
  rw [first_eq,normTrial_eq]
  cases CapExecution016.first (CachedSampler018.normTrial (oldTables t)) 196 coins.1 <;> simp only [cube_eq]

theorem seedEquiv_eq : StandaloneRuntime019.seedEquiv=SamplerCode016.seedEquiv := rfl

theorem scatter_step_eq (a b : Rq) (v : StandaloneRuntime019.Scatter.Coeffs)
    (i j : FT1536.Run2.PolynomialReference.TermIndex) :
    StandaloneRuntime019.Scatter.step a b v i j=Scatter018.step a b v i j := rfl

theorem indices_eq : StandaloneRuntime019.Scatter.indices=Scatter018.indices := rfl
attribute [local irreducible] StandaloneRuntime019.Scatter.indices Scatter018.indices

theorem multiply_eq (a b : Rq) :
    StandaloneRuntime019.Scatter.multiply a b=Scatter018.multiply a b := by
  unfold StandaloneRuntime019.Scatter.multiply Scatter018.multiply
  simp only [indices_eq,scatter_step_eq]

theorem challenge_eq (h : StandaloneRuntime019.Key) (z : StandaloneRuntime019.CachedBox) :
    StandaloneRuntime019.challenge h z=StoredInterface018.challenge h z := by
  unfold StandaloneRuntime019.challenge StoredInterface018.challenge
  rw [multiply_eq]
  rfl

theorem tables_eq : oldTables StandaloneRuntime019.tables=ActualTables016.tables := rfl
attribute [local irreducible] StandaloneRuntime019.selected CachedSampler018.selected

theorem run_eq (h : StandaloneRuntime019.Key) (coins : StandaloneRuntime019.Seed) :
    StandaloneRuntime019.run h coins=StoredInterface018.run h coins := by
  unfold StandaloneRuntime019.run StoredInterface018.run
  rw [selected_eq,tables_eq]
  simp only [challenge_eq]

theorem outputView_eq (out : StandaloneRuntime019.Output) :
    StandaloneRuntime019.outputView out=StoredInterface018.outputView out := rfl

attribute [local irreducible] StandaloneRuntime019.run StoredInterface018.run StandaloneRuntime019.seedEquiv SamplerCode016.seedEquiv

theorem publicCode_eq (h : Rq) : StandaloneRuntime019.publicCode h=LegacyPairWitness019.publicCode h := by
  have hc : (fun tape : JointInterface019.Bits 24662538240 =>
      StandaloneRuntime019.outputView (StandaloneRuntime019.run (StandaloneRuntime019.saveKey h)
        (StandaloneRuntime019.seedEquiv tape)))=
      (fun tape : JointInterface019.Bits 24662538240 =>
      StoredInterface018.outputView (StoredInterface018.run (StoredInterface018.saveKey h)
        (SamplerCode016.seedEquiv tape))) := by
    funext tape
    rw [seedEquiv_eq,run_eq,outputView_eq]
    rfl
  exact congrArg (fun f => (⟨24662538240,f⟩ : JointInterface019.PairCode Rq ReferenceJoint019.Reply)) hc

#print axioms value_eq
#print axioms word_eq
#print axioms first_eq
#print axioms search_eq
#print axioms coord_eq
#print axioms pairTrial_eq
#print axioms pair_eq
#print axioms vector_eq
#print axioms normTrial_eq
#print axioms cubeCoord_eq
#print axioms cube_eq
#print axioms selected_eq
#print axioms seedEquiv_eq
#print axioms scatter_step_eq
#print axioms indices_eq
#print axioms multiply_eq
#print axioms challenge_eq
#print axioms tables_eq
#print axioms run_eq
#print axioms outputView_eq
#print axioms publicCode_eq
end FT1536.S05.RuntimeAgreement019
