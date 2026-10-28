import Source3.BezoutParserPrefix217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- A parsed for(;;) statement is a source loop, for any remaining tokens. -/
namespace FT1536.Source3.BezoutParserLoop217
open KeygenZintCall (Stmt)
open KeygenWordExpr (Types)
open B20.C (Token)

theorem infinite_loop (types : Types) (ptrs : List C99ArrayReference.Name) (fuel : Nat) (tail : List Token)
    (stmt : Stmt) (next : List C99ArrayReference.Name) (rest : List Token)
    (parsed : KeygenZintCall.parseStatement types ptrs (fuel+1)
      (["for".toList,"(".toList,";".toList,";".toList,")".toList]++tail)=some (stmt,next,rest)) :
    ∃ inner, stmt=.loop (.scalar (.literal .i32 1)) inner KeygenZintCall.skip := by
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
    exact ⟨inner,(congrArg Prod.fst eq).symm⟩

end FT1536.Source3.BezoutParserLoop217
