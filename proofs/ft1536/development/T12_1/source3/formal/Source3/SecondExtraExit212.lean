import Source3.SecondExtraInner212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondExtraExit212
open C99ArrayReference (State Name restoreScope)
open C99LoopScalar141 (Cell)
open KeygenMakeFgSource (Exec)
open SecondStepOuter204 (Outer)

def scopedState (s out : State) := restoreScope s out MakeFgAddPrimeShape194.localNames MakeFgAddPrimeShape194.pointerNames
 def next (s out : State) := FftLocalCells140.put (scopedState s out) "u".toList (C99NatWord141.word 3)

theorem scoped_local (s out : State) (name : Name) (absent : name∉MakeFgAddPrimeShape194.localNames) :
    (scopedState s out).locals name=out.locals name := by
  simp only [scopedState,restoreScope,C99ScalarReference.restore,List.contains_iff_mem,absent,ite_false]

theorem scope_source (s out : State) (run : Exec MakeFgAddPrimeShape194.aInner s ⟨out,.normal⟩) :
    Exec MakeFgAddPrimeShape194.aBody s ⟨scopedState s out,.normal⟩ := by
  rw [MakeFgAddPrimeShape194.body_shape]
  exact .scope _ _ _ s ⟨out,.normal⟩ run

theorem increment (s out : State) (u : Cell out "u".toList 2) :
    Exec MakeFgAddPrimeShape194.aInc (scopedState s out) ⟨next s out,.normal⟩ := by
  have cell : Cell (scopedState s out) "u".toList 2 := (scoped_local s out _ (by decide)).trans u
  have update : C99ArrayReference.Exec FftLeafPrograms.program
      (.scalar (.update "u".toList .add (MakeFgTailShape190.num 1))) (scopedState s out) (next s out) := by
    cases C99LoopScalar141.increment (fun _ => none) (scopedState s out) "u".toList 2 (by decide) cell with
    | base _ _ _ source => exact source
  rw [MakeFgAddPrimeShape194.inc_shape]
  exact .level _ _ _ (.modular _ _ _ (.base _ _ _ update))

theorem put_same (s : State) (name : Name) (w : BitVec 64) (cell : s.locals name=some (.uint64,some (.uint64 w))) :
    FftLocalCells140.put s name w=s := by
  have eq : C99ScalarReference.set s.locals name (.uint64,some (.uint64 w))=s.locals := by
    funext other
    by_cases same : other=name
    · subst other; simp only [C99ScalarReference.set,ite_true]; exact cell.symm
    · simp only [C99ScalarReference.set,same,ite_false]
  change {s with locals:=C99ScalarReference.set s.locals name (.uint64,some (.uint64 w))}=s
  rw [eq]

theorem init_source (s : State) (h : Outer s 2) : Exec MakeFgAddPrimeShape194.aInit s ⟨s,.normal⟩ := by
  have run : Exec MakeFgAddPrimeShape194.initU s ⟨CrtState205.set64 s "u" 2,.normal⟩ :=
    .level _ _ _ (.modular _ _ _ (.assign _ _ _ .uint64 (some (.uint64 2)) (.uint64 2) h.uCell
      (.scalar _ _ (.variable _ _ _ h.slenCell))))
  rw [MakeFgAddPrimeShape194.init_shape]
  have eq : CrtState205.set64 s "u" 2=s := (FftLocalCells140.put_bind s "u".toList 2).symm.trans (put_same s "u".toList 2 h.uCell)
  simpa only [eq] using run

theorem locals (s out : State)
    (ls : ∀ name : Name, name∉MakeFgAddPrimeShape194.localNames → out.locals name=s.locals name)
    (name : Name) (nu : name≠"u".toList) : (next s out).locals name=s.locals name := by
  change (FftLocalCells140.put (scopedState s out) "u".toList (C99NatWord141.word 3)).locals name=s.locals name
  rw [FftLocalCells140.outside _ _ _ _ nu]
  by_cases member : name∈MakeFgAddPrimeShape194.localNames
  · simp only [scopedState,restoreScope,C99ScalarReference.restore,List.contains_iff_mem,member,ite_true]
  · exact (scoped_local s out name member).trans (ls name member)

theorem arrays (s out : State) (ars : ∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) :
    (next s out).arrays=s.arrays := by
  funext name
  change (if MakeFgAddPrimeShape194.pointerNames.contains name then s.arrays name else out.arrays name)=s.arrays name
  by_cases same : name="x".toList
  · subst name; rfl
  · have absent : name∉MakeFgAddPrimeShape194.pointerNames := by simp only [MakeFgAddPrimeShape194.pointerNames,List.mem_cons,List.not_mem_nil,or_false]; exact same
    simp only [List.contains_iff_mem,absent,ite_false]
    exact ars name same

theorem outer (s out : State) (h : Outer s 2)
    (run : Exec MakeFgAddPrimeShape194.aInner s ⟨out,.normal⟩)
    (ls : ∀ name : Name, name∉MakeFgAddPrimeShape194.localNames → out.locals name=s.locals name)
    (ars : ∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) : Outer (next s out) 3 := by
  have l:=locals s out ls
  have a:=arrays s out ars
  have stable:=KeygenHelperStability.make _ _ _ run
  have size : out.heap.size=s.heap.size := stable.size
  refine ⟨(l _ (by decide)).trans h.nCell,(l _ (by decide)).trans h.hnCell,(l _ (by decide)).trans h.slenCell,
    (l _ (by decide)).trans h.tlenCell,FftLocalCells140.cell_at _ _ _,(l _ (by decide)).trans h.lognCell,
    (l _ (by decide)).trans h.terCell,(l _ (by decide)).trans h.inCell,(l _ (by decide)).trans h.outCell,
    (congrFun a _).trans h.fdBinding,(congrFun a _).trans h.gdBinding,(congrFun a _).trans h.fsBinding,
    (congrFun a _).trans h.gsBinding,(congrFun a _).trans h.gmBinding,(congrFun a _).trans h.igmBinding,
    (congrFun a _).trans h.t1Binding,(congrFun a _).trans h.primesBinding,?_,?_⟩
  · change out.heap.writable 31=true; rw [stable.writable]; exact h.writable
  · intro i bound
    change C99MemoryReference.Allocated out.heap _
    simpa only [C99MemoryReference.Allocated,size] using h.allocated i bound

theorem true_guard (s : State) (h : Outer s 2) :
    C99ArrayReference.scalar s (.cmp .lt MakeFgAddPrimeShape194.varU MakeFgAddPrimeShape194.varTlen) (.int32 1) :=
  .compare .lt _ _ _ _ _ (.variable _ _ _ h.uCell) (.variable _ _ _ h.tlenCell)
    (.step .lt (.uint64 2) (.uint64 3) .uint64 rfl (.uint64 2) (.uint64 3) rfl rfl)

theorem loop_end (s : State) (h : Outer s 3) : Exec MakeFgAddPrimeShape194.aLoop s ⟨s,.normal⟩ := by
  rw [MakeFgAddPrimeShape194.loop_shape]
  exact .loopFalse _ _ _ s (.int32 0)
    (.compare .lt _ _ _ _ _ (.variable _ _ _ h.uCell) (.variable _ _ _ h.tlenCell)
      (.step .lt (.uint64 3) (.uint64 3) .uint64 rfl (.uint64 3) (.uint64 3) rfl rfl)) rfl

end FT1536.Source3.SecondExtraExit212
