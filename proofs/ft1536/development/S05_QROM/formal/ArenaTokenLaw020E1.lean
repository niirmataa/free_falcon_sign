import ArenaToken020E1

namespace FT1536.S05.ArenaTokenLaw020E1
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArenaToken020E1

theorem assemble_needs (t : Token) (args : List Piece) (p : Piece)
    (h : assemble t args=some p) : args.map pieceKind=needs t := by
  cases t <;> cases args with
  | nil => simp_all [assemble,push,needs]
  | cons a as =>
    cases a <;> cases as with
    | nil => simp_all [assemble,push,pieceKind,needs]
    | cons b bs =>
      cases b <;> cases bs with
      | nil => simp_all [assemble,push,pieceKind,needs]
      | cons c cs =>
        cases c <;> cases cs <;> simp_all [assemble,push,pieceKind,needs]

theorem push_result (t : Token) (ps qs : List Piece) (h : push t ps=some qs) :
    ∃ p,assemble t (ps.take (arity t))=some p ∧ qs=p::ps.drop (arity t) := by
  rw [push_split] at h
  cases ha : assemble t (ps.take (arity t)) with
  | none => simp only [ha,Option.map_none] at h;cases h
  | some p =>
    simp only [ha,Option.map_some,Option.some.injEq] at h
    exact ⟨p,rfl,h.symm⟩

theorem push_arity (t : Token) (ps qs : List Piece) (h : push t ps=some qs) : arity t≤ps.length := by
  obtain ⟨p,hp,_⟩ := push_result t ps qs h
  have he := congrArg List.length (assemble_needs t _ p hp)
  simp only [List.length_map,List.length_take] at he
  change min (arity t) ps.length=arity t at he
  omega

end FT1536.S05.ArenaTokenLaw020E1
