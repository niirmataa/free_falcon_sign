import ActualVector020C
import FlagCore020C

namespace FT1536.S05.BoxImage020C
open WordRAM020 ReadSemantics020A JointInterface019 CdfPrefix020A
open PairStores020B TrialCorrect020A VectorValues020C VectorPrefix020C
open VectorLoopCore020C VectorLoop020C ActualVector020C
open FT1536.Relation
attribute [local irreducible] exec loopState values StandaloneRuntime019.vector StandaloneRuntime019.pair

abbrev Packed := Fin 1536 → Word × Word
def readVec (s : State) : Packed := fun p => (s.ram (slot0 p),s.ram (slot1 p))
def image (z : StandaloneRuntime019.CachedBox) : Packed := fun p =>
  if hp : p.val<768 then encoded z.1[p.val] else
    have hk : p.val-768<768 := by have := p.isLt; omega
    encoded z.2[p.val-768]
def answer (s : State) : Option Packed := FlagCore020C.observe 20 readVec s

theorem image_left (z : StandaloneRuntime019.CachedBox) (j : Fin 768) :
    image z ⟨j.val,by omega⟩=encoded z.1[j.val] := by
  simp only [image,dite_eq_left j.isLt]

theorem image_right (z : StandaloneRuntime019.CachedBox) (j : Fin 768) :
    image z ⟨768+j.val,by omega⟩=encoded z.2[j.val] := by
  simp only [image,dite_eq_right (show ¬768+j.val<768 by omega),Nat.add_sub_cancel_left]

theorem prefix_image (v : Values) (z : StandaloneRuntime019.CachedBox) (s : State)
    (pref : Prefix v 1536 s)
    (left : ∀ j : Fin 768, v j.val=decoded z.1[j.val])
    (right : ∀ j : Fin 768, v (768+j.val)=decoded z.2[j.val]) : readVec s=image z := by
  funext p
  have hp := pref p p.isLt
  change (s.ram (slot0 p),s.ram (slot1 p))=image z p
  rw [hp.1,hp.2]
  by_cases h : p.val<768
  · have hl := left ⟨p.val,h⟩
    rw [hl]
    simp only [image,dite_eq_left h]
    rfl
  · have hj : p.val-768<768 := by have := p.isLt;omega
    have hr := right ⟨p.val-768,hj⟩
    have he : 768+(p.val-768)=p.val := by omega
    rw [he] at hr
    rw [hr]
    simp only [image,dite_eq_right h]
    rfl

theorem vector_image (h : Rq) (t : Bits tapeSize) (n : Fin 196) (s : State)
    (h0 : s.reg 0=nw n.val) :
    readVec (exec (InputLayout020.encode h t) vectorCode s)=
      image (StandaloneRuntime019.vector StandaloneRuntime019.tables ((StandaloneRuntime019.seedEquiv t).1 n)) :=
  prefix_image (values (InputLayout020.encode h t) n.val)
    (StandaloneRuntime019.vector StandaloneRuntime019.tables ((StandaloneRuntime019.seedEquiv t).1 n))
    (exec (InputLayout020.encode h t) vectorCode s)
    (vector_correct h t n.val s n.isLt h0).1.2.2.2 (source_left h t n) (source_right h t n)

end FT1536.S05.BoxImage020C
