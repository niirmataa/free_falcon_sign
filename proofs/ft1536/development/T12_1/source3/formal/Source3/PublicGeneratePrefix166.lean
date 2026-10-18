import Source3.PublicU32Locals165
import Source3.PublicGenerateRemaining159

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Construct the missing row prologue; the existing159 store loops are
   consumed unchanged after these actual scalar assignments. -/
namespace FT1536.Source3.PublicGeneratePrefix166
open C99ArrayReference (State bindValue)
open KeygenPublicExec (Exec chain)
open KeygenPublicTableAtoms (var)
open PublicU32Locals165 (Env Ready)
open KeygenPublicTableRows (bDeclared rowSteps)

def targets : List String := ["x","ix","g2","g4","ig2","ig4"]
def inputs : List String := ["g","ig"]
def outputs : List String := ["ig4","ig2","g4","g2","ix","x","g","ig"]

theorem copy (s : State) (declared initialized : List String) (env : Env s declared)
    (ready : Ready s initialized) (dst src : String) (target : dst∈declared) (input : src∈initialized) :
    ∃ after, Exec KeygenPublicSource.program [] (.assign dst.toList (var src)) s ⟨after,.normal⟩ ∧
      Env after declared ∧ Ready after (dst::initialized) ∧ after.heap=s.heap := by
  obtain ⟨w,slot⟩ := ready src input
  obtain ⟨old,cell⟩ := env dst target
  have run : Exec KeygenPublicSource.program [] (.assign dst.toList (var src)) s
      ⟨bindValue s dst.toList .uint32 (.uint32 w),.normal⟩ :=
    .assign _ _ _ .uint32 old (.uint32 w) cell (PublicGenerateHead159.eval_var s src w slot)
  exact ⟨_,run,PublicU32Locals165.env_after s dst _ declared env,
    PublicU32Locals165.ready_after s dst _ initialized ready
      ⟨w,PublicGenerateRow159.u32_slot_after s dst w⟩,rfl⟩

theorem env_b (s : State) (env : Env s targets) : Env (bDeclared s) targets := by
  have distinct : ∀ n ∈ targets, n.toList∉["b".toList] := by decide
  intro n member
  obtain ⟨old,slot⟩ := env n member
  exact ⟨old,(KeygenPublicTableControl.declare_frame .uint64 ["b".toList] s.locals n.toList
    (distinct n member)).trans slot⟩

theorem ready_b (s : State) (ready : Ready s inputs) : Ready (bDeclared s) inputs := by
  have distinct : ∀ n ∈ inputs, n.toList∉["b".toList] := by decide
  intro n member
  obtain ⟨w,slot⟩ := ready n member
  exact ⟨w,(KeygenPublicTableControl.declare_frame .uint64 ["b".toList] s.locals n.toList
    (distinct n member)).trans slot⟩

theorem source (s : State) (env : Env s targets) (ready : Ready s inputs) :
    ∃ after, Exec KeygenPublicSource.program [] (chain rowSteps) s ⟨after,.normal⟩ ∧
      Env after targets ∧ Ready after outputs ∧
      after.locals "b".toList=some (.uint64,none) ∧ after.heap=s.heap := by
  have declRun : Exec KeygenPublicSource.program [] (.scalar (.declare .u64 ["b".toList])) s
      ⟨bDeclared s,.normal⟩ :=
    .scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint64 ["b".toList] s.locals)
  obtain ⟨s1,r1,e1,v1,h1⟩ := copy (bDeclared s) targets inputs (env_b s env) (ready_b s ready)
    "x" "g" (by decide) (by decide)
  obtain ⟨s2,r2,e2,v2,h2⟩ := copy s1 targets _ e1 v1 "ix" "ig" (by decide) (by decide)
  obtain ⟨s3,r3,e3,v3,h3⟩ := PublicU32Locals165.mont s2 targets _ e2 v2
    "g2" "g" "g" (by decide) (by decide) (by decide)
  obtain ⟨s4,r4,e4,v4,h4⟩ := PublicU32Locals165.mont s3 targets _ e3 v3
    "g4" "g2" "g2" (by decide) (by decide) (by decide)
  obtain ⟨s5,r5,e5,v5,h5⟩ := PublicU32Locals165.mont s4 targets _ e4 v4
    "ig2" "ig" "ig" (by decide) (by decide) (by decide)
  obtain ⟨s6,r6,e6,v6,h6⟩ := PublicU32Locals165.mont s5 targets _ e5 v5
    "ig4" "ig2" "ig2" (by decide) (by decide) (by decide)
  have pureRun : Exec KeygenPublicSource.program [] (chain rowSteps.tail) (bDeclared s) ⟨s6,.normal⟩ :=
    PublicGenerateRow159.chain_step _ _ (bDeclared s) s1 ⟨s6,.normal⟩ r1
      (PublicGenerateRow159.chain_step _ _ s1 s2 ⟨s6,.normal⟩ r2
        (PublicGenerateRow159.chain_step _ _ s2 s3 ⟨s6,.normal⟩ r3
          (PublicGenerateRow159.chain_step _ _ s3 s4 ⟨s6,.normal⟩ r4
            (PublicGenerateRow159.chain_step _ _ s4 s5 ⟨s6,.normal⟩ r5
              (PublicGenerateRow159.chain_step _ _ s5 s6 ⟨s6,.normal⟩ r6 (.skip s6))))))
  have frame := KeygenPublicTableControl.frame _ _ _ _ _ (by decide) pureRun
  exact ⟨s6,PublicGenerateRow159.chain_step _ _ s (bDeclared s) ⟨s6,.normal⟩ declRun pureRun,
    e6,v6,(frame.2.2 _ (by decide)).trans (by rfl),
    h6.trans (h5.trans (h4.trans (h3.trans (h2.trans h1))))⟩

end FT1536.Source3.PublicGeneratePrefix166
