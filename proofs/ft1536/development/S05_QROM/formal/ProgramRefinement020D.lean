import ActualEmit020D
import SelectionBoundary020C
import RefinementTarget020

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProgramRefinement020D
open WordRAM020 PairProgram020 ReadSemantics020A JointInterface019 ActualScatter020D
open FT1536.Relation
attribute [local irreducible] exec loopState List.ofFn

theorem after_select (h : Rq) (tape : Bits tapeSize) (s : State) (z : StandaloneRuntime019.CachedBox)
    (hz : BoxImage020C.readVec s=BoxImage020C.image z) :
    let i := InputLayout020.encode h tape
    let t := exec i emitPair (exec i multiply s)
    List.ofFn t.out=PairEncoding020.encode (ActualEmit020D.referencePair h z) ∧ t.fault=s.fault := by
  have mul := MultiplyLoop020D.multiply_correct h tape z s hz
  have em := ActualEmit020D.emit_correct (InputLayout020.encode h tape) _ h z
    ((frame_image mul.2).trans hz) mul.1
  exact ⟨em.1,em.2.trans mul.2.2.1⟩

theorem three_stages (i : Input) (a b c : Code) (s : State) :
    exec i (seqs [a,b,c]) s=exec i c (exec i b (exec i a s)) := by
  simp only [exec_seqs_cons,exec_seqs_nil]

theorem program_shape (i : Input) (s : State) :
    exec i program s=exec i emitPair (exec i multiply (exec i select s)) :=
  three_stages i select multiply emitPair s

/-- Every h, every full tape and every state. The original020 program has
    exactly the019 bit output and preserves the incoming fault flag. -/
theorem program_correct (h : Rq) (tape : Bits tapeSize) (s : State) :
    let t := exec (InputLayout020.encode h tape) program s
    List.ofFn t.out=PairEncoding020.encode ((StandaloneRuntime019.publicCode h).code tape) ∧
      t.fault=s.fault := by
  have sel := ActualSelect020C.select_correct h tape s
  have post := after_select h tape _ _ sel.1
  dsimp only
  rw [program_shape]
  exact ⟨post.1,post.2.trans (ActualSelect020C.no_new_fault h tape s)⟩

theorem from_initial (i : Input) (c : Code) (bits : List Bool)
    (hc : List.ofFn (exec i c initial).out=bits ∧ (exec i c initial).fault=initial.fault) :
    (run i c initial).1.fault=false ∧ List.ofFn (run i c initial).1.out=bits := by
  unfold exec at hc
  exact ⟨hc.2.trans WordRAM020.initial_no_fault,hc.1⟩

/-- Fills the proposition left OPEN in020, without new premises or axioms. -/
theorem every_tape : RefinementTarget020.EveryTape :=
  fun h tape => from_initial (InputLayout020.encode h tape) program _ (program_correct h tape initial)

/-- The result and cost refer to the same original program and public initial.
    This is a bound in the020 word-RAM model, not a complete implementation cost. -/
theorem public_initial_with_cost (h : Rq) (tape : Bits tapeSize) :
    let r := run (InputLayout020.encode h tape) program initial
    r.1.fault=false ∧ List.ofFn r.1.out=PairEncoding020.encode ((StandaloneRuntime019.publicCode h).code tape) ∧
      r.2≤bound program :=
  ⟨(every_tape h tape).1,(every_tape h tape).2,run_bound _ _ _⟩

end FT1536.S05.ProgramRefinement020D
