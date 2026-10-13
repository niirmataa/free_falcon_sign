import ArenaProgram020E1
import ProgramRefinement020D

set_option maxRecDepth 8192
namespace FT1536.S05.ArenaExecution020E1
open WordRAM020 SyntaxTape020E JointInterface019 FT1536.Relation

/-- This boundary decodes the parsed node bank back to Code and invokes the
    existing logical stack evaluator. It is not yet direct node execution. -/
def dispatch (i : Input) (s : State) : Piece → Option State
  | .expr _ => none
  | .code c => ControlStack020E.execute i (ControlStack020E.work c) [c] s

def execute (i : Input) (s : State) : Option State :=
  (ArenaProgram020E1.actual.bind ArenaDecode020E1.root).bind (dispatch i s)

theorem correct (i : Input) (s : State) :
    execute i s=some (run i PairProgram020.program s).1 := by
  rw [execute,ArenaProgram020E1.actual_roundtrip,Option.bind_some]
  exact ControlStack020E.singleton i PairProgram020.program s

/-- Parsing/reconstruction preserves the existing every-tape theorem; no new
    sampler law, mass condition, nonce or quantum-history premise is introduced. -/
theorem public_initial (h : Rq) (tape : Bits tapeSize) :
    ∃ s : State,execute (InputLayout020.encode h tape) initial=some s ∧ s.fault=false ∧
      List.ofFn s.out=PairEncoding020.encode ((StandaloneRuntime019.publicCode h).code tape) :=
  ⟨(run (InputLayout020.encode h tape) PairProgram020.program initial).1,
    correct _ _,ProgramRefinement020D.every_tape h tape⟩

end FT1536.S05.ArenaExecution020E1
