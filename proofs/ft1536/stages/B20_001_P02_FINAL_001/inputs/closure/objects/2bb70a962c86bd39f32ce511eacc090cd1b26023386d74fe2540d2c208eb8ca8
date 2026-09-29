import Std
set_option maxRecDepth 8192
set_option maxHeartbeats 20000000

namespace FT1536Global
abbrev Mem := Nat → Int
def store (s : Mem) (i : Nat) (x : Int) : Mem := fun j => if j=i then x else s j

theorem store_at (s : Mem) (i : Nat) (x : Int) : store s i x i = x := by simp [store]
theorem store_away (s : Mem) (i j : Nat) (x : Int) (h : j≠i) : store s i x j = s j := by simp [store,h]

def runSteps (step : Nat → Mem → Mem) : Nat → Mem → Mem
  | 0, s => s
  | n+1, s => step n (runSteps step n s)

-- The induction concerns every prefix of the sequential execution, not
-- a definition of the completed stage as an ideal simultaneous map.
theorem prefix_invariant {K : Type} (count : Nat)
    (addr : Nat → K → Nat) (op : Nat → (K → Int) → K → Int)
    (step : Nat → Mem → Mem)
    (layout : ∀ b, b<count → ∀ c, c<count → ∀ k l,
      addr b k=addr c l → b=c ∧ k=l)
    (localStep : ∀ b, b<count → ∀ s k,
      step b s (addr b k)=op b (fun l => s (addr b l)) k)
    (frameStep : ∀ b, b<count → ∀ s i,
      (∀ k, i≠addr b k) → step b s i=s i) :
    ∀ n, n≤count → ∀ s b, b<count → ∀ k,
      runSteps step n s (addr b k) =
        if b<n then op b (fun l => s (addr b l)) k else s (addr b k) := by
  intro n
  induction n with
  | zero => intro hn s b hb k; simp [runSteps]
  | succ n ih =>
    intro hn s b hb k
    have hn0 : n<count := by omega
    have hn1 : n≤count := by omega
    by_cases hbn : b=n
    · subst b
      rw [runSteps, localStep n hn0]
      have snapshot : (fun l => runSteps step n s (addr n l)) = (fun l => s (addr n l)) := by
        funext l
        rw [ih hn1 s n hn0 l]
        simp
      rw [snapshot]
      simp
    · have away : ∀ l, addr b k≠addr n l := by
        intro l eq
        exact hbn (layout b hb n hn0 k l eq).1
      rw [runSteps, frameStep n hn0 _ _ away, ih hn1 s b hb k]
      by_cases hlt : b<n
      · have hlt1 : b<n+1 := by omega
        simp [hlt,hlt1]
      · have hlt1 : ¬b<n+1 := by omega
        simp [hlt,hlt1]

theorem prefix_frame {K : Type} (count : Nat) (addr : Nat → K → Nat)
    (step : Nat → Mem → Mem)
    (frameStep : ∀ b, b<count → ∀ s i, (∀ k, i≠addr b k) → step b s i=s i)
    (n : Nat) (hn : n≤count) (s : Mem) (i : Nat)
    (outside : ∀ b, b<count → ∀ k, i≠addr b k) : runSteps step n s i=s i := by
  induction n with
  | zero => rfl
  | succ n ih =>
    have hnc : n<count := by omega
    rw [runSteps, frameStep n hnc _ i (outside n hnc)]
    exact ih (by omega)

def pairStep (addr : Nat → Bool → Nat) (op : Nat → (Bool → Int) → Bool → Int)
    (b : Nat) (s : Mem) : Mem :=
  let saved := fun k => s (addr b k)
  let out := op b saved
  let t := store s (addr b false) (out false)
  store t (addr b true) (out true)

theorem pair_local (addr : Nat → Bool → Nat) (op : Nat → (Bool → Int) → Bool → Int)
    (b : Nat) (s : Mem) (distinct : addr b false≠addr b true) (k : Bool) :
    pairStep addr op b s (addr b k)=op b (fun l => s (addr b l)) k := by
  cases k <;> simp [pairStep,store,distinct]

theorem pair_frame (addr : Nat → Bool → Nat) (op : Nat → (Bool → Int) → Bool → Int)
    (b : Nat) (s : Mem) (i : Nat) (away : ∀ k, i≠addr b k) : pairStep addr op b s i=s i := by
  simp [pairStep,store,away false,away true]

-- State after the first of the two stores: the second input is still the
-- old value. Both output expressions are based on the old snapshot.
theorem pair_first_store (addr : Nat → Bool → Nat) (op : Nat → (Bool → Int) → Bool → Int)
    (b : Nat) (s : Mem) (distinct : addr b false≠addr b true) :
    let out := op b (fun k => s (addr b k))
    let t := store s (addr b false) (out false)
    t (addr b false)=out false ∧ t (addr b true)=s (addr b true) := by
  simp [store,Ne.symm distinct]

theorem pair_prefix (count : Nat) (addr : Nat → Bool → Nat)
    (op : Nat → (Bool → Int) → Bool → Int)
    (layout : ∀ b, b<count → ∀ c, c<count → ∀ k l,
      addr b k=addr c l → b=c ∧ k=l)
    (n : Nat) (hn : n≤count) (s : Mem) (b : Nat) (hb : b<count) (k : Bool) :
    runSteps (pairStep addr op) n s (addr b k)=
      if b<n then op b (fun l => s (addr b l)) k else s (addr b k) := by
  apply prefix_invariant count addr op (pairStep addr op) layout
  · intro j hj st slot
    apply pair_local
    intro eq
    have bad := (layout j hj j hj false true eq).2
    cases bad
  · intro j hj st i away
    exact pair_frame addr op j st i away
  · exact hn
  · exact hb

def tripleStep (addr : Nat → Fin 3 → Nat) (op : Nat → (Fin 3 → Int) → Fin 3 → Int)
    (b : Nat) (s : Mem) : Mem :=
  let saved := fun k => s (addr b k)
  let out := op b saved
  let s1 := store s (addr b 0) (out 0)
  let s2 := store s1 (addr b 1) (out 1)
  store s2 (addr b 2) (out 2)

theorem fin3_cases (k : Fin 3) : k=0 ∨ k=1 ∨ k=2 := by
  have h : k.val=0 ∨ k.val=1 ∨ k.val=2 := by have hk := k.isLt; omega
  rcases h with h|h|h
  · exact Or.inl (Fin.ext h)
  · exact Or.inr (Or.inl (Fin.ext h))
  · exact Or.inr (Or.inr (Fin.ext h))

theorem triple_local (addr : Nat → Fin 3 → Nat) (op : Nat → (Fin 3 → Int) → Fin 3 → Int)
    (b : Nat) (s : Mem) (distinct : ∀ k l, addr b k=addr b l → k=l) (k : Fin 3) :
    tripleStep addr op b s (addr b k)=op b (fun l => s (addr b l)) k := by
  have h01 : addr b 0≠addr b 1 := fun h => (by decide : (0:Fin 3)≠1) (distinct 0 1 h)
  have h02 : addr b 0≠addr b 2 := fun h => (by decide : (0:Fin 3)≠2) (distinct 0 2 h)
  have h12 : addr b 1≠addr b 2 := fun h => (by decide : (1:Fin 3)≠2) (distinct 1 2 h)
  rcases fin3_cases k with hk|hk|hk <;> subst k <;>
    simp [tripleStep,store,h01,h02,h12]

theorem triple_frame (addr : Nat → Fin 3 → Nat) (op : Nat → (Fin 3 → Int) → Fin 3 → Int)
    (b : Nat) (s : Mem) (i : Nat) (away : ∀ k, i≠addr b k) : tripleStep addr op b s i=s i := by
  simp [tripleStep,store,away 0,away 1,away 2]

theorem triple_prefix (count : Nat) (addr : Nat → Fin 3 → Nat)
    (op : Nat → (Fin 3 → Int) → Fin 3 → Int)
    (layout : ∀ b, b<count → ∀ c, c<count → ∀ k l,
      addr b k=addr c l → b=c ∧ k=l)
    (n : Nat) (hn : n≤count) (s : Mem) (b : Nat) (hb : b<count) (k : Fin 3) :
    runSteps (tripleStep addr op) n s (addr b k)=
      if b<n then op b (fun l => s (addr b l)) k else s (addr b k) := by
  apply prefix_invariant count addr op (tripleStep addr op) layout
  · intro j hj st slot
    apply triple_local
    intro l m eq
    exact (layout j hj j hj l m eq).2
  · intro j hj st i away
    exact triple_frame addr op j st i away
  · exact hn
  · exact hb

#check @prefix_invariant
#check @pair_prefix
#check @triple_prefix
#print axioms store_at
#print axioms store_away
#print axioms prefix_invariant
#print axioms prefix_frame
#print axioms pair_local
#print axioms pair_frame
#print axioms pair_first_store
#print axioms pair_prefix
#print axioms triple_local
#print axioms triple_frame
#print axioms triple_prefix
end FT1536Global
