import Source3.KeygenPublicReverseRow

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- All reverse u1 rows in their actual order, with physical j*t offsets
   and the writable generated inverse table preserved through every store. -/
namespace FT1536.Source3.KeygenPublicReverseRows
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicAlgebra (R)
open KeygenPublicInputCells (Cells)
open KeygenPublicInverseTables (Table)
open KeygenPublicSizeOps (Declared)
open KeygenNttLoopSupport (USlot)
open KeygenPublicTableControl (frame seq_inv)
open KeygenPublicReverseProgram
open KeygenPublicRadixProgram (nextRow nextBase)

def image (a : Nat → R) (m h : Nat) : Nat → Nat → R
  | 0 => a
  | j+1 => KeygenPublicReverseFold.image (image a m h j) (j*(2*h)) h (KeygenPublicReverseRow.root m j) h

structure Fixed (p igm : ArrayPointer) (m h : Nat) (s : State) : Prop where
  positive : 0 < h
  bound : m≤256
  extent : m*(2*h)=1536
  width : p.elementBytes=2
  separate : p.block≠igm.block
  pointer : s.arrays "a".toList=some p
  square : s.arrays "igm_square".toList=some igm
  table : Table s.heap igm
  count : USlot s "m" m
  half : USlot s "ht" h
  size : USlot s "t" (2*h)
structure Inv (a : Nat → R) (p igm : ArrayPointer) (m h j : Nat) (s : State) : Prop
    extends Fixed p igm m h s where
  counterBound : j≤m
  counter : USlot s "u1" j
  base : USlot s "v1" (j*(2*h))
  vType : Declared s "v"
  cells : Cells s.heap p 1536 (image a m h j)

def fixedNames : List Name := ["m".toList,"ht".toList,"t".toList]
theorem fixed_after (code : Stmt) (s : State) (out : Result) (p igm : ArrayPointer) (m h : Nat)
    (ok : KeygenPublicTableControl.supported code=true) (only : KeygenPublicValueFrames.onlyA code=true)
    (keep : ∀ name∈fixedNames, name∉KeygenPublicTableControl.writes code)
    (fixed : Fixed p igm m h s) (source : Exec KeygenPublicSource.program [] code s out) :
    Fixed p igm m h out.state := by
  have f := frame _ [] code s out ok source
  exact ⟨fixed.positive,fixed.bound,fixed.extent,fixed.width,fixed.separate,
    by rw [f.2.1]; exact fixed.pointer,by rw [f.2.1]; exact fixed.square,
    KeygenPublicInverseTables.table_after code s out p igm ok only fixed.separate fixed.pointer fixed.table source,
    (f.2.2 _ (keep _ (by simp [fixedNames]))).trans fixed.count,
    (f.2.2 _ (keep _ (by simp [fixedNames]))).trans fixed.half,
    (f.2.2 _ (keep _ (by simp [fixedNames]))).trans fixed.size⟩

theorem step (a : Nat → R) (p igm : ArrayPointer) (m h j : Nat) (s middle next : State)
    (active : j<m) (inv : Inv a p igm m h j s)
    (iteration : Exec KeygenPublicSource.program [] rowBody s ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program [] rowStep middle ⟨next,.normal⟩) :
    Inv a p igm m h (j+1) next := by
  have bound := inv.bound
  have extent := inv.extent
  have rowExtent : j*(2*h)+2*h≤1536 := by
    have mul := Nat.mul_le_mul_right (2*h) (show j+1≤m from by omega)
    nlinarith
  have baseBound : j*(2*h)≤1536 := by omega
  have hBound : 2*h≤1536 := by nlinarith
  obtain ⟨cells,vc⟩ := KeygenPublicReverseRow.source_row (image a m h j) p igm m j (j*(2*h)) h s ⟨middle,.normal⟩
    inv.positive rowExtent (by omega) (by omega) inv.width
    ⟨inv.pointer,inv.square,inv.count,inv.counter,inv.base,inv.half⟩ inv.vType inv.table inv.cells iteration
  have fm := fixed_after rowBody s ⟨middle,.normal⟩ p igm m h (by decide) (by decide) (by decide) inv.toFixed iteration
  have row := (frame _ [] rowBody _ _ (by decide) iteration).2.2 _ (by decide) |>.trans inv.counter
  have base := (frame _ [] rowBody _ _ (by decide) iteration).2.2 _ (by decide) |>.trans inv.base
  obtain ⟨mid,inc,add⟩ := seq_inv nextRow nextBase middle ⟨next,.normal⟩ (by decide) update
  obtain ⟨count,heap1⟩ := KeygenPublicSizeOps.increment middle ⟨mid,.normal⟩ "u1" j (by omega) row inc
  have stepFrame := frame _ [] nextRow middle ⟨mid,.normal⟩ (by decide) inc
  have base1 : USlot mid "v1" (j*(2*h)) := (stepFrame.2.2 _ (by decide)).trans base
  have t1 : USlot mid "t" (2*h) := (stepFrame.2.2 _ (by decide)).trans fm.size
  have sum := (KeygenPublicSizeOps.assign mid ⟨next,.normal⟩ "v1" _ (j*(2*h)+2*h) (by omega)
    ⟨_,base1⟩ (KeygenPublicSizeOps.sum mid _ _ _ _ (by omega) (by omega)
      (KeygenPublicSizeOps.variable_slot mid "v1" _ base1) (KeygenPublicSizeOps.variable_slot mid "t" _ t1)) add).2
  have heap2 := KeygenPublicTableControl.assign_heap _ _ _ _ add
  have fn := fixed_after rowStep middle ⟨next,.normal⟩ p igm m h (by decide) (by decide) (by decide) fm update
  refine ⟨fn,by omega,?_,?_,?_,?_⟩
  · exact (frame _ [] nextBase _ _ (by decide) add).2.2 _ (by decide) |>.trans count
  · convert sum using 1; ring
  · refine ⟨some (KeygenNttLoopSupport.u64 (j*(2*h)+h)),?_⟩
    exact (frame _ [] rowStep _ _ (by decide) update).2.2 _ (by decide) |>.trans vc
  · rw [heap2,heap1]; exact cells

theorem loop_result (a : Nat → R) (p igm : ArrayPointer) (m h : Nat) (code : Stmt)
    (before : State) (result : Result) (source : Exec KeygenPublicSource.program [] code before result)
    (shape : code=rowLoop) (j : Nat) (inv : Inv a p igm m h j before) :
    result.flow=.normal ∧ Inv a p igm m h m result.state := by
  generalize sgnEq : ([] : List Name)=sgn at source
  induction source generalizing j with
  | loopFalse _ _ _ before v guard zero =>
      cases shape; cases sgnEq
      have bound := inv.bound
      have count := inv.counterBound
      rw [KeygenPublicSizeOps.lt before "u1" "m" j m (by omega) (by omega) v inv.counter inv.count guard] at zero
      have no : ¬j<m := by
        by_contra active
        simp [active,C99ScalarReference.boolean,Value.integer] at zero
      have eq : j=m := by omega
      subst j
      exact ⟨rfl,inv⟩
  | loopNormal _ _ _ before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape; cases sgnEq
      have bound := inv.bound
      have count := inv.counterBound
      rw [KeygenPublicSizeOps.lt before "u1" "m" j m (by omega) (by omega) v inv.counter inv.count guard] at nonzero
      have active : j<m := by
        by_contra no
        simp [no,C99ScalarReference.boolean,Value.integer] at nonzero
      exact ih3 rfl (j+1) (step a p igm m h j before middle next active inv iteration update) rfl
  | loopReturn _ _ _ _ _ _ _ _ _ iteration _ =>
      cases shape
      have impossible := (frame _ _ _ _ _ (by decide) iteration).1
      cases impossible
  | skip | scalar | assign | declarePointer | pointer | store | call | seqNormal | seqExit
  | scope | arrayScope | branchTrue | branchFalse | ret | retVoid => cases shape

theorem source_rows (a : Nat → R) (p igm : ArrayPointer) (m h : Nat) (s : State) (out : Result)
    (fixed : Fixed p igm m h s) (rowType : Declared s "u1") (baseType : Declared s "v1")
    (vType : Declared s "v") (input : Cells s.heap p 1536 a)
    (source : Exec KeygenPublicSource.program [] rows s out) :
    out.flow=.normal ∧ Inv a p igm m h m out.state := by
  obtain ⟨entry,init,loop⟩ := seq_inv initRows rowLoop s out (by decide) source
  obtain ⟨mid,first,second⟩ := seq_inv _ _ s ⟨entry,.normal⟩ (by decide) init
  obtain ⟨row,heap1⟩ := KeygenPublicSizeOps.init s ⟨mid,.normal⟩ "u1" 0 (by decide) rowType first
  have frame1 := frame _ [] (.assign "u1".toList (KeygenPublicTableAtoms.literal 0)) s ⟨mid,.normal⟩ (by decide) first
  have baseType1 : Declared mid "v1" := by rw [Declared,frame1.2.2 _ (by decide)]; exact baseType
  obtain ⟨base,heap2⟩ := KeygenPublicSizeOps.init mid ⟨entry,.normal⟩ "v1" 0 (by decide) baseType1 second
  have frame2 := frame _ [] (.assign "v1".toList (KeygenPublicTableAtoms.literal 0)) mid ⟨entry,.normal⟩ (by decide) second
  have inv : Inv a p igm m h 0 entry := by
    refine ⟨fixed_after initRows s ⟨entry,.normal⟩ p igm m h (by decide) (by decide) (by decide) fixed init,
      Nat.zero_le _,(frame2.2.2 _ (by decide)).trans row,?_,?_,?_⟩
    · simpa only [Nat.zero_mul] using base
    · rw [Declared,(frame _ [] initRows _ _ (by decide) init).2.2 _ (by decide)]; exact vType
    · rw [heap2,heap1]; exact input
  exact loop_result a p igm m h rowLoop entry out loop rfl 0 inv

end FT1536.Source3.KeygenPublicReverseRows
