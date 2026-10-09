import Source3.KeygenPublicTableSeed

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Extract the real last-row entry from the same complete generator call.
   Both directions' x/g2/g4 seeds are derived; table images are not premises.
   The following store loops remain source executions to be refined. -/
namespace FT1536.Source3.KeygenPublicTableRows
open C99ArrayReference (State bindValue)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenPublicExec (Stmt Exec)
open KeygenPublicTableAtoms
open KeygenPublicTableSeed (rootWord inverseWord prepend take_step)
open KeygenPublicDivisionAlgebra (multiply Scaled)

def noReturn : Stmt → Bool
  | .ret _ => false
  | .seq a b | .branch _ a b | .loop _ a b => noReturn a && noReturn b
  | .scope _ _ b | .arrayScope _ _ b => noReturn b
  | _ => true
theorem normal (program : KeygenPublicExec.Program) (signed : List C99ArrayReference.Name)
    (code : Stmt) (s : State) (out : Result) (source : Exec program signed code s out)
    (checked : noReturn code=true) : out.flow=.normal := by
  induction source with
  | skip | scalar | assign | declarePointer | pointer | store | call | loopFalse => rfl
  | seqNormal _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | seqExit _ _ _ _ _ exit ih => exact (exit (ih (Bool.and_eq_true_iff.mp checked).1)).elim
  | scope _ _ _ _ _ _ ih => exact ih checked
  | arrayScope _ _ _ _ _ _ _ _ _ _ ih => exact ih checked
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ ih => exact ih checked
  | loopReturn _ _ _ _ _ _ _ _ _ _ ih =>
      have impossible := ih (Bool.and_eq_true_iff.mp checked).1
      cases impossible
  | ret | retVoid => cases checked

def fragment (start count : Nat) : Stmt := ((KeygenPublicParser.body KeygenPublicSource.signatures
  (KeygenPublicSource.types .generate) 512 (KeygenPublicScalar.expand ((KeygenZintTop.tokens
    ((KeygenPublicScalar.lines start count).flatMap String.toList++['}'])).getD []))).map (fun r => r.1)).getD .skip
def two : BitVec 32 := multiply rootWord rootWord
def four : BitVec 32 := multiply two two
def inverseTwo : BitVec 32 := multiply inverseWord inverseWord
def inverseFour : BitVec 32 := multiply inverseTwo inverseTwo
def rowSteps : List Stmt := [.scalar (.declare .u64 ["b".toList]),
  .assign "x".toList (var "g"),.assign "ix".toList (var "ig"),
  .assign "g2".toList (mont (var "g") (var "g")),
  .assign "g4".toList (mont (var "g2") (var "g2")),
  .assign "ig2".toList (mont (var "ig") (var "ig")),
  .assign "ig4".toList (mont (var "ig2") (var "ig2"))]
def remaining : Stmt := fragment 849 12
def body : Stmt := prepend rowSteps remaining
def lastRow : Stmt := .scope ["b".toList] [] body
def simpleRow : Stmt := .scope [] [] (KeygenPublicExec.chain [
  .store "gm".toList (.literal .i32 1) true (var "g"),
  .store "igm".toList (.literal .i32 1) true (var "ig")])
def afterRows : Stmt := fragment 863 22
def dispatch : Stmt := .branch (.cmp .eq (var "logn") (literal 1)) simpleRow lastRow
theorem source_dispatch : KeygenPublicTableSeed.suffix=.seq dispatch afterRows := by decide
theorem dispatch_normal : noReturn dispatch=true := by decide
theorem full_normal : noReturn (KeygenPublicSource.code .generate)=true := by decide

def bDeclared (s : State) : State := {s with locals := C99DeclarationCells.declareCells .uint64 ["b".toList] s.locals}
def xReady (s : State) : State := bindValue (bDeclared s) "x".toList .uint32 (.uint32 rootWord)
def ixReady (s : State) : State := bindValue (xReady s) "ix".toList .uint32 (.uint32 inverseWord)
def twoReady (s : State) : State := bindValue (ixReady s) "g2".toList .uint32 (.uint32 two)
def fourReady (s : State) : State := bindValue (twoReady s) "g4".toList .uint32 (.uint32 four)
def inverseTwoReady (s : State) : State := bindValue (fourReady s) "ig2".toList .uint32 (.uint32 inverseTwo)
def ready (s : State) : State := bindValue (inverseTwoReady s) "ig4".toList .uint32 (.uint32 inverseFour)
def Owned (s : State) : Prop := Slot s "g" rootWord ∧ Slot s "ig" inverseWord ∧
  ∀ n∈["x","ix","g2","g4","ig2","ig4"], s.locals n.toList=some (.uint32,none)
theorem declaration_preserves (names : List C99ArrayReference.Name) (ty : C99IntegerReference.Ty)
    (env : C99ScalarReference.Env) (name : C99ArrayReference.Name) (slot : env name=some (ty,none)) :
    C99DeclarationCells.declareCells ty names env name=some (ty,none) := by
  induction names generalizing env with
  | nil => exact slot
  | cons n ns ih =>
      apply ih
      by_cases same : name=n
      · simp [C99ScalarReference.set,same]
      · simpa only [C99ScalarReference.set,same,ite_false] using slot
theorem declaration_member (names : List C99ArrayReference.Name) (ty : C99IntegerReference.Ty)
    (env : C99ScalarReference.Env) (name : C99ArrayReference.Name) (member : name∈names) :
    C99DeclarationCells.declareCells ty names env name=some (ty,none) := by
  induction names generalizing env with
  | nil => cases member
  | cons n ns ih =>
      rcases List.mem_cons.mp member with rfl | rest
      · exact declaration_preserves ns ty (C99ScalarReference.set env name (ty,none)) name
          (by simp [C99ScalarReference.set])
      · exact ih _ rest
theorem initial_declared (s : State) (n : String) (member : n∈KeygenPublicTableSeed.locals) :
    (KeygenPublicTableSeed.declared s).locals n.toList=some (.uint32,none) :=
  declaration_member _ _ _ _ (List.mem_map.mpr ⟨n,member,rfl⟩)
theorem ready_uninitialized (s : State) (n : String) (ng : n≠"g") (nk : n≠"k") (ni : n≠"ig")
    (member : n∈KeygenPublicTableSeed.locals) : (KeygenPublicTableSeed.ready s).locals n.toList=some (.uint32,none) := by
  rw [KeygenPublicTableSeed.ready,KeygenPublicTableSeed.unchanged_cell _ n "ig" _ _ ni,
    KeygenPublicTableSeed.completed,KeygenPublicTableSeed.unchanged_cell _ n "k" _ _ nk,
    KeygenPublicTableSeed.squared,KeygenPublicTableSeed.unchanged_cell _ n "g" _ _ ng,
    KeygenPublicTableSeed.beforeSquare,KeygenPublicTableSeed.unchanged_cell _ n "k" _ _ nk,
    KeygenPublicTableSeed.setup,KeygenPublicTableSeed.unchanged_cell _ n "k" _ _ nk,
    KeygenPublicTableSeed.converted,KeygenPublicTableSeed.unchanged_cell _ n "g" _ _ ng]
  exact initial_declared s n member
theorem initial_owned (s : State) : Owned (KeygenPublicTableSeed.ready s) := by
  refine ⟨(KeygenPublicTableSeed.ready_slots s).1,(KeygenPublicTableSeed.ready_slots s).2.1,?_⟩
  intro n hn
  have facts : n∈KeygenPublicTableSeed.locals ∧ n≠"g" ∧ n≠"k" ∧ n≠"ig" := by
    simp only [List.mem_cons,List.not_mem_nil,or_false] at hn
    rcases hn with rfl | rfl | rfl | rfl | rfl | rfl <;> decide
  exact ready_uninitialized s n facts.2.1 facts.2.2.1 facts.2.2.2 facts.1
theorem ready_x (s : State) : Slot (ready s) "x" rootWord :=
  slot_preserved _ _ _ _ _ _ (by decide) (slot_preserved _ _ _ _ _ _ (by decide)
    (slot_preserved _ _ _ _ _ _ (by decide) (slot_preserved _ _ _ _ _ _ (by decide)
      (slot_preserved _ _ _ _ _ _ (by decide) (slot_after _ _ _)))))
theorem ready_ix (s : State) : Slot (ready s) "ix" inverseWord :=
  slot_preserved _ _ _ _ _ _ (by decide) (slot_preserved _ _ _ _ _ _ (by decide)
    (slot_preserved _ _ _ _ _ _ (by decide) (slot_preserved _ _ _ _ _ _ (by decide) (slot_after _ _ _))))
theorem ready_two (s : State) : Slot (ready s) "g2" two :=
  slot_preserved _ _ _ _ _ _ (by decide) (slot_preserved _ _ _ _ _ _ (by decide)
    (slot_preserved _ _ _ _ _ _ (by decide) (slot_after _ _ _)))
theorem ready_four (s : State) : Slot (ready s) "g4" four :=
  slot_preserved _ _ _ _ _ _ (by decide) (slot_preserved _ _ _ _ _ _ (by decide) (slot_after _ _ _))
theorem ready_inverse_two (s : State) : Slot (ready s) "ig2" inverseTwo :=
  slot_preserved _ _ _ _ _ _ (by decide) (slot_after _ _ _)
theorem ready_inverse_four (s : State) : Slot (ready s) "ig4" inverseFour := slot_after _ _ _
theorem slots (s : State) : Slot (ready s) "x" rootWord ∧ Slot (ready s) "ix" inverseWord ∧
    Slot (ready s) "g2" two ∧ Slot (ready s) "g4" four ∧
    Slot (ready s) "ig2" inverseTwo ∧ Slot (ready s) "ig4" inverseFour :=
  ⟨ready_x s,ready_ix s,ready_two s,ready_four s,ready_inverse_two s,ready_inverse_four s⟩
theorem b_preserves (s : State) (n : String) (different : n≠"b") :
    (bDeclared s).locals n.toList=s.locals n.toList := by
  simp only [bDeclared,C99DeclarationCells.declareCells,C99ScalarReference.set,
    show n.toList≠"b".toList from fun equal => different (String.toList_injective equal),ite_false]
theorem declared_x (s : State) (owned : Owned s) : (bDeclared s).locals "x".toList=some (.uint32,none) := by
  rw [b_preserves _ "x" (by decide)]
  exact owned.2.2 "x" (by simp)
theorem declared_ix (s : State) (owned : Owned s) : (xReady s).locals "ix".toList=some (.uint32,none) := by
  rw [xReady,KeygenPublicTableSeed.unchanged_cell _ "ix" "x" _ _ (by decide),b_preserves _ "ix" (by decide)]
  exact owned.2.2 "ix" (by simp)
theorem declared_two (s : State) (owned : Owned s) : (ixReady s).locals "g2".toList=some (.uint32,none) := by
  rw [ixReady,KeygenPublicTableSeed.unchanged_cell _ "g2" "ix" _ _ (by decide),
    xReady,KeygenPublicTableSeed.unchanged_cell _ "g2" "x" _ _ (by decide),b_preserves _ "g2" (by decide)]
  exact owned.2.2 "g2" (by simp)
theorem declared_four (s : State) (owned : Owned s) : (twoReady s).locals "g4".toList=some (.uint32,none) := by
  rw [twoReady,KeygenPublicTableSeed.unchanged_cell _ "g4" "g2" _ _ (by decide),
    ixReady,KeygenPublicTableSeed.unchanged_cell _ "g4" "ix" _ _ (by decide),
    xReady,KeygenPublicTableSeed.unchanged_cell _ "g4" "x" _ _ (by decide),b_preserves _ "g4" (by decide)]
  exact owned.2.2 "g4" (by simp)
theorem declared_inverse_two (s : State) (owned : Owned s) : (fourReady s).locals "ig2".toList=some (.uint32,none) := by
  rw [fourReady,KeygenPublicTableSeed.unchanged_cell _ "ig2" "g4" _ _ (by decide),
    twoReady,KeygenPublicTableSeed.unchanged_cell _ "ig2" "g2" _ _ (by decide),
    ixReady,KeygenPublicTableSeed.unchanged_cell _ "ig2" "ix" _ _ (by decide),
    xReady,KeygenPublicTableSeed.unchanged_cell _ "ig2" "x" _ _ (by decide),b_preserves _ "ig2" (by decide)]
  exact owned.2.2 "ig2" (by simp)
theorem declared_inverse_four (s : State) (owned : Owned s) : (inverseTwoReady s).locals "ig4".toList=some (.uint32,none) := by
  rw [inverseTwoReady,KeygenPublicTableSeed.unchanged_cell _ "ig4" "ig2" _ _ (by decide),
    fourReady,KeygenPublicTableSeed.unchanged_cell _ "ig4" "g4" _ _ (by decide),
    twoReady,KeygenPublicTableSeed.unchanged_cell _ "ig4" "g2" _ _ (by decide),
    ixReady,KeygenPublicTableSeed.unchanged_cell _ "ig4" "ix" _ _ (by decide),
    xReady,KeygenPublicTableSeed.unchanged_cell _ "ig4" "x" _ _ (by decide),b_preserves _ "ig4" (by decide)]
  exact owned.2.2 "ig4" (by simp)
theorem row_prefix (s : State) (out : Result) (owned : Owned s)
    (source : Exec KeygenPublicSource.program [] body s out) :
    Exec KeygenPublicSource.program [] remaining (ready s) out := by
  have rest0 := take_step _ _ s (bDeclared s) out (fun r hr => declaration_result _ _ _ .u64 _ r hr) source
  have g : Slot (bDeclared s) "g" rootWord := by
    simpa [Slot,bDeclared,C99DeclarationCells.declareCells,C99ScalarReference.set] using owned.1
  have ig : Slot (bDeclared s) "ig" inverseWord := by
    simpa [Slot,bDeclared,C99DeclarationCells.declareCells,C99ScalarReference.set] using owned.2.1
  have rest1 := take_step _ _ (bDeclared s) (xReady s) out (fun r hr => assign_result _ _ _ "x" _ rootWord r
    ⟨none,declared_x s owned⟩ (fun v hv => variable_value [] _ "g" rootWord v g hv) hr) rest0
  have igx : Slot (xReady s) "ig" inverseWord := slot_preserved _ _ _ _ _ _ (by decide) ig
  have rest2 := take_step _ _ (xReady s) (ixReady s) out (fun r hr => assign_result _ _ _ "ix" _ inverseWord r
    ⟨none,declared_ix s owned⟩ (fun v hv => variable_value [] _ "ig" inverseWord v igx hv) hr) rest1
  have gi : Slot (ixReady s) "g" rootWord :=
    slot_preserved _ _ _ _ _ _ (by decide) (slot_preserved _ _ _ _ _ _ (by decide) g)
  have rest3 := take_step _ _ (ixReady s) (twoReady s) out (fun r hr => assign_result _ _ _ "g2" _ two r
    ⟨none,declared_two s owned⟩ (fun v hv => mont_value [] _ _ _ rootWord rootWord v
      (fun z hz => variable_argument [] _ "g" rootWord z gi hz)
      (fun z hz => variable_argument [] _ "g" rootWord z gi hz) hv) hr) rest2
  have rest4 := take_step _ _ (twoReady s) (fourReady s) out (fun r hr => assign_result _ _ _ "g4" _ four r
    ⟨none,declared_four s owned⟩ (fun v hv => mont_value [] _ _ _ two two v
      (fun z hz => variable_argument [] _ "g2" two z (slot_after _ _ _) hz)
      (fun z hz => variable_argument [] _ "g2" two z (slot_after _ _ _) hz) hv) hr) rest3
  have igf : Slot (fourReady s) "ig" inverseWord :=
    slot_preserved _ _ _ _ _ _ (by decide) (slot_preserved _ _ _ _ _ _ (by decide)
      (slot_preserved _ _ _ _ _ _ (by decide) igx))
  have rest5 := take_step _ _ (fourReady s) (inverseTwoReady s) out (fun r hr => assign_result _ _ _ "ig2" _ inverseTwo r
    ⟨none,declared_inverse_two s owned⟩ (fun v hv => mont_value [] _ _ _ inverseWord inverseWord v
      (fun z hz => variable_argument [] _ "ig" inverseWord z igf hz)
      (fun z hz => variable_argument [] _ "ig" inverseWord z igf hz) hv) hr) rest4
  exact take_step _ _ (inverseTwoReady s) (ready s) out (fun r hr => assign_result _ _ _ "ig4" _ inverseFour r
    ⟨none,declared_inverse_four s owned⟩ (fun v hv => mont_value [] _ _ _ inverseTwo inverseTwo v
      (fun z hz => variable_argument [] _ "ig2" inverseTwo z (slot_after _ _ _) hz)
      (fun z hz => variable_argument [] _ "ig2" inverseTwo z (slot_after _ _ _) hz) hv) hr) rest5

theorem dispatch_false (s : State) (v : Value) (profile : Slot s "logn" 10)
    (source : KeygenPublicWord.Eval [] s (.cmp .eq (var "logn") (literal 1)) v) : v.integer=0 := by
  cases source with
  | cmp _ _ _ a b _ first second comparison =>
      have ae := variable_value [] s "logn" 10 a profile first
      have be := literal_value [] s 1 b second
      subst a; subst b
      have equal := C99CountedWords.comparison_result _ _ _ v comparison
      change v=C99ScalarReference.boolean false at equal
      rw [equal]
      rfl
theorem scope_result (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program [] lastRow s out) :
    ∃ inner, Exec KeygenPublicSource.program [] body s inner ∧
      out=⟨C99ArrayReference.restoreScope s inner.state ["b".toList] [],inner.flow⟩ := by
  cases source
  exact ⟨_,‹_›,rfl⟩
theorem seed_profile (s : State) (profile : Slot s "logn" 10) : Slot (KeygenPublicTableSeed.ready s) "logn" 10 := by
  rw [Slot,KeygenPublicTableSeed.ready,KeygenPublicTableSeed.unchanged_cell _ "logn" "ig" _ _ (by decide),
    KeygenPublicTableSeed.completed,KeygenPublicTableSeed.unchanged_cell _ "logn" "k" _ _ (by decide),
    KeygenPublicTableSeed.squared,KeygenPublicTableSeed.unchanged_cell _ "logn" "g" _ _ (by decide),
    KeygenPublicTableSeed.beforeSquare,KeygenPublicTableSeed.unchanged_cell _ "logn" "k" _ _ (by decide),
    KeygenPublicTableSeed.setup,KeygenPublicTableSeed.unchanged_cell _ "logn" "k" _ _ (by decide)]
  exact KeygenPublicTableSeed.converted_profile s profile
theorem source_last_row_entry (s : State) (out : Result) (profile : Slot s "logn" 10)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .generate) s out) :
    ∃ after inner,
      Exec KeygenPublicSource.program [] remaining (ready (KeygenPublicTableSeed.ready s)) inner ∧
      after=C99ArrayReference.restoreScope (KeygenPublicTableSeed.ready s) inner.state ["b".toList] [] ∧
      inner.flow=.normal ∧ Exec KeygenPublicSource.program [] afterRows after out := by
  have rest := KeygenPublicTableSeed.source_prefix s out profile source
  rw [source_dispatch] at rest
  have profileReady := seed_profile s profile
  cases rest with
  | seqNormal _ _ _ after _ first tail =>
      cases first with
      | branchTrue _ _ _ _ _ v guard nonzero _ => exact (nonzero (dispatch_false _ v profileReady guard)).elim
      | branchFalse _ _ _ _ _ v guard zero selected =>
          obtain ⟨inner,executed,result⟩ := scope_result _ ⟨after,.normal⟩ selected
          have afterEqual := congrArg Result.state result
          refine ⟨after,inner,row_prefix _ inner (initial_owned s) executed,afterEqual,?_,tail⟩
          exact normal _ _ body _ inner executed (by decide)
  | seqExit _ _ _ _ first exit => exact (exit (normal _ _ dispatch _ out first dispatch_normal)).elim

theorem scaled_seeds : Scaled two (KeygenPublicRoots.root^2) ∧ Scaled four (KeygenPublicRoots.root^4) ∧
    Scaled inverseTwo ((KeygenPublicRoots.root⁻¹)^2) ∧ Scaled inverseFour ((KeygenPublicRoots.root⁻¹)^4) := by
  have h2 := KeygenPublicDivisionAlgebra.scaled_square _ _ KeygenPublicTableSeed.root_scaled
  have hi2 := KeygenPublicDivisionAlgebra.scaled_square _ _ KeygenPublicTableSeed.inverse_scaled
  refine ⟨h2,?_,hi2,?_⟩
  · simpa only [four,two,← pow_mul,show (2 : Nat)*2=4 from rfl] using KeygenPublicDivisionAlgebra.scaled_square _ _ h2
  · simpa only [inverseFour,inverseTwo,← pow_mul,show (2 : Nat)*2=4 from rfl] using KeygenPublicDivisionAlgebra.scaled_square _ _ hi2

end FT1536.Source3.KeygenPublicTableRows
