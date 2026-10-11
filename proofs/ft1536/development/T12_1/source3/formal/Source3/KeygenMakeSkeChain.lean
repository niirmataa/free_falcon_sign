import Source3.KeygenMakeSkeCells

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- THE concrete statement-chain extraction of the `ske` cell history along
   the nine pre-loop statements of the encoding tail, reaching the
   four-segment loop entry with ALL FOUR cell words, and the cell history at
   the first encoder call site (segment 0) of the loop.

   The chain follows the executed statements in source order (the 060
   `Head`/`Encoding` machine over the kernel-checked tail list): the
   `skbuf`/`klen`/`skoff` bindings and the `skbuf[0]` header byte store
   execute first (no cell word exists yet -- the words are CREATED by the
   later `ske[i]=...` pointer-array stores), then the four `skeBind` stores
   create the words `SkeCellWord env 0..3` one by one
   (`KeygenMakeSkeCells.ske_word_of_bind`), each foreign `ske` store
   preserving the words of the other segments
   (`KeygenMakeSkeCells.ske_word_of_store_frame` over the disjoint cell
   extents `skeElem_disjoint`). At the four-segment loop entry all four
   words hold simultaneously, so the segment-0 call boundary carries its
   complete cell history and the 062 derived liveness
   (`small_site_src_live`) and source tie (`small_site_material_extended`)
   apply at the concrete site with no readable-word or liveness hypothesis.

   B1.08/09 seam (the remaining survival leg): the call boundaries of
   segments 1-3 additionally require the survival of the cell words through
   the heap effects of the EARLIER codec calls of segments 0..i-1. The 060
   call events carry their heap effect open (`SmallSite`'s `after`), so the
   survival is exactly the codec write-frame item of B1.08/09: the codec
   bodies (`falcon_encode_small` dispatch to `compress_none`/
   `compress_static`, and the public encoders) must be bound to source
   executions whose writes are confined to the destination window, then the
   words survive because the `ske` cells lie outside that window. That
   derivation is NOT supplied here and no codec outcome, exact encoded
   length or codec write frame appears as a premise of any export below.
   Not a review, not a codec claim and not a law claim. -/
namespace FT1536.Source3.KeygenMakeSkeChain
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ProcedureReference (Result)
open KeygenMakeSyntax (Stmt)
open KeygenMakeInvocation (Env SmallSite VirtualLegal skeName inputOf TailCells Head Encoding Segments
  initCounter privkeyLenRead skbufAssign skHeader skoffOne skeBind)
open KeygenMakeSkeCells (SkeCellWord ske_word_of_bind ske_word_of_store_frame
  small_site_src_live small_site_material_extended)

/-! ## 1. The nine-statement chain to the loop entry (definitions first) -/

/-- THE concrete pre-loop statement chain of the encoding tail: the five
    caller-state statements (`klen` read, `skbuf` bind, the private capacity
    test, the header byte store, `skoff=1`) and the four `ske` pointer-array
    stores, reaching the four-segment loop statement. -/
def chain : List Stmt :=
  [privkeyLenRead,skbufAssign,KeygenMakeProgram.capacityReturn,skHeader,skoffOne,
   skeBind 0 "f".toList,skeBind 1 "g".toList,skeBind 2 "F".toList,skeBind 3 "G".toList]

theorem chain_source : chain=KeygenMakeProgram.encoding.take 9 := by
  rw [KeygenMakeInvocation.tail_source]
  rfl

/-- The `ske` cell names never collide with the `skbuf` binding of the
    tail, so the material cells survive every non-`ske` statement. -/
theorem skeName_ne_skbuf (i : Fin 4) : skeName i≠"skbuf".toList := by
  fin_cases i <;> decide

theorem mat_at_head (env : Env) (stmt : Stmt) (s : State) (out : Result)
    (source : Head env stmt s out) (material : ∀ slot : Fin 4,
      s.arrays (skeName slot)=some (inputOf env slot)) :
    ∀ slot : Fin 4, out.state.arrays (skeName slot)=some (inputOf env slot) := by
  intro slot
  exact (KeygenMakeInvocation.head_cells env stmt s out source (skeName slot)
    (skeName_ne_skbuf slot)).trans (material slot)

/-! ## 2. The chain walk: creation at the `ske` stores, transport across
    foreign stores -/

/-- One executed `ske[i]=...` store of the chain CREATES the cell word of
    segment `i` and PRESERVES the words of the earlier segments (their
    cells are byte-disjoint). The statement index is inverted through its
    shape equation: `Head`'s statement indices are computed definitions
    (`skeBind i.val (skeName i)`), so a direct `cases` on an indexed head
    fails dependent elimination; inverting over a variable statement and
    transporting along the shape equation is the working form. The word
    bounds are counted in `Nat` (`k` = number of completed `ske` stores) so
    the walk composes without arithmetic on `Fin` literals. -/
theorem bindSke_step (env : Env) (iv : Fin 4) (k : Nat) (stmt : Stmt) (s m : State)
    (head : Head env stmt s ⟨m,.normal⟩)
    (shape : stmt=skeBind iv.val (skeName iv))
    (atIndex : iv.val=k)
    (material : ∀ slot : Fin 4, s.arrays (skeName slot)=some (inputOf env slot))
    (words : ∀ j : Fin 4, j.val < k → SkeCellWord env j s) :
    (∀ j : Fin 4, j.val < k+1 → SkeCellWord env j m) ∧
      ∀ slot : Fin 4, m.arrays (skeName slot)=some (inputOf env slot) := by
  have matm := mat_at_head env stmt s ⟨m,.normal⟩ head material
  cases head with
  | readPrivate s word load => simp [privkeyLenRead,skeBind,KeygenMakeProgram.varExpr,
      KeygenMakeProgram.number] at shape
  | bindSkbuf s => simp [skbufAssign,skeBind,KeygenMakeProgram.varExpr,
      KeygenMakeProgram.number] at shape
  | privatePass s klen cell ge => simp [KeygenMakeProgram.capacityReturn,KeygenMakeProgram.capacityTest,
      skeBind,KeygenMakeProgram.varExpr,KeygenMakeProgram.number] at shape
  | storeSkHeader s ter comp logn byte after terCell compCell lognCell skbufCell value store =>
    simp [skHeader,skeBind,KeygenMakeProgram.varExpr,KeygenMakeProgram.number] at shape
  | bindSkoff s => simp [skoffOne,skeBind,KeygenMakeProgram.varExpr,
      KeygenMakeProgram.number] at shape
  | bindSke i s src after cell store =>
    have iev : i.val=iv.val := by
      have same := shape
      simp [skeBind,KeygenMakeProgram.varExpr,KeygenMakeProgram.number] at same
      exact same.1
    have kb : i.val=k := by omega
    refine ⟨fun j bound => ?_,matm⟩
    · by_cases earlier : j.val < k
      · exact ske_word_of_store_frame env j i s src after (by omega) (words j earlier) store
      · have samej : j=i := Fin.ext (by omega)
        rw [samej]
        exact ske_word_of_bind env i s after src (material i) cell store
  | segmentsNormal s seg run normal =>
    simp [KeygenMakeProgram.secretLoop,skeBind,KeygenMakeProgram.varExpr,
      KeygenMakeProgram.number] at shape
  | storePrivkeyLen s skoff after skoffCell store =>
    simp [KeygenMakeInvocation.privkeyLenWrite,skeBind,KeygenMakeProgram.varExpr,
      KeygenMakeProgram.number] at shape
  | readPubKlen s word load =>
    simp [KeygenMakeInvocation.pubkeyLenRead,skeBind,KeygenMakeProgram.varExpr,
      KeygenMakeProgram.number] at shape
  | publicPass s klen cell ge =>
    simp [KeygenMakeProgram.capacityReturn,KeygenMakeProgram.capacityTest,
      skeBind,KeygenMakeProgram.varExpr,KeygenMakeProgram.number] at shape
  | storePkHeader s ter logn byte after terCell lognCell pubkeyCell value store =>
    simp [KeygenMakeInvocation.pkHeader,skeBind,KeygenMakeProgram.varExpr,
      KeygenMakeProgram.number] at shape
  | publicTernary s after ret ter terCell nonzero site =>
    simp [KeygenMakeProgram.publicDispatch,skeBind,KeygenMakeProgram.varExpr,
      KeygenMakeProgram.number] at shape
  | publicBinary s after ret ter terCell zero site =>
    simp [KeygenMakeProgram.publicDispatch,skeBind,KeygenMakeProgram.varExpr,
      KeygenMakeProgram.number] at shape
  | zeroPass s klen cell nonzero =>
    simp [KeygenMakeInvocation.zeroCapacity,skeBind,KeygenMakeProgram.varExpr,
      KeygenMakeProgram.number] at shape
  | storePubkeyLen s klen after klenCell store =>
    simp [KeygenMakeInvocation.pubkeyLenWrite,skeBind,KeygenMakeProgram.varExpr,
      KeygenMakeProgram.number] at shape

/-- A normal-flow step over a statement list head decomposes into its head
    edge and the remaining run; the exit edge contradicts normal flow. -/
theorem encoding_cons_normal (env : Env) (stmt : Stmt) (ss : List Stmt) (s : State) (out : Result)
    (run : Encoding env (stmt::ss) s out) (normal : out.flow=.normal) :
    ∃ m : State, Head env stmt s ⟨m,.normal⟩ ∧ Encoding env ss m out := by
  cases run with
  | step stmt ss s m o head tail => exact ⟨m,head,tail⟩
  | exit stmt ss s o head flow => exact absurd normal flow

/-- THE concrete statement-chain extraction of the `ske` cell history:
    executing the nine pre-loop statements of the encoding tail creates all
    FOUR cell words, so at the four-segment loop entry every `ske` cell
    holds the LP64 word of its segment's material pointer. The words are
    created by the four executed `ske[i]=...` stores and transported across
    the foreign stores; nothing before the first store creates a word (the
    `skbuf[0]` header store predates them all). -/
theorem prefix_ske_chain (env : Env) (s : State) (out : Result) (cells : TailCells env s)
    (run : Encoding env chain s out) (normal : out.flow=.normal) :
    ∀ i : Fin 4, SkeCellWord env i out.state := by
  have mat : ∀ slot : Fin 4, s.arrays (skeName slot)=some (inputOf env slot) := cells.material
  obtain ⟨m1,h1,r1⟩ := encoding_cons_normal env privkeyLenRead _ s out run normal
  have mat1 := mat_at_head env privkeyLenRead s ⟨m1,.normal⟩ h1 mat
  obtain ⟨m2,h2,r2⟩ := encoding_cons_normal env skbufAssign _ m1 out r1 normal
  have mat2 := mat_at_head env skbufAssign m1 ⟨m2,.normal⟩ h2 mat1
  obtain ⟨m3,h3,r3⟩ := encoding_cons_normal env KeygenMakeProgram.capacityReturn _ m2 out r2 normal
  have mat3 := mat_at_head env KeygenMakeProgram.capacityReturn m2 ⟨m3,.normal⟩ h3 mat2
  obtain ⟨m4,h4,r4⟩ := encoding_cons_normal env skHeader _ m3 out r3 normal
  have mat4 := mat_at_head env skHeader m3 ⟨m4,.normal⟩ h4 mat3
  obtain ⟨m5,h5,r5⟩ := encoding_cons_normal env skoffOne _ m4 out r4 normal
  have mat5 := mat_at_head env skoffOne m4 ⟨m5,.normal⟩ h5 mat4
  obtain ⟨m6,h6,r6⟩ := encoding_cons_normal env (skeBind 0 "f".toList) _ m5 out r5 normal
  have step6 := bindSke_step env ⟨0,by omega⟩ 0 (skeBind 0 "f".toList) m5 m6 h6 rfl rfl mat5
    (fun j bound => absurd bound (by omega))
  obtain ⟨m7,h7,r7⟩ := encoding_cons_normal env (skeBind 1 "g".toList) _ m6 out r6 normal
  have step7 := bindSke_step env ⟨1,by omega⟩ 1 (skeBind 1 "g".toList) m6 m7 h7 rfl rfl step6.2
    (fun j bound => step6.1 j bound)
  obtain ⟨m8,h8,r8⟩ := encoding_cons_normal env (skeBind 2 "F".toList) _ m7 out r7 normal
  have step8 := bindSke_step env ⟨2,by omega⟩ 2 (skeBind 2 "F".toList) m7 m8 h8 rfl rfl step7.2
    (fun j bound => step7.1 j bound)
  obtain ⟨m9,h9,r9⟩ := encoding_cons_normal env (skeBind 3 "G".toList) _ m8 out r8 normal
  have step9 := bindSke_step env ⟨3,by omega⟩ 3 (skeBind 3 "G".toList) m8 m9 h9 rfl rfl step8.2
    (fun j bound => step8.1 j bound)
  cases r9
  intro i
  exact step9.1 i i.isLt

/-! ## 3. The loop-entry interface and the first encoder call site -/

/-- `i=0` initialization of the loop counter touches only locals: the cell
    words at the loop statement's entry state are the chain words. -/
theorem initCounter_words (env : Env) (i : Fin 4) (s : State)
    (word : SkeCellWord env i s) : SkeCellWord env i (initCounter s) :=
  word

/-- THE four words at the four-segment loop entry: the chain words survive
    the `i=0` initialization and hold at the entry state of the segment
    loop statement. -/
theorem chain_words_at_loop (env : Env) (s : State) (out : Result) (cells : TailCells env s)
    (run : Encoding env chain s out) (normal : out.flow=.normal) :
    ∀ i : Fin 4, SkeCellWord env i (initCounter out.state) := by
  intro i
  exact initCounter_words env i out.state (prefix_ske_chain env s out cells run normal i)

/-- THE first encoder call site of the segment loop: at `i=0` the loop body
    executes its `falcon_encode_small` call site before any iteration has
    completed, so the call-boundary state of segment 0 is the loop-entry
    state itself. -/
theorem segments_first_site (env : Env) (s : State) (seg : Result)
    (run : Segments env 0 s seg) :
    ∃ (after : Memory) (ret : BitVec 64), Nonempty (SmallSite env s ⟨0,by omega⟩ after ret) := by
  cases run with
  | done i s bound counter => exact absurd bound (by omega)
  | capacity i s after lt ret counter site zero => exact ⟨after,ret,⟨site⟩⟩
  | next i s after lt ret counter site nonzero skoff skoffCell rest => exact ⟨after,ret,⟨site⟩⟩

/-- THE cell history at the first call site (segment 0): the word created by
    the `ske[0]=f` store of the chain reaches the segment-0 call boundary
    with no codec call in between. -/
theorem first_site_history (env : Env) (s : State) (out : Result) (cells : TailCells env s)
    (run : Encoding env chain s out) (normal : out.flow=.normal) :
    SkeCellWord env 0 (initCounter out.state) :=
  chain_words_at_loop env s out cells run normal 0

/-- THE derived liveness and source tie at the concrete segment-0 call site:
    under the pinned explicit live-set extension of the 061 module the read
    pointer's block is live and the call-site source IS the material array
    of segment 0 — the 062 exports instantiated on the extracted chain, no
    readable-word hypothesis and no liveness side condition. -/
theorem first_site_liveness (env : Env) (before : State) (after : Memory) (ret : BitVec 64)
    (site : SmallSite env before 0 after ret)
    (legal : VirtualLegal (site.src.block::env.live) env.vb)
    (history : SkeCellWord env 0 before) :
    site.src.block∈env.live ∧ site.src=inputOf env 0 :=
  ⟨small_site_src_live env before 0 after ret site legal history,
   small_site_material_extended env before 0 after ret site legal history⟩

/-! ## 4. The B1.08/09 seam (named, not supplied)

    The call boundaries of segments 1-3 of the loop require the survival of
    the cell words through the heap effects of the earlier codec calls of
    segments 0..i-1 (the `SmallSite` call events of the 060 machine carry
    their heap effect `after` open). The survival is the codec write-frame
    item: bind the codec bodies to source executions, derive their write
    confinement to the destination window (`skbuf+skoff`, `klen-skoff` for
    the segments; `pubkey+1`, `klen-1` for the public call), then the `ske`
    cells (block `env.blocks 5`, offsets `8*i`) lie outside every destination
    window and the words survive. No export above consumes a codec outcome,
    an exact encoded length or a codec write frame; the remaining survival
    leg is stated here as the exact boundary and stays with B1.08/09. -/

end FT1536.Source3.KeygenMakeSkeChain
