import Source3.StepU1Run195
import Source3.StepGeneratorBridge188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The ter generator branch of the make_fg_step additional-prime loop
   body at the u = 1 cell: the modp_mkgm3 wrapper call
   (MakeFgAddPrimeShape194.generateCall, the pinned seven-argument list
   generateArgs) executed through KeygenLevelCalls.Call .generate at the
   StepU1Run195 u = 1 body run, and the gBranch statement at ter = 1
   (the modp_mkgm2 binary alternative is not taken; its guard is the
   same decide-bound shape). The export is branch_source over the caller
   state s with the continuation of the loop body. The callee changes
   only the heap: every caller local/array cell (p/p0i/R2/Rx/u/v/x/
   slen/tlen/n/logn/ter/out_ntt, primes/fs/gs/t1/fd/gd/gm/igm) keeps
   through the call (afterGenerate). Values stay executed words; no
   table law, root law or positivity claim is made here. -/
namespace FT1536.Source3.SelectedStepGenerate195
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeFgSource (Exec)
open KeygenModpR2Exec (Slot)
open StepU1Entry195 (p1 p0i1 r21 g1)

/- The generator result state at caller state s (heap image only). -/
noncomputable def afterGenerate (s : State) (input0 : StepU1Entry195.Input s) : State :=
  {s with heap:=(StepU1Run195.topAfter s input0).heap}

theorem locals_keep (s : State) (input0 : StepU1Entry195.Input s) :
    (afterGenerate s input0).locals=s.locals := rfl
theorem arrays_keep (s : State) (input0 : StepU1Entry195.Input s) :
    (afterGenerate s input0).arrays=s.arrays := rfl

/- The wrapper call and the make-level instruction. -/
theorem call_run (s : State) (input0 : StepU1Entry195.Input s) :
    KeygenLevelCalls.Call .generate s MakeFgAddPrimeShape194.generateArgs
      (afterGenerate s input0) :=
  StepU1Entry195.source_call s input0 ⟨StepU1Run195.topAfter s input0,.normal⟩
    (StepU1Run195.body_source s input0) .voidEnd

theorem instruction (s : State) (input0 : StepU1Entry195.Input s) :
    Exec MakeFgAddPrimeShape194.generateCall s ⟨afterGenerate s input0,.normal⟩ :=
  .level _ _ _ (.call .generate MakeFgAddPrimeShape194.generateArgs s (afterGenerate s input0)
    (call_run s input0))

theorem scoped_run (s : State) (input0 : StepU1Entry195.Input s) :
    Exec (.scope [] [] (.seq MakeFgAddPrimeShape194.generateCall KeygenMakeFgSource.skip)) s
      ⟨afterGenerate s input0,.normal⟩ :=
  MakeFgScope187.source _ s (afterGenerate s input0)
    (.seqNormal _ _ s (afterGenerate s input0) _ (instruction s input0)
      (MakeFgDeclarations176.array_source .skip (afterGenerate s input0) (afterGenerate s input0)
        (.skip (afterGenerate s input0))))

/- The gBranch statement at ter = 1. -/
theorem branch_source (s : State) (input0 : StepU1Entry195.Input s) :
    Exec MakeFgAddPrimeShape194.gBranch s ⟨afterGenerate s input0,.normal⟩ := by
  rw [MakeFgAddPrimeShape194.generateBranch_guard,MakeFgAddPrimeShape194.genYes_shape,
    MakeFgAddPrimeShape194.genNo_shape]
  exact .branchTrue _ _ _ s ⟨afterGenerate s input0,.normal⟩ (.uint32 1)
    (.variable _ _ _ input0.terCell) (by decide) (scoped_run s input0)

/- The continuation of the loop body after the ter branch. -/
theorem continue_inner (s : State) (input0 : StepU1Entry195.Input s) (out : Result)
    (rest : Exec MakeFgAddPrimeShape194.r1 (afterGenerate s input0) out) :
    Exec MakeFgAddPrimeShape194.remaining s out := by
  rw [MakeFgAddPrimeShape194.r0_split]
  exact .seqNormal _ _ s (afterGenerate s input0) out (branch_source s input0) rest

/- Result-state cells of the caller words (the call writes no locals). -/
theorem p_cell (s : State) (input0 : StepU1Entry195.Input s) :
    Slot (afterGenerate s input0) "p" p1 := input0.pCell
theorem i_cell (s : State) (input0 : StepU1Entry195.Input s) :
    Slot (afterGenerate s input0) "p0i" p0i1 := input0.iCell
theorem u_cell (s : State) (input0 : StepU1Entry195.Input s) :
    (afterGenerate s input0).locals "u".toList=some (.uint64,some (.uint64 (C99NatWord141.word 1))) :=
  input0.uCell

end FT1536.Source3.SelectedStepGenerate195
