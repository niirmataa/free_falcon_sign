import Source3.KeygenCodecControl

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete NONE returned-value classification at the source-derived M0
   profile. The length is a conclusion of the actual branch execution. -/
namespace FT1536.Source3.KeygenCodecNoneResult
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecControl

theorem q_eval (args : Args) (heap : Memory) (buf : Option (Option ArrayPointer))
    (before after : Locals) (result : Value)
    (cell : before.scalars "q".toList=some (.uint32,some (.uint32 18433)))
    (source : Eval args heap buf (.variable "q".toList) before result after) :
    result=.integer (.uint32 18433) ∧ after=before := by
  cases source
  simp_all

theorem q_test (args : Args) (s : State) (l : Locals) (value : Value)
    (cell : s.locals.scalars "q".toList=some (.uint32,some (.uint32 18433)))
    (source : Eval args s.heap s.buf KeygenCodecNoneBinding.guard010 s.locals value l) :
    truth value=false ∧ l=s.locals := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    obtain ⟨hx,hm⟩ := q_eval args s.heap s.buf s.locals middle x cell first
    subst x
    subst middle
    obtain ⟨hy,ht⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 12289 (.int32 12289) s.locals l y (by decide +kernel) second
    subst y
    cases operation with
    | eq x y z compared =>
      cases compared
      simp_all [truth,C99IntegerReference.usual,C99IntegerReference.promote,
        C99IntegerReference.convert,C99IntegerReference.Value.type,C99IntegerReference.Value.integer,C99IntegerReference.compare,C99IntegerReference.signed,C99IntegerReference.width]

theorem declaration_len (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenCodecNoneBinding.node000 s t flow) :
    t.locals.scalars "len".toList=some (.uint64,none) := by
  cases source with
  | declare args s objects locals declarations =>
    have same : locals=localSet (localSet s.locals "len".toList .uint64 none) "u".toList .uint64 none := by
      simpa [KeygenCodecNoneBinding.node000,declareLocals,scalarTy] using declarations.symm
    subst locals
    simp [declared,localSet,C99ScalarReference.set]

theorem assign_length (args : Args) (s t : State) (flow : Flow)
    (cell : s.locals.scalars "logn".toList=some (.uint32,some (.uint32 10)))
    (declaredLen : s.locals.scalars "len".toList=some (.uint64,none))
    (source : Exec args KeygenCodecNoneBinding.node006 s t flow) :
    t.locals.scalars "len".toList=some (.uint64,some (.uint64 3072)) := by
  cases source with
  | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have equal : ty=.uint64 ∧ old=none := by simpa only [Option.some.injEq,Prod.mk.injEq] using declared.symm.trans declaredLen
    obtain ⟨rfl,rfl⟩ := equal
    obtain ⟨same,last⟩ := KeygenCodecNoneLength.rhs_eval args s.heap s.buf s.locals locals (.integer value) cell evaluated
    have integer : value=.uint64 3072 := Value.integer.inj same
    subst value
    cases assigned with
    | set => simp [withLocals,localSet,C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]

theorem branch_length (args : Args) (s t : State) (flow : Flow)
    (qCell : s.locals.scalars "q".toList=some (.uint32,some (.uint32 18433)))
    (lognCell : s.locals.scalars "logn".toList=some (.uint32,some (.uint32 10)))
    (lenCell : s.locals.scalars "len".toList=some (.uint64,none))
    (source : Exec args KeygenCodecNoneBinding.node010 s t flow) :
    t.locals.scalars "len".toList=some (.uint64,some (.uint64 3072)) := by
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    have zero := (q_test args s locals value qCell evaluated).1
    rw [zero] at yes
    cases yes
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    have last := (q_test args s locals value qCell evaluated).2
    subst locals
    cases selected with
    | scope args a s t flow noBufShadow inside =>
      obtain ⟨middle,assigned,rest⟩ := seq_split args KeygenCodecNoneBinding.node006 KeygenCodecNoneBinding.node007 s t flow inside (by rfl)
      have result := assign_length args s middle .normal lognCell lenCell assigned
      cases rest
      exact result

/-- Extract the derived initialized length and the actual remaining body
    from the complete enclosing NONE execution, including its declarations. -/
theorem full_split (args : Args) (before : Memory) (after : State) (flow : Flow)
    (q : args.q=18433) (logn : args.logn=10)
    (source : Exec args KeygenCodecNoneBinding.code (initial args before) after flow) :
    ∃ middle final,
      middle.locals.scalars "len".toList=some (.uint64,some (.uint64 3072)) ∧
      Exec args KeygenCodecNoneBinding.node039 middle final flow ∧ after.heap=final.heap := by
  cases source with
  | scope args a s t flow noBufShadow inside =>
    obtain ⟨declared,first,rest⟩ := seq_split args KeygenCodecNoneBinding.node000 KeygenCodecNoneBinding.node041 _ t flow inside (by rfl)
    obtain ⟨buffer,second,rest⟩ := seq_split args KeygenCodecNoneBinding.node001 KeygenCodecNoneBinding.node040 declared t flow rest (by rfl)
    obtain ⟨middle,branch,rest⟩ := seq_split args KeygenCodecNoneBinding.node010 KeygenCodecNoneBinding.node039 buffer t flow rest (by decide +kernel)
    have qDeclared := KeygenCodecCellFrame.exec_frame "q".toList args _ _ declared .normal first (by decide +kernel)
    have lognDeclared := KeygenCodecCellFrame.exec_frame "logn".toList args _ _ declared .normal first (by decide +kernel)
    have qBuffer := KeygenCodecCellFrame.exec_frame "q".toList args _ declared buffer .normal second (by decide +kernel)
    have lognBuffer := KeygenCodecCellFrame.exec_frame "logn".toList args _ declared buffer .normal second (by decide +kernel)
    have lenBuffer := KeygenCodecCellFrame.exec_frame "len".toList args _ declared buffer .normal second (by decide +kernel)
    have qc : buffer.locals.scalars "q".toList=some (.uint32,some (.uint32 18433)) := by
      simpa [initial,initialLocals,q] using qBuffer.trans qDeclared
    have lc : buffer.locals.scalars "logn".toList=some (.uint32,some (.uint32 10)) := by
      simpa [initial,initialLocals,logn] using lognBuffer.trans lognDeclared
    have length := branch_length args buffer middle .normal qc lc
      (lenBuffer.trans (declaration_len args _ declared .normal first)) branch
    exact ⟨middle,t,length,rest,rfl⟩

theorem none_result (args : Args) (before : Memory) (after : State) (flow : Flow)
    (q : args.q=18433) (logn : args.logn=10)
    (source : Exec args KeygenCodecNoneBinding.code (initial args before) after flow) :
    KeygenCodecControl.LengthFlow flow := by
  obtain ⟨middle,final,cell,rest,_⟩ := full_split args before after flow q logn source
  exact length_flow args _ middle final flow rest (by decide +kernel) (by decide +kernel) cell

theorem returned_length (args : Args) (before : Memory) (after : State) (ret : BitVec 64)
    (q : args.q=18433) (logn : args.logn=10)
    (source : Exec args KeygenCodecNoneBinding.code (initial args before) after (.returned ret)) :
    ret=0 ∨ ret=3072 := by
  rcases none_result args before after (.returned ret) q logn source with normal | zero | length
  · cases normal
  · exact Or.inl (Flow.returned.inj zero)
  · exact Or.inr (Flow.returned.inj length)

end FT1536.Source3.KeygenCodecNoneResult
