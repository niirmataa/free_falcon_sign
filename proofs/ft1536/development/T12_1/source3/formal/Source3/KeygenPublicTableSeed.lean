import Source3.KeygenPublicTableAtoms
import Source3.KeygenPublicRoots

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The actual logn10 generator prefix. The post-increment condition squares
   g once and leaves k=12; it is not a generic assumed root initializer.
   Full table stores and their enclosing memory invariants remain separate. -/
namespace FT1536.Source3.KeygenPublicTableSeed
open C99ArrayReference (State bindValue)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenPublicExec (Stmt Exec)
open KeygenPublicTableAtoms
open KeygenPublicDivisionAlgebra (multiply Scaled)

def locals : List String := ["g","ig","g2","g4","ig2","ig4","w","x","ix"]
def increment : Stmt := .scalar (.update "k".toList .add (.literal .i32 1))
def square : Stmt := .scope [] [] (.seq (.assign "g".toList (mont (var "g") (var "g"))) .skip)
def loop : Stmt := .loop (.cmp .lt (var "k") (literal 11)) (.seq increment square) .skip
def postLoop : Stmt := .seq loop increment
def steps : List Stmt := [.scalar (.declare .u64 ["u".toList]),
  .scalar (.declare .u32 ["k".toList]),.scalar (.declare .u32 (locals.map String.toList)),
  .assign "g".toList (mont (literal 25) (literal 4564)),.assign "k".toList (var "logn"),
  postLoop,.assign "ig".toList (divide (literal 4564) (var "g"))]
def prepend : List Stmt → Stmt → Stmt
  | [],tail => tail | s::ss,tail => .seq s (prepend ss tail)
def suffix : Stmt := ((KeygenPublicParser.body KeygenPublicSource.signatures (KeygenPublicSource.types .generate) 512
  (KeygenPublicScalar.expand ((KeygenZintTop.tokens
    ((KeygenPublicScalar.lines 837 48).flatMap String.toList++['}'])).getD []))).map (fun r => r.1)).getD .skip
theorem source_complete : KeygenPublicSource.code .generate=prepend steps suffix := by decide
theorem suffix_checked : KeygenPublicFrame.only KeygenPublicSource.signatures KeygenPublicSource.permissions
    (KeygenPublicSource.writable .generate) suffix=true := by decide

def declared (s : State) : State :=
  {s with locals := (C99DeclarationCells.declareCells .uint32 (locals.map String.toList)
    (C99DeclarationCells.declareCells .uint32 ["k".toList]
      (C99DeclarationCells.declareCells .uint64 ["u".toList] s.locals)))}
def convertedWord : BitVec 32 := multiply (25#32) (4564#32)
def rootWord : BitVec 32 := multiply convertedWord convertedWord
def inverseWord : BitVec 32 := KeygenPublicDivisionWords.division (4564#32) rootWord
def converted (s : State) : State := bindValue (declared s) "g".toList .uint32 (.uint32 convertedWord)
def setup (s : State) : State := bindValue (converted s) "k".toList .uint32 (.uint32 10)
def beforeSquare (s : State) : State := bindValue (setup s) "k".toList .uint32 (.uint32 11)
def squared (s : State) : State := bindValue (beforeSquare s) "g".toList .uint32 (.uint32 rootWord)
def completed (s : State) : State := bindValue (squared s) "k".toList .uint32 (.uint32 12)
def ready (s : State) : State := bindValue (completed s) "ig".toList .uint32 (.uint32 inverseWord)
theorem ready_memory (s : State) : (ready s).heap=s.heap ∧ (ready s).arrays=s.arrays ∧
    (ready s).tables=s.tables ∧ (ready s).globals=s.globals := ⟨rfl,rfl,rfl,rfl⟩
theorem converted_slot (s : State) : Slot (converted s) "g" convertedWord := slot_after _ _ _
theorem setup_slots (s : State) : Slot (setup s) "g" convertedWord ∧ Slot (setup s) "k" 10 :=
  ⟨slot_preserved _ _ _ _ _ _ (by decide) (converted_slot s),slot_after _ _ _⟩
theorem square_slots (s : State) : Slot (beforeSquare s) "g" convertedWord ∧ Slot (beforeSquare s) "k" 11 :=
  ⟨slot_preserved _ _ _ _ _ _ (by decide) (setup_slots s).1,slot_after _ _ _⟩
theorem squared_slots (s : State) : Slot (squared s) "g" rootWord ∧ Slot (squared s) "k" 11 :=
  ⟨slot_after _ _ _,slot_preserved _ _ _ _ _ _ (by decide) (square_slots s).2⟩
theorem ready_slots (s : State) : Slot (ready s) "g" rootWord ∧ Slot (ready s) "ig" inverseWord ∧ Slot (ready s) "k" 12 := by
  refine ⟨?_,slot_after _ _ _,?_⟩
  · exact slot_preserved _ _ _ _ _ _ (by decide)
      (slot_preserved _ _ _ _ _ _ (by decide) (squared_slots s).1)
  · exact slot_preserved _ _ _ _ _ _ (by decide) (slot_after _ _ _)

theorem take_step (a tail : Stmt) (s next : State) (out : Result)
    (result : ∀ r, Exec KeygenPublicSource.program [] a s r → r=⟨next,.normal⟩)
    (source : Exec KeygenPublicSource.program [] (.seq a tail) s out) :
    Exec KeygenPublicSource.program [] tail next out := by
  cases source with
  | seqNormal _ _ _ middle _ first rest =>
      have equal := congrArg Result.state (result ⟨middle,.normal⟩ first)
      dsimp only at equal
      subst middle
      exact rest
  | seqExit _ _ _ _ first exit =>
      have equal := congrArg Result.flow (result out first)
      exact (exit equal).elim

theorem square_result (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program [] square (beforeSquare s) out) : out=⟨squared s,.normal⟩ := by
  cases source with
  | scope _ _ _ _ inner executed =>
      have first := take_step _ .skip (beforeSquare s) (squared s) inner (fun r hr =>
        assign_result _ _ _ "g" _ rootWord r ⟨some (.uint32 convertedWord),(square_slots s).1⟩
          (fun v hv => mont_value [] _ _ _ convertedWord convertedWord v
            (fun z hz => variable_argument [] _ "g" convertedWord z (square_slots s).1 hz)
            (fun z hz => variable_argument [] _ "g" convertedWord z (square_slots s).1 hz) hv) hr) executed
      cases first
      rfl
theorem loop_false (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program [] loop (squared s) out) : out=⟨squared s,.normal⟩ := by
  cases source with
  | loopFalse _ _ _ _ v guard zero => rfl
  | loopNormal _ _ _ _ _ _ _ v guard nonzero _ _ _ =>
      rw [guard_value [] _ 11 v (squared_slots s).2 guard] at nonzero
      exact (nonzero (by decide)).elim
  | loopReturn _ _ _ _ _ v _ guard nonzero _ =>
      rw [guard_value [] _ 11 v (squared_slots s).2 guard] at nonzero
      exact (nonzero (by decide)).elim
theorem loop_result (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program [] loop (setup s) out) : out=⟨squared s,.normal⟩ := by
  cases source with
  | loopFalse _ _ _ _ v guard zero =>
      rw [guard_value [] _ 10 v (setup_slots s).2 guard] at zero
      cases zero
  | loopNormal _ _ _ _ middle next _ v guard nonzero iteration update rest =>
      have executedSquare := take_step increment square (setup s) (beforeSquare s) ⟨middle,.normal⟩
        (fun r hr => increment_result _ _ _ 10 r (setup_slots s).2 hr) iteration
      have middleEqual := congrArg Result.state (square_result s ⟨middle,.normal⟩ executedSquare)
      dsimp only at middleEqual
      subst middle
      cases update
      exact loop_false s out rest
  | loopReturn _ _ _ _ _ v ret guard nonzero iteration =>
      have executedSquare := take_step increment square (setup s) (beforeSquare s) _
        (fun r hr => increment_result _ _ _ 10 r (setup_slots s).2 hr) iteration
      have impossible := congrArg Result.flow (square_result s _ executedSquare)
      cases impossible
theorem post_result (s : State) (out : Result)
    (source : Exec KeygenPublicSource.program [] postLoop (setup s) out) : out=⟨completed s,.normal⟩ := by
  have last := take_step loop increment (setup s) (squared s) out (loop_result s) source
  exact increment_result _ _ _ 11 out (squared_slots s).2 last

theorem source_prefix (s : State) (out : Result) (profile : Slot s "logn" 10)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicSource.code .generate) s out) :
    Exec KeygenPublicSource.program [] suffix (ready s) out := by
  rw [source_complete] at source
  let d0 : State := {s with locals := C99DeclarationCells.declareCells .uint64 ["u".toList] s.locals}
  let d1 : State := {d0 with locals := C99DeclarationCells.declareCells .uint32 ["k".toList] d0.locals}
  have rest0 := take_step _ _ s d0 out (fun r hr => declaration_result _ _ _ .u64 _ r hr) source
  have rest1 := take_step _ _ d0 d1 out (fun r hr => declaration_result _ _ _ .u32 _ r hr) rest0
  have rest2 := take_step _ _ d1 (declared s) out (fun r hr => declaration_result _ _ _ .u32 _ r hr) rest1
  have gd : (declared s).locals "g".toList=some (.uint32,none) := by
    simp [declared,locals,C99DeclarationCells.declareCells,C99ScalarReference.set]
  have rest3 := take_step _ _ (declared s) (converted s) out (fun r hr =>
    assign_result _ _ _ "g" _ convertedWord r ⟨none,gd⟩
      (fun v hv => mont_value [] _ _ _ 25 4564 v (literal_argument [] _ 25)
        (literal_argument [] _ 4564) hv) hr) rest2
  have kd : (converted s).locals "k".toList=some (.uint32,none) := by
    simp [converted,declared,locals,bindValue,C99DeclarationCells.declareCells,C99ScalarReference.set]
  have logn : Slot (converted s) "logn" 10 := by
    simpa [Slot,converted,declared,locals,bindValue,C99DeclarationCells.declareCells,C99ScalarReference.set] using profile
  have rest4 := take_step _ _ (converted s) (setup s) out (fun r hr =>
    assign_result _ _ _ "k" _ 10 r ⟨none,kd⟩ (fun v hv => variable_value [] _ "logn" 10 v logn hv) hr) rest3
  have rest5 := take_step _ _ (setup s) (completed s) out (post_result s) rest4
  have id : (completed s).locals "ig".toList=some (.uint32,none) := by
    simp [completed,squared,beforeSquare,setup,converted,declared,locals,bindValue,
      C99DeclarationCells.declareCells,C99ScalarReference.set]
  have gslot : Slot (completed s) "g" rootWord :=
    slot_preserved _ _ _ _ _ _ (by decide) (squared_slots s).1
  exact take_step _ _ (completed s) (ready s) out (fun r hr =>
    assign_result _ _ _ "ig" _ inverseWord r ⟨none,id⟩
      (fun v hv => divide_value [] _ _ _ 4564 rootWord v (literal_argument [] _ 4564)
        (fun z hz => variable_argument [] _ "g" rootWord z gslot hz) hv) hr) rest5

theorem root_scaled : Scaled rootWord KeygenPublicRoots.root := by
  have converted := KeygenPublicDivisionAlgebra.conversion (25#32)
    (by change 25<18433; decide : KeygenPublicAlgebra.Canonical (25#32))
  change Scaled convertedWord (25 : KeygenPublicAlgebra.R) at converted
  exact KeygenPublicDivisionAlgebra.scaled_square _ _ converted
theorem root_nonzero : rootWord.toNat≠0 := by
  have nonzero : KeygenPublicRoots.root≠0 := by
    intro zero
    have order := KeygenPublicRoots.root_order
    rw [zero,orderOf_zero] at order
    norm_num at order
  intro zero
  have valueZero : KeygenPublicAlgebra.value rootWord=0 := by simp [KeygenPublicAlgebra.value,zero]
  have equal := root_scaled.2
  rw [valueZero] at equal
  have radixNonzero : KeygenPublicAlgebra.radix≠0 := by
    intro zero
    have impossible := KeygenPublicAlgebra.radix_inverse
    rw [zero,zero_mul] at impossible
    exact zero_ne_one impossible
  exact nonzero ((mul_eq_zero.mp equal.symm).resolve_left radixNonzero)
theorem inverse_scaled : Scaled inverseWord (KeygenPublicRoots.root)⁻¹ := by
  have power := KeygenPublicDivisionAlgebra.division_power (4564#32) rootWord
    (by change 4564<18433; decide) root_scaled.1
  change KeygenPublicAlgebra.Canonical inverseWord ∧ KeygenPublicAlgebra.value inverseWord=
    KeygenPublicAlgebra.value (4564#32)*KeygenPublicAlgebra.value rootWord^18431 at power
  have fermat := ZMod.pow_card_sub_one_eq_one
    (KeygenPublicDivisionAlgebra.nonzero_value rootWord root_scaled.1 root_nonzero)
  have division : KeygenPublicAlgebra.value inverseWord=KeygenPublicAlgebra.value (4564#32)*
      (KeygenPublicAlgebra.value rootWord)⁻¹ := by
    have product : KeygenPublicAlgebra.value inverseWord*KeygenPublicAlgebra.value rootWord=KeygenPublicAlgebra.value (4564#32) := by
      rw [power.2,mul_assoc,← pow_succ,fermat,mul_one]
    calc
      _ = (KeygenPublicAlgebra.value inverseWord*KeygenPublicAlgebra.value rootWord)*
          (KeygenPublicAlgebra.value rootWord)⁻¹ := by
        rw [mul_assoc,mul_inv_cancel₀ (KeygenPublicDivisionAlgebra.nonzero_value rootWord root_scaled.1 root_nonzero),mul_one]
      _ = _ := by rw [product]
  refine ⟨power.1,?_⟩
  rw [division,KeygenPublicAlgebra.radix_squared_word,root_scaled.2,mul_inv_rev]
  calc
    _ = (KeygenPublicAlgebra.radix*KeygenPublicRoots.root⁻¹)*
        (KeygenPublicAlgebra.radix*KeygenPublicAlgebra.radix⁻¹) := by ring
    _ = _ := by rw [KeygenPublicAlgebra.radix_inverse,mul_one]

end FT1536.Source3.KeygenPublicTableSeed
