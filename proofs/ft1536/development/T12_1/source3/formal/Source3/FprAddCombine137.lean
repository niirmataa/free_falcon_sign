import Source3.FprAddCombine

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprAddCombine137
open B20.C

def shifted (ex ey : BitVec 32) (yu : BitVec 64) : BitVec 64 :=
  let cc := ex-ey
  let clamped := yu &&& (-(((cc-60#32) >>> 31).setWidth 64))
  let count := cc &&& 63#32
  let mask := FprHeaderTotal.ulshWord 1 count-1
  FprHeaderTotal.urshWord (clamped ||| ((clamped &&& mask)+mask)) count

def mantissa (ex ey sx sy : BitVec 32) (xu yu : BitVec 64) : BitVec 64 :=
  let small := shifted ex ey yu
  xu + (small-((small <<< 1) &&& (-((sx ^^^ sy).signExtend 64))))

theorem source (s : B20.C.Scalar.State) (ex ey sx sy : BitVec 32) (xu yu : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.addTypes)
    (hex : s.values ['e','x']=some (.i32 ex)) (hey : s.values ['e','y']=some (.i32 ey))
    (hsx : s.values ['s','x']=some (.i32 sx)) (hsy : s.values ['s','y']=some (.i32 sy))
    (hxu : s.values ['x','u']=some (.u64 xu)) (hyu : s.values ['y','u']=some (.u64 yu))
    (hbx : -1078≤ex.toInt ∧ ex.toInt≤969) (hby : -1078≤ey.toInt ∧ ey.toInt≤969) :
    ∃ out, UnsignedState.exec FprPrimitives.headerCalls s FprAddCombine.statements=some out ∧
      out.types=s.types ∧ out.values ['e','x']=some (.i32 ex) ∧ out.values ['s','x']=some (.i32 sx) ∧
      out.values ['x','u']=some (.u64 (mantissa ex ey sx sy xu yu)) := by
  have hd := FprSmallSigned.sub32 ex ey (by omega)
  have c60 : (60#32).toInt=(60 : Int) := by decide +kernel
  have h60 := (FprSmallSigned.sub32 (ex-ey) 60#32 (by rw [c60]; omega)).1
  have hulsh (n : BitVec 32) :
      FprPrimitives.headerCalls ['f','p','r','_','u','l','s','h'] [.i32 1#32,.i32 n]=
        some (.u64 (FprHeaderTotal.ulshWord 1#64 n)) := FprHeaderTotal.header_ulsh_one n
  simp (config := { maxSteps := 200000 })
    [UnsignedState.exec,FprAddCombine.statements,FprUnsignedPrefixes.scalars,FprAST.addCode,
     CLogic.step,CLogic.eval,B20.C.Scalar.assign,B20.C.cast,B20.C.update,
     ht,hex,hey,hsx,hsy,hxu,hyu,FprUnsignedPrefixes.addTypes,List.foldl,
     FprUnsignedPrefixes.xyTypes,UnsignedState.setType,
     literalValue,bin,commonTy,Val.ty,bitsOp,shift,neg,
     FprHeaderTotal.signed_band32,FprAddCombine.signed_xor32,hd.1,h60,
     hulsh,FprHeaderTotal.header_ursh,shifted,mantissa]

end FT1536.Source3.FprAddCombine137
