import Source3.KeygenOutputGateSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.KeygenOutputGateBounds
open C99ArrayReference (State Bind)
open C99MemoryReference
open C99IntegerReference (Value)
open C99ProcedureReference (Result)
open KeygenOutputGateSource

def destinationName (second : Bool) : String := if second then "G" else "F"
def sourceIndex (second : Bool) : Nat := if second then 1536 else 0

structure Caller (s : State) (bigF bigG : ArrayPointer) : Prop where
  logn : KeygenNttForwardExec.lognAt s
  size : C99CountedWords.Limit s
  first : s.arrays "F".toList=some bigF
  second : s.arrays "G".toList=some bigG

theorem view_logn (ctx : Context) (s : State) (profile : KeygenNttForwardExec.lognAt s) :
    KeygenNttForwardExec.lognAt (view ctx s) := by
  simpa [KeygenNttForwardExec.lognAt,view,C99ScalarReference.set] using profile

theorem index_value (ctx : Context) (s : State) (second : Bool) (v : Value)
    (size : C99CountedWords.Limit s)
    (source : C99ArrayReference.scalar (view ctx s) (if second then .var "n".toList else zero) v) :
    v.integer=sourceIndex second := by
  cases second with
  | false =>
      have he := KeygenNttForwardExec.literal_value (view ctx s) .u64 0 v source
      subst v
      rfl
  | true =>
      have hn : (view ctx s).locals "n".toList=some (.uint64,some (.uint64 1536)) := by
        simpa [view,C99ScalarReference.set,C99CountedWords.Limit] using size
      have he := C99CountedWords.variable_exact (view ctx s) "n".toList .uint64 (.uint64 1536) v hn source
      subst v
      rfl

theorem binding_entry (ctx : Context) (s entry : State) (second : Bool) (dst : ArrayPointer)
    (m0 : ctx.ternary=1) (logn : KeygenNttForwardExec.lognAt s) (size : C99CountedWords.Limit s)
    (destination : s.arrays (destinationName second).toList=some dst)
    (binding : Bind (view ctx s) KeygenSmallCalls.params ((arguments second).map lower) entry) :
    KeygenSmallBounds.Profile entry ∧ entry.arrays "d".toList=some dst ∧
      entry.arrays "s".toList=some (KeygenSmallOutput.element ctx.tmp (sourceIndex second)) := by
  cases binding with
  | pointer _ _ _ dp _ _ _ dv tail =>
    cases tail with
    | pointer _ _ _ sp _ _ _ sv tail =>
      cases tail with
      | scalar _ _ _ _ _ _ lv le tail =>
        cases tail with
        | scalar _ _ _ _ _ _ tv te tail =>
          cases tail
          have db : (view ctx s).arrays (destinationName second).toList=some dst := by
            cases second <;> simpa [destinationName,view] using destination
          have dv' : C99ArrayReference.Pointer (view ctx s) (destinationName second).toList zero dp := by
            cases second <;> exact dv
          have dp0 := KeygenSolverNttCalls.pointer_zero (view ctx s) (destinationName second) dst dp db dv'
          have tb : (view ctx s).arrays "$fk.tmp".toList=some ctx.tmp := by simp [view]
          obtain ⟨iv,ie,sp0⟩ := KeygenNttLoopSupport.pointer_root (view ctx s) "$fk.tmp".toList _ ctx.tmp sp tb sv
          have iv0 := index_value ctx s second iv size ie
          have sp1 : sp=KeygenSmallOutput.element ctx.tmp (sourceIndex second) := by
            rw [iv0] at sp0
            exact sp0
          have lv0 := C99CountedWords.variable_exact (view ctx s) "logn".toList .uint32 (.uint32 10) lv
            (view_logn ctx s logn) le
          have tv0 := C99CountedWords.variable_exact (view ctx s) "$fk.ternary".toList .uint32 (.uint32 ctx.ternary) tv
            (by simp [view,C99ScalarReference.set]) te
          clear sp0
          subst dp sp lv tv
          refine ⟨⟨rfl,?_⟩,rfl,rfl⟩
          change some (C99IntegerReference.Ty.uint32,some (C99IntegerReference.convert .uint32 (Value.uint32 ctx.ternary).integer))=
            some (C99IntegerReference.Ty.uint32,some (Value.uint32 1))
          rw [m0]
          rfl

theorem call_writes (ctx : Context) (s after : State) (second : Bool) (dst : ArrayPointer) (v : Value)
    (m0 : ctx.ternary=1) (logn : KeygenNttForwardExec.lognAt s) (size : C99CountedWords.Limit s)
    (destination : s.arrays (destinationName second).toList=some dst)
    (source : Call ctx (arguments second) s after v) (nonzero : v.integer≠0) :
    KeygenSmallBounds.Writes dst 0 s.heap after.heap := by
  cases source with
  | run entry out value binding body returned =>
      have fields := binding_entry ctx s entry second dst m0 logn size destination binding
      have one := KeygenSmallCalls.return_one entry out dst fields.1 fields.2.1 body value returned nonzero
      subst value
      have writes := KeygenSmallBounds.source_writes entry out dst fields.1 fields.2.1 body returned
      rw [C99ArrayReference.bind_heap (view ctx s) _ _ entry binding] at writes
      exact writes

theorem caller_preserved (ctx : Context) (args : List Argument) (s after : State) (v : Value)
    (bigF bigG : ArrayPointer) (caller : Caller s bigF bigG) (source : Call ctx args s after v) :
    Caller after bigF bigG := by
  obtain ⟨hl,ha⟩ := call_frame ctx args s after v source
  exact ⟨(congrFun hl _).trans caller.logn,(congrFun hl _).trans caller.size,
    (congrFun ha _).trans caller.first,(congrFun ha _).trans caller.second⟩

theorem gate_writes (ctx : Context) (s : State) (out : Result) (bigF bigG : ArrayPointer)
    (m0 : ctx.ternary=1) (caller : Caller s bigF bigG)
    (source : Exec ctx s out) (normal : out.flow=.normal) :
    ∃ middle : Memory, KeygenSmallBounds.Writes bigF 0 s.heap middle ∧
      KeygenSmallBounds.Writes bigG 0 middle out.state.heap := by
  obtain ⟨middle,a,b,first,hna,second,hnb⟩ := passed_calls ctx s out source normal
  have keep := caller_preserved ctx (arguments false) s middle a bigF bigG caller first
  exact ⟨middle.heap,call_writes ctx s middle false bigF a m0 caller.logn caller.size caller.first first hna,
    call_writes ctx middle out.state true bigG b m0 keep.logn keep.size keep.second second hnb⟩

theorem gate_material (ctx : Context) (s : State) (out : Result) (bigF bigG : ArrayPointer)
    (m0 : ctx.ternary=1) (caller : Caller s bigF bigG)
    (firstWidth : bigF.elementBytes=2) (secondWidth : bigG.elementBytes=2)
    (separate : KeygenMkgm3Layout.DisjointBytes bigG 3072 bigF 3072)
    (source : Exec ctx s out) (normal : out.flow=.normal) :
    ∃ F G : Geometry.Vec,
      KeygenMaterial.Represents out.state.heap bigF F ∧ KeygenIntegerLift.Bound F 2047 ∧
      KeygenMaterial.Represents out.state.heap bigG G ∧ KeygenIntegerLift.Bound G 2047 := by
  obtain ⟨middle,first,second⟩ := gate_writes ctx s out bigF bigG m0 caller source normal
  exact KeygenSmallCalls.two_outputs bigF bigG s.heap middle out.state.heap firstWidth secondWidth separate first second

theorem gate_preserves (ctx : Context) (s : State) (out : Result) (bigF bigG other : ArrayPointer)
    (m0 : ctx.ternary=1) (caller : Caller s bigF bigG)
    (firstWidth : bigF.elementBytes=2) (secondWidth : bigG.elementBytes=2) (otherWidth : other.elementBytes=2)
    (separateF : KeygenMkgm3Layout.DisjointBytes bigF 3072 other 3072)
    (separateG : KeygenMkgm3Layout.DisjointBytes bigG 3072 other 3072)
    (v : Geometry.Vec) (represented : KeygenMaterial.Represents s.heap other v)
    (source : Exec ctx s out) (normal : out.flow=.normal) : KeygenMaterial.Represents out.state.heap other v := by
  obtain ⟨middle,first,second⟩ := gate_writes ctx s out bigF bigG m0 caller source normal
  exact KeygenSmallCalls.preserves bigG other middle out.state.heap second secondWidth otherWidth separateG v
    (KeygenSmallCalls.preserves bigF other s.heap middle first firstWidth otherWidth separateF v represented)

end FT1536.Source3.KeygenOutputGateBounds
