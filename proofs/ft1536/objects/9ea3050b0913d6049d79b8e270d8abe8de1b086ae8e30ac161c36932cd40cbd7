import Source3.C99AddMulSound

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99DivSound
open B20.C C99Typing C99ValueBridge C99DivLoopBridge

theorem condition_sound (s : B20.C.Scalar.State) (i : Nat) (hi : i≤55)
    (inv : FprDivLoopTotal.Inv s i) (hg : WellTyped s) :
    C99ScalarReference.Eval C99Frontend.headerCalls (environment s) condition
      (C99ScalarReference.boolean (decide (i<55))) := by
  have he : ExpressionFuel.unbounded FprPrimitives.headerCalls s.values condExpr=
      some (CLogic.boolean (decide (i<55))) := by
    have hidx := FprDivLoopTotal.index_value i (by omega)
    simp [ExpressionFuel.unbounded,condExpr,inv.index,literalValue,CLogic.compare,
      commonTy,Val.ty,B20.C.cast,Val.integer,hidx]
  exact C99ExpressionSound.expression_sound _ _ C99HeaderSound.header_sound s hg _ _ he

theorem iteration_sound (s next : B20.C.Scalar.State) (i : Nat) (hi : i<55)
    (inv : FprDivLoopTotal.Inv s i) (hg : WellTyped s)
    (h : FprDivLoopTotal.oneStep s=some next) :
    C99ScalarReference.Exec C99Frontend.headerCalls (environment s) iteration
      (.normal (environment next)) ∧ WellTyped next ∧ FprDivLoopTotal.Inv next (i+1) := by
  have hguard := FprDivLoopTotal.index_guard s i (by omega) inv.index
  have hh : (do
      let (inner,ret) ← FprPrimitives.execBlock 250 .u64 FprDivRound.roundCode s
      if ret.isSome then none else
        FprPrimitives.inc ['i'] (FprPrimitives.leaveBlock s inner (FprPrimitives.blockDecls FprDivRound.roundCode)))=some next := by
    simpa [FprDivLoopTotal.oneStep,hguard,hi] using h
  obtain ⟨⟨inner,ret⟩,hinner,hinc⟩ := Option.bind_eq_some_iff.mp hh
  have hret : ret=none := by
    cases ret with
    | none => rfl
    | some _ => simp at hinc
  rw [hret,round_shape] at hinner
  have hmodel := C99FprInversion.scalar_normal _ _ _ _ _ hinner
  obtain ⟨hr,gi,ti⟩ := C99BodySound.normal_sound C99HeaderSignature.signature C99Frontend.headerCalls
    FprPrimitives.headerCalls C99HeaderSound.header_sound roundStatements s inner roundTypes hg
    (by rw [inv.types]; exact round_checked) hmodel
  let clean := FprPrimitives.leaveBlock s inner (FprPrimitives.scalarDecls roundStatements)
  have hgc := C99ScopeBridge.restore_good s inner (FprPrimitives.scalarDecls roundStatements) hg gi
  have hblock : C99ScalarReference.Exec C99Frontend.headerCalls (environment s)
      (.block (FprPrimitives.blockDecls FprDivRound.roundCode) (C99Frontend.scalars roundStatements))
      (.normal (environment clean)) := by
    rw [decl_names,C99ScopeBridge.restore_environment]
    exact C99ScalarReference.Exec.blockNormal _ _ _ _ hr
  have hm : CLogic.step FprPrimitives.headerCalls clean (.assign ['i'] incrementExpr)=some next := by
    rw [increment_model]
    simpa [hret,decl_names] using hinc
  obtain ⟨hri,gn⟩ := C99StateSound.assign_sound _ _ C99HeaderSound.header_sound clean next ['i']
    incrementExpr hgc (by decide) hm
  obtain ⟨other,ho,invo⟩ := FprDivLoopTotal.one_step_total s i hi inv
  have heq : other=next := Option.some.inj (ho.symm.trans h)
  subst other
  exact ⟨C99ScalarReference.Exec.seqNormal _ _ _ _ _ hblock hri,gn,invo⟩

theorem while_sound (remaining : Nat) : ∀ (i : Nat) (s out : B20.C.Scalar.State),
    i+remaining=55 → FprDivLoopTotal.Inv s i → WellTyped s →
    C99DivWhileProof.repeatStep remaining s=some out →
    C99ScalarReference.Exec C99Frontend.headerCalls (environment s) (.while condition iteration)
      (.normal (environment out)) ∧ WellTyped out ∧ FprDivLoopTotal.Inv out 55 := by
  induction remaining with
  | zero =>
      intro i s out hi inv hg h
      have heq : s=out := Option.some.inj h
      subst out
      have hi55 : i=55 := by omega
      subst i
      exact ⟨C99ScalarReference.Exec.whileFalse _ _ _ _
        (condition_sound s 55 (by omega) inv hg) rfl,hg,inv⟩
  | succ n ih =>
      intro i s out hi inv hg h
      have hil : i<55 := by omega
      obtain ⟨next,hn,hr⟩ := Option.bind_eq_some_iff.mp h
      obtain ⟨hiter,gn,invn⟩ := iteration_sound s next i hil inv hg hn
      obtain ⟨htail,go,invo⟩ := ih (i+1) next out (by omega) invn gn hr
      have hc := condition_sound s i (by omega) inv hg
      exact ⟨C99ScalarReference.Exec.whileTrue _ _ _ _ _ _ hc (by simp [C99ScalarReference.boolean,hil,
        C99IntegerReference.Value.integer]) hiter htail,go,invo⟩

theorem div_sound (x y : BitVec 64) (w : Val)
    (h : FprPrimitives.execute FprAST.divCode [.u64 x,.u64 y]=some w) :
    C99ScalarReference.FunctionExec C99Frontend.headerCalls C99DivProof.referenceFunction
      [.uint64 x,.uint64 y] (value w) := by
  obtain ⟨s,out,hbind,hbody⟩ := C99FprInversion.execute_inv _ _ _ h
  obtain ⟨hp,hg⟩ := C99HeaderSound.bind_sound _ _ _ hbind
  have hbind0 : B20.C.Scalar.bindArgs FprAST.divCode.params [.u64 x,.u64 y]=
      some (FprUnsignedPrefixes.initial x y) := FprUnsignedPrefixes.bind_xy x y
  have hs : s=FprUnsignedPrefixes.initial x y := Option.some.inj (hbind.symm.trans hbind0)
  have ht : s.types=FprUnsignedPrefixes.xyTypes := by rw [hs]; rfl
  rw [C99DivProof.body_shape,List.append_assoc] at hbody
  obtain ⟨sp,hpre,hrest⟩ := C99FprInversion.prefix_inv C99DivProof.prelude _ s out (some w) .u64 251
    C99DivProof.prelude_no_return hbody
  obtain ⟨hrp,gp,tp⟩ := C99BodySound.normal_sound C99HeaderSignature.signature C99Frontend.headerCalls
    FprPrimitives.headerCalls C99HeaderSound.header_sound C99DivProof.prelude s sp
    FprUnsignedPrefixes.divTypes hg (by rw [ht]; exact C99DivProof.prelude_checked) hpre
  have gpA : UnsignedState.Good FprUnsignedPrefixes.divCtx sp := by
    obtain ⟨sa,ha,hga⟩ := FprUnsignedPrefixes.div_prefix_total x y
    have hpa : UnsignedState.exec FprPrimitives.headerCalls (FprUnsignedPrefixes.initial x y)
        FprUnsignedPrefixes.divPrefix=some sp := by simpa [C99DivProof.prelude,hs] using hpre
    have heq : sa=sp := Option.some.inj (ha.symm.trans hpa)
    simpa [heq] using hga
  change (B20.C.Scalar.assign sp ['i'] (.i32 0)).bind
    (fun first => ((List.range 55).foldlM (fun acc _ => FprDivLoopTotal.oneStep acc) first).bind
      (fun finish => (FprPrimitives.guard ['i'] 55 finish).bind
        (fun g => if g then none else FprPrimitives.execBlock 250 .u64
          (C99DivProof.tail.map FprPrimitives.Instr.scalar) finish)))=some (out,some w) at hrest
  obtain ⟨si,hsi,hloop⟩ := Option.bind_eq_some_iff.mp hrest
  obtain ⟨last,hfold,hsuffix⟩ := Option.bind_eq_some_iff.mp hloop
  obtain ⟨guard,hguard,htail⟩ := Option.bind_eq_some_iff.mp hsuffix
  have hgfalse : guard=false := by cases guard <;> simp_all
  rw [hgfalse] at htail
  have ity : sp.types ['i']=some .i32 := by rw [tp]; rfl
  have hstart : si=C99DivProof.started sp := by
    exact (Option.some.inj (by simpa [B20.C.Scalar.assign,ity,B20.C.cast,C99DivProof.started] using hsi)).symm
  have inv0 : FprDivLoopTotal.Inv si 0 := by rw [hstart]; exact C99DivProof.start_inv sp gpA
  have hinit : CLogic.step FprPrimitives.headerCalls sp (.assign ['i'] (.literal .i32 0))=some si := by
    simpa [CLogic.step,CLogic.eval,literalValue] using hsi
  obtain ⟨hri,gi⟩ := C99StateSound.assign_sound _ _ C99HeaderSound.header_sound sp si ['i'] (.literal .i32 0)
    gp (by decide) hinit
  rw [C99DivWhileProof.fold_length,List.length_range] at hfold
  obtain ⟨hrw,gl,inv55⟩ := while_sound 55 0 si last rfl inv0 gi hfold
  have hscalar := C99FprInversion.scalar_return _ _ _ _ _ _ htail
  obtain ⟨ctxTail,hct⟩ := Option.isSome_iff_exists.mp C99DivProof.tail_checked
  obtain ⟨v,hrt,hw⟩ := C99BodySound.return_sound C99HeaderSignature.signature C99Frontend.headerCalls
    FprPrimitives.headerCalls C99HeaderSound.header_sound C99DivProof.tail .u64 last ctxTail w gl
    (by rw [inv55.types]; exact hct) hscalar
  have hfull := C99FprInversion.prefix_sound _ _ _ _ _ _ hrp
    (C99ScalarReference.Exec.seqNormal _ _ _ _ _ hri
      (C99ScalarReference.Exec.seqNormal _ _ _ _ _ hrw hrt))
  rw [hw,cast_matches,value_encode]
  exact C99ScalarReference.FunctionExec.call _ _ _ hp hfull

end FT1536.Source3.C99DivSound

#print axioms FT1536.Source3.C99DivSound.div_sound
