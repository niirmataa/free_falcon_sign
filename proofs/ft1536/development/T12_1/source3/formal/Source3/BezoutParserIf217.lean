import Source3.BezoutParserLoop217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- A successful source-guard if parse constructs a branch with that guard. -/
namespace FT1536.Source3.BezoutParserIf217
open KeygenZintCall (Stmt)
open KeygenWordExpr (Types)
open B20.C (Token)

theorem branch (types : Types) (ptrs : List C99ArrayReference.Name) (fuel : Nat) (tail : List Token)
    (stmt : Stmt) (next : List C99ArrayReference.Name) (rest : List Token)
    (parsed : KeygenZintCall.parseStatement types ptrs (fuel+1)
      (["if".toList,"(".toList]++BezoutParserPrefix217.guardTokens++tail)=some (stmt,next,rest)) :
    ∃ yes no, stmt=.branch BezoutLoopGuard217.condition yes no := by
  change (do
    let (condition,afterCondition) ← KeygenWordExpr.expression (KeygenZintCall.env types ptrs) (BezoutParserPrefix217.guardTokens++tail)
    match afterCondition with
    | [')']::afterClose => do
      let (yes,ps,afterYes) ← KeygenZintCall.parseStatement types ptrs fuel afterClose
      match afterYes with
      | ['e','l','s','e']::afterElse => do
        let (no,ps,afterNo) ← KeygenZintCall.parseStatement types ps fuel afterElse
        pure (Stmt.branch condition yes no,ps,afterNo)
      | _ => pure (Stmt.branch condition yes KeygenZintCall.skip,ps,afterYes)
    | _ => none)=some (stmt,next,rest) at parsed
  rw [BezoutParserPrefix217.guard_prefix] at parsed
  change (do
    let (yes,ps,afterYes) ← KeygenZintCall.parseStatement types ptrs fuel tail
    match afterYes with
    | ['e','l','s','e']::afterElse => do
      let (no,ps,afterNo) ← KeygenZintCall.parseStatement types ps fuel afterElse
      pure (Stmt.branch BezoutLoopGuard217.condition yes no,ps,afterNo)
    | _ => pure (Stmt.branch BezoutLoopGuard217.condition yes KeygenZintCall.skip,ps,afterYes))=some (stmt,next,rest) at parsed
  cases h : KeygenZintCall.parseStatement types ptrs fuel tail with
  | none => simp [h] at parsed
  | some result =>
    rcases result with ⟨yes,ps,afterYes⟩
    rw [h] at parsed
    dsimp at parsed
    split at parsed
    next afterElse =>
      cases he : KeygenZintCall.parseStatement types ps fuel afterElse with
      | none => simp [he] at parsed
      | some result =>
        rcases result with ⟨no,ps2,afterNo⟩
        rw [he] at parsed
        change some (Stmt.branch BezoutLoopGuard217.condition yes no,ps2,afterNo)=some (stmt,next,rest) at parsed
        exact ⟨yes,no,(congrArg Prod.fst (Option.some.inj parsed)).symm⟩
    next =>
      exact ⟨yes,KeygenZintCall.skip,(congrArg Prod.fst (Option.some.inj parsed)).symm⟩

end FT1536.Source3.BezoutParserIf217
