import Source3.FprAddCombine
import Mathlib.Tactic.FinCases

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprNormRound
open B20.C

def flag (m : BitVec 64) (shift : Nat) : BitVec 32 :=
  let t := (m >>> shift).setWidth 32
  (t ||| -t) >>> 31

theorem flag_bool (m : BitVec 64) (shift : Nat) : flag m shift=0#32 ∨ flag m shift=1#32 := by
  let t := (m >>> shift).setWidth 32
  have ht := (t ||| -t).isLt
  have hv : (flag m shift).toNat=(t ||| -t).toNat/2^31 := by
    simp [flag,t,BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
  have hb : (flag m shift).toNat=0 ∨ (flag m shift).toNat=1 := by omega
  rcases hb with hb | hb
  · left; apply BitVec.eq_of_toNat_eq; exact hb
  · right; apply BitVec.eq_of_toNat_eq; exact hb

def delta (m : BitVec 64) (shift : Nat) (p : Fin 6) : BitVec 32 := flag m shift <<< p.val
theorem delta_bounds (m : BitVec 64) (shift : Nat) (p : Fin 6) :
    0≤(delta m shift p).toInt ∧ (delta m shift p).toInt≤32 := by
  rcases flag_bool m shift with h | h <;>
    fin_cases p <;> simp [delta,h]

def code (rs ms : Nat) (es : Fin 6) : List CLogic.Stmt := [
  .assign ['n','t'] (.cast .u32 (.bin .shr (.var ['x','u']) (.literal .i32 rs))),
  .assign ['n','t'] (.bin .shr (.bin .bor (.var ['n','t']) (.neg (.var ['n','t']))) (.literal .i32 31)),
  .update ['x','u'] .xor (.bin .band
    (.bin .xor (.var ['x','u']) (.bin .shl (.var ['x','u']) (.literal .i32 ms)))
    (.bin .sub (.cast .u64 (.var ['n','t'])) (.literal .i32 1))),
  .update ['e','x'] .add (.cast .i32 (.bin .shl (.var ['n','t']) (.literal .i32 es.val)))]

def nextM (m : BitVec 64) (rs ms : Nat) : BitVec 64 :=
  m ^^^ ((m ^^^ (m <<< ms)) &&& ((flag m rs).setWidth 64-1))
def after (s : B20.C.Scalar.State) (m : BitVec 64) (e : BitVec 32) (rs ms : Nat) (es : Fin 6) :
    B20.C.Scalar.State :=
  {s with values := update (update (update (update s.values
    ['n','t'] (.u32 ((m >>> rs).setWidth 32))) ['n','t'] (.u32 (flag m rs)))
    ['x','u'] (.u64 (nextM m rs ms))) ['e','x'] (.i32 (e+delta m rs es))}

theorem round_exec (s : B20.C.Scalar.State) (m : BitVec 64) (e : BitVec 32)
    (rs ms : Nat) (es : Fin 6) (hrs : rs<64) (hms : ms<64)
    (htn : s.types ['n','t']=some .u32) (htm : s.types ['x','u']=some .u64)
    (hte : s.types ['e','x']=some .i32)
    (hm : s.values ['x','u']=some (.u64 m)) (he : s.values ['e','x']=some (.i32 e))
    (hbound : -2000≤e.toInt ∧ e.toInt≤2000) :
    UnsignedState.exec FprPrimitives.headerCalls s (code rs ms es)=some (after s m e rs ms es) ∧
    e.toInt≤(e+delta m rs es).toInt ∧ (e+delta m rs es).toInt≤e.toInt+32 := by
  have hdelta := delta_bounds m rs es
  have hsum := FprSmallSigned.add32 e (delta m rs es) (by omega)
  have hs0 := hsum.1
  simp only [delta,flag] at hs0
  have hrs32 : rs<2^32 := by omega
  have hms32 : ms<2^32 := by omega
  have hes32 : es.val<32 := by have hh:=es.isLt; omega
  have hesfull : es.val<2^32 := by omega
  have hmodr : rs%4294967296=rs := by omega
  have hmodm : ms%4294967296=ms := by omega
  have hmode : es.val%4294967296=es.val := by omega
  refine ⟨?_,by omega,by omega⟩
  simp [UnsignedState.exec,code,CLogic.step,CLogic.eval,B20.C.Scalar.assign,
    B20.C.update,B20.C.cast,literalValue,bin,commonTy,Val.ty,bitsOp,shift,neg,
    htn,htm,hte,hm,he,hrs,hms,hes32,hmodr,hmodm,hmode,
    hs0,after,flag,nextM,delta]

theorem source_rounds :
    FprAST.normCode.drop 2 = code 32 32 5 ++ code 48 16 4 ++ code 56 8 3 ++
      code 60 4 2 ++ code 62 2 1 ++ FprAST.normCode.drop 22 := by rfl

end FT1536.Source3.FprNormRound

#print axioms FT1536.Source3.FprNormRound.round_exec
#print axioms FT1536.Source3.FprNormRound.source_rounds
