import Source3.FprNormSteps137

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprNormFast137
open B20.C
open FprNormSteps137
open FprNormTotal (Ready)

theorem source (s : B20.C.Scalar.State) (e sx : BitVec 32) (m : BitVec 64)
    (ht : s.types=FprUnsignedPrefixes.addTypes)
    (he : s.values ['e','x']=some (.i32 e)) (hm : s.values ['x','u']=some (.u64 m))
    (hs : s.values ['s','x']=some (.i32 sx)) (hb : -1078≤e.toInt ∧ e.toInt≤969) :
    ∃ out, FprPrimitives.execScalars FprAST.normCode s=some out ∧
      Ready out (result e m).1 (result e m).2 sx ∧
      -1141≤(result e m).1.toInt ∧ (result e m).1.toInt≤1067 := by
  let v0 := (e-63#32,m)
  let v1 := step v0 32 32 5
  let v2 := step v1 48 16 4
  let v3 := step v2 56 8 3
  let v4 := step v3 60 4 2
  let v5 := step v4 62 2 1
  obtain ⟨s0,h0,r0,l0,u0⟩ := start_source s e sx m ht he hm hs hb
  change -1141≤v0.1.toInt at l0
  change v0.1.toInt≤906 at u0
  obtain ⟨s1,h1,r1,l1,u1⟩ := round_source s0 v0.1 sx v0.2 32 32 5 (by decide +kernel) (by decide +kernel) r0 (by omega)
  change v0.1.toInt≤v1.1.toInt at l1
  change v1.1.toInt≤v0.1.toInt+32 at u1
  obtain ⟨s2,h2,r2,l2,u2⟩ := round_source s1 v1.1 sx v1.2 48 16 4 (by decide +kernel) (by decide +kernel) r1 (by omega)
  change v1.1.toInt≤v2.1.toInt at l2
  change v2.1.toInt≤v1.1.toInt+32 at u2
  obtain ⟨s3,h3,r3,l3,u3⟩ := round_source s2 v2.1 sx v2.2 56 8 3 (by decide +kernel) (by decide +kernel) r2 (by omega)
  change v2.1.toInt≤v3.1.toInt at l3
  change v3.1.toInt≤v2.1.toInt+32 at u3
  obtain ⟨s4,h4,r4,l4,u4⟩ := round_source s3 v3.1 sx v3.2 60 4 2 (by decide +kernel) (by decide +kernel) r3 (by omega)
  change v3.1.toInt≤v4.1.toInt at l4
  change v4.1.toInt≤v3.1.toInt+32 at u4
  obtain ⟨s5,h5,r5,l5,u5⟩ := round_source s4 v4.1 sx v4.2 62 2 1 (by decide +kernel) (by decide +kernel) r4 (by omega)
  change v4.1.toInt≤v5.1.toInt at l5
  change v5.1.toInt≤v4.1.toInt+32 at u5
  obtain ⟨s6,h6,r6,l6,u6⟩ := last_source s5 v5.1 sx v5.2 r5 (by omega)
  refine ⟨s6,?_,r6,?_,?_⟩
  · have code : FprAST.normCode=FprAST.normCode.take 2 ++
        (FprNormRound.code 32 32 5 ++ FprNormRound.code 48 16 4 ++
         FprNormRound.code 56 8 3 ++ FprNormRound.code 60 4 2 ++
         FprNormRound.code 62 2 1 ++ FprAST.normCode.drop 22) := by rfl
    rw [FprScalarSequence.exec_scalars,code]
    simp only [FprScalarSequence.exec_append,h0,h1,h2,h3,h4,h5,h6,Option.bind_some]
  · change -1141≤(lastE v5.1 v5.2).toInt
    omega
  · change (lastE v5.1 v5.2).toInt≤1067
    omega

end FT1536.Source3.FprNormFast137
