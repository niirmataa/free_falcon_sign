import LocalInverse
set_option maxRecDepth 16384
set_option maxHeartbeats 30000000
namespace FT1536Global
abbrev PairOp := Nat → (Bool → Int) → Bool → Int
abbrev TripleOp := Nat → (Fin 3 → Int) → Fin 3 → Int
abbrev pairStage (h : Nat) (op : PairOp) (s : Mem) : Mem := runSteps (pairStep (pairAddr h) op) 768 s
abbrev tripleStage (op : TripleOp) (s : Mem) : Mem := runSteps (tripleStep tripleAddr op) 512 s
def scaleMem (c : Int) (s : Mem) : Mem := fun i => if i<1536 then (c*s i)%18433 else s i

theorem scale_at (c : Int) (s : Mem) (i : Nat) (hi : i<1536) : scaleMem c s i=(c*s i)%18433 := by simp [scaleMem,hi]
theorem scale_out (c : Int) (s : Mem) (i : Nat) (hi : ¬i<1536) : scaleMem c s i=s i := by simp [scaleMem,hi]
theorem scale_range (c : Int) (s : Mem) : CanonMem (scaleMem c s) := by
  intro i hi; rw [scale_at c s i hi]; omega
theorem scale_combine (c d : Int) (s : Mem) : scaleMem c (scaleMem d s)=scaleMem (c*d) s := by
  funext i
  by_cases hi : i<1536
  · simp [scaleMem,hi,Int.mul_emod,Int.mul_assoc]
  · simp [scaleMem,hi]
theorem scale_one (s : Mem) (hs : CanonMem s) : scaleMem 1 s=s := by
  funext i
  by_cases hi : i<1536
  · have h:=hs i hi
    simp [scaleMem,hi,Int.emod_eq_of_lt h.1 h.2]
  · simp [scaleMem,hi]

theorem pair_stage_at (h : Nat) (hh : HalfOK h) (op : PairOp) (s : Mem) (b : Nat) (hb : b<768) (k : Bool) :
    pairStage h op s (pairAddr h b k)=op b (fun l => s (pairAddr h b l)) k := by
  rw [source_pair_prefix h hh op 768 (by omega) s b hb k,ite_eq_left hb]
theorem triple_stage_at (op : TripleOp) (s : Mem) (b : Nat) (hb : b<512) (k : Fin 3) :
    tripleStage op s (tripleAddr b k)=op b (fun l => s (tripleAddr b l)) k := by
  rw [source_triple_prefix op 512 (by omega) s b hb k,ite_eq_left hb]
theorem pair_stage_out (h : Nat) (hh : HalfOK h) (op : PairOp) (s : Mem) (i : Nat) (hi : ¬i<1536) :
    pairStage h op s i=s i := by
  apply prefix_frame 768 (pairAddr h) (pairStep (pairAddr h) op)
  · intro b hb st j away; exact pair_frame _ _ _ _ _ away
  · omega
  · intro b hb k he
    have hbound:=pair_address_bound h b hh hb k
    omega
theorem triple_stage_out (op : TripleOp) (s : Mem) (i : Nat) (hi : ¬i<1536) : tripleStage op s i=s i := by
  apply prefix_frame 512 tripleAddr (tripleStep tripleAddr op)
  · intro b hb st j away; exact triple_frame _ _ _ _ _ away
  · omega
  · intro b hb k he
    have hbound:=triple_address_bound b hb k
    omega

theorem pair_stage_inverse (h : Nat) (hh : HalfOK h) (f g : PairOp) (c : Int)
    (localInv : ∀ b, b<768 → ∀ v, (∀ k, CanonVal (v k)) → ∀ k, g b (f b v) k=(c*v k)%18433)
    (s : Mem) (hs : CanonMem s) : pairStage h g (pairStage h f s)=scaleMem c s := by
  funext i
  by_cases hi : i<1536
  · obtain ⟨hb,cover⟩:=pair_cover h i hh hi
    rw [←cover,pair_stage_at h hh g _ _ hb]
    have hf : (fun l => pairStage h f s (pairAddr h (pairBlock h i) l))=
        f (pairBlock h i) (fun l => s (pairAddr h (pairBlock h i) l)) := by
      funext l; exact pair_stage_at h hh f s _ hb l
    rw [hf,localInv _ hb _ (fun k => hs _ (pair_address_bound h _ hh hb k))]
    rw [scale_at c s _ (pair_address_bound h _ hh hb _)]
  · rw [pair_stage_out h hh g _ i hi,pair_stage_out h hh f s i hi,scale_out c s i hi]

theorem triple_stage_inverse (f g : TripleOp) (c : Int)
    (localInv : ∀ b, b<512 → ∀ v, (∀ k, CanonVal (v k)) → ∀ k, g b (f b v) k=(c*v k)%18433)
    (s : Mem) (hs : CanonMem s) : tripleStage g (tripleStage f s)=scaleMem c s := by
  funext i
  by_cases hi : i<1536
  · obtain ⟨hb,cover⟩:=triple_cover i hi
    rw [←cover,triple_stage_at g _ _ hb]
    have hf : (fun l => tripleStage f s (tripleAddr (i/3) l))=f (i/3) (fun l => s (tripleAddr (i/3) l)) := by
      funext l; exact triple_stage_at f s _ hb l
    rw [hf,localInv _ hb _ (fun k => hs _ (triple_address_bound _ hb k))]
    rw [scale_at c s _ (triple_address_bound _ hb _)]
  · rw [triple_stage_out g _ i hi,triple_stage_out f s i hi,scale_out c s i hi]

theorem pair_stage_homogeneous (h : Nat) (hh : HalfOK h) (g : PairOp) (c : Int)
    (localHom : ∀ b, b<768 → ∀ v, (∀ k, CanonVal (v k)) → ∀ k,
      g b (fun j => (c*v j)%18433) k=(c*g b v k)%18433)
    (s : Mem) (hs : CanonMem s) : pairStage h g (scaleMem c s)=scaleMem c (pairStage h g s) := by
  funext i
  by_cases hi : i<1536
  · obtain ⟨hb,cover⟩:=pair_cover h i hh hi
    rw [←cover,pair_stage_at h hh g _ _ hb,scale_at c _ _ (pair_address_bound h _ hh hb _),pair_stage_at h hh g _ _ hb]
    have hv : (fun l => scaleMem c s (pairAddr h (pairBlock h i) l))=
        (fun l => (c*s (pairAddr h (pairBlock h i) l))%18433) := by
      funext l; exact scale_at c s _ (pair_address_bound h _ hh hb l)
    rw [hv]
    exact localHom _ hb _ (fun k => hs _ (pair_address_bound h _ hh hb k)) _
  · rw [pair_stage_out h hh g _ i hi,scale_out c s i hi,scale_out c _ i hi,pair_stage_out h hh g s i hi]

def pointStep (op : Nat → Int → Int) (i : Nat) (s : Mem) : Mem := store s i (op i (s i))
theorem point_prefix (op : Nat → Int → Int) (n : Nat) (s : Mem) (i : Nat) :
    runSteps (pointStep op) n s i=if i<n then op i (s i) else s i := by
  induction n with
  | zero => simp [runSteps]
  | succ n ih =>
    by_cases he : i=n
    · subst i
      simp [runSteps,pointStep,store,ih]
    · rw [runSteps]
      change store (runSteps (pointStep op) n s) n _ i=_
      rw [store_away _ n i _ he,ih]
      by_cases hl : i<n
      · have hl1 : i<n+1 := by omega
        simp [hl,hl1]
      · have hl1 : ¬i<n+1 := by omega
        simp [hl,hl1]

theorem scale_loop (s : Mem) : runSteps scaleStep 1536 s=scaleMem 18421 s := by
  funext i
  have h:=point_prefix (fun _ x => mmQ x 6187) 1536 s i
  change runSteps scaleStep 1536 s i=(if i<1536 then mmQ (s i) 6187 else s i) at h
  rw [h]
  unfold scaleMem
  split
  · unfold mmQ; omega
  · rfl

theorem scale_cancel (s : Mem) (hs : CanonMem s) : scaleMem 18421 (scaleMem 1536 s)=s := by
  funext i
  by_cases hi : i<1536
  · rw [scale_at _ _ i hi,scale_at _ _ i hi,Int.mul_comm 18421,FT1536Linear.final_scaling]
    exact Int.emod_eq_of_lt (hs i hi).1 (hs i hi).2
  · rw [scale_out _ _ i hi,scale_out _ _ i hi]

#check @pair_stage_inverse
#check @triple_stage_inverse
#check @pair_stage_homogeneous
#check @point_prefix
#print axioms scale_combine
#print axioms scale_one
#print axioms pair_stage_at
#print axioms triple_stage_at
#print axioms pair_stage_out
#print axioms triple_stage_out
#print axioms pair_stage_inverse
#print axioms triple_stage_inverse
#print axioms pair_stage_homogeneous
#print axioms point_prefix
#print axioms scale_loop
#print axioms scale_cancel
end FT1536Global
