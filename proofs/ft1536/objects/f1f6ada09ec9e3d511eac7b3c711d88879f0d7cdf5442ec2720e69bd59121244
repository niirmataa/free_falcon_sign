import Source3.KeygenPublicTableIndex

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicTableStore
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open C99MemoryReference (Memory ArrayPointer)
open KeygenPublicExec (Exec Stmt)
open KeygenPublicAlgebra (R)
open KeygenPublicDivisionAlgebra (Scaled multiply)
open KeygenPublicTableAtoms (Slot var mont)
open KeygenPublicTableControl (supported writes frame)
open KeygenPublicTableCells (Cell)
open KeygenSmallOutput (element Store16)
open KeygenNttLoopSupport (USlot)

def Word (s : State) (name : String) (z : R) : Prop := ∃ w, Slot s name w ∧ Scaled w z
def EvalWord (s : State) (e : KeygenWordExpr.Expr) (z : R) : Prop :=
  ∀ v, KeygenPublicWord.Eval [] s e v → ∃ w, v=.uint32 w ∧ Scaled w z
def Pointers (s : State) (gm igm : ArrayPointer) : Prop :=
  s.arrays "gm".toList=some gm ∧ s.arrays "igm".toList=some igm
def Separate (gm igm : ArrayPointer) : Prop := KeygenMkgm3Layout.DisjointBytes gm 2048 igm 2048
def Update (p : ArrayPointer) (i : Nat) (z : R) (before after : Memory) : Prop :=
  Cell after p i z ∧ ∀ j<1024, i≠j → ∀ a, Cell before p j a → Cell after p j a
def PairUpdate (gm igm : ArrayPointer) (i : Nat) (a b : R) (before after : Memory) : Prop :=
  Update gm i a before after ∧ Update igm i b before after
def OutsideLast (gm igm : ArrayPointer) (block offset : Nat) : Prop :=
  ∀ p∈[gm,igm], block≠p.block ∨ offset<p.offset+1024 ∨ p.offset+2048≤offset
def LastFrame (gm igm : ArrayPointer) (before after : Memory) : Prop :=
  after.size=before.size ∧ after.writable=before.writable ∧
    ∀ block offset, OutsideLast gm igm block offset → after.bytes block offset=before.bytes block offset
theorem frame_refl (gm igm : ArrayPointer) (heap : Memory) : LastFrame gm igm heap heap :=
  ⟨rfl,rfl,fun _ _ _ => rfl⟩
theorem frame_trans (gm igm : ArrayPointer) (a b c : Memory)
    (first : LastFrame gm igm a b) (second : LastFrame gm igm b c) : LastFrame gm igm a c :=
  ⟨second.1.trans first.1,second.2.1.trans first.2.1,
    fun block offset h => (second.2.2 block offset h).trans (first.2.2 block offset h)⟩
theorem last_write_frame (gm igm p : ArrayPointer) (member : p∈[gm,igm]) (width : p.elementBytes=2)
    (i : Nat) (lower : 512 ≤ i) (upper : i < 1024) (before after : Memory) (w : BitVec 16)
    (source : Store16 before (element p i) w after) : LastFrame gm igm before after := by
  refine ⟨source.2.2.2.1,source.2.2.2.2.1,?_⟩
  intro block offset outside
  apply source.2.2.2.2.2.2
  have separate := outside p member
  simp only [element,ArrayPointer.offset,width] at *
  omega

theorem word_after (code : Stmt) (s : State) (out : Result) (name : String) (z : R)
    (ok : supported code=true) (keep : name.toList∉writes code)
    (word : Word s name z) (source : Exec KeygenPublicSource.program [] code s out) : Word out.state name z := by
  obtain ⟨w,slot,scaled⟩ := word
  exact ⟨w,((frame _ _ code s out ok source).2.2 _ keep).trans slot,scaled⟩
theorem pointers_after (code : Stmt) (s : State) (out : Result) (gm igm : ArrayPointer)
    (ok : supported code=true) (pointers : Pointers s gm igm)
    (source : Exec KeygenPublicSource.program [] code s out) : Pointers out.state gm igm := by
  unfold Pointers
  rw [(frame _ _ code s out ok source).2.1]
  exact pointers
theorem variable_word (s : State) (name : String) (z : R) (word : Word s name z) : EvalWord s (var name) z := by
  obtain ⟨w,slot,scaled⟩ := word
  exact fun v hv => ⟨w,KeygenPublicTableAtoms.variable_value [] s name w v slot hv,scaled⟩
theorem mont_word (s : State) (a b : KeygenWordExpr.Expr) (x y : R)
    (left : EvalWord s a x) (right : EvalWord s b y) : EvalWord s (mont a b) (x*y) := by
  intro v source
  cases source with
  | call4 _ _ _ _ _ av bv qv iv _ first second third fourth invoked =>
      obtain ⟨aw,ae,as⟩ := left av first
      obtain ⟨bw,be,bs⟩ := right bv second
      have qe := KeygenPublicTableAtoms.literal_value [] s 18433 qv third
      have ie := KeygenPublicTableAtoms.literal_value [] s 18431 iv fourth
      subst av; subst bv; subst qv; subst iv
      exact ⟨multiply aw bw,KeygenPublicArguments.source_mul_exact aw bw _ _ _ _ v
        (KeygenPublicArguments.u32_self aw) (KeygenPublicArguments.u32_self bw)
        (KeygenPublicArguments.u32_literal 18433) (KeygenPublicArguments.u32_literal 18431) invoked,
        KeygenPublicDivisionAlgebra.scaled_product aw bw x y as bs⟩
theorem assign_word (s : State) (out : Result) (name : String) (e : KeygenWordExpr.Expr) (z : R)
    (declared : ∃ old, s.locals name.toList=some (.uint32,old)) (value : EvalWord s e z)
    (source : Exec KeygenPublicSource.program [] (.assign name.toList e) s out) : Word out.state name z := by
  obtain ⟨old,bound⟩ := declared
  cases source with
  | assign _ _ _ ty previous v slot evaluated =>
      have te := congrArg Prod.fst (Option.some.inj (slot.symm.trans bound))
      dsimp only at te
      subst ty
      obtain ⟨w,ve,scaled⟩ := value v evaluated
      subst v
      exact ⟨w,KeygenPublicTableAtoms.slot_after _ _ _,scaled⟩
theorem word_declared (s : State) (name : String) (z : R) (word : Word s name z) :
    ∃ old, s.locals name.toList=some (.uint32,old) := by
  obtain ⟨w,slot,_⟩ := word
  exact ⟨some (.uint32 w),slot⟩
theorem advance_word (s : State) (out : Result) (name factor : String) (x y : R)
    (first : Word s name x) (second : Word s factor y)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicLastProgram.advance name factor) s out) :
    Word out.state name (x*y) :=
  assign_word s out name _ _ (word_declared s name x first)
    (mont_word s _ _ x y (variable_word s name x first) (variable_word s factor y second)) source

theorem separate_symm (gm igm : ArrayPointer) (separate : Separate gm igm) : Separate igm gm := by
  rcases separate with h | h | h
  · exact Or.inl (Ne.symm h)
  · exact Or.inr (Or.inr h)
  · exact Or.inr (Or.inl h)
theorem separated_bytes (gm igm : ArrayPointer) (gw : gm.elementBytes=2) (iw : igm.elementBytes=2)
    (separate : Separate gm igm) (i j : Nat) (hi : i<1024) (hj : j<1024) (byte : Fin 2) :
    (element gm j).block≠(element igm i).block ∨
      (element gm j).offset+byte.val<(element igm i).offset ∨
        (element igm i).offset+2≤(element gm j).offset+byte.val := by
  simp only [Separate,KeygenMkgm3Layout.DisjointBytes,ArrayPointer.offset,gw,iw] at separate
  simp only [element,ArrayPointer.offset,gw,iw]
  have bound := byte.isLt
  omega
theorem cross_preserves (before after : Memory) (gm igm : ArrayPointer)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (i j : Nat) (hi : i<1024) (hj : j<1024) (w : BitVec 16) (z : R)
    (source : Store16 before (element igm i) w after) (cell : Cell before gm j z) : Cell after gm j z :=
  KeygenPublicTableCells.separate_store before after gm igm i j w z
    (separated_bytes gm igm gw iw separate i j hi hj) source cell
theorem paired_writes (before middle after : Memory) (gm igm : ArrayPointer)
    (gw : gm.elementBytes=2) (iw : igm.elementBytes=2) (separate : Separate gm igm)
    (i : Nat) (hi : i<1024) (x y : BitVec 32) (a b : R) (xs : Scaled x a) (ys : Scaled y b)
    (first : Store16 before (element gm i) (KeygenPublicWord.narrow (.uint32 x)) middle)
    (second : Store16 middle (element igm i) (KeygenPublicWord.narrow (.uint32 y)) after) :
    PairUpdate gm igm i a b before after := by
  constructor
  · refine ⟨cross_preserves middle after gm igm gw iw separate i i hi hi _ a second
      (KeygenPublicTableCells.written_cell before middle gm i x a xs first),?_⟩
    intro j hj ne z old
    exact cross_preserves middle after gm igm gw iw separate i j hi hj _ z second
      (KeygenPublicTableCells.preserves_cell before middle gm gw i j ne _ z first old)
  · refine ⟨KeygenPublicTableCells.written_cell middle after igm i y b ys second,?_⟩
    intro j hj ne z old
    exact KeygenPublicTableCells.preserves_cell middle after igm iw i j ne _ z second
      (cross_preserves before middle igm gm iw gw (separate_symm gm igm separate) i j hi hj _ z first old)

theorem source_store (s : State) (out : Result) (name value : String) (e : CLogic.Expr)
    (p : ArrayPointer) (i : Nat) (hi : i<512) (z : R)
    (binding : s.arrays name.toList=some p) (k : Slot s "k" 1) (b : USlot s "b" 512)
    (input : ∀ v, KeygenPublicWord.scalar s e v → v=KeygenNttLoopSupport.u64 i)
    (word : Word s value z)
    (source : Exec KeygenPublicSource.program [] (KeygenPublicLastProgram.store name value e) s out) :
    ∃ w, Scaled w z ∧ Store16 s.heap (element p (KeygenMkgm3Indices.lastIndex i))
      (KeygenPublicWord.narrow (.uint32 w)) out.state.heap := by
  cases source with
  | store _ _ _ _ before heap actual v address evaluated write =>
      rw [KeygenPublicTableIndex.index_address s name e p actual i hi binding k b input address] at write
      obtain ⟨w,ve,scaled⟩ := variable_word s value z word v evaluated
      subst v
      exact ⟨w,scaled,write⟩

end FT1536.Source3.KeygenPublicTableStore
