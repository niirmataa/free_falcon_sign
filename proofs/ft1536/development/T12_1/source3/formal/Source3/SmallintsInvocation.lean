import Source3.SmallintsPrelude

namespace FT1536.Source3.SmallintsInvocation
open C99MemoryReference
open C99ArrayReference (Name State Arg Bind)

def args (destination source : Name) : List Arg :=
  [.pointer destination (.literal .u64 0),.pointer source (.literal .u64 0),
   .scalar (.var "logn".toList),.scalar (.literal .i32 1)]

/- A closed call judgment: the actual four-parameter header and parsed,
   narrow-typed body execute, then the void call boundary restores locals. -/
def Call (destination source : Name) (before after : State) : Prop :=
  ∃ (entry : State) (result : C99ProcedureReference.Result),
    Bind before SmallintsProgram.function.params (args destination source) entry ∧
    C99ProcedureReference.Exec FftProcedurePrograms.program SmallintsProgram.body entry result ∧
    C99ProcedureReference.ReturnValue none result.flow none ∧ after={before with heap := result.state.heap}

theorem parameter_bindings (destination source : Name) (dst src : ArrayPointer) (before entry : State)
    (logn : before.locals "logn".toList=some (.uint32,some (.uint32 10)))
    (hd : before.arrays destination=some dst) (hs : before.arrays source=some src)
    (binding : Bind before SmallintsProgram.function.params (args destination source) entry) :
    MknReference.Profile entry ∧ entry.arrays "r".toList=some dst ∧
      entry.arrays "t".toList=some src ∧ entry.heap=before.heap ∧ entry.tables=before.tables := by
  cases binding with
  | pointer _ _ _ d _ _ _ dstArg remaining =>
      have hdst := CertificateAfterConversion.zero_pointer before destination d dst dstArg hd
      subst d
      cases remaining with
      | pointer _ _ _ s _ _ _ srcArg remaining =>
          have hsrc := CertificateAfterConversion.zero_pointer before source s src srcArg hs
          subst s
          cases remaining with
          | scalar _ _ _ _ _ _ lg lognArg remaining =>
              have hlg := C99CountedWords.variable_exact before "logn".toList .uint32 (.uint32 10) lg logn lognArg
              subst lg
              cases remaining with
              | scalar _ _ _ _ _ _ ter terArg remaining =>
                  change C99ScalarReference.Eval _ _ (.literal .int32 1) ter at terArg
                  cases terArg
                  cases remaining
                  refine ⟨?_,?_,?_,rfl,rfl⟩
                  all_goals simp [MknReference.Profile,C99ArrayReference.bindPointer,C99ArrayReference.bindValue,
                    C99ScalarReference.set,C99IntegerReference.convert,C99IntegerReference.Value.integer]

theorem output_initialized (destination source : Name) (dst src : ArrayPointer) (before after : State)
    (logn : before.locals "logn".toList=some (.uint32,some (.uint32 10)))
    (hd : before.arrays destination=some dst) (hs : before.arrays source=some src)
    (width : dst.elementBytes=8) (call : Call destination source before after) :
    C99InitializationTrace.Initialized after.heap dst.block dst.offset 12288 := by
  obtain ⟨entry,result,binding,body,returned,he⟩ := call
  have hp := parameter_bindings destination source dst src before entry logn hd hs binding
  have initialized := SmallintsPrelude.output_initialized dst src entry result hp.1 hp.2.1 hp.2.2.1 width body
  simpa only [he] using initialized

theorem memory_steps (destination source : Name) (before after : State)
    (call : Call destination source before after) : C99InitializationTrace.Steps before.heap after.heap := by
  obtain ⟨entry,result,binding,body,returned,he⟩ := call
  have hs := C99ProcedureReference.memory_steps _ _ _ _ body
  rw [C99ArrayReference.bind_heap before SmallintsProgram.function.params (args destination source) entry binding] at hs
  simpa only [he] using hs

theorem caller_bindings (destination source : Name) (before after : State)
    (call : Call destination source before after) :
    after.locals=before.locals ∧ after.arrays=before.arrays ∧ after.tables=before.tables := by
  obtain ⟨entry,result,binding,body,returned,he⟩ := call
  rw [he]
  exact ⟨rfl,rfl,rfl⟩

theorem caller_frame (destination source : Name) (before after : State)
    (call : Call destination source before after) (block offset : Nat)
    (outside : C99ArrayFrame.Outside before [destination] block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  obtain ⟨entry,result,binding,body,returned,he⟩ := call
  have checked : C99PointerFootprint.arguments [destination] ["r".toList]
      SmallintsProgram.function.params (args destination source)=true := by
    simp [C99PointerFootprint.arguments,SmallintsProgram.function,args]
  obtain ⟨ho,ht⟩ := C99PointerFootprint.bind_outside before SmallintsProgram.function.params
    (args destination source) entry binding [destination] ["r".toList] checked block offset outside tables
  have hf := SmallintsProgram.source_frame entry result body block offset ho
    (by simpa only [C99PointerFootprint.TablesOutside,ht] using tables)
  rw [C99ArrayReference.bind_heap before SmallintsProgram.function.params (args destination source) entry binding] at hf
  simpa only [he] using hf

theorem source_frame (destination source : Name) (dst src : ArrayPointer) (before after : State)
    (logn : before.locals "logn".toList=some (.uint32,some (.uint32 10)))
    (hd : before.arrays destination=some dst) (hs : before.arrays source=some src)
    (call : Call destination source before after) (block offset : Nat)
    (outside : C99PointerFootprint.PointOutside dst block offset)
    (tables : C99PointerFootprint.TablesOutside before block offset) :
    after.heap.bytes block offset=before.heap.bytes block offset := by
  obtain ⟨entry,result,binding,body,returned,he⟩ := call
  have hp := parameter_bindings destination source dst src before entry logn hd hs binding
  have ho : C99ArrayFrame.Outside entry ["r".toList] block offset := by
    intro name hn p hptr
    have hname : name="r".toList := by simpa only [List.mem_singleton] using hn
    subst name
    have heq : p=dst := Option.some.inj (hptr.symm.trans hp.2.1)
    subst p
    exact outside
  have ht : C99PointerFootprint.TablesOutside entry block offset := by
    simpa only [C99PointerFootprint.TablesOutside,hp.2.2.2.2] using tables
  have frame := SmallintsProgram.source_frame entry result body block offset ho ht
  rw [hp.2.2.2.1] at frame
  simpa only [he] using frame

end FT1536.Source3.SmallintsInvocation
