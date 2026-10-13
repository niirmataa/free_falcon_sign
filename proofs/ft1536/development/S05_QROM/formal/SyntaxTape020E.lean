import WordRAM020

namespace FT1536.S05.SyntaxTape020E
open WordRAM020

inductive Token where
  | literal (w : Word) | register (r : Reg) | binary (o : Op)
  | setter (r : Reg) | rom (r : Reg) | ram (r : Reg) | bit (r : Reg)
  | store | emit | seq | branch | loop (cap : Nat)
  deriving Repr

inductive Piece where
  | expr (e : Expr)
  | code (c : Code)
  deriving Repr

def expression : Expr → List Token
  | .lit w => [.literal w]
  | .reg r => [.register r]
  | .bin o a b => expression a ++ expression b ++ [.binary o]

def atomic : Atom → List Token
  | .set r e => expression e ++ [.setter r]
  | .loadROM r a => expression a ++ [.rom r]
  | .loadRAM r a => expression a ++ [.ram r]
  | .loadBit r a => expression a ++ [.bit r]
  | .store a v => expression a ++ expression v ++ [.store]
  | .emit a v => expression a ++ expression v ++ [.emit]

def program : Code → List Token
  | .atom a => atomic a
  | .seq a b => program a ++ program b ++ [.seq]
  | .branch e a b => expression e ++ program a ++ program b ++ [.branch]
  | .loop n g b => expression g ++ program b ++ [.loop n]

def push : Token → List Piece → Option (List Piece)
  | .literal w,ps => some (.expr (.lit w)::ps)
  | .register r,ps => some (.expr (.reg r)::ps)
  | .binary o,.expr b::.expr a::ps => some (.expr (.bin o a b)::ps)
  | .setter r,.expr e::ps => some (.code (.atom (.set r e))::ps)
  | .rom r,.expr e::ps => some (.code (.atom (.loadROM r e))::ps)
  | .ram r,.expr e::ps => some (.code (.atom (.loadRAM r e))::ps)
  | .bit r,.expr e::ps => some (.code (.atom (.loadBit r e))::ps)
  | .store,.expr v::.expr a::ps => some (.code (.atom (.store a v))::ps)
  | .emit,.expr v::.expr a::ps => some (.code (.atom (.emit a v))::ps)
  | .seq,.code b::.code a::ps => some (.code (.seq a b)::ps)
  | .branch,.code b::.code a::.expr e::ps => some (.code (.branch e a b)::ps)
  | .loop n,.code b::.expr e::ps => some (.code (.loop n e b)::ps)
  | _,_ => none

def parse : List Token → List Piece → Option (List Piece)
  | [],ps => some ps
  | t::ts,ps => (push t ps).bind (parse ts)

theorem parse_append (xs ys : List Token) (ps : List Piece) :
    parse (xs++ys) ps=(parse xs ps).bind (parse ys) := by
  induction xs generalizing ps with
  | nil => rfl
  | cons x xs ih =>
    simp only [List.cons_append,parse]
    cases h : push x ps with
    | none => rfl
    | some qs => exact ih qs

theorem expression_roundtrip (e : Expr) (ps : List Piece) :
    parse (expression e) ps=some (.expr e::ps) := by
  induction e generalizing ps with
  | lit w => rfl
  | reg r => rfl
  | bin o a b ha hb => simp only [expression,parse_append,ha,hb,Option.bind_some,parse,push]

theorem atomic_roundtrip (a : Atom) (ps : List Piece) :
    parse (atomic a) ps=some (.code (.atom a)::ps) := by
  cases a <;> simp only [atomic,parse_append,expression_roundtrip,Option.bind_some,parse,push]

theorem program_roundtrip (c : Code) (ps : List Piece) :
    parse (program c) ps=some (.code c::ps) := by
  induction c generalizing ps with
  | atom a => exact atomic_roundtrip a ps
  | seq a b ha hb => simp only [program,parse_append,ha,hb,Option.bind_some,parse,push]
  | branch e a b ha hb =>
    simp only [program,parse_append,expression_roundtrip,ha,hb,Option.bind_some,parse,push]
  | loop n g b hb => simp only [program,parse_append,expression_roundtrip,hb,Option.bind_some,parse,push]

theorem expression_length (e : Expr) : (expression e).length=exprNodes e := by
  induction e with
  | lit w => rfl
  | reg r => rfl
  | bin o a b ha hb => simp only [expression,List.length_append,List.length_singleton,ha,hb,exprNodes];omega

theorem atomic_length (a : Atom) : (atomic a).length=atomNodes a := by
  cases a <;> simp only [atomic,List.length_append,List.length_singleton,expression_length,atomNodes] <;> omega

theorem program_length (c : Code) : (program c).length=nodes c := by
  induction c with
  | atom a => exact atomic_length a
  | seq a b ha hb => simp only [program,List.length_append,List.length_singleton,ha,hb,nodes];omega
  | branch e a b ha hb =>
    simp only [program,List.length_append,List.length_singleton,expression_length,ha,hb,nodes];omega
  | loop n g b hb => simp only [program,List.length_append,List.length_singleton,expression_length,hb,nodes];omega

theorem program_injective : Function.Injective program := by
  intro a b h
  have p := congrArg (fun ts => parse ts []) h
  rw [program_roundtrip,program_roundtrip] at p
  exact Piece.code.inj (List.cons.inj (Option.some.inj p)).1

end FT1536.S05.SyntaxTape020E
