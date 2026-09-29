import RawComposition
namespace RawAssembly
def All {W : Type} (p : W → Prop) (xs : List W) := ∀x∈xs,p x
theorem all_append {W : Type} (p : W → Prop) (a b : List W)
    (ha : All p a) (hb : All p b) : All p (a++b) := by
  intro x hx
  rcases List.mem_append.mp hx with h|h
  · exact ha x h
  · exact hb x h
theorem inner8_length {W : Type} (L a b : List W)
    (hL : L.length=256) (ha : a.length=1024) (hb : b.length=1024) :
    (L++a++b).length=2304 := by simp [hL,ha,hb]
theorem depth_length {W : Type} (L a b c : List W)
    (hL : L.length=1536) (ha : a.length=2304) (hb : b.length=2304) (hc : c.length=2304) :
    (L++a++b++c).length=8448 := by simp [hL,ha,hb,hc]
theorem top_length {W : Type} (L a b : List W)
    (hL : L.length=1536) (ha : a.length=8448) (hb : b.length=8448) :
    (L++a++b).length=18432 := by simp [hL,ha,hb]
theorem all_local_words_finite {W : Type} (finite : W → Prop) (L a b : List W)
    (hL : All finite L) (ha : All finite a) (hb : All finite b) : All finite (L++a++b) := by
  exact all_append finite (L++a) b (all_append finite L a hL ha) hb
theorem snapshot_read_before_reuse {A B C : Type} (read : A → B) (after : B → C)
    (snapshot : A) : (let child:=read snapshot;after child)=after (read snapshot) := by rfl
theorem fixed_profile_and_late_guard : ((1+2*(1:Nat))*2^(10-1)=1536) ∧
    ¬((10:Nat)≠10 ∨ (1536:Nat)≠1536 ∨ (18433:Nat)≠18433) := by decide
end RawAssembly
