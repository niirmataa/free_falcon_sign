import Source3.KeygenSearchStability
import Source3.KeygenRootControl
import Source3.KeygenStaticReads

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenRootObjects
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMemoryStability
open KeygenHelperStability (compose)
open KeygenSearchContext (Context)

theorem load64 (before after : Memory) (p : ArrayPointer) (v : BitVec 64)
    (read : Load64 before p v) (stable : Stable before after) (readonly : before.writable p.block=false) : Load64 after p v := by
  cases read with
  | load data allocated width bytes =>
    exact .load after p data (by simpa only [Allocated,stable.size] using allocated) width
      (fun i => (stable.readonly p.block _ readonly).trans (bytes i))
theorem prime (before after : Memory) (p : ArrayPointer) (table : KeygenStaticTables.PrimeTable)
    (source : KeygenStaticTables.PrimeObject before p table) (stable : Stable before after) :
    KeygenStaticTables.PrimeObject after p table := by
  obtain ⟨width,index,count,readonly,extent,bound,words⟩ := source
  refine ⟨width,index,count,by rw [stable.writable]; exact readonly,
    by rw [stable.size]; exact extent,by rw [stable.size]; exact bound,?_⟩
  intro i v hi field
  exact Gate00Memory.load32_transport _ _ _ _ (words i v hi field) stable.size
    (fun _ => stable.readonly p.block _ readonly)
theorem size_table (before after : Memory) (p : ArrayPointer) (table : KeygenStaticTables.SizeTable)
    (source : KeygenStaticTables.SizeObject before p table) (stable : Stable before after) :
    KeygenStaticTables.SizeObject after p table := by
  obtain ⟨width,index,count,readonly,extent,bound,words⟩ := source
  refine ⟨width,index,count,by rw [stable.writable]; exact readonly,
    by rw [stable.size]; exact extent,by rw [stable.size]; exact bound,?_⟩
  intro i v hi
  exact load64 _ _ _ _ (words i v hi) stable readonly
theorem rev_table (before after : Memory) (p : ArrayPointer) (source : KeygenMkgm3RevMemory.SourceTable before p)
    (stable : Stable before after) : KeygenMkgm3RevMemory.SourceTable after p := by
  obtain ⟨readonly,data,parsed,words⟩ := source
  refine ⟨by rw [stable.writable]; exact readonly,data,parsed,?_⟩
  intro i n hi
  exact C99NarrowReads.load16_transport _ _ _ _ (words i n hi) stable.size
    (fun _ => stable.readonly p.block _ readonly)
theorem scratch (before after : Memory) (p : ArrayPointer) (source : KeygenMkgm3Layout.Legal before p)
    (stable : Stable before after) : KeygenMkgm3Layout.Legal after p := by
  simpa only [KeygenMkgm3Layout.Legal,stable.size,stable.writable] using source
theorem search_profile (ctx : Context) (before : State) (out : Result)
    (source : KeygenRootSearch.Exec ctx before out) (profile : KeygenSearchContext.M0 before.heap ctx)
    (separate : KeygenRootSearch.Protected ctx before ctx.object.block) : KeygenSearchContext.M0 out.state.heap ctx := by
  have stable := KeygenSearchStability.root ctx before out source
  have bytes := (KeygenRootSearch.frame ctx before out source profile ctx.object.block separate).2.2.2
  exact ⟨Gate00Memory.load32_transport _ _ _ _ profile.1 stable.size (fun _ => bytes _),
    Gate00Memory.load32_transport _ _ _ _ profile.2 stable.size (fun _ => bytes _)⟩

theorem store16 (before after : Memory) (p : ArrayPointer) (v : BitVec 16)
    (source : KeygenSmallOutput.Store16 before p v after) : Stable before after := by
  refine ⟨source.2.2.2.1,source.2.2.2.2.1,?_⟩
  intro block offset readonly
  have ne : block≠p.block := by intro he; subst block; rw [source.2.2.1] at readonly; cases readonly
  exact source.2.2.2.2.2.2 block offset (Or.inl ne)
theorem small (code : KeygenSmallSource.Stmt) (before : State) (out : Result)
    (source : KeygenSmallSource.Exec code before out) : Stable before.heap out.state.heap := by
  induction source
  case modular code before out source => exact modular _ _ _ source
  case store16 dst index value before after p v address evaluated store => exact store16 _ _ _ _ store
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
theorem small_call (ctx : KeygenOutputGateSource.Context) (args : List KeygenOutputGateSource.Argument)
    (before after : State) (v : C99IntegerReference.Value) (source : KeygenOutputGateSource.Call ctx args before after v) :
    Stable before.heap after.heap := by
  cases source with
  | run entry out v binding body returned =>
    have result := small _ _ _ body
    rw [C99ArrayReference.bind_heap _ _ _ _ binding] at result
    exact result
theorem evaluated (ctx : KeygenOutputGateSource.Context) (condition : KeygenOutputGateSource.Condition)
    (before after : State) (v : Bool) (source : KeygenOutputGateSource.Evaluate ctx condition before after v) :
    Stable before.heap after.heap := by
  induction source
  case call args before after v body => exact small_call _ _ _ _ _ body
  all_goals first | assumption | solve_by_elim [compose]
theorem gate (ctx : KeygenOutputGateSource.Context) (before : State) (out : Result)
    (source : KeygenOutputGateSource.Exec ctx before out) : Stable before.heap out.state.heap := by
  cases source with
  | failed middle out guard body => exact compose _ _ _ (evaluated _ _ _ _ _ guard) (small _ _ _ body)
  | passed after guard => exact evaluated _ _ _ _ _ guard
theorem gate_slots (ctx : KeygenOutputGateSource.Context) (before : State) (out : Result)
    (source : KeygenOutputGateSource.Exec ctx before out) (normal : out.flow=.normal) :
    out.state.locals=before.locals ∧ out.state.arrays=before.arrays ∧ out.state.tables=before.tables := by
  obtain ⟨middle,a,b,first,_,second,_⟩ := KeygenOutputGateSource.passed_calls ctx before out source normal
  have slots (args : List KeygenOutputGateSource.Argument) (before after : State) (v : C99IntegerReference.Value)
      (source : KeygenOutputGateSource.Call ctx args before after v) :
      after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.tables=before.tables := by
    cases source
    exact ⟨rfl,rfl,rfl⟩
  obtain ⟨hl,ha,ht⟩ := slots _ _ _ _ first
  obtain ⟨gl,ga,gt⟩ := slots _ _ _ _ second
  exact ⟨gl.trans hl,ga.trans ha,gt.trans ht⟩

end FT1536.Source3.KeygenRootObjects
