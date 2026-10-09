import Source3.KeygenPublicInputLifetime

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Ordinary field values of actual expressions. Range is only one conjunct;
   every value equation below is derived separately from the source calls. -/
namespace FT1536.Source3.KeygenPublicValueExpr
open C99ArrayReference (State)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenPublicAlgebra (R Canonical value radix)
open KeygenPublicRangeExpr (Ranged word word_argument word_range)
open KeygenPublicWord (Eval)
open KeygenWordExpr (Expr)
open KeygenPublicTableAtoms (Slot var literal mont)
open KeygenPublicExec (Exec Stmt)

def meaning (v : Value) : R := v.integer
def Evaluates (s : State) (e : Expr) (z : R) : Prop :=
  ∀ v, Eval [] s e v → Ranged v ∧ meaning v=z
def Local (s : State) (name : String) (z : R) : Prop :=
  ∃ w, Slot s name w ∧ Canonical w ∧ value w=z
def add (a b : Expr) : Expr := .call3 (KeygenPublicScalar.name .add) a b (literal 18433)
def sub (a b : Expr) : Expr := .call3 (KeygenPublicScalar.name .sub) a b (literal 18433)

theorem word_meaning (v : Value) (range : Ranged v) : value (word v)=meaning v := by
  rw [value,KeygenPublicRangeExpr.word_nat v range]
  have eq : (v.integer.toNat : Int)=v.integer := Int.toNat_of_nonneg range.1
  exact (Int.cast_natCast v.integer.toNat).symm.trans (congrArg (fun z : Int => (z : R)) eq)

theorem local_value (s : State) (name : String) (z : R) (fact : Local s name z) : Evaluates s (var name) z := by
  obtain ⟨w,slot,range,eq⟩ := fact
  intro v source
  rw [KeygenPublicTableAtoms.variable_value [] s name w v slot source]
  exact ⟨KeygenPublicRangeExpr.uint32_range w range,
    by simpa only [meaning,Value.integer,Int.cast_natCast,KeygenPublicAlgebra.value] using eq⟩

theorem add_value (s : State) (a b : Expr) (x y : R)
    (left : Evaluates s a x) (right : Evaluates s b y) : Evaluates s (add a b) (x+y) := by
  intro v source
  cases source with
  | call3 _ _ _ _ av bv qv _ first second third called =>
      obtain ⟨ar,ae⟩ := left av first
      obtain ⟨br,be⟩ := right bv second
      have qm := KeygenPublicTableAtoms.literal_argument [] s 18433 qv third
      have normalized := KeygenPublicArguments.call_leaf_conversion .add (by decide) [av,bv,qv]
        [.uint32 (word av),.uint32 (word bv),.uint32 18433] v
        (.cons _ _ _ _ _ _ _ ((word_argument av ar).trans (KeygenPublicArguments.u32_self _).symm)
          (.cons _ _ _ _ _ _ _ ((word_argument bv br).trans (KeygenPublicArguments.u32_self _).symm)
            (.cons _ _ _ _ _ _ _ (qm.trans (KeygenPublicArguments.u32_self _).symm) .nil))) called
      have eq := KeygenPublicLeafWords.source_add _ (word av) (word bv) 18433 v
        (KeygenPublicAlgebra.call_leaf .add (by decide) _ _ normalized)
      rw [eq] at normalized ⊢
      obtain ⟨range,law⟩ := KeygenPublicAlgebra.source_add _ _ _ (word_range av ar) (word_range bv br) normalized
      refine ⟨KeygenPublicRangeExpr.uint32_range _ range,?_⟩
      change value _=x+y
      rw [law,word_meaning av ar,word_meaning bv br,ae,be]

theorem sub_value (s : State) (a b : Expr) (x y : R)
    (left : Evaluates s a x) (right : Evaluates s b y) : Evaluates s (sub a b) (x-y) := by
  intro v source
  cases source with
  | call3 _ _ _ _ av bv qv _ first second third called =>
      obtain ⟨ar,ae⟩ := left av first
      obtain ⟨br,be⟩ := right bv second
      have qm := KeygenPublicTableAtoms.literal_argument [] s 18433 qv third
      have normalized := KeygenPublicArguments.call_leaf_conversion .sub (by decide) [av,bv,qv]
        [.uint32 (word av),.uint32 (word bv),.uint32 18433] v
        (.cons _ _ _ _ _ _ _ ((word_argument av ar).trans (KeygenPublicArguments.u32_self _).symm)
          (.cons _ _ _ _ _ _ _ ((word_argument bv br).trans (KeygenPublicArguments.u32_self _).symm)
            (.cons _ _ _ _ _ _ _ (qm.trans (KeygenPublicArguments.u32_self _).symm) .nil))) called
      have eq := KeygenPublicLeafWords.source_sub _ (word av) (word bv) 18433 v
        (KeygenPublicAlgebra.call_leaf .sub (by decide) _ _ normalized)
      rw [eq] at normalized ⊢
      obtain ⟨range,law⟩ := KeygenPublicAlgebra.source_sub _ _ _ (word_range av ar) (word_range bv br) normalized
      refine ⟨KeygenPublicRangeExpr.uint32_range _ range,?_⟩
      change value _=x-y
      rw [law,word_meaning av ar,word_meaning bv br,ae,be]

theorem twiddle_value (s : State) (a b : Expr) (x z : R)
    (left : Evaluates s a x) (right : Evaluates s b (radix*z)) : Evaluates s (mont a b) (x*z) := by
  intro v source
  cases source with
  | call4 _ _ _ _ _ av bv qv iv _ first second third fourth called =>
      obtain ⟨ar,ae⟩ := left av first
      obtain ⟨br,be⟩ := right bv second
      have qm := KeygenPublicTableAtoms.literal_argument [] s 18433 qv third
      have im := KeygenPublicTableAtoms.literal_argument [] s 18431 iv fourth
      have eq := KeygenPublicArguments.source_mul_exact (word av) (word bv) av bv qv iv v
        (word_argument av ar) (word_argument bv br) qm im called
      rw [eq] at called ⊢
      obtain ⟨range,law⟩ := KeygenPublicArguments.source_mul _ _ _ av bv qv iv (word_range av ar) (word_range bv br)
        (word_argument av ar) (word_argument bv br) qm im called
      rw [word_meaning av ar,word_meaning bv br,ae,be] at law
      refine ⟨KeygenPublicRangeExpr.uint32_range _ range,?_⟩
      change value _=x*z
      calc
        value _=(value _*radix)*radix⁻¹ := by rw [mul_assoc,KeygenPublicAlgebra.radix_inverse,mul_one]
        _=(x*(radix*z))*radix⁻¹ := by rw [law]
        _=(x*z)*(radix*radix⁻¹) := by ring
        _=x*z := by rw [KeygenPublicAlgebra.radix_inverse,mul_one]

theorem local_after (code : Stmt) (s : State) (out : Result) (name : String) (z : R)
    (ok : KeygenPublicTableControl.supported code=true) (keep : name.toList∉KeygenPublicTableControl.writes code)
    (fact : Local s name z) (source : Exec KeygenPublicSource.program [] code s out) : Local out.state name z := by
  obtain ⟨w,slot,range,eq⟩ := fact
  exact ⟨w,(KeygenPublicTableControl.frame _ _ _ _ _ ok source).2.2 _ keep |>.trans slot,range,eq⟩

theorem assign_value (s : State) (out : Result) (name : String) (e : Expr) (z : R)
    (declared : ∃ old, s.locals name.toList=some (.uint32,old)) (value : Evaluates s e z)
    (source : Exec KeygenPublicSource.program [] (.assign name.toList e) s out) : Local out.state name z := by
  obtain ⟨old,bound⟩ := declared
  cases source with
  | assign _ _ _ ty previous v slot evaluated =>
      have te := congrArg Prod.fst (Option.some.inj (slot.symm.trans bound))
      dsimp only at te
      subst ty
      obtain ⟨range,eq⟩ := value v evaluated
      refine ⟨word v,?_,word_range v range,(word_meaning v range).trans eq⟩
      have converted := word_argument v range
      unfold KeygenPublicArguments.U32 at converted
      simp only [Slot,C99ArrayReference.bindValue,C99ScalarReference.set,ite_true,converted]

end FT1536.Source3.KeygenPublicValueExpr
