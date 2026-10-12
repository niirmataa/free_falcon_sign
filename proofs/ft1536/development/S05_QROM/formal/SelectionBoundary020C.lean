import ActualSelect020C

namespace FT1536.S05.SelectionBoundary020C
open WordRAM020 JointInterface019 BoxImage020C
open FT1536.Relation

/-- Every cube bit lies strictly after every norm-trial bit, including bits
    reserved for all rejected pair/norm attempts. -/
theorem fresh_cube_after_norm (n : Fin 196) (p : Fin 1536) (k : Fin 80)
    (j : Fin 1024) (c : Fin 1536) (b : Fin 20) :
    TrialAddress020A.base n.val p.val k.val+j.val < CubeRead020C.base c.val+b.val := by
  have hn := (TrialAddress020A.window n.val p.val k.val n.isLt p.isLt k.isLt).1
  unfold CubeRead020C.base
  omega

/-- Exact result and operational bound refer to the SAME original select
    program. Cost is in the declared020 word-RAM model, not a CPU bound. -/
theorem refinement_with_cost (h : Rq) (tape : Bits tapeSize) (s : State) :
    let r := run (InputLayout020.encode h tape) PairProgram020.select s
    readVec r.1=image (StandaloneRuntime019.selected StandaloneRuntime019.tables
      (StandaloneRuntime019.seedEquiv tape)) ∧ r.1.fault=s.fault ∧
      r.2≤bound PairProgram020.select :=
  ⟨(ActualSelect020C.select_correct h tape s).1,ActualSelect020C.no_new_fault h tape s,
    run_bound _ _ _⟩

theorem public_initial (h : Rq) (tape : Bits tapeSize) :
    let r := run (InputLayout020.encode h tape) PairProgram020.select initial
    readVec r.1=image (StandaloneRuntime019.selected StandaloneRuntime019.tables
      (StandaloneRuntime019.seedEquiv tape)) ∧ r.1.fault=false ∧
      r.2≤bound PairProgram020.select :=
  ⟨(ActualSelect020C.select_correct h tape initial).1,ActualSelect020C.initial_no_fault h tape,
    run_bound _ _ _⟩

end FT1536.S05.SelectionBoundary020C
