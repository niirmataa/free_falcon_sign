import Buffer
set_option maxRecDepth 8192
set_option maxHeartbeats 20000000

namespace FT1536Global
def HalfOK (h : Nat) : Prop :=
  h=768 ∨ h=384 ∨ h=192 ∨ h=96 ∨ h=48 ∨ h=24 ∨ h=12 ∨ h=6 ∨ h=3
def pairAddr (h b : Nat) (k : Bool) : Nat :=
  (b/h)*(2*h) + b%h + if k then h else 0
def pairBlock (h i : Nat) : Nat := (i/(2*h))*h + i%h
def pairSide (h i : Nat) : Bool := decide (h ≤ i%(2*h))

theorem pair_address_bound (h b : Nat) (hh : HalfOK h) (hb : b<768) (k : Bool) :
    pairAddr h b k < 1536 := by
  rcases hh with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl <;>
    cases k <;> simp only [pairAddr, Bool.false_eq_true, ↓reduceIte] <;> omega

theorem pair_decode (h b : Nat) (hh : HalfOK h) (k : Bool) :
    pairBlock h (pairAddr h b k)=b ∧ pairSide h (pairAddr h b k)=k := by
  rcases hh with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl <;>
    cases k <;> simp [pairAddr,pairBlock,pairSide] <;> omega

theorem pair_cover (h i : Nat) (hh : HalfOK h) (hi : i<1536) :
    pairBlock h i < 768 ∧ pairAddr h (pairBlock h i) (pairSide h i)=i := by
  by_cases hs : h ≤ i%(2*h)
  all_goals
    rcases hh with rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl|rfl <;>
      simp [pairAddr,pairBlock,pairSide,hs] <;> omega

theorem pair_layout (h : Nat) (hh : HalfOK h) (b c : Nat) (k l : Bool)
    (eq : pairAddr h b k=pairAddr h c l) : b=c ∧ k=l := by
  have x := congrArg (pairBlock h) eq
  have y := congrArg (pairSide h) eq
  rw [(pair_decode h b hh k).1, (pair_decode h c hh l).1] at x
  rw [(pair_decode h b hh k).2, (pair_decode h c hh l).2] at y
  exact ⟨x,y⟩

theorem source_pair_prefix (h : Nat) (hh : HalfOK h)
    (op : Nat → (Bool → Int) → Bool → Int) (n : Nat) (hn : n≤768)
    (s : Mem) (b : Nat) (hb : b<768) (k : Bool) :
    runSteps (pairStep (pairAddr h) op) n s (pairAddr h b k)=
      if b<n then op b (fun l => s (pairAddr h b l)) k else s (pairAddr h b k) := by
  apply pair_prefix 768 (pairAddr h) op
  · intro j hj c hc k l eq
    exact pair_layout h hh j c k l eq
  · exact hn
  · exact hb

def tripleAddr (b : Nat) (k : Fin 3) : Nat := 3*b+k.val
theorem triple_address_bound (b : Nat) (hb : b<512) (k : Fin 3) : tripleAddr b k<1536 := by
  have hk := k.isLt
  unfold tripleAddr
  omega

theorem triple_layout (b c : Nat) (k l : Fin 3) (eq : tripleAddr b k=tripleAddr c l) : b=c ∧ k=l := by
  have hk := k.isLt
  have hl := l.isLt
  unfold tripleAddr at eq
  constructor
  · omega
  · apply Fin.ext
    omega

theorem triple_cover (i : Nat) (hi : i<1536) :
    i/3<512 ∧ tripleAddr (i/3) ⟨i%3, by omega⟩=i := by
  change i/3<512 ∧ 3*(i/3)+i%3=i
  omega

theorem source_triple_prefix (op : Nat → (Fin 3 → Int) → Fin 3 → Int)
    (n : Nat) (hn : n≤512) (s : Mem) (b : Nat) (hb : b<512) (k : Fin 3) :
    runSteps (tripleStep tripleAddr op) n s (tripleAddr b k)=
      if b<n then op b (fun l => s (tripleAddr b l)) k else s (tripleAddr b k) := by
  apply triple_prefix 512 tripleAddr op
  · intro j hj c hc k l eq
    exact triple_layout j c k l eq
  · exact hn
  · exact hb

def CanonMem (s : Mem) : Prop := ∀ i, i<1536 → 0≤s i ∧ s i<18433

theorem pair_prefix_canonical (h : Nat) (hh : HalfOK h)
    (op : Nat → (Bool → Int) → Bool → Int)
    (hop : ∀ b, b<768 → ∀ v, (∀ k, 0≤v k ∧ v k<18433) → ∀ k, 0≤op b v k ∧ op b v k<18433)
    (n : Nat) (hn : n≤768) (s : Mem) (hs : CanonMem s) :
    CanonMem (runSteps (pairStep (pairAddr h) op) n s) := by
  intro i hi
  obtain ⟨hb,cover⟩ := pair_cover h i hh hi
  rw [←cover, source_pair_prefix h hh op n hn s (pairBlock h i) hb (pairSide h i)]
  split
  · apply hop _ hb
    intro k
    exact hs _ (pair_address_bound h _ hh hb k)
  · exact hs _ (pair_address_bound h _ hh hb _)

theorem triple_prefix_canonical
    (op : Nat → (Fin 3 → Int) → Fin 3 → Int)
    (hop : ∀ b, b<512 → ∀ v, (∀ k, 0≤v k ∧ v k<18433) → ∀ k, 0≤op b v k ∧ op b v k<18433)
    (n : Nat) (hn : n≤512) (s : Mem) (hs : CanonMem s) :
    CanonMem (runSteps (tripleStep tripleAddr op) n s) := by
  intro i hi
  obtain ⟨hb,cover⟩ := triple_cover i hi
  rw [←cover, source_triple_prefix op n hn s (i/3) hb ⟨i%3, by omega⟩]
  split
  · apply hop _ hb
    intro k
    exact hs _ (triple_address_bound _ hb k)
  · exact hs _ (triple_address_bound _ hb _)

def forwardSchedule : Nat → Nat → Nat → List (Nat × Nat)
  | 0, _, _ => []
  | fuel+1, m, t => if 3<t then (m,t)::forwardSchedule fuel (2*m) (t/2) else []
def inverseSchedule : Nat → Nat → Nat → List (Nat × Nat)
  | 0, _, _ => []
  | fuel+1, m, t => if t<1536 then (m,t)::inverseSchedule fuel (m/2) (2*t) else []
theorem forward_schedule : forwardSchedule 9 2 768 =
    [(2,768),(4,384),(8,192),(16,96),(32,48),(64,24),(128,12),(256,6)] := by decide
theorem inverse_schedule : inverseSchedule 9 256 6 =
    [(256,6),(128,12),(64,24),(32,48),(16,96),(8,192),(4,384),(2,768)] := by decide

#check @source_pair_prefix
#check @source_triple_prefix
#check @pair_prefix_canonical
#check @triple_prefix_canonical
#print axioms pair_address_bound
#print axioms pair_decode
#print axioms pair_cover
#print axioms pair_layout
#print axioms source_pair_prefix
#print axioms triple_address_bound
#print axioms triple_layout
#print axioms triple_cover
#print axioms source_triple_prefix
#print axioms pair_prefix_canonical
#print axioms triple_prefix_canonical
#print axioms forward_schedule
#print axioms inverse_schedule
end FT1536Global
