import ArenaTypes020E1

namespace FT1536.S05.ArenaToken020E1
open WordRAM020 SyntaxTape020E ArenaTypes020E1

def assemble (t : Token) (args : List Piece) : Option Piece :=
  match push t args with
  | some [p] => some p
  | _ => none

/-- The exact source parser consumes only the token's required prefix. -/
theorem push_split (t : Token) (ps : List Piece) :
    push t ps=(assemble t (ps.take (arity t))).map (fun p => p::ps.drop (arity t)) := by
  cases t <;> first
  | rfl
  | cases ps with
    | nil => rfl
    | cons p ps =>
      cases p <;> first
      | rfl
      | cases ps with
        | nil => rfl
        | cons q qs =>
          cases q <;> first
          | rfl
          | cases qs with
            | nil => rfl
            | cons r rs => cases r <;> rfl

theorem assemble_kind (t : Token) (args : List Piece) (p : Piece)
    (h : assemble t args=some p) : pieceKind p=resultKind t := by
  cases t <;> cases args with
  | nil => simp_all [assemble,push,pieceKind,resultKind] <;> subst p <;> rfl
  | cons a as =>
    cases a <;> cases as with
    | nil => simp_all [assemble,push,pieceKind,resultKind] <;> subst p <;> rfl
    | cons b bs =>
      cases b <;> cases bs with
      | nil => simp_all [assemble,push,pieceKind,resultKind] <;> subst p <;> rfl
      | cons c cs =>
        cases c <;> cases cs <;> simp_all [assemble,push,pieceKind,resultKind] <;> subst p <;> rfl

/-- Runtime checking needs only the kinds of the referenced children. -/
theorem assemble_exists (t : Token) (args : List Piece)
    (hk : args.map pieceKind=needs t) : ∃ p,assemble t args=some p := by
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

end FT1536.S05.ArenaToken020E1
