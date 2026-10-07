import Source3.KeygenSolverNttCalls

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Byte frames follow pointer provenance and the actual Store32 footprint,
   independently of canonical residues or the polynomial-value invariant. -/
namespace FT1536.Source3.KeygenNttMemoryFrame
open C99MemoryReference
open C99ArrayReference (State Name)
open C99ProcedureReference (Result)
open C99ModularReference (Stmt Exec)
open KeygenSmallOutput (element)
open KeygenMkgm3Frame (Outside)

def names : List Name := ["a".toList,"r1".toList,"r2".toList]
def Descendant (root p : ArrayPointer) : Prop := p.block=root.block ∧ p.base=root.base ∧
  p.count=root.count ∧ p.elementBytes=4 ∧ root.index≤p.index
def Bindings (s : State) (root : ArrayPointer) : Prop :=
  ∀ name∈names, ∀ p, s.arrays name=some p → Descendant root p
def supported : Stmt → Bool
  | .base .skip | .base (.scalar _) | .assign _ _ | .ret _ | .retVoid => true
  | .base (.declarePtr name) => names.contains name
  | .base (.bindPtr name origin _) => names.contains name && names.contains origin
  | .store32 name _ _ => names.contains name
  | .seq a b | .branch _ a b | .loop _ a b => supported a && supported b
  | .scope _ body => supported body
  | _ => false

theorem pointer_descendant (s : State) (root p : ArrayPointer) (name : Name) (idx : CLogic.Expr)
    (bindings : Bindings s root) (member : name∈names)
    (address : C99ArrayReference.Pointer s name idx p) : Descendant root p := by
  cases address with
  | add original actual i binding value positive within =>
      have fields := bindings name member original binding
      cases within
      exact ⟨fields.1,fields.2.1,fields.2.2.1,fields.2.2.2.1,by dsimp; have := fields.2.2.2.2; omega⟩

theorem store_bytes (before after : Memory) (root p : ArrayPointer) (word : BitVec 32)
    (width : root.elementBytes=4) (fields : Descendant root p) (write : Store32 before p word after)
    (block offset : Nat) (outside : Outside root block offset) : after.bytes block offset=before.bytes block offset := by
  apply write.2.2.2.2.2.2
  have allocated := write.1.2.2.1
  dsimp [Outside,ArrayPointer.offset] at outside ⊢
  rw [fields.1,fields.2.1,fields.2.2.2.1]
  rw [width] at outside
  have count := fields.2.2.1
  have lower := fields.2.2.2.2
  omega

def Frame (before after : Memory) (root : ArrayPointer) : Prop :=
  after.size=before.size ∧ after.writable=before.writable ∧
  ∀ block offset, Outside root block offset → after.bytes block offset=before.bytes block offset

theorem frame_trans (a b c : Memory) (root : ArrayPointer) (first : Frame a b root) (second : Frame b c root) :
    Frame a c root := ⟨second.1.trans first.1,second.2.1.trans first.2.1,
      fun block offset outside => (second.2.2 block offset outside).trans (first.2.2 block offset outside)⟩

theorem source_frame (code : Stmt) (before : State) (out : Result) (root : ArrayPointer)
    (width : root.elementBytes=4) (checked : supported code=true) (bindings : Bindings before root)
    (source : Exec code before out) : Bindings out.state root ∧ Frame before.heap out.state.heap root := by
  induction source with
  | base code before after body =>
      cases code with
      | skip => cases body; exact ⟨bindings,rfl,rfl,fun _ _ _ => rfl⟩
      | scalar statement => cases body; exact ⟨bindings,rfl,rfl,fun _ _ _ => rfl⟩
      | declarePtr name =>
          cases body
          refine ⟨?_,rfl,rfl,fun _ _ _ => rfl⟩
          intro n member p bound
          by_cases equal : n=name
          · subst n; simp only [ite_true] at bound; cases bound
          · apply bindings n member p
            simpa only [equal,ite_false] using bound
      | bindPtr name origin idx =>
          cases body with
          | bindPtr s name origin idx p address =>
              have allowed := Bool.and_eq_true_iff.mp checked
              have desc := pointer_descendant before root p origin idx bindings (List.contains_iff_mem.mp allowed.2) address
              refine ⟨?_,rfl,rfl,fun _ _ _ => rfl⟩
              intro n member q bound
              by_cases equal : n=name
              · subst n
                have same : p=q := Option.some.inj (by simpa [C99ArrayReference.bindPointer] using bound)
                subst q; exact desc
              · exact bindings n member q (by simpa only [C99ArrayReference.bindPointer,equal,ite_false] using bound)
      | assign | store64 | store32 | copy | seq | scope | branch | «while» | call => cases checked
  | assign => exact ⟨bindings,rfl,rfl,fun _ _ _ => rfl⟩
  | store32 name idx e before after p v address value write =>
      exact ⟨bindings,write.2.2.2.1,write.2.2.2.2.1,
        store_bytes before.heap after root p _ width
          (pointer_descendant before root p name idx bindings (List.contains_iff_mem.mp checked) address) write⟩
  | storeRev => cases checked
  | seqNormal first second before middle out head tail ih1 ih2 =>
      have hs := Bool.and_eq_true_iff.mp checked
      obtain ⟨mid,first⟩ := ih1 hs.1 bindings
      obtain ⟨last,second⟩ := ih2 hs.2 mid
      exact ⟨last,frame_trans _ _ _ root first second⟩
  | seqExit first second before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1 bindings
  | scope names body before out inner ih => exact ih checked bindings
  | branchTrue condition yes no before out v guard nonzero body ih => exact ih (Bool.and_eq_true_iff.mp checked).1 bindings
  | branchFalse condition yes no before out v guard zero body ih => exact ih (Bool.and_eq_true_iff.mp checked).2 bindings
  | loopFalse => exact ⟨bindings,rfl,rfl,fun _ _ _ => rfl⟩
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
      have hs := Bool.and_eq_true_iff.mp checked
      obtain ⟨mid,first⟩ := ih1 hs.1 bindings
      obtain ⟨next,second⟩ := ih2 hs.2 mid
      obtain ⟨last,third⟩ := ih3 checked next
      exact ⟨last,frame_trans _ _ _ root first (frame_trans _ _ _ root second third)⟩
  | loopReturn condition body increment before after v value guard nonzero iteration ih =>
      exact ih (Bool.and_eq_true_iff.mp checked).1 bindings
  | ret | retVoid => exact ⟨bindings,rfl,rfl,fun _ _ _ => rfl⟩

def tailCode : Stmt := KeygenNttForwardPrograms.glue KeygenNttForwardPrograms.firstPass
  (KeygenNttForwardPrograms.glue KeygenNttForwardPrograms.intermediatePass KeygenNttForwardPrograms.triplePass)
theorem tail_supported : supported tailCode=true := by decide

theorem whole_frame (before : State) (out : Result) (root p gm : ArrayPointer) (p0i : BitVec 32)
    (width : root.elementBytes=4) (desc : Descendant root p)
    (entry : KeygenNttFirstComposition.Entry before p gm p0i)
    (source : Exec KeygenNttForwardPrograms.forwardBody before out) : Frame before.heap out.state.heap root := by
  have split := KeygenNttExecution.glue_chain _ tailCode before out source
  obtain ⟨ready,prologue,rest⟩ := (KeygenNttForwardExec.seq_inv _ _ before out split).resolve_right (by
    rintro ⟨r,hr,hn,he⟩
    subst r
    exact hn (congrArg Result.flow (KeygenNttForwardExec.prologue_result before out entry.logn entry.full hr)))
  have equal := congrArg Result.state (KeygenNttForwardExec.prologue_result before ⟨ready,.normal⟩ entry.logn entry.full prologue)
  dsimp only at equal
  subst ready
  have bindings : Bindings (KeygenNttForwardExec.ready before) root := by
    intro name member q bound
    have choices : name="a".toList ∨ name="r1".toList ∨ name="r2".toList := by
      simpa only [names,List.mem_cons,List.not_mem_nil,or_false] using member
    rcases choices with rfl | rfl | rfl
    · have actual : before.arrays "a".toList=some q := bound
      have same := Option.some.inj (entry.array.symm.trans actual)
      subst q
      exact desc
    · change none=some q at bound; cases bound
    · change none=some q at bound; cases bound
  exact (source_frame tailCode _ out root width tail_supported bindings rest).2

theorem call_frame (name : String) (before after : State) (root p gm : ArrayPointer) (p0i : BitVec 32)
    (width : root.elementBytes=4) (desc : Descendant root p)
    (caller : KeygenSolverNttCalls.Caller before p0i gm) (array : before.arrays name.toList=some p)
    (source : KeygenSolverNttCalls.Exec (KeygenSolverNttCalls.call name) before after) :
    Frame before.heap after.heap root := by
  cases source with
  | call args before entry out parameters body returned =>
      have entryArgs := KeygenSolverNttCalls.binding_entry before entry name p gm p0i caller array parameters
      have heap := C99ArrayReference.bind_heap before _ _ entry parameters
      have result := whole_frame entry out root p gm p0i width desc entryArgs body
      rw [heap] at result
      exact result

theorem material_preserved (before after : Memory) (root input : ArrayPointer) (v : Geometry.Vec)
    (width : root.elementBytes=4) (count : root.index≤root.count) (inputWidth : input.elementBytes=2)
    (separate : KeygenMkgm3Layout.DisjointBytes input 3072 root (KeygenMkgm3Frame.objectBytes root))
    (frame : Frame before after root) (represented : KeygenMaterial.Represents before input v) :
    KeygenMaterial.Represents after input v := by
  intro i
  constructor
  · intro byte
    rw [frame.2.2 _ _ (KeygenMkgm3Frame.input_outside root input width count inputWidth separate
      i.val (by have := i.isLt; omega) byte)]
    exact (represented i).1 byte
  · intro byte
    rw [frame.2.2 _ _ (KeygenMkgm3Frame.input_outside root input width count inputWidth separate
      (i.val+768) (by have := i.isLt; omega) byte)]
    exact (represented i).2 byte

end FT1536.Source3.KeygenNttMemoryFrame
