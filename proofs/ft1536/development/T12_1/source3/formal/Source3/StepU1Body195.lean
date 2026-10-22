import Source3.StepU1Entry195
import Source3.StepGeneratorReady188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The modp_mkgm3 scalar prelude of the u = 1 generator call: the
   declaration effect and the rAssign/r2Assign/gConvert/kFromLogn0/
   ifNotFull/whileK/igAssign chain of KeygenMkgm3Program executed at the
   StepU1Entry195 callee entry, at the u = 1 words p1/p0i1/r21/g1. This
   is the StepGeneratorScalar188/Cube188/Square188/InverseCall188/
   Prefix188/Ready188 chain re-instantiated at the u = 1 words; the
   proofs follow those modules statement by statement, and every
   intermediate state is a plain top-level def (defeq discipline).
   Values stay executed words: no table law or root law is claimed. -/
namespace FT1536.Source3.StepU1Body195
open C99ArrayReference (State)
open C99ModularReference (Exec ModCall chainOf)
open C99MemoryReference (Allocated)
open KeygenMkgm3Program
open ModularAtoms178 (set cell assign mont)
open KeygenModpR2Exec (Slot)
open SelectedStepLayout187 (gm igm)
open KeygenFullData127 (rev)
open StepU1Entry195 (p1 p0i1 r21 g1 r1)

/- The u = 1 run words. -/
def rU : BitVec 32 := r1
def g0U : BitVec 32 := KeygenModpWord.montgomery g1 r21 p1 p0i1
def gSqU : BitVec 32 := KeygenModpWord.montgomery g0U g0U p1 p0i1
def gCubeU : BitVec 32 := KeygenModpWord.montgomery g0U gSqU p1 p0i1
def gRun : BitVec 32 := KeygenModpWord.montgomery gCubeU gCubeU p1 p0i1
def igU : BitVec 32 := ModpDivTotal178.word r21 gRun p1 p0i1 rU

/- The prelude state spine at caller state s. -/
noncomputable def before (s : State) : State := GeneratorDeclarations178.after (StepU1Entry195.entry s)
noncomputable def withR (s : State) : State := set (before s) "R" rU
noncomputable def withR2 (s : State) : State := set (withR s) "R2" r21
noncomputable def converted (s : State) : State := set (withR2 s) "g" g0U
noncomputable def afterScalar (s : State) : State := set (converted s) "k" 9
noncomputable def cubed (s : State) : State := set (afterScalar s) "g" gCubeU
noncomputable def afterCube (s : State) : State := set (cubed s) "k" 10
noncomputable def advanced (s : State) : State := set (afterCube s) "k" 11
noncomputable def squared (s : State) : State := set (advanced s) "g" gRun
noncomputable def afterSquare (s : State) : State := set (squared s) "k" 12
noncomputable def after (s : State) : State := set (afterSquare s) "ig" igU

def steps := declarations++[rAssign,r2Assign,gConvert,kFromLogn0,ifNotFull,whileK,igAssign]
def remaining := [rowSelect,kFromLogn,ifFull,squareLoop]++topElements
def scalarSteps := [rAssign,r2Assign,gConvert,kFromLogn0,ifNotFull,whileK,igAssign]

/- The four scalar statements. -/
theorem r_source (s : State) : Exec rAssign (before s) ⟨withR s,.normal⟩ :=
  assign (before s) "R" none _ rU rfl
    (.call1 _ _ _ _ (cell (before s) "p" p1 rfl) (.r _ _ (KeygenModpR.source_exists p1)))

theorem r2_source (s : State) : Exec r2Assign (withR s) ⟨withR2 s,.normal⟩ :=
  assign (withR s) "R2" none _ r21 rfl
    (.call2 _ _ _ _ _ _ (cell (withR s) "p" p1 rfl) (cell (withR s) "p0i" p0i1 rfl)
      (.r2 _ _ (KeygenModpR2Exec.source_exists (withR s) p1 p0i1)))

theorem convert_source (s : State) : Exec gConvert (withR2 s) ⟨converted s,.normal⟩ :=
  assign (withR2 s) "g" (some (.uint32 g1)) _ g0U rfl
    (mont (withR2 s) _ _ g1 r21 p1 p0i1 (cell (withR2 s) "g" g1 rfl) (cell (withR2 s) "R2" r21 rfl) rfl rfl)

theorem k_source (s : State) : Exec kFromLogn0 (converted s) ⟨afterScalar s,.normal⟩ :=
  assign (converted s) "k" none _ 9 rfl (cell (converted s) "logn" 9 rfl)

theorem scalar_run (s : State) :
    ModularSequence178.Run ModCall [rAssign,r2Assign,gConvert,kFromLogn0] (before s) (afterScalar s) :=
  .cons _ _ _ _ _ (r_source s) (.cons _ _ _ _ _ (r2_source s)
    (.cons _ _ _ _ _ (convert_source s) (.cons _ _ _ _ _ (k_source s) (.nil (afterScalar s)))))

/- ifNotFull at full = 0: the g cube and the k increment. -/
theorem cube_source (s : State) : Exec (.assign "g".toList tripleGG) (afterScalar s) ⟨cubed s,.normal⟩ :=
  assign (afterScalar s) "g" (some (.uint32 g0U)) _ gCubeU rfl
    (mont (afterScalar s) _ _ g0U gSqU p1 p0i1 (cell (afterScalar s) "g" g0U rfl)
      (mont (afterScalar s) _ _ g0U g0U p1 p0i1 (cell (afterScalar s) "g" g0U rfl)
        (cell (afterScalar s) "g" g0U rfl) rfl rfl) rfl rfl)

theorem increment9 (s : State) : Exec (inc "k") (cubed s) ⟨afterCube s,.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint32 (some (.uint32 9)) (.uint32 10) rfl
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 1)
      (.step .plus (.uint32 9) (.int32 1) .uint32 rfl (.uint32 9) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible)))))

theorem cube_scoped (s : State) :
    Exec (.scope [] (chainOf [.assign "g".toList tripleGG,inc "k"])) (afterScalar s) ⟨afterCube s,.normal⟩ := by
  have inner : Exec (chainOf [.assign "g".toList tripleGG,inc "k"]) (afterScalar s) ⟨afterCube s,.normal⟩ :=
    .seqNormal _ _ (afterScalar s) (cubed s) _ (cube_source s)
      (.seqNormal _ _ (cubed s) (afterCube s) _ (increment9 s) (.base .skip _ _ (.skip _)))
  have run := C99ModularReference.GenExec.scope [] _ (afterScalar s) ⟨afterCube s,.normal⟩ inner
  simpa only [KeygenPublicForwardCall.restore_empty] using run

theorem not_full_source (s : State) : Exec ifNotFull (afterScalar s) ⟨afterCube s,.normal⟩ :=
  .branchTrue _ _ _ (afterScalar s) ⟨afterCube s,.normal⟩ (.int32 1)
    (.logicalNot _ (.uint32 0) (.variable _ _ _ rfl)) (by decide) (cube_scoped s)

/- whileK at logn = 9: one loop round and the trailing increment. -/
theorem increment10 (s : State) : Exec (inc "k") (afterCube s) ⟨advanced s,.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint32 (some (.uint32 10)) (.uint32 11) rfl
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 1)
      (.step .plus (.uint32 10) (.int32 1) .uint32 rfl (.uint32 10) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible)))))

theorem square_source (s : State) : Exec (.assign "g".toList montGG) (advanced s) ⟨squared s,.normal⟩ :=
  assign (advanced s) "g" (some (.uint32 gCubeU)) _ gRun rfl
    (mont (advanced s) _ _ gCubeU gCubeU p1 p0i1 (cell (advanced s) "g" gCubeU rfl)
      (cell (advanced s) "g" gCubeU rfl) rfl rfl)

theorem square_scoped (s : State) :
    Exec (.scope [] (chainOf [.assign "g".toList montGG])) (advanced s) ⟨squared s,.normal⟩ := by
  have inner : Exec (chainOf [.assign "g".toList montGG]) (advanced s) ⟨squared s,.normal⟩ :=
    .seqNormal _ _ (advanced s) (squared s) ⟨squared s,.normal⟩ (square_source s)
      (.base .skip (squared s) (squared s) (.skip (squared s)))
  have run := C99ModularReference.GenExec.scope [] _ (advanced s) ⟨squared s,.normal⟩ inner
  simpa only [KeygenPublicForwardCall.restore_empty] using run

theorem increment11 (s : State) : Exec (inc "k") (squared s) ⟨afterSquare s,.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint32 (some (.uint32 11)) (.uint32 12) rfl
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 1)
      (.step .plus (.uint32 11) (.int32 1) .uint32 rfl (.uint32 11) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible)))))

theorem loop_source (s : State) : Exec whileK (afterCube s) ⟨afterSquare s,.normal⟩ :=
  .seqNormal _ _ (afterCube s) (squared s) ⟨afterSquare s,.normal⟩
    (.loopNormal _ _ _ (afterCube s) (squared s) (squared s) ⟨squared s,.normal⟩ (.int32 1)
      (.compare .lt _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 11)
        (.step .lt (.uint32 10) (.int32 11) .uint32 rfl (.uint32 10) (.uint32 11) rfl rfl))
      (by decide)
      (.seqNormal _ _ (afterCube s) (advanced s) ⟨squared s,.normal⟩ (increment10 s) (square_scoped s))
      (.base .skip (squared s) (squared s) (.skip (squared s)))
      (.loopFalse _ _ _ (squared s) (.int32 0)
        (.compare .lt _ _ _ _ _ (.variable _ _ _ rfl) (.literal .int32 11)
          (.step .lt (.uint32 11) (.int32 11) .uint32 rfl (.uint32 11) (.uint32 11) rfl rfl)) rfl))
    (increment11 s)

/- igAssign at the u = 1 words. -/
theorem ig_source (s : State) : Exec igAssign (afterSquare s) ⟨after s,.normal⟩ :=
  assign (afterSquare s) "ig" none _ igU rfl
    (.call5 _ _ _ _ _ _ _ _ _ _ _ _ (cell (afterSquare s) "R2" r21 rfl) (cell (afterSquare s) "g" gRun rfl)
      (cell (afterSquare s) "p" p1 rfl) (cell (afterSquare s) "p0i" p0i1 rfl)
      (.call1 _ _ _ _ (cell (afterSquare s) "p" p1 rfl) (.r _ _ (KeygenModpR.source_exists p1)))
      (.div _ _ (ModpDivTotal178.source_exists (afterSquare s) r21 gRun p1 p0i1 rU)))

theorem scalar_source (s : State) : Exec (chainOf scalarSteps) (before s) ⟨after s,.normal⟩ :=
  ModularSequence178.source ModCall [rAssign,r2Assign,gConvert,kFromLogn0]
    (before s) (afterScalar s) (scalar_run s)
    [ifNotFull,whileK,igAssign] ⟨after s,.normal⟩
    (.seqNormal _ _ (afterScalar s) (afterCube s) _ (not_full_source s)
      (.seqNormal _ _ (afterCube s) (afterSquare s) _ (loop_source s)
        (.seqNormal _ _ (afterSquare s) (after s) _ (ig_source s)
          (.base .skip _ _ (.skip _)))))

theorem append_source (s : State) (tail : List C99ModularReference.Stmt) (out : C99ProcedureReference.Result)
    (rest : Exec (chainOf tail) (after s) out) : Exec (chainOf (steps++tail)) (StepU1Entry195.entry s) out :=
  ModularSequence178.source ModCall declarations (StepU1Entry195.entry s) (before s)
    (GeneratorDeclarations178.source (StepU1Entry195.entry s))
    ([rAssign,r2Assign,gConvert,kFromLogn0,ifNotFull,whileK,igAssign]++tail) out
    (ModularSequence178.source ModCall [rAssign,r2Assign,gConvert,kFromLogn0]
      (before s) (afterScalar s) (scalar_run s)
      ([ifNotFull,whileK,igAssign]++tail) out
      (.seqNormal _ _ (afterScalar s) (afterCube s) out (not_full_source s)
        (.seqNormal _ _ (afterCube s) (afterSquare s) out (loop_source s)
          (.seqNormal _ _ (afterSquare s) (after s) out (ig_source s) rest))))

theorem source (s : State) : Exec (chainOf steps) (StepU1Entry195.entry s) ⟨after s,.normal⟩ := by
  have run := append_source s [] ⟨after s,.normal⟩ (.base .skip (after s) (after s) (.skip (after s)))
  simpa only [List.append_nil] using run

theorem continue_generator (s : State) (out : C99ProcedureReference.Result)
    (rest : Exec (chainOf remaining) (after s) out) :
    Exec KeygenMkgm3Program.code (StepU1Entry195.entry s) out := append_source s remaining out rest

/- Pre-heap fact: the prelude chain writes no heap. -/
theorem entry_heap (s : State) : (after s).heap=s.heap :=
  (KeygenMkgm3Atoms.pure_heap _ _ _ (by decide) (source s)).trans (StepU1Entry195.entry_heap s)

/- Cell facts of the prelude end state (StepGeneratorReady188 mirror). -/
theorem k12 (s : State) : (afterSquare s).locals "k".toList=some (.uint32,some (.uint32 12)) := rfl

theorem k_cell (s : State) : Slot (after s) "k" 12 :=
  (ModularAtoms178.outside (afterSquare s) "ig" "k" igU (by decide)).trans (k12 s)

theorem g_cell (s : State) : Slot (after s) "g" gRun :=
  (ModularAtoms178.outside (afterSquare s) "ig" "g" igU (by decide)).trans rfl

theorem ig_cell (s : State) : Slot (after s) "ig" igU := ModularAtoms178.slot (afterSquare s) "ig" igU

theorem scalar_r (s : State) : Slot (afterScalar s) "R" rU :=
  (ModularAtoms178.outside (converted s) "k" "R" 9 (by decide)).trans
    ((ModularAtoms178.outside (withR2 s) "g" "R" g0U (by decide)).trans
      ((ModularAtoms178.outside (withR s) "R2" "R" r21 (by decide)).trans
        (ModularAtoms178.slot (before s) "R" rU)))

theorem scalar_r2 (s : State) : Slot (afterScalar s) "R2" r21 :=
  (ModularAtoms178.outside (converted s) "k" "R2" 9 (by decide)).trans
    ((ModularAtoms178.outside (withR2 s) "g" "R2" g0U (by decide)).trans
      (ModularAtoms178.slot (withR s) "R2" r21))

theorem r_cell (s : State) : Slot (after s) "R" rU :=
  KeygenNttControl.keep_u32 (ig_source s) (by decide) "R" rU (by decide)
    (KeygenNttControl.keep_u32 (loop_source s) (by decide) "R" rU (by decide)
      (KeygenNttControl.keep_u32 (not_full_source s) (by decide) "R" rU (by decide) (scalar_r s)))

theorem r2_cell (s : State) : Slot (after s) "R2" r21 :=
  KeygenNttControl.keep_u32 (ig_source s) (by decide) "R2" r21 (by decide)
    (KeygenNttControl.keep_u32 (loop_source s) (by decide) "R2" r21 (by decide)
      (KeygenNttControl.keep_u32 (not_full_source s) (by decide) "R2" r21 (by decide) (scalar_r2 s)))

theorem u_declared (s : State) : (after s).locals "u".toList=some (.uint64,none) :=
  ((KeygenNttControl.frame _ _ _ (by decide) (scalar_source s)).2.1 "u".toList (by decide)).trans rfl

theorem w_declared (s : State) : (after s).locals "w".toList=some (.uint32,none) :=
  ((KeygenNttControl.frame _ _ _ (by decide) (scalar_source s)).2.1 "w".toList (by decide)).trans rfl

theorem p_cell (s : State) : Slot (after s) "p" p1 :=
  KeygenNttControl.keep_u32 (source s) (by decide) "p" p1 (by decide) rfl

theorem i_cell (s : State) : Slot (after s) "p0i" p0i1 :=
  KeygenNttControl.keep_u32 (source s) (by decide) "p0i" p0i1 (by decide) rfl

theorem logn_cell (s : State) : Slot (after s) "logn" 9 :=
  KeygenNttControl.keep_u32 (source s) (by decide) "logn" 9 (by decide) rfl

theorem full_cell (s : State) : Slot (after s) "full" 0 :=
  KeygenNttControl.keep_u32 (source s) (by decide) "full" 0 (by decide) rfl

theorem gm_binding (s : State) : (after s).arrays "gm".toList=some gm :=
  KeygenNttControl.keep_pointer (source s) (by decide) "gm" gm (by decide) rfl

theorem igm_binding (s : State) : (after s).arrays "igm".toList=some igm :=
  KeygenNttControl.keep_pointer (source s) (by decide) "igm" igm (by decide) rfl

theorem rev_binding (s : State) (input : StepU1Entry195.Input s) :
    (after s).arrays "REV10".toList=some rev :=
  KeygenNttControl.keep_pointer (source s) (by decide) "REV10" rev (by decide)
    (StepU1Entry195.rev_binding s input)

theorem rev_source (s : State) (input : StepU1Entry195.Input s) :
    KeygenMkgm3RevMemory.SourceTable (after s).heap rev := by
  rw [entry_heap]
  exact input.revSource

theorem allocated (s : State) (input : StepU1Entry195.Input s) (index : Nat) (inside : index<71680) :
    Allocated (after s).heap {KeygenFullData127.env.ctx.scratch with index:=index} := by
  rw [entry_heap]
  exact input.scratch index inside

theorem writable (s : State) (input : StepU1Entry195.Input s) : (after s).heap.writable 31=true := by
  rw [entry_heap]
  exact input.writable

end FT1536.Source3.StepU1Body195
