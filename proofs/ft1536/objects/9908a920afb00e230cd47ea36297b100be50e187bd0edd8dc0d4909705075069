import Source3.FprScalarSequence
import Source3.FprSmallSigned

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprAddDecode
open B20.C

def expRaw (x : BitVec 64) := (x >>> 52).setWidth 32
def expField (x : BitVec 64) := expRaw x &&& 2047#32
def expValue (x : BitVec 64) := expField x-1078#32
def signWord (x : BitVec 64) := (expRaw x).sshiftRight 11
def maskWord (x : BitVec 64) : BitVec 64 :=
  ((expField x+2047#32).sshiftRight 11).setWidth 64 <<< 52
def mantWord (x : BitVec 64) : BitVec 64 :=
  ((x &&& ((1#64 <<< 52)-1)) ||| maskWord x) <<< 3

theorem field_bounds (x : BitVec 64) :
    0≤(expField x).toInt ∧ (expField x).toInt≤2047 := by
  simpa [expField,expRaw,FprSmallSigned.exponent] using FprSmallSigned.exponent_bounds x

theorem exponent_bounds (x : BitVec 64) :
    -1078≤(expValue x).toInt ∧ (expValue x).toInt≤969 := by
  have h := field_bounds x
  have c : (1078#32).toInt=(1078 : Int) := by decide
  have he := (FprSmallSigned.sub32 (expField x) 1078#32 (by rw [c]; omega)).2
  dsimp [expValue]
  omega

def sourceName (second : Bool) : Name := if second then ['y'] else ['x']
def expName (second : Bool) : Name := if second then ['e','y'] else ['e','x']
def signName (second : Bool) : Name := if second then ['s','y'] else ['s','x']
def mantName (second : Bool) : Name := if second then ['y','u'] else ['x','u']
def statements (second : Bool) : List CLogic.Stmt :=
  (FprUnsignedPrefixes.scalars ((FprAST.addCode.body.drop (if second then 15 else 9)).take 6)).getD []

def after (s : B20.C.Scalar.State) (second : Bool) (x : BitVec 64) : B20.C.Scalar.State :=
  {s with values := update (update (update (update (update (update s.values
    (expName second) (.i32 (expRaw x))) (signName second) (.i32 (signWord x)))
    (expName second) (.i32 (expField x))) ['m'] (.u64 (maskWord x)))
    (mantName second) (.u64 (mantWord x))) (expName second) (.i32 (expValue x))}

theorem decode_total (s : B20.C.Scalar.State) (second : Bool) (x : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.addTypes)
    (hv : s.values (sourceName second)=some (.u64 x)) :
    UnsignedState.exec FprPrimitives.headerCalls s (statements second)=some (after s second x) := by
  have hfield := field_bounds x
  have c2047 : (2047#32).toInt=(2047 : Int) := by decide
  have c1078 : (1078#32).toInt=(1078 : Int) := by decide
  have hplus := (FprSmallSigned.add32 (expField x) 2047#32 (by rw [c2047]; omega)).1
  have hsub := (FprSmallSigned.sub32 (expField x) 1078#32 (by rw [c1078]; omega)).1
  simp [expField,expRaw] at hplus hsub
  cases second <;> simp [sourceName] at hv <;>
    simp (config := { maxSteps := 200000 })
      [UnsignedState.exec,statements,FprUnsignedPrefixes.scalars,FprAST.addCode,
       CLogic.step,CLogic.eval,B20.C.Scalar.assign,B20.C.cast,B20.C.update,
       ht,hv,expName,signName,mantName,FprUnsignedPrefixes.addTypes,List.foldl,
       FprUnsignedPrefixes.xyTypes,UnsignedState.setType,
       literalValue,bin,commonTy,Val.ty,bitsOp,shift,
       FprHeaderTotal.signed_band32,hplus,hsub,
       after,expRaw,expField,expValue,signWord,maskWord,mantWord]

end FT1536.Source3.FprAddDecode

#print axioms FT1536.Source3.FprAddDecode.decode_total
#print axioms FT1536.Source3.FprAddDecode.exponent_bounds
