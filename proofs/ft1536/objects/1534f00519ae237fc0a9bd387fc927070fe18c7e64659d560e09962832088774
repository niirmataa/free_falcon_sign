import Source3.KeygenLevelNtt
import Source3.KeygenSearchMemory
import Source3.KeygenFirstPrime

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- Fixed modular procedure calls used by make_fg and intermediate search.
   Prime struct members are actual 32-bit memory reads at offsets 0/4/8 of
   a 12-byte element. The outer caller must instantiate the static table.
   No prime value or arithmetic postcondition is supplied as execution. -/
namespace FT1536.Source3.KeygenLevelCalls
open C99ArrayReference (State Name Param bindValue bindPointer)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)

inductive Field where
  | p | g | s
  deriving DecidableEq, Repr
def Field.offset : Field → Nat
  | .p => 0
  | .g => 4
  | .s => 8
def fieldPointer (p : ArrayPointer) (field : Field) : ArrayPointer :=
  ⟨p.block,p.offset+field.offset,1,4,0⟩
inductive PrimeRead (before : State) (name : Name) (index : CLogic.Expr) (field : Field) : Value → Prop where
  | read (p : ArrayPointer) (w : BitVec 32)
      (address : C99ArrayReference.Pointer before name index p)
      (width : p.elementBytes=12) (extent : p.index<p.count)
      (bytes : Load32 before.heap (fieldPointer p field) w) :
      PrimeRead before name index field (.uint32 w)
inductive Expr where
  | modular (e : C99ModularReference.Expr)
  | prime (name : Name) (index : CLogic.Expr) (field : Field)
  deriving DecidableEq, Repr
inductive Eval (before : State) : Expr → Value → Prop where
  | modular (e : C99ModularReference.Expr) (v : Value) (source : C99ModularReference.Eval before e v) :
      Eval before (.modular e) v
  | prime (name : Name) (index : CLogic.Expr) (field : Field) (v : Value)
      (source : PrimeRead before name index field v) : Eval before (.prime name index field) v
inductive Arg where
  | scalar (value : Expr)
  | pointer (name : Name) (index : CLogic.Expr)
  deriving DecidableEq, Repr
inductive Bind (before : State) : List Param → List Arg → State → Prop where
  | nil : Bind before [] [] ⟨before.heap,before.globals,before.tables,before.globals,before.tables⟩
  | scalar (ty : C99IntegerReference.Ty) (name : Name) (e : Expr) (ps : List Param) (args : List Arg)
      (out : State) (v : Value) (value : Eval before e v) (rest : Bind before ps args out) :
      Bind before (.scalar ty name::ps) (.scalar e::args) (bindValue out name ty v)
  | pointer (name src : Name) (index : CLogic.Expr) (p : ArrayPointer)
      (ps : List Param) (args : List Arg) (out : State)
      (address : C99ArrayReference.Pointer before src index p) (rest : Bind before ps args out) :
      Bind before (.pointer name::ps) (.pointer src index::args) (bindPointer out name p)
theorem bind_heap (before entry : State) (ps : List Param) (args : List Arg)
    (source : Bind before ps args entry) : entry.heap=before.heap := by
  induction source with
  | nil => rfl
  | scalar _ _ _ _ _ _ _ _ _ ih => exact ih
  | pointer _ _ _ _ _ _ _ _ _ ih => exact ih
def arguments (caller callee : List Name) : List Param → List Arg → Bool
  | [],[] => true
  | .scalar _ _::ps,.scalar _::args => arguments caller callee ps args
  | .pointer name::ps,.pointer src _::args =>
    (!(callee.contains name) || caller.contains src) && arguments caller callee ps args
  | _,_ => false
theorem bind_outside (before entry : State) (ps : List Param) (args : List Arg)
    (source : Bind before ps args entry) (caller callee : List Name)
    (checked : arguments caller callee ps args=true) (block offset : Nat)
    (outside : C99ArrayFrame.Outside before caller block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    C99ArrayFrame.Outside entry callee block offset ∧ entry.tables=before.tables := by
  induction source with
  | nil => exact ⟨fun name _ p hp => tables name p hp,rfl⟩
  | scalar ty name e ps args out v value rest ih => exact ih checked
  | pointer name src index p ps args out address rest ih =>
    obtain ⟨hc,hr⟩ := Bool.and_eq_true_iff.mp checked
    obtain ⟨ho,ht⟩ := ih hr
    refine ⟨?_,ht⟩
    intro n hn q hq
    by_cases equal : n=name
    · subst n
      have hm : callee.contains name=true := List.contains_iff_mem.mpr hn
      have hs : src∈caller := List.contains_iff_mem.mp (by rw [hm] at hc; exact hc)
      have same : p=q := Option.some.inj (by simpa [bindPointer] using hq)
      subst q
      exact C99PointerFootprint.pointer_outside before caller src index p address hs block offset outside
    · exact ho n hn q (by simpa [bindPointer,equal] using hq)

inductive Kind where
  | forward | inverse | generate
  deriving DecidableEq, Repr
def params : Kind → List Param
  | .forward => KeygenLevelNtt.params .forward
  | .inverse => KeygenLevelNtt.params .inverse
  | .generate => [.pointer "gm".toList,.pointer "igm".toList,.scalar .uint32 "logn".toList,
    .scalar .uint32 "full".toList,.scalar .uint32 "g".toList,
    .scalar .uint32 "p".toList,.scalar .uint32 "p0i".toList]
def body : Kind → C99ModularReference.Stmt
  | .forward => KeygenNttForwardPrograms.forwardBody
  | .inverse => KeygenLevelNtt.inverse
  | .generate => KeygenMkgm3Program.code
def writable : Kind → List Name
  | .forward | .inverse => KeygenLevelNtt.writable
  | .generate => ["gm".toList,"igm".toList]
theorem generator_checked : KeygenLevelModularFrame.only (writable .generate) (body .generate)=true := by decide
theorem checked (kind : Kind) : KeygenLevelModularFrame.only (writable kind) (body kind)=true := by
  cases kind
  · exact KeygenLevelNtt.forward_checked
  · exact KeygenLevelNtt.inverse_checked
  · exact generator_checked
inductive Call (kind : Kind) (before : State) (args : List Arg) : State → Prop where
  | run (entry : State) (out : Result) (binding : Bind before (params kind) args entry)
      (source : C99ModularReference.Exec (body kind) entry out)
      (returned : C99ProcedureReference.ReturnValue none out.flow none) :
      Call kind before args {before with heap := out.state.heap}
theorem call_frame (kind : Kind) (before after : State) (args : List Arg)
    (source : Call kind before args after) (names : List Name) (block offset : Nat)
    (allowed : arguments names (writable kind) (params kind) args=true)
    (outside : C99ArrayFrame.Outside before names block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  cases source with
  | run entry out binding execution returned =>
    obtain ⟨ho,_⟩ := bind_outside before entry (params kind) args binding names (writable kind)
      allowed block offset outside tables
    have keep := (KeygenLevelModularFrame.body_frame (body kind) entry out execution
      (writable kind) (checked kind) block offset ho).2.2
    rw [bind_heap before entry (params kind) args binding] at keep
    exact keep

end FT1536.Source3.KeygenLevelCalls
