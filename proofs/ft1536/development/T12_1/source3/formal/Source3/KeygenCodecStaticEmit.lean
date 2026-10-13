import Source3.KeygenCodecStaticCursor
import Source3.KeygenCodecNoneWhole

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Both destination modes and the exact expected single-byte trace.
   The non-NULL path derives capacity rejection before the write. -/
namespace FT1536.Source3.KeygenCodecStaticEmit
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecScalarCalculation KeygenCodecStaticByte KeygenCodecStaticWriteStep

def test : Expr := .binary .ne (.variable "buf".toList) (.variable "NULL".toList)
def optional (rhs : Expr) : Stmt := .branch test (.scope (KeygenCodecGuardedWrite.guarded rhs)) .skip

structure Ready (args : Args) (s : State) : Prop where
  buffer : s.buf=some args.out
  bufCell : s.locals.scalars "buf".toList=none
  nullCell : s.locals.scalars "NULL".toList=none
  capacity : Capacity args s

def writes (out : Option ArrayPointer) (u : BitVec 64) (word : BitVec 32) : List KeygenCodecByteHistory.Write :=
  out.toList.map (fun dst => (byteOff dst u.toNat,byte word))

def Emitted (args : Args) (s t : State) (u : BitVec 64) (word : BitVec 32) : Prop :=
  t.locals=s.locals ∧ t.buf=s.buf ∧
  KeygenCodecByteHistory.Trace s.heap t.heap (writes args.out u word) ∧
  (args.out=none ∨ u.toNat<args.capacity.toNat)

def Result (args : Args) (s t : State) (u : BitVec 64) (word : BitVec 32) (flow : Flow) : Prop :=
  (flow=.normal ∧ Emitted args s t u word) ∨
  (args.out≠none ∧ Rejected args s t u flow)

theorem buffer_eval (args : Args) (s : State) (l : Locals) (value : Value)
    (ready : Ready args s)
    (source : Eval args s.heap s.buf (.variable "buf".toList) s.locals value l) :
    value=.pointer args.out ∧ l=s.locals := by
  cases source with
  | scalar name l ty v held => rw [ready.bufCell] at held; cases held
  | buffer l p held => exact ⟨by rw [ready.buffer] at held; cases held; rfl,rfl⟩

theorem test_eval (args : Args) (s : State) (l : Locals) (value : Value) (ready : Ready args s)
    (source : Eval args s.heap s.buf test s.locals value l) :
    truth value=decide (args.out≠none) ∧ l=s.locals := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    obtain ⟨rfl,rfl⟩ := buffer_eval args s middle x ready first
    obtain ⟨rfl,last⟩ := KeygenCodecNoneWhole.null_eval args s l y ready.nullCell second
    cases operation
    exact ⟨by by_cases nonnull : args.out≠none <;>
      simp [boolean,truth,C99ScalarReference.boolean,C99IntegerReference.Value.integer,nonnull],last⟩

theorem optional_result (args : Args) (s t : State) (flow : Flow) (rhs : Expr)
    (u : BitVec 64) (word : BitVec 32) (ready : Ready args s) (cursor : Cursor u s)
    (calculation : Computes s.locals rhs (promoted word))
    (source : Exec args (optional rhs) s t flow) : Result args s t u word flow := by
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    obtain ⟨test,last⟩ := test_eval args s locals value ready evaluated
    rw [test] at yes
    have nonnull : args.out≠none := by simpa using yes
    subst locals
    cases selected with
    | scope args a s inner flow noBufShadow inside =>
      change Result args s inner u word flow
      rcases guarded_outcome args s inner flow rhs u word cursor ready.capacity calculation inside with accepted | rejected
      · obtain ⟨normal,bound,locals,buf,dst,buffer,store⟩ := accepted
        have out : args.out=some dst := by simpa only [ready.buffer,Option.some.injEq] using buffer
        exact Or.inl ⟨normal,locals,buf,by simpa only [writes,out,Option.toList_some,List.map_cons,List.map_nil] using
          (KeygenCodecByteHistory.Trace.step _ _ _ _ _ _ store (.nil _)),Or.inr bound⟩
      · exact Or.inr ⟨nonnull,rejected⟩
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    obtain ⟨test,last⟩ := test_eval args s locals value ready evaluated
    rw [test] at no
    have out : args.out=none := by simpa using no
    subst locals
    cases selected
    exact Or.inl ⟨rfl,rfl,rfl,by simpa only [writes,out,Option.toList_none,List.map_nil,withLocals] using (KeygenCodecByteHistory.Trace.nil s.heap),Or.inl out⟩

theorem source_sites :
    KeygenCodecStaticBinding.node053=optional (.cast .byte (.binary .shr (.variable "acc".toList) (.variable "acc_len".toList))) ∧
    KeygenCodecStaticBinding.node073=optional (.cast .byte (.variable "acc".toList)) ∧
    KeygenCodecStaticBinding.node113=optional (.cast .byte (.binary .shl (.variable "acc".toList)
      (.binary .sub (.number .i32 8) (.variable "acc_len".toList)))) := ⟨rfl,rfl,rfl⟩

end FT1536.Source3.KeygenCodecStaticEmit
