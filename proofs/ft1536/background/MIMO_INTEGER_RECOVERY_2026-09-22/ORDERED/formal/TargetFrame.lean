import TargetAlgebra
namespace InitialTarget
theorem target_frame {W : Type} (mem : Nat → W) (writes : List (Nat×W))
    (hw : ∀w∈writes,w.1<3072) : ∀i,3072≤i → RootLDL.runStores mem writes i=mem i := by
  induction writes generalizing mem with
  | nil => intro i _;rfl
  | cons w ws ih =>
    intro i hi
    have ht : ∀v∈ws,v.1<3072 := by intro v hv;exact hw v (by simp [hv])
    rw [RootLDL.runStores,ih (RootLDL.store mem w) ht i hi]
    have hne : i≠w.1 := by have h:=hw w (by simp);omega
    simp [RootLDL.store,hne]
theorem prefix_offsets : (3*2^9:Nat)=1536 ∧ (16*1536:Nat)=24576 ∧ (7*1536:Nat)=10752 ∧
    (2*1536:Nat)=3072 ∧ (3*1536:Nat)=4608 ∧ (4*1536:Nat)=6144 := by decide
theorem buffers_and_future_pointers : (3072:Nat)<10752 ∧ (4608:Nat)<10752 ∧ (6144:Nat)<10752 ∧
    (6144:Nat)<24576 ∧ (24576*8:Nat)<2147483647 := by decide
theorem target_read_write_indices (u : Nat) (hu : u<1536) :
    u<3072 ∧ 1536+u<3072 ∧ 1536+u<24576 ∧ 4608+u<24576 := by omega
theorem packed_indices (i : Nat) (hi : i<768) : i<1536 ∧ i+768<1536 ∧ i≠i+768 := by omega
theorem copy_disjoint (i j : Nat) (hi : i<1536) (hj : j<1536) : i≠1536+j := by omega
theorem whole_key_frame {W : Type} (mem : Nat → W) (writes : List (Nat×W))
    (hw : ∀w∈writes,w.1<3072) (i : Nat) :
    RootLDL.runStores mem writes (32768+i)=mem (32768+i) := by
  exact target_frame mem writes hw (32768+i) (by omega)
end InitialTarget
