import Source3.FprDivRound
import Source3.FprSmallSigned

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprDivLoopTotal
open B20.C
open FprDivRound

theorem index_value (i : Nat) (hi : i≤56) : (BitVec.ofNat 32 i).toInt=(i : Int) := by
  have hnat : (BitVec.ofNat 32 i).toNat=i := by
    simp [BitVec.toNat_ofNat]
    omega
  have h := BitVec.toInt_eq_toNat_of_lt (x:=BitVec.ofNat 32 i) (by omega)
  omega

theorem index_guard (s : B20.C.Scalar.State) (i : Nat) (hi : i≤55)
    (hs : s.values ['i']=some (.i32 (BitVec.ofNat 32 i))) :
    FprPrimitives.guard ['i'] 55 s=some (decide (i<55)) := by
  have hval := index_value i (by omega)
  simp [FprPrimitives.guard,CLogic.truth,CLogic.compare,CLogic.boolean,Val.integer,
    commonTy,Val.ty,B20.C.cast,hs,hval]
  by_cases hb : i<55 <;> simp [hb]

theorem index_inc (s : B20.C.Scalar.State) (i : Nat) (hi : i<55)
    (ht : s.types ['i']=some .i32)
    (hv : s.values ['i']=some (.i32 (BitVec.ofNat 32 i))) :
    FprPrimitives.inc ['i'] s=some
      {s with values := update s.values ['i'] (.i32 (BitVec.ofNat 32 (i+1)))} := by
  have hval := index_value i (by omega)
  have hone : (1#32).toInt=(1 : Int) := by decide
  have ha := (FprSmallSigned.add32 (BitVec.ofNat 32 i) 1#32 (by rw [hval,hone]; omega)).1
  simp [FprPrimitives.inc,B20.C.Scalar.assign,hv,ht,bin,commonTy,Val.ty,
    B20.C.cast,ha,bitsOp,BitVec.ofNat_add_ofNat]

structure Inv (s : B20.C.Scalar.State) (i : Nat) : Prop where
  types : s.types=FprUnsignedPrefixes.divTypes
  x : ∃ w, s.values ['x']=some (.u64 w)
  y : ∃ w, s.values ['y']=some (.u64 w)
  xu : ∃ w, s.values ['x','u']=some (.u64 w)
  yu : ∃ w, s.values ['y','u']=some (.u64 w)
  q : ∃ w, s.values ['q']=some (.u64 w)
  index : s.values ['i']=some (.i32 (BitVec.ofNat 32 i))

def oneStep (s : B20.C.Scalar.State) : Option B20.C.Scalar.State := do
  if !(← FprPrimitives.guard ['i'] 55 s) then none else do
    let (next,v) ← FprPrimitives.execBlock 250 .u64 roundCode s
    if v.isSome then none else
      FprPrimitives.inc ['i'] (FprPrimitives.leaveBlock s next (FprPrimitives.blockDecls roundCode))

theorem one_step_total (s : B20.C.Scalar.State) (i : Nat) (hi : i<55) (hs : Inv s i) :
    ∃ next, oneStep s=some next ∧ Inv next (i+1) := by
  obtain ⟨xu,hxu⟩ := hs.xu
  obtain ⟨yu,hyu⟩ := hs.yu
  obtain ⟨q,hq⟩ := hs.q
  let clean := cleaned s xu yu q
  have ht : clean.types ['i']=some .i32 := by
    rw [clean_types,hs.types]
    rfl
  have hv : clean.values ['i']=some (.i32 (BitVec.ofNat 32 i)) := by
    rw [clean_values]
    simpa [update] using hs.index
  let next : B20.C.Scalar.State :=
    {clean with values := update clean.values ['i'] (.i32 (BitVec.ofNat 32 (i+1)))}
  refine ⟨next,?_,?_⟩
  · have hg := index_guard s i (by omega) hs.index
    have hr := round_execution s xu yu q hs.types hxu hyu hq
    have hc := index_inc clean i hi ht hv
    simp [oneStep,hg,hi,hr,next]
    exact hc
  · refine ⟨?_,?_,?_,?_,?_,?_,?_⟩
    · exact (clean_types s xu yu q).trans hs.types
    · obtain ⟨x,hx⟩ := hs.x
      exact ⟨x,by simp [next,clean,clean_values,update,hx]⟩
    · obtain ⟨y,hy⟩ := hs.y
      exact ⟨y,by simp [next,clean,clean_values,update,hy]⟩
    · exact ⟨nextX xu yu,by simp [next,clean,clean_values,update]⟩
    · exact ⟨yu,by simp [next,clean,clean_values,update,hyu]⟩
    · exact ⟨nextQ xu yu q,by simp [next,clean,clean_values,update]⟩
    · simp [next,update]

theorem iterations_total (s : B20.C.Scalar.State) (hs : Inv s 0) :
    ∀ n≤55, ∃ out,
      (List.range n).foldlM (fun acc _ => oneStep acc) s=some out ∧ Inv out n := by
  intro n
  induction n with
  | zero => intro _; exact ⟨s,rfl,hs⟩
  | succ n ih =>
      intro hn
      obtain ⟨mid,hm,him⟩ := ih (by omega)
      obtain ⟨out,ho,hio⟩ := one_step_total mid n (by omega) him
      refine ⟨out,?_,hio⟩
      simp [List.range_succ,List.foldlM_append,hm,ho]

end FT1536.Source3.FprDivLoopTotal

#print axioms FT1536.Source3.FprDivLoopTotal.iterations_total
