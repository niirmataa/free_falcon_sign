import Source3.C99ScopeBridge
import Source3.C99ScalarToFpr

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99PrefixBridge
open B20.C

def withTail : List CLogic.Stmt → C99ScalarReference.Stmt → C99ScalarReference.Stmt
  | [],tail => tail
  | stmt::rest,tail => .seq (C99Frontend.scalar stmt) (withTail rest tail)

theorem lower_with_tail (stmts : List CLogic.Stmt) (rest : List FprPrimitives.Instr) :
    C99Frontend.lowerBody (stmts.map FprPrimitives.Instr.scalar ++ rest)=
      (C99Frontend.lowerBody rest).map (withTail stmts) := by
  induction stmts with
  | nil => simp [withTail]
  | cons stmt tail ih =>
      simp [C99Frontend.lowerBody,withTail,ih]
      cases C99Frontend.lowerBody rest <;> rfl

theorem prefix_inv (rc : C99ScalarReference.CallRelation) (env : C99ScalarReference.Env)
    (stmts : List CLogic.Stmt) (tail : C99ScalarReference.Stmt) (result : C99ScalarReference.Result)
    (hn : ∀ e, CLogic.Stmt.ret e∉stmts)
    (hs : C99ScalarReference.Exec rc env (withTail stmts tail) result) :
    ∃ middle, C99ScalarReference.Exec rc env (C99Frontend.scalars stmts) (.normal middle) ∧
      C99ScalarReference.Exec rc middle tail result := by
  induction stmts generalizing env with
  | nil => exact ⟨env,C99ScalarReference.Exec.skip env,hs⟩
  | cons stmt rest ih =>
      rcases C99ControlInversion.seq_inv _ _ _ _ _ hs with ⟨mid,hfirst,hrest⟩ | ⟨v,hreturn,_⟩
      · have hnRest : ∀ e, CLogic.Stmt.ret e∉rest := fun e he => hn e (List.mem_cons_of_mem stmt he)
        obtain ⟨out,hprefix,htail⟩ := ih mid hnRest hrest
        exact ⟨out,C99ScalarReference.Exec.seqNormal env mid _ _ _ hfirst hprefix,htail⟩
      · have hnOne : ∀ e, CLogic.Stmt.ret e∉[stmt] := by
          intro e he
          have heq : CLogic.Stmt.ret e=stmt := by simpa using he
          exact hn e (by simp [heq])
        have hbad : C99ScalarReference.Exec rc env (C99Frontend.scalars [stmt]) (.returned v) :=
          C99ScalarReference.Exec.seqReturn env _ _ v hreturn
        exact False.elim (C99NormalBodyBridge.normal_no_return [stmt] hnOne rc env v hbad)

end FT1536.Source3.C99PrefixBridge

#print axioms FT1536.Source3.C99PrefixBridge.prefix_inv
