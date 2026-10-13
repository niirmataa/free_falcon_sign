import Source3.KeygenDecodeNoneMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Source-derived NONE loop test and uint64 increment. Natural counters
   remain in0..1536 and cannot wrap on this actual source path. -/
namespace FT1536.Source3.KeygenDecodeNoneCounter
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeCalculation KeygenDecodeNoneCore KeygenDecodeNoneReady

def test : Expr := .binary .lt (.variable "u".toList) (.variable "n".toList)
def loopCode : Stmt := .whileLoop test (.seq KeygenDecodeNoneBinding.node041 KeygenDecodeNoneBinding.loop042Update)

theorem self_uint64 (word : BitVec 64) :
    C99IntegerReference.convert .uint64 (C99IntegerReference.Value.uint64 word).integer=.uint64 word := by
  simp only [C99IntegerReference.convert,C99IntegerReference.Value.integer,
    BitVec.ofInt_natCast,BitVec.ofNat_toNat,BitVec.setWidth_eq]

theorem less64 (n : Nat) (bound : n≤1536) :
    C99IntegerReference.CompareExec .lt (.uint64 (BitVec.ofNat 64 n)) (.uint64 1536)
      (.int32 (if n<1536 then 1 else 0)) := by
  have source := C99IntegerReference.CompareExec.step .lt (.uint64 (BitVec.ofNat 64 n)) (.uint64 1536)
    .uint64 rfl (.uint64 (BitVec.ofNat 64 n)) (.uint64 1536) (self_uint64 _).symm rfl
  have ni := KeygenCodecNoneCursor.unsigned_nat64 n (by omega)
  have limit : (C99IntegerReference.Value.uint64 1536).integer=(1536 : Int) := rfl
  by_cases less : n<1536
  · have signedLess : (n : Int)<1536 := by omega
    simpa only [C99IntegerReference.compare,ni,limit,signedLess,decide_true,ite_true,less,show (1#32 : BitVec 32)=(1 : BitVec 32) by decide +kernel] using source
  · have signedLess : ¬(n : Int)<1536 := by omega
    simpa only [C99IntegerReference.compare,ni,limit,signedLess,decide_false,ite_false,less,Bool.false_eq_true,show (0#32 : BitVec 32)=(0 : BitVec 32) by decide +kernel] using source

theorem test_calculation (args : Args) (s : State) (n : Nat) (bound : n≤1536)
    (src dst : ArrayPointer) (ready : Ready args n src dst s) :
    Computes args s.heap s.buf s.locals test (.int32 (if n<1536 then 1 else 0)) :=
  .binary _ _ _ _ _ _ (.scalar _ _ _ (by unfold Ordinary; decide +kernel) ready.cursor)
    (.scalar _ _ _ (by unfold Ordinary; decide +kernel) ready.count) (.lt _ _ _ (less64 n bound))

theorem test_eval (args : Args) (s : State) (l : Locals) (value : Value) (n : Nat) (bound : n≤1536)
    (src dst : ArrayPointer) (ready : Ready args n src dst s)
    (source : Eval args s.heap s.buf test s.locals value l) :
    truth value=decide (n<1536) ∧ l=s.locals := by
  obtain ⟨same,last⟩ := computes_eval args s.heap s.buf s.locals _ _ (test_calculation args s n bound src dst ready) l value source
  subst value
  refine ⟨?_,last⟩
  by_cases less : n<1536 <;> simp [truth,less,C99IntegerReference.Value.integer]

def next (s : State) (n : Nat) : State :=
  withLocals s (localSet s.locals "u".toList .uint64 (some (.uint64 (BitVec.ofNat 64 (n+1)))))

theorem other_cell (s : State) (n : Nat) (name : String) (ty : C99IntegerReference.Ty)
    (value : C99IntegerReference.Value) (different : name.toList≠"u".toList)
    (cell : Cell name ty value s.locals) : Cell name ty value (next s n).locals := by
  simpa only [Cell,next,withLocals,localSet,C99ScalarReference.set,different,ite_false] using cell

theorem next_ready (args : Args) (s : State) (n : Nat) (src dst : ArrayPointer)
    (ready : Ready args n src dst s) : Ready args (n+1) src dst (next s n) := by
  refine ⟨?_,other_cell s n "q" _ _ (by decide +kernel) ready.q,
    other_cell s n "hq" _ _ (by decide +kernel) ready.hq,
    other_cell s n "tq" _ _ (by decide +kernel) ready.tq,
    other_cell s n "n" _ _ (by decide +kernel) ready.count,
    other_cell s n "len" _ _ (by decide +kernel) ready.length,ready.buffer,ready.destination⟩
  simp only [KeygenDecodeNoneRead.Cursor,Cell,next,withLocals,localSet,C99ScalarReference.set,ite_true]

/-- The source u++ derives the exact next activation without wrap. -/
theorem update_source (args : Args) (s t : State) (flow : Flow) (n : Nat) (bound : n<1536)
    (cursor : KeygenDecodeNoneRead.Cursor n s.locals)
    (source : Exec args KeygenDecodeNoneBinding.loop042Update s t flow) : t=next s n ∧ flow=.normal := by
  cases source with
  | evaluate s e value locals evaluated =>
    cases evaluated with
    | postInc name l t value nextValue updated =>
      cases updated with
      | scalar name delta l ty v z held operation =>
        have same := Option.some.inj (held.symm.trans cursor)
        cases same
        have canonical := KeygenDecodeNoneRead.plus64 n 1 (by omega) (by decide +kernel)
        have equal := C99IntegerReference.arithmetic_deterministic _ _ _ _ _ operation canonical
        subst z
        simp only [next,withLocals,self_uint64]
        trivial

theorem update_exists (args : Args) (s : State) (n : Nat) (bound : n<1536)
    (cursor : KeygenDecodeNoneRead.Cursor n s.locals) :
    Exec args KeygenDecodeNoneBinding.loop042Update s (next s n) .normal := by
  have update := Update.scalar "u".toList 1 s.locals .uint64
    (.uint64 (BitVec.ofNat 64 n)) (.uint64 (BitVec.ofNat 64 (n+1))) cursor
    (KeygenDecodeNoneRead.plus64 n 1 (by omega) (by decide +kernel))
  have nextUpdate : Update "u".toList 1 s.locals
      (.integer (.uint64 (BitVec.ofNat 64 n))) (.integer (.uint64 (BitVec.ofNat 64 (n+1))))
      (next s n).locals := by
    simpa only [next,withLocals,self_uint64] using update
  have evaluated : Eval args s.heap s.buf (.postInc (.variable "u".toList)) s.locals
      (.integer (.uint64 (BitVec.ofNat 64 n))) (next s n).locals :=
    .postInc "u".toList s.locals (next s n).locals
      (.integer (.uint64 (BitVec.ofNat 64 n))) (.integer (.uint64 (BitVec.ofNat 64 (n+1)))) nextUpdate
  exact .evaluate args s _ _ _ evaluated

end FT1536.Source3.KeygenDecodeNoneCounter
