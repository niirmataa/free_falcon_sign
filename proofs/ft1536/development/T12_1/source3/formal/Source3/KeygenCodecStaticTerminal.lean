import Source3.KeygenCodecStaticAppend

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticTerminal
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference

theorem decrement_rule : C99IntegerReference.ArithmeticExec .plus
    (.int32 (-1)) (.int32 (-1)) (.int32 (-2)) := by
  apply (C99IntegerReference.arithmetic_iff _ _ _ _).mpr
  constructor
  · intro _
    change (-2147483648≤(-2 : Int) ∧ (-2 : Int)<2147483648)
    decide +kernel
  · rfl

theorem postdecrement (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (l t : Locals) (v : C99IntegerReference.Value)
    (cell : l.scalars "ne".toList=some (.int32,some (.int32 (-1))))
    (source : Eval args heap buf (.postDec (.variable "ne".toList)) l (.integer v) t) :
    v=.int32 (-1) ∧ t.scalars "ne".toList=some (.int32,some (.int32 (-2))) := by
  cases source with
  | postDec name l t value next operation =>
    cases operation with
    | scalar name delta l ty v z bound operation =>
      have equal : ty=.int32 ∧ v=.int32 (-1) := by
        simpa only [Option.some.injEq,Prod.mk.injEq,Option.some.injEq] using bound.symm.trans cell
      obtain ⟨rfl,rfl⟩ := equal
      have same := C99IntegerReference.arithmetic_deterministic _ _ _ _ _ operation decrement_rule
      subst z
      exact ⟨rfl,by simp [localSet,C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]⟩

theorem terminal_test (args : Args) (s : State) (l : Locals) (value : Value)
    (cell : s.locals.scalars "ne".toList=some (.int32,some (.int32 (-1))))
    (source : Eval args s.heap s.buf KeygenCodecStaticBinding.guard087 s.locals value l) :
    truth value=false ∧ l.scalars "ne".toList=some (.int32,some (.int32 (-2))) := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    cases operation with
    | ge x y z compared =>
      obtain ⟨hx,hm⟩ := postdecrement args s.heap s.buf s.locals middle x cell first
      subst x
      obtain ⟨hy,ht⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 0 (.int32 0) middle l (.integer y) (by decide +kernel) second
      have integer : y=.int32 0 := Value.integer.inj hy
      subst y
      subst l
      cases compared
      simp_all [truth,C99IntegerReference.usual,C99IntegerReference.promote,C99IntegerReference.convert,
        C99IntegerReference.Value.type,C99IntegerReference.Value.integer,C99IntegerReference.compare]

/-- A real final failing guard with ne=-1 leaves ne=-2. Deriving the old
    -1 cell from the complete unary loop remains a separate obligation. -/
theorem terminal_exit (args : Args) (s t : State) (flow : Flow)
    (cell : s.locals.scalars "ne".toList=some (.int32,some (.int32 (-1))))
    (source : Exec args KeygenCodecStaticBinding.node087 s t flow) :
    flow=.normal ∧ t.locals.scalars "ne".toList=some (.int32,some (.int32 (-2))) := by
  cases source with
  | whileDone args test a s value locals evaluated no => exact ⟨rfl,(terminal_test args s locals value cell evaluated).2⟩
  | whileNext args test a s middle t flow value locals evaluated yes iteration rest =>
    have zero := (terminal_test args s locals value cell evaluated).1
    rw [zero] at yes
    cases yes
  | whileReturn args test a s t ret value locals evaluated yes iteration =>
    have zero := (terminal_test args s locals value cell evaluated).1
    rw [zero] at yes
    cases yes

end FT1536.Source3.KeygenCodecStaticTerminal
