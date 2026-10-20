import Source3.KeygenNttWordAlgebra

namespace FT1536.Source3.KeygenNttButterflyAlgebra
open KeygenNttWordAlgebra (R value radix)

def Add (a b out : BitVec 32) : Prop := KeygenModpAddSub.SourceExec .add a b KeygenNinv31.prime (.uint32 out)
def Sub (a b out : BitVec 32) : Prop := KeygenModpAddSub.SourceExec .sub a b KeygenNinv31.prime (.uint32 out)
def Mul (p0i a b out : BitVec 32) : Prop := KeygenModpWord.SourceExec a b KeygenNinv31.prime p0i (.uint32 out)
def Canonical (word : BitVec 32) : Prop := word.toNat<KeygenNinv31.prime.toNat

/- Intermediate call observations only. Their extraction from the parsed
   memory/control bodies is the next source-binding obligation. -/
structure FirstCalls (a0 a1 w p0i low high : BitVec 32) where
  product : BitVec 32
  sum : BitVec 32
  multiply : Mul p0i a1 w product
  lowCall : Add a0 product low
  sumCall : Add a0 a1 sum
  highCall : Sub sum product high

theorem first_values (a0 a1 w p0i low high : BitVec 32) (root : R)
    (ha0 : Canonical a0) (ha1 : Canonical a1) (hw : Canonical w)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (scaled : value w=radix*root) (calls : FirstCalls a0 a1 w p0i low high) :
    Canonical low ∧ Canonical high ∧
      value low=value a0+value a1*root ∧ value high=value a0+value a1-value a1*root := by
  have product := KeygenNttWordAlgebra.source_twiddle a1 w p0i calls.product root ha1 hw initialization scaled calls.multiply
  have sum := KeygenNttWordAlgebra.source_add a0 a1 calls.sum ha0 ha1 calls.sumCall
  have lo := KeygenNttWordAlgebra.source_add a0 calls.product low ha0 product.1 calls.lowCall
  have hi := KeygenNttWordAlgebra.source_sub calls.sum calls.product high sum.1 product.1 calls.highCall
  rw [product.2] at lo
  rw [sum.2,product.2] at hi
  exact ⟨lo.1,hi.1,lo.2,hi.2⟩

structure BinaryCalls (x y s p0i low high : BitVec 32) where
  product : BitVec 32
  multiply : Mul p0i y s product
  lowCall : Add x product low
  highCall : Sub x product high

theorem binary_values (x y s p0i low high : BitVec 32) (root : R)
    (hx : Canonical x) (hy : Canonical y) (hs : Canonical s)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (scaled : value s=radix*root) (calls : BinaryCalls x y s p0i low high) :
    Canonical low ∧ Canonical high ∧ value low=value x+value y*root ∧ value high=value x-value y*root := by
  have product := KeygenNttWordAlgebra.source_twiddle y s p0i calls.product root hy hs initialization scaled calls.multiply
  have lo := KeygenNttWordAlgebra.source_add x calls.product low hx product.1 calls.lowCall
  have hi := KeygenNttWordAlgebra.source_sub x calls.product high hx product.1 calls.highCall
  rw [product.2] at lo hi
  exact ⟨lo.1,hi.1,lo.2,hi.2⟩

structure TripleCalls (a b c x w p0i out0 out1 out2 : BitVec 32) where
  x2 : BitVec 32
  b0 : BitVec 32
  b1 : BitVec 32
  b2 : BitVec 32
  c0 : BitVec 32
  c1 : BitVec 32
  c2 : BitVec 32
  s0 : BitVec 32
  s1 : BitVec 32
  s2 : BitVec 32
  squareCall : Mul p0i x x x2
  b0Call : Mul p0i b x b0
  b1Call : Mul p0i b0 w b1
  b2Call : Mul p0i b1 w b2
  c0Call : Mul p0i c x2 c0
  c1Call : Mul p0i c0 w c1
  c2Call : Mul p0i c1 w c2
  s0Call : Add b0 c0 s0
  s1Call : Add b1 c2 s1
  s2Call : Add b2 c1 s2
  out0Call : Add a s0 out0
  out1Call : Add a s1 out1
  out2Call : Add a s2 out2

theorem triple_values (a b c x w p0i out0 out1 out2 : BitVec 32) (root unity : R)
    (ha : Canonical a) (hb : Canonical b) (hc : Canonical c) (hx : Canonical x) (hw : Canonical w)
    (initialization : KeygenNinv31.SourceExec KeygenNinv31.prime (.uint32 p0i))
    (scaledRoot : value x=radix*root) (scaledUnity : value w=radix*unity) (unityCube : unity^3=1)
    (calls : TripleCalls a b c x w p0i out0 out1 out2) :
    Canonical out0 ∧ Canonical out1 ∧ Canonical out2 ∧
      value out0=value a+value b*root+value c*root^2 ∧
      value out1=value a+value b*(root*unity)+value c*(root*unity)^2 ∧
      value out2=value a+value b*(root*unity^2)+value c*(root*unity^2)^2 := by
  have x2 := KeygenNttWordAlgebra.source_scaled_product x x p0i calls.x2 root root hx hx initialization scaledRoot scaledRoot calls.squareCall
  have b0 := KeygenNttWordAlgebra.source_twiddle b x p0i calls.b0 root hb hx initialization scaledRoot calls.b0Call
  have b1 := KeygenNttWordAlgebra.source_twiddle calls.b0 w p0i calls.b1 unity b0.1 hw initialization scaledUnity calls.b1Call
  have b2 := KeygenNttWordAlgebra.source_twiddle calls.b1 w p0i calls.b2 unity b1.1 hw initialization scaledUnity calls.b2Call
  have c0 := KeygenNttWordAlgebra.source_twiddle c calls.x2 p0i calls.c0 (root*root) hc x2.1 initialization x2.2 calls.c0Call
  have c1 := KeygenNttWordAlgebra.source_twiddle calls.c0 w p0i calls.c1 unity c0.1 hw initialization scaledUnity calls.c1Call
  have c2 := KeygenNttWordAlgebra.source_twiddle calls.c1 w p0i calls.c2 unity c1.1 hw initialization scaledUnity calls.c2Call
  have s0 := KeygenNttWordAlgebra.source_add calls.b0 calls.c0 calls.s0 b0.1 c0.1 calls.s0Call
  have s1 := KeygenNttWordAlgebra.source_add calls.b1 calls.c2 calls.s1 b1.1 c2.1 calls.s1Call
  have s2 := KeygenNttWordAlgebra.source_add calls.b2 calls.c1 calls.s2 b2.1 c1.1 calls.s2Call
  have o0 := KeygenNttWordAlgebra.source_add a calls.s0 out0 ha s0.1 calls.out0Call
  have o1 := KeygenNttWordAlgebra.source_add a calls.s1 out1 ha s1.1 calls.out1Call
  have o2 := KeygenNttWordAlgebra.source_add a calls.s2 out2 ha s2.1 calls.out2Call
  refine ⟨o0.1,o1.1,o2.1,?_,?_,?_⟩
  · rw [o0.2,s0.2,b0.2,c0.2]
    ring
  · rw [o1.2,s1.2,b1.2,b0.2,c2.2,c1.2,c0.2]
    ring
  · rw [o2.2,s2.2,b2.2,b1.2,b0.2,c1.2,c0.2]
    have fourth : unity^4=unity := by rw [show (4 : Nat)=3+1 by decide,pow_succ,unityCube,one_mul]
    ring_nf
    rw [fourth]

end FT1536.Source3.KeygenNttButterflyAlgebra
