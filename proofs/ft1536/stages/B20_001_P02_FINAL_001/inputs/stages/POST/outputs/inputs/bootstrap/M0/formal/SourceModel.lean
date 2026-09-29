import Layouts
import Twiddles
import Deps.Composition
set_option maxRecDepth 16384
set_option maxHeartbeats 30000000

namespace FT1536Global
abbrev Vec := FT1536Composition.Vec
def canVal (x : Int) : Int := x % 18433
def addQ (x y : Int) : Int := (x+y)%18433
def subQ (x y : Int) : Int := (x-y)%18433
def mmQ (x y : Int) : Int := (x*y*5184)%18433
def CanonVal (x : Int) : Prop := 0≤x ∧ x<18433

theorem addQ_range (x y : Int) : CanonVal (addQ x y) := by unfold CanonVal addQ; omega
theorem subQ_range (x y : Int) : CanonVal (subQ x y) := by unfold CanonVal subQ; omega
theorem mmQ_range (x y : Int) : CanonVal (mmQ x y) := by unfold CanonVal mmQ; omega

theorem addQ_source (x y : Int) (hx : FT1536NTT.Canon x) (hy : FT1536NTT.Canon y) :
    FT1536NTT.addWord x y=addQ x y := (FT1536NTT.add_contract x y hx hy).1
theorem subQ_source (x y : Int) (hx : FT1536NTT.Canon x) (hy : FT1536NTT.Canon y) :
    FT1536NTT.subWord x y=subQ x y := (FT1536NTT.sub_contract x y hx hy).1
theorem mmQ_source (x y : Int) (hx : FT1536NTT.Canon x) (hy : FT1536NTT.Canon y) :
    FT1536NTT.montZ (x*y)=mmQ x y := by
  have nonneg : 0≤x*y := Int.mul_nonneg hx.1 hy.1
  have bound := Int.mul_le_mul (show x≤18432 by have h:=hx.2; omega)
    (show y≤18432 by have h:=hy.2; omega) hy.1 (show (0:Int)≤18432 by decide)
  exact (FT1536NTT.mont_contract_z (x*y) nonneg (by omega)).2.1

-- Each operator follows the source temporaries and primitive call order.
def forwardRootOp (_b : Nat) (v : Bool → Int) (k : Bool) : Int :=
  let a0:=v false; let a1:=v true
  let z:=mmQ a1 (gmAt 1)
  if k then subQ (addQ a0 a1) z else addQ a0 z

def forwardBinaryOp (m ht b : Nat) (v : Bool → Int) (k : Bool) : Int :=
  let a0:=v false; let a1:=v true
  let z:=mmQ a1 (gmAt (m+b/ht))
  if k then subQ a0 z else addQ a0 z

def forwardCubicOp (b : Nat) (v : Fin 3 → Int) (k : Fin 3) : Int :=
  let fA:=v 0;let fB:=v 1;let fC:=v 2
  let x:=gmAt (512+b);let x2:=mmQ x x;let w:=mmQ (gmAt 1) (gmAt 1)
  let b0:=mmQ fB x;let b1:=mmQ b0 w;let b2:=mmQ b1 w
  let c0:=mmQ fC x2;let c1:=mmQ c0 w;let c2:=mmQ c1 w
  if k=0 then addQ fA (addQ b0 c0)
  else if k=1 then addQ fA (addQ b1 c2) else addQ fA (addQ b2 c1)

def inverseCubicOp (b : Nat) (v : Fin 3 → Int) (k : Fin 3) : Int :=
  let f0:=v 0;let f1:=v 1;let f2:=v 2
  let x:=igmAt (512+b);let x2:=mmQ x x;let w:=mmQ (igmAt 1) (igmAt 1)
  let f11:=mmQ f1 w;let f12:=mmQ f11 w
  let f21:=mmQ f2 w;let f22:=mmQ f21 w
  if k=0 then addQ f0 (addQ f1 f2)
  else if k=1 then mmQ x (addQ f0 (addQ f11 f22))
  else mmQ x2 (addQ f0 (addQ f12 f21))

def inverseBinaryOp (m ht b : Nat) (v : Bool → Int) (k : Bool) : Int :=
  let a0:=v false;let a1:=v true
  if k then mmQ (subQ a0 a1) (igmAt (m+b/ht)) else addQ a0 a1

def inverseRootOp (_b : Nat) (v : Bool → Int) (k : Bool) : Int :=
  let a0:=v false;let a1:=v true
  let z:=mmQ (igmAt 0) (subQ a0 a1)
  if k then addQ z z else subQ (addQ a0 a1) z

theorem forwardRootOp_range (b : Nat) (v : Bool → Int) (k : Bool) : CanonVal (forwardRootOp b v k) := by
  cases k <;> first | exact addQ_range _ _ | exact subQ_range _ _
theorem forwardBinaryOp_range (m ht b : Nat) (v : Bool → Int) (k : Bool) : CanonVal (forwardBinaryOp m ht b v k) := by
  cases k <;> first | exact addQ_range _ _ | exact subQ_range _ _
theorem forwardCubicOp_range (b : Nat) (v : Fin 3 → Int) (k : Fin 3) : CanonVal (forwardCubicOp b v k) := by
  unfold forwardCubicOp
  split
  · exact addQ_range _ _
  · split <;> exact addQ_range _ _
theorem inverseCubicOp_range (b : Nat) (v : Fin 3 → Int) (k : Fin 3) : CanonVal (inverseCubicOp b v k) := by
  unfold inverseCubicOp
  split
  · exact addQ_range _ _
  · split <;> exact mmQ_range _ _
theorem inverseBinaryOp_range (m ht b : Nat) (v : Bool → Int) (k : Bool) : CanonVal (inverseBinaryOp m ht b v k) := by
  cases k <;> first | exact addQ_range _ _ | exact mmQ_range _ _
theorem inverseRootOp_range (b : Nat) (v : Bool → Int) (k : Bool) : CanonVal (inverseRootOp b v k) := by
  cases k <;> first | exact addQ_range _ _ | exact subQ_range _ _

def forwardMiddle : List (Nat × Nat) → Mem → Mem
  | [],s => s
  | (m,t)::ps,s => forwardMiddle ps
      (runSteps (pairStep (pairAddr (t/2)) (forwardBinaryOp m (t/2))) 768 s)
def inverseMiddle : List (Nat × Nat) → Mem → Mem
  | [],s => s
  | (m,t)::ps,s => inverseMiddle ps
      (runSteps (pairStep (pairAddr (t/2)) (inverseBinaryOp m (t/2))) 768 s)

def scaleStep (i : Nat) (s : Mem) : Mem := store s i (mmQ (s i) 6187)
def forwardMem (s : Mem) : Mem :=
  let root:=runSteps (pairStep (pairAddr 768) forwardRootOp) 768 s
  let mid:=forwardMiddle (forwardSchedule 9 2 768) root
  runSteps (tripleStep tripleAddr forwardCubicOp) 512 mid
def inverseMem (s : Mem) : Mem :=
  let cub:=runSteps (tripleStep tripleAddr inverseCubicOp) 512 s
  let mid:=inverseMiddle (inverseSchedule 9 256 6) cub
  let root:=runSteps (pairStep (pairAddr 768) inverseRootOp) 768 mid
  runSteps scaleStep 1536 root

theorem forward_params_half : ∀ p, p∈forwardSchedule 9 2 768 → HalfOK (p.2/2) := by
  intro p hp
  rw [forward_schedule] at hp
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hp
  rcases hp with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl <;> simp [HalfOK]
theorem inverse_params_half : ∀ p, p∈inverseSchedule 9 256 6 → HalfOK (p.2/2) := by
  intro p hp
  rw [inverse_schedule] at hp
  simp only [List.mem_cons, List.not_mem_nil, or_false] at hp
  rcases hp with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl <;> simp [HalfOK]

theorem forwardMiddle_canonical (ps : List (Nat × Nat))
    (hp : ∀ p, p∈ps → HalfOK (p.2/2)) (s : Mem) (hs : CanonMem s) : CanonMem (forwardMiddle ps s) := by
  induction ps generalizing s with
  | nil => exact hs
  | cons p ps ih =>
    apply ih
    · intro a ha
      exact hp a (List.mem_cons_of_mem p ha)
    · apply pair_prefix_canonical (p.2/2) (hp p (by simp)) (forwardBinaryOp p.1 (p.2/2)) _ 768 (by omega) s hs
      intro b hb v hv k
      exact forwardBinaryOp_range _ _ _ _ _

theorem inverseMiddle_canonical (ps : List (Nat × Nat))
    (hp : ∀ p, p∈ps → HalfOK (p.2/2)) (s : Mem) (hs : CanonMem s) : CanonMem (inverseMiddle ps s) := by
  induction ps generalizing s with
  | nil => exact hs
  | cons p ps ih =>
    apply ih
    · intro a ha
      exact hp a (List.mem_cons_of_mem p ha)
    · apply pair_prefix_canonical (p.2/2) (hp p (by simp)) (inverseBinaryOp p.1 (p.2/2)) _ 768 (by omega) s hs
      intro b hb v hv k
      exact inverseBinaryOp_range _ _ _ _ _

theorem store_canonical (s : Mem) (hs : CanonMem s) (i : Nat) (x : Int) (hx : CanonVal x) : CanonMem (store s i x) := by
  intro j hj
  by_cases h : j=i
  · simpa [CanonVal,store,h] using hx
  · simpa [store,h] using hs j hj

theorem scale_canonical (n : Nat) (s : Mem) (hs : CanonMem s) : CanonMem (runSteps scaleStep n s) := by
  induction n with
  | zero => exact hs
  | succ n ih => exact store_canonical _ ih n _ (mmQ_range _ _)

theorem forward_canonical (s : Mem) (hs : CanonMem s) : CanonMem (forwardMem s) := by
  have hroot : CanonMem (runSteps (pairStep (pairAddr 768) forwardRootOp) 768 s) := by
    apply pair_prefix_canonical 768 (by simp [HalfOK]) forwardRootOp _ 768 (by omega) s hs
    intro b hb v hv k
    exact forwardRootOp_range _ _ _
  have hmid := forwardMiddle_canonical _ forward_params_half _ hroot
  apply triple_prefix_canonical forwardCubicOp _ 512 (by omega) _ hmid
  intro b hb v hv k
  exact forwardCubicOp_range _ _ _

theorem inverse_canonical (s : Mem) (hs : CanonMem s) : CanonMem (inverseMem s) := by
  have hcub : CanonMem (runSteps (tripleStep tripleAddr inverseCubicOp) 512 s) := by
    apply triple_prefix_canonical inverseCubicOp _ 512 (by omega) s hs
    intro b hb v hv k
    exact inverseCubicOp_range _ _ _
  have hmid := inverseMiddle_canonical _ inverse_params_half _ hcub
  have hroot : CanonMem (runSteps (pairStep (pairAddr 768) inverseRootOp) 768
      (inverseMiddle (inverseSchedule 9 256 6) (runSteps (tripleStep tripleAddr inverseCubicOp) 512 s))) := by
    apply pair_prefix_canonical 768 (by simp [HalfOK]) inverseRootOp _ 768 (by omega) _ hmid
    intro b hb v hv k
    exact inverseRootOp_range _ _ _
  exact scale_canonical 1536 _ hroot

def fromVec (v : Vec) : Mem := fun i => if hi : i<1536 then v ⟨i,hi⟩ else 0
def toVec (s : Mem) : Vec := fun i => s i.val
def forwardC (v : Vec) : Vec := toVec (forwardMem (fromVec v))
def inverseC (v : Vec) : Vec := toVec (inverseMem (fromVec v))
def liftForward (v : Vec) : Vec := forwardC (FT1536Composition.canonical v)
def liftInverse (v : Vec) : Vec := inverseC (FT1536Composition.canonical v)
def CanonVec (v : Vec) : Prop := ∀ i, CanonVal (v i)

theorem fromVec_canonical (v : Vec) (hv : CanonVec v) : CanonMem (fromVec v) := by
  intro i hi
  simpa [CanonVal,fromVec,hi] using hv ⟨i,hi⟩
theorem forwardC_canonical (v : Vec) (hv : CanonVec v) : CanonVec (forwardC v) := by
  intro i
  exact forward_canonical _ (fromVec_canonical v hv) i.val i.isLt
theorem inverseC_canonical (v : Vec) (hv : CanonVec v) : CanonVec (inverseC v) := by
  intro i
  exact inverse_canonical _ (fromVec_canonical v hv) i.val i.isLt
theorem canonical_fixed (v : Vec) (hv : CanonVec v) : FT1536Composition.canonical v=v := by
  funext i
  have h:=hv i
  unfold FT1536Composition.canonical CanonVal at *
  omega
theorem liftForward_agrees (v : Vec) (hv : CanonVec v) : liftForward v=forwardC v := by
  unfold liftForward
  rw [canonical_fixed v hv]
theorem liftInverse_agrees (v : Vec) (hv : CanonVec v) : liftInverse v=inverseC v := by
  unfold liftInverse
  rw [canonical_fixed v hv]

#check @forward_canonical
#check @inverse_canonical
#check @liftForward_agrees
#print axioms addQ_source
#print axioms subQ_source
#print axioms mmQ_source
#print axioms forwardRootOp_range
#print axioms forwardBinaryOp_range
#print axioms forwardCubicOp_range
#print axioms inverseCubicOp_range
#print axioms inverseBinaryOp_range
#print axioms inverseRootOp_range
#print axioms forwardMiddle_canonical
#print axioms inverseMiddle_canonical
#print axioms scale_canonical
#print axioms forward_canonical
#print axioms inverse_canonical
#print axioms forwardC_canonical
#print axioms inverseC_canonical
#print axioms canonical_fixed
#print axioms liftForward_agrees
#print axioms liftInverse_agrees
end FT1536Global
