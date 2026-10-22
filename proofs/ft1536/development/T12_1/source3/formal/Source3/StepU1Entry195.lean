import Source3.SelectedStepAddPrime195
import Source3.StepGeneratorEntry188

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The modp_mkgm3 wrapper call of the make_fg_step additional-prime loop
   body at the u = 1 cell (MakeFgAddPrimeShape194.generateArgs): the
   callee entry state over the caller state s, the KeygenLevelCalls.Bind
   of the pinned seven-argument list, the primes[1].g PrimeRead at the
   u = 1 index and the Call wrapper around a body execution. The words
   are the executed words of the u = 1 row of the block-21 ternary
   table: p1/p0i1/r21 from SelectedStepAddPrime195, g1 = the row-1 .g
   word, r1 = KeygenModpR.word p1 (the modp_R leaf at p1). Values stay
   executed words: no transform property, table law, root law or
   positivity claim is made here. The caller-state cells, the row-1
   table-word loads and the static memory facts are hypotheses of this
   layer; their transport to the concrete part-3 CRT exit state is the
   keep chain of the section export, matching the SelectedStepAddPrime195
   scope note. -/
namespace FT1536.Source3.StepU1Entry195
open C99ArrayReference (State bindValue bindPointer)
open C99MemoryReference (ArrayPointer Load32 Allocated)
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenFullData127 (primes rev)
open SelectedStepLayout187 (gm igm)
open C99NatWord141 (word)
open KeygenStaticTables (PrimeObject primeField fieldValue values)
open KeygenModpR2Exec (Slot)

/- The u = 1 generator words. -/
def g1 : BitVec 32 := BitVec.ofNat 32 1119654270
def r1 : BitVec 32 := KeygenModpR.word SelectedStepAddPrime195.p1
def p1 : BitVec 32 := SelectedStepAddPrime195.p1
def p0i1 : BitVec 32 := SelectedStepAddPrime195.p0i1
def r21 : BitVec 32 := SelectedStepAddPrime195.r21

theorem g1_word : BitVec.ofNat 32 (fieldValue (2147346433,1119654270,238827065) .g)=g1 := rfl
theorem r1_word : r1=SelectedStepAddPrime195.rx1 := rfl
theorem fieldPointer_one_g :
    KeygenLevelCalls.fieldPointer SelectedStepAddPrime195.primes1 .g=primeField primes 1 .g := rfl

/- The row-1 .g word from the table object at an arbitrary heap. -/
theorem g_object_word (s : State) (object : PrimeObject s.heap primes .ternary) :
    Load32 s.heap (primeField primes 1 .g) g1 := by
  rw [← g1_word]
  exact object.2.2.2.2.2.2 1 (2147346433,1119654270,238827065) SelectedStepAddPrime195.row1_value .g

/- The hypotheses of the call layer at the caller state s. -/
structure Input (s : State) : Prop where
  pCell : Slot s "p" p1
  iCell : Slot s "p0i" p0i1
  lognCell : Slot s "logn" 9
  uCell : s.locals "u".toList=some (.uint64,some (.uint64 (word 1)))
  terCell : s.locals "ter".toList=some (.uint32,some (.uint32 1))
  gmBind : s.arrays "gm".toList=some gm
  igmBind : s.arrays "igm".toList=some igm
  primesBind : s.arrays "primes".toList=some primes
  revBind : s.tables "REV10".toList=some rev
  gLoad : Load32 s.heap (primeField primes 1 .g) g1
  revSource : KeygenMkgm3RevMemory.SourceTable s.heap rev
  scratch : ∀ index : Nat, index<71680 →
    Allocated s.heap {KeygenFullData127.env.ctx.scratch with index:=index}
  writable : s.heap.writable 31=true
  rawInit : GeneratorSquareDomains181.From s.heap gm igm 0

/- Callee entry state (the Bind of generateArgs at s). -/
noncomputable def empty (s : State) : State :=
  ⟨s.heap,s.globals,s.tables,s.globals,s.tables⟩
noncomputable def withI (s : State) : State := bindValue (empty s) "p0i".toList .uint32 (.uint32 p0i1)
noncomputable def withP (s : State) : State := bindValue (withI s) "p".toList .uint32 (.uint32 p1)
noncomputable def withG (s : State) : State := bindValue (withP s) "g".toList .uint32 (.uint32 g1)
noncomputable def withFull (s : State) : State := bindValue (withG s) "full".toList .uint32 (.int32 0)
noncomputable def withLogn (s : State) : State := bindValue (withFull s) "logn".toList .uint32 (.uint32 9)
noncomputable def withIgm (s : State) : State := bindPointer (withLogn s) "igm".toList igm
noncomputable def entry (s : State) : State := bindPointer (withIgm s) "gm".toList gm

theorem generator_read (s : State) (input : Input s) :
    KeygenLevelCalls.PrimeRead s "primes".toList (MakeFgAddPrimeShape194.var "u") .g (.uint32 g1) :=
  KeygenLevelCalls.PrimeRead.read SelectedStepAddPrime195.primes1 g1
    (C99ArrayReference.Pointer.add "primes".toList (MakeFgAddPrimeShape194.var "u") primes
      SelectedStepAddPrime195.primes1 (.uint64 (word 1)) input.primesBind
      (C99ScalarReference.Eval.variable "u".toList .uint64 (.uint64 (word 1)) input.uCell)
      (by decide) (C99MemoryReference.PointerAdd.within primes 1 (by decide)))
    SelectedStepAddPrime195.primes1_width SelectedStepAddPrime195.primes1_extent
    (by rw [fieldPointer_one_g]; exact input.gLoad)

theorem binding (s : State) (input : Input s) :
    KeygenLevelCalls.Bind s (KeygenLevelCalls.params .generate) MakeFgAddPrimeShape194.generateArgs
      (entry s) :=
  .pointer "gm".toList "gm".toList C99ProcedureParser.zero gm _ _ _
    (RootBinding175.zero s "gm" gm input.gmBind (by decide))
    (.pointer "igm".toList "igm".toList C99ProcedureParser.zero igm _ _ _
      (RootBinding175.zero s "igm" igm input.igmBind (by decide))
      (.scalar .uint32 "logn".toList _ _ _ _ (.uint32 9)
        (.modular _ _ (.scalar _ _ (.variable _ _ _ input.lognCell)))
        (.scalar .uint32 "full".toList _ _ _ _ (.int32 0)
          (.modular _ _ (.scalar _ _ (.literal .int32 0)))
          (.scalar .uint32 "g".toList _ _ _ _ (.uint32 g1)
            (.prime _ _ _ _ (generator_read s input))
            (.scalar .uint32 "p".toList _ _ _ _ (.uint32 p1)
              (.modular _ _ (.scalar _ _ (.variable _ _ _ input.pCell)))
              (.scalar .uint32 "p0i".toList _ [] [] (empty s) (.uint32 p0i1)
                (.modular _ _ (.scalar _ _ (.variable _ _ _ input.iCell))) .nil))))))

theorem source_call (s : State) (input : Input s) (out : Result)
    (source : C99ModularReference.Exec KeygenMkgm3Program.code (entry s) out)
    (returned : C99ProcedureReference.ReturnValue none out.flow none) :
    KeygenLevelCalls.Call .generate s MakeFgAddPrimeShape194.generateArgs
      {s with heap:=out.state.heap} :=
  .run (entry s) out (binding s input) source returned

/- Static memory facts of the callee entry (from the caller hypotheses). -/
theorem entry_heap (s : State) : (entry s).heap=s.heap := rfl

theorem rev_binding (s : State) (input : Input s) : (entry s).arrays "REV10".toList=some rev :=
  input.revBind

theorem rev_source (s : State) (input : Input s) :
    KeygenMkgm3RevMemory.SourceTable (entry s).heap rev := by
  rw [entry_heap]
  exact input.revSource

theorem allocated (s : State) (input : Input s) (index : Nat) (inside : index<71680) :
    Allocated (entry s).heap {KeygenFullData127.env.ctx.scratch with index:=index} := by
  rw [entry_heap]
  exact input.scratch index inside

theorem writable (s : State) (input : Input s) : (entry s).heap.writable 31=true := by
  rw [entry_heap]
  exact input.writable

theorem raw_initialized (s : State) (input : Input s) :
    GeneratorSquareDomains181.From (entry s).heap gm igm 0 := by
  rw [entry_heap]
  exact input.rawInit

end FT1536.Source3.StepU1Entry195
