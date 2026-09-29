import TowerExecution
set_option maxRecDepth 16384
namespace RawAssembly
def branch (b : Nat) := 1536+b*8448
def level8 (b k : Nat) := branch b+1536+k*2304
def inner7 (b k e : Nat) := level8 b k+256+e*1024
theorem allocation_sizes : (16*1536:Nat)=24576 ∧ (7*1536:Nat)=10752 ∧
    (24576*8:Nat)=196608 ∧ (10752*8:Nat)=86016 := by decide
theorem count_from_children : (256+2*Tower.words 6:Nat)=2304 ∧
    (1536+3*2304:Nat)=8448 ∧ (1536+2*8448:Nat)=18432 := by decide
theorem internal_leaf_counts : (1536+3072+1536+12*Tower.internal 6:Nat)=16896 ∧
    12*Tower.leaves 6=1536 ∧ (16896+1536:Nat)=18432 := by decide
theorem scratch_from_children : Tower.scratch 6≤256 ∧
    (256+256:Nat)=512 ∧ (1536+512:Nat)=2048 ∧ (1536+2048:Nat)=3584 ∧
    (4608+3584:Nat)=8192 ∧ (8192:Nat)<10752 := by decide
theorem branch_bounds (b : Nat) (hb : b<2) : 1536≤branch b ∧ branch b+8448≤18432 := by
  unfold branch;omega
theorem level8_bounds (b k : Nat) (hb : b<2) (hk : k<3) :
    branch b+1536≤level8 b k ∧ level8 b k+2304≤branch b+8448 ∧ level8 b k+2304≤18432 := by
  unfold level8 branch;omega
theorem inner7_bounds (b k e : Nat) (hb : b<2) (hk : k<3) (he : e<2) :
    level8 b k+256≤inner7 b k e ∧ inner7 b k e+1024≤level8 b k+2304 ∧ inner7 b k e+1024≤18432 := by
  unfold inner7 level8 branch;omega
theorem separate_branches : branch 0+8448=branch 1 := by decide
theorem separate_children (b k : Nat) : level8 b k+2304=level8 b (k+1) := by
  unfold level8;omega
theorem separate_inner7 (b k : Nat) : inner7 b k 0+1024=inner7 b k 1 := by
  unfold inner7;omega
theorem full_tree_partition (i : Nat) (hi : i<18432) :
    i<1536 ∨ (1536≤i ∧ i<9984) ∨ (9984≤i ∧ i<18432) := by omega
theorem depth_partition (b i : Nat) (hi : branch b≤i ∧ i<branch b+8448) :
    (branch b≤i ∧ i<branch b+1536) ∨
    (level8 b 0≤i ∧ i<level8 b 0+2304) ∨
    (level8 b 1≤i ∧ i<level8 b 1+2304) ∨
    (level8 b 2≤i ∧ i<level8 b 2+2304) := by
  unfold level8;omega
theorem level8_partition (b k i : Nat) (hi : level8 b k≤i ∧ i<level8 b k+2304) :
    (level8 b k≤i ∧ i<level8 b k+256) ∨
    (inner7 b k 0≤i ∧ i<inner7 b k 0+1024) ∨
    (inner7 b k 1≤i ∧ i<inner7 b k 1+1024) := by
  unfold inner7;omega
theorem packed_tree_offset (i : Nat) (hi : i<18432) : 6144≤6144+i ∧ 6144+i<24576 := by omega
theorem all_byte_offsets_fit : (196608:Nat)<2147483647 ∧ (86016:Nat)<2147483647 ∧
    (196608:Nat)<18446744073709551616 := by decide
theorem checked_coeff_fits_int16 (x : Int) (hx : -2047≤x ∧ x≤2047) :
    -32768≤x ∧ x≤32767 ∧ -2147483648≤x ∧ x≤2147483647 := by omega
-- Tagged flat addresses: K starts at0, S at32768, read-only coefficients at65536.
def treeStore (a : Nat) : Prop := (6144≤a ∧ a<24576) ∨ (37376≤a ∧ a<40960)
def keepAfterGram (a : Nat) : Prop := a<6144 ∨ (32768≤a ∧ a<37376) ∨ 65536≤a
theorem raw_tree_frame {α : Type} (mem : Nat → α) (ws : List (Nat×α))
    (h : ∀w∈ws,treeStore w.1) : ∀i,keepAfterGram i → Tower.stores mem ws i=mem i := by
  apply Tower.frame mem ws keepAfterGram
  intro w hw
  have ht:=h w hw
  unfold treeStore at ht
  unfold keepAfterGram
  omega
theorem depth_children_preserve_diagonals (read write : Nat)
    (hr : read<7168) (hw : 7680≤write) : read≠write := by omega
theorem inner_first_child_preserves_input (read write : Nat)
    (hr : read<7680) (hw : 7680≤write) : read≠write := by omega
theorem root_D_read_before_reuse_ranges : (6144+1536:Nat)=7680 ∧
    (4608+1536:Nat)=6144 ∧ (6144+512:Nat)=6656 ∧ (6656+512:Nat)=7168 := by decide
end RawAssembly
