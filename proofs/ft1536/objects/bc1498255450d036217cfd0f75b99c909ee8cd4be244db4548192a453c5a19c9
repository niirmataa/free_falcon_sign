import StableBits
namespace StableNorm
def leafPos : Nat → Nat → List Nat
  | 0,off => [off+2,off+3]
  | d+1,off => leafPos d (off+2^(d+2)) ++ leafPos d (off+2^(d+2)+Tower.words d)
def onlyLeaf : Tower.Event → Option Nat
  | .leaf i => some i
  | _ => none
theorem normalized_raw_leaf_map (d off : Nat) : leafPos d off=(Tower.trace d off).filterMap onlyLeaf := by
  induction d generalizing off with
  | zero => simp [leafPos,Tower.trace,onlyLeaf]
  | succ d ih => simp [leafPos,Tower.trace,onlyLeaf,ih]
theorem leaf_count (d off : Nat) : (leafPos d off).length=Tower.leaves d := by
  induction d generalizing off with
  | zero => rfl
  | succ d ih => simp [leafPos,Tower.leaves,ih,Nat.two_mul]
theorem leaf_position_range (d off i : Nat) (hi : i∈leafPos d off) : off≤i ∧ i<off+Tower.words d := by
  induction d generalizing off with
  | zero => simp only [leafPos,List.mem_cons,List.mem_singleton] at hi;rcases hi with h|h <;> subst i <;> simp [Tower.words] <;> omega
  | succ d ih =>
    simp only [leafPos,List.mem_append] at hi
    rcases hi with h|h
    · have hp:=ih _ h;simp only [Tower.words];omega
    · have hp:=ih _ h;simp only [Tower.words];omega
def fullMap : List Nat :=
  leafPos 7 3072 ++ leafPos 7 5376 ++ leafPos 7 7680 ++
  leafPos 7 11520 ++ leafPos 7 13824 ++ leafPos 7 16128
theorem full_count : fullMap.length=1536 := by simp [fullMap,leaf_count,Tower.leaves]
theorem full_map_range (i : Nat) (h : i∈fullMap) : i<18432 := by
  simp only [fullMap,List.mem_append] at h
  rcases h with h|h|h|h|h|h
  all_goals
    have q:=leaf_position_range 7 _ i h
    rw [show Tower.words 7=2304 by decide] at q
    omega
theorem normalized_frame {W : Type} (mem : Nat → W) (writes : List (Nat×W))
    (hw : ∀w∈writes,∃i∈fullMap,w.1=6144+i) :
    ∀a,(∀i∈fullMap,a≠6144+i) → Tower.stores mem writes a=mem a := by
  apply Tower.frame mem writes
  intro w h
  obtain ⟨i,hi,he⟩:=hw w h
  intro hk;exact hk i hi he
theorem basis_preserved {W : Type} (mem : Nat → W) (writes : List (Nat×W))
    (hw : ∀w∈writes,∃i∈fullMap,w.1=6144+i) :
    ∀a,a<6144 → Tower.stores mem writes a=mem a := by
  intro a ha;apply normalized_frame mem writes hw a
  intro i _;omega
theorem reverse_reciprocal_disjoint (i : Nat) (hi : i<768) :
    768≤1535-i ∧ 1535-i<1536 ∧ i<1535-i := by omega
theorem reverse_reciprocal_injective (i j : Nat) (hi : i<768) (hj : j<768)
    (h : 1535-i=1535-j) : i=j := by omega
theorem stable_tmp_ranges : (768+1536:Nat)=2304 ∧ (2304+256:Nat)=2560 ∧
    (2*1536:Nat)=3072 ∧ (3072:Nat)<10752 := by decide
theorem scalar_calls_count : (2*1536:Nat)=3072 := by decide
end StableNorm
