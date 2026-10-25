import Source3.StepNttMloop195

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The u/r1/r2 keeps at the POST-DOUBLING state of the pinned
   modp_NTT3_ext forward body at the selected call words (logn = 9 /
   full = 0, n = 512, hn = 256, stride = 1), carried to the tailT output
   (the body exit) through the TAKEN-SIDE FRAME of the skipped triple
   pass. TRAP 6 (do not re-derive): KeygenNttControl.localsWritten is a
   static over-approximation — the un-taken triple branch still
   contributes u/r1 to the written set, so the freshness-based keep_u64
   cannot certify u or r1 across tailT. The tailT run is instead
   DECOMPOSED at the triplePass statement (tail_split) and only the
   write frame of the TAKEN side is used: StepNttMloop195.triple_skip
   runs the branchFalse `.base .skip` side, which writes nothing, so the
   tailT output state equals the post-doubling (m walk exit) state in
   full (triple_frame). No freshness is taken across the triple pass.
   What the keeps establish: the u cell at the body exit is 256 (the
   first-pass exit cell survives the doubling rounds — they do not write
   u — and the skipped triple pass), and the r1/r2 bindings of the body
   exit are exactly the POST-DOUBLING bindings (the doubling rounds
   REBIND r1/r2 at every block through v1Bind/htBind/pointerAdvance, so
   no first-pass r1/r2 value survives the rounds; the concrete exit
   bindings belong to the doubling-word image work, OPEN here). This
   module consumes the corrected job-571 states (bodyAt/stepAt) and the
   pinned job-570/572 layers only as pinned inputs; the job-570
   bodyHeap mis-composition (retained finding) is documented in the
   layer-195 supplement (owner decision A, 2026-10-25) and is never
   rebuilt here. Values stay executed words: no transform property,
   table law, root law or positivity claim is made here. -/
namespace FT1536.Source3.StepNttKeep195
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenNttLoopSupport (USlot PSlot u64)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)

/-! ## Guard inversion for variable conditions -/

theorem var_slot {s : State} {v : Value} {name : Name}
    (guard : C99ArrayReference.scalar s (.var name) v) :
    ∃ ty, s.locals name=some (ty,some v) := by
  change C99ScalarReference.Eval FprPrefixCalls.calls s.locals
    (C99ScalarReference.Expr.variable name) v at guard
  cases guard with
  | «variable» _ ty _ bound => exact ⟨ty,bound⟩

/-! ## The taken-side frame of the skipped triple pass (trap 6 bypass) -/

theorem triple_frame {s out : State} (full : Slot s "full" 0)
    (run : Exec KeygenNttForwardPrograms.triplePass s ⟨out,.normal⟩) : out=s := by
  cases run
  case seqNormal middle head tail =>
      have skip : (⟨out,.normal⟩ : Result)=⟨middle,.normal⟩ :=
        C99ModularReference.skip_result middle ⟨out,.normal⟩ tail
      have outEq : out=middle := congrArg Result.state skip
      cases head
      case branchFalse v z grd body =>
          have same : (⟨middle,.normal⟩ : Result)=⟨s,.normal⟩ :=
            C99ModularReference.skip_result s ⟨middle,.normal⟩ body
          exact outEq.trans (congrArg Result.state same)
      case branchTrue v nz grd body =>
          obtain ⟨ty,binding⟩ := var_slot grd
          have pair := Option.some.inj (binding.symm.trans full)
          have value : v=.uint32 0 := Option.some.inj (Prod.mk.inj pair).2
          subst value
          exact (nz (by decide)).elim
  case seqExit exit head =>
      exact (exit rfl).elim

/-! ## The tailT run decomposed at the triplePass statement -/

theorem tail_split {s out : State} (run : Exec StepNttBody195.tailT s ⟨out,.normal⟩) :
    ∃ s1 s2, Exec KeygenNttForwardPrograms.tFromHalf s ⟨s1,.normal⟩ ∧
      Exec StepNttBody195.mHead s1 ⟨s2,.normal⟩ ∧
      Exec KeygenNttForwardPrograms.triplePass s2 ⟨out,.normal⟩ := by
  change Exec (.seq KeygenNttForwardPrograms.tFromHalf StepNttBody195.tailMiddle)
    s ⟨out,.normal⟩ at run
  obtain ⟨s1,head,middleRun⟩ := KeygenNttControl.seq_inv KeygenNttForwardPrograms.tFromHalf
    StepNttBody195.tailMiddle s ⟨out,.normal⟩ (by decide) run
  change Exec (.seq StepNttBody195.mHead KeygenNttForwardPrograms.triplePass)
    s1 ⟨out,.normal⟩ at middleRun
  obtain ⟨s2,head2,tail2⟩ := KeygenNttControl.seq_inv StepNttBody195.mHead
    KeygenNttForwardPrograms.triplePass s1 ⟨out,.normal⟩ (by decide) middleRun
  exact ⟨s1,s2,head,head2,tail2⟩

/-! ## The keeps u/r1/r2 at the post-doubling state -/

theorem tail_keeps {s out : State} (run : Exec StepNttBody195.tailT s ⟨out,.normal⟩)
    (full : Slot s "full" 0) (uc : Cell s "u".toList 256) :
    ∃ s1 s2, Exec KeygenNttForwardPrograms.tFromHalf s ⟨s1,.normal⟩ ∧
      Exec StepNttBody195.mHead s1 ⟨s2,.normal⟩ ∧
      Cell s2 "u".toList 256 ∧ Cell out "u".toList 256 ∧
      out.locals=s2.locals ∧ out.arrays=s2.arrays ∧ out.heap=s2.heap := by
  obtain ⟨s1,s2,head,middleRun,tripleRun⟩ := tail_split run
  have full1 : Slot s1 "full" 0 :=
    KeygenNttControl.keep_u32 head (by decide) "full" 0 (by decide) full
  have full2 : Slot s2 "full" 0 :=
    KeygenNttControl.keep_u32 middleRun (by decide) "full" 0 (by decide) full1
  have same : out=s2 := triple_frame full2 tripleRun
  have u1 : Cell s1 "u".toList 256 :=
    KeygenNttControl.keep_u64 head (by decide) "u" 256 (by decide) uc
  have u2 : Cell s2 "u".toList 256 :=
    KeygenNttControl.keep_u64 middleRun (by decide) "u" 256 (by decide) u1
  refine ⟨s1,s2,head,middleRun,u2,?_,?_,?_,?_⟩
  · rw [same]
    exact u2
  · rw [same]
  · rw [same]
  · rw [same]

theorem tail_keep_u {s out : State} (run : Exec StepNttBody195.tailT s ⟨out,.normal⟩)
    (full : Slot s "full" 0) (uc : Cell s "u".toList 256) : Cell out "u".toList 256 := by
  obtain ⟨s1,s2,_,_,_,uo,_,_,_⟩ := tail_keeps run full uc
  exact uo

/-- r1 keep: the body-exit binding is the post-doubling binding (the
    skipped triple pass moves nothing; the doubling rounds rebind r1 at
    every block, so the concrete value is the doubling-image work). -/
theorem tail_keep_r1 {s2 out : State} (eq : out.arrays=s2.arrays) {p : ArrayPointer}
    (slot : PSlot s2 "r1" p) : PSlot out "r1" p := by
  show out.arrays "r1".toList=some p
  rw [eq]
  exact slot

/-- r2 keep: the body-exit binding is the post-doubling binding. -/
theorem tail_keep_r2 {s2 out : State} (eq : out.arrays=s2.arrays) {p : ArrayPointer}
    (slot : PSlot s2 "r2" p) : PSlot out "r2" p := by
  show out.arrays "r2".toList=some p
  rw [eq]
  exact slot

/-- Heap keep: the body-exit words are the post-doubling words (the
    doubling-pass image carries to the body exit verbatim). -/
theorem tail_keep_words {s2 out : State} (eq : out.heap=s2.heap) :
    out.heap=s2.heap := eq

end FT1536.Source3.StepNttKeep195
