import Source3.BezoutParserActualLoop217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Invert loop and block productions while retaining recursive parse evidence. -/
namespace FT1536.Source3.BezoutParserLoopScope217
open KeygenZintCall (Stmt)
open KeygenWordExpr (Types)
open B20.C (Token)

theorem loop_body (types : Types) (ptrs : List C99ArrayReference.Name) (fuel : Nat) (tail : List Token)
    (stmt : Stmt) (next : List C99ArrayReference.Name) (rest : List Token)
    (parsed : KeygenZintCall.parseStatement types ptrs (fuel+1)
      (["for".toList,"(".toList,";".toList,";".toList,")".toList]++tail)=some (stmt,next,rest)) :
    ∃ inner, KeygenZintCall.parseStatement types ptrs fuel tail=some (inner,next,rest) ∧
      stmt=.loop (.scalar (.literal .i32 1)) inner KeygenZintCall.skip := by
  change (do
    let (inner,ps,remaining) ← KeygenZintCall.parseStatement types ptrs fuel tail
    pure (Stmt.loop (.scalar (.literal .i32 1)) inner KeygenZintCall.skip,ps,remaining))=some (stmt,next,rest) at parsed
  cases h : KeygenZintCall.parseStatement types ptrs fuel tail with
  | none => simp [h] at parsed
  | some result =>
    rcases result with ⟨inner,ps,remaining⟩
    rw [h] at parsed
    change some (Stmt.loop (.scalar (.literal .i32 1)) inner KeygenZintCall.skip,ps,remaining)=some (stmt,next,rest) at parsed
    have eq := Option.some.inj parsed
    have ec := (congrArg Prod.fst eq).symm
    have es : (ps,remaining)=(next,rest) := congrArg Prod.snd eq
    cases es
    exact ⟨inner,rfl,ec⟩

theorem scope_body (types : Types) (ptrs : List C99ArrayReference.Name) (fuel : Nat) (tail : List Token)
    (stmt : Stmt) (next : List C99ArrayReference.Name) (rest : List Token)
    (parsed : KeygenZintCall.parseStatement types ptrs (fuel+1) ("{".toList::tail)=some (stmt,next,rest)) :
    ∃ inner innerPtrs, KeygenZintCall.parseBody types ptrs fuel tail=some (inner,innerPtrs,rest) ∧
      stmt=.scope (KeygenZintCall.declarations inner).1 (KeygenZintCall.declarations inner).2 inner ∧ next=ptrs := by
  change (do
    let (inner,_,remaining) ← KeygenZintCall.parseBody types ptrs fuel tail
    let vars := KeygenZintCall.declarations inner
    pure (Stmt.scope vars.1 vars.2 inner,ptrs,remaining))=some (stmt,next,rest) at parsed
  cases h : KeygenZintCall.parseBody types ptrs fuel tail with
  | none => simp [h] at parsed
  | some result =>
    rcases result with ⟨inner,innerPtrs,remaining⟩
    rw [h] at parsed
    change some (Stmt.scope (KeygenZintCall.declarations inner).1 (KeygenZintCall.declarations inner).2 inner,ptrs,remaining)=some (stmt,next,rest) at parsed
    have eq := Option.some.inj parsed
    have ec := (congrArg Prod.fst eq).symm
    have es : (ptrs,remaining)=(next,rest) := congrArg Prod.snd eq
    have ep : next=ptrs := (congrArg Prod.fst es).symm
    have er : remaining=rest := congrArg Prod.snd es
    subst remaining
    exact ⟨inner,innerPtrs,rfl,ec,ep⟩

end FT1536.Source3.BezoutParserLoopScope217
