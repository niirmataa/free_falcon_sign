import MultiplyLoop020D

namespace FT1536.S05.OutputValues020D
open WordRAM020 Residue020D Interleaved020D IndexReference020D DataWords020D
open BufferField020D ActualScatter020D
open FT1536.Relation FT1536.PublicSimulation FT1536.Run2.PolynomialReference

def keyValue (z : StandaloneRuntime019.CachedBox) (v : Coeffs) (j : Fin 1536) : Residue020D.F :=
  (signed z false j:Residue020D.F)+v ⟨exponentN j.val,exponent_bound j.val j.isLt⟩
def replyValue (z : StandaloneRuntime019.CachedBox) (j : Fin 1536) : Nat :=
  if j.val%2=0 then (z.2[(pairIndex j).val]).1.val else (z.2[(pairIndex j).val]).2.val
def sumRq (a b : Rq) : Rq := fun j => ((a j).1+(b j).1,(a j).2+(b j).2)

theorem reply_shift (z : StandaloneRuntime019.CachedBox) (j : Fin 1536) :
    signed z true j+65535=(replyValue z j:Int) := by
  by_cases hj : j.val%2=0 <;> simp [signed,replyValue,side,hj,VectorValues020C.decoded]

theorem reply_bound (z : StandaloneRuntime019.CachedBox) (j : Fin 1536) : replyValue z j<131071 := by
  unfold replyValue
  split
  · exact (z.2[(pairIndex j).val]).1.isLt
  · exact (z.2[(pairIndex j).val]).2.isLt

theorem sum_coefficient (a b : Rq) (p : TermIndex) :
    coefficient (sumRq a b) p=coefficient a p+coefficient b p := by
  rcases p with ⟨j,tag⟩
  cases tag <;> rfl

theorem vector_coefficient (v : StandaloneRuntime019.Scatter.Coeffs) (j : Fin 1536) :
    coefficient (StandaloneRuntime019.Scatter.view v) (term j)=v.get ⟨exponentN j.val,exponent_bound j.val j.isLt⟩ := by
  rw [coefficient_eq]
  rcases parity j.val with he|he <;>
    simp only [he,ite_true,one_ne_zero,ite_false,StandaloneRuntime019.Scatter.view,exponentN,zero_mul,one_mul,Nat.add_zero]
  all_goals rfl

theorem key_save (h : Rq) : StandaloneRuntime019.keyView (StandaloneRuntime019.saveKey h)=h := by
  funext j
  simp only [StandaloneRuntime019.keyView,StandaloneRuntime019.saveKey,Vector.getElem_ofFn]

theorem challenge_view (h : StandaloneRuntime019.Key) (z : StandaloneRuntime019.CachedBox) :
    StandaloneRuntime019.keyView (StandaloneRuntime019.challenge h z)=
      sumRq (reduceVec (decode (StandaloneRuntime019.view z)).1)
        (StandaloneRuntime019.Scatter.view (StandaloneRuntime019.Scatter.multiply (StandaloneRuntime019.keyView h) (noise z))) := by
  funext j
  simp only [StandaloneRuntime019.keyView,StandaloneRuntime019.challenge,Vector.getElem_ofFn]
  rfl

theorem key_reference (h : Rq) (z : StandaloneRuntime019.CachedBox) (j : Fin 1536) :
    keyValue z (fun r => (StandaloneRuntime019.Scatter.multiply h (noise z))[r.val]) j=
      coefficient (StandaloneRuntime019.keyView (StandaloneRuntime019.challenge (StandaloneRuntime019.saveKey h) z)) (term j) := by
  have hc : coefficient (reduceVec (decode (StandaloneRuntime019.view z)).1) (term j)=(signed z false j:Residue020D.F) := by
    simpa only [Bool.false_eq_true,ite_false] using coefficient_signed z false j
  rw [challenge_view,key_save,sum_coefficient,vector_coefficient,hc]
  rfl

end FT1536.S05.OutputValues020D
