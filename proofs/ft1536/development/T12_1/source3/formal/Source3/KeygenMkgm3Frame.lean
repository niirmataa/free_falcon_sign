import Source3.KeygenMkgm3Assembly

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Original coefficient objects are outside the caller's scratch object.
   The write footprint follows pointer provenance and defined Store32
   bounds, including same-block disjoint subobjects. -/
namespace FT1536.Source3.KeygenMkgm3Frame
open C99MemoryReference
open C99ArrayReference (State Name)
open C99ProcedureReference (Result)
open C99ModularReference (Stmt Exec)
open KeygenSmallOutput (element)

def Outside (root : ArrayPointer) (block offset : Nat) : Prop :=
  block≠root.block ∨ offset<root.offset ∨ root.base+4*root.count ≤ offset
def Bindings (s : State) (root : ArrayPointer) : Prop :=
  s.arrays "gm".toList=some (KeygenMkgm3Layout.gm root) ∧ s.arrays "igm".toList=some root

def tableWrites : Stmt → Bool
  | .base .skip | .base (.scalar _) | .assign _ _ => true
  | .store32 name _ _ | .storeRev name _ _ _ _ => decide (name="gm".toList ∨ name="igm".toList)
  | .seq a b | .branch _ a b | .loop _ a b => tableWrites a && tableWrites b
  | .scope _ body => tableWrites body
  | _ => false

theorem bindings_after (code : Stmt) (s : State) (out : Result) (root : ArrayPointer)
    (support : KeygenMkgm3Control.supported code=true) (bindings : Bindings s root)
    (source : Exec code s out) : Bindings out.state root := by
  have ha := (KeygenMkgm3Control.frame code s out support source).2.1
  simpa only [Bindings,ha] using bindings

theorem store_outside (s : State) (after : Memory) (name : Name) (idx : CLogic.Expr)
    (p root : ArrayPointer) (w : BitVec 32) (width : root.elementBytes=4)
    (bindings : Bindings s root) (named : name="gm".toList ∨ name="igm".toList)
    (address : C99ArrayReference.Pointer s name idx p) (write : Store32 s.heap p w after)
    (block offset : Nat) (outside : Outside root block offset) :
    after.bytes block offset=s.heap.bytes block offset := by
  apply write.2.2.2.2.2.2
  have fields : p.block=root.block ∧ p.base=root.base ∧ p.count=root.count ∧
      p.elementBytes=4 ∧ root.index ≤ p.index := by
    cases address with
    | add base actual v binding value nonnegative within =>
        rcases named with rfl | rfl
        · have hb := Option.some.inj (binding.symm.trans bindings.1)
          subst base
          cases within
          exact ⟨rfl,rfl,rfl,width,by dsimp [KeygenMkgm3Layout.gm,element]; omega⟩
        · have hb := Option.some.inj (binding.symm.trans bindings.2)
          subst base
          cases within
          exact ⟨rfl,rfl,rfl,width,by dsimp; omega⟩
  have allocated := write.1.2.2.1
  dsimp [Outside,ArrayPointer.offset] at outside ⊢
  rw [fields.1,fields.2.1,fields.2.2.2.1]
  rw [width] at outside
  have count := fields.2.2.1
  have lower := fields.2.2.2.2
  omega

theorem outside_bytes (code : Stmt) (s : State) (out : Result) (root : ArrayPointer)
    (width : root.elementBytes=4) (support : KeygenMkgm3Control.supported code=true)
    (checked : tableWrites code=true) (bindings : Bindings s root)
    (source : Exec code s out) :
    ∀ block offset, Outside root block offset → out.state.heap.bytes block offset=s.heap.bytes block offset := by
  induction source with
  | base code before after body =>
      cases code with
      | skip => cases body; exact fun _ _ _ => rfl
      | scalar statement => cases body; exact fun _ _ _ => rfl
      | assign | declarePtr | bindPtr | store64 | store32 | copy | seq | scope
      | branch | «while» | call => cases support
  | assign => exact fun _ _ _ => rfl
  | store32 name idx e before after p v address value write =>
      exact store_outside before after name idx p root _ width bindings (of_decide_eq_true checked) address write
  | storeRev name table base idx e before after p q bv w v be ta tr address value write =>
      exact store_outside before after name _ p root _ width bindings (of_decide_eq_true checked) address write
  | seqNormal first second before middle result head tail ih1 ih2 =>
      have hs := Bool.and_eq_true_iff.mp support
      have hc := Bool.and_eq_true_iff.mp checked
      have hb := bindings_after first before ⟨middle,.normal⟩ root hs.1 bindings head
      intro block offset ho
      exact (ih2 hs.2 hc.2 hb block offset ho).trans (ih1 hs.1 hc.1 bindings block offset ho)
  | seqExit first second before result head exit ih =>
      exact ih (Bool.and_eq_true_iff.mp support).1 (Bool.and_eq_true_iff.mp checked).1 bindings
  | scope names body before result inner ih => exact ih support checked bindings
  | branchTrue condition yes no before result v guard nonzero body ih =>
      exact ih (Bool.and_eq_true_iff.mp support).1 (Bool.and_eq_true_iff.mp checked).1 bindings
  | branchFalse condition yes no before result v guard zero body ih =>
      exact ih (Bool.and_eq_true_iff.mp support).2 (Bool.and_eq_true_iff.mp checked).2 bindings
  | loopFalse => exact fun _ _ _ => rfl
  | loopNormal condition body increment before middle next result v guard nonzero iteration update rest ih1 ih2 ih3 =>
      have hs := Bool.and_eq_true_iff.mp support
      have hc := Bool.and_eq_true_iff.mp checked
      have hb := bindings_after body before ⟨middle,.normal⟩ root hs.1 bindings iteration
      have hn := bindings_after increment middle ⟨next,.normal⟩ root hs.2 hb update
      intro block offset ho
      exact (ih3 support checked hn block offset ho).trans
        ((ih2 hs.2 hc.2 hb block offset ho).trans (ih1 hs.1 hc.1 bindings block offset ho))
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      exact ih (Bool.and_eq_true_iff.mp support).1 (Bool.and_eq_true_iff.mp checked).1 bindings
  | ret | retVoid => cases support

theorem source_footprint : tableWrites KeygenMkgm3Program.code=true := by decide

def objectBytes (root : ArrayPointer) : Nat := 4*(root.count-root.index)

theorem input_outside (root input : ArrayPointer) (width : root.elementBytes=4)
    (count : root.index ≤ root.count) (inputWidth : input.elementBytes=2)
    (separate : KeygenMkgm3Layout.DisjointBytes input 3072 root (objectBytes root))
    (i : Nat) (hi : i<1536) (byte : Fin 2) :
    Outside root (element input i).block ((element input i).offset+byte.val) := by
  have hcount : root.count-root.index+root.index=root.count := Nat.sub_add_cancel count
  simp only [Outside,KeygenMkgm3Layout.DisjointBytes,objectBytes,element,ArrayPointer.offset] at *
  rw [width,inputWidth] at *
  have hb := byte.isLt
  omega

theorem source_material (s : State) (out : Result) (root input : ArrayPointer)
    (width : root.elementBytes=4) (count : root.index ≤ root.count) (inputWidth : input.elementBytes=2)
    (bindings : Bindings s root)
    (separate : KeygenMkgm3Layout.DisjointBytes input 3072 root (objectBytes root))
    (material : FT1536.Geometry.Vec) (represented : KeygenMaterial.Represents s.heap input material)
    (source : Exec KeygenMkgm3Program.code s out) : KeygenMaterial.Represents out.state.heap input material := by
  have bytes := outside_bytes _ s out root width KeygenMkgm3Control.source_supported source_footprint bindings source
  intro i
  constructor
  · intro byte
    rw [bytes _ _ (input_outside root input width count inputWidth separate i.val (by have := i.isLt; omega) byte)]
    exact (represented i).1 byte
  · intro byte
    rw [bytes _ _ (input_outside root input width count inputWidth separate (i.val+768) (by have := i.isLt; omega) byte)]
    exact (represented i).2 byte

end FT1536.Source3.KeygenMkgm3Frame
