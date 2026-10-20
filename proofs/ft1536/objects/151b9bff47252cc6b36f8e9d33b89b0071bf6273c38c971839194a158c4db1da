import Source3.ShakeSeedReference

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Linux M0 system-seed control from Extra/c/frng.c (Falcon Project /
   Thomas Pornin). open/read/errno/close are the EXTERNAL interface, not
   ideal random draws. Byte writes are bounded POSIX read observations;
   errors, EINTR, short/zero reads and failed opens remain possible. Only
   finite source derivations are considered; no availability is asserted. -/
namespace FT1536.Source3.KeygenEntropySource
open C99MemoryReference
open C99ArrayReference (State)
open C99IntegerReference (Value)
open ShakePointFrame (Same)

def frngSha256 : String := "4b1289adf0c902abe9408d989b4eb8d292cbb6ea86b92e1325a10fd9c5dfc644"
def urandomLines : List String := [
  "#if USE_URANDOM\n","static int\n","urandom_get_seed(void *seed, size_t len)\n","{\n","\tint f;\n","\n",
  "\tif (len == 0) {\n","\t\treturn 1;\n","\t}\n",
  "\tf = open(\"/dev/urandom\", O_RDONLY);\n","\tif (f >= 0) {\n","\t\twhile (len > 0) {\n",
  "\t\t\tssize_t rlen;\n","\n","\t\t\trlen = read(f, seed, len);\n","\t\t\tif (rlen < 0) {\n",
  "\t\t\t\tif (errno == EINTR) {\n","\t\t\t\t\tcontinue;\n","\t\t\t\t}\n","\t\t\t\tbreak;\n","\t\t\t}\n",
  "\t\t\tseed = (unsigned char *)seed + rlen;\n","\t\t\tlen -= (size_t)rlen;\n","\t\t}\n",
  "\t\tclose(f);\n","\t\treturn len == 0;\n","\t} else {\n","\t\treturn 0;\n","\t}\n","}\n","#endif\n"]
def wrapperLines : List String := ["int\n","falcon_get_seed(void *seed, size_t len)\n","{\n",
  "\t/* (NIST_API_REMOVE_BEGIN) */\n","#if USE_URANDOM\n","\tif (urandom_get_seed(seed, len)) {\n","\t\treturn 1;\n","\t}\n",
  "#endif\n","#if USE_WIN32_RAND\n","\tif (win32_get_seed(seed, len)) {\n","\t\treturn 1;\n","\t}\n","#endif\n",
  "\t/* (NIST_API_REMOVE_END) */\n","\treturn 0;\n","}\n"]
def linuxWrapper : List String := ["int\n","falcon_get_seed(void *seed, size_t len)\n","{\n",
  "\tif (urandom_get_seed(seed, len)) {\n","\t\treturn 1;\n","\t}\n","\treturn 0;\n","}\n"]
/- Fixed active macro values are checked against the actual compiler
   environment in the Sage source controls. This is not a Windows theorem. -/
def linuxMacros : List (String × Int) := [("USE_URANDOM",1),("USE_WIN32_RAND",0),("O_RDONLY",0),("EINTR",4)]
def InputWrite (before : Memory) (p : ArrayPointer) (requested : Nat) (payload : List Byte) (after : Memory) : Prop :=
  payload.length≤requested ∧ requested<2^63 ∧ p.elementBytes=1 ∧
  p.offset+requested≤p.base+p.count ∧ p.offset+requested≤before.size p.block ∧
  before.size p.block<2^64 ∧ before.writable p.block=true ∧
  after.size=before.size ∧ after.writable=before.writable ∧
  (∀ i : Fin payload.length, after.bytes p.block (p.offset+i.val)=some payload[i.val]) ∧
  (∀ b o, b≠p.block ∨ o<p.offset ∨ p.offset+payload.length≤o → after.bytes b o=before.bytes b o)
inductive Event where
  | open (fd : BitVec 32)
  | read (fd : BitVec 32) (requested : BitVec 64) (rlen : BitVec 64) (errno : BitVec 32) (payload : List Byte)
  | close (fd : BitVec 32)
  deriving DecidableEq, Repr
inductive ReadIO (fd : BitVec 32) (before : State) (p : ArrayPointer) (len : BitVec 64) :
    State → BitVec 64 → BitVec 32 → List Byte → Prop where
  | error (rlen : BitVec 64) (errno : BitVec 32) (negative : rlen.toInt<0) : ReadIO fd before p len before rlen errno []
  | input (heap : Memory) (payload : List Byte) (errno : BitVec 32)
      (write : InputWrite before.heap p len.toNat payload heap) :
      ReadIO fd before p len {before with heap := heap} (BitVec.ofNat 64 payload.length) errno payload
def Compare (op : C99IntegerReference.Comparison) (x y : Value) (v : Value) : Prop := C99IntegerReference.CompareExec op x y v
inductive ReadLoop (fd : BitVec 32) : State → ArrayPointer → BitVec 64 → List Event → State → BitVec 64 → Prop where
  | done (s : State) (p : ArrayPointer) (len : BitVec 64) (v : Value)
      (guard : Compare .gt (.uint64 len) (.int32 0) v) (zero : v.integer=0) : ReadLoop fd s p len [] s len
  | failed (before read : State) (p : ArrayPointer) (len rlen : BitVec 64) (errno : BitVec 32) (payload : List Byte)
      (a b c : Value) (loopGuard : Compare .gt (.uint64 len) (.int32 0) a) (nonzero : a.integer≠0)
      (external : ReadIO fd before p len read rlen errno payload)
      (negative : Compare .lt (.int64 rlen) (.int32 0) b) (isNegative : b.integer≠0)
      (retry : Compare .eq (.int32 errno) (.int32 4) c) (notInterrupted : c.integer=0) :
      ReadLoop fd before p len [.read fd len rlen errno payload] read len
  | interrupted (before read after : State) (p : ArrayPointer) (len rlen final : BitVec 64)
      (errno : BitVec 32) (payload : List Byte) (events : List Event) (a b c : Value)
      (loopGuard : Compare .gt (.uint64 len) (.int32 0) a) (nonzero : a.integer≠0)
      (external : ReadIO fd before p len read rlen errno payload)
      (negative : Compare .lt (.int64 rlen) (.int32 0) b) (isNegative : b.integer≠0)
      (retry : Compare .eq (.int32 errno) (.int32 4) c) (isInterrupted : c.integer≠0)
      (rest : ReadLoop fd read p len events after final) :
      ReadLoop fd before p len (.read fd len rlen errno payload::events) after final
  | next (before read after : State) (p advanced : ArrayPointer) (len rlen next final : BitVec 64)
      (errno : BitVec 32) (payload : List Byte) (events : List Event) (a b : Value)
      (loopGuard : Compare .gt (.uint64 len) (.int32 0) a) (nonzero : a.integer≠0)
      (external : ReadIO fd before p len read rlen errno payload)
      (negative : Compare .lt (.int64 rlen) (.int32 0) b) (notNegative : b.integer=0)
      (address : PointerAdd p rlen.toInt.toNat advanced)
      (subtract : C99IntegerReference.ArithmeticExec .minus (.uint64 len)
        (C99IntegerReference.convert .uint64 rlen.toInt) (.uint64 next))
      (rest : ReadLoop fd read advanced next events after final) :
      ReadLoop fd before p len (.read fd len rlen errno payload::events) after final
inductive Urandom (before : State) (p : ArrayPointer) (len : BitVec 64) : List Event → State → Value → Prop where
  | empty (v : Value) (test : Compare .eq (.uint64 len) (.int32 0) v) (zeroLength : v.integer≠0) : Urandom before p len [] before (.int32 1)
  | openFailed (fd : BitVec 32) (a b : Value)
      (length : Compare .eq (.uint64 len) (.int32 0) a) (notEmpty : a.integer=0)
      (opened : Compare .ge (.int32 fd) (.int32 0) b) (failed : b.integer=0) :
      Urandom before p len [.open fd] before (.int32 0)
  | opened (fd : BitVec 32) (a b v : Value) (events : List Event) (after : State) (final : BitVec 64)
      (length : Compare .eq (.uint64 len) (.int32 0) a) (notEmpty : a.integer=0)
      (opened : Compare .ge (.int32 fd) (.int32 0) b) (success : b.integer≠0)
      (loop : ReadLoop fd before p len events after final)
      (returned : Compare .eq (.uint64 final) (.int32 0) v) :
      Urandom before p len (.open fd::events++[.close fd]) after v
inductive Call (before : State) (p : ArrayPointer) (len : Value) : List Event → State → Value → Prop where
  | success (events : List Event) (after : State) (v : Value)
      (source : Urandom before p (BitVec.ofInt 64 len.integer) events after v) (nonzero : v.integer≠0) :
      Call before p len events {before with heap := after.heap} (.int32 1)
  | failure (events : List Event) (after : State) (v : Value)
      (source : Urandom before p (BitVec.ofInt 64 len.integer) events after v) (zero : v.integer=0) :
      Call before p len events {before with heap := after.heap} (.int32 0)
theorem write_frame (before after : Memory) (p : ArrayPointer) (len : Nat) (payload : List Byte)
    (source : InputWrite before p len payload after) (b o : Nat) (outside : ShakeBlock.Outside p b o) : Same before after b o := by
  obtain ⟨count,small,width,extent,allocated,fit,writable,hs,hw,bytes,frame⟩ := source
  refine ⟨hs,hw,frame b o ?_⟩
  dsimp [ShakeBlock.Outside,ArrayPointer.offset] at outside extent ⊢
  simp only [width,Nat.one_mul] at outside extent ⊢
  omega
theorem read_frame (fd : BitVec 32) (before after : State) (p : ArrayPointer) (len rlen : BitVec 64)
    (errno : BitVec 32) (payload : List Byte) (source : ReadIO fd before p len after rlen errno payload)
    (b o : Nat) (outside : ShakeBlock.Outside p b o) : Same before.heap after.heap b o := by
  cases source with
  | error => exact ⟨rfl,rfl,rfl⟩
  | input heap payload errno write => exact write_frame _ _ _ _ _ write b o outside
theorem loop_frame (fd : BitVec 32) (before after : State) (p : ArrayPointer) (len final : BitVec 64)
    (events : List Event) (source : ReadLoop fd before p len events after final)
    (b o : Nat) (outside : ShakeBlock.Outside p b o) : Same before.heap after.heap b o := by
  induction source with
  | done => exact ⟨rfl,rfl,rfl⟩
  | failed _ _ _ _ _ _ _ _ _ _ _ _ external _ _ _ _ => exact read_frame _ _ _ _ _ _ _ _ external b o outside
  | interrupted _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ external _ _ _ _ _ ih =>
    exact ShakePointFrame.trans _ _ _ b o (read_frame _ _ _ _ _ _ _ _ external b o outside) (ih outside)
  | next _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ external _ _ address _ _ ih =>
    have keep := read_frame _ _ _ _ _ _ _ _ external b o outside
    cases address
    exact ShakePointFrame.trans _ _ _ b o keep (ih outside)
theorem urandom_frame (before after : State) (p : ArrayPointer) (len : BitVec 64) (events : List Event) (v : Value)
    (source : Urandom before p len events after v) (b o : Nat) (outside : ShakeBlock.Outside p b o) : Same before.heap after.heap b o := by
  cases source with
  | empty | openFailed => exact ⟨rfl,rfl,rfl⟩
  | opened fd a b v events after final length notEmpty opened success loop returned => exact loop_frame _ _ _ _ _ _ _ loop _ _ outside
theorem call_frame (before after : State) (p : ArrayPointer) (len : Value) (events : List Event) (v : Value)
    (source : Call before p len events after v) (b o : Nat) (outside : ShakeBlock.Outside p b o) : Same before.heap after.heap b o := by
  cases source with
  | success after v source nonzero | failure after v source zero => exact urandom_frame _ _ _ _ _ _ source _ _ outside
theorem call_value (before after : State) (p : ArrayPointer) (len : Value) (events : List Event) (v : Value)
    (source : Call before p len events after v) : v=.int32 0 ∨ v=.int32 1 := by
  cases source with | success => exact Or.inr rfl | failure => exact Or.inl rfl
theorem call_slots (before after : State) (p : ArrayPointer) (len : Value) (events : List Event) (v : Value)
    (source : Call before p len events after v) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.globals=before.globals ∧ after.tables=before.tables := by
  cases source <;> exact ⟨rfl,rfl,rfl,rfl⟩

end FT1536.Source3.KeygenEntropySource
