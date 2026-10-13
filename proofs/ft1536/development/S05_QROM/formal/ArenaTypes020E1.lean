import SyntaxLegal020E

namespace FT1536.S05.ArenaTypes020E1
open WordRAM020 SyntaxTape020E

inductive Kind where
  | expr | code
  deriving DecidableEq, Repr

def pieceKind : Piece → Kind
  | .expr _ => .expr | .code _ => .code

def resultKind : Token → Kind
  | .literal _ | .register _ | .binary _ => .expr
  | _ => .code

/-- Children appear in stack order: rhs before lhs; no/yes/guard for branch. -/
def needs : Token → List Kind
  | .literal _ | .register _ => []
  | .binary _ | .store | .emit => [.expr,.expr]
  | .setter _ | .rom _ | .ram _ | .bit _ => [.expr]
  | .seq => [.code,.code]
  | .branch => [.code,.code,.expr]
  | .loop _ => [.code,.expr]

def arity (t : Token) : Nat := (needs t).length
abbrev Ptr (capacity : Nat) := Fin (capacity+1)

structure Node (capacity : Nat) where
  cell : SyntaxCells020E.Cell
  first : Ptr capacity
  second : Ptr capacity
  third : Ptr capacity

/-- Both banks have fixed capacity; used/sp may equal capacity. The extra
    pointer value is a checked sentinel, not an extra accessible bank cell. -/
structure Arena (capacity : Nat) where
  bank : Fin capacity → Node capacity
  stack : Fin capacity → Ptr capacity
  used : Ptr capacity
  sp : Ptr capacity

def emptyNode (capacity : Nat) : Node capacity := ⟨(0,0),0,0,0⟩
def empty (capacity : Nat) : Arena capacity := ⟨fun _ => emptyNode capacity,fun _ => 0,0,0⟩

def children {capacity : Nat} (t : Token) (n : Node capacity) : List (Ptr capacity) :=
  match arity t with
  | 0 => [] | 1 => [n.first] | 2 => [n.first,n.second] | _ => [n.first,n.second,n.third]

def nodeKind {capacity : Nat} (n : Node capacity) : Option Kind :=
  (SyntaxCells020E.decode n.cell).map resultKind

theorem arity_bound (t : Token) : arity t≤3 := by cases t <;> simp [arity,needs]

theorem children_length {capacity : Nat} (t : Token) (n : Node capacity) :
    (children t n).length=arity t := by cases t <;> rfl

theorem empty_used (capacity : Nat) : (empty capacity).used.val=0 := rfl
theorem empty_sp (capacity : Nat) : (empty capacity).sp.val=0 := rfl

end FT1536.S05.ArenaTypes020E1
