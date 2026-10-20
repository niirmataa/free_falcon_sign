import Source3.FprASTBinding

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprHeaderTotal
open B20.C

theorem signed_band32 (x y : BitVec 32) :
    signedBitsOp .band x y=bitsOp .band x y := by
  simp [signedBitsOp,signedSafe]

theorem and31_count (x : BitVec 32) : (x &&& 31#32).toNat<32 := by
  have h := Nat.and_le_right (n:=x.toNat) (m:=31)
  change (x.toNat &&& 31)<32
  omega

def ulshWord (x : BitVec 64) (n : BitVec 32) : BitVec 64 :=
  (x ^^^ ((x ^^^ (x <<< 32)) &&& -((n.sshiftRight 5).signExtend 64))) <<< (n &&& 31#32).toNat
def urshWord (x : BitVec 64) (n : BitVec 32) : BitVec 64 :=
  (x ^^^ ((x ^^^ (x >>> 32)) &&& -((n.sshiftRight 5).signExtend 64))) >>> (n &&& 31#32).toNat

theorem ulsh_exec (x : BitVec 64) (n : BitVec 32) :
    CLogic.execute (fun _ _ => none) FprAST.ulshCode [.u64 x,.i32 n]=
      some (.u64 (ulshWord x n)) := by
  have hc : (n &&& 31#32).toNat<64 := Nat.lt_trans (and31_count n) (by decide)
  simp [CLogic.execute,FprAST.ulshCode,B20.C.Scalar.bindArgs,
    B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,B20.C.Scalar.assign,
    CLogic.evalBody,CLogic.step,CLogic.eval,B20.C.update,B20.C.cast,
    literalValue,bin,commonTy,Val.ty,bitsOp,shift,neg,ulshWord,signed_band32]
  exact hc

theorem ursh_exec (x : BitVec 64) (n : BitVec 32) :
    CLogic.execute (fun _ _ => none) FprAST.urshCode [.u64 x,.i32 n]=
      some (.u64 (urshWord x n)) := by
  have hc : (n &&& 31#32).toNat<64 := Nat.lt_trans (and31_count n) (by decide)
  simp [CLogic.execute,FprAST.urshCode,B20.C.Scalar.bindArgs,
    B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,B20.C.Scalar.assign,
    CLogic.evalBody,CLogic.step,CLogic.eval,B20.C.update,B20.C.cast,
    literalValue,bin,commonTy,Val.ty,bitsOp,shift,neg,urshWord,signed_band32]
  exact hc

theorem pack_neg_defined (m : BitVec 64) :
    B20.C.neg (.i32 ((m >>> 54).setWidth 32)) =
      some (.i32 (-((m >>> 54).setWidth 32))) := by
  have h1 : (m >>> 54).toNat = m.toNat / 2^54 := by
    simp [BitVec.toNat_ushiftRight,Nat.shiftRight_eq_div_pow]
  have h2 : ((m >>> 54).setWidth 32).toNat = (m >>> 54).toNat % 2^32 := by
    simp [BitVec.toNat_setWidth]
  have hm := m.isLt
  have hne : ((m >>> 54).setWidth 32) ≠ 0x80000000#32 := by
    intro he
    have hval := congrArg BitVec.toNat he
    change ((m >>> 54).setWidth 32).toNat = 2147483648 at hval
    omega
  change (if ((m >>> 54).setWidth 32)=0x80000000#32 then none else
    some (Val.i32 (-((m >>> 54).setWidth 32)))) = _
  rw [ite_eq_right hne]

theorem pack_and7_count (n : Nat) : n &&& 7<32 := by
  have h : n &&& 7≤7 := Nat.and_le_right
  omega

def packWord (s e : BitVec 32) (m : BitVec 64) : BitVec 64 :=
  let e1 := e+1076#32
  let t := e1 >>> 31
  let m1 := m &&& (t.setWidth 64-1)
  let t2 := (m1 >>> 54).setWidth 32
  let e2 := e1 &&& (-t2)
  let x := ((s.signExtend 64 <<< 63) ||| (m1 >>> 2)) + (e2.setWidth 64 <<< 52)
  x + (((200#32 >>> (m1.setWidth 32 &&& 7#32).toNat) &&& 1#32).setWidth 64)

theorem pack_exec (s e : BitVec 32) (m : BitVec 64)
    (he : -2147483648≤e.toInt+1076 ∧ e.toInt+1076<2147483648) :
    CLogic.execute (fun _ _ => none) FprAST.packCode [.i32 s,.i32 e,.u64 m]=
      some (.u64 (packWord s e m)) := by
  have hsafe : signedBitsOp .add e 1076#32=bitsOp .add e 1076#32 := by
    have hc : (1076#32).toInt=(1076 : Int) := by decide
    simp [signedBitsOp,signedSafe,hc,he]
  simp (config := { maxSteps := 200000 })
    [CLogic.execute,FprAST.packCode,B20.C.Scalar.bindArgs,
     B20.C.Scalar.emptyState,B20.C.Scalar.declareOne,B20.C.Scalar.declareMany,
     B20.C.Scalar.assign,CLogic.evalBody,CLogic.step,CLogic.eval,
     B20.C.update,B20.C.cast,literalValue,bin,commonTy,Val.ty,bitsOp,shift,
     packWord,pack_neg_defined,hsafe,signed_band32,pack_and7_count]

theorem header_ulsh (x : BitVec 64) (n : BitVec 32) :
    FprPrimitives.headerCalls ['f','p','r','_','u','l','s','h'] [.u64 x,.i32 n]=
      some (.u64 (ulshWord x n)) := by
  simp [FprPrimitives.headerCalls,FprAST.ulsh_binding,ulsh_exec]
theorem header_ursh (x : BitVec 64) (n : BitVec 32) :
    FprPrimitives.headerCalls ['f','p','r','_','u','r','s','h'] [.u64 x,.i32 n]=
      some (.u64 (urshWord x n)) := by
  simp [FprPrimitives.headerCalls,FprAST.ursh_binding,ursh_exec]
theorem header_pack (s e : BitVec 32) (m : BitVec 64)
    (he : -2147483648≤e.toInt+1076 ∧ e.toInt+1076<2147483648) :
    FprPrimitives.headerCalls ['F','P','R'] [.i32 s,.i32 e,.u64 m]=
      some (.u64 (packWord s e m)) := by
  simp [FprPrimitives.headerCalls,FprAST.pack_binding,pack_exec s e m he]

theorem header_ulsh_one (n : BitVec 32) :
    FprPrimitives.headerCalls ['f','p','r','_','u','l','s','h'] [.i32 1,.i32 n]=
      some (.u64 (ulshWord 1 n)) := by
  have h : CLogic.execute (fun _ _ => none) FprAST.ulshCode [.i32 1,.i32 n]=
      CLogic.execute (fun _ _ => none) FprAST.ulshCode [.u64 1,.i32 n] := by rfl
  simp [FprPrimitives.headerCalls,FprAST.ulsh_binding]
  exact h.trans (ulsh_exec 1 n)

end FT1536.Source3.FprHeaderTotal

#check @FT1536.Source3.FprHeaderTotal.header_pack
#print axioms FT1536.Source3.FprHeaderTotal.header_pack
#print axioms FT1536.Source3.FprHeaderTotal.header_ulsh
#print axioms FT1536.Source3.FprHeaderTotal.header_ursh
