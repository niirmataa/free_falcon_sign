import BitTapes016
import CapExecution016
import Run2.PolynomialReference

set_option maxRecDepth 8192

/- Computable finite-tape reference for007. CDF search is explicit linear
   first-hit search; it is not assigned the bisect implementation's cost.
   Tables are public data parameters, not ideal real Gaussian oracles. -/
namespace FT1536.S05.SamplerCode016
open FT1536.Geometry FT1536.PublicSimulation FT1536.Relation FT1536.Run2
open BitTapes016 CapExecution016

abbrev CoordIndex := Fin 30721
abbrev PairIndex := Fin 61441
abbrev Block := Fin 131071 × Fin 131071
structure Tables where
  cdf : CoordIndex → ℕ
  threshold : PairIndex → ℕ

def coord (t : Tables) (w : Bits 384) : CoordIndex :=
  let residue := (word 384 w).val % t.cdf ⟨30720,by decide⟩
  ((List.finRange 30721).find? (fun i => residue<t.cdf i)).getD ⟨30720,by decide⟩

def embedCoord (i : CoordIndex) : Fin 131071 := ⟨i.val+50175,by have := i.isLt; omega⟩
def zeroBlock : Block := (⟨65535,by decide⟩,⟨65535,by decide⟩)
abbrev PairBits := Bits 384 × (Bits 384 × Bits 256)
abbrev PairSeed := Fin 80 → PairBits
abbrev VectorSeed := (Fin 768 → PairSeed) × (Fin 768 → PairSeed)
abbrev NormSeed := Fin 196 → VectorSeed
abbrev CubeSeed := (Fin 768 → Bits 10 × Bits 10) × (Fin 768 → Bits 10 × Bits 10)
abbrev Seed := NormSeed × CubeSeed
instance pairBitsFintype : Fintype PairBits := inferInstance
instance pairSeedFintype : Fintype PairSeed := inferInstance
instance vectorSeedFintype : Fintype VectorSeed := inferInstance
instance normSeedFintype : Fintype NormSeed := inferInstance
instance cubeSeedFintype : Fintype CubeSeed := inferInstance
instance seedFintype : Fintype Seed := inferInstance
noncomputable instance seedDecidableEq : DecidableEq Seed := Classical.decEq Seed

def pairTrial (t : Tables) (coins : PairBits) : Option Block :=
  let x := coord t coins.1
  let y := coord t coins.2.1
  if (word 256 coins.2.2).val<t.threshold ⟨x.val+y.val,by have := x.isLt; have := y.isLt; omega⟩
    then some (embedCoord x,embedCoord y) else none

def pair (t : Tables) (coins : PairSeed) : Block :=
  (first (pairTrial t) 80 coins).getD zeroBlock

def vector (t : Tables) (coins : VectorSeed) : BoxPair :=
  (fun i => pair t (coins.1 i),fun i => pair t (coins.2 i))

def normTrial (t : Tables) (coins : VectorSeed) : Option BoxPair :=
  let z := vector t coins
  if Q (decode z)<B then some z else none

def cubeCoord (coins : Bits 10) : Fin 131071 :=
  ⟨(word 10 coins).val+65023,by have := (word 10 coins).isLt; norm_num at this; omega⟩

def cube (coins : CubeSeed) : BoxPair :=
  (fun i => (cubeCoord (coins.1 i).1,cubeCoord (coins.1 i).2),
   fun i => (cubeCoord (coins.2 i).1,cubeCoord (coins.2 i).2))

def selected (t : Tables) (coins : Seed) : BoxPair :=
  match first (normTrial t) 196 coins.1 with
  | some z => z
  | none => cube coins.2

def pairEquiv : Bits 1024 ≃ PairBits :=
  (split 384 640).trans (Equiv.prodCongr (Equiv.refl _) (split 384 256))
def pairSeedEquiv : Bits (80*1024) ≃ PairSeed :=
  (chunks 80 1024).trans (Equiv.piCongrRight (fun _ => pairEquiv))
def halfSeedEquiv : Bits (768*(80*1024)) ≃ (Fin 768 → PairSeed) :=
  (chunks 768 (80*1024)).trans (Equiv.piCongrRight (fun _ => pairSeedEquiv))
def vectorSeedEquiv : Bits (1536*80*1024) ≃ VectorSeed :=
  (split (768*(80*1024)) (768*(80*1024))).trans (Equiv.prodCongr halfSeedEquiv halfSeedEquiv)
def normSeedEquiv : Bits (196*(1536*80*1024)) ≃ NormSeed :=
  (chunks 196 (1536*80*1024)).trans (Equiv.piCongrRight (fun _ => vectorSeedEquiv))
def cubeHalfEquiv : Bits (768*20) ≃ (Fin 768 → Bits 10 × Bits 10) :=
  (chunks 768 20).trans (Equiv.piCongrRight (fun _ => split 10 10))
def cubeSeedEquiv : Bits 30720 ≃ CubeSeed :=
  (split (768*20) (768*20)).trans (Equiv.prodCongr cubeHalfEquiv cubeHalfEquiv)
def seedEquiv : Bits 24662538240 ≃ Seed :=
  (split (196*(1536*80*1024)) 30720).trans (Equiv.prodCongr normSeedEquiv cubeSeedEquiv)

def challenge (h : Rq) (z : BoxPair) : Rq :=
  reduceVec (decode z).1+PolynomialReference.multiply h (reduceVec (decode z).2)

def sampler (t : Tables) : Sampler where
  bits := 24662538240
  code h _ _ _ tape :=
    let z := selected t (seedEquiv tape)
    (challenge h z,some z.2)

theorem challenge_correct (h : Rq) (z : BoxPair) : challenge h z=SigmaMath.syndrome h z := by
  rw [challenge,PolynomialReference.multiply_correct]
  rfl

theorem seed_uniform : (Law.uniform : Law (Bits 24662538240)).map seedEquiv=Law.uniform :=
  uniform_equiv seedEquiv

theorem ignores_context (t : Tables) (h : Rq) (st : State) (m : Bytes) (r : Nonce)
    (coins : Bits 24662538240) :
    (sampler t).code h st m r coins=(sampler t).code h initial m r coins := rfl

theorem bit_count : 196*1536*80*(2*384+256)+2*1536*10=24662538240 := by norm_num

theorem proposal_count : 196*1536*80=24084480 := by norm_num

#print axioms challenge_correct
#print axioms seed_uniform
#print axioms ignores_context
#print axioms bit_count
#print axioms proposal_count
end FT1536.S05.SamplerCode016
