import Scatter018

set_option maxRecDepth 8192
namespace FT1536.S05.StoredInterface018
open FT1536.Geometry FT1536.PublicSimulation FT1536.Relation FT1536.Run2
open SamplerCode016 CachedSampler018
abbrev Key := Vector (ZMod 18433 × ZMod 18433) 768
abbrev Output := Key × Vector Block 768

def keyView (h : Key) : Rq := fun i => h[i.val]
def saveKey (h : Rq) : Key := Vector.ofFn h

theorem keyView_saveKey (h : Rq) : keyView (saveKey h)=h := by
  funext i
  simp [keyView,saveKey]

def challenge (h : Key) (z : CachedBox) : Key :=
  let p := Scatter018.multiply (keyView h) (reduceVec (decode (CachedSampler018.view z)).2)
  Vector.ofFn (fun i =>
    ((reduceVec (decode (CachedSampler018.view z)).1 i).1+p[i.val],
     (reduceVec (decode (CachedSampler018.view z)).1 i).2+p[i.val+768]))

theorem challenge_eq (h : Key) (z : CachedBox) :
    keyView (challenge h z)=SamplerCode016.challenge (keyView h) (CachedSampler018.view z) := by
  have hp := Scatter018.multiply_eq (keyView h) (reduceVec (decode (CachedSampler018.view z)).2)
  funext i
  have hi := congrFun hp i
  simp only [Scatter018.view] at hi
  simp only [keyView,challenge,Vector.getElem_ofFn,SamplerCode016.challenge,Pi.add_apply]
  rw [Prod.ext_iff] at hi
  exact Prod.ext (congrArg (_+·) hi.1) (congrArg (_+·) hi.2)

def run (h : Key) (coins : Seed) : Output :=
  let z := CachedSampler018.selected ActualTables016.tables coins
  (challenge h z,z.2)

def outputView (out : Output) : Rq × Option BoxVec :=
  (keyView out.1,some (fun i => out.2[i.val]))

attribute [local irreducible] CachedSampler018.selected SamplerCode016.selected ActualTables016.tables

theorem run_eq (h : Rq) (coins : Seed) :
    outputView (run (saveKey h) coins)=
      let z := SamplerCode016.selected ActualTables016.tables coins
      (SamplerCode016.challenge h z,some z.2) := by
  simp only [outputView,run,challenge_eq,keyView_saveKey]
  have he := CachedSampler018.actual_selected_eq coins
  apply Prod.ext
  · exact congrArg (SamplerCode016.challenge h) he
  · exact congrArg some (congrArg Prod.snd he)

def sampler : Sampler where
  bits := 24662538240
  code h _ _ _ coins := outputView (run (saveKey h) (seedEquiv coins))

theorem sampler_eq : sampler=ActualTables016.actualSampler := by
  have hc : sampler.code=ActualTables016.actualSampler.code := by
    funext h st m r coins
    exact run_eq h (seedEquiv coins)
  exact congrArg (fun f => (⟨24662538240,f⟩ : Sampler)) hc

theorem all_h_ac (h : Rq) (st : State) (m : Bytes) (r : Nonce) :
    Divergence.AC (samplerLaw sampler h st m r) (SigmaMath.freshHonest h) := by
  rw [sampler_eq]
  exact ActualTables016.actual_all_h_ac h st m r

theorem moment_under_mass (h : Rq) (mass : SamplerMassCondition014.MassCondition h)
    (st : State) (m : Bytes) (r : Nonce) :
    Divergence.second (samplerLaw sampler h st m r) (SigmaMath.freshHonest h)≤1+1/2^47 := by
  rw [sampler_eq]
  exact ActualInterface017.moment_under_mass h mass st m r

theorem initial_certificate (h : Rq) (mass : SamplerMassCondition014.MassCondition h)
    (m : Bytes) (r : Nonce) :
    Divergence.AC (samplerLaw sampler h initial m r) (SigmaMath.freshHonest h) ∧
    Divergence.second (samplerLaw sampler h initial m r) (SigmaMath.freshHonest h)≤1+1/2^47 := by
  rw [sampler_eq]
  exact ActualInterface017.initial_certificate h mass m r

theorem key_law_under_cover (domain : Rq → Prop) (mu : Law Rq)
    (cover : KeySupport011.Covered mu domain)
    (mass : ∀ h,domain h → SamplerMassCondition014.MassCondition h)
    (st : Rq → State) (m : Rq → Bytes) (r : Rq → Nonce) :
    Divergence.AC (KeySupport011.jointSim mu sampler st m r) (KeySupport011.jointHonest mu) ∧
    Divergence.second (KeySupport011.jointSim mu sampler st m r) (KeySupport011.jointHonest mu)≤1+1/2^47 := by
  rw [sampler_eq]
  exact ActualInterface017.key_law_under_cover domain mu cover mass st m r

#print axioms keyView_saveKey
#print axioms challenge_eq
#print axioms run_eq
#print axioms sampler_eq
#print axioms all_h_ac
#print axioms moment_under_mass
#print axioms initial_certificate
#print axioms key_law_under_cover
end FT1536.S05.StoredInterface018
