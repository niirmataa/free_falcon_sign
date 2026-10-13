import Source3.KeygenPublicCallerExecution077

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenPublicCallerTrace077
open C99MemoryReference
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env assign byteOff publicOf)
open KeygenPublicCallerSite077 (Site nextState)
open KeygenPublicCallerExecution077

theorem read_length (env : Env) (s t : State)
    (source : KeygenMakeInvocation.Head env KeygenMakeInvocation.pubkeyLenRead s ⟨t,.normal⟩) :
    ∃ klen, Load64 s.heap env.args.pubkeyLen klen ∧ t=assign s "klen".toList .uint64 (.uint64 klen) := by
  cases source with
  | readPubKlen s word load => exact ⟨word,load,rfl⟩
theorem capacity_pass (env : Env) (s t : State)
    (source : KeygenMakeInvocation.Head env KeygenMakeProgram.capacityReturn s ⟨t,.normal⟩) : t=s := by
  cases source <;> rfl
theorem zero_pass (env : Env) (s t : State)
    (source : KeygenMakeInvocation.Head env KeygenMakeInvocation.zeroCapacity s ⟨t,.normal⟩) : t=s := by
  cases source
  rfl
theorem header (env : Env) (s t : State) (profile : KeygenCodecProfile.Profile env s)
    (source : KeygenMakeInvocation.Head env KeygenMakeInvocation.pkHeader s ⟨t,.normal⟩) :
    KeygenCodecExecution.StoreByte s.heap (byteOff env.args.pubkey 0) 138 t.heap ∧ t.locals=s.locals := by
  cases source with
  | storePkHeader s ter logn byte after terCell lognCell pubkeyCell value store =>
    have terEq : ter=1 := by simpa using terCell.symm.trans profile.ter
    have lognEq : logn=10 := by simpa using lognCell.symm.trans profile.logn
    subst ter; subst logn
    rw [KeygenPublicCallerSite077.header_value] at value
    subst byte
    exact ⟨store,rfl⟩
theorem length_store (env : Env) (s t : State)
    (source : KeygenMakeInvocation.Head env KeygenMakeInvocation.pubkeyLenWrite s ⟨t,.normal⟩) :
    ∃ klen, s.locals "klen".toList=some (.uint64,some (.uint64 klen)) ∧ Store64 s.heap env.args.pubkeyLen (klen+1) t.heap := by
  cases source with
  | storePubkeyLen s klen after cell store => exact ⟨klen,cell,store⟩

/-- The actual seven public suffix statements yield one fixed-body call,
    its input capacity load, the derived header, and the real length store.
    The only result premise is the observed enclosing caller return1. -/
theorem trace (env : Env) (s : State) (out : Result) (calls : List (Site env))
    (profile : KeygenCodecProfile.Profile env s) (source : Encoding env code s out calls)
    (success : out.flow=.returned (some (.int32 1))) :
    ∃ (c : Site env) (capacity : BitVec 64), calls=[c] ∧
      Load64 s.heap env.args.pubkeyLen capacity ∧ c.site.klen=capacity ∧ c.site.logn=10 ∧
      KeygenCodecExecution.StoreByte s.heap (byteOff env.args.pubkey 0) 138 c.before.heap ∧
      Store64 c.after env.args.pubkeyLen (c.ret+1) out.state.heap := by
  obtain ⟨s1,f1,l1,h1,t1,e1⟩ := next env _ _ s out calls source success (by decide +kernel)
  obtain ⟨s2,f2,l2,h2,t2,e2⟩ := next env _ _ s1 out l1 t1 success (by decide +kernel)
  obtain ⟨s3,f3,l3,h3,t3,e3⟩ := next env _ _ s2 out l2 t2 success (by decide +kernel)
  obtain ⟨s4,f4,l4,h4,t4,e4⟩ := next env _ _ s3 out l3 t3 success (by decide +kernel)
  obtain ⟨c,beforeEq,afterEq,called⟩ := public_extract env s3 ⟨s4,.normal⟩ f4 h4
  subst s3
  have stateEq : s4=nextState c := congrArg Result.state afterEq
  subst s4
  obtain ⟨s5,f5,l5,h5,t5,e5⟩ := next env _ _ (nextState c) out l4 t4 success (by decide +kernel)
  obtain ⟨s6,f6,l6,h6,t6,e6⟩ := next env _ _ s5 out l5 t5 success (by decide +kernel)
  obtain ⟨finalEq,emptyLast⟩ := return_final env s6 out l6 t6
  obtain ⟨empty1,old1⟩ := plain env _ _ _ _ h1 (by decide +kernel)
  obtain ⟨empty2,old2⟩ := plain env _ _ _ _ h2 (by decide +kernel)
  obtain ⟨empty3,old3⟩ := plain env _ _ _ _ h3 (by decide +kernel)
  obtain ⟨empty5,old5⟩ := plain env _ _ _ _ h5 (by decide +kernel)
  obtain ⟨empty6,old6⟩ := plain env _ _ _ _ h6 (by decide +kernel)
  obtain ⟨capacity,load,readEq⟩ := read_length env s s1 old1
  have passEq := capacity_pass env s1 s2 old2
  have profile2 : KeygenCodecProfile.Profile env s2 := by
    rw [passEq,readEq]
    exact ⟨profile.logn,profile.ter,profile.comp⟩
  obtain ⟨headerStore,localsEq⟩ := header env s2 c.before profile2 old3
  have capacityEq : c.site.klen=capacity := by
    have cell := c.site.klenCell
    rw [localsEq,passEq,readEq] at cell
    simpa only [assign,C99ScalarReference.set,ite_true,Option.some.injEq,Prod.mk.injEq,true_and,
      C99IntegerReference.Value.uint64.injEq] using cell.symm
  have lognEq : c.site.logn=10 := by
    have cell : c.before.locals "logn".toList=some (.uint32,some (.uint32 10)) := by
      rw [localsEq]
      exact profile2.logn
    simpa using c.site.lognCell.symm.trans cell
  have oldHeap : s2.heap=s.heap := by rw [passEq,readEq]; rfl
  rw [oldHeap] at headerStore
  have zeroEq := zero_pass env (nextState c) s5 old5
  obtain ⟨returned,returnCell,lengthStore⟩ := length_store env s5 s6 old6
  have returnEq : returned=c.ret := by
    rw [zeroEq] at returnCell
    simpa only [nextState,assign,C99ScalarReference.set,ite_true,Option.some.injEq,Prod.mk.injEq,true_and,
      C99IntegerReference.Value.uint64.injEq] using returnCell.symm
  rw [zeroEq,returnEq] at lengthStore
  have actualStore : Store64 c.after env.args.pubkeyLen (c.ret+1) out.state.heap := by
    rw [finalEq]
    exact lengthStore
  refine ⟨c,capacity,?_,load,capacityEq,lognEq,headerStore,actualStore⟩
  simp only [e1,e2,e3,e4,e5,e6,empty1,empty2,empty3,called,empty5,empty6,emptyLast,List.nil_append,List.append_nil]

end FT1536.Source3.KeygenPublicCallerTrace077
