import Source3.C99Frontend

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The pinned sqrt body uses a C99 for-declared index, unlike the older
   primitive grammar. Its declaration has exactly the enclosing for scope. -/
namespace FT1536.Source3.FprSqrtSyntax132
open B20.C

structure Code where
  pre : List CLogic.Stmt
  round : List CLogic.Stmt
  tail : List CLogic.Stmt
  deriving Repr, DecidableEq

def parseUntil (stop : Token) : Nat → List Token → Option (List CLogic.Stmt × List Token)
  | 0, _ => none
  | fuel+1, tokens =>
      if tokens.head?=some stop then some ([],tokens) else do
        let (first,rest) ← CLogicParser.statement tokens
        let (following,last) ← parseUntil stop fuel rest
        pure (first::following,last)

def parse : Option Code := do
  let tokens ← CLogicParser.tokenize ((FprPrimitives.cslice 1182 76).length+1)
    (FprPrimitives.cslice 1182 76)
  match tokens with
  | ['f','p','r']::['f','p','r','_','s','q','r','t']::['(']::['f','p','r']::['x']::[')']::['{']::rest =>
      let (pre,loop) ← parseUntil ['f','o','r'] 128 rest
      match loop with
      | ['f','o','r']::['(']::['i','n','t']::['i']::['=']::['0']::[';']::['i']::['<']::['5','4']::[';']::['i']::['+']::['+']::[')']::['{']::inner =>
          let (round,endRound) ← parseUntil ['}'] 128 inner
          match endRound with
          | ['}']::rest =>
              let (tail,endBody) ← parseUntil ['}'] 128 rest
              if endBody=[['}']] then pure ⟨pre,round,tail⟩ else none
          | _ => none
      | _ => none
  | _ => none

def active : Bool := FprPrimitives.m0Active &&
  FprPinned.cLines[1003]?==some "#if FALCON_ASM_CORTEXM4 // yyyASM_CORTEXM4+1\n" &&
  FprPinned.cLines[1179]?==some "#else // yyyASM_CORTEXM4+0\n" &&
  FprPinned.cLines[1258]?==some "#endif // yyyASM_CORTEXM4-\n"

theorem active_source : active=true := by decide +kernel
theorem parsed : parse.isSome=true := by decide +kernel

def condition : CLogic.Expr := .cmp .lt (.var ['i']) (.literal .i32 54)
def increment : CLogic.Stmt := .update ['i'] .add (.literal .i32 1)

def iteration (code : Code) : C99ScalarReference.Stmt :=
  .seq (.block (FprPrimitives.scalarDecls code.round) (C99Frontend.scalars code.round))
    (C99Frontend.scalar increment)

def loop (code : Code) : C99ScalarReference.Stmt :=
  .block [['i']] (.seq (.declare .int32 ['i'])
    (.seq (C99Frontend.scalar (.assign ['i'] (.literal .i32 0)))
      (.while (C99Frontend.expression condition) (iteration code))))

def lower (code : Code) : C99ScalarReference.Function :=
  ⟨[(.uint64,['x'])],.uint64,
    .seq (C99Frontend.scalars code.pre) (.seq (loop code) (C99Frontend.scalars code.tail))⟩

def function : Option C99ScalarReference.Function :=
  if active then parse.map lower else none

end FT1536.Source3.FprSqrtSyntax132
