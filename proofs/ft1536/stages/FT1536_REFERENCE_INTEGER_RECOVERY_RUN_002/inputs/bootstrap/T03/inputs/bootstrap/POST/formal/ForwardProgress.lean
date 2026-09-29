import InverseGlobal
set_option maxRecDepth 16384
set_option maxHeartbeats 30000000
namespace FT1536Global
def ordinary (w : Int) : Int := (w*5184)%18433
theorem mmQ_ordinary (x w : Int) : mmQ x w=(x*ordinary w)%18433 := by
  simp [mmQ,ordinary,Int.mul_emod,Int.mul_assoc]
theorem ordinary_root : ordinary (gmAt 1)=14649 := by decide

theorem root_coefficients (s : Mem) (i : Nat) (hi : i<768) :
    pairStage 768 forwardRootOp s i=(s i+14649*s (i+768))%18433 ∧
    pairStage 768 forwardRootOp s (i+768)=(s i+(1-14649)*s (i+768))%18433 := by
  have ha : pairAddr 768 i false=i := by unfold pairAddr; simp; omega
  have hb : pairAddr 768 i true=i+768 := by unfold pairAddr; simp; omega
  have h0:=pair_stage_at 768 (by simp [HalfOK]) forwardRootOp s i hi false
  have h1:=pair_stage_at 768 (by simp [HalfOK]) forwardRootOp s i hi true
  have hmul : mmQ (s (i+768)) (gmAt 1)=(14649*s (i+768))%18433 := by
    rw [mmQ_ordinary,ordinary_root,Int.mul_comm]
  constructor
  · simpa only [ha,hb,forwardRootOp,Bool.false_eq_true,↓reduceIte,hmul,addQ,Int.add_emod,Int.emod_emod] using h0
  · simp only [ha,hb,forwardRootOp,↓reduceIte,hmul,addQ,subQ] at h1
    rw [h1]
    omega

-- One complete binary stage, in actual physical addresses. This is a
-- coefficient-level split; it does not assume or assert the missing global CRT invariant.
theorem binary_coefficients (h m : Nat) (hh : HalfOK h) (s : Mem) (b : Nat) (hb : b<768) :
    pairStage h (forwardBinaryOp m h) s (pairAddr h b false)=
      (s (pairAddr h b false)+s (pairAddr h b true)*ordinary (gmAt (m+b/h)))%18433 ∧
    pairStage h (forwardBinaryOp m h) s (pairAddr h b true)=
      (s (pairAddr h b false)-s (pairAddr h b true)*ordinary (gmAt (m+b/h)))%18433 := by
  constructor
  · rw [pair_stage_at h hh _ s b hb false]
    unfold forwardBinaryOp
    simp only [Bool.false_eq_true,↓reduceIte,mmQ_ordinary,addQ,Int.add_emod,Int.emod_emod]
  · rw [pair_stage_at h hh _ s b hb true]
    unfold forwardBinaryOp
    simp only [↓reduceIte,mmQ_ordinary,subQ,Int.sub_emod,Int.emod_emod]

theorem initialized_binary_read (p : Nat × Nat) (hp : ParamOK p) (b : Nat) (hb : b<768) (k : Bool) :
    pairAddr (p.2/2) b k<1536 ∧ 0<p.1+b/(p.2/2) ∧ p.1+b/(p.2/2)<1024 :=
  ⟨pair_address_bound _ b hp.1 hb k,hp.2 b hb⟩
theorem initialized_cubic_read (b : Nat) (hb : b<512) (k : Fin 3) :
    tripleAddr b k<1536 ∧ 512+b<1024 := ⟨triple_address_bound b hb k,by omega⟩

#check @root_coefficients
#check @binary_coefficients
#print axioms mmQ_ordinary
#print axioms ordinary_root
#print axioms root_coefficients
#print axioms binary_coefficients
#print axioms initialized_binary_read
#print axioms initialized_cubic_read
end FT1536Global
