import PairEncodingInjective020

namespace FT1536.S05.WireFormat020D
open WordRAM020 JointInterface019 FT1536.Relation FT1536.PublicSimulation
attribute [local irreducible] List.ofFn

/-- Total fixed-width encoding, including the full none branch. -/
def wire (a : Rq × Option BoxVec) : Bits outputSize := fun j =>
  have hb : j.val<(PairEncoding020.encode a).length := by
    rw [PairEncoding020.full_pair_length]
    exact j.isLt
  (PairEncoding020.encode a)[j.val]

theorem list_fixed (n : Nat) (xs : List Bool) (he : xs.length=n) :
    List.ofFn (fun j : Fin n => xs[j.val]'(by rw [he];exact j.isLt))=xs := by
  apply List.ext_getElem
  · exact List.length_ofFn.trans he.symm
  · intro j hj hj'
    rw [List.getElem_ofFn]

theorem wire_list (a : Rq × Option BoxVec) : List.ofFn (wire a)=PairEncoding020.encode a :=
  list_fixed outputSize (PairEncoding020.encode a) (PairEncoding020.full_pair_length a)

theorem wire_injective : Function.Injective wire := by
  intro a b he
  apply PairEncodingInjective020.full_pair_injective
  exact (wire_list a).symm.trans ((congrArg List.ofFn he).trans (wire_list b))

theorem of_list (out : Bits outputSize) (a : Rq × Option BoxVec)
    (he : List.ofFn out=PairEncoding020.encode a) : out=wire a :=
  List.ofFn_injective (he.trans (wire_list a).symm)

end FT1536.S05.WireFormat020D
