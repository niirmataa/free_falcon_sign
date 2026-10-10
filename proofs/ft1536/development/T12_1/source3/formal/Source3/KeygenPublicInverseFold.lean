import Source3.KeygenPublicInverseValues

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- All512 executed inverse triples. The image is an explicit unnormalized
   linear transform of the ACTUAL input, not an assumed forward round-trip. -/
namespace FT1536.Source3.KeygenPublicInverseFold
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer)
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicAlgebra (R radix)
open KeygenPublicInputCells (Cell Cells)
open KeygenPublicInverseTables (Table rootAt)
open KeygenPublicValueExpr (Local)
open KeygenNttLoopSupport (USlot)
open KeygenPublicTableControl (frame)
open KeygenPublicInverseProgram (guard body step loop)

def unity : R := KeygenPublicRoots.unity⁻¹
def output (A B C x w : R) (k : Nat) : R :=
  if k=0 then A+(B+C)
  else if k=1 then x*(A+(B*w+C*w^2))
  else x^2*(A+(B*w^2+C*w))
def value (a : Nat → R) (i : Nat) : R := output
  (a (3*(i/3))) (a (3*(i/3)+1)) (a (3*(i/3)+2)) (rootAt (512+i/3)) unity (i%3)
def image (a : Nat → R) (n i : Nat) : R := if i<3*n then value a i else a i
theorem image_input (a : Nat → R) (j k : Nat) : image a j (3*j+k)=a (3*j+k) := by
  simp only [image,show ¬3*j+k<3*j from by omega,ite_false]
theorem image_output (a : Nat → R) (j k : Nat) (hk : k<3) : image a (j+1) (3*j+k)=
    output (a (3*j)) (a (3*j+1)) (a (3*j+2)) (rootAt (512+j)) unity k := by
  have div : (3*j+k)/3=j := by omega
  have rem : (3*j+k)%3=k := by omega
  simp only [image,show 3*j+k<3*(j+1) from by omega,ite_true,value,div,rem]
theorem image_unchanged (a : Nat → R) (j i : Nat)
    (h0 : i≠3*j) (h1 : i≠3*j+1) (h2 : i≠3*j+2) : image a j i=image a (j+1) i := by
  have same : (i<3*j) ↔ i<3*(j+1) := by omega
  simp only [image,same]

structure Fixed (p igm : ArrayPointer) (s : State) : Prop where
  width : p.elementBytes=2
  separate : p.block≠igm.block
  pointer : s.arrays "a".toList=some p
  cubic : s.arrays "igm_cubic".toList=some igm
  table : Table s.heap igm
  n : USlot s "n" 1536
  unity : Local s "w" (radix*unity)
structure Inv (a : Nat → R) (p igm : ArrayPointer) (j : Nat) (s : State) : Prop
    extends Fixed p igm s where
  counterBound : j≤512
  u : USlot s "u" (3*j)
  v : USlot s "v" (512+j)
  cells : Cells s.heap p 1536 (image a j)

theorem fixed_after (code : Stmt) (s : State) (out : Result) (p igm : ArrayPointer)
    (ok : KeygenPublicTableControl.supported code=true) (only : KeygenPublicValueFrames.onlyA code=true)
    (keep : "n".toList∉KeygenPublicTableControl.writes code ∧ "w".toList∉KeygenPublicTableControl.writes code)
    (fixed : Fixed p igm s) (source : Exec KeygenPublicSource.program [] code s out) : Fixed p igm out.state := by
  have f := frame _ [] code s out ok source
  exact ⟨fixed.width,fixed.separate,by rw [f.2.1]; exact fixed.pointer,by rw [f.2.1]; exact fixed.cubic,
    KeygenPublicInverseTables.table_after code s out p igm ok only fixed.separate fixed.pointer fixed.table source,
    (f.2.2 _ keep.1).trans fixed.n,
    KeygenPublicValueExpr.local_after code s out "w" _ ok keep.2 fixed.unity source⟩

theorem body_image (a : Nat → R) (p igm : ArrayPointer) (j : Nat) (s : State) (out : Result)
    (active : j<512) (inv : Inv a p igm j s)
    (source : Exec KeygenPublicSource.program [] body s out) : Cells out.state.heap p 1536 (image a (j+1)) := by
  have cells (k : Nat) (hk : k<3) : Cell s.heap p (3*j+k) (a (3*j+k)) := by
    have c := inv.cells (3*j+k) (by omega)
    rwa [image_input] at c
  obtain ⟨⟨c0,c1,c2⟩,h1,h2,w0,w1,w2,store0,store1,store2⟩ := KeygenPublicInverseValues.source_body
    s out p igm (3*j) (512+j) (a (3*j)) (a (3*j+1)) (a (3*j+2)) (rootAt (512+j)) unity
    (by omega) (by omega) inv.width ⟨inv.pointer,inv.cubic,inv.u,inv.v⟩
    (by simpa only [Nat.add_zero] using cells 0 (by decide)) (cells 1 (by decide)) (cells 2 (by decide))
    (inv.table.2 (512+j) (by omega) (by omega)) inv.unity source
  intro i hi
  by_cases i0 : i=3*j
  · subst i
    have eq := image_output a j 0 (by decide)
    simp only [Nat.add_zero,output,ite_true] at eq
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

theorem iteration_result (a : Nat → R) (p igm : ArrayPointer) (j : Nat) (s middle next : State)
    (active : j<512) (inv : Inv a p igm j s)
    (iteration : Exec KeygenPublicSource.program [] body s ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program [] step middle ⟨next,.normal⟩) : Inv a p igm (j+1) next := by
  have cells := body_image a p igm j s ⟨middle,.normal⟩ active inv iteration
  have fm := fixed_after body s ⟨middle,.normal⟩ p igm (by decide) (by decide) (by decide) inv.toFixed iteration
  have f := frame _ [] body s ⟨middle,.normal⟩ (by decide) iteration
  obtain ⟨u,v,heap⟩ := KeygenPublicTripleFold.increment_result middle ⟨next,.normal⟩ j active
    ((f.2.2 _ (by decide)).trans inv.u) ((f.2.2 _ (by decide)).trans inv.v) update
  refine ⟨fixed_after step middle ⟨next,.normal⟩ p igm (by decide) (by decide) (by decide) fm update,by omega,u,v,?_⟩
  rw [heap]; exact cells

theorem loop_result (a : Nat → R) (p igm : ArrayPointer) (code : Stmt) (before : State) (result : Result)
    (source : Exec KeygenPublicSource.program [] code before result) (shape : code=loop)
    (j : Nat) (inv : Inv a p igm j before) : result.flow=.normal ∧ Inv a p igm 512 result.state := by
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
      exact ih3 rfl (j+1) (iteration_result a p igm j before middle next active inv iteration update) rfl
  | loopReturn _ _ _ _ _ _ _ _ _ iteration _ =>
      cases shape
      have impossible := (frame _ _ _ _ _ (by decide) iteration).1
      cases impossible
  | skip | scalar | assign | declarePointer | pointer | store | call | seqNormal | seqExit
  | scope | arrayScope | branchTrue | branchFalse | ret | retVoid => cases shape

theorem folded (a : Nat → R) (p igm : ArrayPointer) (s : State) (inv : Inv a p igm 512 s) :
    Cells s.heap p 1536 (value a) := by
  intro i hi
  have c := inv.cells i hi
  simpa only [image,show i<3*512 from by omega,ite_true] using c

end FT1536.Source3.KeygenPublicInverseFold
