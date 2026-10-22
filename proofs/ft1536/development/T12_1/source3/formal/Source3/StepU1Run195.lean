import Source3.StepU1Body195
import Source3.Gen0RowPrelude189
import Source3.Gen0RowPreludeFacts189
import Source3.Gen0RowLoop189
import Source3.Gen0RowFixed189
import Source3.GeneratorSquareLoop181
import Source3.GeneratorTopSource181
import Source3.Gen0RawInitialized189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The modp_mkgm3 row/square/top suffix of the u = 1 generator call: the
   rowSelect prelude and 512-row loop, the kFromLogn/ifFull control pair,
   the squareLoop and the three top elements, executed at the
   StepU1Body195 prelude end state at the u = 1 words. This is the
   SelectedGen0Prelude189/RowFixed189/RowLoop189/Row189/Control189/
   Square189/Top189 chain re-instantiated at the u = 1 words; the loop
   engines (Gen0RowLoop189.full, GeneratorSquareLoop181.full,
   GeneratorTopSource181.source) are generic in the words and are
   consumed directly. The export is the full body execution
   body_source : Exec KeygenMkgm3Program.code entry ⟨topAfter,.normal⟩.
   The chosen engine-result states are parameterized by the caller-state
   input proof; every consumer threads the same input0 term (defeq
   discipline). Values stay executed words; no table law or root law is
   claimed. -/
namespace FT1536.Source3.StepU1Run195
open C99ArrayReference (State restoreScope)
open C99ModularReference (Exec ModCall chainOf)
open C99MemoryReference (Allocated Load32)
open KeygenMkgm3Program
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open KeygenSmallOutput (element)
open SelectedStepLayout187 (gm igm)
open KeygenFullData127 (rev)
open StepU1Entry195 (p1 p0i1 r21 g1)
open StepU1Body195 (rU gRun igU)

/- Row prelude at the prelude end state. -/
def g2 : BitVec 32 := Gen0RowPrelude189.square gRun p1 p0i1
def g4 : BitVec 32 := Gen0RowPrelude189.fourth gRun p1 p0i1
def ig2 : BitVec 32 := Gen0RowPrelude189.square igU p1 p0i1
def ig4 : BitVec 32 := Gen0RowPrelude189.fourth igU p1 p0i1

noncomputable def preBefore (s : State) : State := StepU1Body195.after s
noncomputable def preAfter (s : State) : State :=
  Gen0RowPrelude189.after (preBefore s) gRun igU p1 p0i1

theorem pre_input (s : State) : Gen0RowPrelude189.Input (preBefore s) gRun igU p1 p0i1 :=
  ⟨StepU1Body195.g_cell s,StepU1Body195.ig_cell s,StepU1Body195.p_cell s,StepU1Body195.i_cell s,
    StepU1Body195.logn_cell s,some (.uint32 12),StepU1Body195.k_cell s⟩

theorem pre_source (s : State) :
    Exec (chainOf KeygenMkgm3RowInit.rowPrelude) (preBefore s) ⟨preAfter s,.normal⟩ :=
  Gen0RowPreludeFacts189.source (preBefore s) gRun igU p1 p0i1 (pre_input s)

theorem pre_run (s : State) :
    ModularSequence178.Run ModCall KeygenMkgm3RowInit.rowPrelude (preBefore s) (preAfter s) := by
  exact Gen0RowPrelude189.source (preBefore s) gRun igU p1 p0i1 (pre_input s)

theorem pre_heap (s : State) : (preAfter s).heap=s.heap :=
  (Gen0RowPreludeFacts189.heap (preBefore s) gRun igU p1 p0i1 (pre_input s)).trans
    (StepU1Body195.entry_heap s)

theorem pre_arrays (s : State) : (preAfter s).arrays=(preBefore s).arrays :=
  Gen0RowPreludeFacts189.arrays (preBefore s) gRun igU p1 p0i1 (pre_input s)

theorem u_declared (s : State) : (preAfter s).locals "u".toList=some (.uint64,none) :=
  (Gen0RowPreludeFacts189.u_cell (preBefore s) gRun igU p1 p0i1 (pre_input s)).trans
    (StepU1Body195.u_declared s)

theorem pre_x (s : State) : Slot (preAfter s) "x" gRun :=
  Gen0RowPreludeFacts189.x_cell (preBefore s) gRun igU p1 p0i1
theorem pre_ix (s : State) : Slot (preAfter s) "ix" igU :=
  Gen0RowPreludeFacts189.ix_cell (preBefore s) gRun igU p1 p0i1

/- The fixed facts of the row loop input state. -/
theorem table (s : State) (input0 : StepU1Entry195.Input s) :
    KeygenMkgm3RevMemory.Rev (preAfter s) rev :=
  KeygenMkgm3RevMemory.from_source (preAfter s) rev
    (by rw [pre_arrays]; exact StepU1Body195.rev_binding s input0)
    (by rw [pre_heap]; exact input0.revSource)

theorem fixed (s : State) (input0 : StepU1Entry195.Input s) :
    Gen0RowFixed189.Fixed (preAfter s) gm igm rev p1 p0i1 g2 g4 ig2 ig4 := by
  refine ⟨Gen0RowPreludeFacts189.p_cell (preBefore s) gRun igU p1 p0i1 (pre_input s),
    Gen0RowPreludeFacts189.i_cell (preBefore s) gRun igU p1 p0i1 (pre_input s),
    Gen0RowPreludeFacts189.g2_cell (preBefore s) gRun igU p1 p0i1,
    Gen0RowPreludeFacts189.g4_cell (preBefore s) gRun igU p1 p0i1,
    Gen0RowPreludeFacts189.ig2_cell (preBefore s) gRun igU p1 p0i1,
    Gen0RowPreludeFacts189.ig4_cell (preBefore s) gRun igU p1 p0i1,
    Gen0RowPreludeFacts189.k_cell (preBefore s) gRun igU p1 p0i1,
    Gen0RowPreludeFacts189.b_cell (preBefore s) gRun igU p1 p0i1,
    ?_,?_,table s input0,by decide,by decide,?_,?_,?_,?_⟩
  · rw [pre_arrays]; exact StepU1Body195.gm_binding s
  · rw [pre_arrays]; exact StepU1Body195.igm_binding s
  · intro j hj
    rw [pre_heap]
    exact input0.scratch (2718+j) (by omega)
  · intro j hj
    rw [pre_heap]
    exact input0.scratch (3230+j) (by omega)
  · rw [pre_heap]; exact input0.writable
  · rw [pre_heap]; exact input0.writable

/- The 512-row loop engine instance. -/
theorem exists_row (s : State) (input0 : StepU1Entry195.Input s) :
    ∃ out x' ix', Exec lastRowLoop (preAfter s) ⟨out,.normal⟩ ∧
      Gen0RowFixed189.Fixed out gm igm rev p1 p0i1 g2 g4 ig2 ig4 ∧
      Slot out "x" x' ∧ Slot out "ix" ix' ∧ USlot out "u" 256 :=
  Gen0RowLoop189.full (preAfter s) gm igm rev p1 p0i1 g2 g4 ig2 ig4 gRun igU
    (fixed s input0) (pre_x s) (pre_ix s) none (u_declared s)

noncomputable def rowLoopAfter (s : State) (input0 : StepU1Entry195.Input s) : State :=
  Classical.choose (exists_row s input0)

theorem row_source (s : State) (input0 : StepU1Entry195.Input s) :
    Exec lastRowLoop (preAfter s) ⟨rowLoopAfter s input0,.normal⟩ := by
  obtain ⟨x',ix',run,_⟩ := Classical.choose_spec (exists_row s input0)
  exact run

theorem row_fixed (s : State) (input0 : StepU1Entry195.Input s) :
    Gen0RowFixed189.Fixed (rowLoopAfter s input0) gm igm rev p1 p0i1 g2 g4 ig2 ig4 := by
  obtain ⟨x',ix',_,fx,_⟩ := Classical.choose_spec (exists_row s input0)
  exact fx

theorem row_counter (s : State) (input0 : StepU1Entry195.Input s) :
    USlot (rowLoopAfter s input0) "u" 256 := by
  obtain ⟨x',ix',_,_,_,_,hu⟩ := Classical.choose_spec (exists_row s input0)
  exact hu

/- rowSelect at logn = 9: the elseRow scope. -/
def names : List B20.C.Name := ["x","ix","g2","g4","ig2","ig4","b"].map String.toList
noncomputable def rowAfter (s : State) (input0 : StepU1Entry195.Input s) : State :=
  restoreScope (preBefore s) (rowLoopAfter s input0) names []

theorem else_shape : elseRow=.scope names (chainOf (KeygenMkgm3RowInit.rowPrelude++[lastRowLoop])) := rfl

theorem else_source (s : State) (input0 : StepU1Entry195.Input s) :
    Exec elseRow (preBefore s) ⟨rowAfter s input0,.normal⟩ := by
  rw [else_shape]
  apply C99ModularReference.GenExec.scope names _ (preBefore s) ⟨rowLoopAfter s input0,.normal⟩
  exact ModularSequence178.source _ _ _ _ (pre_run s)
    [lastRowLoop] _ (.seqNormal _ _ (preAfter s) (rowLoopAfter s input0) _
      (row_source s input0) (.base .skip _ _ (.skip _)))

theorem select_source (s : State) (input0 : StepU1Entry195.Input s) :
    Exec rowSelect (preBefore s) ⟨rowAfter s input0,.normal⟩ :=
  .branchFalse _ _ _ (preBefore s) ⟨rowAfter s input0,.normal⟩ (.int32 0)
    (.compare .eq _ _ _ _ _ (.variable _ _ _ (pre_input s).logn) (.literal .int32 1)
      (.step .eq (.uint32 9) (.int32 1) .uint32 rfl (.uint32 9) (.uint32 1) rfl rfl))
    rfl (else_source s input0)

/- kFromLogn and the false ifFull. -/
noncomputable def controlAfter (s : State) (input0 : StepU1Entry195.Input s) : State :=
  ModularAtoms178.set (rowAfter s input0) "k" 8

theorem k_before (s : State) (input0 : StepU1Entry195.Input s) : Slot (rowAfter s input0) "k" 2 :=
  (row_fixed s input0).kCell

theorem logn_cell (s : State) (input0 : StepU1Entry195.Input s) : Slot (rowAfter s input0) "logn" 9 :=
  KeygenNttControl.keep_u32 (select_source s input0) (by decide) "logn" 9 (by decide)
    (StepU1Body195.logn_cell s)

theorem full_cell (s : State) (input0 : StepU1Entry195.Input s) : Slot (rowAfter s input0) "full" 0 :=
  KeygenNttControl.keep_u32 (select_source s input0) (by decide) "full" 0 (by decide)
    (StepU1Body195.full_cell s)

theorem k_source (s : State) (input0 : StepU1Entry195.Input s) :
    Exec kFromLogn (rowAfter s input0) ⟨controlAfter s input0,.normal⟩ :=
  ModularAtoms178.assign (rowAfter s input0) "k" (some (.uint32 2)) _ 8 (k_before s input0)
    (.scalar _ _ (.arithmetic .minus _ _ _ _ _ (.variable _ _ _ (logn_cell s input0))
      (.literal .int32 1)
      (.step .minus (.uint32 9) (.int32 1) .uint32 rfl (.uint32 9) (.uint32 1) rfl rfl
        (by intro impossible; cases impossible))))

theorem skip_cube (s : State) (input0 : StepU1Entry195.Input s) :
    Exec ifFull (controlAfter s input0) ⟨controlAfter s input0,.normal⟩ :=
  .branchFalse _ _ _ (controlAfter s input0) ⟨controlAfter s input0,.normal⟩ (.uint32 0)
    (.variable _ _ _ (full_cell s input0)) rfl (.base .skip _ _ (.skip _))

/- The fixed facts at the square-loop input state. -/
theorem raw_before (s : State) (input0 : StepU1Entry195.Input s) :
    GeneratorSquareDomains181.From (StepU1Body195.after s).heap gm igm 0 := by
  rw [StepU1Body195.entry_heap]
  exact input0.rawInit

theorem initialized (s : State) (input0 : StepU1Entry195.Input s) :
    GeneratorSquareDomains181.From (controlAfter s input0).heap gm igm 0 :=
  GeneratorSquareDomains181.from_transport _ _ gm igm 0
    (C99InitializationTrace.steps_preserve _ _ (KeygenMkgm3RevMemory.memory_steps _ _ _
      (select_source s input0))) (raw_before s input0)

theorem control_fixed (s : State) (input0 : StepU1Entry195.Input s) :
    GeneratorCubeFixed180.Fixed (controlAfter s input0) gm igm p1 p0i1 := by
  have stable := KeygenMemoryStability.modular _ _ _ (select_source s input0)
  have control := KeygenNttControl.frame _ _ _ (by decide) (select_source s input0)
  refine ⟨?_,?_,ModularAtoms178.slot (rowAfter s input0) "k" 8,?_,?_,by decide,by decide,
    ?_,?_,?_,?_,?_,?_⟩
  · exact (control.2.1 "p".toList (by decide)).trans (StepU1Body195.p_cell s)
  · exact (control.2.1 "p0i".toList (by decide)).trans (StepU1Body195.i_cell s)
  · exact (control.2.2 "gm".toList (by decide)).trans (StepU1Body195.gm_binding s)
  · exact (control.2.2 "igm".toList (by decide)).trans (StepU1Body195.igm_binding s)
  · intro j hj
    change C99MemoryReference.Allocated (rowAfter s input0).heap (element gm j)
    unfold C99MemoryReference.Allocated
    rw [show (rowAfter s input0).heap.size=(StepU1Body195.after s).heap.size from stable.size]
    exact StepU1Body195.allocated s input0 (2718+j) (by omega)
  · intro j hj
    change C99MemoryReference.Allocated (rowAfter s input0).heap (element igm j)
    unfold C99MemoryReference.Allocated
    rw [show (rowAfter s input0).heap.size=(StepU1Body195.after s).heap.size from stable.size]
    exact StepU1Body195.allocated s input0 (3230+j) (by omega)
  · change (rowAfter s input0).heap.writable 31=true
    rw [stable.writable]
    exact StepU1Body195.writable s input0
  · change (rowAfter s input0).heap.writable 31=true
    rw [stable.writable]
    exact StepU1Body195.writable s input0
  · intro j lo hi; exact (initialized s input0 j (by omega) hi).1
  · intro j lo hi; exact (initialized s input0 j (by omega) hi).2

theorem u_cell (s : State) (input0 : StepU1Entry195.Input s) :
    USlot (controlAfter s input0) "u" 256 := row_counter s input0

/- The squareLoop engine instance. -/
theorem input_initialized (s : State) (input0 : StepU1Entry195.Input s) :
    GeneratorSquareDomains181.From (controlAfter s input0).heap gm igm 256 :=
  fun j _ hi => initialized s input0 j (Nat.zero_le j) hi

theorem exists_square (s : State) (input0 : StepU1Entry195.Input s) :
    ∃ out, Exec squareLoop (controlAfter s input0) ⟨out,.normal⟩ ∧
      GeneratorCubeFixed180.Fixed out gm igm p1 p0i1 ∧ USlot out "u" 0 ∧
      GeneratorSquareDomains181.From out.heap gm igm 1 :=
  GeneratorSquareLoop181.full (controlAfter s input0) gm igm p1 p0i1 (control_fixed s input0)
    (input_initialized s input0) (some (.uint64 256)) (u_cell s input0)

noncomputable def squareAfter (s : State) (input0 : StepU1Entry195.Input s) : State :=
  Classical.choose (exists_square s input0)

theorem square_run (s : State) (input0 : StepU1Entry195.Input s) :
    Exec squareLoop (controlAfter s input0) ⟨squareAfter s input0,.normal⟩ :=
  (Classical.choose_spec (exists_square s input0)).1

theorem square_fixed (s : State) (input0 : StepU1Entry195.Input s) :
    GeneratorCubeFixed180.Fixed (squareAfter s input0) gm igm p1 p0i1 :=
  (Classical.choose_spec (exists_square s input0)).2.1

theorem square_counter (s : State) (input0 : StepU1Entry195.Input s) :
    USlot (squareAfter s input0) "u" 0 :=
  (Classical.choose_spec (exists_square s input0)).2.2.1

theorem square_initialized (s : State) (input0 : StepU1Entry195.Input s) :
    GeneratorSquareDomains181.From (squareAfter s input0).heap gm igm 1 :=
  (Classical.choose_spec (exists_square s input0)).2.2.2

/- The three top elements. -/
theorem exists_word (s : State) (input0 : StepU1Entry195.Input s) :
    ∃ w, Load32 (squareAfter s input0).heap (element gm 1) w :=
  Word32Initialized180.load (squareAfter s input0).heap (element gm 1)
    ((square_fixed s input0).gAllocated 1 (by decide)) (square_fixed s input0).gWidth
    ((square_initialized s input0) 1 (by decide) (by decide)).1

noncomputable def w (s : State) (input0 : StepU1Entry195.Input s) : BitVec 32 :=
  Classical.choose (exists_word s input0)

noncomputable def topAfter (s : State) (input0 : StepU1Entry195.Input s) : State :=
  GeneratorTopSource181.after (squareAfter s input0) gm igm (w s input0) p1 p0i1 rU r21

theorem r_before (s : State) (input0 : StepU1Entry195.Input s) : Slot (controlAfter s input0) "R" rU :=
  (ModularAtoms178.outside (rowAfter s input0) "k" "R" 8 (by decide)).trans
    (KeygenNttControl.keep_u32 (select_source s input0) (by decide) "R" rU (by decide)
      (StepU1Body195.r_cell s))

theorem r2_before (s : State) (input0 : StepU1Entry195.Input s) :
    Slot (controlAfter s input0) "R2" r21 :=
  (ModularAtoms178.outside (rowAfter s input0) "k" "R2" 8 (by decide)).trans
    (KeygenNttControl.keep_u32 (select_source s input0) (by decide) "R2" r21 (by decide)
      (StepU1Body195.r2_cell s))

theorem w_before (s : State) (input0 : StepU1Entry195.Input s) :
    (controlAfter s input0).locals "w".toList=some (.uint32,none) :=
  (ModularAtoms178.outside (rowAfter s input0) "k" "w" 8 (by decide)).trans
    (((KeygenNttControl.frame _ _ _ (by decide) (select_source s input0)).2.1 "w".toList
      (by decide)).trans (StepU1Body195.w_declared s))

theorem r_cell (s : State) (input0 : StepU1Entry195.Input s) : Slot (squareAfter s input0) "R" rU :=
  KeygenNttControl.keep_u32 (square_run s input0) (by decide) "R" rU (by decide) (r_before s input0)

theorem r2_cell (s : State) (input0 : StepU1Entry195.Input s) :
    Slot (squareAfter s input0) "R2" r21 :=
  KeygenNttControl.keep_u32 (square_run s input0) (by decide) "R2" r21 (by decide) (r2_before s input0)

theorem w_declared (s : State) (input0 : StepU1Entry195.Input s) :
    (squareAfter s input0).locals "w".toList=some (.uint32,none) :=
  ((KeygenNttControl.frame _ _ _ (by decide) (square_run s input0)).2.1 "w".toList (by decide)).trans
    (w_before s input0)

theorem top_source (s : State) (input0 : StepU1Entry195.Input s) :
    Exec (chainOf topElements) (squareAfter s input0) ⟨topAfter s input0,.normal⟩ :=
  GeneratorTopSource181.source (squareAfter s input0) gm igm (w s input0) p1 p0i1 rU r21
    (square_fixed s input0) (r_cell s input0) (r2_cell s input0) none (w_declared s input0)
    (Classical.choose_spec (exists_word s input0))

/- The full body execution at the u = 1 callee entry. -/
theorem remainder_source (s : State) (input0 : StepU1Entry195.Input s) :
    Exec (chainOf StepU1Body195.remaining) (StepU1Body195.after s) ⟨topAfter s input0,.normal⟩ :=
  .seqNormal _ _ (StepU1Body195.after s) (rowAfter s input0) _ (select_source s input0)
    (.seqNormal _ _ (rowAfter s input0) (controlAfter s input0) _ (k_source s input0)
      (.seqNormal _ _ (controlAfter s input0) (controlAfter s input0) _ (skip_cube s input0)
        (.seqNormal _ _ (controlAfter s input0) (squareAfter s input0) _ (square_run s input0)
          (top_source s input0))))

theorem body_source (s : State) (input0 : StepU1Entry195.Input s) :
    Exec KeygenMkgm3Program.code (StepU1Entry195.entry s) ⟨topAfter s input0,.normal⟩ :=
  StepU1Body195.continue_generator s ⟨topAfter s input0,.normal⟩ (remainder_source s input0)

end FT1536.Source3.StepU1Run195
