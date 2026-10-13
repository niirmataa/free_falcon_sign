import ArrayArena020E4

namespace FT1536.S05.ParserDecision020E5
open WordRAM020 SyntaxTape020E ArenaTypes020E1 ArrayBank020E4

/-- A bounded commit descriptor. The arena itself is never returned by the
    decision procedure; exactly two bank cells and two scalar pointers change. -/
structure Change (cap : Nat) where
  nodeSite : Fin cap
  stackSite : Fin cap
  node : Node cap
  pushed : Ptr cap
  used : Ptr cap
  sp : Ptr cap

def apply {cap : Nat} (a : ArrayArena020E4.Arena cap) (c : Change cap) : ArrayArena020E4.Arena cap :=
  ⟨write a.bank c.nodeSite c.node,write a.stack c.stackSite c.pushed,c.used,c.sp⟩

def token {cap : Nat} (a : ArrayArena020E4.Arena cap) (t : Token) : Option (Change cap) :=
  if hu : a.used.val<cap then
    if arity t≤a.sp.val then
      if hr : a.sp.val-arity t<cap then
        let node := ArenaStackRead020E1.freshNode (ArrayArena020E4.model a) t
        if (children t node).map (ArenaStep020E1.checkedKind (ArrayArena020E4.model a))=(needs t).map some then
          some ⟨⟨a.used.val,hu⟩,⟨a.sp.val-arity t,hr⟩,node,a.used,
            ⟨a.used.val+1,by omega⟩,⟨a.sp.val-arity t+1,by omega⟩⟩
        else none
      else none
    else none
  else none

def cell {cap : Nat} (a : ArrayArena020E4.Arena cap) (c : SyntaxCells020E.Cell) : Option (Change cap) :=
  (SyntaxCells020E.decode c).bind (token a)

theorem token_refines {cap : Nat} (a : ArrayArena020E4.Arena cap) (t : Token) :
    (token a t).map (apply a)=ArrayArena020E4.step t a := by
  unfold token ArrayArena020E4.step
  split <;> (try rfl)
  split <;> (try rfl)
  split <;> (try rfl)
  dsimp only
  split <;> rfl

theorem cell_refines {cap : Nat} (a : ArrayArena020E4.Arena cap) (c : SyntaxCells020E.Cell) :
    (cell a c).map (apply a)=ArrayArena020E4.stepCell c a := by
  unfold cell ArrayArena020E4.stepCell
  cases SyntaxCells020E.decode c
  · rfl
  · exact token_refines a _

end FT1536.S05.ParserDecision020E5
