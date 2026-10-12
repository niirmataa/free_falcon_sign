import SelectFinish020C

namespace FT1536.S05.ActualSelect020C
open WordRAM020 ReadSemantics020A JointInterface019
open BoxImage020C NormResponse020C SelectFinish020C
open FT1536.Relation
attribute [local irreducible] exec loopState StandaloneRuntime019.first StandaloneRuntime019.selected

/-- The WHOLE original020 select, on every public h, full tape and state:
    cap80 within1536 pairs, strict norm, cap196 and the actual fresh cube.
    No probabilistic/M, source-step or correct-layout premise is required. -/
theorem select_correct (h : Rq) (tape : Bits tapeSize) (s : State) :
    let i := InputLayout020.encode h tape
    readVec (exec i PairProgram020.select s)=
      image (StandaloneRuntime019.selected StandaloneRuntime019.tables (StandaloneRuntime019.seedEquiv tape)) ∧
    Preserves s (exec i PairProgram020.select s) := by
  let i := InputLayout020.encode h tape
  let q := exec i (NormCap020C.capped 196) s
  let o := StandaloneRuntime019.first (StandaloneRuntime019.normTrial StandaloneRuntime019.tables)
    196 (StandaloneRuntime019.seedEquiv tape).1
  let c := StandaloneRuntime019.cube (StandaloneRuntime019.seedEquiv tape).2
  have cap := NormCap020C.cap196_correct h tape s
  have post := select_from_cap i s q o c rfl cap.1 cap.2
    (CubeBinding020C.cube_image h tape q) (CubeLoop020C.cube_correct i q).2
  exact ⟨post.1.trans (congrArg image (selected_getD StandaloneRuntime019.tables
    (StandaloneRuntime019.seedEquiv tape))).symm,post.2⟩

theorem no_new_fault (h : Rq) (tape : Bits tapeSize) (s : State) :
    (exec (InputLayout020.encode h tape) PairProgram020.select s).fault=s.fault :=
  (select_correct h tape s).2.2.1

theorem initial_no_fault (h : Rq) (tape : Bits tapeSize) :
    (exec (InputLayout020.encode h tape) PairProgram020.select initial).fault=false :=
  (no_new_fault h tape initial).trans WordRAM020.initial_no_fault

end FT1536.S05.ActualSelect020C
