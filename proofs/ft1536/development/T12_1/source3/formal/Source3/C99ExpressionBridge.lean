import Source3.C99OperatorBridge
import Source3.ExpressionFuel

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99ExpressionBridge
open B20.C C99ValueBridge

def CallsOK (sig : C99Typing.Types) (reference : C99ScalarReference.CallRelation)
    (model : B20.C.Scalar.Calls) : Prop :=
  ∀ name args z t, sig name=some t → reference name args z →
    model name (args.map encode)=some (encode z) ∧ z.type=type t

theorem cast_encode (t : Ty) (v : C99IntegerReference.Value) :
    encode (C99IntegerReference.convert (type t) v.integer)=B20.C.cast t (encode v) := by
  have h := cast_matches t (encode v)
  rw [value_encode] at h
  exact (congrArg encode h).symm.trans (encode_value _)

theorem literal_encode (t : Ty) (n : Nat) :
    encode (C99IntegerReference.convert (type t) n)=B20.C.literalValue t n := by
  cases t <;> simp [type,encode,C99IntegerReference.convert,literalValue]

theorem boolean_encode (b : Bool) : encode (C99ScalarReference.boolean b)=CLogic.boolean b := rfl
theorem truth_encode (v : C99IntegerReference.Value) :
    CLogic.truth (encode v)=decide (v.integer≠0) := by cases v <;> rfl

theorem binary_source_inv (calls : C99ScalarReference.CallRelation) (env : C99ScalarReference.Env)
    (op : BinOp) (a b : C99ScalarReference.Expr) (z : C99IntegerReference.Value)
    (h : C99ScalarReference.Eval calls env (C99Frontend.binary op a b) z) :
    ∃ x y, C99ScalarReference.Eval calls env a x ∧ C99ScalarReference.Eval calls env b y ∧
      C99OperatorBridge.Binary op x y z := by
  cases op <;> cases h <;> exact ⟨_,_,by assumption,by assumption,by assumption⟩

theorem infer_binary (sig ctx : C99Typing.Types) (op : BinOp) (a b : CLogic.Expr) (t : Ty)
    (h : C99Typing.infer sig ctx (.bin op a b)=some t) :
    ∃ ta tb, C99Typing.infer sig ctx a=some ta ∧ C99Typing.infer sig ctx b=some tb ∧
      t=C99OperatorBridge.resultType op ta tb ∧
      (op=.shr ∨ op=.shl → tb=.i32 ∨ tb=.u32) ∧
      (op=.shl → ta=.u64 ∨ ta=.u32) := by
  obtain ⟨ta,ha,hr⟩ := Option.bind_eq_some_iff.mp h
  obtain ⟨tb,hb,hr⟩ := Option.bind_eq_some_iff.mp hr
  refine ⟨ta,tb,ha,hb,?_,?_,?_⟩
  all_goals cases op <;> simp_all [C99OperatorBridge.resultType,C99Typing.count32,C99Typing.unsigned]
  all_goals tauto

theorem expression_complete (sig : C99Typing.Types) (rcalls : C99ScalarReference.CallRelation)
    (mcalls : B20.C.Scalar.Calls) (hok : CallsOK sig rcalls mcalls)
    (s : B20.C.Scalar.State) (hstate : C99Typing.WellTyped s) (e : CLogic.Expr)
    (t : Ty) (z : C99IntegerReference.Value)
    (ht : C99Typing.infer sig s.types e=some t)
    (he : C99ScalarReference.Eval rcalls (C99Typing.environment s) (C99Frontend.expression e) z) :
    ExpressionFuel.unbounded mcalls s.values e=some (encode z) ∧ z.type=type t := by
  induction e generalizing t z with
  | literal ty n =>
      cases he
      have hty : ty=t := Option.some.inj ht
      subst t
      exact ⟨by rw [literal_encode]; rfl,C99Typing.converted_type _ _⟩
  | var name =>
      cases he with
      | «variable» _ rt _ bound => exact C99Typing.variable_related s name t rt z hstate ht bound
  | cast ty e ih =>
      obtain ⟨te,hti,hr⟩ := Option.bind_eq_some_iff.mp ht
      have hty : ty=t := Option.some.inj hr
      subst t
      cases he with
      | cast _ _ v hv =>
          obtain ⟨hv',_⟩ := ih te v hti hv
          exact ⟨by simp [ExpressionFuel.unbounded,hv',cast_encode],C99Typing.converted_type _ _⟩
  | neg e ih =>
      cases he with
      | neg _ v _ hv hop =>
          obtain ⟨hv',hvt⟩ := ih t v ht hv
          have ho := C99UnaryBridge.neg_source_to_interpreter (encode v) (encode z)
            (by simpa only [value_encode] using hop)
          exact ⟨by simp [ExpressionFuel.unbounded,hv',ho],(C99OperatorBridge.neg_type _ _ hop).trans hvt⟩
  | bitNot e ih =>
      cases he with
      | complement _ v _ hv hop =>
          obtain ⟨hv',hvt⟩ := ih t v ht hv
          have ho := C99UnaryBridge.complement_source_to_interpreter (encode v) (encode z)
            (by simpa only [value_encode] using hop)
          exact ⟨by simp [ExpressionFuel.unbounded,hv',ho],(C99OperatorBridge.complement_type _ _ hop).trans hvt⟩
  | bin op a b iha ihb =>
      obtain ⟨ta,tb,ha,hb,hr,hct,hlt⟩ := infer_binary sig s.types op a b t ht
      obtain ⟨x,y,hx,hy,hop⟩ := binary_source_inv _ _ _ _ _ _ he
      obtain ⟨hx',hxt⟩ := iha ta x ha hx
      obtain ⟨hy',hyt⟩ := ihb tb y hb hy
      have ho := C99OperatorBridge.binary_complete op x y z
        (fun hh => by simpa [C99Typing.encoded_type y tb hyt] using hct hh)
        (fun hh => by simpa [C99Typing.encoded_type x ta hxt] using hlt hh) hop
      refine ⟨by simp [ExpressionFuel.unbounded,hx',hy',ho],?_⟩
      rw [hr]
      exact C99OperatorBridge.binary_type op x y z ta tb hxt hyt hop
  | cmp op a b iha ihb =>
      obtain ⟨ta,ha,hr⟩ := Option.bind_eq_some_iff.mp ht
      obtain ⟨tb,hb,hr⟩ := Option.bind_eq_some_iff.mp hr
      have hty : t=.i32 := (Option.some.inj hr).symm
      subst t
      cases he with
      | compare _ _ _ x y _ hx hy hop =>
          obtain ⟨hx',_⟩ := iha ta x ha hx
          obtain ⟨hy',_⟩ := ihb tb y hb hy
          have ho := C99CompareBridge.source_to_interpreter op (encode x) (encode y) (encode z)
            (by simpa only [value_encode] using hop)
          exact ⟨by simp [ExpressionFuel.unbounded,hx',hy',ho],C99OperatorBridge.compare_type _ _ _ _ hop⟩
  | lnot e ih =>
      obtain ⟨te,hti,hr⟩ := Option.bind_eq_some_iff.mp ht
      have hty : t=.i32 := (Option.some.inj hr).symm
      subst t
      cases he with
      | logicalNot _ v hv =>
          obtain ⟨hv',_⟩ := ih te v hti hv
          exact ⟨by simp [ExpressionFuel.unbounded,hv',truth_encode,boolean_encode],rfl⟩
  | land a b iha ihb =>
      obtain ⟨ta,ha,hr⟩ := Option.bind_eq_some_iff.mp ht
      obtain ⟨tb,hb,hr⟩ := Option.bind_eq_some_iff.mp hr
      have hty : t=.i32 := (Option.some.inj hr).symm
      subst t
      cases he with
      | andFalse _ _ v hv hz =>
          obtain ⟨hv',_⟩ := iha ta v ha hv
          exact ⟨by simp [ExpressionFuel.unbounded,hv',truth_encode,hz,boolean_encode],rfl⟩
      | andTrue _ _ x y hx hn hy =>
          obtain ⟨hx',_⟩ := iha ta x ha hx
          obtain ⟨hy',_⟩ := ihb tb y hb hy
          exact ⟨by simp [ExpressionFuel.unbounded,hx',hy',truth_encode,hn,boolean_encode],rfl⟩
  | lor a b iha ihb =>
      obtain ⟨ta,ha,hr⟩ := Option.bind_eq_some_iff.mp ht
      obtain ⟨tb,hb,hr⟩ := Option.bind_eq_some_iff.mp hr
      have hty : t=.i32 := (Option.some.inj hr).symm
      subst t
      cases he with
      | orTrue _ _ v hv hn =>
          obtain ⟨hv',_⟩ := iha ta v ha hv
          exact ⟨by simp [ExpressionFuel.unbounded,hv',truth_encode,hn,boolean_encode],rfl⟩
      | orFalse _ _ x y hx hz hy =>
          obtain ⟨hx',_⟩ := iha ta x ha hx
          obtain ⟨hy',_⟩ := ihb tb y hb hy
          exact ⟨by simp [ExpressionFuel.unbounded,hx',hy',truth_encode,hz,boolean_encode],rfl⟩
  | call1 name a iha =>
      obtain ⟨ta,ha,hname⟩ := Option.bind_eq_some_iff.mp ht
      cases he with
      | call1 _ _ v _ hv hc =>
          obtain ⟨hv',_⟩ := iha ta v ha hv
          obtain ⟨hc',hct⟩ := hok name [v] z t hname hc
          exact ⟨by simpa [ExpressionFuel.unbounded,hv'] using hc',hct⟩
  | call2 name a b iha ihb =>
      obtain ⟨ta,ha,hr⟩ := Option.bind_eq_some_iff.mp ht
      obtain ⟨tb,hb,hname⟩ := Option.bind_eq_some_iff.mp hr
      cases he with
      | call2 _ _ _ x y _ hx hy hc =>
          obtain ⟨hx',_⟩ := iha ta x ha hx
          obtain ⟨hy',_⟩ := ihb tb y hb hy
          obtain ⟨hc',hct⟩ := hok name [x,y] z t hname hc
          exact ⟨by simpa [ExpressionFuel.unbounded,hx',hy'] using hc',hct⟩
  | call3 name a b c iha ihb ihc =>
      obtain ⟨ta,ha,hr⟩ := Option.bind_eq_some_iff.mp ht
      obtain ⟨tb,hb,hr⟩ := Option.bind_eq_some_iff.mp hr
      obtain ⟨tc,hc,hname⟩ := Option.bind_eq_some_iff.mp hr
      cases he with
      | call3 _ _ _ _ x y v _ hx hy hz hcall =>
          obtain ⟨hx',_⟩ := iha ta x ha hx
          obtain ⟨hy',_⟩ := ihb tb y hb hy
          obtain ⟨hz',_⟩ := ihc tc v hc hz
          obtain ⟨hcall',hrt⟩ := hok name [x,y,v] z t hname hcall
          exact ⟨by simpa [ExpressionFuel.unbounded,hx',hy',hz'] using hcall',hrt⟩

end FT1536.Source3.C99ExpressionBridge

#check @FT1536.Source3.C99ExpressionBridge.expression_complete
#print axioms FT1536.Source3.C99ExpressionBridge.expression_complete
