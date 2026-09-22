import Stages
set_option maxRecDepth 16384
set_option maxHeartbeats 50000000
namespace FT1536Global

theorem fpair_canonical (p : Nat × Nat) (hp : ParamOK p) (s : Mem) (hs : CanonMem s) :
    CanonMem (pairStage (p.2/2) (forwardBinaryOp p.1 (p.2/2)) s) := by
  apply pair_prefix_canonical _ hp.1 _ _ 768 (by omega) s hs
  intro b hb v hv k; exact forwardBinaryOp_range _ _ _ _ _
theorem ipair_canonical (p : Nat × Nat) (hp : ParamOK p) (s : Mem) (hs : CanonMem s) :
    CanonMem (pairStage (p.2/2) (inverseBinaryOp p.1 (p.2/2)) s) := by
  apply pair_prefix_canonical _ hp.1 _ _ 768 (by omega) s hs
  intro b hb v hv k; exact inverseBinaryOp_range _ _ _ _ _
theorem froot_canonical (s : Mem) (hs : CanonMem s) : CanonMem (pairStage 768 forwardRootOp s) := by
  apply pair_prefix_canonical _ (by simp [HalfOK]) _ _ 768 (by omega) s hs
  intro b hb v hv k; exact forwardRootOp_range _ _ _

theorem pair_source_inverse (p : Nat × Nat) (hp : ParamOK p) (s : Mem) (hs : CanonMem s) :
    pairStage (p.2/2) (inverseBinaryOp p.1 (p.2/2))
      (pairStage (p.2/2) (forwardBinaryOp p.1 (p.2/2)) s)=scaleMem 2 s := by
  apply pair_stage_inverse _ hp.1 _ _ 2 _ s hs
  intro b hb v hv k
  exact binary_inverse _ _ b (hp.2 b hb).1 (hp.2 b hb).2 v hv k
theorem pair_source_homogeneous (p : Nat × Nat) (hp : ParamOK p) (c : Int) (s : Mem) (hs : CanonMem s) :
    pairStage (p.2/2) (inverseBinaryOp p.1 (p.2/2)) (scaleMem c s)=
      scaleMem c (pairStage (p.2/2) (inverseBinaryOp p.1 (p.2/2)) s) := by
  apply pair_stage_homogeneous _ hp.1 _ c _ s hs
  intro b hb v hv k; exact binary_homogeneous _ _ b c v hv k
theorem root_source_inverse (s : Mem) (hs : CanonMem s) :
    pairStage 768 inverseRootOp (pairStage 768 forwardRootOp s)=scaleMem 2 s := by
  apply pair_stage_inverse _ (by simp [HalfOK]) _ _ 2 _ s hs
  intro b hb v hv k; exact root_inverse b v hv k
theorem root_source_homogeneous (c : Int) (s : Mem) (hs : CanonMem s) :
    pairStage 768 inverseRootOp (scaleMem c s)=scaleMem c (pairStage 768 inverseRootOp s) := by
  apply pair_stage_homogeneous _ (by simp [HalfOK]) _ c _ s hs
  intro b hb v hv k; exact root_homogeneous b c v hv k
theorem cubic_source_inverse (s : Mem) (hs : CanonMem s) :
    tripleStage inverseCubicOp (tripleStage forwardCubicOp s)=scaleMem 3 s :=
  triple_stage_inverse _ _ 3 cubic_inverse s hs

theorem inverse_append (ps qs : List (Nat × Nat)) (s : Mem) :
    inverseMiddle (ps++qs) s=inverseMiddle qs (inverseMiddle ps s) := by
  induction ps generalizing s with
  | nil => rfl
  | cons p ps ih => simpa only [List.cons_append,inverseMiddle] using ih (pairStage (p.2/2) (inverseBinaryOp p.1 (p.2/2)) s)

theorem middle_homogeneous (ps : List (Nat × Nat)) (hp : ∀ p, p∈ps → ParamOK p)
    (c : Int) (s : Mem) (hs : CanonMem s) :
    inverseMiddle ps (scaleMem c s)=scaleMem c (inverseMiddle ps s) := by
  induction ps generalizing s with
  | nil => rfl
  | cons p ps ih =>
    have hhead:=hp p (by simp)
    have htail : ∀ a, a∈ps → ParamOK a := fun a ha => hp a (List.mem_cons_of_mem p ha)
    change inverseMiddle ps (pairStage (p.2/2) (inverseBinaryOp p.1 (p.2/2)) (scaleMem c s))=_
    rw [pair_source_homogeneous p hhead c s hs,ih htail _ (ipair_canonical p hhead s hs)]
    rfl

theorem middle_reverse_inverse (ps : List (Nat × Nat)) (hp : ∀ p, p∈ps → ParamOK p)
    (s : Mem) (hs : CanonMem s) :
    inverseMiddle ps.reverse (forwardMiddle ps s)=scaleMem ((2:Int)^ps.length) s := by
  induction ps generalizing s with
  | nil => exact (scale_one s hs).symm
  | cons p ps ih =>
    have hhead:=hp p (by simp)
    have htail : ∀ a, a∈ps → ParamOK a := fun a ha => hp a (List.mem_cons_of_mem p ha)
    have hforward:=fpair_canonical p hhead s hs
    rw [List.reverse_cons,inverse_append]
    change pairStage (p.2/2) (inverseBinaryOp p.1 (p.2/2))
      (inverseMiddle ps.reverse (forwardMiddle ps (pairStage (p.2/2) (forwardBinaryOp p.1 (p.2/2)) s)))=_
    rw [ih htail _ hforward,pair_source_homogeneous p hhead _ _ hforward,pair_source_inverse p hhead s hs,scale_combine]
    simp only [List.length_cons,Int.pow_succ]

theorem inverseMem_forwardMem (s : Mem) (hs : CanonMem s) : inverseMem (forwardMem s)=s := by
  have hr:=froot_canonical s hs
  have hm:=forwardMiddle_canonical _ forward_params_half _ hr
  have hrev : ∀ p, p∈inverseSchedule 9 256 6 → ParamOK p := by
    intro p hp
    rw [schedules_reverse,List.mem_reverse] at hp
    exact forward_params_ok p hp
  unfold forwardMem inverseMem
  change runSteps scaleStep 1536 (pairStage 768 inverseRootOp
    (inverseMiddle (inverseSchedule 9 256 6)
      (tripleStage inverseCubicOp (tripleStage forwardCubicOp
        (forwardMiddle (forwardSchedule 9 2 768) (pairStage 768 forwardRootOp s))))))=s
  rw [cubic_source_inverse _ hm,middle_homogeneous _ hrev 3 _ hm,schedules_reverse,
    middle_reverse_inverse _ forward_params_ok _ hr]
  have hlen : (forwardSchedule 9 2 768).length=8 := by rw [forward_schedule]; rfl
  rw [hlen,scale_combine]
  change runSteps scaleStep 1536 (pairStage 768 inverseRootOp (scaleMem 768 (pairStage 768 forwardRootOp s)))=s
  rw [root_source_homogeneous 768 _ hr,root_source_inverse s hs,scale_combine]
  change runSteps scaleStep 1536 (scaleMem 1536 s)=s
  rw [scale_loop,scale_cancel s hs]

theorem forwardMiddle_out (ps : List (Nat × Nat)) (hp : ∀ p, p∈ps → HalfOK (p.2/2))
    (s : Mem) (i : Nat) (hi : ¬i<1536) : forwardMiddle ps s i=s i := by
  induction ps generalizing s with
  | nil => rfl
  | cons p ps ih =>
    change forwardMiddle ps (pairStage (p.2/2) (forwardBinaryOp p.1 (p.2/2)) s) i=s i
    rw [ih (fun a ha => hp a (List.mem_cons_of_mem p ha)),pair_stage_out _ (hp p (by simp)) _ s i hi]
theorem forward_out (s : Mem) (i : Nat) (hi : ¬i<1536) : forwardMem s i=s i := by
  unfold forwardMem
  change tripleStage forwardCubicOp (forwardMiddle (forwardSchedule 9 2 768) (pairStage 768 forwardRootOp s)) i=s i
  rw [triple_stage_out _ _ i hi,forwardMiddle_out _ forward_params_half _ i hi,pair_stage_out 768 (by simp [HalfOK]) _ s i hi]

theorem forward_from_to (v : Vec) : fromVec (forwardC v)=forwardMem (fromVec v) := by
  funext i
  by_cases hi : i<1536
  · simp only [fromVec,hi,↓reduceDIte,forwardC,toVec]
  · rw [forward_out _ i hi]
    simp [fromVec,hi]

theorem inverseC_forwardC (v : Vec) (hv : CanonVec v) : inverseC (forwardC v)=v := by
  unfold inverseC
  rw [forward_from_to,inverseMem_forwardMem _ (fromVec_canonical v hv)]
  funext i
  simp [toVec,fromVec,i.isLt]

theorem canonicalVec (v : Vec) : CanonVec (FT1536Composition.canonical v) := by
  intro i; unfold CanonVal FT1536Composition.canonical; omega
theorem inverse_forward (v : Vec) : liftInverse (liftForward v)=FT1536Composition.canonical v := by
  unfold liftForward liftInverse
  rw [canonical_fixed _ (forwardC_canonical _ (canonicalVec v))]
  exact inverseC_forwardC _ (canonicalVec v)

#check @middle_reverse_inverse
#check @inverseMem_forwardMem
#check @inverseC_forwardC
#check @inverse_forward
#print axioms pair_source_inverse
#print axioms root_source_inverse
#print axioms cubic_source_inverse
#print axioms middle_homogeneous
#print axioms middle_reverse_inverse
#print axioms inverseMem_forwardMem
#print axioms forward_from_to
#print axioms inverseC_forwardC
#print axioms inverse_forward
end FT1536Global
