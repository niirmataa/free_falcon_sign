import ConsumerCount020E13

namespace FT1536.S05.CoreCountTypes020E13

/-- Structural events only. Cycles each contain two fetch-machine transitions;
    scans are decoder invocations, writes are target-bank writes. This record
    is proof instrumentation and supplies neither a primitive time price nor
    a memory allocation/lifetime certificate. -/
structure Counts where
  cycles : Nat
  slots : Nat
  scans : Nat
  writes : Nat
  rounds : Nat
  tests : Nat

def zero : Counts := ⟨0,0,0,0,0,0⟩
def add (a b : Counts) : Counts :=
  ⟨a.cycles+b.cycles,a.slots+b.slots,a.scans+b.scans,a.writes+b.writes,a.rounds+b.rounds,a.tests+b.tests⟩
def test (a : Counts) : Counts := {a with tests:=a.tests+1}

structure Report (α : Type) where
  value : α
  counts : Counts

def map {α β : Type} (f : α → β) (r : Report α) : Report β := ⟨f r.value,r.counts⟩

/-- A relation derived below from the instrumented execution, not an input
    certificate assumed for the sampler. -/
def Valid (c : Counts) (fuel : Nat) : Prop :=
  c.cycles=14733*c.rounds ∧ c.slots=32*c.rounds ∧ c.scans≤c.slots ∧
  c.writes≤c.scans ∧ c.rounds≤fuel ∧ c.tests≤fuel

theorem zero_valid (fuel : Nat) : Valid zero fuel :=
  ⟨rfl,rfl,Nat.le_refl _,Nat.le_refl _,Nat.zero_le _,Nat.zero_le _⟩

theorem stop_valid (fuel : Nat) : Valid (test zero) (fuel+1) := by
  exact ⟨rfl,rfl,Nat.le_refl _,Nat.le_refl _,Nat.zero_le _,by simp [test,zero]⟩

theorem round_valid (a b : Counts) (fuel : Nat)
    (ha : a.cycles=14733 ∧ a.slots=32 ∧ a.scans≤32 ∧ a.writes≤a.scans ∧ a.rounds=1 ∧ a.tests=0)
    (hb : Valid b fuel) : Valid (test (add a b)) (fuel+1) := by
  rcases ha with ⟨hc,hs,hscan,hw,hr,ht⟩
  rcases hb with ⟨bc,bs,bscan,bw,br,bt⟩
  simp only [Valid,test,add]
  constructor
  · omega
  constructor
  · omega
  exact ⟨by omega,by omega,by omega,by omega⟩

end FT1536.S05.CoreCountTypes020E13
