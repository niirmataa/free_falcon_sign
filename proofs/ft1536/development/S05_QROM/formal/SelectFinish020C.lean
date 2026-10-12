import NormCap020C
import CubeBinding020C

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.SelectFinish020C
open WordRAM020 PairProgram020 ReadSemantics020A CdfPrefix020A
open BoxImage020C NormResponse020C
attribute [local irreducible] exec loopState StandaloneRuntime019.first

def fallbackCode : Code := .branch (FlagCore020C.guard 20) PairProgram020.cube skip

theorem exec_single (i : Input) (c : Code) (s : State) : exec i (seqs [c]) s=exec i c s := by
  simp only [exec_seqs_cons,exec_seqs_nil]

theorem select_shape (i : Input) (s : State) :
    exec i PairProgram020.select s=exec i fallbackCode (exec i (NormCap020C.capped 196) s) :=
  (CdfStep020A.seqs_append i
    [set 0 (lit 0),set 20 (lit 0),.loop 196 (FlagCore020C.guard 20) PairProgram020.normTrial]
    [fallbackCode] s).trans (exec_single i fallbackCode _)

theorem some_payload (s : State) (v : Packed) (hs : answer s=some v) :
    s.reg 20≠0 ∧ readVec s=v := by
  have hn : s.reg 20≠0 := by
    intro hz
    have he := (FlagCore020C.observe_none 20 readVec s).mpr hz
    change answer s=none at he
    rw [hs] at he
    exact Option.some_ne_none v he
  refine ⟨hn,?_⟩
  change (if s.reg 20=0 then none else some (readVec s))=some v at hs
  rw [ite_eq_right hn] at hs
  exact Option.some.inj hs

theorem branch_correct (i : Input) (q : State) (o : Option StandaloneRuntime019.CachedBox)
    (c : StandaloneRuntime019.CachedBox) (ho : answer q=o.map image)
    (hc : readVec (exec i PairProgram020.cube q)=image c)
    (hframe : Preserves q (exec i PairProgram020.cube q)) :
    readVec (exec i fallbackCode q)=image (o.getD c) ∧ Preserves q (exec i fallbackCode q) := by
  unfold fallbackCode
  rw [exec_branch]
  cases o with
  | none =>
    have hz : q.reg 20=0 := (FlagCore020C.observe_none 20 readVec q).mp ho
    rw [ite_eq_right (FlagCore020C.guard_on 20 q hz)]
    exact ⟨hc,hframe⟩
  | some z =>
    have hs := some_payload q (image z) ho
    rw [ite_eq_left (FlagCore020C.guard_off 20 q hs.1),exec_skip]
    exact ⟨hs.2,preserves_refl q⟩

theorem select_from_cap (i : Input) (s q : State) (o : Option StandaloneRuntime019.CachedBox)
    (c : StandaloneRuntime019.CachedBox) (hq : exec i (NormCap020C.capped 196) s=q)
    (ho : answer q=o.map image) (fr : Preserves s q)
    (hc : readVec (exec i PairProgram020.cube q)=image c)
    (hframe : Preserves q (exec i PairProgram020.cube q)) :
    readVec (exec i PairProgram020.select s)=image (o.getD c) ∧
      Preserves s (exec i PairProgram020.select s) := by
  have post := branch_correct i q o c ho hc hframe
  rw [select_shape,hq]
  exact ⟨post.1,preserves_trans fr post.2⟩

theorem selected_getD (t : StandaloneRuntime019.Tables) (c : StandaloneRuntime019.Seed) :
    StandaloneRuntime019.selected t c=
      (StandaloneRuntime019.first (StandaloneRuntime019.normTrial t) 196 c.1).getD
        (StandaloneRuntime019.cube c.2) := by
  unfold StandaloneRuntime019.selected
  cases StandaloneRuntime019.first (StandaloneRuntime019.normTrial t) 196 c.1 <;> rfl

end FT1536.S05.SelectFinish020C
