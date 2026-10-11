import Source3.KeygenCodecTypedSegments

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Derive the profile arguments at every codec boundary from the actual
   caller cells, rather than asserting a codec result/length/write frame.
   This matters: compress_none with q18433/logn0 computes the odd length3
   but its two-byte loop writes4 bytes. That out-of-profile call must not
   be covered by an unqualified capacity-window theorem. -/
namespace FT1536.Source3.KeygenCodecProfile
open C99ArrayReference (State bindPointer)
open C99ProcedureReference (Result)
open KeygenMakeInvocation (Env Head Encoding Segments assign initCounter)

structure Profile (env : Env) (s : State) : Prop where
  logn : s.locals "logn".toList=some (.uint32,some (.uint32 10))
  ter : s.locals "ter".toList=some (.uint32,some (.uint32 1))
  comp : s.locals "comp".toList=some (.int32,some (.int32 env.args.comp))

theorem assign_cell (s : State) (written : List Char) (ty : C99IntegerReference.Ty)
    (value : C99IntegerReference.Value) (name : List Char) (different : name≠written) :
    (assign s written ty value).locals name=s.locals name := by
  dsimp only [assign,C99ScalarReference.set]
  split <;> simp_all


theorem segment_cell (env : Env) (i : Nat) (s : State) (out : Result)
    (source : Segments env i s out) (name : List Char)
    (notI : name≠"i".toList) (notSkoff : name≠"skoff".toList) : out.state.locals name=s.locals name := by
  induction source with
  | done => rfl
  | capacity => rfl
  | next i s after lt ret counter site nonzero skoff skoffCell rest ih =>
    have last := assign_cell (assign {s with heap := after} "skoff".toList .uint64 (.uint64 (skoff+ret)))
      "i".toList .int32 (.int32 (BitVec.ofNat 32 (i+1))) name notI
    have first := assign_cell {s with heap := after} "skoff".toList .uint64 (.uint64 (skoff+ret)) name notSkoff
    exact ih.trans (last.trans first)


theorem head_cell (env : Env) (statement : KeygenMakeSyntax.Stmt) (s : State) (out : Result)
    (source : Head env statement s out) (name : List Char)
    (notI : name≠"i".toList) (notSkoff : name≠"skoff".toList)
    (notKlen : name≠"klen".toList) : out.state.locals name=s.locals name := by
  cases source
  case segmentsNormal =>
    rename_i seg normal run
    exact (segment_cell env 0 (initCounter s) seg run name notI notSkoff).trans
      (assign_cell s "i".toList .int32 (.int32 0) name notI)
  case segmentsReturn =>
    rename_i seg returned run
    exact (segment_cell env 0 (initCounter s) seg run name notI notSkoff).trans
      (assign_cell s "i".toList .int32 (.int32 0) name notI)
  all_goals first
    | rfl
    | exact assign_cell _ _ _ _ name notKlen
    | exact assign_cell _ _ _ _ name notSkoff

theorem encoding_cell (env : Env) (statements : List KeygenMakeSyntax.Stmt) (s : State) (out : Result)
    (source : Encoding env statements s out) (name : List Char)
    (notI : name≠"i".toList) (notSkoff : name≠"skoff".toList)
    (notKlen : name≠"klen".toList) : out.state.locals name=s.locals name := by
  induction source with
  | done => rfl
  | step statement rest s middle out head tail ih =>
    exact ih.trans (head_cell env statement s ⟨middle,.normal⟩ head name notI notSkoff notKlen)
  | exit statement rest s out head flow =>
    exact head_cell env statement s out head name notI notSkoff notKlen

theorem encoding_profile (env : Env) (statements : List KeygenMakeSyntax.Stmt) (s : State) (out : Result)
    (source : Encoding env statements s out) (profile : Profile env s) : Profile env out.state := by
  refine ⟨?_,?_,?_⟩
  · exact (encoding_cell env statements s out source "logn".toList (by decide) (by decide) (by decide)).trans profile.logn
  · exact (encoding_cell env statements s out source "ter".toList (by decide) (by decide) (by decide)).trans profile.ter
  · exact (encoding_cell env statements s out source "comp".toList (by decide) (by decide) (by decide)).trans profile.comp

theorem init_profile (env : Env) (s : State) (profile : Profile env s) : Profile env (initCounter s) := by
  exact ⟨profile.logn,profile.ter,profile.comp⟩

theorem next_profile (env : Env) (c : KeygenCodecTypedSegments.Site env) (skoff : BitVec 64)
    (profile : Profile env c.before) : Profile env (KeygenCodecTypedSegments.nextState c skoff) := by
  exact ⟨profile.logn,profile.ter,profile.comp⟩

theorem segment_profiles (env : Env) (i : Nat) (s : State) (out : Result)
    (calls : List (KeygenCodecTypedSegments.Site env))
    (source : KeygenCodecTypedSegments.Segments env i s out calls) (profile : Profile env s) :
    ∀ c, c∈calls → Profile env c.before := by
  induction source with
  | done => intro c member; cases member
  | capacity c counter zero =>
    intro d member
    have equal : d=c := by simpa only [List.mem_singleton] using member
    subst d
    exact profile
  | next c counter nonzero skoff skoffCell rest ih =>
    intro d member
    rcases List.mem_cons.mp member with same | tail
    · subst d; exact profile
    · exact ih (next_profile env c skoff profile) d tail

theorem chain_profiles (env : Env) (s : State) (headOut out : Result)
    (calls : List (KeygenCodecTypedSegments.Site env))
    (cells : KeygenMakeInvocation.TailCells env s)
    (chain : Encoding env KeygenMakeSkeChain.chain s headOut)
    (source : KeygenCodecTypedSegments.Segments env 0 (initCounter headOut.state) out calls) :
    ∀ c, c∈calls → Profile env c.before :=
  segment_profiles env 0 _ out calls source
    (init_profile env headOut.state (encoding_profile env _ s headOut chain ⟨cells.logn,cells.ter,cells.comp⟩))

/-- The profile restriction needed by capacity/length proofs is derived
    at ALL four actual sites, including sites following earlier writes. -/
theorem arguments_profile (env : Env) (c : KeygenCodecTypedSegments.Site env)
    (profile : Profile env c.before) :
    (KeygenCodecTypedSegments.arguments env c.before c.index c.after c.ret c.site).q=18433 ∧
    (KeygenCodecTypedSegments.arguments env c.before c.index c.after c.ret c.site).logn=10 := by
  have ter : c.site.ter=1 := by simpa using c.site.terCell.symm.trans profile.ter
  have logn : c.site.logn=10 := by simpa using c.site.lognCell.symm.trans profile.logn
  simp [KeygenCodecTypedSegments.arguments,ter,logn]

end FT1536.Source3.KeygenCodecProfile
