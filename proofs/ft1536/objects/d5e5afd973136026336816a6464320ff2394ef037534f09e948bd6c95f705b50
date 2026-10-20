import Source3.C99DivWhileProof

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99DivProof
open B20.C C99Typing C99StateBridge C99ValueBridge

def prelude : List CLogic.Stmt := FprUnsignedPrefixes.divPrefix
def tail : List CLogic.Stmt := (FprUnsignedPrefixes.scalars (FprAST.divCode.body.drop 6)).getD []
def initialStatement : CLogic.Stmt := .assign ['i'] (.literal .i32 0)
def referenceBody : C99ScalarReference.Stmt :=
  C99PrefixBridge.withTail prelude
    (.seq (C99Frontend.scalar initialStatement)
      (.seq (.while C99DivLoopBridge.condition C99DivLoopBridge.iteration) (C99Frontend.scalars tail)))
def referenceFunction : C99ScalarReference.Function :=
  ⟨FprAST.divCode.params.map (fun (t,n) => (type t,n)),.uint64,referenceBody⟩

theorem body_shape : FprAST.divCode.body=prelude.map FprPrimitives.Instr.scalar ++
    [.forInc ['i'] 55 FprDivRound.roundCode] ++ tail.map FprPrimitives.Instr.scalar := by rfl
theorem lowering : C99Frontend.function FprAST.divCode=some referenceFunction := by
  unfold C99Frontend.function
  rw [body_shape,List.append_assoc,C99PrefixBridge.lower_with_tail]
  simp [C99Frontend.lowerBody,C99DivLoopBridge.round_shape,C99ScalarToFpr.lower_scalars,
    referenceFunction,referenceBody,initialStatement,C99DivLoopBridge.condition,C99DivLoopBridge.condExpr,
    C99DivLoopBridge.iteration,C99DivLoopBridge.incrementExpr,C99Frontend.scalar,
    C99Frontend.expression,C99Frontend.binary,C99Frontend.comparison]
  exact ⟨rfl,rfl⟩

theorem params_checked : C99ParametersBridge.paramTypes FprAST.divCode.params=some FprUnsignedPrefixes.xyTypes := by rfl
theorem prelude_checked : checkBody C99HeaderSignature.signature FprUnsignedPrefixes.xyTypes prelude=
    some FprUnsignedPrefixes.divTypes := by rfl
theorem tail_checked : (checkBody C99HeaderSignature.signature FprUnsignedPrefixes.divTypes tail).isSome := by decide
theorem prelude_no_return : ∀ e, CLogic.Stmt.ret e∉prelude := by
  intro e; simp [prelude,FprUnsignedPrefixes.divPrefix,FprUnsignedPrefixes.scalars,FprAST.divCode]

def started (s : B20.C.Scalar.State) : B20.C.Scalar.State :=
  {s with values := B20.C.update s.values ['i'] (.i32 0)}

theorem start_inv (s : B20.C.Scalar.State) (hg : UnsignedState.Good FprUnsignedPrefixes.divCtx s) :
    FprDivLoopTotal.Inv (started s) 0 := by
  obtain ⟨x,hx⟩ := FprScalarSequence.get_u64 _ s ['x'] hg FprUnsignedPrefixes.div_ctx_x
  obtain ⟨y,hy⟩ := FprScalarSequence.get_u64 _ s ['y'] hg FprUnsignedPrefixes.div_ctx_y
  obtain ⟨xu,hxu⟩ := FprScalarSequence.get_u64 _ s ['x','u'] hg FprUnsignedPrefixes.div_ctx_xu
  obtain ⟨yu,hyu⟩ := FprScalarSequence.get_u64 _ s ['y','u'] hg FprUnsignedPrefixes.div_ctx_yu
  obtain ⟨q,hq⟩ := FprScalarSequence.get_u64 _ s ['q'] hg FprUnsignedPrefixes.div_ctx_q
  refine ⟨hg.1.trans FprUnsignedPrefixes.div_context_types,⟨x,?_⟩,⟨y,?_⟩,⟨xu,?_⟩,⟨yu,?_⟩,⟨q,?_⟩,?_⟩ <;>
    simp [started,B20.C.update,hx,hy,hxu,hyu,hq]

theorem div_complete (x y : BitVec 64) (z : C99IntegerReference.Value)
    (hs : C99ScalarReference.FunctionExec C99Frontend.headerCalls referenceFunction [.uint64 x,.uint64 y] z) :
    FprPrimitives.execute FprAST.divCode [.u64 x,.u64 y]=some (encode z) := by
  obtain ⟨env,v,hparam,hbody,hreturn⟩ := C99HeaderProof.function_inv _ _ _ _ hs
  obtain ⟨s,hbind,henv,ht,hgood⟩ := C99ParametersBridge.bind_complete FprAST.divCode.params [.u64 x,.u64 y]
    env FprUnsignedPrefixes.xyTypes params_checked hparam
  have hbind0 : B20.C.Scalar.bindArgs FprAST.divCode.params [.u64 x,.u64 y]=
      some (FprUnsignedPrefixes.initial x y) := FprUnsignedPrefixes.bind_xy x y
  have hs0 : s=FprUnsignedPrefixes.initial x y := Option.some.inj (hbind.symm.trans hbind0)
  rw [← henv] at hbody
  obtain ⟨middle,hprefix,hrest⟩ := C99PrefixBridge.prefix_inv _ _ _ _ _ prelude_no_return hbody
  obtain ⟨sp,hp,hsp,tp,gp⟩ := C99NormalBodyBridge.normal_complete C99HeaderSignature.signature
    C99Frontend.headerCalls FprPrimitives.headerCalls C99HeaderSignature.calls_ok prelude s
    FprUnsignedPrefixes.divTypes middle hgood (by rw [ht]; exact prelude_checked) hprefix
  have gpA : UnsignedState.Good FprUnsignedPrefixes.divCtx sp := by
    obtain ⟨sa,ha,hga⟩ := FprUnsignedPrefixes.div_prefix_total x y
    have hpa : UnsignedState.exec FprPrimitives.headerCalls (FprUnsignedPrefixes.initial x y)
        FprUnsignedPrefixes.divPrefix=some sp := by simpa [prelude,hs0] using hp
    have hsame : sa=sp := Option.some.inj (ha.symm.trans hpa)
    simpa [hsame] using hga
  rw [← hsp] at hrest
  rcases C99ControlInversion.seq_inv _ _ _ _ _ hrest with ⟨afterInit,hinit,hrest⟩ | ⟨r,hinit,_⟩
  · have ity : sp.types ['i']=some .i32 := by rw [tp]; rfl
    have icheck : expressionCheck C99HeaderSignature.signature sp.types (.literal .i32 0)=true := by rfl
    obtain ⟨si,hsi,hRi,_,gi⟩ := C99StatementBridge.assign_complete C99HeaderSignature.signature
      C99Frontend.headerCalls FprPrimitives.headerCalls C99HeaderSignature.calls_ok sp ['i'] (.literal .i32 0)
      .i32 (.normal afterInit) gp ity icheck hinit
    have hass : B20.C.Scalar.assign sp ['i'] (.i32 0)=some si := by
      simpa [CLogic.step,CLogic.eval,B20.C.literalValue] using hsi
    have hstart : si=started sp := by
      exact (Option.some.inj (by simpa [B20.C.Scalar.assign,ity,B20.C.cast,started] using hass)).symm
    have inv0 : FprDivLoopTotal.Inv si 0 := by rw [hstart]; exact start_inv sp gpA
    have hei : afterInit=environment si := C99ScalarReference.Result.normal.inj hRi
    subst afterInit
    rcases C99ControlInversion.seq_inv _ _ _ _ _ hrest with ⟨afterLoop,hwhile,htail⟩ | ⟨r,hwhile,_⟩
    · obtain ⟨last,hfold,hrlast,glast,inv55⟩ := C99DivWhileProof.all_55_reference_iterations si
        (.normal afterLoop) inv0 gi hwhile
      have helast : afterLoop=environment last := C99ScalarReference.Result.normal.inj hrlast
      subst afterLoop
      obtain ⟨ctxTail,hct⟩ := Option.isSome_iff_exists.mp tail_checked
      have hv := C99BodyBridge.body_complete C99HeaderSignature.signature C99Frontend.headerCalls
        FprPrimitives.headerCalls C99HeaderSignature.calls_ok tail .u64 last ctxTail v glast
        (by rw [inv55.types]; exact hct) htail
      obtain ⟨final,hfinal⟩ := C99ScalarToFpr.return_to_block tail .u64 last
        (B20.C.cast .u64 (encode v)) 250 (by decide) hv
      have hguard : FprPrimitives.guard ['i'] 55 last=some false := by
        simpa using FprDivLoopTotal.index_guard last 55 (by omega) inv55.index
      have hloop : FprPrimitives.execBlock 251 .u64
          (.forInc ['i'] 55 FprDivRound.roundCode::tail.map FprPrimitives.Instr.scalar) sp=
          some (final,some (B20.C.cast .u64 (encode v))) := by
        change (B20.C.Scalar.assign sp ['i'] (.i32 0)).bind
          (fun first => ((List.range 55).foldlM (fun acc _ => FprDivLoopTotal.oneStep acc) first).bind
            (fun finish => (FprPrimitives.guard ['i'] 55 finish).bind
              (fun g => if g then none else FprPrimitives.execBlock 250 .u64
                (tail.map FprPrimitives.Instr.scalar) finish))) = _
        rw [hass]
        dsimp only [Option.bind]
        rw [hfold]
        dsimp only [Option.bind]
        rw [hguard]
        exact hfinal
      have hfull : FprPrimitives.execBlock 256 .u64 FprAST.divCode.body s=
          some (final,some (B20.C.cast .u64 (encode v))) := by
        rw [body_shape,List.append_assoc,show 256=251+prelude.length by decide]
        rw [FprScalarSequence.scalar_prefix _ _ _ hp]
        exact hloop
      have hz : encode z=B20.C.cast .u64 (encode v) := by rw [hreturn]; exact C99ExpressionBridge.cast_encode .u64 v
      have htype : FprAST.divCode.result=.u64 := rfl
      simp [FprPrimitives.execute,hbind,htype,hfull,hz]
    · obtain ⟨_,_,no,_,_⟩ := C99DivWhileProof.all_55_reference_iterations si (.returned r) inv0 gi hwhile
      cases no
  · obtain ⟨_,_,_,_,_,no⟩ := C99ControlInversion.assign_inv _ _ _ _ _ hinit
    cases no

theorem pinned_div_complete (x y z : BitVec 64)
    (hs : C99Frontend.primitiveCall ['f','p','r','_','d','i','v'] [.uint64 x,.uint64 y] (.uint64 z)) :
    FprPrimitives.div x y=some z := by
  obtain ⟨f,hlookup,hf⟩ := hs
  have heq : f=referenceFunction := by simpa [C99Frontend.lookup,lowering] using hlookup.symm
  subst f
  have he := div_complete x y (.uint64 z) hf
  simp [FprPrimitives.div,FprPrimitives.call,FprAST.div_binding,he,encode]

end FT1536.Source3.C99DivProof

#check @FT1536.Source3.C99DivProof.pinned_div_complete
#print axioms FT1536.Source3.C99DivProof.pinned_div_complete
