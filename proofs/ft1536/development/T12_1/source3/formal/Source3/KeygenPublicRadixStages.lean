import Source3.KeygenPublicRadixRows

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- All eight executed outer m stages. The recursive image records exactly
   the source's row order; relating it to original-polynomial evaluations
   is a separate invariant, not an assumption of this source fold. -/
namespace FT1536.Source3.KeygenPublicRadixStages
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicAlgebra (R)
open KeygenPublicInputCells (Cells)
open KeygenPublicFirstTables (Table)
open KeygenPublicSizeOps (Declared)
open KeygenNttLoopSupport (USlot)
open KeygenPublicTableControl (frame seq_inv)
open KeygenPublicRadixProgram

def size (k : Nat) : Nat := 768/2^k
def count (k : Nat) : Nat := 2^(k+1)
def image (a : Nat → R) : Nat → Nat → R
  | 0 => a
  | k+1 => KeygenPublicRadixRows.image (image a k) (count k) (size k/2) (count k)

theorem dimensions (k : Nat) (hk : k<8) :
    0<size k/2 ∧ count k≤256 ∧ count k*(2*(size k/2))=1536 ∧ size k=2*(size k/2) ∧
    size (k+1)=size k/2 ∧ count (k+1)=count k*2 ∧ 3<size k := by
  have cert : ∀ i : Fin 8,
      0<size i.val/2 ∧ count i.val≤256 ∧ count i.val*(2*(size i.val/2))=1536 ∧ size i.val=2*(size i.val/2) ∧
      size (i.val+1)=size i.val/2 ∧ count (i.val+1)=count i.val*2 ∧ 3<size i.val := by decide
  exact cert ⟨k,hk⟩
theorem size_bound (k : Nat) : size k≤768 := Nat.div_le_self _ _
theorem count_bound (k : Nat) (hk : k≤8) : count k≤512 := by
  have cert : ∀ i : Fin 9, count i.val≤512 := by decide
  exact cert ⟨k,by omega⟩
theorem terminal (k : Nat) (hk : k≤8) : ¬3<size k ↔ k=8 := by
  have cert : ∀ i : Fin 9, ¬3<size i.val ↔ i.val=8 := by decide
  exact cert ⟨k,by omega⟩

structure Fixed (p gm : ArrayPointer) (s : State) : Prop where
  width : p.elementBytes=2
  separate : p.block≠gm.block
  pointer : s.arrays "a".toList=some p
  square : s.arrays "gm_square".toList=some gm
  table : Table s.heap gm
structure Inv (a : Nat → R) (p gm : ArrayPointer) (k : Nat) (s : State) : Prop
    extends Fixed p gm s where
  counterBound : k≤8
  counter : USlot s "m" (count k)
  currentSize : USlot s "t" (size k)
  vType : Declared s "v"
  cells : Cells s.heap p 1536 (image a k)

theorem fixed_after (code : Stmt) (s : State) (out : Result) (p gm : ArrayPointer)
    (ok : KeygenPublicTableControl.supported code=true) (only : KeygenPublicValueFrames.onlyA code=true)
    (fixed : Fixed p gm s) (source : Exec KeygenPublicSource.program [] code s out) : Fixed p gm out.state := by
  have f := frame _ [] code s out ok source
  exact ⟨fixed.width,fixed.separate,by rw [f.2.1]; exact fixed.pointer,by rw [f.2.1]; exact fixed.square,
    KeygenPublicValueFrames.table_after code s out p gm ok only fixed.separate fixed.pointer fixed.table source⟩

theorem source_stage (a : Nat → R) (p gm : ArrayPointer) (k : Nat) (s : State) (out : Result)
    (active : k<8) (inv : Inv a p gm k s)
    (source : Exec KeygenPublicSource.program [] stageBody s out) :
    Cells out.state.heap p 1536 (image a (k+1)) ∧ USlot out.state "t" (size (k+1)) ∧ Declared out.state "v" := by
  obtain ⟨positive,bound,extent,twice,half,_,_⟩ := dimensions k active
  have sb := size_bound k
  cases source with
  | scope _ _ _ _ result executed =>
      obtain ⟨s1,d,rest1⟩ := seq_inv _ _ s result (by decide) executed
      obtain ⟨s2,setHalf,rest2⟩ := seq_inv _ _ s1 result (by decide) rest1
      obtain ⟨s3,rowExec,rest3⟩ := seq_inv _ _ s2 result (by decide) rest2
      obtain ⟨s4,setSize,last⟩ := seq_inv _ _ s3 result (by decide) rest3
      cases last
      have state1 := congrArg Result.state
        (KeygenPublicTableAtoms.declaration_result _ [] s .u64 stageNames ⟨s1,.normal⟩ d)
      dsimp only at state1
      have f1 := frame _ [] (.scalar (.declare .u64 stageNames)) s ⟨s1,.normal⟩ (by decide) d
      have t1 : USlot s1 "t" (size k) := (f1.2.2 _ (by decide)).trans inv.currentSize
      have ht := (KeygenPublicSizeOps.assign s1 ⟨s2,.normal⟩ "ht" _ (size k/2) (by omega)
        ⟨none,by rw [state1]; rfl⟩ (KeygenPublicSizeOps.half s1 "t" (size k) (by omega) t1) setHalf).2
      have f2 := frame _ [] htSet s1 ⟨s2,.normal⟩ (by decide) setHalf
      have heap2 : s2.heap=s.heap := by rw [KeygenPublicTableControl.assign_heap _ _ _ _ setHalf,state1]
      have fixed : KeygenPublicRadixRows.Fixed p gm (count k) (size k/2) s2 := by
        refine ⟨positive,bound,extent,inv.width,inv.separate,?_,?_,?_,?_,ht,?_⟩
        · rw [f2.2.1,f1.2.1]; exact inv.pointer
        · rw [f2.2.1,f1.2.1]; exact inv.square
        · rw [heap2]; exact inv.table
        · exact (f2.2.2 _ (by decide)).trans ((f1.2.2 _ (by decide)).trans inv.counter)
        · rw [← twice]; exact (f2.2.2 _ (by decide)).trans t1
      have rowType : Declared s2 "u1" := by
        refine ⟨none,?_⟩; rw [f2.2.2 _ (by decide),state1]; rfl
      have baseType : Declared s2 "v1" := by
        refine ⟨none,?_⟩; rw [f2.2.2 _ (by decide),state1]; rfl
      have vType : Declared s2 "v" := by
        rw [Declared,f2.2.2 _ (by decide),f1.2.2 _ (by decide)]; exact inv.vType
      have rowsFinal := (KeygenPublicRadixRows.source_rows (image a k) p gm (count k) (size k/2) s2 ⟨s3,.normal⟩
        fixed rowType baseType vType (by rw [heap2]; exact inv.cells) rowExec).2
      have tType : Declared s3 "t" := ⟨_,rowsFinal.size⟩
      have t4 := (KeygenPublicSizeOps.assign s3 ⟨s4,.normal⟩ "t" _ (size k/2) (by omega) tType
        (KeygenPublicSizeOps.variable_slot s3 "ht" _ rowsFinal.half) setSize).2
      refine ⟨?_,?_,?_⟩
      · change Cells s4.heap p 1536 (image a (k+1))
        rw [KeygenPublicTableControl.assign_heap _ _ _ _ setSize]
        exact rowsFinal.cells
      · change USlot s4 "t" (size (k+1))
        rw [half]; exact t4
      · change Declared s4 "v"
        rw [Declared,(frame _ [] tSet _ _ (by decide) setSize).2.2 _ (by decide)]
        exact rowsFinal.vType

theorem step (a : Nat → R) (p gm : ArrayPointer) (k : Nat) (s middle next : State)
    (active : k<8) (inv : Inv a p gm k s)
    (iteration : Exec KeygenPublicSource.program [] stageBody s ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program [] stageStep middle ⟨next,.normal⟩) : Inv a p gm (k+1) next := by
  obtain ⟨cells,t,vType⟩ := source_stage a p gm k s ⟨middle,.normal⟩ active inv iteration
  have bound := count_bound k inv.counterBound
  have countM : USlot middle "m" (count k) :=
    (frame _ [] stageBody _ _ (by decide) iteration).2.2 _ (by decide) |>.trans inv.counter
  have countN := (KeygenPublicSizeOps.assign middle ⟨next,.normal⟩ "m" _ (count k*2) (by omega)
    ⟨_,countM⟩ (KeygenPublicSizeOps.double middle "m" _ (by omega) countM) update).2
  have fm := fixed_after stageBody s ⟨middle,.normal⟩ p gm (by decide) (by decide) inv.toFixed iteration
  have fn := fixed_after stageStep middle ⟨next,.normal⟩ p gm (by decide) (by decide) fm update
  refine ⟨fn,by omega,?_,?_,?_,?_⟩
  · rw [(dimensions k active).2.2.2.2.2.1]; exact countN
  · exact (frame _ [] stageStep _ _ (by decide) update).2.2 _ (by decide) |>.trans t
  · rw [Declared,(frame _ [] stageStep _ _ (by decide) update).2.2 _ (by decide)]; exact vType
  · rw [KeygenPublicTableControl.assign_heap _ _ _ _ update]; exact cells

theorem loop_result (a : Nat → R) (p gm : ArrayPointer) (code : Stmt) (before : State) (result : Result)
    (source : Exec KeygenPublicSource.program [] code before result) (shape : code=stageLoop)
    (k : Nat) (inv : Inv a p gm k before) : result.flow=.normal ∧ Inv a p gm 8 result.state := by
  generalize sgnEq : ([] : List Name)=sgn at source
  induction source generalizing k with
  | loopFalse _ _ _ before v guard zero =>
      cases shape; cases sgnEq
      rw [KeygenPublicSizeOps.gt_three before (size k) (size_bound k) v inv.currentSize guard] at zero
      have no : ¬3<size k := by
        by_contra active
        simp [active,C99ScalarReference.boolean,Value.integer] at zero
      have eq := (terminal k inv.counterBound).mp no
      subst k; exact ⟨rfl,inv⟩
  | loopNormal _ _ _ before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape; cases sgnEq
      rw [KeygenPublicSizeOps.gt_three before (size k) (size_bound k) v inv.currentSize guard] at nonzero
      have active : k<8 := by
        have bound := inv.counterBound
        by_contra no
        have eq : k=8 := by omega
        subst k
        norm_num [size,C99ScalarReference.boolean,Value.integer] at nonzero
      exact ih3 rfl (k+1) (step a p gm k before middle next active inv iteration update) rfl
  | loopReturn _ _ _ _ _ _ _ _ _ iteration _ =>
      cases shape
      have impossible := (frame _ _ _ _ _ (by decide) iteration).1
      cases impossible
  | skip | scalar | assign | declarePointer | pointer | store | call | seqNormal | seqExit
  | scope | arrayScope | branchTrue | branchFalse | ret | retVoid => cases shape

theorem source_stages (a : Nat → R) (p gm : ArrayPointer) (s : State) (out : Result)
    (fixed : Fixed p gm s) (t : USlot s "t" 768) (mType : Declared s "m") (vType : Declared s "v")
    (input : Cells s.heap p 1536 a) (source : Exec KeygenPublicSource.program [] stages s out) :
    out.flow=.normal ∧ Inv a p gm 8 out.state := by
  obtain ⟨entry,init,loop⟩ := seq_inv _ _ s out (by decide) source
  obtain ⟨m,heap⟩ := KeygenPublicSizeOps.init s ⟨entry,.normal⟩ "m" 2 (by decide) mType init
  have f := frame _ [] (.assign "m".toList (KeygenPublicTableAtoms.literal 2)) s ⟨entry,.normal⟩ (by decide) init
  have inv : Inv a p gm 0 entry := by
    refine ⟨fixed_after _ s ⟨entry,.normal⟩ p gm (by decide) (by decide) fixed init,by decide,m,?_,?_,?_⟩
    · exact (f.2.2 _ (by decide)).trans t
    · rw [Declared,f.2.2 _ (by decide)]; exact vType
    · rw [heap]; exact input
  exact loop_result a p gm stageLoop entry out loop rfl 0 inv

end FT1536.Source3.KeygenPublicRadixStages
