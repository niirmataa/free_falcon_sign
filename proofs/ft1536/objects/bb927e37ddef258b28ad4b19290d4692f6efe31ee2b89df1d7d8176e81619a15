import Source3.C99NormalBodyBridge
import Source3.FprScalarSequence

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99ScopeBridge
open B20.C C99Typing

theorem restore_environment (outer inner : B20.C.Scalar.State) (names : List Name) :
    environment (FprPrimitives.leaveBlock outer inner names)=
      C99ScalarReference.restore (environment outer) (environment inner) names := by
  funext name
  by_cases h : name∈names <;>
    simp [environment,FprPrimitives.leaveBlock,C99ScalarReference.restore,h]

theorem restore_good (outer inner : B20.C.Scalar.State) (names : List Name)
    (ho : WellTyped outer) (hi : WellTyped inner) :
    WellTyped (FprPrimitives.leaveBlock outer inner names) := by
  intro name v hv
  by_cases h : name∈names
  · have hread : outer.values name=some v := by simpa [FprPrimitives.leaveBlock,h] using hv
    simpa [FprPrimitives.leaveBlock,h] using ho name v hread
  · have hread : inner.values name=some v := by simpa [FprPrimitives.leaveBlock,h] using hv
    simpa [FprPrimitives.leaveBlock,h] using hi name v hread

theorem block_inv (rc : C99ScalarReference.CallRelation) (env : C99ScalarReference.Env)
    (names : List Name) (body : C99ScalarReference.Stmt) (r : C99ScalarReference.Result)
    (hs : C99ScalarReference.Exec rc env (.block names body) r) :
    (∃ inner, C99ScalarReference.Exec rc env body (.normal inner) ∧
      r=.normal (C99ScalarReference.restore env inner names)) ∨
    (∃ v, C99ScalarReference.Exec rc env body (.returned v) ∧ r=.returned v) := by
  cases hs
  · exact Or.inl ⟨_,by assumption,rfl⟩
  · exact Or.inr ⟨_,by assumption,rfl⟩

theorem scalar_block_complete (sig : Types) (rc : C99ScalarReference.CallRelation)
    (mc : B20.C.Scalar.Calls) (hok : C99ExpressionBridge.CallsOK sig rc mc)
    (s : B20.C.Scalar.State) (body : List CLogic.Stmt) (ctx : Types)
    (r : C99ScalarReference.Result) (hgood : WellTyped s)
    (hc : C99StateBridge.checkBody sig s.types body=some ctx)
    (hn : ∀ e, CLogic.Stmt.ret e∉body)
    (hs : C99ScalarReference.Exec rc (environment s)
      (.block (FprPrimitives.scalarDecls body) (C99Frontend.scalars body)) r) :
    ∃ out, UnsignedState.exec mc s body=some out ∧ out.types=ctx ∧ WellTyped out ∧
      r=.normal (environment (FprPrimitives.leaveBlock s out (FprPrimitives.scalarDecls body))) := by
  rcases block_inv _ _ _ _ _ hs with ⟨inner,hbody,hresult⟩ | ⟨v,hreturn,_⟩
  · obtain ⟨out,ho,henv,ht,hgo⟩ := C99NormalBodyBridge.normal_complete sig rc mc hok body s ctx inner hgood hc hbody
    refine ⟨out,ho,ht,hgo,?_⟩
    rw [restore_environment,henv]
    exact hresult
  · exact False.elim (C99NormalBodyBridge.normal_no_return body hn rc (environment s) v hreturn)

end FT1536.Source3.C99ScopeBridge

#print axioms FT1536.Source3.C99ScopeBridge.scalar_block_complete
