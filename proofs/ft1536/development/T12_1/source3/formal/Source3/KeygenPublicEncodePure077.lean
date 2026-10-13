import Source3.KeygenPublicEncodeExecution077
import Source3.KeygenCodecScalarCalculation

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicEncodePure077
open KeygenCodecSyntax KeygenPublicEncodeValues077 C99MemoryReference
abbrev IV := C99IntegerReference.Value
abbrev Ordinary := KeygenCodecScalarCalculation.Ordinary
abbrev Computes := KeygenCodecScalarCalculation.Computes

theorem exists_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (l : Locals) (e : Expr) (v : IV) (calculation : Computes l e v) : Eval args heap buf e l (.integer v) l := by
  induction calculation with
  | number ty n v value => exact .number _ _ _ _ value
  | scalar name ty v ordinary cell => exact .scalar _ _ _ _ cell
  | cast ty e v z inner converted ih => exact .cast _ _ _ _ _ _ ih converted
  | unary op e v z inner operation ih => exact .unary _ _ _ _ _ _ ih operation
  | binary op a b x y z left right operation ih1 ih2 => exact .binary _ _ _ _ _ _ _ _ _ ih1 ih2 operation

theorem value_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (l : Locals) (e : Expr) (v : IV) (calculation : Computes l e v)
    (t : Locals) (result : Value) (source : Eval args heap buf e l result t) : result=.integer v ∧ t=l := by
  induction calculation generalizing t result with
  | number ty n v value =>
    cases source with
    | number ty n actual l cast =>
      have equal := Option.some.inj (cast.symm.trans value)
      subst actual
      exact ⟨rfl,rfl⟩
  | scalar name ty v ordinary cell => cases source <;> simp_all [KeygenCodecScalarCalculation.Ordinary]
  | cast ty e v z inner converted ih =>
    cases source with
    | cast ty e l t v z evaluated cast =>
      obtain ⟨same,last⟩ := ih t _ evaluated
      cases same
      exact ⟨congrArg KeygenCodecValues.Value.integer (Option.some.inj (cast.symm.trans converted)),last⟩
  | unary op e v z inner operation ih =>
    cases source with
    | unary op e l t v z evaluated actual =>
      obtain ⟨same,last⟩ := ih t _ evaluated
      subst v
      exact ⟨KeygenCodecScalarCalculation.unary_unique _ _ _ _ actual operation,last⟩
    | dereference => cases operation
  | binary op a b x y z left right operation ih1 ih2 =>
    cases source with
    | binary op a b l middle t x y z first second actual =>
      obtain ⟨same,last⟩ := ih1 middle _ first
      subst x; subst middle
      obtain ⟨same,last⟩ := ih2 t _ second
      subst y
      exact ⟨KeygenCodecScalarCalculation.binary_unique _ _ _ _ _ actual operation,last⟩
    | andFalse => cases operation
    | andTrue => cases operation
    | orTrue => cases operation
    | orFalse => cases operation

end FT1536.Source3.KeygenPublicEncodePure077
