import Source3.SelectedStepFull194
import Source3.SelectedStepOutNtt194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The outer u++/final-guard tail of the make_fg_step first-prime loop at the
   selected seed9 state. The sealed SelectedStepFull194.source closes the
   first-prime body s0-s8 (the composed fullPrefix run and the false !out_ntt
   branch s8 as its skip); this module assembles the complete one-iteration
   loop execution: the body scope over the s0-s8 run, the u increment to
   u = 1, the false u < slen guard exit and the part-2 statement execution
   (`u = 0; for (u = 0; u < slen; u ++) { body }`) to the loop exit state,
   the transport to the second prime. Export at the exit state: the executed
   u/n/hn/slen/tlen/logn/ter/in_ntt/out_ntt cells, the caller frames outside
   u/v/p/p0i/R2 and x, the gs transformed words and the gd written image
   (the body scope restore and the u increment are heap-free). Values stay
   executed words: no transform property, table law, root law or positivity
   claim. The fs/fd image transport from the assembled s0-s3 state to the
   exit state is the recorded next obligation (keep-arity gap of the s4/s6
   loops). -/
namespace FT1536.Source3.SelectedStepLoopTail194
open C99ArrayReference (State Name restoreScope)
open C99MemoryReference (Load32)
open KeygenMakeFgSource (Exec skip)
open C99LoopScalar141 (Cell)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open StepCopyBody190 (elem)
open StepProductFixed191 (Image)
open SelectedStepLayout187 (gs gd)
open NttInverseWholeBridges192 (scaledWord)
open MakeFgSequence187 (Run)

noncomputable abbrev base : State := SelectedGen0Call189.after

noncomputable def bodyOut (final : State) : State :=
  restoreScope SelectedStepPrime188.initial final
    StepPrimeShape188.localNames StepPrimeShape188.pointerNames

noncomputable def exit (final : State) : State :=
  FftLocalCells140.put (bodyOut final) "u".toList (C99NatWord141.word 1)

abbrev LocalsFrame (final : State) : Prop :=
  ∀ name : Name, name≠"v".toList → final.locals name=SelectedStepProduct191.base.locals name

/- Generic destructuring of a normal-flow sequence execution. -/
theorem seq_inv {a b : KeygenMakeFgSource.Stmt} {before out : State}
    (source : Exec (.seq a b) before ⟨out,.normal⟩) :
    ∃ middle, Exec a before ⟨middle,.normal⟩ ∧ Exec b middle ⟨out,.normal⟩ := by
  cases source with
  | seqNormal _ _ _ middle _ first second => exact ⟨middle,first,second⟩
  | seqExit _ _ _ _ _ stopped => exact (stopped (by rfl)).elim

/- The sealed right-leaning projection tree of the first-prime body tail
   equals the flat statement list used by the Run chain. -/
theorem tail_expand : StepPrimeShape188.tail =
    MakeFgSequence187.append
      [MakeFgTailShape190.s0, MakeFgTailShape190.s1, MakeFgTailShape190.s2, MakeFgTailShape190.s3,
       MakeFgTailShape190.s4, MakeFgTailShape190.s5, MakeFgTailShape190.s6, MakeFgTailShape190.s7,
       MakeFgTailShape190.s8] skip := by
  show MakeFgTailShape190.r0 = _
  rw [MakeFgTailShape190.r0_split, MakeFgTailShape190.r1_split, MakeFgTailShape190.r2_split,
    MakeFgTailShape190.r3_split, MakeFgTailShape190.r4_split, MakeFgTailShape190.r5_split,
    MakeFgTailShape190.r6_split, MakeFgTailShape190.r7_split, MakeFgTailShape190.r8_split,
    MakeFgTailShape190.r9_skip]
  rfl

/- The s0-s8 tail execution from the sealed fullPrefix run and the s8 skip. -/
theorem tail_run (final : State) (full : Exec SelectedStepGsChain194.fullPrefix base ⟨final,.normal⟩)
    (s8Run : Exec MakeFgTailShape190.s8 final ⟨final,.normal⟩) :
    Exec StepPrimeShape188.tail base ⟨final,.normal⟩ := by
  obtain ⟨a1,head1,rest1⟩ := seq_inv full
  obtain ⟨a2,s0Run,head2⟩ := seq_inv head1
  obtain ⟨a3,s1Run,head3⟩ := seq_inv head2
  obtain ⟨a4,s2Run,s3Run⟩ := seq_inv head3
  obtain ⟨a5,s4Run,rest2⟩ := seq_inv rest1
  obtain ⟨a6,s5Run,rest3⟩ := seq_inv rest2
  obtain ⟨a7,s6Run,s7Run⟩ := seq_inv rest3
  have skipRun : Exec skip final ⟨final,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip final)))
  have run : Run
      [MakeFgTailShape190.s0, MakeFgTailShape190.s1, MakeFgTailShape190.s2, MakeFgTailShape190.s3,
       MakeFgTailShape190.s4, MakeFgTailShape190.s5, MakeFgTailShape190.s6, MakeFgTailShape190.s7,
       MakeFgTailShape190.s8] base final :=
    .cons _ _ base a2 final s0Run
      (.cons _ _ a2 a3 final s1Run
        (.cons _ _ a3 a4 final s2Run
          (.cons _ _ a4 a1 final s3Run
            (.cons _ _ a1 a5 final s4Run
              (.cons _ _ a5 a6 final s5Run
                (.cons _ _ a6 a7 final s6Run
                  (.cons _ _ a7 final final s7Run
                    (.cons _ _ final final final s8Run (.nil final)))))))))
  rw [tail_expand]
  exact MakeFgSequence187.source
    [MakeFgTailShape190.s0, MakeFgTailShape190.s1, MakeFgTailShape190.s2, MakeFgTailShape190.s3,
     MakeFgTailShape190.s4, MakeFgTailShape190.s5, MakeFgTailShape190.s6, MakeFgTailShape190.s7,
     MakeFgTailShape190.s8] base final run skip ⟨final,.normal⟩ skipRun

theorem locals_out (final : State) (name : Name) (outside : name ∉ StepPrimeShape188.localNames) :
    (bodyOut final).locals name = final.locals name := by
  show (C99ScalarReference.restore SelectedStepPrime188.initial.locals final.locals
      StepPrimeShape188.localNames) name = final.locals name
  simp [C99ScalarReference.restore, outside]

theorem restore_outside (name : Name) :
    name≠"p".toList → name≠"p0i".toList → name≠"R2".toList → name≠"v".toList →
      name ∉ StepPrimeShape188.localNames := by
  intro differentP differentI differentR differentV members
  simp only [StepPrimeShape188.localNames, List.map_cons, List.map_nil, List.mem_cons] at members
  rcases members with same | same | same | same | same
  · exact differentP same
  · exact differentI same
  · exact differentR same
  · exact differentV same
  · exact List.not_mem_nil same

theorem arrays_out (final : State) (name : Name) (different : name≠"x".toList) :
    (bodyOut final).arrays name = final.arrays name := by
  show (fun n => if StepPrimeShape188.pointerNames.contains n
      then SelectedStepPrime188.initial.arrays n else final.arrays n) name = final.arrays name
  simp only []
  have absent : name ∉ StepPrimeShape188.pointerNames := by
    intro members
    simp only [StepPrimeShape188.pointerNames, List.mem_singleton] at members
    exact different members
  simp [absent]

theorem arrays_x (final : State) :
    (bodyOut final).arrays "x".toList = SelectedStepPrime188.initial.arrays "x".toList := by
  show (fun n => if StepPrimeShape188.pointerNames.contains n
      then SelectedStepPrime188.initial.arrays n else final.arrays n) "x".toList = _
  simp [StepPrimeShape188.pointerNames]

theorem body_heap (final : State) : (bodyOut final).heap = final.heap := rfl
theorem exit_heap (final : State) : (exit final).heap = final.heap := rfl

theorem u_mid (final : State) (frame : LocalsFrame final) : Cell (bodyOut final) "u".toList 0 :=
  ((locals_out final "u".toList (restore_outside "u".toList (by decide) (by decide) (by decide)
      (by decide))).trans (frame "u".toList (by decide))).trans
    (by exact SelectedGen0Ready189.u_cell)

theorem cell_at_exit (final : State) (frame : LocalsFrame final) (name : Name) (n : Nat)
    (value : SelectedStepProduct191.base.locals name=some (.uint64,some (.uint64 (C99NatWord141.word n))))
    (differentU : name≠"u".toList) (differentP : name≠"p".toList)
    (differentI : name≠"p0i".toList) (differentR : name≠"R2".toList)
    (differentV : name≠"v".toList) : Cell (exit final) name n :=
  ((FftLocalCells140.outside (bodyOut final) "u".toList name (C99NatWord141.word 1) differentU).trans
    ((locals_out final name (restore_outside name differentP differentI differentR differentV)).trans
      ((frame name differentV).trans value)))

theorem inc_run (final : State) (frame : LocalsFrame final) :
    Exec StepPrimeShape188.increment (bodyOut final) ⟨exit final,.normal⟩ := by
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "u".toList .add (MakeFgTailShape190.num 1))) (bodyOut final)
      (FftLocalCells140.put (bodyOut final) "u".toList (C99NatWord141.word 1)) := by
    cases C99LoopScalar141.increment (fun _ => none) (bodyOut final) "u".toList 0 (by omega)
        (u_mid final frame) with
    | base _ _ _ source => exact source
  have first : C99ModularReference.Exec
      (.base (.scalar (.update "u".toList .add (MakeFgTailShape190.num 1)))) (bodyOut final)
      ⟨FftLocalCells140.put (bodyOut final) "u".toList (C99NatWord141.word 1),.normal⟩ :=
    .base _ _ _ update
  exact .level _ _ _ (.modular _ _ _ first)

theorem exit_u (final : State) : Cell (exit final) "u".toList 1 :=
  FftLocalCells140.cell_at (bodyOut final) "u".toList (C99NatWord141.word 1)

theorem exit_guard (final : State) (frame : LocalsFrame final) :
    C99ArrayReference.scalar (exit final) StepPrimeShape188.condition (.int32 0) := by
  show C99ArrayReference.scalar (exit final)
    (.cmp .lt (CLogic.Expr.var "u".toList) (CLogic.Expr.var "slen".toList)) (.int32 0)
  simpa [C99ScalarReference.boolean] using
    C99LoopScalar141.less (exit final) (CLogic.Expr.var "u".toList) (CLogic.Expr.var "slen".toList)
      1 1 (by omega) (by omega)
      (C99LoopScalar141.read (exit final) "u".toList 1 (exit_u final))
      (C99LoopScalar141.read (exit final) "slen".toList 1
        (cell_at_exit final frame "slen".toList 1 (by exact SelectedGen0Ready189.slen_cell)
          (by decide) (by decide) (by decide) (by decide) (by decide)))

theorem skip_run (s : State) : Exec skip s ⟨s,.normal⟩ :=
  .level _ _ _ (.modular _ _ _ (.base _ _ _ (.skip s)))

theorem loop_run (final : State) (frame : LocalsFrame final)
    (bodyRun : Exec StepPrimeShape188.body SelectedStepPrime188.initial ⟨bodyOut final,.normal⟩) :
    Exec StepPrimeShape188.loop SelectedStepPrime188.initial ⟨exit final,.normal⟩ :=
  .loopNormal _ _ _ SelectedStepPrime188.initial (bodyOut final) (exit final) ⟨exit final,.normal⟩
    (.int32 1) SelectedStepPrime188.guard (by decide) bodyRun (inc_run final frame)
    (.loopFalse _ _ _ (exit final) (.int32 0) (exit_guard final frame) (by decide))

theorem source : ∃ (final next : State),
    Exec SelectedStepGsChain194.fullPrefix base ⟨final,.normal⟩ ∧
    Exec StepPrimeShape188.loop SelectedStepPrime188.initial ⟨next,.normal⟩ ∧
    Exec (KeygenMakeFgSource.part .step 2) SelectedStepMove187.after ⟨next,.normal⟩ ∧
    Cell next "u".toList 1 ∧
    Cell next "n".toList 512 ∧
    Cell next "hn".toList 256 ∧
    Cell next "slen".toList 1 ∧
    Cell next "tlen".toList 2 ∧
    Slot next "logn" 9 ∧
    Slot next "ter" 1 ∧
    next.locals "in_ntt".toList=some (.int32,some (.int32 1)) ∧
    next.locals "out_ntt".toList=some (.int32,some (.int32 1)) ∧
    (∀ name : Name, name≠"u".toList → name≠"v".toList → name≠"p".toList →
      name≠"p0i".toList → name≠"R2".toList → next.locals name=SelectedStepProduct191.base.locals name) ∧
    (∀ name : Name, name≠"x".toList → next.arrays name=SelectedStepProduct191.base.arrays name) ∧
    next.arrays "x".toList=SelectedStepPrime188.initial.arrays "x".toList ∧
    (∀ i : Fin 512, Load32 next.heap (elem gs i.val)
      (scaledWord SelectedStepChainKeep194.gvs SelectedStepChain193.tws
        SelectedTopInit178.p SelectedTopInit178.p0i i.val)) ∧
    Image next gd 0 2 256 SelectedTopInit178.p SelectedTopInit178.p0i
      SelectedTopInit178.r2 SelectedStepChainKeep194.gvs 256 := by
  obtain ⟨_,final,_,wholeRun,finalImage,gdImage,_,_,finalLocals,finalArrays⟩ :=
    SelectedStepFull194.source
  have outNttCell : final.locals "out_ntt".toList=some (.int32,some (.int32 1)) :=
    (finalLocals "out_ntt".toList (by decide)).trans
      (by exact SelectedGen0Ready189.out_ntt_cell)
  have tailRun : Exec StepPrimeShape188.tail base ⟨final,.normal⟩ :=
    tail_run final wholeRun (SelectedStepOutNtt194.source final outNttCell)
  have bodyRun : Exec StepPrimeShape188.body SelectedStepPrime188.initial ⟨bodyOut final,.normal⟩ := by
    rw [StepPrimeShape188.body_shape]
    exact .scope _ _ _ SelectedStepPrime188.initial ⟨final,.normal⟩
      (SelectedGen0Call189.continue_inner ⟨final,.normal⟩ tailRun)
  refine ⟨final,exit final,wholeRun,loop_run final finalLocals bodyRun,?_,?_,?_,?_,?_,?_,?_,?_,
    ?_,?_,?_,?_,?_,?_,?_⟩
  · rw [StepPrimeShape188.loop_shape]
    exact .seqNormal _ _ SelectedStepMove187.after (exit final) ⟨exit final,.normal⟩
      (.seqNormal _ _ SelectedStepMove187.after SelectedStepPrime188.initial ⟨exit final,.normal⟩
        SelectedStepPrime188.initial_source (loop_run final finalLocals bodyRun))
      (skip_run _)
  · exact exit_u final
  · exact cell_at_exit final finalLocals "n".toList 512
      (by exact SelectedGen0Ready189.n_cell) (by decide) (by decide) (by decide) (by decide) (by decide)
  · exact cell_at_exit final finalLocals "hn".toList 256
      (by exact SelectedGen0Ready189.hn_cell) (by decide) (by decide) (by decide) (by decide) (by decide)
  · exact cell_at_exit final finalLocals "slen".toList 1
      (by exact SelectedGen0Ready189.slen_cell) (by decide) (by decide) (by decide) (by decide) (by decide)
  · exact cell_at_exit final finalLocals "tlen".toList 2
      (by exact SelectedGen0Ready189.tlen_cell) (by decide) (by decide) (by decide) (by decide) (by decide)
  · refine (FftLocalCells140.outside (bodyOut final) "u".toList "logn".toList
      (C99NatWord141.word 1) (by decide)).trans
      ((locals_out final "logn".toList (restore_outside "logn".toList (by decide) (by decide)
        (by decide) (by decide))).trans ((finalLocals "logn".toList (by decide)).trans ?_))
    exact (by exact SelectedGen0Ready189.logn_cell)
  · refine (FftLocalCells140.outside (bodyOut final) "u".toList "ter".toList
      (C99NatWord141.word 1) (by decide)).trans
      ((locals_out final "ter".toList (restore_outside "ter".toList (by decide) (by decide)
        (by decide) (by decide))).trans ((finalLocals "ter".toList (by decide)).trans ?_))
    exact (by exact SelectedGen0Ready189.ternary_cell)
  · refine (FftLocalCells140.outside (bodyOut final) "u".toList "in_ntt".toList
      (C99NatWord141.word 1) (by decide)).trans
      ((locals_out final "in_ntt".toList (restore_outside "in_ntt".toList (by decide) (by decide)
        (by decide) (by decide))).trans ((finalLocals "in_ntt".toList (by decide)).trans ?_))
    exact (by exact SelectedGen0Ready189.in_ntt_cell)
  · exact outNttCell
  · intro name differentU differentV differentP differentI differentR
    exact (FftLocalCells140.outside (bodyOut final) "u".toList name (C99NatWord141.word 1)
      differentU).trans ((locals_out final name
        (restore_outside name differentP differentI differentR differentV)).trans
        (finalLocals name differentV))
  · intro name different
    exact (rfl : (exit final).arrays name=(bodyOut final).arrays name).trans
      ((arrays_out final name different).trans (finalArrays name different))
  · show (exit final).arrays "x".toList=SelectedStepPrime188.initial.arrays "x".toList
    exact (rfl : (exit final).arrays "x".toList=(bodyOut final).arrays "x".toList).trans
      (arrays_x final)
  · intro i
    rw [exit_heap]
    exact finalImage i
  · intro i bound
    rw [exit_heap]
    exact gdImage i bound

end FT1536.Source3.SelectedStepLoopTail194
