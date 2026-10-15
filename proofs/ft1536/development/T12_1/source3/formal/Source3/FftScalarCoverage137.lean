import Source3.FprFastCalls137
import Source3.KeygenSearchFft

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Syntactic coverage of the actual forward FFT's scalar-call names/arities.
   This is not a proof of pointer safety, initialized inputs or execution. -/
namespace FT1536.Source3.FftScalarCoverage137

def arity : FprFastCalls137.Kind → Nat
  | .add | .mul | .sub => 2
  | .neg | .sqr | .half | .double => 1

def accepts (name : B20.C.Name) (count : Nat) : Bool :=
  ((FprFastCalls137.lookup name).map (fun kind => arity kind==count)).getD false

def scalar : CLogic.Expr → Bool
  | .literal _ _ | .var _ => true
  | .cast _ e | .neg e | .bitNot e | .lnot e => scalar e
  | .bin _ a b | .cmp _ a b | .land a b | .lor a b => scalar a && scalar b
  | .call1 name a => accepts name 1 && scalar a
  | .call2 name a b => accepts name 2 && scalar a && scalar b
  | .call3 name a b c => accepts name 3 && scalar a && scalar b && scalar c

def expression : C99ArrayReference.Expr → Bool
  | .scalar e => scalar e
  | .load _ index | .load16 _ _ index => scalar index
  | .call1 name a => accepts name 1 && expression a
  | .call2 name a b => accepts name 2 && expression a && expression b

def scalarStatement : CLogic.Stmt → Bool
  | .declare _ _ => true
  | .assign _ e | .update _ _ e | .ret e => scalar e

def array : C99ArrayReference.Stmt → Bool
  | .skip | .declarePtr _ => true
  | .scalar code => scalarStatement code
  | .assign _ e => expression e
  | .bindPtr _ _ index => scalar index
  | .store64 _ index e | .store32 _ index e => scalar index && expression e
  | .copy _ _ di si count => scalar di && scalar si && scalar count
  | .seq a b => array a && array b
  | .scope _ _ body => array body
  | .branch condition yes no => scalar condition && array yes && array no
  | .while condition body => scalar condition && array body
  | .call _ _ => false

def procedure : C99ProcedureReference.Stmt → Bool
  | .base code => array code
  | .seq a b => procedure a && procedure b
  | .scope _ _ body => procedure body
  | .branch condition yes no => scalar condition && procedure yes && procedure no
  | .loop condition body increment => scalar condition && procedure body && procedure increment
  | .ret none | .breakLoop | .continueLoop => true
  | .ret (some e) => expression e
  | .call _ _ _ => false

theorem forward_source_covered :
    (KeygenSearchFft.program "falcon_FFT3".toList).map (fun function => procedure function.body)=some true := by
  decide +kernel

end FT1536.Source3.FftScalarCoverage137
