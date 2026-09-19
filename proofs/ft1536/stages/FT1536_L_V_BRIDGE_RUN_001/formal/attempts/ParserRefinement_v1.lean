import MachineBindings
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Bridge

theorem unary_unique (d : Bytes) (ne : Nat) (c : Cursor) (a b : Option (Nat × Cursor))
    (ha : UnaryRun d ne c a) (hb : UnaryRun d ne c b) : a=b := by
  induction ha generalizing b <;> cases hb <;> simp_all

theorem unary_terminates (d : Bytes) (c : Cursor) (hc : Inv d c) :
    UnaryRun d 0 c (unary d c) ∧ ∀ result, UnaryRun d 0 c result → result=unary d c := by
  have hs:=unary_source (remaining d c) d 0 c hc (by omega)
  exact ⟨hs,fun result hr => unary_unique d 0 c result (unary d c) hr hs⟩

theorem fill_unique (need : Nat) (d : Bytes) (c : Cursor) (a b : Option Cursor)
    (ha : FillRun need d c a) (hb : FillRun need d c b) : a=b := by
  induction ha generalizing b <;> cases hb <;> simp_all <;> omega

theorem static_fill_exact (d : Bytes) (c : Cursor) (hc : Inv d c) :
    ∀ result, FillRun 9 d c result ↔ result=fill 2 9 d c := by
  intro result
  have hs:=static_head_source d c hc
  constructor
  · intro hr;exact fill_unique 9 d c result _ hr hs
  · intro he;rw [he];exact hs

theorem pk_fill_exact (d : Bytes) (c : Cursor) (hc : Inv d c) :
    ∀ result, FillRun 15 d c result ↔ result=fill 2 15 d c := by
  intro result
  have hs:=pk_head_source d c hc
  constructor
  · intro hr;exact fill_unique 15 d c result _ hr hs
  · intro he;rw [he];exact hs

#check @unary_terminates
#check @static_fill_exact
#check @pk_fill_exact
#print axioms unary_unique
#print axioms unary_terminates
#print axioms fill_unique
#print axioms static_fill_exact
#print axioms pk_fill_exact
end FT1536Bridge
