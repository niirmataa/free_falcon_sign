import BlockChecks
set_option maxRecDepth 16384
set_option maxHeartbeats 30000000
namespace FT1536Global

theorem local_at (i : Nat) (hi0 : 0<i) (hi : i<1024) :
    blockCheck (binFExpr (gmAt i)) (binIExpr (igmAt i)) 2=true ∧
    blockCheck (cubeFExpr (gmAt i) fW) (cubeIExpr (igmAt i) iW) 3=true := by
  have h := FT1536Tables.all_sound _ _ local_checked (unitRow ⟨i,hi⟩) (List.get_mem _ _)
  have hn : rowID (unitRow ⟨i,hi⟩)≠0 := by rw [unitRow_id]; change (i : Int)≠0; omega
  simpa only [localCheck,ite_eq_right hn,Bool.and_eq_true,gmAt,igmAt,dite_eq_left hi,gm,igm] using h

theorem pairInput_slot (v : Bool → Int) (k : Bool) : pairInput v (slot k)=v k := by cases k <;> rfl
theorem pairInput_canonical (v : Bool → Int) (hv : ∀ k, CanonVal (v k)) : ∀ j, CanonVal (pairInput v j) := by
  intro j
  rcases fin3_cases j with rfl|rfl|rfl
  · exact hv false
  · exact hv true
  · simp [pairInput,CanonVal]

theorem root_inverse (b : Nat) (v : Bool → Int) (hv : ∀ k, CanonVal (v k)) (k : Bool) :
    inverseRootOp b (forwardRootOp b v) k=(2*v k)%18433 := by
  have h:=blockCheck_sound _ _ 2 root_checked (pairInput v) (pairInput_canonical v hv) (slot k)
  simpa only [rootI_bind b,rootF_bind b,pairInput_slot] using h
theorem binary_inverse (m ht b : Nat) (hi0 : 0<m+b/ht) (hi : m+b/ht<1024)
    (v : Bool → Int) (hv : ∀ k, CanonVal (v k)) (k : Bool) :
    inverseBinaryOp m ht b (forwardBinaryOp m ht b v) k=(2*v k)%18433 := by
  have h:=blockCheck_sound _ _ 2 (local_at (m+b/ht) hi0 hi).1 (pairInput v) (pairInput_canonical v hv) (slot k)
  simpa only [binI_bind m ht b,binF_bind m ht b,pairInput_slot] using h
theorem cubic_inverse (b : Nat) (hb : b<512) (v : Fin 3 → Int) (hv : ∀ k, CanonVal (v k)) (k : Fin 3) :
    inverseCubicOp b (forwardCubicOp b v) k=(3*v k)%18433 := by
  have h:=blockCheck_sound _ _ 3 (local_at (512+b) (by omega) (by omega)).2 v hv k
  simpa only [cubeI_bind,cubeF_bind] using h

theorem root_homogeneous (b : Nat) (c : Int) (v : Bool → Int) (hv : ∀ k, CanonVal (v k)) (k : Bool) :
    inverseRootOp b (fun j => (c*v j)%18433) k=(c*inverseRootOp b v k)%18433 := by
  have h:=eval_scaled (rootIExpr (igmAt 0) (slot k)) c (pairInput v) (pairInput_canonical v hv)
  simpa only [rootI_bind b,scaled3,pairInput_slot] using h
theorem binary_homogeneous (m ht b : Nat) (c : Int) (v : Bool → Int) (hv : ∀ k, CanonVal (v k)) (k : Bool) :
    inverseBinaryOp m ht b (fun j => (c*v j)%18433) k=(c*inverseBinaryOp m ht b v k)%18433 := by
  have h:=eval_scaled (binIExpr (igmAt (m+b/ht)) (slot k)) c (pairInput v) (pairInput_canonical v hv)
  simpa only [binI_bind m ht b,scaled3,pairInput_slot] using h
theorem cubic_homogeneous (b : Nat) (c : Int) (v : Fin 3 → Int) (hv : ∀ k, CanonVal (v k)) (k : Fin 3) :
    inverseCubicOp b (fun j => (c*v j)%18433) k=(c*inverseCubicOp b v k)%18433 := by
  have h:=eval_scaled (cubeIExpr (igmAt (512+b)) iW k) c v hv
  rw [cubeI_bind,cubeI_bind] at h
  exact h

def ParamOK (p : Nat × Nat) : Prop := HalfOK (p.2/2) ∧
  ∀ b, b<768 → 0<p.1+b/(p.2/2) ∧ p.1+b/(p.2/2)<1024
theorem forward_params_ok : ∀ p, p∈forwardSchedule 9 2 768 → ParamOK p := by
  intro p hp
  constructor
  · exact forward_params_half p hp
  · rw [forward_schedule] at hp
    simp only [List.mem_cons,List.not_mem_nil,or_false] at hp
    rcases hp with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl <;> intro b hb <;> dsimp <;> omega
theorem schedules_reverse : inverseSchedule 9 256 6=(forwardSchedule 9 2 768).reverse := by
  rw [forward_schedule,inverse_schedule]
  rfl

#check @root_inverse
#check @binary_inverse
#check @cubic_inverse
#print axioms local_at
#print axioms root_inverse
#print axioms binary_inverse
#print axioms cubic_inverse
#print axioms root_homogeneous
#print axioms binary_homogeneous
#print axioms cubic_homogeneous
#print axioms forward_params_ok
#print axioms schedules_reverse
end FT1536Global
