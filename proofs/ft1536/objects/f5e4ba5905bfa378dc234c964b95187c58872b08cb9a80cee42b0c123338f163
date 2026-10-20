import Source3.KeygenPublicTripleValues

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Fold all512 executed triples, retaining every cell outside the current
   three stores and the writable generated table through the full loop. -/
namespace FT1536.Source3.KeygenPublicTripleFold
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicAlgebra (R radix)
open KeygenPublicInputCells (Cell Cells)
open KeygenPublicFirstTables (Table)
open KeygenPublicValueExpr (Local)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicTableControl (frame seq_inv)
open KeygenPublicTripleProgram (guard body step loop)

def root (j : Nat) : R := KeygenPublicRoots.root^KeygenMkgm3Indices.tableExponent (512+j)
def value (a : Nat → R) (i : Nat) : R := KeygenPublicTripleOrder.output
  (a (3*(i/3))) (a (3*(i/3)+1)) (a (3*(i/3)+2)) (root (i/3)) KeygenPublicRoots.unity (i%3)
def image (a : Nat → R) (n i : Nat) : R := if i<3*n then value a i else a i
theorem image_input (a : Nat → R) (j k : Nat) : image a j (3*j+k)=a (3*j+k) := by
  simp only [image,show ¬3*j+k<3*j from by omega,ite_false]
theorem image_output (a : Nat → R) (j k : Nat) (hk : k<3) : image a (j+1) (3*j+k)=
    KeygenPublicTripleOrder.output (a (3*j)) (a (3*j+1)) (a (3*j+2)) (root j) KeygenPublicRoots.unity k := by
  have div : (3*j+k)/3=j := by omega
  have rem : (3*j+k)%3=k := by omega
  simp only [image,show 3*j+k<3*(j+1) from by omega,ite_true,value,div,rem]
theorem image_unchanged (a : Nat → R) (j i : Nat)
    (h0 : i≠3*j) (h1 : i≠3*j+1) (h2 : i≠3*j+2) : image a j i=image a (j+1) i := by
  have same : (i<3*j) ↔ i<3*(j+1) := by omega
  simp only [image,same]

structure Fixed (p gm : ArrayPointer) (s : State) : Prop where
  width : p.elementBytes=2
  separate : p.block≠gm.block
  pointer : s.arrays "a".toList=some p
  cubic : s.arrays "gm_cubic".toList=some gm
  table : Table s.heap gm
  n : USlot s "n" 1536
  unity : Local s "w" (radix*KeygenPublicRoots.unity)
structure Inv (a : Nat → R) (p gm : ArrayPointer) (j : Nat) (s : State) : Prop
    extends Fixed p gm s where
  counterBound : j≤512
  u : USlot s "u" (3*j)
  v : USlot s "v" (512+j)
  cells : Cells s.heap p 1536 (image a j)

theorem fixed_after (code : Stmt) (s : State) (out : Result) (p gm : ArrayPointer)
    (ok : KeygenPublicTableControl.supported code=true) (only : KeygenPublicValueFrames.onlyA code=true)
    (keep : "n".toList∉KeygenPublicTableControl.writes code ∧ "w".toList∉KeygenPublicTableControl.writes code)
    (fixed : Fixed p gm s) (source : Exec KeygenPublicSource.program [] code s out) : Fixed p gm out.state := by
  have f := frame _ [] code s out ok source
  exact ⟨fixed.width,fixed.separate,by rw [f.2.1]; exact fixed.pointer,by rw [f.2.1]; exact fixed.cubic,
    KeygenPublicValueFrames.table_after code s out p gm ok only fixed.separate fixed.pointer fixed.table source,
    (f.2.2 _ keep.1).trans fixed.n,
    KeygenPublicValueExpr.local_after code s out "w" _ ok keep.2 fixed.unity source⟩

theorem body_image (a : Nat → R) (p gm : ArrayPointer) (j : Nat) (s : State) (out : Result)
    (active : j<512) (inv : Inv a p gm j s)
    (source : Exec KeygenPublicSource.program [] body s out) : Cells out.state.heap p 1536 (image a (j+1)) := by
  have cells (k : Nat) (hk : k<3) : Cell s.heap p (3*j+k) (a (3*j+k)) := by
    have c := inv.cells (3*j+k) (by omega)
    rwa [image_input] at c
  obtain ⟨⟨c0,c1,c2⟩,h1,h2,w0,w1,w2,store0,store1,store2⟩ := KeygenPublicTripleValues.source_body
    s out p gm (3*j) (512+j) (a (3*j)) (a (3*j+1)) (a (3*j+2)) (root j) KeygenPublicRoots.unity
    (by omega) (by omega) inv.width ⟨inv.pointer,inv.cubic,inv.u,inv.v⟩
    (by simpa only [Nat.add_zero] using cells 0 (by decide)) (cells 1 (by decide)) (cells 2 (by decide))
    (inv.table (512+j) (by omega)) inv.unity source
  intro i hi
  by_cases i0 : i=3*j
  · subst i
    have eq := image_output a j 0 (by decide)
    simp only [Nat.add_zero,KeygenPublicTripleOrder.output,ite_true] at eq
    rw [eq]; exact c0
  · by_cases i1 : i=3*j+1
    · subst i
      rw [image_output a j 1 (by decide)]
      exact c1
    · by_cases i2 : i=3*j+2
      · subst i
        rw [image_output a j 2 (by decide)]
        exact c2
      · have keep0 := KeygenPublicInputCells.preserves _ _ p inv.width (3*j) i (Ne.symm i0) w0 _ store0 (inv.cells i hi)
        have keep1 := KeygenPublicInputCells.preserves _ _ p inv.width (3*j+1) i (Ne.symm i1) w1 _ store1 keep0
        have keep2 := KeygenPublicInputCells.preserves _ _ p inv.width (3*j+2) i (Ne.symm i2) w2 _ store2 keep1
        rwa [image_unchanged a j i i0 i1 i2] at keep2

theorem increment_result (s : State) (out : Result) (j : Nat) (hj : j<512)
    (u : USlot s "u" (3*j)) (v : USlot s "v" (512+j))
    (source : Exec KeygenPublicSource.program [] step s out) :
    USlot out.state "u" (3*(j+1)) ∧ USlot out.state "v" (512+(j+1)) ∧ out.state.heap=s.heap := by
  obtain ⟨mid,nextU,nextV⟩ := seq_inv _ _ s out (by decide) source
  have value : KeygenPublicSizeOps.Has s (.bin .add (KeygenPublicTableAtoms.var "u") (KeygenPublicTableAtoms.literal 3)) (3*j+3) := by
    intro result evaluated
    cases evaluated with
    | bin _ _ _ av bv _ first second op =>
        have ae := KeygenPublicTableIndex.word64 s "u" (3*j) av u first
        have be := KeygenPublicTableAtoms.literal_value [] s 3 bv second
        subst av; subst bv
        exact KeygenPublicTableIndex.plus_literal (3*j) 3 (by omega) (by decide) result op
  have count := (KeygenPublicSizeOps.assign s ⟨mid,.normal⟩ "u" _ (3*j+3) (by omega) ⟨_,u⟩ value nextU).2
  have f := frame _ [] (.assign "u".toList (.bin .add (KeygenPublicTableAtoms.var "u") (KeygenPublicTableAtoms.literal 3))) s ⟨mid,.normal⟩ (by decide) nextU
  have vm : USlot mid "v" (512+j) := (f.2.2 _ (by decide)).trans v
  obtain ⟨vc,heap2⟩ := KeygenPublicSizeOps.increment mid out "v" (512+j) (by omega) vm nextV
  have uFinal := (frame _ [] (.scalar (.update "v".toList .add (.literal .i32 1))) _ _ (by decide) nextV).2.2 _ (by decide) |>.trans count
  refine ⟨?_,?_,heap2.trans (KeygenPublicTableControl.assign_heap _ _ _ _ nextU)⟩
  · rw [show 3*(j+1)=3*j+3 from by omega]
    exact uFinal
  · simpa only [Nat.add_assoc] using vc

theorem iteration_result (a : Nat → R) (p gm : ArrayPointer) (j : Nat) (s middle next : State)
    (active : j<512) (inv : Inv a p gm j s)
    (iteration : Exec KeygenPublicSource.program [] body s ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program [] step middle ⟨next,.normal⟩) : Inv a p gm (j+1) next := by
  have cells := body_image a p gm j s ⟨middle,.normal⟩ active inv iteration
  have fm := fixed_after body s ⟨middle,.normal⟩ p gm (by decide) (by decide) (by decide) inv.toFixed iteration
  have f := frame _ [] body s ⟨middle,.normal⟩ (by decide) iteration
  obtain ⟨u,v,heap⟩ := increment_result middle ⟨next,.normal⟩ j active
    ((f.2.2 _ (by decide)).trans inv.u) ((f.2.2 _ (by decide)).trans inv.v) update
  refine ⟨fixed_after step middle ⟨next,.normal⟩ p gm (by decide) (by decide) (by decide) fm update,by omega,u,v,?_⟩
  rw [heap]; exact cells

theorem loop_result (a : Nat → R) (p gm : ArrayPointer) (code : Stmt) (before : State) (result : Result)
    (source : Exec KeygenPublicSource.program [] code before result) (shape : code=loop)
    (j : Nat) (inv : Inv a p gm j before) : result.flow=.normal ∧ Inv a p gm 512 result.state := by
  generalize sgnEq : ([] : List Name)=sgn at source
  induction source generalizing j with
  | loopFalse _ _ _ before v guard zero =>
      cases shape; cases sgnEq
      have bound := inv.counterBound
      rw [KeygenPublicSizeOps.lt before "u" "n" (3*j) 1536 (by omega) (by decide) v inv.u inv.n guard] at zero
      have no : ¬3*j<1536 := by
        by_contra active
        simp [active,C99ScalarReference.boolean,Value.integer] at zero
      have eq : j=512 := by omega
      subst j; exact ⟨rfl,inv⟩
  | loopNormal _ _ _ before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape; cases sgnEq
      have bound := inv.counterBound
      rw [KeygenPublicSizeOps.lt before "u" "n" (3*j) 1536 (by omega) (by decide) v inv.u inv.n guard] at nonzero
      have active : j<512 := by
        by_contra no
        have falseGuard : ¬3*j<1536 := by omega
        simp [falseGuard,C99ScalarReference.boolean,Value.integer] at nonzero
      exact ih3 rfl (j+1) (iteration_result a p gm j before middle next active inv iteration update) rfl
  | loopReturn _ _ _ _ _ _ _ _ _ iteration _ =>
      cases shape
      have impossible := (frame _ _ _ _ _ (by decide) iteration).1
      cases impossible
  | skip | scalar | assign | declarePointer | pointer | store | call | seqNormal | seqExit
  | scope | arrayScope | branchTrue | branchFalse | ret | retVoid => cases shape

theorem source_loop (a : Nat → R) (p gm : ArrayPointer) (s : State) (out : Result)
    (fixed : Fixed p gm s) (u : USlot s "u" 0) (v : USlot s "v" 512)
    (input : Cells s.heap p 1536 a) (source : Exec KeygenPublicSource.program [] loop s out) :
    out.flow=.normal ∧ Cells out.state.heap p 1536 (value a) := by
  have initial : Inv a p gm 0 s := by
    refine ⟨fixed,by decide,u,v,?_⟩
    intro i hi
    simp only [image,Nat.mul_zero,Nat.not_lt_zero,ite_false]
    exact input i hi
  obtain ⟨flow,final⟩ := loop_result a p gm loop s out source rfl 0 initial
  refine ⟨flow,?_⟩
  intro i hi
  have c := final.cells i hi
  simpa only [image,show i<3*512 from by omega,ite_true] using c

end FT1536.Source3.KeygenPublicTripleFold
