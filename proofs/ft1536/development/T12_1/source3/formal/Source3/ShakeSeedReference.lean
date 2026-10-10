import Source3.ShakeSeedProgram

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Independent word/byte execution of complete source init/inject/flip.
   xor_block, dec64le and process_block have fixed executed bodies. The
   relations record no SHAKE idealization, seed law or desired final image. -/
namespace FT1536.Source3.ShakeSeedReference
open C99MemoryReference
open C99ArrayReference (State Name bindValue bindPointer)
open C99IntegerReference (Value Ty)
open ShakeExtractSource (Layout Field field)
open ShakeSeedProgram
open ShakePointFrame (Same)

inductive ReadCall (ctx : Layout) (s : State) : C99ScalarReference.CallRelation where
  | dptr (dummy : Value) (w : BitVec 64) (read : Load64 s.heap (field ctx .dptr) w) :
      ReadCall ctx s (readName .dptr) [dummy] (.uint64 w)
  | rate (dummy : Value) (w : BitVec 64) (read : Load64 s.heap (field ctx .rate) w) :
      ReadCall ctx s (readName .rate) [dummy] (.uint64 w)
def Eval (ctx : Layout) (s : State) (e : CLogic.Expr) (v : Value) : Prop :=
  C99ScalarReference.Eval (ReadCall ctx s) s.locals (C99Frontend.expression e) v
inductive Exec (ctx : Layout) : Stmt → State → State → Prop where
  | scalar (code : CLogic.Stmt) (before : State) (env : C99ScalarReference.Env)
      (source : C99ScalarReference.Exec (ReadCall ctx before) before.locals (C99Frontend.scalar code) (.normal env)) :
      Exec ctx (.scalar code) before {before with locals := env}
  | declarePointer (s : State) (n : Name) : Exec ctx (.declarePointer n) s
      {s with arrays := fun name => if name=n then none else s.arrays name}
  | pointer (s : State) (dst src : Name) (e : CLogic.Expr) (p : ArrayPointer)
      (source : C99ArrayReference.Pointer s src e p) : Exec ctx (.pointer dst src e) s (bindPointer s dst p)
  | readLocal (s : State) (dst : Name) (member : Field) (ty : Ty) (old : Option Value) (w : BitVec 64)
      (declared : s.locals dst=some (ty,old)) (read : Load64 s.heap (field ctx member) w) :
      Exec ctx (.readLocal dst member) s (bindValue s dst ty (.uint64 w))
  | write (s : State) (member : Field) (e : CLogic.Expr) (v : Value) (heap : Memory)
      (value : Eval ctx s e v) (store : Store64 s.heap (field ctx member) (BitVec.ofInt 64 v.integer) heap) :
      Exec ctx (.write member e) s {s with heap := heap}
  | store64 (s : State) (index value : CLogic.Expr) (i v : Value) (p : ArrayPointer) (heap : Memory)
      (offset : Eval ctx s index i) (positive : 0 ≤ i.integer)
      (address : PointerAdd (field ctx .a) i.integer.toNat p) (evaluated : Eval ctx s value v)
      (write : Store64 s.heap p (BitVec.ofInt 64 v.integer) heap) : Exec ctx (.store .a index value) s {s with heap := heap}
  | store8 (s : State) (index value : CLogic.Expr) (i v : Value) (p : ArrayPointer) (heap : Memory)
      (offset : Eval ctx s index i) (positive : 0 ≤ i.integer)
      (address : PointerAdd (field ctx .dbuf) i.integer.toNat p) (evaluated : Eval ctx s value v)
      (write : ShakeEncode.Store8 s.heap p (BitVec.ofInt 8 v.integer) heap) : Exec ctx (.store .dbuf index value) s {s with heap := heap}
  /- Postincrement's old index and incremented field are separate snapshots.
     Its increment is sequenced before the assignment's byte store; these
     distinct subobjects permit this C99 evaluation order. -/
  | postByte (s : State) (value : CLogic.Expr) (old : BitVec 64) (next v : Value)
      (p : ArrayPointer) (incremented heap : Memory)
      (read : Load64 s.heap (field ctx .dptr) old)
      (update : C99IntegerReference.ArithmeticExec .plus (.uint64 old) (.int32 1) next)
      (writeCounter : Store64 s.heap (field ctx .dptr) (BitVec.ofInt 64 next.integer) incremented)
      (address : PointerAdd (field ctx .dbuf) old.toNat p) (evaluated : Eval ctx s value v)
      (writeByte : ShakeEncode.Store8 incremented p (BitVec.ofInt 8 v.integer) heap) :
      Exec ctx (.postByte value) s {s with heap := heap}
  | fill (s : State) (member : Field) (start count : CLogic.Expr) (i n : Value) (p : ArrayPointer) (heap : Memory)
      (offset : Eval ctx s start i) (length : Eval ctx s count n) (positive : 0 ≤ i.integer) (nonnegative : 0≤n.integer)
      (address : PointerAdd (field ctx member) i.integer.toNat p)
      (source : ShakeSeedMemory.Fill s.heap p n.integer.toNat 0 heap) : Exec ctx (.fill member start count) s {s with heap := heap}
  | copyData (s : State) (start count : CLogic.Expr) (i n : Value) (p q : ArrayPointer) (heap : Memory)
      (offset : Eval ctx s start i) (length : Eval ctx s count n) (positive : 0 ≤ i.integer) (nonnegative : 0≤n.integer)
      (destination : PointerAdd (field ctx .dbuf) i.integer.toNat p)
      (source : C99ArrayReference.Pointer s "buf".toList zero q)
      (dstObject : p.offset+n.integer.toNat≤p.base+p.elementBytes*p.count)
      (srcObject : q.offset+n.integer.toNat≤q.base+q.elementBytes*q.count)
      (copy : Memcpy s.heap p q n.integer.toNat heap) : Exec ctx (.copyData start count) s {s with heap := heap}
  | xor (before after : State) (rate : CLogic.Expr) (v : Value) (evaluated : Eval ctx before rate v)
      (source : ShakeSeedMemory.XorCall before (field ctx .a) (field ctx .dbuf) v after) : Exec ctx (.xor rate) before after
  | process (before after : State) (source : ShakeExtractSource.Process before (field ctx .a) after) : Exec ctx .process before after
  | skip (s : State) : Exec ctx .skip s s
  | seq (a b : Stmt) (before middle after : State) (first : Exec ctx a before middle) (second : Exec ctx b middle after) :
      Exec ctx (.seq a b) before after
  | scope (locals pointers : List Name) (code : Stmt) (before after : State) (source : Exec ctx code before after) :
      Exec ctx (.scope locals pointers code) before (C99ArrayReference.restoreScope before after locals pointers)
  | branchTrue (condition : CLogic.Expr) (yes no : Stmt) (before after : State) (v : Value)
      (guard : Eval ctx before condition v) (nonzero : v.integer≠0) (source : Exec ctx yes before after) :
      Exec ctx (.branch condition yes no) before after
  | branchFalse (condition : CLogic.Expr) (yes no : Stmt) (before after : State) (v : Value)
      (guard : Eval ctx before condition v) (zero : v.integer=0) (source : Exec ctx no before after) :
      Exec ctx (.branch condition yes no) before after
  | loopFalse (condition : CLogic.Expr) (body : Stmt) (s : State) (v : Value)
      (guard : Eval ctx s condition v) (zero : v.integer=0) : Exec ctx (.loop condition body) s s
  | loopNext (condition : CLogic.Expr) (body : Stmt) (before middle after : State) (v : Value)
      (guard : Eval ctx before condition v) (nonzero : v.integer≠0)
      (iteration : Exec ctx body before middle) (rest : Exec ctx (.loop condition body) middle after) :
      Exec ctx (.loop condition body) before after

theorem source_frame (ctx : Layout) (code : Stmt) (before after : State) (source : Exec ctx code before after)
    (b o : Nat) (outside : ∀ member, ShakeBlock.Outside (field ctx member) b o) : Same before.heap after.heap b o := by
  induction source with
  | scalar | declarePointer | pointer | readLocal | skip | loopFalse => exact ⟨rfl,rfl,rfl⟩
  | write s member e v heap value store => exact ShakePointFrame.store64 _ _ _ _ b o store (outside member)
  | store64 s index value i v p heap offset positive address evaluated write =>
    cases address; exact ShakePointFrame.store64 _ _ _ _ b o write (outside .a)
  | store8 s index value i v p heap offset positive address evaluated write =>
    cases address; exact ShakePointFrame.store8 _ _ _ _ b o write (outside .dbuf)
  | postByte s value old next v p incremented heap read update writeCounter address evaluated writeByte =>
    cases address
    exact ShakePointFrame.trans _ _ _ b o (ShakePointFrame.store64 _ _ _ _ b o writeCounter (outside .dptr))
      (ShakePointFrame.store8 _ _ _ _ b o writeByte (outside .dbuf))
  | fill s member start count i n p heap offset length positive nonnegative address fill =>
    cases address; exact ShakeSeedMemory.fill_frame _ _ _ _ _ fill b o (outside member)
  | copyData s start count i n p q heap offset length positive nonnegative destination source dstObject srcObject copy =>
    cases destination
    obtain ⟨_,_,_,_,_,_,_,hs,hw,_,hf⟩ := copy
    refine ⟨hs,hw,hf b o ?_⟩
    have out := outside .dbuf
    dsimp [ShakeBlock.Outside,ArrayPointer.offset] at out dstObject ⊢
    omega
  | xor before after rate v evaluated source => exact ShakeSeedMemory.xor_frame _ _ _ _ _ source b o (outside .a)
  | process before after source => exact ShakePointFrame.process _ _ _ source b o (outside .a)
  | seq a b before middle after first second ih1 ih2 => exact ShakePointFrame.trans _ _ _ _ _ ih1 ih2
  | scope _ _ _ _ _ _ ih | branchTrue _ _ _ _ _ _ _ _ _ ih | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih
  | loopNext _ _ _ _ _ _ _ _ _ _ ih1 ih2 => exact ShakePointFrame.trans _ _ _ _ _ ih1 ih2

def entry (s : State) : State := {s with locals := fun _ => none, arrays := fun _ => none}
def initEntry (s : State) (capacity : Value) : State := bindValue (entry s) "capacity".toList .int32 capacity
def injectEntry (s : State) (data : ArrayPointer) (len : Value) : State :=
  bindPointer (bindValue (entry s) "len".toList .uint64 len) "data".toList data
inductive Init (ctx : Layout) (before : State) (capacity : Value) : State → Prop where
  | run (after : State) (source : Exec ctx initCode (initEntry before capacity) after) : Init ctx before capacity {before with heap := after.heap}
inductive Inject (ctx : Layout) (before : State) (data : ArrayPointer) (len : Value) : State → Prop where
  | run (after : State) (source : Exec ctx injectCode (injectEntry before data len) after) : Inject ctx before data len {before with heap := after.heap}
inductive Flip (ctx : Layout) (before : State) : State → Prop where
  | run (after : State) (source : Exec ctx flipCode (entry before) after) : Flip ctx before {before with heap := after.heap}
theorem init_frame (ctx : Layout) (before after : State) (capacity : Value) (source : Init ctx before capacity after)
    (b o : Nat) (outside : ∀ member, ShakeBlock.Outside (field ctx member) b o) : Same before.heap after.heap b o := by
  cases source with | run after source => exact source_frame ctx _ _ after source b o outside
theorem inject_frame (ctx : Layout) (before after : State) (data : ArrayPointer) (len : Value)
    (source : Inject ctx before data len after) (b o : Nat)
    (outside : ∀ member, ShakeBlock.Outside (field ctx member) b o) : Same before.heap after.heap b o := by
  cases source with | run after source => exact source_frame ctx _ _ after source b o outside
theorem flip_frame (ctx : Layout) (before after : State) (source : Flip ctx before after)
    (b o : Nat) (outside : ∀ member, ShakeBlock.Outside (field ctx member) b o) : Same before.heap after.heap b o := by
  cases source with | run after source => exact source_frame ctx _ _ after source b o outside
theorem init_slots (ctx : Layout) (before after : State) (v : Value) (source : Init ctx before v after) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.globals=before.globals ∧ after.tables=before.tables := by
  cases source; exact ⟨rfl,rfl,rfl,rfl⟩
theorem inject_slots (ctx : Layout) (before after : State) (p : ArrayPointer) (v : Value) (source : Inject ctx before p v after) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.globals=before.globals ∧ after.tables=before.tables := by
  cases source; exact ⟨rfl,rfl,rfl,rfl⟩
theorem flip_slots (ctx : Layout) (before after : State) (source : Flip ctx before after) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.globals=before.globals ∧ after.tables=before.tables := by
  cases source; exact ⟨rfl,rfl,rfl,rfl⟩

end FT1536.Source3.ShakeSeedReference
