import Complete
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Bridge
open FT1536Global

def u32 (x : Int) : Int := x%4294967296
def s16 (x : Int) : Int := (x+32768)%65536-32768
def s32 (x : Int) : Int := (x+2147483648)%4294967296-2147483648
def s64 (x : Int) : Int := (x+9223372036854775808)%18446744073709551616-9223372036854775808
def SignedVec (v : Vec) : Prop := ∀ i, FT1536.InInt16 (v i)

theorem s16_range (x : Int) : FT1536.InInt16 (s16 x) := by unfold s16 FT1536.InInt16; omega
theorem s16_exact (x : Int) (hx : FT1536.InInt16 x) : s16 x=x := by unfold s16 FT1536.InInt16 at *; omega
theorem s16_bits (x : Int) : s16 (x%65536)=s16 x := by unfold s16; omega
theorem s32_exact (x : Int) (hx : -2147483648≤x ∧ x≤2147483647) : s32 x=x := by unfold s32; omega
theorem s64_exact (x : Int) (hx : -9223372036854775808≤x ∧ x≤9223372036854775807) : s64 x=x := by unfold s64; omega
theorem u32_range (x : Int) : 0≤u32 x ∧ u32 x<4294967296 := by unfold u32; omega
theorem fromVec_signed (v : Vec) (hv : SignedVec v) (i : Nat) (hi : i<1536) : FT1536.InInt16 (fromVec v i) := by
  simpa only [fromVec,dite_eq_left hi] using hv ⟨i,hi⟩

-- uint32 subtraction, logical shift31, unsigned negation, bitwise AND q,
-- then the two signed casts occurring in source lines1429-1434.
def centerBorrow (d : Int) : Int := u32 (9216-d)/2147483648
def centerCorrection (d : Int) : Int :=
  Int.ofNat (18433 &&& (u32 (-centerBorrow d)).toNat)
def centerBeforeStore (d : Int) : Int := s32 d-s32 (centerCorrection d)
def centerC (d : Int) : Int := s16 (centerBeforeStore d)
def centerBits (d : Int) : Int := centerC d%65536

theorem center_borrow (d : Int) (hd : CanonVal d) : centerBorrow d=if d≤9216 then 0 else 1 := by
  unfold centerBorrow u32 CanonVal at *
  split <;> omega
theorem center_correction (d : Int) (hd : CanonVal d) : centerCorrection d=if d≤9216 then 0 else 18433 := by
  unfold centerCorrection
  rw [center_borrow d hd]
  split <;> decide

theorem CENTER_C (d : Int) (hd : CanonVal d) :
    centerBeforeStore d=FT1536.center d ∧ centerC d=FT1536.center d ∧
    -9216≤centerBeforeStore d ∧ centerBeforeStore d≤9216 := by
  have hc:=center_correction d hd
  have hd32 : s32 d=d := s32_exact d (by unfold CanonVal at hd; omega)
  have hbefore : centerBeforeStore d=FT1536.center d := by
    unfold centerBeforeStore
    rw [hd32,hc]
    by_cases h : d≤9216
    · simp only [ite_eq_left h]
      unfold s32 FT1536.center CanonVal at *
      omega
    · simp only [ite_eq_right h]
      unfold s32 FT1536.center CanonVal at *
      omega
  have hr : -9216≤FT1536.center d ∧ FT1536.center d≤9216 := by unfold FT1536.center; omega
  refine ⟨hbefore,?_,by omega,by omega⟩
  unfold centerC
  rw [hbefore,s16_exact _ (by unfold FT1536.InInt16; omega)]

theorem center_mod (x : Int) : FT1536.center (x%18433)=FT1536.center x := by unfold FT1536.center; omega
theorem center_congruence (x : Int) : (FT1536.center x-x)%18433=0 := by unfold FT1536.center; omega
theorem center_range (x : Int) : -9216≤FT1536.center x ∧ FT1536.center x≤9216 := by unfold FT1536.center; omega

def centerLoop (v : Vec) : Vec := fun i =>
  s16 (runSteps (pointStep (fun _ x => centerBits x)) 1536 (fromVec v) i.val)
theorem center_prefix (v : Vec) (n i : Nat) :
    runSteps (pointStep (fun _ x => centerBits x)) n (fromVec v) i=
      if i<n then centerBits (fromVec v i) else fromVec v i := point_prefix _ n _ i
theorem center_unread (v : Vec) (hv : CanonVec v) (n : Nat) (hn : n<1536) :
    runSteps (pointStep (fun _ x => centerBits x)) n (fromVec v) n=v ⟨n,hn⟩ ∧
    CanonVal (runSteps (pointStep (fun _ x => centerBits x)) n (fromVec v) n) := by
  rw [center_prefix]
  simp only [Nat.lt_irrefl,↓reduceIte,fromVec,dite_eq_left hn]
  exact ⟨rfl,hv ⟨n,hn⟩⟩
theorem center_loop_correct (v : Vec) (hv : CanonVec v) : centerLoop v=(fun i => FT1536.center (v i)) := by
  funext i
  unfold centerLoop
  rw [center_prefix]
  simp only [i.isLt,↓reduceIte,fromVec,↓reduceDIte,centerBits,s16_bits]
  rw [(CENTER_C (v i) (hv i)).2.1,s16_exact _ (by have hr:=center_range (v i);unfold FT1536.InInt16;omega)]

#check @CENTER_C
#check @center_loop_correct
#print axioms s16_range
#print axioms s16_exact
#print axioms s16_bits
#print axioms s32_exact
#print axioms s64_exact
#print axioms center_borrow
#print axioms center_correction
#print axioms CENTER_C
#print axioms center_mod
#print axioms center_congruence
#print axioms center_range
#print axioms center_prefix
#print axioms center_unread
#print axioms center_loop_correct
end FT1536Bridge
