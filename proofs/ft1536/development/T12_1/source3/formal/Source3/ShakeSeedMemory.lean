import Source3.ShakePointFrame

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Byte library rules and the fixed dec64le/xor_block source callees used
   by injection and padding. No Keccak or random-output oracle is used. -/
namespace FT1536.Source3.ShakeSeedMemory
open C99MemoryReference
open C99ArrayReference (State Name bindValue bindPointer)
open C99IntegerReference (Value)
open ShakePointFrame (Same)

def Fill (before : Memory) (p : ArrayPointer) (n : Nat) (v : Byte) (after : Memory) : Prop :=
  p.offset+n≤p.base+p.elementBytes*p.count ∧ p.offset+n≤before.size p.block ∧
  before.size p.block<2^64 ∧ before.writable p.block=true ∧
  after.size=before.size ∧ after.writable=before.writable ∧
  (∀ i<n, after.bytes p.block (p.offset+i)=some v) ∧
  (∀ b o, b≠p.block ∨ o<p.offset ∨ p.offset+n≤o → after.bytes b o=before.bytes b o)
inductive Read8 (s : State) : C99ScalarReference.CallRelation where
  | byte (i : Value) (root p : ArrayPointer) (v : Byte)
      (binding : s.arrays "buf".toList=some root) (positive : 0 ≤ i.integer)
      (address : PointerAdd root i.integer.toNat p) (legal : Allocated s.heap p)
      (width : p.elementBytes=1) (bytes : s.heap.bytes p.block p.offset=some v) :
      Read8 s "$seed_byte".toList [i] (.int32 (BitVec.ofNat 32 v.toNat))
def byte (i : Nat) : C99ScalarReference.Expr := .cast .uint64
  (.call1 "$seed_byte".toList (.literal .int32 i))
def shifted (i : Nat) : C99ScalarReference.Expr :=
  if i=0 then byte i else .shift .left (byte i) (.literal .int32 (8*i))
def decoded : C99ScalarReference.Expr :=
  (List.range 8).foldl (fun a i => .bitwise .or a (shifted i)) (shifted 0)
def decodeExpr : C99ScalarReference.Expr :=
  .bitwise .or (.bitwise .or (.bitwise .or (.bitwise .or (.bitwise .or
    (.bitwise .or (.bitwise .or (shifted 0) (shifted 1)) (shifted 2)) (shifted 3))
    (shifted 4)) (shifted 5)) (shifted 6)) (shifted 7)
def decodeEntry (s : State) (p : ArrayPointer) : State :=
  {s with locals := fun _ => none, arrays := fun n => if n="data".toList then some p else none}
def declareBuf : C99ArrayReference.Stmt := .declarePtr "buf".toList
def assignBuf : C99ArrayReference.Stmt := .bindPtr "buf".toList "data".toList C99ProcedureParser.zero
inductive Decode (before : State) (p : ArrayPointer) : BitVec 64 → Prop where
  | run (declared ready : State) (w : BitVec 64)
      (declaration : C99ArrayReference.Exec (fun _ => none) declareBuf (decodeEntry before p) declared)
      (assignment : C99ArrayReference.Exec (fun _ => none) assignBuf declared ready)
      (result : C99ScalarReference.Eval (Read8 ready) ready.locals decodeExpr (.uint64 w)) : Decode before p w
theorem decode_source : (ShakeSource.sourceLines.drop 56).take 15 = [
  "static inline uint64_t\n","dec64le(const void *data)\n","{\n","\tconst unsigned char *buf;\n","\n",
  "\tbuf = data;\n","\treturn (uint64_t)buf[0]\n","\t\t| ((uint64_t)buf[1] << 8)\n",
  "\t\t| ((uint64_t)buf[2] << 16)\n","\t\t| ((uint64_t)buf[3] << 24)\n",
  "\t\t| ((uint64_t)buf[4] << 32)\n","\t\t| ((uint64_t)buf[5] << 40)\n",
  "\t\t| ((uint64_t)buf[6] << 48)\n","\t\t| ((uint64_t)buf[7] << 56);\n","}\n"] := by decide

def xorEntry (s : State) (a data : ArrayPointer) (rate : Value) : State :=
  {s with
    locals := C99ScalarReference.set (fun _ => none) "rate".toList
      (.uint64,some (C99IntegerReference.convert .uint64 rate.integer))
    arrays := fun n => if n="A".toList then some a else if n="data".toList then some data else none}
def declaration : C99ModularReference.Stmt := .base (.scalar (.declare .u64 ["u".toList]))
def initial : C99ModularReference.Stmt := .assign "u".toList (.scalar (.literal .i32 0))
def condition : CLogic.Expr := .cmp .lt (.var "u".toList) (.var "rate".toList)
def increment : C99ModularReference.Stmt := .base (.scalar (.update "u".toList .add (.literal .i32 8)))
def index : CLogic.Expr := .bin .shr (.var "u".toList) (.literal .i32 3)
inductive XorStep (before : State) : State → Prop where
  | run (a data : ArrayPointer) (old decoded : BitVec 64) (v : Value) (heap : Memory)
      (destination : C99ArrayReference.Pointer before "A".toList index a)
      (source : C99ArrayReference.Pointer before "data".toList (.var "u".toList) data)
      (read : Load64 before.heap a old) (decode : Decode before data decoded)
      (operation : C99IntegerReference.BitwiseExec .xor (.uint64 old) (.uint64 decoded) v)
      (write : Store64 before.heap a (BitVec.ofInt 64 v.integer) heap) :
      XorStep before {before with heap := heap}
inductive XorLoop : State → State → Prop where
  | done (s : State) (v : Value) (guard : C99ArrayReference.scalar s condition v) (zero : v.integer=0) : XorLoop s s
  | next (before middle next after : State) (v : Value)
      (guard : C99ArrayReference.scalar before condition v) (nonzero : v.integer≠0)
      (body : XorStep before middle)
      (update : C99ModularReference.Exec increment middle ⟨next,.normal⟩)
      (rest : XorLoop next after) : XorLoop before after
inductive XorCall (before : State) (a data : ArrayPointer) (rate : Value) : State → Prop where
  | run (declared ready after : State)
      (decl : C99ModularReference.Exec declaration (xorEntry before a data rate) ⟨declared,.normal⟩)
      (init : C99ModularReference.Exec initial declared ⟨ready,.normal⟩)
      (loop : XorLoop ready after) : XorCall before a data rate {before with heap := after.heap}
theorem xor_source : (ShakeSource.sourceLines.drop 95).take 9 = [
  "static void\n","xor_block(uint64_t *A, const void *data, size_t rate)\n","{\n","\tsize_t u;\n","\n",
  "\tfor (u = 0; u < rate; u += 8) {\n",
  "\t\tA[u >> 3] ^= dec64le((const unsigned char *)data + u);\n","\t}\n","}\n"] := by decide

theorem fill_frame (before after : Memory) (p : ArrayPointer) (n : Nat) (v : Byte)
    (source : Fill before p n v after) (b o : Nat) (outside : ShakeBlock.Outside p b o) : Same before after b o := by
  refine ⟨source.2.2.2.2.1,source.2.2.2.2.2.1,source.2.2.2.2.2.2.2 b o ?_⟩
  dsimp [ShakeBlock.Outside] at outside
  have extent := source.1
  dsimp [ArrayPointer.offset] at extent ⊢
  omega
theorem pointer_outside (s : State) (name : Name) (expr : CLogic.Expr) (root p : ArrayPointer)
    (binding : s.arrays name=some root) (source : C99ArrayReference.Pointer s name expr p)
    (b o : Nat) (outside : ShakeBlock.Outside root b o) : ShakeBlock.Outside p b o := by
  cases source with
  | add original p i actual value positive within =>
    have equal : original=root := Option.some.inj (actual.symm.trans binding)
    subst original; cases within; exact outside
theorem step_slots (before after : State) (source : XorStep before after) : after.arrays=before.arrays := by cases source; rfl
theorem step_frame (before after : State) (a : ArrayPointer) (binding : before.arrays "A".toList=some a)
    (source : XorStep before after) (b o : Nat) (outside : ShakeBlock.Outside a b o) : Same before.heap after.heap b o := by
  cases source with
  | run actual data old decoded v heap destination readData read decode operation write =>
    exact ShakePointFrame.store64 _ _ _ _ b o write (pointer_outside _ _ _ _ _ binding destination b o outside)
theorem loop_frame (before after : State) (a : ArrayPointer) (binding : before.arrays "A".toList=some a)
    (source : XorLoop before after) (b o : Nat) (outside : ShakeBlock.Outside a b o) : Same before.heap after.heap b o := by
  induction source with
  | done => exact ⟨rfl,rfl,rfl⟩
  | next before middle next after v guard nonzero body update rest ih =>
    have first := step_frame before middle a binding body b o outside
    have middleBinding := (congrFun (step_slots before middle body) _).trans binding
    have updateFrame := C99ModularFrame.source_frame increment middle ⟨next,.normal⟩ update (by decide)
    have last := ih ((congrFun updateFrame.2 _).trans middleBinding)
    have heap : next.heap=middle.heap := updateFrame.1
    rw [heap] at last
    exact ShakePointFrame.trans _ _ _ b o first last
theorem xor_frame (before after : State) (a data : ArrayPointer) (rate : Value)
    (source : XorCall before a data rate after) (b o : Nat) (outside : ShakeBlock.Outside a b o) : Same before.heap after.heap b o := by
  cases source with
  | run declared ready after decl init loop =>
    have first := C99ModularFrame.source_frame declaration (xorEntry before a data rate) ⟨declared,.normal⟩ decl (by decide)
    have second := C99ModularFrame.source_frame initial declared ⟨ready,.normal⟩ init (by decide)
    have binding : ready.arrays "A".toList=some a :=
      (congrFun second.2 _).trans ((congrFun first.2 _).trans (by simp [xorEntry]))
    have keep := loop_frame ready after a binding loop b o outside
    have heap : ready.heap=before.heap := second.1.trans first.1
    rw [heap] at keep
    exact keep

end FT1536.Source3.ShakeSeedMemory
