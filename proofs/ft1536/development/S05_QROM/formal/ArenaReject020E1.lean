import ArenaStep020E1

namespace FT1536.S05.ArenaReject020E1
open SyntaxTape020E ArenaTypes020E1 ArenaStackRead020E1 ArenaStep020E1

/-- These are parser errors, not new modeled signature-abort atoms. -/
theorem full {cap : Nat} (s : Arena cap) (t : Token) (h : s.used.val=cap) : step t s=none := by
  have hn : ¬s.used.val<cap := by omega
  simp only [step,dite_eq_right hn]

theorem underflow {cap : Nat} (s : Arena cap) (t : Token) (h : s.sp.val<arity t) : step t s=none := by
  have hn : ¬arity t≤s.sp.val := by omega
  simp [step,hn]

theorem bad_child {cap : Nat} (s : Arena cap) (t : Token) (p : Ptr cap)
    (hp : p∈children t (freshNode s t)) (hk : checkedKind s p=none) : step t s=none := by
  have hn : (children t (freshNode s t)).map (checkedKind s)≠(needs t).map some := by
    intro he
    have hm : none∈(children t (freshNode s t)).map (checkedKind s) := List.mem_map.mpr ⟨p,hp,hk⟩
    rw [he] at hm
    obtain ⟨k,_,hbad⟩ := List.mem_map.mp hm
    cases hbad
  simp [step,hn]

theorem invalid_pointer {cap : Nat} (s : Arena cap) (p : Ptr cap) (hp : s.used.val≤p.val) :
    checkedKind s p=none := by
  have hn : ¬p.val<s.used.val := by omega
  rw [checkedKind,dite_eq_right hn]

theorem bad_cell {cap : Nat} (s : Arena cap) (cell : SyntaxCells020E.Cell)
    (hc : SyntaxCells020E.decode cell=none) : stepCell cell s=none := by
  rw [stepCell,hc]
  rfl

end FT1536.S05.ArenaReject020E1
