import BoxImage020C
import IndexReference020D
import Residue020D

namespace FT1536.S05.DataWords020D
open WordRAM020 BoxImage020C PairStores020B TrialCorrect020A VectorValues020C
open Interleaved020D IndexReference020D PairCoordinate020B Residue020D
open FT1536.Geometry FT1536.PublicSimulation FT1536.Relation FT1536.Run2.PolynomialReference

def side (z : StandaloneRuntime019.CachedBox) (b : Bool) : Vector StandaloneRuntime019.Block 768 :=
  if b then z.2 else z.1
def signed (z : StandaloneRuntime019.CachedBox) (b : Bool) (j : Fin 1536) : Int :=
  if j.val%2=0 then (decoded (side z b)[(pairIndex j).val]).1 else (decoded (side z b)[(pairIndex j).val]).2
def dataSlot (b : Bool) (j : Fin 1536) : Fin ramSize :=
  ⟨(if b then 1536 else 0)+j.val,by have := j.isLt;unfold ramSize;split <;> omega⟩

theorem signed_bounds (z : StandaloneRuntime019.CachedBox) (b : Bool) (j : Fin 1536) :
    -65535≤signed z b j ∧ signed z b j≤65535 := by
  unfold signed
  split
  · exact coordinate_bound ((side z b)[(pairIndex j).val]).1
  · exact coordinate_bound ((side z b)[(pairIndex j).val]).2

theorem half_words (s : State) (z : StandaloneRuntime019.CachedBox) (b : Bool) (p : Fin 768)
    (hs : readVec s=image z) :
    (s.ram ⟨(if b then 1536 else 0)+2*p.val,by have := p.isLt;unfold ramSize;split <;> omega⟩,
     s.ram ⟨(if b then 1536 else 0)+2*p.val+1,by have := p.isLt;unfold ramSize;split <;> omega⟩)=
      encoded (side z b)[p.val] := by
  cases b
  · have h := congrFun hs (⟨p.val,by omega⟩:Fin 1536)
    rw [image_left z p] at h
    simpa only [readVec,slot0,slot1,side,Bool.false_eq_true,ite_false,Nat.zero_add] using h
  · have h := congrFun hs (⟨768+p.val,by omega⟩:Fin 1536)
    rw [image_right z p] at h
    have h0 : (⟨1536+2*p.val,by have := p.isLt;unfold ramSize;omega⟩:Fin ramSize)=slot0 ⟨768+p.val,by omega⟩ := by
      apply Fin.ext;change 1536+2*p.val=2*(768+p.val);omega
    have h1 : (⟨1536+2*p.val+1,by have := p.isLt;unfold ramSize;omega⟩:Fin ramSize)=slot1 ⟨768+p.val,by omega⟩ := by
      apply Fin.ext;change 1536+2*p.val+1=2*(768+p.val)+1;omega
    change (s.ram ⟨1536+2*p.val,_⟩,s.ram ⟨1536+2*p.val+1,_⟩)=_
    rw [h0,h1]
    exact h

theorem data_word (s : State) (z : StandaloneRuntime019.CachedBox) (b : Bool) (j : Fin 1536)
    (hs : readVec s=image z) : s.ram (dataSlot b j)=word (signed z b j) := by
  have hh := half_words s z b (pairIndex j) hs
  rcases parity j.val with hp|hp
  · have he : dataSlot b j=(⟨(if b then 1536 else 0)+2*(pairIndex j).val,by have := j.isLt;unfold ramSize;split <;> omega⟩:Fin ramSize) := by
      apply Fin.ext;change (if b then 1536 else 0)+j.val=(if b then 1536 else 0)+2*(j.val/2);omega
    rw [he]
    simpa only [signed,hp,ite_true,encoded,decoded] using congrArg Prod.fst hh
  · have he : dataSlot b j=(⟨(if b then 1536 else 0)+2*(pairIndex j).val+1,by have := j.isLt;unfold ramSize;split <;> omega⟩:Fin ramSize) := by
      apply Fin.ext;change (if b then 1536 else 0)+j.val=(if b then 1536 else 0)+2*(j.val/2)+1;omega
    rw [he]
    simpa only [signed,hp,one_ne_zero,ite_false,encoded,decoded] using congrArg Prod.snd hh

theorem coefficient_signed (z : StandaloneRuntime019.CachedBox) (b : Bool) (j : Fin 1536) :
    coefficient (reduceVec (if b then (decode (StandaloneRuntime019.view z)).2 else
      (decode (StandaloneRuntime019.view z)).1)) (term j)=(signed z b j:Residue020D.F) := by
  rw [coefficient_eq]
  cases b <;> unfold signed side <;> split <;> rfl

end FT1536.S05.DataWords020D
