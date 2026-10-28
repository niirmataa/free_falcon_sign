import Source3.BezoutLexerPart7Tokens217

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Invert a successful body parse beginning with the for token. -/
namespace FT1536.Source3.BezoutParserBodyHead217
open KeygenZintCall (Stmt)
open KeygenWordExpr (Types)
open B20.C (Token)

theorem head (types : Types) (ptrs : List C99ArrayReference.Name) (fuel : Nat) (tail : List Token)
    (code : Stmt) (outPtrs : List C99ArrayReference.Name) (rest : List Token)
    (parsed : KeygenZintCall.parseBody types ptrs (fuel+1) ("for".toList::tail)=some (code,outPtrs,rest)) :
    ∃ first next mid after, KeygenZintCall.parseStatement types ptrs fuel ("for".toList::tail)=some (first,next,mid) ∧
      KeygenZintCall.parseBody types next fuel mid=some (after,outPtrs,rest) ∧ code=.seq first after := by
  change (do
    let (first,next,mid) ← KeygenZintCall.parseStatement types ptrs fuel ("for".toList::tail)
    let (after,outPtrs,rest) ← KeygenZintCall.parseBody types next fuel mid
    pure (Stmt.seq first after,outPtrs,rest))=some (code,outPtrs,rest) at parsed
  cases hs : KeygenZintCall.parseStatement types ptrs fuel ("for".toList::tail) with
  | none =>
    change KeygenZintCall.parseStatement types ptrs fuel (['f','o','r']::tail)=none at hs
    simp [hs] at parsed
  | some a =>
    rcases a with ⟨first,next,mid⟩
    rw [hs] at parsed
    change (do let (after,ps,r) ← KeygenZintCall.parseBody types next fuel mid
               pure (Stmt.seq first after,ps,r))=some (code,outPtrs,rest) at parsed
    cases hb : KeygenZintCall.parseBody types next fuel mid with
    | none => simp [hb] at parsed
    | some b =>
      rcases b with ⟨after,ps,r⟩
      rw [hb] at parsed
      change some (Stmt.seq first after,ps,r)=some (code,outPtrs,rest) at parsed
      have eq := Option.some.inj parsed
      have ec : code=.seq first after := (congrArg Prod.fst eq).symm
      have es : (ps,r)=(outPtrs,rest) := congrArg Prod.snd eq
      cases es
      exact ⟨first,next,mid,after,rfl,hb,ec⟩

end FT1536.Source3.BezoutParserBodyHead217
