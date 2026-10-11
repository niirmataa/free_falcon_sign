import JointInterface019
import FT1536.Model
import PublicTables016
import Run2.PolynomialReference
import Mathlib.Logic.Equiv.Fin.Basic
import Init.Data.Vector.OfFn

set_option maxRecDepth 8192
namespace FT1536.S05.StandaloneRuntime019
open FT1536.Geometry FT1536.PublicSimulation FT1536.Relation JointInterface019

def split (a b : ℕ) : Bits (a+b) ≃ Bits a × Bits b :=
  (Equiv.arrowCongr finSumFinEquiv.symm (Equiv.refl Bool)).trans
    (Equiv.sumArrowEquivProdArrow (Fin a) (Fin b) Bool)

def chunks (n k : ℕ) : Bits (n*k) ≃ (Fin n → Bits k) :=
  (Equiv.arrowCongr finProdFinEquiv.symm (Equiv.refl Bool)).trans
    (Equiv.curry (Fin n) (Fin k) Bool)

def value : (n : ℕ) → Bits n → ℕ
  | 0,_ => 0
  | n+1,tape => (if tape 0 then 1 else 0)+2*value n (fun i => tape i.succ)

theorem value_lt (n : ℕ) (tape : Bits n) : value n tape<2^n := by
  induction n with
  | zero => simp [value]
  | succ n ih =>
    have hh := ih (fun i => tape i.succ)
    simp only [value,pow_succ]
    split <;> omega

def word (n : ℕ) (tape : Bits n) : Fin (2^n) := ⟨value n tape,value_lt n tape⟩

abbrev CoordIndex := Fin 30721

abbrev PairIndex := Fin 61441

abbrev Block := Fin 131071 × Fin 131071

structure Tables where
  cdf : CoordIndex → ℕ
  threshold : PairIndex → ℕ

def embedCoord (i : CoordIndex) : Fin 131071 := ⟨i.val+50175,by have := i.isLt; omega⟩

def zeroBlock : Block := (⟨65535,by decide⟩,⟨65535,by decide⟩)

abbrev PairBits := Bits 384 × (Bits 384 × Bits 256)

abbrev PairSeed := Fin 80 → PairBits

abbrev VectorSeed := (Fin 768 → PairSeed) × (Fin 768 → PairSeed)

abbrev NormSeed := Fin 196 → VectorSeed

abbrev CubeSeed := (Fin 768 → Bits 10 × Bits 10) × (Fin 768 → Bits 10 × Bits 10)

abbrev Seed := NormSeed × CubeSeed

def first {Coin A : Type} (trial : Coin → Option A) : (n : ℕ) → (Fin n → Coin) → Option A
  | 0,_ => none
  | n+1,tape => match trial (tape 0) with
    | some x => some x
    | none => first trial n (fun i => tape i.succ)

def search (cdf : ℕ → ℕ) (u : ℕ) : ℕ → ℕ → ℕ → ℕ×ℕ
  | 0,lo,_ => (lo,0)
  | fuel+1,lo,len =>
    if len=0 then (lo,0) else
      let mid := len/2
      let next := if u<cdf (lo+mid)
        then search cdf u fuel lo mid
        else search cdf u fuel (lo+mid+1) (len-mid-1)
      (next.1,next.2+1)

def extended (t : Tables) (i : ℕ) : ℕ := t.cdf ⟨min i 30720,by omega⟩

def coordRun (t : Tables) (bits : Bits 384) : ℕ×ℕ :=
  search (extended t) ((word 384 bits).val%t.cdf ⟨30720,by decide⟩) 15 0 30721

def coord (t : Tables) (bits : Bits 384) : CoordIndex :=
  ⟨min (coordRun t bits).1 30720,by omega⟩

abbrev CachedBox := Vector Block 768 × Vector Block 768

def view (v : CachedBox) : BoxPair := (fun i => v.1[i.val],fun i => v.2[i.val])

def save (v : BoxPair) : CachedBox := (Vector.ofFn v.1,Vector.ofFn v.2)

def pairTrial (t : Tables) (coins : PairBits) : Option Block :=
  let x := coord t coins.1
  let y := coord t coins.2.1
  if (word 256 coins.2.2).val<t.threshold ⟨x.val+y.val,by have := x.isLt; have := y.isLt; omega⟩
    then some (embedCoord x,embedCoord y) else none

def pair (t : Tables) (coins : PairSeed) : Block :=
  (first (pairTrial t) 80 coins).getD zeroBlock

def vector (t : Tables) (coins : VectorSeed) : CachedBox :=
  (Vector.ofFn (fun i => pair t (coins.1 i)),Vector.ofFn (fun i => pair t (coins.2 i)))

def normTrial (t : Tables) (coins : VectorSeed) : Option CachedBox :=
  let v := vector t coins
  if Q (decode (view v))<B then some v else none

def cubeCoord (coins : Bits 10) : Fin 131071 :=
  ⟨(word 10 coins).val+65023,by have := (word 10 coins).isLt; norm_num at this; omega⟩

def cube (coins : CubeSeed) : CachedBox :=
  (Vector.ofFn (fun i => (cubeCoord (coins.1 i).1,cubeCoord (coins.1 i).2)),
   Vector.ofFn (fun i => (cubeCoord (coins.2 i).1,cubeCoord (coins.2 i).2)))

def selected (t : Tables) (coins : Seed) : CachedBox :=
  match first (normTrial t) 196 coins.1 with
  | some v => v
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

namespace Scatter
open FT1536.Run2.PolynomialReference
abbrev Coeffs := Vector F 1536

def addAt (v : Coeffs) (t : Fin 1536 × F) : Coeffs :=
  v.set t.1.val (v[t.1.val]+t.2)

def scatter (v : Coeffs) (xs : List (Fin 1536 × F)) : Coeffs := xs.foldl addAt v

def indices : List TermIndex := (List.finRange 768).flatMap (fun i => [(i,false),(i,true)])

def step (a b : Rq) (v : Coeffs) (i j : TermIndex) : Coeffs :=
  let c := coefficient a i*coefficient b j
  scatter v ((remainderTerms (productExponent i j)).map (fun t => (t.1,c*t.2)))

def multiply (a b : Rq) : Coeffs :=
  indices.foldl (fun v i => indices.foldl (fun w j => step a b w i j) v) (Vector.replicate 1536 0)

def view (v : Coeffs) : Rq := fun i => (v[i.val],v[i.val+768])

end Scatter
def tables : Tables where
  cdf i := TableData016.cdf i.val
  threshold i := TableData016.threshold i.val

abbrev Key := Vector (ZMod 18433 × ZMod 18433) 768

abbrev Output := Key × Vector Block 768

def keyView (h : Key) : Rq := fun i => h[i.val]

def saveKey (h : Rq) : Key := Vector.ofFn h

def challenge (h : Key) (z : CachedBox) : Key :=
  let p := Scatter.multiply (keyView h) (reduceVec (decode (view z)).2)
  Vector.ofFn (fun i =>
    ((reduceVec (decode (view z)).1 i).1+p[i.val],
     (reduceVec (decode (view z)).1 i).2+p[i.val+768]))

def run (h : Key) (coins : Seed) : Output :=
  let z := selected tables coins
  (challenge h z,z.2)

def outputView (out : Output) : Rq × Option BoxVec :=
  (keyView out.1,some (fun i => out.2[i.val]))


def publicCode (h : Rq) : PairCode Rq (Option BoxVec) where
  bits := 24662538240
  code tape := outputView (run (saveKey h) (seedEquiv tape))

end FT1536.S05.StandaloneRuntime019
