import Source3.KeygenPublicLastBody

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicLastLoop
open C99ArrayReference (State bindValue)
open C99ProcedureReference (Result)
open C99MemoryReference (ArrayPointer Memory)
open KeygenPublicExec (Exec)
open KeygenPublicLastProgram (condition increment loop body)
open KeygenPublicTableControl (supported writes)
open KeygenPublicTableStore (Word Separate)
open KeygenPublicLastBody (Fixed PairImages fixed_after)
open KeygenPublicTableCells (Cell)
open KeygenNttLoopSupport (USlot u64)
open KeygenPublicRoots (root)
open KeygenMkgm3Rows (exponent)
open KeygenMkgm3Indices (lastIndex)

def Processed (gm igm : ArrayPointer) (j : Nat) (heap : Memory) : Prop :=
  ∀ i<2*j, Cell heap gm (lastIndex i) (root^exponent i) ∧ Cell heap igm (lastIndex i) ((root⁻¹)^exponent i)
def LowerFrame (gm igm : ArrayPointer) (before after : Memory) : Prop :=
  ∀ p∈[gm,igm], ∀ i<512, ∀ z, Cell before p i z → Cell after p i z
structure Invariant (gm igm : ArrayPointer) (initial : Memory) (j : Nat) (s : State) : Prop where
  bound : j≤256
  fixed : Fixed gm igm s
  counter : USlot s "u" (2*j)
  x : Word s "x" (root^exponent (2*j))
  ix : Word s "ix" ((root⁻¹)^exponent (2*j))
  cells : Processed gm igm j s.heap
  lower : LowerFrame gm igm initial s.heap
  bytes : KeygenPublicTableStore.LastFrame gm igm initial s.heap

theorem guard (s : State) (j : Nat) (hj : j≤256) (v : C99IntegerReference.Value)
    (u : USlot s "u" (2*j)) (b : USlot s "b" 512)
    (source : KeygenPublicWord.Eval [] s condition v) :
    v=C99ScalarReference.boolean (decide (j<256)) := by
  cases source with
  | cmp _ _ _ a c _ first second op =>
      have av := KeygenPublicTableIndex.word64 s "u" (2*j) a u first
      have cv := KeygenPublicTableIndex.word64 s "b" 512 c b second
      subst a; subst c
      have equal := C99CountedWords.comparison_result _ _ _ v op
      change v=C99ScalarReference.boolean (C99IntegerReference.compare .lt
        (C99IntegerReference.convert .uint64 (u64 (2*j)).integer).integer
        (C99IntegerReference.convert .uint64 (u64 512).integer).integer) at equal
      rw [KeygenNttLoopSupport.convert_u64_self (2*j) (by omega),
        KeygenNttLoopSupport.convert_u64_self 512 (by decide),
        KeygenNttLoopSupport.u64_integer (2*j) (by omega),
        KeygenNttLoopSupport.u64_integer 512 (by decide)] at equal
      have comparison : (((2*j : Nat) : Int)<((512 : Nat) : Int)) ↔ j<256 := by omega
      simpa only [C99IntegerReference.compare,comparison] using equal
theorem increment_result (s : State) (out : Result) (j : Nat) (hj : j<256)
    (u : USlot s "u" (2*j)) (source : Exec KeygenPublicSource.program [] increment s out) :
    out=⟨bindValue s "u".toList .uint64 (u64 (2*(j+1))),.normal⟩ := by
  cases source with
  | assign _ _ _ ty old v declared evaluated =>
      have te := congrArg Prod.fst (Option.some.inj (declared.symm.trans u))
      dsimp only at te
      subst ty
      cases evaluated with
      | bin _ _ _ a b _ left right op =>
          have av := KeygenPublicTableIndex.word64 s "u" (2*j) a u left
          have bv := KeygenPublicTableAtoms.literal_value [] s 2 b right
          subst a; subst b
          have equal := KeygenPublicTableIndex.plus_literal (2*j) 2 (by omega) (by decide) v op
          rw [show 2*j+2=2*(j+1) by omega] at equal
          rw [equal]
theorem increment_counter (s : State) (j : Nat) (hj : j<256) :
    USlot (bindValue s "u".toList .uint64 (u64 (2*(j+1)))) "u" (2*(j+1)) := by
  simp only [USlot,bindValue,C99ScalarReference.set,ite_true,
    KeygenNttLoopSupport.convert_u64_self (2*(j+1)) (by omega)]

theorem processed_step (gm igm : ArrayPointer) (j : Nat) (hj : j<256) (before after : Memory)
    (old : Processed gm igm j before) (update : PairImages gm igm (2*j) before after) :
    Processed gm igm (j+1) after := by
  intro i hi
  by_cases earlier : i<2*j
  · have ne (k : Nat) (hk : k<512) (different : k≠i) : lastIndex k≠lastIndex i := by
      intro equal
      exact different (KeygenMkgm3Table.last_injective k i hk (by omega) equal)
    have n0 := ne (2*j) (by omega) (by omega)
    have n1 := ne (2*j+1) (by omega) (by omega)
    have bound := (KeygenMkgm3Table.last_range i (by omega)).2
    exact ⟨update.1 gm (by simp) _ bound n0 n1 _ (old i earlier).1,
      update.1 igm (by simp) _ bound n0 n1 _ (old i earlier).2⟩
  · have choices : i=2*j ∨ i=2*j+1 := by omega
    rcases choices with rfl | rfl
    · exact ⟨update.2.1,update.2.2.1⟩
    · exact ⟨update.2.2.2.1,update.2.2.2.2⟩
theorem lower_step (gm igm : ArrayPointer) (j : Nat) (hj : j<256) (initial before after : Memory)
    (old : LowerFrame gm igm initial before) (update : PairImages gm igm (2*j) before after) :
    LowerFrame gm igm initial after := by
  intro p hp i hi z cell
  have h0 := (KeygenMkgm3Table.last_range (2*j) (by omega)).1
  have h1 := (KeygenMkgm3Table.last_range (2*j+1) (by omega)).1
  exact update.1 p hp i (by omega) (by omega) (by omega) z (old p hp i hi z cell)

theorem body_invariant (s : State) (out : Result) (gm igm : ArrayPointer) (initial : Memory)
    (j : Nat) (hj : j<256) (inv : Invariant gm igm initial j s)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (source : Exec KeygenPublicSource.program [] (.scope [] [] body) s out) :
    Fixed gm igm out.state ∧ USlot out.state "u" (2*j) ∧
      Word out.state "x" (root^exponent (2*(j+1))) ∧ Word out.state "ix" ((root⁻¹)^exponent (2*(j+1))) ∧
      Processed gm igm (j+1) out.state.heap ∧ LowerFrame gm igm initial out.state.heap ∧
      KeygenPublicTableStore.LastFrame gm igm initial out.state.heap := by
  cases source with
  | scope _ _ _ _ inner execution =>
      obtain ⟨x,ix,update,bytes⟩ := KeygenPublicLastBody.body_result s inner gm igm j hj inv.fixed inv.counter
        gw iw separate inv.x inv.ix execution
      have fixed := fixed_after body s inner gm igm inv.fixed KeygenPublicLastProgram.body_supported
        (by rw [KeygenPublicLastProgram.body_writes]; simp) execution
      have u := KeygenPublicLastBody.counter_after body s inner (2*j) inv.counter KeygenPublicLastProgram.body_supported
        (by rw [KeygenPublicLastProgram.body_writes]; decide) execution
      exact ⟨fixed,u,x,ix,processed_step gm igm j hj s.heap inner.state.heap inv.cells update,
        lower_step gm igm j hj initial s.heap inner.state.heap inv.lower update,
        KeygenPublicTableStore.frame_trans gm igm _ _ _ inv.bytes bytes⟩
theorem step (s middle next : State) (gm igm : ArrayPointer) (initial : Memory)
    (j : Nat) (hj : j<256) (inv : Invariant gm igm initial j s)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (bodyExec : Exec KeygenPublicSource.program [] (.scope [] [] body) s ⟨middle,.normal⟩)
    (update : Exec KeygenPublicSource.program [] increment middle ⟨next,.normal⟩) :
    Invariant gm igm initial (j+1) next := by
  obtain ⟨fixed,u,x,ix,cells,lower,bytes⟩ := body_invariant s ⟨middle,.normal⟩ gm igm initial j hj inv gw iw separate bodyExec
  have fixedNext := fixed_after increment middle ⟨next,.normal⟩ gm igm fixed rfl (by simp [writes,increment]) update
  have xNext := KeygenPublicTableStore.word_after increment middle ⟨next,.normal⟩ "x" _ rfl (by decide) x update
  have ixNext := KeygenPublicTableStore.word_after increment middle ⟨next,.normal⟩ "ix" _ rfl (by decide) ix update
  have equal := congrArg Result.state (increment_result middle ⟨next,.normal⟩ j hj u update)
  dsimp only at equal
  refine ⟨by omega,fixedNext,?_,xNext,ixNext,?_,?_,?_⟩
  · rw [equal]
    exact increment_counter middle j hj
  · simpa only [equal,bindValue] using cells
  · simpa only [equal,bindValue] using lower
  · simpa only [equal,bindValue] using bytes

theorem source_loop (s : State) (out : Result) (gm igm : ArrayPointer) (initial : Memory)
    (j : Nat) (inv : Invariant gm igm initial j s)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (source : Exec KeygenPublicSource.program [] loop s out) :
    out.flow=.normal ∧ Invariant gm igm initial 256 out.state := by
  generalize shape : loop=code at source
  generalize signedShape : ([] : List C99ArrayReference.Name)=signed at source
  induction source generalizing j with
  | loopFalse _ _ _ before v evaluated zero =>
      cases shape
      cases signedShape
      rw [guard before j inv.bound v inv.counter inv.fixed.b evaluated] at zero
      have done : j=256 := by
        have bound := inv.bound
        by_cases h : j<256
        · simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at zero
        · omega
      subst j
      exact ⟨rfl,inv⟩
  | loopNormal _ _ _ before middle next result v evaluated nonzero iteration update rest ih1 ih2 ih3 =>
      cases shape
      cases signedShape
      rw [guard before j inv.bound v inv.counter inv.fixed.b evaluated] at nonzero
      have active : j<256 := by
        by_contra h
        simp [h,C99ScalarReference.boolean,C99IntegerReference.Value.integer] at nonzero
      exact ih3 (j+1) (step before middle next gm igm initial j active inv gw iw separate iteration update) rfl rfl
  | loopReturn _ _ _ _ _ _ _ _ _ iteration _ =>
      cases shape
      have impossible := (KeygenPublicTableControl.frame _ _ _ _ _ (by decide) iteration).1
      cases impossible
  | skip | scalar | assign | declarePointer | pointer | store | call | seqNormal | seqExit
  | scope | arrayScope | branchTrue | branchFalse | ret | retVoid => cases shape

end FT1536.Source3.KeygenPublicLastLoop
