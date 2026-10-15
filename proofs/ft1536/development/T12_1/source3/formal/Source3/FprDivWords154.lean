import Source3.FprDivLoopTotal
import Source3.FprMulMantissa137

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprDivWords154
open B20.C
open FprDivRound

def prefixRun (x y : BitVec 64) :=
  UnsignedState.exec FprPrimitives.headerCalls (FprUnsignedPrefixes.initial x y) FprUnsignedPrefixes.divPrefix

theorem prefix_x (x y : BitVec 64) : (prefixRun x y).bind (fun s => s.values ['x'])=some (.u64 x) := by rfl
theorem prefix_y (x y : BitVec 64) : (prefixRun x y).bind (fun s => s.values ['y'])=some (.u64 y) := by rfl
theorem prefix_xu (x y : BitVec 64) :
    (prefixRun x y).bind (fun s => s.values ['x','u'])=some (.u64 (FprMulMantissa137.mantissa x)) := by rfl
theorem prefix_yu (x y : BitVec 64) :
    (prefixRun x y).bind (fun s => s.values ['y','u'])=some (.u64 (FprMulMantissa137.mantissa y)) := by rfl
theorem prefix_q (x y : BitVec 64) : (prefixRun x y).bind (fun s => s.values ['q'])=some (.u64 0) := by rfl

def next (yu : BitVec 64) (pair : BitVec 64 × BitVec 64) : BitVec 64 × BitVec 64 :=
  (nextX pair.1 yu,nextQ pair.1 yu pair.2)

def iterate (yu : BitVec 64) : Nat → (BitVec 64 × BitVec 64) → BitVec 64 × BitVec 64
  | 0, pair => pair
  | n+1, pair => next yu (iterate yu n pair)

structure Exact (s : B20.C.Scalar.State) (x y xu yu q : BitVec 64) (i : Nat) : Prop where
  types : s.types=FprUnsignedPrefixes.divTypes
  xValue : s.values ['x']=some (.u64 x)
  yValue : s.values ['y']=some (.u64 y)
  xuValue : s.values ['x','u']=some (.u64 xu)
  yuValue : s.values ['y','u']=some (.u64 yu)
  qValue : s.values ['q']=some (.u64 q)
  index : s.values ['i']=some (.i32 (BitVec.ofNat 32 i))

theorem one_step (s : B20.C.Scalar.State) (x y xu yu q : BitVec 64) (i : Nat)
    (hi : i<55) (hs : Exact s x y xu yu q i) :
    ∃ out, FprDivLoopTotal.oneStep s=some out ∧ Exact out x y (nextX xu yu) yu (nextQ xu yu q) (i+1) := by
  let clean := cleaned s xu yu q
  have ht : clean.types ['i']=some .i32 := by rw [clean_types,hs.types]; rfl
  have hv : clean.values ['i']=some (.i32 (BitVec.ofNat 32 i)) := by
    rw [clean_values]
    simpa [update] using hs.index
  let out : B20.C.Scalar.State := {clean with values := update clean.values ['i'] (.i32 (BitVec.ofNat 32 (i+1)))}
  refine ⟨out,?_,?_,?_,?_,?_,?_,?_,?_⟩
  · have hg := FprDivLoopTotal.index_guard s i (by omega) hs.index
    have hr := round_execution s xu yu q hs.types hs.xuValue hs.yuValue hs.qValue
    have hc := FprDivLoopTotal.index_inc clean i hi ht hv
    simp [FprDivLoopTotal.oneStep,hg,hi,hr,out]
    exact hc
  · exact (clean_types s xu yu q).trans hs.types
  · simp [out,clean,clean_values,update,hs.xValue]
  · simp [out,clean,clean_values,update,hs.yValue]
  · simp [out,clean,clean_values,update]
  · simp [out,clean,clean_values,update,hs.yuValue]
  · simp [out,clean,clean_values,update]
  · simp [out,update]

/-- Exact word recurrence for the original loop, using the existing round source theorem. -/
theorem iterations (s : B20.C.Scalar.State) (x y xu yu q : BitVec 64)
    (hs : Exact s x y xu yu q 0) : ∀ n, n ≤ 55 →
    ∃ out, (List.range n).foldlM (fun acc _ => FprDivLoopTotal.oneStep acc) s=some out ∧
      Exact out x y (iterate yu n (xu,q)).1 yu (iterate yu n (xu,q)).2 n := by
  intro n
  induction n with
  | zero => intro _; exact ⟨s,rfl,hs⟩
  | succ n ih =>
    intro hn
    obtain ⟨mid,hm,him⟩ := ih (by omega)
    obtain ⟨out,ho,hio⟩ := one_step mid x y _ yu _ n (by omega) him
    refine ⟨out,?_,?_⟩
    · simp [List.range_succ,List.foldlM_append,hm,ho]
    · exact hio

end FT1536.Source3.FprDivWords154
